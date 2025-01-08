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

-- Loads config file
local disableWeaponPickups = Config and Config.DisableWeaponPickups

---------------------------------------------------------------------------------------------------------

-- Function to Disable Weapon Pickups
if disableWeaponPickups then
    CreateThread(function()
        while true do
            Wait(0) -- Loop continuously to monitor dropped weapons

            -- Iterate through all objects in the world
            for object in EnumerateObjects() do
                if IsWeaponPickup(object) then
                    -- Delete the weapon pickup
                    RemovePickup(object)
                end
            end
        end
    end)
end

-- Helper function to enumerate objects in the world
function EnumerateObjects()
    return coroutine.wrap(function()
        local handle, object = FindFirstObject()
        local success
        repeat
            coroutine.yield(object)
            success, object = FindNextObject(handle)
        until not success
        EndFindObject(handle)
    end)
end

-- Helper function to check if an object is a weapon pickup
function IsWeaponPickup(object)
    local model = GetEntityModel(object)
    return IsPickupWeapon(model)
end