
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

function CreateAnimalAI(model, coords, heading)
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

function GetNewPoint()
    print(Config.MissionData.missionStage)
    if Config.MissionData.missionStage == 0 then
        local tblLengh = #Config.MissionPlace['sttrail'].group
        local selectedNumber = math.random(1, tblLengh)
        
        for idx, val in ipairs(Config.MissionPlace['sttrail'].group) do
            if idx == selectedNumber then
                Config.MissionData.missionCords = val
                Config.MissionData.selectedMission = 'sttrail'
                DeleteBlips()
                CreateBlip(Config.MissionData.selectedMission)
                break
            end
        end

    elseif Config.MissionData.missionStage == 1 then
        local tblLengh = #Config.MissionPlace['ndtrail'].group
        local selectedNumber = math.random(0, tblLengh-1)

        for idx, val in ipairs(Config.MissionPlace['ndtrail'].group) do
            if idx == selectedNumber then
                Config.MissionData.missionCords = val
                Config.MissionData.selectedMission = 'ndtrail'
                DeleteBlips()
                CreateBlip(Config.MissionData.selectedMission)
                break
            end
        end

    elseif Config.MissionData.missionStage == 2 then
        local tblLengh = #Config.MissionPlace['rdtrail'].group
        local selectedNumber = math.random(0, tblLengh-1)

        for idx, val in ipairs(Config.MissionPlace['rdtrail'].group) do
            if idx == selectedNumber then
                Config.MissionData.missionCords = val
                Config.MissionData.selectedMission = 'rdtrail'
                DeleteBlips()
                CreateBlip(Config.MissionData.selectedMission)
                break
            end
        end
    
    elseif Config.MissionData.missionStage == 3 then
        local tblLengh = #Config.MissionPlace['appear'].group
        local selectedNumber = math.random(0, tblLengh-1)

        for idx, val in ipairs(Config.MissionPlace['appear'].group) do
            if idx == selectedNumber then
                Config.MissionData.missionCords = val
                Config.MissionData.selectedMission = 'appear'
                DeleteBlips()
                CreateBlip(Config.MissionData.selectedMission)
                break
            end
        end

    end
end

function CreateBlip(key)
        Config.MissionPlace[key].blip = AddBlipForCoord(Config.MissionData.missionCords.x, Config.MissionData.missionCords.y, Config.MissionData.missionCords.z)
        SetBlipSprite(Config.MissionPlace[key].blip, 66)
        SetBlipDisplay(Config.MissionPlace[key].blip, 4)
        SetBlipScale(Config.MissionPlace[key].blip, 0.7)
        SetBlipAsShortRange(Config.MissionPlace[key].blip, true)
        SetBlipColour(Config.MissionPlace[key].blip, 6)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.Translations[Config.Lang].trailBlip)
        EndTextCommandSetBlipName(Config.MissionPlace[key].blip)
        SetBlipRoute(Config.MissionPlace[key].blip, true)
end

function DeleteBlips()
    for k, v in pairs(Config.MissionPlace) do
        RemoveBlip(Config.MissionPlace[k].blip)
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
