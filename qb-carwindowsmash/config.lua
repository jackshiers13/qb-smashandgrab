-- config.lua

Config = {}

Config.Items = {
    {name = "classic_phone", label = "Phone", chance = 10},
    {name = "vape", label = "Vape", chance = 15},
    {name = "rolex", label = "Rolex", chance = 5},
    {name = "water", label = "Water", chance = 50},
    {name = "advancedlockpick", label = "Lockpick", chance = 5},

}

Config.BleedingDamage = 1 -- Damage per second
Config.BleedingDuration = 10 -- Duration in seconds

Config.RequiredWeapon = `WEAPON_HAMMER`

Config.SmashCooldown = 30 -- 5 minutes cooldown
Config.BleedingDuration = 10 -- 10 seconds of bleeding
Config.BleedingDamage = 5 -- 5 HP damage per second

Config.BlacklistedVehicleTypes = {
    8, -- Motorcycles
    13, -- Cycles
    14, -- Boats
    15, -- Helicopters
    16, -- Planes
    21 -- Trains
}