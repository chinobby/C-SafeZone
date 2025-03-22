local safeZones = Config.SafeZones
local antiVDM = Config.AntiVDM
local wasInSafeZone = false

function ShowNotification(text)
    ESX.ShowNotification(text)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local inSafeZone = false

        for _, zone in ipairs(safeZones) do
            local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, zone.x, zone.y, zone.z)
            if distance < zone.radius then
                inSafeZone = true
                break
            end
        end

        if inSafeZone and not wasInSafeZone then
            wasInSafeZone = true
            ShowNotification('Has entrado en la Zona Segura')
        elseif not inSafeZone and wasInSafeZone then
            wasInSafeZone = false
            ShowNotification('Has salido de la Zona Segura')
        end

        if inSafeZone then
            DisablePlayerFiring(playerPed, true)
            SetEntityInvincible(playerPed, true)
            ClearPlayerWantedLevel(PlayerId())
            if antiVDM then
                SetEntityCanBeDamaged(playerPed, false)
                SetEntityProofs(playerPed, true, true, true, true, true, true, true, true)
            end
        else
            DisablePlayerFiring(playerPed, false)
            SetEntityInvincible(playerPed, false)
            if antiVDM then
                SetEntityCanBeDamaged(playerPed, true)
                SetEntityProofs(playerPed, false, false, false, false, false, false, false, false)
            end
        end
    end
end)
