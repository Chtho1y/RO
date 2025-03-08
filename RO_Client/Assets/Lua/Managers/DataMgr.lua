local DataMgr = class("DataMgr")

function DataMgr:ctor()
    self.UserData = require("UserData"):new()
    self.BagData = require("BagData"):new()
    self.PartnerData = require("PartnerData"):new()
    self.EquipData = require("EquipData"):new()
    self.ChipData = require("ChipData"):new()
    self.CardData = require("CardData"):new()
    self.GuildLobbyData = require("GuildLobbyData"):new()
    self.GuildDataMgr = require("Guild/GuildDataMgr"):new()
    self.GuildWarDataMgr = require('GuildWar.GuildWarDataMgr'):new()
    self.FashionData = require("FashionData"):new()
    self.StageGoalData = require("StageGoalData"):new()
    self.BigMapData = require('BigMapData'):new()
    self.TreasureData = require("TreasureData"):new()
    self.HeadProtraitData = require("HeadProtraitData"):new()
    self.MailData = require("MailData"):new()
    self.ArenaData = require("ArenaData"):new()
    self.WorldBossData = require("WorldBossData"):new()
    self.CompetitionData = require("CompetitionData"):new()
    self.StoryData = require("StoryData"):new()
    self.ChatData = require("ChatData"):new()
    self.FriendDataMgr = require("Friend/FriendDataMgr"):new()
    self.ShopDataMgr = require("Shop/ShopDataMgr"):new()
    self.RuneShopDataMgr = require('RuneShop/RuneShopDataMgr'):new()
    self.SignData = require("SignData"):new()
    self.NotifyData = require("NotifyData"):new()
    self.TaskDataNew = require("TaskDataNew"):new()
    self.TowerDataMgr = require("ClimbingTower/ClimbingTowerDataMgr"):new()
    self.ForceGuideData = require("ForceGuideData"):new()
    self.EvilData = require("Evil/EvilData"):new()
    self.GMNoticeData = require("GMNoticeData"):new()
    self.CollectionBookData = require("CollectionBookData"):new()
    self.PetDataMgr = require("Pet/PetDataMgr"):new()
    self.HeadFrameDataMgr = require("HeadFrame/HeadFrameDataMgr"):new()
    self.ExpeditionDataMgr = require("Expedition/ExpeditionDataMgr"):new()
    self.ActsDataMgr = require("Activities/ActivitiesDataMgr"):new()
    self.SummonDataMgr = require('SummonDataMgr'):new()
    self.HundredDojoDataMgr = require('HundredDojo/HundredDojoDataMgr'):new()
    self.RankActivitiesMgr = require('RankActivities/RankActivitiesMgr'):new()
    self.KeepSakeBookData = require('CollectionHouse/KeepSakeBookData'):new()
    self.TrunWheelDataMgr = require("SeasonTurnWheel/TrunWheelDataMgr"):new()
    self.StarSignData = require("StarSignData"):new()
    self.VoyageDataMgr = require('Voyage/VoyageDataMgr'):new()
    self.SkillEquipData = require("SkillEquipData"):new()
    self.GuildDemonData = require("Guild/GuildDemonData"):new()
    self.TitleData = require("Title/TitleData"):new()
    self.IdolData = require("IdolData"):new()

    self.PeakTowerDataMgr = require("PeakTower/PeakTowerDataMgr"):new()
    self.CombineServerDataMgr = require('CombineServerDataMgr'):new()
end

function DataMgr:RegisterAllDataEvents()
    for _,v in pairs(self) do
        if iskindof(v, "DataBase") then
            v:RegisterNetEvents()
        end
    end

end

function DataMgr:ResetAllData()
    for _,v in pairs(self) do
        if iskindof(v, "DataBase") then
            v:Clear()
        end
    end
end

function DataMgr:Destroy()
    for k,_ in pairs(self) do
        if self[k].Save then
            self[k]:Save()
        end
    end

    for k,_ in pairs(self) do
        if self[k].Destroy then
            self[k]:Destroy()
        end
        self[k] = nil
    end

    if tolua.getpeer(self) ~= nil then
		tolua.setpeer(self, nil)
    end
end
return DataMgr