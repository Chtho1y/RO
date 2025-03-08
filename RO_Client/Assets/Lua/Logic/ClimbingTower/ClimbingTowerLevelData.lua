local ClimbingTowerLevelData = class("ClimbingTowerLevelData")
local ClimbingTowerNpcData = require("ClimbingTower/ClimbingTowerNpcData")

function ClimbingTowerLevelData:ctor(cfg)
    self.levelId = cfg.Id
    self.sceneName = cfg.SceneName
    self.bgmName = cfg.BgmName
    self.maxFightingTime = cfg.MaxFightingTime
    self.monsterLevel = cfg.MonsterLevel
    self.hasPassed = false                      --是否通过
    self.npcs = nil                             --关卡npc信息
    self.rewards = cfg.RewardItems              --关卡奖励
    self.specialReward = cfg.SpecialReward      --关卡特殊奖励
    self.friends = nil                          --好友通关记录
    self.lowestPlayer = nil                     --最低通过玩家记录
    self.CardUnlock = cfg.CardUnlock

    self:InitNpcData(cfg.NpcList)
end

function ClimbingTowerLevelData:InitNpcData(npcData)
    self.npcs = {}
    for i=1,#npcData do
        self.npcs[#self.npcs+1] =ClimbingTowerNpcData:new(npcData[i],self.monsterLevel)  
    end
end

function ClimbingTowerLevelData:SetLowestPlayerInfo(brief_info,fight_power,record_time,battle_time)
    self.lowestPlayer = {}
    self.lowestPlayer.head = CommonUtil.GetPlayerHeadIcon(brief_info)
    self.lowestPlayer.uid = brief_info.uid
    self.lowestPlayer.job = brief_info.config_id
    self.lowestPlayer.level = brief_info.level
    self.lowestPlayer.name = CommonUtil.GetVaildNickName(brief_info.nick_name)
    self.lowestPlayer.fightPower = fight_power
    self.lowestPlayer.battle_record_uid = brief_info.battle_record_id
    self.lowestPlayer.record_time = record_time
    self.lowestPlayer.battle_time = battle_time
    self.lowestPlayer.head_frame = brief_info.head_frame_id
end

function ClimbingTowerLevelData:SetFriendData(playerList)
    if playerList ~= nil then
        self.friends = {}
        for i = 1, #playerList do
            local brief_info = playerList[i]
            local player = {}
            player.uid = brief_info.uid
            player.job = brief_info.config_id
            player.level = brief_info.level
            player.name = CommonUtil.GetVaildNickName(brief_info.nick_name)
            player.fightPower = brief_info.fight_power
            player.head = CommonUtil.GetPlayerHeadIcon(brief_info)
            player.headFrameId = brief_info.head_frame_id
            
            local headFrame = ManagerContainer.DataMgr.HeadFrameDataMgr:GetHeadFrameById(brief_info.head_frame_id)
            if headFrame ~= nil then
                player.headFrame = headFrame.icon
            else
                player.headFrame = nil
            end

            self.friends[#self.friends+1] = player
        end
    else
        self.friends = nil
    end
end

function ClimbingTowerLevelData:SetPassed(val)
    self.hasPassed = val
end

function ClimbingTowerLevelData:GetRewards()
    return self.rewards
end

function ClimbingTowerLevelData:GetLowestPlayer()
    return self.lowestPlayer
end

function ClimbingTowerLevelData:GetFriendsInfo()
    return self.friends
end

function ClimbingTowerLevelData:HasFriend()
    return self.friends ~= nil and #self.friends > 0
end

return ClimbingTowerLevelData
