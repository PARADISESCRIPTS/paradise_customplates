local QBCore = exports['qb-core']:GetCoreObject()

local function GetClosestVehicle(coords)
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = nil
    
    for _, vehicle in ipairs(vehicles) do
        local vehCoords = GetEntityCoords(vehicle)
        local distance = #(coords - vehCoords)
        
        if closestDistance == -1 or closestDistance > distance then
            closestDistance = distance
            closestVehicle = vehicle
        end
    end
    
    return closestVehicle, closestDistance
end

local function PlayClipboardAnim()
    local ped = PlayerPedId()
    local animDict = "missfam4"
    local animName = "base"
    local prop = CreateObject(`p_amb_clipboard_01`, 0, 0, 0, true, true, true)
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end
    AttachEntityToEntity(
        prop,
        ped,
        GetPedBoneIndex(ped, 36029),
        0.16, 0.08, 0.10,
        -130.0, -50.0, 0.0,
        true, true, false, true, 1, true
    )
    
    TaskPlayAnim(ped, animDict, animName, 2.0, 2.0, -1, 49, 0, false, false, false)
    return prop
end

local function StopClipboardAnim(prop)
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    DeleteEntity(prop)
end

RegisterNetEvent('paradise_customplate:useItem')
AddEventHandler('paradise_customplate:useItem', function()
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    
    local vehicle, distance = GetClosestVehicle(coords)
    
    if not vehicle then
        lib.notify(Config.Notify.noVehicle)
        return
    end
    
    if distance > Config.CheckDistance then
        lib.notify(Config.Notify.tooFar)
        return
    end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    local clipboardProp = PlayClipboardAnim()
    
    lib.callback('paradise_customplate:checkVehicleOwner', false, function(isOwner)
        if not isOwner then
            StopClipboardAnim(clipboardProp)
            lib.notify(Config.Notify.notOwned)
            return
        end
        
        local input = lib.inputDialog('Custom Plate', {
            {
                type = 'input',
                label = 'New Plate Text',
                description = 'Enter the new license plate text (max 8 characters)',
                required = true,
                placeholder = 'ABC 123',
                min = 1,
                max = 8
            }
        })
        
        StopClipboardAnim(clipboardProp)
        
        if not input then return end
        local newPlate = string.upper(input[1])
        
        if not newPlate or newPlate == '' then
            lib.notify(Config.Notify.failed)
            return
        end
        
        if lib.progressBar({
            duration = 5000,
            label = 'Changing License Plate...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped'
            },
        }) then
            TriggerServerEvent('paradise_customplate:changePlate', VehToNet(vehicle), newPlate, plate)
        end
    end, plate)
end)