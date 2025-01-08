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
local disableWeaponPickups = Config and Config.DisableWeaponPickups

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