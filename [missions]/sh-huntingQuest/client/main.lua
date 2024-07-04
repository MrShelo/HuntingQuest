

local huntingZone = PolyZone:Create(Config.HuntingZone, {
    name="huntingZone",
    --minZ = 10.314173698425,
    --maxZ = 106.15273284912
  })

huntingZone:onPlayerInOut(function(isPointInside)
    if isPointInside and Config.MissionData.missionStage > -1 then
        GiveWeaponToPed(PlayerPedId(), Config.WeaponHash, 100)
    else
        RemoveWeaponFromPed(PlayerPedId(), Config.WeaponHash)
    end
end)

Citizen.CreateThread(function()
    CreateNPC(Config.PedModel, Config.MissionPlace['npc'].coords - vector4(0,0,0.95,0), Config.MissionPlace['npc'].coords.w)
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 5000
        local plyCoords = GetEntityCoords(PlayerPedId())
        local dstLoc = GetDistanceBetweenCoords(plyCoords, Config.MissionPlace['npc'].coords, true)
        
        if dstLoc < 15 then
            sleep = 500
            if dstLoc < Config.MissionPlace['npc'].InteractDistanceNPC then
                sleep = 7
                if Config.MissionData.missionStage == -1 then
                    Draw3DText(Config.MissionPlace['npc'].coords.x,Config.MissionPlace['npc'].coords.y,Config.MissionPlace['npc'].coords.z + 0.95, 0.3, Config.MissionPlace['npc'].GetMissionText)
                    if IsControlJustReleased(0, Config.InteractKey) then
                        Config.MissionData.missionStage = 0
                        SpawnNetworkVehicle(Config.JobVeh, Config.SpawnJobVehicle)
                        GetNewPoint()
                    end
                elseif Config.MissionData.missionStage >= 0 and Config.MissionData.missionStage < 4 then
                    Draw3DText(Config.MissionPlace['npc'].coords.x,Config.MissionPlace['npc'].coords.y,Config.MissionPlace['npc'].coords.z + 0.95, 0.3, Config.MissionPlace['npc'].OnMissionText)
                elseif Config.MissionData.missionStage == 4 then
                    Draw3DText(Config.MissionPlace['npc'].coords.x,Config.MissionPlace['npc'].coords.y,Config.MissionPlace['npc'].coords.z + 0.95, 0.3, Config.MissionPlace['npc'].AfterMissionText)   
                    if IsControlJustReleased(0, Config.InteractKey) then
                        Config.MissionData.missionStage = 0
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 5000
        local plyCoords = GetEntityCoords(PlayerPedId())
        if Config.MissionData.missionCords ~= nil then
            local dstLoc = GetDistanceBetweenCoords(plyCoords, Config.MissionData.missionCords, true)
            if dstLoc < 15 and Config.MissionData.selectedMission ~= nil and not Config.MissionData.selectedMission == 'appear' then 
                sleep = 5
                Draw3DText(Config.MissionData.missionCords.x,Config.MissionData.missionCords.y,Config.MissionData.missionCords.z, 0.5, Config.MissionPlace[Config.MissionData.selectedMission].OnMissionText)
                if dstLoc < 3 then
                    while (not HasAnimDictLoaded(Config.InvestigationAnim)) do
                        RequestAnimDict(Config.InvestigationAnim)
                        Citizen.Wait(0)
                    end
                    Draw3DText(Config.MissionData.missionCords.x,Config.MissionData.missionCords.y,Config.MissionData.missionCords.z-0.5, 0.5, Config.Translations[Config.Lang].checkTrail)
                    if IsControlJustReleased(0, Config.InteractKey) then
                        TaskPlayAnim(PlayerPedId(), Config.InvestigationAnim, Config.InvestigationLib, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                        Citizen.Wait(2000)
                        ClearPedTasksImmediately(PlayerPedId())
                        Config.MissionData.missionStage = Config.MissionData.missionStage + 1
                        Citizen.Wait(50)
                        GetNewPoint()
                    end
                end
            end
        end
        Config.MissionData.plyCoords = plyCoords
        Citizen.Wait(sleep)
    end
end)