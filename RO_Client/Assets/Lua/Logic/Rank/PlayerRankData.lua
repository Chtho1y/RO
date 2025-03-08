local PlayerRankData = class("PlayerRankData")

function PlayerRankData:ctor(rank,brief_info,score)
    self.rank = rank
    self.score = score
    if brief_info ~= nil then
        self.playerId = brief_info.uid
        self.playerName = brief_info.nick_name
        self.playerGender = brief_info.gender
        self.playerLevel = brief_info.level
        self.playerJobId = brief_info.config_id
        self.playerFighterPower = brief_info.fight_power
        self.headFrameId = brief_info.head_frame_id
        self.playerHead = CommonUtil.GetPlayerHeadIcon(brief_info)
        self.vipLv          = brief_info.vip_level
    end

    local danCfg = CommonUtil.GetDanCfg(self.score)
    if danCfg ~= nil then
        self.danName = danCfg.ArenaLevelName
        self.danIcon = danCfg.LevelIcon
    end
end

return PlayerRankData