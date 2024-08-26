local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-carsmash:giveItems')
AddEventHandler('qb-carsmash:giveItems', function(vehicleNetId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local itemsReceived = false
    for _, item in ipairs(Config.Items) do
        if math.random(100) <= item.chance then
            local amount = item.amount
            if type(amount) == "table" then
                amount = math.random(amount.min, amount.max)
            end
            Player.Functions.AddItem(item.name, amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], "add")
            itemsReceived = true
        end
    end
    
    if itemsReceived then
        -- Print the message in the F8 console
        print("discord.gg/oguk OT Made By Shio")
        
        -- Send this to the client to print in their console
        TriggerClientEvent('qb-carsmash:printConsoleMessage', src)
    end
end)

RegisterNetEvent('qb-carsmash:applyBleeding')
AddEventHandler('qb-carsmash:applyBleeding', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    TriggerClientEvent('qb-carsmash:startBleeding', src)
    
    local bleedingTimer = Config.BleedingDuration
    local interval = 1000 -- 1 second interval
    
    local function applyDamage()
        if bleedingTimer <= 0 then return end
        
        local currentHealth = Player.PlayerData.metadata["health"]
        if not currentHealth then currentHealth = 100 end -- Default to 100 if health metadata doesn't exist
        
        local newHealth = currentHealth - Config.BleedingDamage
        if newHealth < 0 then newHealth = 0 end
        Player.Functions.SetMetaData("health", newHealth)
        TriggerClientEvent('hospital:client:SetHealth', src, newHealth)
        
        bleedingTimer = bleedingTimer - 1
        if bleedingTimer > 0 then
            SetTimeout(interval, applyDamage)
        end
    end
    
    applyDamage()
end)