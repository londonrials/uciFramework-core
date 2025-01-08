--[[
  _    _  _____ _____   ______                                           _       _____               
 | |  | |/ ____|_   _| |  ____|                                         | |     / ____|              
 | |  | | |      | |   | |__ _ __ __ _ _ __ ___   _____      _____  _ __| | __ | |     ___  _ __ ___ 
 | |  | | |      | |   |  __| '__/ _` | '_ ` _ \ / _ \ \ /\ / / _ \| '__| |/ / | |    / _ \| '__/ _ \
 | |__| | |____ _| |_  | |  | | | (_| | | | | | |  __/\ V  V / (_) | |  |   <  | |___| (_) | | |  __/
  \____/ \_____|_____| |_|  |_|  \__,_|_| |_| |_|\___| \_/\_/ \___/|_|  |_|\_\  \_____\___/|_|  \___|
                                                                                                  
This the server side script for world restrictions to ensure a proper roleplay environment. Things like disabling the wanted level and default GTA medical response.
Make sure to restart the resource after making changes to this file to ensure the changes are live.
/stop uciFramework-core -> /start uciFramework-core

]]-------------------------------------------------------------------------------------------------------
-- Load configuration
local disableWeaponPickups = Config and Config.DisableWeaponPickups

if disableWeaponPickups then
    -- Listen for ped deaths to prevent weapon drops
    AddEventHandler('entityCreating', function(entity)
        if DoesEntityExist(entity) and GetEntityType(entity) == 1 then -- Check if it's a ped
            local ped = entity

            -- Use a short delay to ensure the ped is initialized
            Wait(500)

            if IsPedDeadOrDying(ped, true) then
                -- Clear weapons from the ped to prevent drops
                RemoveAllPedWeapons(ped, true)
            end
        end
    end)

    -- Catch weapon drop attempts
    AddEventHandler('giveWeaponEvent', function(playerId, data)
        CancelEvent() -- Prevent the weapon drop from happening
    end)
end
