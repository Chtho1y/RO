local ExpeditionMapData = class("ExpeditionMapData")
local ExpeditionLevelData = require("Expedition/ExpeditionLevelData")

function ExpeditionMapData:ctor(mapId,cfg)
    self.mapId = mapId
    self.maxLevelNum = cfg.LevelNum
    self.name = cfg.Name
    self.icon = cfg.Icon
    self.sceneName = cfg.SceneName
    self.bgm = cfg.BGM
    self.loadingId = cfg.LoadingId
    self.bannerImg = cfg.BannerImg
    self.showRewards = cfg.ShowReward
    self.unlockConds = cfg.UnlockCondition
    self.unlockContent = cfg.UnlockDesc or ""
    self.levelBg = cfg.LevelBg or ""
    self.isPassed = false           --是否通关
    self.unlocked = false
    self.isChallenging = false
    self.allLevels = nil
    self.isUnfold = false
    self.isNew = false
    self:InitData()
end

function ExpeditionMapData:InitData()
    self.allLevels = {}
    for levelId = 1, self.maxLevelNum do
        local cfg = ManagerContainer.CfgMgr:GetExpeditionCfgByTypeAndLevelId(self.mapId,levelId)
        if cfg ~= nil then
            self.allLevels[#self.allLevels + 1] = ExpeditionLevelData:new(cfg)
        end
    end
    -- self:CheckUnlock()
end 

function ExpeditionMapData:SetUnfold(unfold)
    self.isUnfold = unfold
    self.isNew = false
end

function ExpeditionMapData:SetUnlockState(unlocked)
    self.unlocked = unlocked
end

function ExpeditionMapData:SetChallengeState(challenging)
    self.isChallenging = challenging
    if challenging then
        self.isUnfold = true
    end
end

function ExpeditionMapData:SetMapPassed()
    if self.allLevels == nil then
        return
    end

    for i = 1, #self.allLevels do
        self.allLevels[i]:SetPassed(true)
    end
    self.isPassed = true
end

function ExpeditionMapData:SetPassedLevels(curChallengeLevel)
    if curChallengeLevel == nil  or curChallengeLevel <= 1 then
        return 
    end

    for levelId = 1, curChallengeLevel-1 do
        local level = self:FindLevelByLevelId(levelId)
        if level ~= nil then
            level:SetPassed(true)
        end
    end
end

function ExpeditionMapData:SetGotRewardLevels(levelIds)
    if levelIds == nil then
        return
    end

    for i = 1, #levelIds do
        local level = self:FindLevelByLevelId(levelIds[i])
        if level ~= nil then
            level:SetGotReward(true)
        end
    end
end

function ExpeditionMapData:SetGotRewardLevel(levelId)
    local level = self:FindLevelByLevelId(levelId)
    if level ~= nil then
        level:SetGotReward(true)
    end
end

function ExpeditionMapData:SetMapGotReward()
    if self.allLevels == nil then
        return
    end

    for i = 1, #self.allLevels do
        self.allLevels[i]:SetGotReward(true)
    end
end

function ExpeditionMapData:FindLevelByLevelId(levelId)
    if self.allLevels == nil or #self.allLevels == 0 then
        return nil
    end

    for i = 1, #self.allLevels do 
        if self.allLevels[i].levelId == levelId then
            return self.allLevels[i]
        end
    end

    return nil
end

function ExpeditionMapData:GetLevelIdxByLevelId(levelId)
    if self.allLevels == nil or #self.allLevels == 0 then
        return 0
    end

    for i = 1, #self.allLevels do 
        if self.allLevels[i].levelId == levelId then
            return i
        end
    end

    return 0
end


function ExpeditionMapData:GetNextGoodRewardLevel(curLevelId)
    if self.isPassed then
        return 0
    end

    if self.allLevels == nil or #self.allLevels == 0 then
        return 0
    end

    local levelIdx = self:GetLevelIdxByLevelId(curLevelId)
    for i = levelIdx, #self.allLevels do 
        if self.allLevels[i].isGoodReward then
            return i - levelIdx + 1
        end
    end
    
    return 0
end

function ExpeditionMapData:Reset()
    self.isUnfold = false
    self.isPassed = false 
    self.isChallenging = false
    if self.allLevels ~= nil then
        for i = 1, #self.allLevels do
            local level = self.allLevels[i]
            level:SetPassed(false)
            level:SetGotReward(false)
        end
    end
end

function ExpeditionMapData:HasRedPoint()
    if self.isNew  then
        return true
    end

    if self.allLevels == nil then
        return false
    end

    for i = 1, #self.allLevels do
        if self.allLevels[i]:HasRedPoint() then
            return true
        end
    end
    return false
end

function ExpeditionMapData:SetNewState(bNew)
    self.isNew = bNew
end

return ExpeditionMapData