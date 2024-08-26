local QBCore = exports['qb-core']:GetCoreObject()
local smashCooldowns = {}

function IsVehicleLocked(vehicle)
    return GetVehicleDoorLockStatus(vehicle) >= 2
end

RegisterNetEvent('qb-carsmash:smashWindow')
AddEventHandler('qb-carsmash:smashWindow', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = QBCore.Functions.GetClosestVehicle(coords)
    
    if not vehicle or #(coords - GetEntityCoords(vehicle)) > 3.0 then
        QBCore.Functions.Notify("No vehicle nearby", "error")
        return
    end
    
    local vehicleType = GetVehicleClass(vehicle)
    if tableContains(Config.BlacklistedVehicleTypes, vehicleType) then
        QBCore.Functions.Notify("You can't smash this type of vehicle", "error")
        return
    end
    
    if not IsVehicleLocked(vehicle) then
        QBCore.Functions.Notify("The vehicle is not locked", "error")
        return
    end
    
    local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
    if smashCooldowns[vehicleNetId] and smashCooldowns[vehicleNetId] > GetGameTimer() then
        QBCore.Functions.Notify("This vehicle was recently smashed", "error")
        return
    end
    
    local weapon = GetSelectedPedWeapon(playerPed)
    local isUsingHammer = GetHashKey("weapon_hammer") == weapon
    
    -- Animation for breaking the window
    RequestAnimDict("melee@large_wpn@streamed_core")
    while not HasAnimDictLoaded("melee@large_wpn@streamed_core") do
        Wait(100)
    end
    TaskPlayAnim(playerPed, "melee@large_wpn@streamed_core", "ground_attack_on_spot", 8.0, -8.0, -1, 0, 0, false, false, false)
    Wait(1000)
    
    -- Break the window
    SmashVehicleWindow(vehicle, 0) -- Driver's window
    
    if not isUsingHammer then
        TriggerServerEvent('qb-carsmash:applyBleeding')
    end
    
    -- Animation for reaching inside
    RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
    while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
        Wait(100)
    end
    TaskPlayAnim(playerPed, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8.0, -1, 0, 0, false, false, false)
    
    QBCore.Functions.Progressbar("reaching_inside", "Reaching inside...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(playerPed)
        TriggerServerEvent('qb-carsmash:giveItems', vehicleNetId)
        smashCooldowns[vehicleNetId] = GetGameTimer() + (Config.SmashCooldown * 1000)
    end)
end)

function tableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

RegisterCommand("smash", function()
    TriggerEvent('qb-carsmash:smashWindow')
end, false)

RegisterNetEvent('qb-carsmash:startBleeding')
AddEventHandler('qb-carsmash:startBleeding', function()
    local playerPed = PlayerPedId()
    
    -- Visual effect for bleeding
    SetEntityHealth(playerPed, GetEntityHealth(playerPed) - 1)
    
    -- Particle effects for blood
    local boneIndex = GetPedBoneIndex(playerPed, 18905) -- Right hand
    local coords = GetPedBoneCoords(playerPed, boneIndex)
    
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do
        Wait(10)
    end
    
    UseParticleFxAssetNextCall("core")
    local particle = StartParticleFxLoopedOnEntityBone("blood_stab", playerPed, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, boneIndex, 0.5, false, false, false)
    
    QBCore.Functions.Notify("You've cut yourself on the glass!", "error")
    
    -- Stop the particle effect after 10 seconds
    SetTimeout(10000, function()
        StopParticleFxLooped(particle, false)
    end)
end)


RegisterNetEvent('qb-carsmash:printConsoleMessage')
AddEventHandler('qb-carsmash:printConsoleMessage', function()
    -- This will print the message in the client's F8 console
    Citizen.Trace("discord.gg/oguk OT Made By Shio\n")
end)