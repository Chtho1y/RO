local ExpeditionLevelData = class("ExpeditionLevelData")

function ExpeditionLevelData:ctor(cfg)
    self.levelId = cfg.LevelId
    self.rewards = cfg.Reward
    self.bossList = cfg.BossList
    self.maxFightingTime = cfg.MaxFightingTime
    self.closeRewardBoxImg = cfg.BoxImg[1]
    self.openRewardBoxImg = cfg.BoxImg[2]
    self.isGoodReward = cfg.HighReward > 0
    self.RestoreSp = cfg.RestoreSp 
    self.WarriorScore = cfg.WarriorScore
    if cfg.LevelCoefficient then
        self.LevelCoefficient = cfg.LevelCoefficient
    end
    self.isPassed = false
    self.isGotReward = false
end

function ExpeditionLevelData:GetLevelCoefficient()
    return self.LevelCoefficient
end

function ExpeditionLevelData:GetScore()
    return self.WarriorScore
end

function ExpeditionLevelData:SetRewardState(got)
    if self.rewards == nil then
        return
    end

    for i = 1, #self.rewards do
        self.rewards[i][3] = got
    end
end

function ExpeditionLevelData:SetPassed(passed)
    self.isPassed = passed
    self:SetGotReward(false)
end

function ExpeditionLevelData:SetGotReward(bGot)
    self.isGotReward = bGot
    self:SetRewardState(bGot)
end

function ExpeditionLevelData:GetBossMaxHPAndSp(bossId)
    if self.bossList == nil then
        return 1000000000000, 1000000000000
    end

    for i = 1, #self.bossList do
        if self.bossList[i][2] == bossId then
            return self.bossList[i][4],self.bossList[i][5]
        end
    end
    return 1000000000000,1000000000000
end

function ExpeditionLevelData:HasRedPoint()
    return self.isPassed and not self.isGotReward
end

return ExpeditionLevelData