Config = {}

Config.Debug = true
Config.Item = "newplate"
Config.CheckDistance = 4.0

Config.Discord = {
    enabled = true,
    webhookUrl = "https://discord.com/api/webhooks/1304504948087717978/x6g17c_9H2secYXTWz7VlYLtWXG5zi5-dc058ZF1rD4HYrej9rfo6FN0m8w8ehHxxDvt",
    botName = "Custom Plates Logger",
    color = 3447003,  -- Blue color in decimal
}

Config.Notify = {
    noVehicle = {
        type = 'error',
        title = 'Error',
        description = 'No vehicle nearby!',
        position = 'top-right',
        duration = 3000
    },
    tooFar = {
        type = 'error',
        title = 'Error',
        description = 'Vehicle is too far away!',
        position = 'top-right',
        duration = 3000
    },
    notOwned = {
        type = 'error',
        title = 'Error',
        description = 'You don\'t own this vehicle!',
        position = 'top-right',
        duration = 3000
    },
    success = {
        type = 'success',
        title = 'Success',
        description = 'License plate changed successfully!',
        position = 'top-right',
        duration = 3000
    },
    failed = {
        type = 'error',
        title = 'Error',
        description = 'Failed to change license plate!',
        position = 'top-right',
        duration = 3000
    }
}