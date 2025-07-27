local QBCore = exports['qb-core']:GetCoreObject()
local inZone = false

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function OpenApplicationUI()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "open",
        questions = Config.Questions,
        locale = {
            title = Config.Locale.form_title,
            submit = Config.Locale.submit_button,
            cancel = Config.Locale.cancel_button
        }
    })
    TriggerServerEvent('police:playerEnteredZone')
end

Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local currentZone = nil
        local wait = 1000

        for _, location in ipairs(Config.Locations) do
            local dist = #(playerCoords - vec3(location.x, location.y, location.z))
            if dist < 10.0 then
                wait = 200
                if dist < 2.0 then
                    wait = 5
                    currentZone = location
                    break
                end
            end
        end

        inZone = (currentZone ~= nil)

        if inZone then
            DrawText3D(currentZone.x, currentZone.y, currentZone.z + 1.0, Config.Locale.interact_prompt)
            if IsControlJustReleased(0, 38) then
                OpenApplicationUI()
            end
        end

        Citizen.Wait(wait)
    end
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('submit', function(data, cb)
    TriggerServerEvent('police:submitApplication', data)
    cb('ok')
end)

RegisterNetEvent('police:applicationResult', function(success, message)
    local notifyMessage = message or (success and Config.Locale.success_notification or Config.Locale.failure_notification)
    
    QBCore.Functions.Notify(notifyMessage, success and "success" or "error")

    SendNUIMessage({
        type = "submissionResult",
        success = success
    })
    
    if not success then
        SetNuiFocus(false, false)
    end
end)