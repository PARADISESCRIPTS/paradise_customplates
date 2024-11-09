local QBCore = exports['qb-core']:GetCoreObject()

local function SendDiscordLog(player, oldPlate, newPlate)
    if not Config.Discord.enabled then return end
    
    local embed = {
        {
            ["color"] = Config.Discord.color,
            ["title"] = "License Plate Changed",
            ["description"] = "A player has changed their vehicle's license plate",
            ["fields"] = {
                {
                    ["name"] = "Player",
                    ["value"] = string.format("%s (ID: %s)", player.PlayerData.name, player.PlayerData.source),
                    ["inline"] = true
                },
                {
                    ["name"] = "Old Plate",
                    ["value"] = oldPlate,
                    ["inline"] = true
                },
                {
                    ["name"] = "New Plate",
                    ["value"] = newPlate,
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S")
            }
        }
    }

    PerformHttpRequest(Config.Discord.webhookUrl, function(err, text, headers) end, 'POST', json.encode({
        username = Config.Discord.botName,
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

local function GiveVehicleKeys(source, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    TriggerEvent('qb-vehiclekeys:server:RemoveKey', plate, Player.PlayerData.citizenid)
    
    TriggerEvent('qb-vehiclekeys:server:GiveVehicleKeys', plate, Player.PlayerData.citizenid)
    
    TriggerClientEvent('qb-vehiclekeys:client:AddKeys', source, plate)
end

lib.callback.register('paradise_customplate:checkVehicleOwner', function(source, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    
    local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?', {
        plate,
        Player.PlayerData.citizenid
    })
    
    return result and #result > 0
end)

local function CheckPlateExists(plate)
    local result = MySQL.query.await('SELECT 1 FROM player_vehicles WHERE plate = ?', {plate})
    return result and #result > 0
end

RegisterNetEvent('paradise_customplate:changePlate')
AddEventHandler('paradise_customplate:changePlate', function(netId, newPlate, oldPlate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    
    if not Player or not vehicle then return end
    
    if CheckPlateExists(newPlate) then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = 'This plate number is already registered',
            type = 'error'
        })
        return
    end
    
    MySQL.update('UPDATE player_vehicles SET plate = ? WHERE plate = ? AND citizenid = ?', {
        newPlate,
        oldPlate,
        Player.PlayerData.citizenid
    }, function(affected)
        if affected > 0 then
            Player.Functions.RemoveItem(Config.Item, 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Item], "remove")
            
            SetVehicleNumberPlateText(vehicle, newPlate)
            
            GiveVehicleKeys(src, newPlate)
            
            SendDiscordLog(Player, oldPlate, newPlate)
            
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Success',
                description = 'Plate changed and new keys received',
                type = 'success'
            })

            TriggerClientEvent('paradise_customplate:syncVehicle', -1, netId, newPlate)
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Error',
                description = 'Failed to change plate',
                type = 'error'
            })
        end
    end)
end)

QBCore.Functions.CreateUseableItem(Config.Item, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    TriggerClientEvent("paradise_customplate:useItem", src)
end)

RegisterNetEvent('paradise_customplate:syncVehicle')
AddEventHandler('paradise_customplate:syncVehicle', function(netId, newPlate)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(vehicle) then
        SetVehicleNumberPlateText(vehicle, newPlate)
    end
end)