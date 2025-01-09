--[[
  _    _  _____ _____   ______                                           _       _____               
 | |  | |/ ____|_   _| |  ____|                                         | |     / ____|              
 | |  | | |      | |   | |__ _ __ __ _ _ __ ___   _____      _____  _ __| | __ | |     ___  _ __ ___ 
 | |  | | |      | |   |  __| '__/ _` | '_ ` _ \ / _ \ \ /\ / / _ \| '__| |/ / | |    / _ \| '__/ _ \
 | |__| | |____ _| |_  | |  | | | (_| | | | | | |  __/\ V  V / (_) | |  |   <  | |___| (_) | | |  __/
  \____/ \_____|_____| |_|  |_|  \__,_|_| |_| |_|\___| \_/\_/ \___/|_|  |_|\_\  \_____\___/|_|  \___|
                                                                                                  
This the configuration file for UCI Framework Core. Each section represents different part of this resource along with help tips to assist in understanding the different settings.
Make sure to restart the resource after making changes to this file to ensure the changes are live.
/stop uciFramework-core -> /start uciFramework-core

]]-------------------------------------------------------------------------------------------------------

Config = {}

------ World Restrictions

-- [Default = true] Set to false to enable weapon pickups.
Config.DisableWeaponPickups = true

-- [Default = true] Set to false to enable the wanted system.
Config.DisableWantedSystem = true

-- [Default = true] Set to false to enable the spawn of police offcers and police vehicles.
Config.DisablePoliceSpawning = true

-- [Default = true] Set to false to enable the spawn of medical personnel and medical vehicles.
Config.DisableEmsSpawning = true

------ Player Restrictions

-- [Default = true] Set to false to enable the ability for players to double jump.
Config.EnableDoubleJumpNerf = true

-- [Default = 2.0] Set the amount of seconds between jumps before the second jump is considered "too soon".
Config.DoubleJumpTimeoutSeconds = 2.0

------ Player Movement

-- [Default = 73 & 29] Set the primary & secondary keybinds for the 'Hands Up' action.
Config.DefaultPrimaryKey = 73
Config.DefaultSecondaryKey = 29

-- [Default = 0.5] Set the animation that plays for the 'Hands Up' action.
Config.AnimationToPlay = "mp_arresting@idle"

