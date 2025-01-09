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

-- Load configuration 
local primaryKey = Config and Config.DefaultPrimaryKey or 73 
local secondaryKey = Config and Config.DefaultSecondaryKey or 29 
local animInfo = Config and Config.AnimationToPlay or {} -- Optional: Provide fallback dictionary/clip in case config is missing or incomplete 

local animDict = animInfo.dict or "missminuteman_1ig_2" local animClip = animInfo.name or "handsup_base"

-- Create a separate thread that listens for the configured keys, then plays the specified animation 
CreateThread(function() 
    -- If we want to make sure the dictionary is loaded once up front, we can. 
    if not HasAnimDictLoaded(animDict) then 
        RequestAnimDict(animDict) while not HasAnimDictLoaded(animDict) do 
            Wait(0) 
        end 
    end
    while true do
        Wait(0)
        -- Check if our primary or secondary key was just pressed
        if IsControlJustPressed(0, primaryKey) or IsControlJustPressed(0, secondaryKey) then
            local ped = PlayerPedId()
            if not IsEntityDead(ped) then
                
                -- Re-request anim in case it was purged
                if not HasAnimDictLoaded(animDict) then
                    RequestAnimDict(animDict)
                    while not HasAnimDictLoaded(animDict) do
                        Wait(0)
                    end
                end
                -- Play the animation once
                TaskPlayAnim(
                    ped,
                    animDict,
                    animClip,
                    8.0,  -- speed
                    1.0,  -- speed multiplier
                    -1,   -- duration (-1 for infinite)
                    0,    -- flags (0 = normal)
                    0,    -- playback rate
                    false,
                    false,
                    false
                )
            end
        end
    end
end)           