local Config = require 'config.client'
local check = false
local DisableCrosshair = Config.DisableCrosshair


-- Handling for First Person Weapon (when equipped)
local function WeaponHandling()
    local playerFreeAiming = IsPlayerFreeAiming(cache.playerId)
    local whitelistguns = nil

            if DisableCrosshair then
                for i = 1, #Config.WhitelistedGuns do
                    if GetHashKey(Config.WhitelistedGuns[i]) == cache.weapon then
                        whitelistguns = Config.WhitelistedGuns[i]
                    end
                end
            end

            if whitelistguns then
                if playerFreeAiming then
                    EnableCrosshairThisFrame()
                    sleep = 1000
                    return sleep
                else
                    DisablePlayerFiring(cache.playerId, true)
                    return
                end
            end
            
            if playerFreeAiming or IsControlPressed(0, 25) then
                sleep = 1000
                check = true
                SetFollowPedCamViewMode(4)
                return sleep, check
            else
                DisablePlayerFiring(cache.playerId, true)
                SetFollowPedCamViewMode(1)
                check = false
                return check
            end               
end

-- Handling for First Person Fist Fight (when player uses fists to attack)
local fistcheck = false
local function FistFightHandling()
if not Config.FirstPersonFistFight then return end

    
    if IsControlPressed(0, 25) then 
        SetFollowPedCamViewMode(4)

    else
        DisableControlAction(0, 140, true) 
        DisableControlAction(0, 24, true) 
    end

    if IsControlJustReleased(0, 25) then
        SetFollowPedCamViewMode(1)
    end     
    
end


CreateThread(function()
    while true do
        SetBlackout(false)
        local sleep = 0
        if cache.weapon then
            WeaponHandling()

            CreateThread(function()
                while check and DisableCrosshair do
                    HideHudComponentThisFrame(14)
                    Wait(1)
                end
            end)
        else
            FistFightHandling()
        end
        Wait(sleep)
    end
end)