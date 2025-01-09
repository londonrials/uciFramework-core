--[[
  _    _  _____ _____   ______                                           _       _____               
 | |  | |/ ____|_   _| |  ____|                                         | |     / ____|              
 | |  | | |      | |   | |__ _ __ __ _ _ __ ___   _____      _____  _ __| | __ | |     ___  _ __ ___ 
 | |  | | |      | |   |  __| '__/ _` | '_ ` _ \ / _ \ \ /\ / / _ \| '__| |/ / | |    / _ \| '__/ _ \
 | |__| | |____ _| |_  | |  | | | (_| | | | | | |  __/\ V  V / (_) | |  |   <  | |___| (_) | | |  __/
  \____/ \_____|_____| |_|  |_|  \__,_|_| |_| |_|\___| \_/\_/ \___/|_|  |_|\_\  \_____\___/|_|  \___|
                                                                                                  
This the client side script for world restrictions to ensure a proper roleplay environment. Things like disabling the wanted level and default GTA medical response.
Make sure to restart the resource after making changes to this file to ensure the changes are live.
/stop uciFramework-core -> /start uciFramework-core

]]-------------------------------------------------------------------------------------------------------
 
-- Load configuration
local disableWeaponPickups = Config and Config.DisableWeaponPickups
local disableWantedSystem = Config and Config.DisableWantedSystem
local disablePoliceSpawning = Config and Config.DisablePoliceSpawning
local disableEmsSpawning = Config and Config.DisableEmsSpawning
local enableDoubleJumpNerf = Config and Config.EnableDoubleJumpNerf
local doubleJumpTimeoutSeconds = Config and Config.DoubleJumpTimeoutSeconds

if disableWeaponPickups then
    CreateThread(function()
        while true do
            Wait(0)

            -- Check for all nearby ped deaths
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local nearbyPeds = GetNearbyPeds(coords.x, coords.y, coords.z, 50.0) -- Adjust range as needed

            for _, ped in ipairs(nearbyPeds) do
                if IsPedDeadOrDying(ped, true) then
                    -- Remove all weapons to prevent drop
                    RemoveAllPedWeapons(ped, true)
                end
            end
        end
    end)
end

-- Helper function to get nearby peds
function GetNearbyPeds(x, y, z, radius)
    local peds = {}
    local handle, ped = FindFirstPed()
    local success
    repeat
        local pedCoords = GetEntityCoords(ped)
        if #(vector3(x, y, z) - pedCoords) <= radius then
            table.insert(peds, ped)
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return peds
end

if disableWantedSystem then
    CreateThread(function()
        -- Get the current player ID.
        local playerId = PlayerId()

        -- Prevent the wanted level from ever increasing above 0.
        SetMaxWantedLevel(0)

        -- Disable police dispatches for the player.
        SetPoliceIgnorePlayer(playerId, true)
        SetDispatchCopsForPlayer(playerId, false)

        -- Continuous loop to ensure the player remains wanted-level free.
        while true do
            Wait(1)

            -- If, for any reason, the player’s wanted level goes above 0, clear it.
            if GetPlayerWantedLevel(playerId) > 0 then
                ClearPlayerWantedLevel(playerId)
                SetPlayerWantedLevelNow(playerId, false)
            end
        end
    end)
end

-- Disable random cop peds & police vehicles if configured 
if disablePoliceSpawning then 
    CreateThread(function()
        -- Turn off standard random cop scenarios 
        SetCreateRandomCops(false) 
        SetCreateRandomCopsNotOnScenarios(false) 
        SetCreateRandomCopsOnScenarios(false)

        -- Suppress known police vehicle models
        local suppressedModels = {
            GetHashKey("police"),
            GetHashKey("police2"),
            GetHashKey("police3"),
            GetHashKey("police4"),
            GetHashKey("fbi"),
            GetHashKey("fbi2"),
            GetHashKey("sheriff"),
            GetHashKey("sheriff2"),
            GetHashKey("policet"),
            GetHashKey("riot"),
            GetHashKey("policeb")
            -- Add more if needed
        }

        for _, model in ipairs(suppressedModels) do
            SetVehicleModelIsSuppressed(model, true)
        end

        -- Periodically ensure random cops are disabled
        while true do
            Wait(10000)
            SetCreateRandomCops(false)
            SetCreateRandomCopsNotOnScenarios(false)
            SetCreateRandomCopsOnScenarios(false)
        end
    end)
end

-- Disable random EMS peds & their vehicles if configured
    if disableEmsSpawning then CreateThread(function() -- Disable the "Ambulance" dispatch service (service ID 5) EnableDispatchService(5, false)

        -- Optionally disable "Fire Dept" dispatch service (service ID 3) if you wish
        EnableDispatchService(3, false)

        -- Suppress paramedic ped models
        local suppressedEmsPeds = {
            GetHashKey("S_M_M_Paramedic_01")  -- Example paramedic ped model
            -- Add more if needed
        }

        -- Suppress EMS/ambulance vehicle models
        local suppressedEmsVehicles = {
            GetHashKey("ambulance"),
            GetHashKey("firetruk") -- Some servers block firetruk if misused
            -- Add more if needed
        }

        for _, pedModel in ipairs(suppressedEmsPeds) do
            SetPedModelIsSuppressed(pedModel, true)
        end

        for _, vehModel in ipairs(suppressedEmsVehicles) do
            SetVehicleModelIsSuppressed(vehModel, true)
        end

        while true do
            -- Re-apply settings periodically in case other game scripts re-enable them
            Wait(1000)  -- 1-second interval; adjust if needed
            
            EnableDispatchService(5, false)
            -- EnableDispatchService(3, false)  -- If you also need fires disabled

            for _, pedModel in ipairs(suppressedEmsPeds) do
                SetPedModelIsSuppressed(pedModel, true)
            end

            for _, vehModel in ipairs(suppressedEmsVehicles) do
                SetVehicleModelIsSuppressed(vehModel, true)
            end
        end
    end)
end

if enableDoubleJumpNerf then 
    CreateThread(function() local jumpControl = 22 -- Default jump control is key code 22 (spacebar) 
        local lastJumpTime = 0 -- Tracks the timestamp of the most recent jump
        while true do
                Wait(0)
                -- Check if the jump key was just pressed
                if IsControlJustPressed(0, jumpControl) then
                    local now = GetGameTimer()
                    -- If the time since last jump is less than or equal to our timeout (in ms), ragdoll the player
                    if (now - lastJumpTime) <= (doubleJumpTimeoutSeconds * 1000) then
                        SetPedToRagdoll(PlayerPedId(), 2000, 2000, 0, false, false, false)
                    end
                    -- Update jump time
                    lastJumpTime = now
                end
            end
    end)
end