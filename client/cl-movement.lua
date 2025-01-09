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

local animDict = animInfo.dict or "mp_am_hold_up" local animClip = animInfo.name or "handsup_base"

-- Track whether the player currently has “hands up” active 
local handsUpActive = false

RegisterCommand("handsup", function() ToggleHandsUp() end, false)
RegisterKeyMapping("handsup", "Put your hands up", "keyboard", primaryKey)
RegisterKeyMapping("~!handsup", "Put your hands up", "keyboard", "B")

-- This function toggles the “hands up” animation on or off function 
ToggleHandsUp() local ped = PlayerPedId() 
    if IsEntityDead(ped) then 
        return 
     end
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
    end
    
    if handsUpActive then
        -- If already active, clear tasks and reset
        ClearPedTasksImmediately(ped)
        handsUpActive = false
    else
        -- Otherwise play the anim indefinitely (loop)
        TaskPlayAnim(
            ped,
            animDict,
            animClip,
            8.0,   -- speed
            8.0,   -- speed multiplier
            -1,    -- duration (-1 = infinite)
            49,    -- flags (e.g., 49 = repeat/loop in place)
            0,     -- playbackRate
            false, -- lockX
            false, -- lockY
            false  -- lockZ
        )
        handsUpActive = true
    end