local config = require 'config.client'
local check = false
local disableCrosshair = config.disableCrosshair


-- Handeling firsperson when use equepped a weapon 
-- Added Whitelistguns for sniper scopes
local function handelingweapon()
    local playerFreeAiming = IsPlayerFreeAiming(cache.playerId)
    local whitelistguns = nil

            if disableCrosshair then
                for i = 1, #config.whitelistguns do
                    if GetHashKey(config.whitelistguns[i]) == cache.weapon then
                        whitelistguns = config.whitelistguns[i]
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

-- Handeling for firsperson when players uses fists
local function handelingfistfight()
if not config.firspersonfistfight then return end

        DisableControlAction(0, 140, true) 
        DisableControlAction(0, 24, true) 

        if IsControlPressed(0, 25) then
            SetFollowPedCamViewMode(4)
            DisableControlAction(0, 140, false) 
            DisableControlAction(0, 24, false) 
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
            handelingweapon()

            CreateThread(function()
                while check and disableCrosshair do
                    HideHudComponentThisFrame(14)
                    Wait(1)
                end
            end)
        else
            handelingfistfight()
        end
        Wait(sleep)
    end
end)