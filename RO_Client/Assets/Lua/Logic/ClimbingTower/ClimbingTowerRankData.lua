local ClimbingTowerRankData = class("ClimbingTowerRankData")

function ClimbingTowerRankData:ctor(uid,rank)
    self.playerId = uid
    self.rank = rank
end

function ClimbingTowerRankData:SetRankData(brief_info)
    if brief_info ~= nil then
        self.playerName = CommonUtil.GetVaildNickName(brief_info.nick_name)
        self.playerGender = brief_info.gender
        self.playerLevel = brief_info.level
        self.playerJobId = brief_info.config_id
        self.playerFighterPower = brief_info.fight_power
        self.headFrameId = brief_info.head_frame_id
        self.playerHead = CommonUtil.GetPlayerHeadIcon(brief_info)
        self.vipLv          = brief_info.vip_level
    end
    self.leveLNum = brief_info.tower_level
    self.passedTime = brief_info.tower_time
    self.passedTimeStr = DateTimeUtil.convertTime2Str(self.passedTime,"yyyy/MM/dd")
end

return ClimbingTowerRankData