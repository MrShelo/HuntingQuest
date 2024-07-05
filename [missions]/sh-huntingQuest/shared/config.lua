Config = {}



Config.SpawnedPeds = {} -- Miejsce zapisu zrespionych npc
Config.MissionData = { -- Dane aktualnej misji, progresu przetrzymywane dla gracza
    missionStage = -1,
    plyCoords = nil,
    missionCords = nil,
    selectedMission = nil,
} 
Config.debug = false -- debug prints server
Config.Lang = 'pl' -- Wybór tłumaczeń w przypadku możliwości wyboru języka

Config.Translations = { -- Tablica z tłumaczeniami
    ['pl'] = {
        npcText = '[E] - Odbierz zlecenie na polowanie',
        npcOnHunt = 'Udaj się na polowanie',
        npcAfterHunt = '[E] - Odbierz zapłatę',
        OnJob = 'Wsiądź do pojazdu i jedź w wyznaczone na mapie miejsce',
        deertext = 'Znajdujesz jelenia.',
        boartext = 'Znajdujesz dzika.',
        checkTrail = '[E] - Sprawdź trop',
        waterText = 'Coś korzystało z tego wodopoju',
        poopText = 'Coś zostawiło tu odchody',
        trailText = 'Coś tędy szło',
        trailBlip = '# Tropy zwierzęcia',
        huntText = 'Polowanie',
        huntleaveText = 'Zwierzyna uciekła',
        diedAnimalText = 'Martwa zwierzyna',
        trailGo = 'Podążaj tropem',
        toskintext = '[E] - Skórowanie',
        returnSkin = 'Przyjedź ze skórą do myśliwego',
        huntingBlip = 'Leśniczy - Polowanie',
        rewardText = 'Może kiedyś dam ci pieniądze..',
    }
}



Config.InvestigationAnim = 'amb@medic@standing@kneel@base'
Config.InvestigationLib = 'base'

Config.SkinningAnim = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@'
Config.SkinningLib = 'machinic_loop_mechandplayer'

Config.InteractKey = 38  -- Control Key który odpowiada za interakcję z NPC

Config.WeaponHash = -1466123874 -- Hash Key bronii palnej

Config.JobVeh = 'rebel' -- Pojazd do huntingu
Config.SpawnJobVehicle = vector4(-684.8661, 5825.1323, 17.3307, 105.2597)  -- Miejsce pojawiania się pojazdu

Config.PedModel = 'ig_hunter' -- Model NPC
Config.Animals ={  -- Tablica ze zwierzętami do polowania
    ['deer'] = {
        model = 'a_c_deer',
        objectiveText = Config.Translations[Config.Lang].deertext,
    },
    ['boar'] = {
        model = 'a_c_boar',
        objectiveText = Config.Translations[Config.Lang].boartext,
    }
}

Config.HuntingZone = { -- Zone' w którym odbywają się polowania
    vector2(-1779.7515869141, 4473.7397460938),
    vector2(-1827.8756103516, 4379.0180664062),
    vector2(-1805.4592285156, 4318.5859375),
    vector2(-1493.1102294922, 4227.0454101562),
    vector2(-1389.1667480469, 4191.564453125),
    vector2(-1292.9479980469, 4218.4116210938),
    vector2(-1254.5577392578, 4256.525390625),
    vector2(-1124.5688476562, 4289.3500976562),
    vector2(-1016.1578369141, 4288.0712890625),
    vector2(-848.75421142578, 4362.73046875),
    vector2(-802.56298828125, 4384.35546875),
    vector2(-813.73083496094, 4464.3349609375),
    vector2(-888.93115234375, 4486.0356445312),
    vector2(-1039.6130371094, 4471.787109375),
    vector2(-1097.1370849609, 4494.2900390625),
    vector2(-1318.3670654297, 4553.927734375),
    vector2(-1391.2169189453, 4579.9965820312),
    vector2(-1480.0980224609, 4619.0795898438),
    vector2(-1545.3325195312, 4671.046875),
    vector2(-1626.4086914062, 4719.4057617188),
    vector2(-1755.1149902344, 4668.9990234375),
    vector2(-1769.6185302734, 4620.705078125),
    vector2(-1794.2661132812, 4526.9521484375) 
}
Config.MissionPlace = { -- Podstawowe miejsca oraz punkty od huntingu
    ['npc'] = { 
        coords = vector4(-682.7876, 5834.7354, 17.3313, 106.0479), -- Miejsce npc
        GetMissionText = Config.Translations[Config.Lang].npcText,
        OnMissionText = Config.Translations[Config.Lang].npcOnHunt,
        AfterMissionText = Config.Translations[Config.Lang].npcAfterHunt,
        InteractDistanceNPC = 3, -- Dystans aby móc wejść w interakcje z NPC
        customblip = nil
    },
    ['sttrail'] = {
        group = {  -- Miejsca pierwszej poszlaki
            vector4(-1326.1499, 4335.7134, 7.0365, 298.2762),
            vector4(-1276.2418, 4360.2817, 6.6650, 342.3373),
            vector4(-1254.3246, 4391.7856, 6.0993, 270.2664),
            vector4(-1223.1517, 4378.8818, 5.6775, 123.5687),
        },
        OnMissionText = Config.Translations[Config.Lang].waterText,
        blip = nil,

    },
    ['ndtrail'] = {
        group = { -- Miejsca drugiej poszlaki
            vector4(-1274.9619, 4438.4458, 14.7324, 28.1476),
            vector4(-1298.4047, 4432.8735, 21.8219, 113.7846),
            vector4(-1292.1605, 4469.5205, 18.4184, 35.3416),
            vector4(-1269.4365, 4458.8408, 8.9225, 98.8417),
        },
        OnMissionText = Config.Translations[Config.Lang].poopText,
        blip = nil,
    },
    ['rdtrail'] = {
        group ={ -- Miejsca trzeciej poszlaki
            vector4(-1389.8202, 4437.1475, 29.5646, 80.1625),
            vector4(-1384.0914, 4407.4404, 31.8201, 141.1594),
            vector4(-1418.2203, 4408.3174, 46.4443, 277.0858),
            vector4(-1417.0620, 4427.5352, 41.2186, 214.4842),
        },
        OnMissionText = Config.Translations[Config.Lang].trailText,
        blip = nil,
    },
    ['appear'] = {
        group ={ -- Miejsca pojawienia się zwierzęcia
            vector4(-1476.5741, 4427.6836, 23.8292, 210.7935),
            vector4(-1489.7793, 4410.1743, 22.2467, 337.4818),
            vector4(-1486.0995, 4430.2876, 21.4767, 327.1075),
            vector4(-1485.3995, 4431.7876, 21.4827, 327.1075)
        },
        blip = nil,
    }

}
