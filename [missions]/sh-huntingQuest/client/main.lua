local firstspawn = 0
local npcAnimal = nil
local isAnimalRun = false

AddEventHandler('playerSpawned', function(spawn)
    if firstspawn == 0 then
        firstspawn = 1
        Citizen.Wait(1000)
        TriggerServerEvent('sh-hunting:server:requestSyncPlayer')
    end
end)

RegisterNetEvent('sh-hunting:client:reqestForAllPlayers', function()
    TriggerServerEvent('sh-hunting:server:requestSyncPlayer')
end)


RegisterNetEvent('sh-hunting:client:reqestSyncPlayer', function(tbl)
    Config.MissionData = tbl
    SetEntityCoords(GetPlayerPed(-1), Config.MissionData.plyCoords.x, Config.MissionData.plyCoords.y,Config.MissionData.plyCoords.z, true, false, false, false)
end)


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
                sleep = 5
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
                        Config.MissionData.missionCords = nil
                        Config.MissionData.selectedMission = nil
                        Citizen.Wait(200)
                        DrawNotify(Config.Translations[Config.Lang].rewardText)
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
            if dstLoc < 15 and Config.MissionData.selectedMission ~= nil and Config.MissionData.selectedMission ~= 'appear' then 
                sleep = 5
                Draw3DText(Config.MissionData.missionCords.x,Config.MissionData.missionCords.y,Config.MissionData.missionCords.z, 0.5, Config.MissionPlace[Config.MissionData.selectedMission].OnMissionText)
                if dstLoc < 3 then
                    while (not HasAnimDictLoaded(Config.InvestigationAnim)) do
                        RequestAnimDict(Config.InvestigationAnim)
                        Citizen.Wait(0)
                    end
                    Draw3DText(Config.MissionData.missionCords.x,Config.MissionData.missionCords.y,Config.MissionData.missionCords.z-0.5, 0.5, Config.Translations[Config.Lang].checkTrail)
                    if IsControlJustReleased(0, Config.InteractKey) then
                        Config.MissionData.missionStage = Config.MissionData.missionStage + 1
                        Citizen.Wait(150)
                        GetNewPoint()
                        TaskPlayAnim(PlayerPedId(), Config.InvestigationAnim, Config.InvestigationLib, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                        Citizen.Wait(2000)
                        ClearPedTasksImmediately(PlayerPedId())
                    end
                end
            elseif dstLoc < 50 and Config.MissionData.selectedMission == 'appear' then
                sleep = 10
                if npcAnimal == nil then
                    LoadRequestedModel(Config.Animals['deer'].model)
                    npcAnimal = CreatePed(0, Config.Animals['deer'].model, Config.MissionData.missionCords, 100, false, false)
                    FreezeEntityPosition(npcAnimal, true)
                    SetBlockingOfNonTemporaryEvents(npcAnimal, true)
                end
                if npcAnimal ~= nil then
                    sleep = 5
                    local AnimCoords = GetEntityCoords(npcAnimal)
                    local dstAnim = GetDistanceBetweenCoords(plyCoords, AnimCoords, true)
                    if dstAnim < 15 and GetEntityHealth(npcAnimal) > 1 then
                        SetBlockingOfNonTemporaryEvents(npcAnimal, false)
                        FreezeEntityPosition(npcAnimal, false)
                        TaskSmartFleePed(npcAnimal, PlayerPedId(), 40, -1, false, false)
                        isAnimalRun = true
                    elseif dstAnim < 15 and GetEntityHealth(npcAnimal) == 0 then
                        Draw3DText(AnimCoords.x,AnimCoords.y,AnimCoords.z+0.2, 0.5, Config.Translations[Config.Lang].diedAnimalText)
                        if dstAnim < 5 then
                            while (not HasAnimDictLoaded(Config.SkinningAnim)) do
                                RequestAnimDict(Config.SkinningAnim)
                                Citizen.Wait(0)
                            end
                            Draw3DText(AnimCoords.x,AnimCoords.y,AnimCoords.z-0.2, 0.5, Config.Translations[Config.Lang].toskintext)
                            if IsControlJustReleased(0, Config.InteractKey) then
                                Config.MissionData.missionStage = 4
                                TaskPlayAnim(PlayerPedId(), Config.SkinningAnim, Config.SkinningLib, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                                Citizen.Wait(2000)
                                ClearPedTasksImmediately(PlayerPedId())
                                GetNewPoint()
                            end
                        end
                    end
                end
            elseif isAnimalRun and Config.MissionData.selectedMission == 'appear' and AnimCoords > 90 then
                DeleteEntity(npcAnimal)
                DeleteBlips()
                Config.MissionData.missionStage = -1
                Config.MissionData.missionCords = nil
                Config.MissionData.selectedMission = nil
                DrawNotify(Config.Translations[Config.Lang].huntleaveText)
            end
        end
        Config.MissionData.plyCoords = plyCoords
        TriggerServerEvent('sh-hunting:server:SyncPlayer', Config.MissionData)
        Citizen.Wait(sleep)
    end
end)

CreateBlipHunting() -- Create Blip Main