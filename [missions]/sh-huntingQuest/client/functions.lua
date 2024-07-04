
function LoadRequestedModel(model)
    if HasModelLoaded(model) then return end
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Citizen.Wait(10)
    end
end

function CreateNPC(model, coords, heading)
    LoadRequestedModel(model)
    local npc = CreatePed(0, model, coords, heading, false, false)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    table.insert(Config.SpawnedPeds, npc)
end


function SpawnNetworkVehicle(model, coords)
    if model ~= nil then
        LoadRequestedModel(model)
        if coords ~= nil then
            local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, false)
            local netid = NetworkGetNetworkIdFromEntity(veh)
            SetNetworkIdCanMigrate(netid, true)
            SetVehicleNeedsToBeHotwired(veh, false)
            SetVehRadioStation(veh, 'OFF')
            SetVehicleFuelLevel(veh, 100.0)
            if coords.w ~= nil then
                SetEntityHeading(veh, coords.w)
            end
        end
    end
end

function Draw3DText(x, y, z, scl_factor, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl_factor
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end