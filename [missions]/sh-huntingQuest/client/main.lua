

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

        Config.MissionData.plyCoords = plyCoords
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 5000
        Citizen.Wait(sleep)
    end
end)