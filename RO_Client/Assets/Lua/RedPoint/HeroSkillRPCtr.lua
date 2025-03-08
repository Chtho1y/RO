local HeroSkillRPCtr = class("HeroSkillRPCtr")

local CACHE_SKILL_KEY_NAME = "Cache_Skill_Key"

function HeroSkillRPCtr:ctor()
    self.cacheSkillCanUnlockMap = nil
    local className = self:getClassName()
    ManagerContainer.LuaEventMgr:RegisterUIEvent(className, UIEventNames.HERO_JOB_CHANGE_SUCCESS, self, self.OnHeroLvChanged)
    ManagerContainer.LuaEventMgr:RegisterUIEvent(className, UIEventNames.HERO_LV_CHANGED, self, self.OnHeroLvChanged)
    ManagerContainer.LuaEventMgr:RegisterUIEvent(className, UIEventNames.EID_PARTER_ADD, self, self.OnParterAdd)
    ManagerContainer.LuaEventMgr:RegisterUIEvent(className, UIEventNames.EID_SKILL_CHANGED, self, self.OnSkillChanged)
end

function HeroSkillRPCtr:Dispose()
    local className = self:getClassName()
    ManagerContainer.LuaEventMgr:Unregister(className)

    self:WriteCacheSkillUnlockData()
    self.cacheSkillCanUnlockMap = nil
end

function HeroSkillRPCtr:OnHeroLvChanged(heroId)
    self:HeroSkillUnlockNotify(heroId)
end

function HeroSkillRPCtr:OnParterAdd(addPartnerMap)
    local isChanged = false
    local isCacheChanged = false
    for heroId,_ in pairs(addPartnerMap) do
        local childChanged, childCacheChanged = self:HeroSkillUnlockNotify(heroId, true, true)
        isChanged = isChanged or childChanged
        isCacheChanged = isCacheChanged or childCacheChanged
    end
    if isCacheChanged then
        self:WriteCacheSkillUnlockData()
    end
    if isChanged then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_NOTICE, Enum.RedPointEnum.SkillUnlockRP)
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.NewSkill, self:GetAllSkillUnlockRPStatus())
end

function HeroSkillRPCtr:OnSkillChanged(heroId)
    self:HeroSkillUnlockNotify(heroId)
end

function HeroSkillRPCtr:SkillUnlockNotify(ignoreSendMsg, ignoreSaveCache)
    if self.cacheSkillCanUnlockMap == nil then
        self:ReadCacheSkillUnlockData()
    end
    local isChanged = false
    local isCacheChanged = false
    local heroId = ManagerContainer.DataMgr.UserData:GetId()
    local childChanged, childCacheChanged = self:HeroSkillUnlockNotify(heroId, true, true)
    isChanged = isChanged or childChanged
    isCacheChanged = isCacheChanged or childCacheChanged
    local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
    for _,v in pairs(partnerDatas) do
        if v.owned then
            childChanged, childCacheChanged = self:HeroSkillUnlockNotify(v.id, true, true)
            isChanged = isChanged or childChanged
            isCacheChanged = isCacheChanged or childCacheChanged
        end
    end
    if isCacheChanged and not ignoreSaveCache then
        self:WriteCacheSkillUnlockData()
    end
    if isChanged and not ignoreSendMsg then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_NOTICE, Enum.RedPointEnum.SkillUnlockRP)
    end
    if not ignoreSendMsg then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.NewSkill, self:GetAllSkillUnlockRPStatus())
    end
end

function HeroSkillRPCtr:HeroSkillUnlockNotify(heroId, ignoreSendMsg, ignoreSaveCache)
    local isChanged = false
    local isCacheChanged = false
    local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(heroId)
    if skillData then
        local isLeaderHero = ManagerContainer.DataMgr.UserData:IsLeaderHero(heroId)
        local cfgId, curJobCfgData
        if isLeaderHero then
            cfgId = ManagerContainer.DataMgr.UserData:GetJobCfgId()
            curJobCfgData = ManagerContainer.CfgMgr:GetJobDataById(cfgId)
        else
            cfgId = ManagerContainer.DataMgr.PartnerData:GetHeroCfgId(heroId)
            curJobCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(cfgId)
        end
        if curJobCfgData then
            local jobs
            if isLeaderHero then
                jobs = ManagerContainer.CfgMgr:GetLastJobs(cfgId)
            else
                jobs = ManagerContainer.CfgMgr:GetParterLastJobs(cfgId)
            end
            if jobs then
                table.insert(jobs, curJobCfgData)
                local heroLv = ManagerContainer.DataMgr.UserData:GetHeroLv(heroId)
                if not self.cacheSkillCanUnlockMap then
                    self.cacheSkillCanUnlockMap = {}
                end
                local cacheMap = self.cacheSkillCanUnlockMap[heroId]
                if not cacheMap then
                    cacheMap = {}
                    self.cacheSkillCanUnlockMap[heroId] = cacheMap
                    isCacheChanged = true
                end
                for i = 1, #jobs do
                    local job = jobs[i]
                    local ls
                    if isLeaderHero then
                        ls = ManagerContainer.CfgMgr:GetSkillTreeByFeature(job.JobType, job.JobBranch, job.JobStage)
                    else
                        ls = ManagerContainer.CfgMgr:GetParterSkillTreeByFeature(job.JobType, job.ParterId)
                    end
                    if ls then
                        for j = 1, #ls do
                            local skillTreeCfgData = ls[j]
                            local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(heroId)
                            local skillMap = skillData:GetUnlockSkillMap()
                            if skillMap and skillTreeCfgData and skillTreeCfgData.SuperSkill then
                                for i = 1, #skillTreeCfgData.SuperSkill do
                                    if skillMap[skillTreeCfgData.SuperSkill[i][2]] then
                                        skillTreeCfgData = CommonUtil.GetSkillTreeCfgData(heroId,skillTreeCfgData.SuperSkill[i][2])
                                        break
                                    end
                                end
                            end
                            if skillTreeCfgData then
                                local skillId = skillTreeCfgData.SkillId
                                local skillIdKey = tostring(skillId)
                                if skillData:GetIsUnlock(skillId) then
                                    local cacheValue = cacheMap[skillIdKey]
                                    if cacheValue then
                                        isChanged = true
                                        isCacheChanged = true
                                        cacheMap[skillIdKey] = nil
                                    elseif cacheValue ~= nil then
                                        isCacheChanged = true
                                        cacheMap[skillIdKey] = nil
                                    end
                                else
                                    local cacheValue = cacheMap[skillIdKey]
                                    if cacheValue == nil then
                                        local isRedPoint = true
                                        local openLevel = skillTreeCfgData.OpenLevel
                                        if openLevel and openLevel > 0 then
                                            isRedPoint = (heroLv >= openLevel)
                                        end
                                        if isRedPoint then
                                            isChanged = true
                                            isCacheChanged = true
                                            cacheMap[skillIdKey] = isRedPoint
                                        end
                                    elseif cacheValue then
                                        local isRedPoint = true
                                        local openLevel = skillTreeCfgData.OpenLevel
                                        if openLevel and openLevel > 0 then
                                            isRedPoint = (heroLv >= openLevel)
                                        end
                                        if not isRedPoint then
                                            isChanged = true
                                            isCacheChanged = true
                                            cacheMap[skillIdKey] = isRedPoint
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if isCacheChanged and not ignoreSaveCache then
        self:WriteCacheSkillUnlockData()
    end
    if isChanged and not ignoreSendMsg then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_NOTICE, Enum.RedPointEnum.SkillUnlockRP)
    end
    if not ignoreSendMsg then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.NewSkill, self:GetAllSkillUnlockRPStatus())
    end
    return isChanged, isCacheChanged
end

function HeroSkillRPCtr:CancelSkillUnlockNotify(heroId, skillId, ignoreSendMsg, ignoreSaveCache)
    local isChanged = false
    local isCacheChanged = false
    local cacheMap = self.cacheSkillCanUnlockMap and self.cacheSkillCanUnlockMap[heroId] or nil
    if cacheMap then
        local skillIdKey = tostring(skillId)
        local cacheValue = cacheMap[skillIdKey]
        if cacheValue then
            isChanged = true
            isCacheChanged = true
            cacheMap[skillIdKey] = false
        end
    end
    if isCacheChanged and not ignoreSaveCache then
        self:WriteCacheSkillUnlockData()
    end
    if isChanged and not ignoreSendMsg then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_NOTICE, Enum.RedPointEnum.SkillUnlockRP)
    end
    if not ignoreSendMsg then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.NewSkill, self:GetAllSkillUnlockRPStatus())
    end
    return isChanged, isCacheChanged
end

function HeroSkillRPCtr:GetAllSkillUnlockRPStatus()
    if self.cacheSkillCanUnlockMap then
        for _, cacheMap in pairs(self.cacheSkillCanUnlockMap) do
            for _,v in pairs(cacheMap) do
                if v then
                    return Enum.RedPointEnum.SkillUnlockRP
                end
            end
        end
    end
    return Enum.RedPointEnum.None
end

function HeroSkillRPCtr:GetHeroSkillUnlockRPStatus(heroId)
    if self.cacheSkillCanUnlockMap then
        local cacheMap = self.cacheSkillCanUnlockMap[heroId]
        if cacheMap then
            for _,v in pairs(cacheMap) do
                if v then
                    return Enum.RedPointEnum.SkillUnlockRP
                end
            end
        end
    end
    return Enum.RedPointEnum.None
end

function HeroSkillRPCtr:GetSkillUnlockRPStatus(heroId, skillId)
    if self.cacheSkillCanUnlockMap then
        local cacheMap = self.cacheSkillCanUnlockMap[heroId]
        if cacheMap then
            local skillIdKey = tostring(skillId)
            local cacheValue = cacheMap[skillIdKey]
            if cacheValue then
                return Enum.RedPointEnum.SkillUnlockRP
            end
        end
    end
    return Enum.RedPointEnum.None
end

function HeroSkillRPCtr:ReadCacheSkillUnlockData()
    local cacheStr = ManagerContainer.PlayerPrefsMgr:GetString(CACHE_SKILL_KEY_NAME, '')
    local cacheSkillCanUnlockMap = JSON:decode(cacheStr)
    if not cacheSkillCanUnlockMap then
        cacheSkillCanUnlockMap = {}
    end
    self.cacheSkillCanUnlockMap = cacheSkillCanUnlockMap
end

function HeroSkillRPCtr:WriteCacheSkillUnlockData()
    if self.cacheSkillCanUnlockMap then
        local valueStr = JSON:encode(self.cacheSkillCanUnlockMap)
        ManagerContainer.PlayerPrefsMgr:SetString(CACHE_SKILL_KEY_NAME, valueStr)
    end
end


return HeroSkillRPCtr