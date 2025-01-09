--[[
  _    _  _____ _____   ______                                           _       _____               
 | |  | |/ ____|_   _| |  ____|                                         | |     / ____|              
 | |  | | |      | |   | |__ _ __ __ _ _ __ ___   _____      _____  _ __| | __ | |     ___  _ __ ___ 
 | |  | | |      | |   |  __| '__/ _` | '_ ` _ \ / _ \ \ /\ / / _ \| '__| |/ / | |    / _ \| '__/ _ \
 | |__| | |____ _| |_  | |  | | | (_| | | | | | |  __/\ V  V / (_) | |  |   <  | |___| (_) | | |  __/
  \____/ \_____|_____| |_|  |_|  \__,_|_| |_| |_|\___| \_/\_/ \___/|_|  |_|\_\  \_____\___/|_|  \___|
                                                                                                  
This the client side script for improving player movement to be more real.
Make sure to restart the resource after making changes to this file to ensure the changes are live.
/stop uciFramework-core -> /start uciFramework-core

]]-------------------------------------------------------------------------------------------------------

-- Variables
local isHandsUp = false

-- Function to toggle hands-up animation
function toggleHandsUp(state)
    local playerPed = PlayerPedId()

    if state and not isHandsUp then
        -- Start the hands-up animation
        RequestAnimDict(Config.HandsUpAnimation.dict)
        while not HasAnimDictLoaded(Config.HandsUpAnimation.dict) do
            Wait(0)
        end

        TaskPlayAnim(playerPed, Config.HandsUpAnimation.dict, Config.HandsUpAnimation.name, 3.0, -8.0, -1, 49, 0, false, false, false)
        isHandsUp = true
    elseif not state and isHandsUp then
        -- Stop the hands-up animation
        ClearPedTasks(playerPed)
        isHandsUp = false
    end
end

-- Main thread to check for key press and release
CreateThread(function()
    while true do
        Wait(0)

        local isKeyPressed = IsControlPressed(0, Config.HandsUpKeybind)

        if isKeyPressed then
            toggleHandsUp(true)
        else
            toggleHandsUp(false)
        end
    end
end)