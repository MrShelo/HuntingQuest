local playersTable = {}

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    QuerryOnStart()
    Citizen.Wait(50)
    TriggerClientEvent('sh-hunting:client:reqestForAllPlayers', -1)
end)

function QuerryOnStart()
    local data = MySQL.query.await('SELECT * FROM `huntingmission`', {})
    if data[1] ~= nil then
        if Config.debug then print(data[1].missionstage) end
        for index, value in ipairs(data) do
            local tbl = { missionStage = data[index].missionstage, plyCoords = json.decode(data[index].plycoords) , missionCords = json.decode(data[index].missionCords), selectedMission = data[index].selectedMission}
            playersTable[data[index].license] = tbl 
        end
    end
    if Config.debug then print(debug(playersTable)) end
end

RegisterNetEvent('sh-hunting:server:SyncPlayer', function(plyInfo)
    local identifier = GetPlayerIdentifierByType(source, 'license')
    local find = false
    if Config.debug then print("=========") end
    if plyInfo.missionCords ~= nil then
        if tablelength(playersTable) > 0 then
            for key, val in pairs(playersTable) do    
                if key == identifier then
                    find = true
                    if Config.debug then print("-------") end
                    if Config.debug then print('SelectData') end
                    playersTable[key] = plyInfo
                    local data = MySQL.query.await('SELECT * FROM `huntingmission` WHERE `license` = ?', {
                        identifier
                    })
                    if data[1] ~= nil then
                        if Config.debug then print("-------") end
                        if Config.debug then print('SelectedData inFor') end
                        if plyInfo.missionStage > data[1].missionstage then
                            local updatedData = MySQL.update.await('UPDATE `huntingmission` SET plycoords = ?, missionstage = ?, stagename = ?, stagecoords = ? WHERE license = ?', {
                                json.encode(plyInfo.plyCoords),plyInfo.missionStage, plyInfo.selectedMission, json.encode(data[index].missionCords), identifier})
                            if Config.debug then print(updatedData) end
                        else
                            local updatedData = MySQL.update.await('UPDATE `huntingmission` SET plycoords = ? WHERE license = ?', {
                                json.encode(plyInfo.plyCoords), identifier})
                            if Config.debug then print(updatedData) end
                            
                        end
                    else
                       local insData = MySQL.insert.await('INSERT INTO `huntingmission` (license, missionstage, stagename, stagecoords, plycoords) VALUES (?, ?, ?, ?, ?)', {
                            key, plyInfo.missionStage, plyInfo.missionStage, plyInfo.selectedMission, json.encode(plyInfo.missionCords), json.encode(plyInfo.plyCoords)
                        })
                        if Config.debug then print("-------") end
                        if Config.debug then print('Insert data') end
                        if Config.debug then print(insData) end
                    end
                end
                
            end
            if not find then
                if Config.debug then print("---------") end
                if Config.debug then print("ActualTable") end
                if Config.debug then print(debug(playersTable)) end
                playersTable[identifier] = plyInfo
                local data = MySQL.query.await('SELECT * FROM `huntingmission` WHERE `license` = ?', {
                    identifier
                })
                if data[1] ~= nil then
                    if Config.debug then print("-------") end
                    if Config.debug then print('SelectedData wotFor') end
                    if Config.debug then print(debug(data)) end
                    if plyInfo.missionStage > data[1].missionstage then
                        local updatedData = MySQL.update.await('UPDATE `huntingmission` SET plycoords = ?, missionstage = ?, stagename = ?, stagecoords = ? WHERE license = ?', {
                            json.encode(plyInfo.plyCoords),plyInfo.missionStage, plyInfo.selectedMission, json.encode(data[index].missionCords), identifier})
                        if Config.debug then print(updatedData) end
                    else
                        local updatedData = MySQL.update.await('UPDATE `huntingmission` SET plycoords = ? WHERE license = ?', {
                            json.encode(plyInfo.plyCoords), identifier})
                        if Config.debug then print(updatedData) end
                        
                    end
                else
                    local insData = MySQL.insert.await('INSERT INTO `huntingmission` (license, missionstage, stagename, stagecoords, plycoords) VALUES (?, ?, ?, ?, ?)', {
                        identifier, plyInfo.missionStage, plyInfo.selectedMission, json.encode(plyInfo.missionCords), json.encode(plyInfo.plyCoords)
                    })
                    if Config.debug then print("-------") end
                    if Config.debug then print('Insert data wFor') end
                    if Config.debug then print(insData) end
                end
            end
        else
            if Config.debug then print("---------") end
            if Config.debug then print("ActualTable") end
            if Config.debug then print(debug(playersTable)) end
            playersTable[identifier] = plyInfo
            local data = MySQL.query.await('SELECT * FROM `huntingmission` WHERE `license` = ?', {
                identifier
            })
            if data[1] ~= nil then
                if Config.debug then print("-------") end
                if Config.debug then print('SelectedData nT') end
                if Config.debug then print(debug(data)) end
                if plyInfo.missionStage > data[1].missionstage then
                    local updatedData = MySQL.update.await('UPDATE `huntingmission` SET plycoords = ?, missionstage = ?, stagename = ?, stagecoords = ? WHERE license = ?', {
                        json.encode(plyInfo.plyCoords),plyInfo.missionStage, plyInfo.selectedMission, json.encode(data[index].missionCords), identifier})
                    if Config.debug then print(updatedData) end
                else
                    local updatedData = MySQL.update.await('UPDATE `huntingmission` SET plycoords = ? WHERE license = ?', {
                        json.encode(plyInfo.plyCoords), identifier})
                    if Config.debug then print(updatedData) end
                    
                end
            else
                local insData = MySQL.insert.await('INSERT INTO `huntingmission` (license, missionstage, stagename, stagecoords, plycoords) VALUES (?, ?, ?, ?, ?)', {
                    identifier, plyInfo.missionStage, plyInfo.selectedMission, json.encode(plyInfo.missionCords), json.encode(plyInfo.plyCoords)
                })
                if Config.debug then print("-------") end
                if Config.debug then print('Insert data nT') end
                if Config.debug then print(insData) end
            end
        end
    end
end)

RegisterNetEvent('sh-hunting:server:requestSyncPlayer', function()
    local identifier = GetPlayerIdentifierByType(source, 'license')
    
    for key, val in pairs(playersTable) do   
        if key == identifier then
            TriggerClientEvent('sh-hunting:client:reqestSyncPlayer', source, val)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        for key, value in pairs(playersTable) do
            local data = MySQL.query.await('SELECT * FROM `huntingmission` WHERE `license` = ?', {
                key
            })
            if data[1] ~= nil then
                if Config.debug then print("Table Players"..debug(playersTable)) end
                if playersTable[key] == data[1].license then
                    local tbl = { data[1].missionstage, json.encode(data[1].plycoords) ,json.encode(data[1].missionCords), data[1].selectedMission}
                    playersTable[key] = tbl
                end
            end
            Citizen.Wait(50)
        end
        Citizen.Wait(10000)
    end
end)


function debug(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. debug(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

 function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end