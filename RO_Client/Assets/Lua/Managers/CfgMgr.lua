local CfgMgr = class("CfgMgr")

local function CfgSort(a,b)
    return a.Id < b.Id
end

local function NumSort(a,b)
    return a < b
end

function CfgMgr:ctor()
    self.UICfg = InternalRequire("UICfg")
    self.RoleCfg = InternalRequire("RoleCfg")
    self.ParterCfg = InternalRequire("ParterCfg")
    self.NpcCfg = InternalRequire("NpcCfg")
    self.NatureCfg = InternalRequire("NatureCfg")
    self.JobCfg = InternalRequire("JobCfg")
    self.JobExpCfg = InternalRequire("JobExpCfg")
    self.ParterProgressCfg = InternalRequire("ParterProgressCfg")
    self.ParterAttributeCfg = InternalRequire("ParterAttributeCfg")
    self.QualityPointCfg = InternalRequire("QualityPointCfg")
    self.ItemCfg = InternalRequire("ItemCfg")
    self.EquipCfg = InternalRequire("EquipCfg")
    self.EquipSuitCfg = InternalRequire("EquipSuitNewCfg")
    self.FightPowerCfg = InternalRequire("FightCfg")
    self.SkillCfg = InternalRequire("SkillCfg")
    self.SkillLvCfg = InternalRequire("SkillLvCfg")
    -- self.PassiveSkillCfg = InternalRequire("PassiveSkillCfg")
    self.SkillTreeCfg = InternalRequire("SkillTreeCfg")
    self.ParterSkillTreeCfg = InternalRequire("ParterSkillTreeCfg")
    self.SkillSlotCfg = InternalRequire("SkillSlotCfg")
    self.SkillUpEffectCfg = InternalRequire("SkillUpEffectCfg")
    self.SkillShowCfg = InternalRequire("SkillShowCfg")
    self.MarkCfg = InternalRequire('MarkCfg')
    self.AvatarCfg = InternalRequire("AvatarCfg")
    self.EquipRefineCfg = InternalRequire("EquipRefineCfg")
    self.CardUnlockCfg = InternalRequire("CardUnlockCfg")
    self.CardCfg = InternalRequire("CardCfg")
    self.RoleAvatarCfg = InternalRequire('RoleAvatarCfg')
    self.FashionCfg = InternalRequire("FashionCfg")
    self.FashionPaperCfg = InternalRequire("FashionPaperCfg")
    self.CreateHairCfg = InternalRequire("CreateHairCfg")
    self.CreateHairColorCfg = InternalRequire("CreateHairColourCfg")
    self.CreateEyeCfg = InternalRequire("CreateEyeCfg")
    self.CreateHeadwearCfg = InternalRequire("CreateHeadwear")
    self.RoleAttributeCfg = InternalRequire("RoleAttributeCfg")
    self.UIJumpCfg = InternalRequire("UIJumpCfg")
    self.TargetTaskCfg = InternalRequire("TargetTaskCfg")
    self.MapCfg = InternalRequire("MapCfg")
    self.QuickBattleCostCfg = InternalRequire("QuickBattleCostCfg")
    self.HeadPortraitCfg = InternalRequire("HeadPortraitCfg")
    self.ConditionCfg = InternalRequire("ConditionCfg")
    self.LevelCfg = InternalRequire("LevelCfg")
    self.WorldBossCfg = InternalRequire("WorldBossCfg")
    self.WorldBossChangePlayCfg = InternalRequire("WorldBossChangePlayCfg")
    self.ArenaRewardCfg = InternalRequire("ArenaRewardCfg")
    self.RobotCfg = InternalRequire("RobotCfg")
    self.ArenaLevelCfg = InternalRequire("ArenaLevelCfg")
    self.MailCfg = InternalRequire("MailCfg")
    self.CardReset = InternalRequire("CardReset")
    self.UIFuncUnLockCfg = InternalRequire("UIFuncUnLockCfg")
    self.CompetitionCfg = InternalRequire("CompetitionCfg")
    self.StoryCfg = InternalRequire("StoryCfg")
    self.StroyPerformCfg = InternalRequire("StroyPerformCfg")
    self.StoryChapterCfg = InternalRequire('StoryChapterCfg')
    self.StorySectionCfg = InternalRequire('StorySectionCfg')
    self.LoadingCfg = InternalRequire("LoadingCfg")
    self.NoticeCfg = InternalRequire("NoticeCfg")
    self.EmojiCfg = InternalRequire("EmojiCfg")
    self.UIRedPointCfg = InternalRequire("UIRedPointCfg")
    self.ShopTypeCfg = InternalRequire('ShopTypeCfg')
    self.ShopCfg = InternalRequire("ShopCfg")
    self.RuneShopMonthCardCfg = InternalRequire('RuneShopMonthCardCfg')
    self.RuneShopGiftsCfg = InternalRequire('RuneShopGiftsCfg')
    self.RuneShopLimitCfg = InternalRequire('RuneShopLimitCfg')
    self.SignInCfg = InternalRequire("SignInCfg");
    self.ForceGuideCfg = InternalRequire("ForceGuideCfg");
    self.GMCfg = InternalRequire("GMCfg");
    self.MissionCfg = InternalRequire("MissionCfg");
    self.LineMissionCfg = InternalRequire("LineMissionCfg");
    self.ActRewardCfg = InternalRequire("ActRewardCfg");
    self.ClimbingTowerCfg = InternalRequire("ClimbingTowerCfg");
    self.EvilCfg = InternalRequire("EvilCfg");
    self.CardIdentification = InternalRequire("CardIdentification");
    self.HeadFrameCfg = InternalRequire("HeadFrameCfg");
    self.GuildBadgeCfg = InternalRequire('GuildBadgeCfg')
    self.GuildLvCfg = InternalRequire('GuildLvCfg')
    self.GuildHuntBossCfg = InternalRequire('GuildBossCfg')
    self.GuildHuntBossRewardCfg = InternalRequire('GuildBossRewardCfg')
    self.PetCfg = InternalRequire('PetCfg')
    self.PetExpCfg = InternalRequire('PetExpCfg')
    self.PetProgressCfg = InternalRequire('PetProgressCfg')
    self.BattleFailedTipsCfg = InternalRequire("BattleFailedTipsCfg")
    self.PetpartnerCfg = InternalRequire("PetpartnerCfg")
    self.ExpeditionCfg = InternalRequire("ExpeditionCfg")
    self.ExpeditionBuffCfg = InternalRequire("ExpeditionBuffCfg")
    self.ExpeditionBuffDropCfg = InternalRequire("ExpeditionBuffDropCfg")
    self.ActivityTaskCfg = InternalRequire("ActivitiesTaskCfg")
    self.ActivitiesCfg = InternalRequire("ActivitiesCfg")
    self.FortnightDaysCfg = InternalRequire("ActivitiesFortnightDaysCfg")
    self.FortnightOnlineCfg = InternalRequire("ActivitiesFortnightOnlineCfg")
    self.ActivitiesCollectionCfg = InternalRequire("ActivitiesCollectionCfg") 
    self.ActivityRewardCfg = InternalRequire("ActivitiesRewardCfg")
    self.FirstChargeCfg = InternalRequire('ActivitiesFirstChargeCfg')
    self.SummonCfg = InternalRequire('SummonCfg')
    self.VipCfg = InternalRequire('VipCfg')
    self.InvitationTaskCfg = InternalRequire('InvitationTaskCfg')
    self.ActivitiesTiredChargeCfg = InternalRequire('ActivitiesTiredChargeCfg')
    self.ActivitiesDiscountsCfg = InternalRequire('ActivitiesDiscountsCfg')
    self.HundredDojoCfg = InternalRequire('HundredDojoCfg')
    self.RushListCfg = InternalRequire('RushListCfg')
    self.RuneShopRankTowerCfg = InternalRequire('RuneShopRankTowerCfg')
    self.RuneShopRankArenaCfg = InternalRequire('RuneShopRankArenaCfg')
    self.RuneShopRankMapCfg = InternalRequire('RuneShopRankMapCfg')
    self.RuneShopRankPetCfg = InternalRequire('RuneShopRankPetCfg')
    self.RuneShopRankSkillCfg = InternalRequire('RuneShopRankSkillCfg')
    self.RuneShopRankAidouluCfg = InternalRequire('RuneShopRankAidouluCfg')
	self.RuneShopGuildBattleCfg = InternalRequire('RuneShopGuildBattleCfg')
    self.RushListTargetCfg = InternalRequire('RushListTargetCfg')
    self.KeepSakeCfg = InternalRequire('KeepSakeCfg')

    self.CardSuitNewCfg = InternalRequire('CardSuitNewCfg')
    self.FightCfg = InternalRequire('FightCfg')

    self.FashionSuitCfg = InternalRequire('FashionSuitCfg')
    self.FashionLevelUp = InternalRequire('FashionLevelUp')
    self.CompetitionPrizeWheelCfg = InternalRequire("CompetitionPrizeWheelCfg")
    self.OnlineRewardsCfg = InternalRequire("OnlineRewardsCfg")
    self.SkillDemandCfg = InternalRequire("SkillDemandCfg") --获取技能升级消耗列表
    self.SkillSuitNewCfg = InternalRequire("SkillSuitNewCfg")
    self.PresspointPvPCfg = InternalRequire("PresspointPvPCfg")
    self.ActivityRoulettelCfg = InternalRequire("ActivityRoulettelCfg")
    self.DesignationCfg = InternalRequire("DesignationCfg") --称号数据表
    self.GuildDemonCfg = InternalRequire("GuildDemonCfg")
    self.CompetitionAidouluCfg = InternalRequire("CompetitionAidouluCfg") --偶像祭宝奖励箱表
end

-- function CfgMgr:GetEvilLevelCfg(id)
--     return self.EvilLevelCfg[id]
-- end

function CfgMgr:GetGuildDemonCfgCfgById(id)
    return self.GuildDemonCfg[id]
end

function CfgMgr:GetWishCfgById(id)
    if not self.WishCfg then
        self.WishCfg = InternalRequire("WishCfg")     --许愿表
    end
    return self.WishCfg[id]
end

function CfgMgr:GetAidouluCfg()
    return  self.CompetitionAidouluCfg
end

function CfgMgr:GetAidouluCfgLength()
    return  self.CompetitionAidouluCfg and # self.CompetitionAidouluCfg or 0
end

function CfgMgr:GetActivitySignDataById(id)
    if not self.ActivitiesSignInCfg then
        self.ActivitiesSignInCfg = InternalRequire("ActivitiesSignInCfg") --暑期活动签到数据表
        self.ActivitiesSignDatas = {}
        for k, v in pairs(self.ActivitiesSignInCfg) do
            if not self.ActivitiesSignDatas[v.ActivitiesId] then
                self.ActivitiesSignDatas[v.ActivitiesId] = {}
            end
            table.insert(self.ActivitiesSignDatas[v.ActivitiesId],v)
        end
        for k, v in pairs(self.ActivitiesSignDatas) do
            table.sort(v,function (a,b)
                return a.Day < b.Day
            end)
        end
        self.ActivitiesSignInCfg = nil
    end
    return self.ActivitiesSignDatas and self.ActivitiesSignDatas[id] or {}
end

function CfgMgr:GetGuildDemonCfg()
    return self.GuildDemonCfg
end

function CfgMgr:GetDesignationCfg()
    return self.DesignationCfg
end

function CfgMgr:GetDesignationCfgById(id)
    return self.DesignationCfg[id]
end

function CfgMgr:GetSkillDemandCfgUpGradeCostById(id)
    return self.SkillDemandCfg[id] and self.SkillDemandCfg[id].LvupCost or nil
end

--获取技能升级等级需求列表
function CfgMgr:GetSkillDemandCfgUpGradeLevelById(id)
    return self.SkillDemandCfg[id] and self.SkillDemandCfg[id].LvupDemand or nil
end

function CfgMgr:GetCompetitionDevineCfgById(id)
    if not self.CompetitionDevineCfg then
        self.CompetitionDevineCfg = require("CompetitionDevineCfg")
    end 
    return self.CompetitionDevineCfg[id]
end

function CfgMgr:GetFirstChargeCfgById(id)
    return self.FirstChargeCfg[id]
end

function CfgMgr:GetActivityRewardCfg()
    return self.ActivityRewardCfg
end

function CfgMgr:GetActivityTaskCfgById(id)
    return self.ActivityTaskCfg[id]
end

function CfgMgr:GetActivityCfg(id)
    return self.ActivitiesCfg[id]
end

function CfgMgr:GetActivities()
    return self.ActivitiesCfg
end

function CfgMgr:GetFortnightDaysCfg()
    return self.FortnightDaysCfg
end

function CfgMgr:GetFortnightOnlineCfg(actId)
    local list = {}
    for _,v in pairs(self.FortnightOnlineCfg) do
        if v.ActivitiesId == actId then
            list[#list + 1] = v
        end
    end
    return list
end

function CfgMgr:GetExpeditionBossCfg(BoosId)
    for _,v in pairs(self.ExpeditionBuffDropCfg) do
        if v.BossID == BoosId then
            return v
        end
    end
end

function CfgMgr:GetActivitiesCollectionCfg(actId)
    local list = {}
    for _,v in pairs(self.ActivitiesCollectionCfg) do
        if v.ActivitiesId == actId then
            list[#list + 1] = v
        end
    end
    return list
end

function CfgMgr:GetActivitiesPetExchangeCfg(actId)
    if not self.ActivitiesPetExchangeCfg then
        self.ActivitiesPetExchangeCfg = require("ActivitiesPetExchangeCfg")
    end
    local list = {}
    for _,v in pairs(self.ActivitiesPetExchangeCfg) do
        if v.ActivitiesId == actId then
            list[#list + 1] = v
        end
    end
    return list
end

function CfgMgr:GetActivitiesPetExchangeCfgById(id)
    if not self.ActivitiesPetExchangeCfg then
        self.ActivitiesPetExchangeCfg = require("ActivitiesPetExchangeCfg")
    end
    return self.ActivitiesPetExchangeCfg[id]
end

function CfgMgr:GetActivitiesCollectionCfgById(id)
    return self.ActivitiesCollectionCfg[id]
end

function CfgMgr:GetExpeditionCfgByTypeAndLevelId(type,levelId)
    return self.ExpeditionCfg[type * 1000 + levelId]
end

function CfgMgr:GetExpeditionBuffCfgById(id)
    return self.ExpeditionBuffCfg[id]
end

function CfgMgr:GetBattleFailedTipsCfg()
    return self.BattleFailedTipsCfg
end

function CfgMgr:GetEvilCfgByLevel(level)
    return self.EvilCfg[level]
end

function CfgMgr:GetUIData(id)
  return self.UICfg[id]
end

function CfgMgr:GetRoleDataById(id)
  return self.RoleCfg[id]
end

function CfgMgr:GetAllPartnerDatas()
  return self.ParterCfg
end

function CfgMgr:GetPartnerDataById(id)
  return self.ParterCfg[id]
end

function CfgMgr:GetPartnerDataByJobId(id)
    for _,v in pairs(self.ParterCfg) do
        if v.JobType == id then
            return v
        end
    end
    return
end

function CfgMgr:GetOriPartnerDatas()
    local list
    for _,v in pairs(self.ParterCfg) do
        if v.JobStage == 1 then
            if list == nil then
                list = {}
            end
            list[#list + 1] = v
        end
    end
    return list
end

function CfgMgr:GetOriPartnerDataByAdvenceId(configId)
    local advenceData = self.ParterCfg[configId]
    if advenceData == nil then return end

    for _,v in pairs(self.ParterCfg) do
        if v.JobStage == 1 and v.PostId == advenceData.PostId then
            return v
        end
    end
    return nil
end

function CfgMgr:GetOriPartnerDataByPostId(slot)
    for _,v in pairs(self.ParterCfg) do
        if v.JobStage == 1 and v.PostId == slot then
            return v
        end
    end
    return nil
end

function CfgMgr:GetPartnerCfgDataByJobType(jobType)
    for _,v in pairs(self.ParterCfg) do
        if v.JobType == jobType then
            return v.Name, v.NameColour
        end
    end
    return
end

function CfgMgr:GetPartnerPostIdByJobType(jobType)
    for _,v in pairs(self.ParterCfg) do
        if v.JobType == jobType then
            return v.PostId
        end
    end
    return 0
end

function CfgMgr:GetPartnerCfgCount()
    return CommonUtil.GetTableCount(self.ParterCfg)
end

function CfgMgr:GetNpcCfgById(id)
    return self.NpcCfg[id]
end

function CfgMgr:GetNatureDataById(id)
  return self.NatureCfg[id]
end

function CfgMgr:GetAllNatureDatas()
  return self.NatureCfg
end

function CfgMgr:GetJobDataById(id)
  return self.JobCfg[id]
end

--- 使用职业特征获得JobData
function CfgMgr:GetJobDataByFeature(jobType, jobBranch, jobStage)
  if not self.JobCfgTree then
    -- jobCfg数据拆解成树，方便查找
    local JobCfgTree = {}
    for _, jobData in pairs(self.JobCfg) do
      local itemJobType = jobData.JobType
      local itemJobBranch = jobData.JobBranch
      local itemJobStage = jobData.JobStage
      local jobTypeTree = JobCfgTree[itemJobType]
      if not jobTypeTree then
        jobTypeTree = {}
        JobCfgTree[itemJobType] = jobTypeTree
      end
      local jobBranchTree = jobTypeTree[itemJobBranch]
      if not jobBranchTree then
        jobBranchTree = {}
        jobTypeTree[itemJobBranch] = jobBranchTree
      end
      jobBranchTree[itemJobStage] = jobData
    end
    self.JobCfgTree = JobCfgTree
  end
  local item = self.JobCfgTree[jobType]
  if item then
    item = item[jobBranch]
    if item then
      return item[jobStage]
    end
  end
  return nil
end

function CfgMgr:GetParterProgressById(id)
    --local index = 0
    --while self.ParterProgressCfg[id] == nil do
    --    index = index + 1
    --    if index == 6 then
    --        return nil
    --    end
    --    local cfgData = self:GetPartnerDataById(id)
    --    if cfgData == nil then
    --        LogError("PartnerCfg   "..id.." not exist")
    --        return nil
    --    else
    --        if cfgData.BeforeJobId > 0 then
    --            id = cfgData.BeforeJobId
    --        else
    --            break
    --        end
    --    end
    --end
    return self.ParterProgressCfg[id]
end

function CfgMgr:GetParterAttributeByLv(lv)
    return self.ParterAttributeCfg[lv]
end

function CfgMgr:GetHeroQualityPointByLv(lv)
    return self.QualityPointCfg[lv]
end

function CfgMgr:GetItemById(id)
    return self.ItemCfg[id]
end

function CfgMgr:GetEquipById(id)
    return self.EquipCfg[id]
end

function CfgMgr:GetSameSuitEquipsBySuitId(suitId, jobType)
    local list
    for _,v in pairs(self.EquipCfg) do
        if v.Suit == suitId and CommonUtil.EleInTable(jobType, v.JobType) then
            if list == nil then
                list = {}
            end
            list[v.Type] = v
        end
    end
    return list
end

function CfgMgr:GetLanguageValueByKey(key, ...)
    return I18N.SetLanguageValue(key, ...)
end

function CfgMgr:GetAllEquipDatasByTypeAndJob(type, jobType, sortRule)
    local data1 = nil
    if sortRule == nil then
        sortRule = Enum.TableSortRule.Up
    end
    local list = {}
    for _, v in pairs(self.EquipCfg) do
        if v.Type == type then
            if v.EquipLevel > 1 then
                if jobType == nil then
                    list[#list + 1] = v
                elseif CommonUtil.EleInTable(jobType, v.JobType) then
                    list[#list + 1] = v
                end
            else
                data1 = v
            end
        end
    end

    CommonUtil.ArraySortSelections(list, sortRule, "Id")

    return list, data1
end

function CfgMgr:GetAllEquipDatasByTypeAndJob1(type, jobType, sortRule)
    if sortRule == nil then
        sortRule = Enum.TableSortRule.Up
    end
    local list = {}
    for _, v in pairs(self.EquipCfg) do
        if v.Type == type then
            if jobType == nil then
                list[#list + 1] = v
            elseif CommonUtil.EleInTable(jobType, v.JobType) then
                list[#list + 1] = v
            end
        end
    end

    CommonUtil.ArraySortSelections(list, sortRule, "Id")

    return list
end

function CfgMgr:GetEquipSuitById(id)
  return self.EquipSuitCfg[id]
end

function CfgMgr:GetFightPowerById(id)
  return self.FightPowerCfg[id]
end

function CfgMgr:GetSkillCfgById(id)
  return self.SkillCfg[id]
end

function CfgMgr:GetSkillLevelCfgById(id)
    return self.SkillLvCfg[id]
  end

function CfgMgr:GetPassiveSkillCfgById(id)
--   return self.PassiveSkillCfg[id]
    return nil
end

function CfgMgr:GetPassiveSkillCfg()
--   return self.PassiveSkillCfg
    return nil
end

function CfgMgr:GetSkillCfgByType(skillType, skillId, skillLv)
    if not skillId then return nil end
    if skillType == Enum.SkillType.Active then
    --   local skillCfgId = CommonUtil.GetSkillCfgIdByIdAndLv(skillId, skillLv or 1)
      return self:GetSkillCfgById(skillId)
    elseif skillType == Enum.SkillType.Passive then
      return self:GetPassiveSkillCfgById(skillId)
    else
      LogError("Unkown Skill Type " .. tostring(skillType))
      return nil
    end
end

--- 使用职业特征获得对应的技能树
function CfgMgr:GetSkillTreeByFeature(jobType, jobBranch, jobStage)
  if not self.SkillTreeMap then
    -- SkillTree数据拆解，方便查找
    local SkillTreeMap = {}
    for _, skillTreeData in pairs(self.SkillTreeCfg) do
      local itemJobType = skillTreeData.JobType
      local itemJobBranch = skillTreeData.JobBranch
      local itemJobStage = skillTreeData.JobStage
      local jobTypeTree = SkillTreeMap[itemJobType]
      if not jobTypeTree then
        jobTypeTree = {}
        SkillTreeMap[itemJobType] = jobTypeTree
      end
      local jobBranchTree = jobTypeTree[itemJobBranch]
      if not jobBranchTree then
        jobBranchTree = {}
        jobTypeTree[itemJobBranch] = jobBranchTree
      end
      local jobStageList = jobBranchTree[itemJobStage]
      if not jobStageList then
        jobStageList = {}
        jobBranchTree[itemJobStage] = jobStageList
      end
        if skillTreeData.beforeSkill == 0 then
            table.insert(jobStageList, skillTreeData)   
        end
    end
    self.SkillTreeMap = SkillTreeMap
  end
  local item = self.SkillTreeMap[jobType]
  if item then
    item = item[jobBranch]
    if item then
      return item[jobStage]
    end
  end
  return nil
end

function CfgMgr:GetSkillTreeCfg()
  return self.SkillTreeCfg;
end

function CfgMgr:GetSkillTreeCfgById(id)
  return self.SkillTreeCfg[id]
end

--- 使用职业特征获得对应的技能树
function CfgMgr:GetParterSkillTreeByFeature(jobType, parterId)
  if not self.ParterSkillTreeMap then
    -- SkillTree数据拆解，方便查找
    local ParterSkillTreeMap = {}
    for _, skillTreeData in pairs(self.ParterSkillTreeCfg) do
      local itemJobType = skillTreeData.JobType
      local itemParterID = skillTreeData.ParterID
      local jobTypeTree = ParterSkillTreeMap[itemJobType]
      if not jobTypeTree then
        jobTypeTree = {}
        ParterSkillTreeMap[itemJobType] = jobTypeTree
      end
      local jobList = jobTypeTree[itemParterID]
      if not jobList then
        jobList = {}
        jobTypeTree[itemParterID] = jobList
      end
        if skillTreeData.beforeSkill == 0 then
            table.insert(jobList, skillTreeData)   
        end
    end
    self.ParterSkillTreeMap = ParterSkillTreeMap
  end
  local item = self.ParterSkillTreeMap[jobType]
  if item then
    return item[parterId]
  end
  return nil
end

function CfgMgr:GetParterSkillTreeCfg()
  return self.ParterSkillTreeCfg;
end

function CfgMgr:GetParterSkillTreeCfgById(id)
  return self.ParterSkillTreeCfg[id]
end

function CfgMgr:GetSkillSlotCfgById(id)
  return self.SkillSlotCfg[id]
end

function CfgMgr:GetSkillUpEffectCfgById(id)
  return self.SkillUpEffectCfg[id]
end

function CfgMgr:GetSkillShowCfgById(id)
  return self.SkillShowCfg[id]
end

function CfgMgr:GetMarkCfg()
  return self.MarkCfg
end

function CfgMgr:GetAvatarCfgById(id)
  return self.AvatarCfg[id]
end

function CfgMgr:GetEquipRefineDataByLv(lv)
    return self.EquipRefineCfg[lv]
end

function CfgMgr:GetEquipRefineCount()
    return #self.EquipRefineCfg
end

function CfgMgr:GetCardUnlockConditionById(id)
    return self.CardUnlockCfg[id]
end

function CfgMgr:GetCardDataById(id)
    return self.CardCfg[id]
end

function CfgMgr:GetRoleAvatarById(id)
  return self.RoleAvatarCfg[id]
end

function CfgMgr:GetFashionById(id)
    return self.FashionCfg[id]
end

function CfgMgr:GetFashionCfg()
    return self.FashionCfg
end

function CfgMgr:GetFashionPaperById(id)
  return self.FashionPaperCfg[id]
end

function CfgMgr:GetCreateHairById(id)
    return self.CreateHairCfg[id]
end

function CfgMgr:GetCreateHairCfg()
  return self.CreateHairCfg
end

function CfgMgr:GetCreateHairColorById(id)
  return self.CreateHairColorCfg[id]
end

function CfgMgr:GetCreateHairColorCfg()
  return self.CreateHairColorCfg
end

function CfgMgr:GetCreateEyeById(id)
  return self.CreateEyeCfg[id]
end

function CfgMgr:GetCreateEyeCfg()
  return self.CreateEyeCfg
end

function CfgMgr:GetCreateHeadwearById(id)
  return self.CreateHeadwearCfg[id]
end

function CfgMgr:GetCreateHeadwearCfg()
  return self.CreateHeadwearCfg
end

function CfgMgr:GetRoleExpData(lv)
    return self.RoleAttributeCfg[lv]
end

function CfgMgr:GetRoleMaxLv()
    return self.RoleAttributeCfg[#self.RoleAttributeCfg].BaseLv
end

function CfgMgr:GetUIJumpData(id)
    return self.UIJumpCfg[id]
end

function CfgMgr:GetMapData(id)
    return self.MapCfg[id]
end

function CfgMgr:GetLastJobs(id)
    local list = {}
    if not id and id <= 0 then return list end
    local data = self.JobCfg[id]
    if not data then return list end
    local beforeJobId = data.BeforeJobId
    data = self.JobCfg[beforeJobId]
    while (beforeJobId and beforeJobId > 0 and data) do
      -- 避免填错数据死循环
      for i = 1, #list do
          if list[i] == data then
            LogError("find last job Error, endless loop " .. data.Id)
            return list
          end
      end
      table.insert(list, 1, data)
      beforeJobId = data.BeforeJobId
      data = self.JobCfg[beforeJobId]
    end
    return list
end

function CfgMgr:GetNextJobs(id)
    local list = {}
    local data = self.JobCfg[id]
    if data == nil then return list end

    for i = 1, #data.AfterJobId do
        list[#list + 1] = self.JobCfg[data.AfterJobId[i]]
    end

    return list
end

function CfgMgr:GetSameStageJobs(id)
    local list = {}
    local data = self.JobCfg[id]
    if data == nil then return list end

    for _,v in pairs(self.JobCfg) do
        if data.JobStage == v.JobStage then
            list[#list + 1] = v
        end
    end
    table.sort(list, CfgSort)
    return list
end

function CfgMgr:GetParterLastJobs(id)
    local list = {}
    if not id and id <= 0 then return list end
    local data = self.ParterCfg[id]
    if not data then return list end
    local beforeJobId = data.BeforeJobId
    data = self.ParterCfg[beforeJobId]
    while (beforeJobId and beforeJobId > 0 and data) do
      -- 避免填错数据死循环
      for i = 1, #list do
          if list[i] == data then
            LogError("find last job Error, endless loop " .. data.Id)
            return list
          end
      end
      table.insert(list, 1, data)
      beforeJobId = data.BeforeJobId
      data = self.ParterCfg[beforeJobId]
    end
    return list
end

function CfgMgr:GetPartnerNextJobs(id)
    local list = {}
    local data = self.ParterCfg[id]
    if data == nil then return list end

    for i = 1, #data.AfterJobId do
        list[#list + 1] = self.ParterCfg[data.AfterJobId[i]]
    end

    return list
end

function CfgMgr:GetPartnerSameStageJobs(id)
    local list = {}
    local data = self.ParterCfg[id]
    if data == nil then return list end

    for _,v in pairs(self.ParterCfg) do
        if data.JobType == v.JobType and data.JobStage == v.JobStage then
            list[#list + 1] = v
        end
    end
    table.sort(list,function(a,b)
        return a.ParterId < b.ParterId
    end)

    return list
end

function CfgMgr:GetPartnerMapItemDataById(partnerId)
    for _,v in pairs(self.ItemCfg) do
        if v.ComposeItem ~= nil and v.ComposeItem[1] == partnerId then
            return v
        end
    end
    return nil
end

function CfgMgr:GetCurMaxJobExpByLvAndStep(lv, step)
    local data = self.JobExpCfg[lv]
    step = step + 1
    if data == nil then
        return 0
    end
    if data["expRequire"..step] == nil then
        return 0
    end
    return data["expRequire"..step]
end

function CfgMgr:GetTargetTaskDataById(id)
    return self.TargetTaskCfg[id]
end

function CfgMgr:GetAllRecruitTasks()
    local list = {}
    for _, v in pairs(self.TargetTaskCfg) do
        if v.TargetReward[1][1] == Enum.ItemIds.Recruit then
            list[#list + 1] = v
        end
    end
    table.sort(list, function (a,b)
        return a.TargetTaskId < b.TargetTaskId
    end)
    return list
end

function CfgMgr:LastTargetTaskId()
    local maxId = 1
    for k,_ in pairs(self.TargetTaskCfg) do
        if k > maxId then
            maxId = k
        end
    end
    return maxId
end

function CfgMgr:GetQuickBattleCost(id)
  return self.QuickBattleCostCfg[id]
end

function CfgMgr:GetHeadPortraitDataById(id)
    return self.HeadPortraitCfg[id]
end

function CfgMgr:GetHeadPortraitDatas()
    return self.HeadPortraitCfg
end

function CfgMgr:GetArenaLevelDatas()
  return self.ArenaLevelCfg
end

function CfgMgr:GetArenaLevelById(id)
  return self.ArenaLevelCfg[id]
end

function CfgMgr:GetArenaLevelDataByScore(score)
    local levelIcon, levelName
    local minNum = 100000
    for _,v in pairs(self.ArenaLevelCfg) do
        if score <= v.ArenaLevelScore and v.ArenaLevelScore < minNum then
            levelIcon = v.LevelIcon
            levelName = v.ArenaLevelName
            minNum = v.ArenaLevelScore
        end
    end
    return levelIcon, levelName
end

function CfgMgr:GetArenaRewardDatas()
  return self.ArenaRewardCfg
end

function CfgMgr:GetCondDataById(id)
    return self.ConditionCfg[id]
end

function CfgMgr:GetLevelDataById(id)
    return self.LevelCfg[id]
end

function CfgMgr:GetLevelDataByMapAndLevel(mapId, levelId)
  local id = mapId * 10000 + levelId
  return self.LevelCfg[id]
end

function CfgMgr:GetLevelUniIdByLevelId(levelId)
    for k,v in pairs(self.LevelCfg) do
        if v.LevelId == levelId then
            return v.Id
        end
    end
    return 0
end

function CfgMgr:GetWorldBossDataById(id)
    return self.WorldBossCfg[id]
end

function CfgMgr:GetWorldPetBossDataById(id)
    return self.WorldBossChangePlayCfg[id]
end

function CfgMgr:GetRobotDataByCfgId(id)
    return self.RobotCfg[id]
end

function CfgMgr:GetMailDataByCfgId(id)
    return self.MailCfg[id]
end

function CfgMgr:GetCardResetDataByLevelAndType(lv,type)
    for _,v in pairs(self.CardReset) do
        if v.CardLv == lv and v.CardType == type then
            return v
        end
    end

    return nil
end

function CfgMgr:GetUIFuncUnLockCfgAllDatas()
    return self.UIFuncUnLockCfg
end

function CfgMgr:GetUIFuncUnLockCfgDataById(id)
    return self.UIFuncUnLockCfg[id]
end

function CfgMgr:GetUIFuncUnLockCfgNewAndNearLevelId(levelId)
    local newFuncs = {}
    local forceGuideList = {}
    local list = {}
    local levelTmp = 100000000
    for _,v in pairs(self.UIFuncUnLockCfg) do
        if v.PrePose == 0 then
            local result = true
            local newResult = true
            local isFuncLevel = false
            local isLevel = false
            if v.UnlockCond then
                if v.UnlockCond[1][1] == Enum.TaskType.Level_Battle_Count then
                    if v.UnlockCond[1][2] == levelId then
                        isFuncLevel = true
                        newResult = true
                    end
                    if v.UnlockCond[1][2] <= levelTmp and v.UnlockCond[1][2] > levelId and v.NeedNotify then
                        levelTmp = v.UnlockCond[1][2]
                        isLevel = true
                        result = false
                    end
                end
            end
            --for _,v1 in pairs(v.UnlockConds) do
            --    local conditionData = ManagerContainer.CfgMgr:GetCondDataById(v1)
            --    if conditionData.Condition[1] == Enum.TaskType.Level_Battle_Count then
            --        if conditionData.Condition[2] == levelId then
            --            isFuncLevel = true
            --            local result1 = ConditionJudge:ConditionPassResult(v1)
            --            if not result1 then
            --                newResult = false
            --            end
            --        end
            --        if conditionData.Condition[2] <= levelTmp and conditionData.Condition[2] > levelId then
            --            levelTmp = conditionData.Condition[2]
            --            isLevel = true
            --            local result1 = ConditionJudge:ConditionPassResult(v1)
            --            if not result1 then
            --                result = false
            --            end
            --        end
            --    end
            --end
            if isFuncLevel and newResult then
                if v.NeedNotify then
                    newFuncs[#newFuncs + 1] = v.Id
                end
                if v.ForceGuideGroup > 0 then
                    forceGuideList[#forceGuideList + 1] = v.Id
                end
            end

            if isLevel and not result then
                if v.NeedNotify then
                    if list[levelTmp] == nil then
                        list[levelTmp] = {}
                    end
                    list[levelTmp][#list[levelTmp] + 1] = v.Id
                end
            end
        end
    end

    local tmpKey = 100000000
    local tmpVal = {}
    for k,v in pairs(list) do
        if k < tmpKey then
            tmpKey = k
            tmpVal = v
        end
    end

    table.sort(newFuncs, NumSort)
    table.sort(tmpVal, NumSort)

    return newFuncs, tmpVal, forceGuideList
end

function CfgMgr:GetUIFuncUnLockCfgDataByUIId(id)
    local list = {}
    for _,v in pairs(self.UIFuncUnLockCfg) do
        if v.UIId == id then
            list[#list + 1] = v
        end
    end
    return list
end

function CfgMgr:GetFirstEquipCfgId()
    local minId = 1000000
    for k,_ in pairs(self.EquipCfg) do
        if k < minId then
            minId = k
        end
    end
    if minId == 1000000 then return nil end

    return minId
end

function CfgMgr:GetCompetitionDataById(id)
    return self.CompetitionCfg[id]
end

function CfgMgr:GetCompetitionData()
    return self.CompetitionCfg
end

function CfgMgr:GetCompetitionDatasByType(competitionId)
    local list = {}
    for k,v in pairs(self.CompetitionCfg) do
        if v.CompetitionId == competitionId then
            list[#list + 1] = v
        end
    end
    table.sort(list, CfgSort)
    return list
end

function CfgMgr:GetAllSelectionCompetitionDatas()
    local list = nil
    for i = 1, #self.CompetitionCfg do
        if self.CompetitionCfg[i].CompetitionType == 2 then
            if list == nil then
                list = {}
            end
            list[#list + 1] = self.CompetitionCfg[i]
        end
    end
    if list ~= nil then
        table.sort(list, CfgSort)
    end
    return list
end

function CfgMgr:GetCompetitionDatasByRank(list, recruitId, rank)
    if list == nil then
        return
    end
    local selectionCompetition = list[recruitId]
    if selectionCompetition == nil then return end
    if selectionCompetition.CompetitionCondition then
        for k,v in pairs(selectionCompetition.CompetitionCondition) do
            if v[3] > 0 then
                if rank >= v[2] and rank <= v[3] then
                    return selectionCompetition, k
                end
            else
                if rank >= v[2]then
                    return selectionCompetition, k
                end
            end
        end
    end

    return
end

function CfgMgr:GetCompetitionTypeRange()
    local min = 1000
    local max = 0
    for _,v in pairs(self.CompetitionCfg) do
        if v.CompetitionType < min then
            min = v.CompetitionType
        end
        if v.CompetitionType > max then
            max = v.CompetitionType
        end
    end
    return min, max
end

function CfgMgr:GetStoryDataById(id)
    return self.StoryCfg[id]
end

function CfgMgr:GetAllStoryDatasByType(type)
    local list
    for _, v in pairs(self.StoryCfg) do
        if v.Condition ~= nil then
            if list == nil then
                list = {}
            end
            if v.Condition[1] == type then
                list[#list + 1] = v
            end
        end
    end
    return list
end

function CfgMgr:GetSameStoryGroupDatasById(id)
    local list
    local cfgData = self:GetStoryDataById(id)
    if cfgData.Group ~= nil then
        for _, v in pairs(cfgData.Group) do
            if list == nil then
                list = {}
            end
            local cfgData1 = self:GetStoryDataById(v)
            list[#list + 1] = cfgData1
        end
    end
    return list
end

function CfgMgr:GetStoryPerformDataById(id)
    local list = {}
    for k, v in pairs(self.StroyPerformCfg) do
        if v.StoryId == id then
            list[#list + 1] = v
        end
    end
    table.sort(list, CfgSort)
    return list
end

function CfgMgr:GetStoryChapterById(id)
  return self.StoryChapterCfg[id]
end

function CfgMgr:GetStorySectionById(id)
  return self.StorySectionCfg[id]
end

function CfgMgr:GetLoadingCfg(id)
  return self.LoadingCfg[id];
end

function CfgMgr:GetNoticeCfg(id)
    return self.NoticeCfg[id];
end

function CfgMgr:GetSignInCfg(id)
    return self.SignInCfg[id];
end

function CfgMgr:GetMaxSignDay()
    return #self.SignInCfg
end

function CfgMgr:GetNoticeCfgAll()
    return self.NoticeCfg;
end

function CfgMgr:GetShopTypeCfg()
    return self.ShopTypeCfg
end

function CfgMgr:GetShopTypeCfgById(id)
    return self.ShopTypeCfg[id]
end

--根据商品类型取商品表格中的数据
function CfgMgr:GetShopCfgsByGoodsType(goodsType)
    if not self.ShopCfgMap then
        local ShopCfgMap = {}
        local itemShopCfgs, itemGoodsType
        for _, value in pairs(self.ShopCfg) do
            itemGoodsType = value.GoodsType
            itemShopCfgs = ShopCfgMap[itemGoodsType]
            if not itemShopCfgs then
            itemShopCfgs = {}
            ShopCfgMap[itemGoodsType] = itemShopCfgs
        end
        table.insert(itemShopCfgs, value)
        end
        -- 排序
        local SortSule = function(a, b)
        return a.SortId < b.SortId
        end
        for _, value in pairs(ShopCfgMap) do
            table.sort(value, SortSule)
        end
        self.ShopCfgMap = ShopCfgMap
    end
    return self.ShopCfgMap[goodsType]
end

function CfgMgr:GetShopCfgByGoodsId(goodsId)
    return self.ShopCfg[goodsId]
end

function CfgMgr:GetRuneShopCfgByFeature(runeShopType, runeShopSubType, id)
    if runeShopType == Enum.RuneShopType.MonthCard then
        return self.RuneShopMonthCardCfg[id]
    elseif runeShopType == Enum.RuneShopType.Gifts then
        local data = self.RuneShopGiftsCfg[id]
        if data and data.Type == runeShopSubType then
            return data
        else
            return nil
        end
    elseif runeShopType == Enum.RuneShopType.LimitTime then
        return self.RuneShopLimitCfg[id]
    elseif runeShopType == Enum.RuneShopType.RushTower then
        return self.RuneShopRankTowerCfg[id]
    elseif runeShopType == Enum.RuneShopType.RushArena then
        return self.RuneShopRankArenaCfg[id]
    elseif runeShopType == Enum.RuneShopType.RushMap then
        return self.RuneShopRankMapCfg[id]
    elseif runeShopType == Enum.RuneShopType.RushPet then
        return self.RuneShopRankPetCfg[id]
	elseif runeShopType == Enum.RuneShopType.GuildWar then
        return self.RuneShopGuildBattleCfg[id]
    elseif runeShopType == Enum.RuneShopType.RushSkill then
        return self.RuneShopRankSkillCfg[id]
    elseif runeShopType == Enum.RuneShopType.IdolShop then
        return self.RuneShopRankAidouluCfg[id]
    end
    return nil
end

function CfgMgr:GetEmojiCfg()
    return self.EmojiCfg
end

function CfgMgr:GetUIRedPointCfgDatas()
    return self.UIRedPointCfg
end

function CfgMgr:GetUIRedPointCfgDataByUIId(id)
    local list = {}
    for _,v in pairs(self.UIRedPointCfg) do
        if v.UIId == id then
            list[#list + 1] = v
        end
    end
    return list
end

function CfgMgr:GetForceGuideDatas()
    return self.ForceGuideCfg
end

function CfgMgr:GetForceGuideDataById(id)
    return self.ForceGuideCfg[id]
end

function CfgMgr:GetForceGuideGroupDatasById(groupId)
    local list = {}
    for i = 1, #self.ForceGuideCfg do
        if self.ForceGuideCfg[i].Group == groupId then
            list[#list + 1] = self.ForceGuideCfg[i]
        end
    end
    return list
end

function CfgMgr:GetGMCfg()
    return self.GMCfg;
end

function CfgMgr:GetMissionById(id)
    return self.MissionCfg[id];
end

function CfgMgr:GetLineMissionById(id)
    return self.LineMissionCfg[id];
end

function CfgMgr:GetClimbingTowerCfg()
    return self.ClimbingTowerCfg
end

function CfgMgr:GetClimbingTowerCfgById(id)
    return self.ClimbingTowerCfg[id]
end

-- function CfgMgr:GetSkillExpBattleCfgById(evilLevel)
--     return self.SkillExpBattleCfg[evilLevel]
-- end

function CfgMgr:GetActRewardCfg()
    return self.ActRewardCfg;
end

-- function CfgMgr:GetRefreshCDCost(leftCD)
--     if self.EvilRefreshCDCostCfg == nil then
--         return 0
--     end

--     for i=1, #self.EvilRefreshCDCostCfg do
--         if leftCD <= self.EvilRefreshCDCostCfg[i].Time then
--             return self.EvilRefreshCDCostCfg[i].Cost[1][2]
--         end
--     end
--     return 0
-- end

function CfgMgr:GetGuildBadgeCfg()
    return self.GuildBadgeCfg
end

function CfgMgr:GetGuildBadgeCfgById(id)
    return self.GuildBadgeCfg[id]
end

function CfgMgr:GetGuildLvCfg()
    return self.GuildLvCfg
end

function CfgMgr:GetGuildLvCfgById(id)
    return self.GuildLvCfg[id]
end

function CfgMgr:GetGuildHuntBossCfg()
    return self.GuildHuntBossCfg
end

function CfgMgr:GetGuildHuntBossCfgById(id)
    return self.GuildHuntBossCfg[id]
end

function CfgMgr:GetGuildHuntBossAwardCfgById(id)
    return self.GuildHuntBossRewardCfg[id]
end

function CfgMgr:GetCardIdentificationDatasByQuality(quality)
    local list
    for _,v in pairs(self.CardIdentification) do
        if v.CardQuality == quality then
            if not list then
                list = {}
            end

            list[#list + 1] = v
        end
    end
    return list
end

function CfgMgr:GetCardIdentificationDatasById(id)
    return self.CardIdentification[id]
end

function CfgMgr:GetHeadFrameById(_id)
    return self.HeadFrameCfg[_id]
end

function CfgMgr:GetAllPetDatas()
    return self.PetCfg
end

function CfgMgr:GetPetDataById(id)
    return self.PetCfg[id]
end

function CfgMgr:GetPetDatasByQuality(quality)
    local list
    for _,v in pairs(self.PetCfg) do
        if v.Quality == quality then
            if list == nil then
                list = {}
            end
            list[#list + 1] = v
        end
    end
    return list
end

function CfgMgr:GetPetProgressCfgDataById(id)
    return self.PetProgressCfg[id]
end

function CfgMgr:GetPetExpCfgMaxData()
    return self.PetExpCfg[#self.PetExpCfg].petLevel
end

function CfgMgr:GetPetExpCfgDataById(level)
    return self.PetExpCfg[level]
end

function CfgMgr:GetAllHeadFrameData()
    return self.HeadFrameCfg;
end

function CfgMgr:GetAllPetPartnerDatas()
    return self.PetpartnerCfg;
end

function CfgMgr:GetPetPartnerDataById(cfgId)
    return self.PetpartnerCfg[cfgId];
end

function CfgMgr:GetAllSummonCfg()
    return self.SummonCfg
end

function CfgMgr:GetSummonCfgById(id)
    return self.SummonCfg[id]
end

function CfgMgr:GetAllVipCfg()
    if Constant.OpenPay then
        return self.VipCfg
    end
    return nil
end

function CfgMgr:GetVipCfgById(cfgId)
    if Constant.OpenPay then
        return self.VipCfg[cfgId]
    end
    return nil
end

function CfgMgr:GetAllInvitationTaskDatas()
    return self.InvitationTaskCfg
end

function CfgMgr:GetInvitationTaskDataByCfgId(cfgId)
    return self.InvitationTaskCfg[cfgId]
end

function CfgMgr:GetNextActivitiesTiredChargeCfgById(index, day)
    local closestDay = self.ActivitiesTiredChargeCfg[1].Day
    local closestCfgData = self.ActivitiesTiredChargeCfg[1]
    for i = 1, #self.ActivitiesTiredChargeCfg do
        if self.ActivitiesTiredChargeCfg[i].Day <= day and self.ActivitiesTiredChargeCfg[i].Day > closestDay then
            closestDay = self.ActivitiesTiredChargeCfg[i].Day
            closestCfgData = self.ActivitiesTiredChargeCfg[i]
        end
    end
    for i = closestCfgData.Id, #self.ActivitiesTiredChargeCfg do
        if self.ActivitiesTiredChargeCfg[i].Index > index then
            return self.ActivitiesTiredChargeCfg[i]
        end
    end

    return nil
end

function CfgMgr:GetNextActivitiesTiredChargeCfgByNum(num)
    for i = 1, #self.ActivitiesTiredChargeCfg do
        if self.ActivitiesTiredChargeCfg[i].RechargeAmount > num then
            return self.ActivitiesTiredChargeCfg[i]
        end
    end
    return nil
end

function CfgMgr:GetActivitiesDiscountsCfgById(id)
    return self.ActivitiesDiscountsCfg[id]
end

function CfgMgr:GetHundredDojoCfg()
    return self.HundredDojoCfg
end

function CfgMgr:GetHundredDojoCfgById(id)
    return self.HundredDojoCfg[id]
end

function CfgMgr:GetOnlineRwards()
    return self.OnlineRewardsCfg 
end

function CfgMgr:GetRushListCfgByTypeAndIdx(type, idx)
    local list
    for i = 1, #self.RushListCfg do
        if self.RushListCfg[i].RankType == type and self.RushListCfg[i].RankId == idx then
            if not list then list = {} end

            list[#list + 1] = self.RushListCfg[i]
        end
    end
    return list
end

function CfgMgr:GetRushListTargetCfgByTypeAndIdx(type, idx)
    local list
    for i = 1, #self.RushListTargetCfg do
        if self.RushListTargetCfg[i].RankType == type and self.RushListTargetCfg[i].RankId == idx then
            if not list then list = {} end

            list[#list + 1] = self.RushListTargetCfg[i]
        end
    end
    return list
end

function CfgMgr:GetRuneShopRankTowerCfgByIdx(idx)
    local list
    for i = 1, #self.RuneShopRankTowerCfg do
        if self.RuneShopRankTowerCfg[i].RankId == idx then
            if not list then list = {} end

            list[#list + 1] = self.RuneShopRankTowerCfg[i]
        end
    end
    return list
end

function CfgMgr:GetRuneShopRankArenaCfgByIdx(idx)
    local list
    for i = 1, #self.RuneShopRankArenaCfg do
        if self.RuneShopRankArenaCfg[i].RankId == idx then
            if not list then list = {} end

            list[#list + 1] = self.RuneShopRankArenaCfg[i]
        end
    end
    return list
end

function CfgMgr:GetRuneShopExploreCfg()
    if not self.RuneShopExploreCfg then
        self.RuneShopExploreCfg = require('RuneShopExploreCfg')
    end
    return self.RuneShopExploreCfg
end

function CfgMgr:GetRuneShopExploreCfgByRound(round)
    local RSExploreCfg = self:GetRuneShopExploreCfg()
    return RSExploreCfg and RSExploreCfg[round] or nil
end

function CfgMgr:GetRuneShopExploreRewardCfg()
    if not self.RuneShopExploreRewardCfg then
        self.RuneShopExploreRewardCfg = require('RuneShopExploreRewardCfg')
    end
    return self.RuneShopExploreRewardCfg
end

function CfgMgr:GetRuneShopExploreRewardCfgById(id)
    local RuneShopExploreRewardCfg = self:GetRuneShopExploreRewardCfg()
    return RuneShopExploreRewardCfg and RuneShopExploreRewardCfg[id] or nil
end

function CfgMgr:GetRShopRewardsCfgByRound(round)
    if not self.RuneShopRoundMap then
        self.RuneShopRoundMap = {}
    end
    if not self.RuneShopRoundMap[round] then
        local ls ={}
        for key, value in pairs(self:GetRuneShopExploreRewardCfg()) do
            if  value.ActiveRound == round then
                ls[#ls+1] = value
            end
        end
        table.sort(ls, function(a, b)
            return a.ID < b.ID
        end)
        self.RuneShopRoundMap[round] = ls
    end
    return self.RuneShopRoundMap[round]
end

function CfgMgr:GetAllKeepSakeCfgDatas()
    return self.KeepSakeCfg
end

function CfgMgr:GetKeepSakeCfgDataById(id)
    return self.KeepSakeCfg[id]
end

function CfgMgr:GetKeepSakeCfgDatasByLevel(lv)
    local list = {}
    for _,v in pairs(self.KeepSakeCfg) do
        if v.CollectionLevel == lv then
            list[#list + 1] = v
        end
    end
    return list
end

function CfgMgr:GetCardSuitNewCfgById(id)
    return self.CardSuitNewCfg[id]
end

function CfgMgr:GetAllCardSuitNewCfg()
    return self.CardSuitNewCfg
end

function CfgMgr:GetSkillSuitNewCfgById(id)
    return self.SkillSuitNewCfg[id]
end

function CfgMgr:GetAllSkillSuitNewCfg()
    return self.SkillSuitNewCfg
end

function CfgMgr:GetFightCfgByAttrId(id)
    return self.FightCfg[id]
end

function CfgMgr:GetAllFashionSuitDatas()
    return self.FashionSuitCfg
end

function CfgMgr:GetFashionSuitDataById(cfgId)
    return self.FashionSuitCfg[cfgId]
end

function CfgMgr:GetFashionMaxLv()
    return self.FashionLevelUp[#self.FashionLevelUp].Level
end

function CfgMgr:GetFashionLvDataByLv(lv)
    return self.FashionLevelUp[lv]
end

function CfgMgr:GetGuildWarBuffCfg()
    if not self.GuildWarBuffCfg then
        self.GuildWarBuffCfg = require('GuildWarBuffCfg')
    end
    return self.GuildWarBuffCfg
end

function CfgMgr:GetActivityRoulettelCfgById(id)
    local Cfg = self.ActivityRoulettelCfg[id]
    if Cfg then
        return Cfg
    end
    return nil
end

function CfgMgr:GetCompetitionPrizeWheelCfgById(id)
    local Cfg = self.CompetitionPrizeWheelCfg[id]
    if Cfg then
        return Cfg
    end
    return nil
end

function CfgMgr:GetGuildWarBuffCfgById(id)
    local GuildWarBuffCfg = self:GetGuildWarBuffCfg()
    if GuildWarBuffCfg then
        return GuildWarBuffCfg[id]
    end
    return nil
end

function CfgMgr:GetGuildWarDojoCfg()
    if not self.GuildWarDojoCfg then
        self.GuildWarDojoCfg = require('GuildWarDojoCfg')
    end
    return self.GuildWarDojoCfg
end

function CfgMgr:GetGuildWarDojoCfgById(id)
    local GuildWarDojoCfg = self:GetGuildWarDojoCfg()
    if GuildWarDojoCfg then
        return GuildWarDojoCfg[id]
    end
    return nil
end

function CfgMgr:GetGuildWarAgainstCfg()
    if not self.GuildWarAgainstCfg then
        self.GuildWarAgainstCfg = require('GuildWarAgainstCfg')
    end
    return self.GuildWarAgainstCfg
end

function CfgMgr:GetGuildWarAgainstCfgById(id)
    local GuildWarAgainstCfg = self:GetGuildWarAgainstCfg()
    if GuildWarAgainstCfg then
        return GuildWarAgainstCfg[id]
    end
    return nil
end

function CfgMgr:GetActivityGoddessGiftCfgByActId(actId)
    if not self.ActivityGoddessGiftCfg then
        self.ActivityGoddessGiftCfg = {}
    end
    if not self.ActivityGoddessGiftCfg[actId] then
        local ls = {}
        self.ActivityGoddessGiftCfg[actId] = ls
        local cfgs = require('ActivitiesGiftCfg')
        for _,cfg in pairs(cfgs) do
            if cfg.Activityid == actId then
                ls[#ls+1] = cfg
            end
        end
        table.sort(ls, function (a, b)
            return a.SortId < b.SortId
        end)
    end
    return self.ActivityGoddessGiftCfg[actId]
end

function CfgMgr:GetActivityGoddessLoveCfgByActId(actId)
    if not self.ActivityGoddessLoveCfg then
        self.ActivityGoddessLoveCfg = {}
    end
    if not self.ActivityGoddessLoveCfg[actId] then
        local ls = {}
        self.ActivityGoddessLoveCfg[actId] = ls
        local cfgs = require('ActivitieslikabilityCfg')
        for _,cfg in pairs(cfgs) do
            if cfg.Activityid == actId then
                ls[cfg.Likelevel] = cfg
            end
        end
    end
    return self.ActivityGoddessLoveCfg[actId]
end

function CfgMgr:GetActivityGoddessLoveCfgByLv(actId, lv)
    local ActivityGoddessLoveCfg = self:GetActivityGoddessLoveCfgByActId(actId)
    if ActivityGoddessLoveCfg then
        return ActivityGoddessLoveCfg[lv]
    end
    return nil
end

function CfgMgr:ClearActivityGoddessCfg()
    self.ActivityGoddessGiftCfg = nil
    self.ActivityGoddessLoveCfg = nil
end

function CfgMgr:GetPetEquipCfgDataById(id)
    if not self.PetEquipCfg then
        self.PetEquipCfg = require('PetEquipCfg')
    end
    return self.PetEquipCfg[id]
end

function CfgMgr:GetPetEquipExpCfgDataByLvAndCfgId(lv, cfgId)
    if not self.PetEquipExpCfg then
        self.PetEquipExpCfg = require('PetEquipExpCfg')
    end
    for _,v in pairs(self.PetEquipExpCfg) do
        if v.PetEquipLevel == lv and v.PetEquipID == cfgId then
            return v
        end
    end
    return nil
end

--根据压制值 计算携带buff
function CfgMgr:GetPresspointPvPCfg(ourPvPVal,enemyPvPVal)
    local BuffId = -1
    local IsLess = ourPvPVal < enemyPvPVal
    local buffIdx = 1
    if not IsLess then
        buffIdx = 2
    end
    local DetalVal = math.abs(ourPvPVal - enemyPvPVal)

    local tbcfg = {}
    local cfgData = self.PresspointPvPCfg
    if not cfgData then
        LogError("PresspointPvPCfg Not Find")
        return IsLess,BuffId
    end 

    for _,v in pairs(cfgData) do
        tbcfg[#tbcfg+1] = v
    end        

    table.sort(
        tbcfg,
        function(v1, v2)
            return v1.TriggerConditions < v2.TriggerConditions
        end
    )
    --LogError(Inspect(tbcfg))
    for i = 1,#tbcfg do
        local cfg = tbcfg[i]
        if cfg.TriggerConditions <= DetalVal then
            BuffId = cfg.buffid[buffIdx]
        else
            break  
        end
    end 
    return IsLess,BuffId
end

function CfgMgr:GetPetEquipSuitCfgDataByQuality(quality)
    if not self.PetEquipSuitCfg then
        self.PetEquipSuitCfg = require('PetEquipSuitCfg')
    end
    for _,v in pairs(self.PetEquipSuitCfg) do
        if v.Amount and v.Amount[1] and v.Amount[1][1] == quality then
            return v
        end
    end
    return nil
end

function CfgMgr:GetVoyageAirShipCfg()
    if not self.VoyageAirShipCfg then
        self.VoyageAirShipCfg = require('TransportCfg')
    end
    return self.VoyageAirShipCfg
end

function CfgMgr:GetVoyageAirShipCfgById(id)
    local VoyageAirShipCfg = self:GetVoyageAirShipCfg()
    return VoyageAirShipCfg and VoyageAirShipCfg[id] or nil
end

function CfgMgr:GetArtifactCfgDataByCfgId(cfgId)
    if not self.ArtifactCfg then
        self.ArtifactCfg = require 'ArtifactCfg'
    end
    for _,v in pairs(self.ArtifactCfg) do
        if v.Id == cfgId then
            return v
        end
    end

    return nil
end

function CfgMgr:GetArtifactExpCfgCostByLv(lv)
    if not self.ArtifactExpCfg then
        self.ArtifactExpCfg = require 'ArtifactExpCfg'
    end
    for _,v in pairs(self.ArtifactExpCfg) do
        if v.ArtifactLevel == lv then
            return v.UpgradeCost
        end
    end

    return nil
end

function CfgMgr:GetTopTowerRewardCfgDataByLv(lv)
    if not self.TopTowerCfgReward then
        self.TopTowerCfgReward = require "TopTowerCfgReward"
    end
    return self.TopTowerCfgReward[lv]
end

function CfgMgr:Destroy()
    for k,v in pairs(self) do
        self[k] = nil
    end


    if tolua.getpeer(self) ~= nil then
		  tolua.setpeer(self, nil)
    end
end

return CfgMgr