local BattleFailedTipsMgr = class("BattleFailedTipsMgr")

function BattleFailedTipsMgr:ctor()
    self.checkTipsData = nil
    self.bInited = false
end

function BattleFailedTipsMgr:Init()
    if self.bInited then
        return
    end

    local cfg = ManagerContainer.CfgMgr:GetBattleFailedTipsCfg()
    if cfg ~= nil then
        self.checkTipsData = {}
        for k,v in pairs(cfg) do
            self.checkTipsData[#self.checkTipsData+1] = v
        end
        self:SortData()
    end
end

function BattleFailedTipsMgr:SortData()
    if self.checkTipsData == nil or #self.checkTipsData < 2 then
        return
    end 

    table.sort(
        self.checkTipsData,
        function(a, b)
            return a.Priority < b.Priority
        end
    )
end

function BattleFailedTipsMgr:CheckShowTips(cnt,inBattleType)
    self:Init()
    local tips = {}
    for i = 1, #self.checkTipsData do
        local ret, heroUid = self:CheckTipCondition(self.checkTipsData[i],inBattleType)
        if ret then
            self.checkTipsData[i].params = heroUid
            tips[#tips+1] = self.checkTipsData[i]
            if #tips == cnt then
                return tips
            end
        end
    end
    return tips
end

-- 1：属性点
-- 2：上阵伙伴数量
-- 3：技能经验的分配
-- 4：有高级装备可以穿戴
-- 5: 有高级装备可以升级
-- 6：有高级卡片可以插卡
-- 7：卡片可以升级
-- 8:24件装备都可以精炼
-- 9: 使用的宠物数量判断
-- 10：当天是否使用过时光之力
-- 11：调整阵容
-- 12：提升角色等级
-- 13：调整技能顺序
-- 14: 上阵伙伴升级
-- 15：召唤
function BattleFailedTipsMgr:CheckTipCondition(tipData,inBattleType)
    if tipData == nil then
        return false
    end

    if tipData.FunId ~= nil then
        for i =1, #tipData.FunId do
            local fId = tipData.FunId[i]
            if fId > 0 and (not ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(fId)) then
                return false
            end
        end
    end

    local canShow = false
    if tipData.ShowBattleType ~= nil then
        for i = 1, #tipData.ShowBattleType do
            if tipData.ShowBattleType[i] == inBattleType then
                canShow = true
                break
            end
        end
    end

    if not canShow then
        return false
    end

    if tipData.Type == 1 then
        return self:CheckHeroAttrPoint()
    elseif tipData.Type == 2 then
        return self:CheckBattleHeroCnt()
    elseif tipData.Type == 3 then
        return self:CheckAvailableSkillExp()
    elseif tipData.Type == 4 then
        return self:CheckEquipWearable()
    elseif tipData.Type == 5 then
        return self:CheckEquipCanUpgrade()
    elseif tipData.Type == 6 then
        return self:CheckAvailableCard()
    elseif tipData.Type == 7 then
        return self:CheckCardCanUpgrade()
    elseif tipData.Type == 8 then
        return self:CheckEquipCanRefine()
    elseif tipData.Type == 9 then
        return self:CheckUsedPetCnt()
    elseif tipData.Type == 10 then
        return self:CheckUnusedQuickBattle()
    elseif tipData.Type == 14 then
        return self:CheckParnterLvup()
    else
        return  true
    end
end

function BattleFailedTipsMgr:CheckHeroAttrPoint()
    local teamData = ManagerContainer.DataMgr.UserData:GetTeamData(true)
    if teamData == nil then
        return false, 0
    end

    local ret = false
    for i = 1, #teamData do
        if ManagerContainer.RedPointMgr.HeroRPCtr:GetAttrPointRPStatus(teamData[i].uid) then
            ret = true
            break
        end
    end

    local maxPointNum = 0
    local maxPointUid = 0
    if ret then
        for i = 1, #teamData do
            local pointNum = 0
            if teamData[i].uid == 1 then
                pointNum = SDataUtil.InvConvert(ManagerContainer.DataMgr.UserData:GetRoleDataAttrPoints())
            else
                pointNum = SDataUtil.InvConvert(ManagerContainer.DataMgr.PartnerData:GetRoleDataAttrPoints(teamData[i].uid))
            end
            if pointNum > maxPointNum then
                maxPointUid = teamData[i].uid
                maxPointNum = pointNum
            end
        end
    end

    return ret,maxPointUid
end

function BattleFailedTipsMgr:CheckParnterLvup()
    local teamData = ManagerContainer.DataMgr.UserData:GetTeamData(true)
    if teamData == nil then
        return false
    end

    local minLevel = 100000
    local minLevelHeroUid = 0

    for i = 1, #teamData do
        local uid = teamData[i].uid
        if uid ~= 1 then
            local status = ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerLvUpRPStatusById(uid)
            if status then
                if teamData[i].lv < minLevel then
                    minLevel = teamData[i].lv
                    minLevelHeroUid = uid
                end
            end
        end
    end

    return minLevelHeroUid > 0, minLevelHeroUid
end

function BattleFailedTipsMgr:CheckBattleHeroCnt()
    local ownedNum = 0
    local inBattleNum = 0
    local maxLevelUid = 0
    local maxLevel = 0
    local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
	for _,v in pairs(partnerDatas) do
        if v ~= nil then
            if v.owned then
                ownedNum = ownedNum + 1
            end
            if v.isBattle then
                inBattleNum = inBattleNum + 1
            else
                if v.owned and v.baseLevel > maxLevel then
                    maxLevel = v.baseLevel
                    maxLevelUid = v.id
                end
            end
		end
    end
    return inBattleNum < 3 and ownedNum > inBattleNum, maxLevelUid
end

function BattleFailedTipsMgr:CheckAvailableSkillExp()
    local teamData = ManagerContainer.DataMgr.UserData:GetTeamData(true)
    if teamData == nil then
        return false, 0
    end

    local maxSkillLvUid = 0
    local maxSkillLevel = 0
    local maxLevelSkillId = 0
    local skillExp = ManagerContainer.DataMgr.UserData:GetCruise()
    for i = 1, #teamData do
        local skills = teamData[i].skills
        if skills ~= nil then
            for j=1, #skills do
                local skill = skills[j]
                if skill.lv > maxSkillLevel then
                    maxSkillLevel = skill.lv
                    maxLevelSkillId = skill.skillId
                    maxSkillLvUid = teamData[i].uid
                end
            end
        end
    end

    local ret = false
    if maxLevelSkillId > 0 then
        if maxSkillLvUid == 1 then
            local skillCfg = ManagerContainer.CfgMgr:GetSkillTreeCfgById(maxLevelSkillId)
            if skillCfg  ~= nil then
                local UpGradeCost = ManagerContainer.CfgMgr:GetSkillDemandCfgUpGradeCostById(skillCfg.OpenLevel)
                if UpGradeCost ~= nil then
                    local costCfg = UpGradeCost[maxSkillLevel]
                    if costCfg ~= nil then
                        ret = skillExp >= costCfg[2]
                    end
                end
            end
        else
            local skillCfg = ManagerContainer.CfgMgr:GetParterSkillTreeCfgById(maxLevelSkillId)
            if skillCfg ~= nil then
                local UpGradeCost = ManagerContainer.CfgMgr:GetSkillDemandCfgUpGradeCostById(skillCfg.OpenLevel)
                if UpGradeCost ~= nil then
                    local costCfg = UpGradeCost[maxSkillLevel]
                    if costCfg ~= nil then
                        ret = skillExp >= costCfg[2]
                    end
                end
            end
        end
    end
    return ret,maxSkillLvUid
end

function BattleFailedTipsMgr:CheckEquipWearable()
    local teamData = ManagerContainer.DataMgr.UserData:GetTeamData(true)
    if teamData == nil then
        return false
    end

    local maxFightPowerUid = 0
    local maxFightPower = 0

    for i = 1, #teamData do
        local RPStatus = ManagerContainer.RedPointMgr.HeroRPCtr:GetEquipDressRPByUid(teamData[i].uid)
        if RPStatus ~= nil then
            local tempRet = false
            for j =1, #RPStatus do
                if RPStatus[j] then
                    tempRet = true
                    break
                end
            end
            if tempRet then
                local fightPower = ManagerContainer.DataMgr.UserData:GetSlotFightPower(teamData[i].uid)
                if fightPower > maxFightPower then
                    maxFightPower = fightPower
                    maxFightPowerUid = teamData[i].uid
                end
            end
        end
    end
    -- LogError("maxFightPowerUid = " .. tostring(maxFightPowerUid))
    return maxFightPowerUid > 0, maxFightPowerUid
end

function BattleFailedTipsMgr:CheckEquipCanUpgrade()
    local teamData = ManagerContainer.DataMgr.UserData:GetTeamData(true)
    if teamData == nil then
        return false
    end

    local maxFightPowerUid = 0
    local maxFightPower = 0

    for i = 1, #teamData do
        local RPStatus = ManagerContainer.RedPointMgr.HeroRPCtr:GetEquipUpgradeRPByUid(teamData[i].uid)
        if RPStatus~= nil then
            local tempRet = false
            for j =1, #RPStatus do
                if RPStatus[j] then
                    tempRet = true
                    break
                end
            end
            if tempRet then
                local fightPower = ManagerContainer.DataMgr.UserData:GetSlotFightPower(teamData[i].uid)
                if fightPower > maxFightPower then
                    maxFightPower = fightPower
                    maxFightPowerUid = teamData[i].uid
                end
            end
        end
    end
    return maxFightPowerUid > 0, maxFightPowerUid
end

function BattleFailedTipsMgr:CheckEquipCanRefine()
    local teamData = ManagerContainer.DataMgr.UserData:GetTeamData(true)
    if teamData == nil then
        return false
    end
    
    if #teamData < 4 then
        return false
    end

    local refineCnt = 0
    for i = 1, #teamData do
        local RPStatus = ManagerContainer.RedPointMgr.HeroRPCtr:GetEquipRefineRPByUid(teamData[i].uid)
        if RPStatus~= nil then
            for j =1, #RPStatus do
                if RPStatus[j] then
                    refineCnt = refineCnt + 1
                end
            end
        end
    end

    local ret = refineCnt == (#teamData * 6)
    local maxFightPowerUid = 0
    local maxPower = 0
    if ret then
        for i = 1,#teamData do
            local fightPower = ManagerContainer.DataMgr.UserData:GetSlotFightPower(teamData[i].uid)
            if fightPower > maxPower then
                maxPower = fightPower
                maxFightPowerUid = teamData[i].uid
            end
        end
    end

    return ret, maxFightPowerUid
end

function BattleFailedTipsMgr:CheckAvailableCard()
    local teamData = ManagerContainer.DataMgr.UserData:GetTeamData(true)
    if teamData == nil then
        return false
    end

    local maxFightPowerUid = 0
    local maxPower = 0
 
    for i = 1, #teamData do
        if ManagerContainer.RedPointMgr.HeroRPCtr:GetRoleCardSlotEmptyRP(teamData[i].uid) then
            local fightPower = ManagerContainer.DataMgr.UserData:GetSlotFightPower(teamData[i].uid)
            if fightPower > maxPower then
                maxPower = fightPower
                maxFightPowerUid = teamData[i].uid
            end
        end
    end
    return maxFightPowerUid > 0, maxFightPowerUid
end

function BattleFailedTipsMgr:CheckCardCanUpgrade()
    local teamData = ManagerContainer.DataMgr.UserData:GetTeamData(true)
    if teamData == nil then
        return false
    end

    local maxFightPowerUid = 0
    local maxPower = 0
 
    for i = 1, #teamData do
        if ManagerContainer.RedPointMgr.HeroRPCtr:GetRoleCardSlotUpRP(teamData[i].uid) then
            local fightPower = ManagerContainer.DataMgr.UserData:GetSlotFightPower(teamData[i].uid)
            if fightPower > maxPower then
                maxPower = fightPower
                maxFightPowerUid = teamData[i].uid
            end
        end
    end
    return maxFightPowerUid > 0,maxFightPowerUid
end

function BattleFailedTipsMgr:CheckUsedPetCnt()

    local teamData = ManagerContainer.DataMgr.UserData:GetTeamData(true)
    if teamData == nil then
        return false
    end

    local unlockedPetSlotCnt = ManagerContainer.DataMgr.PetDataMgr:GetBattleUnlockSlotCount()
    local pets = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
    local  totalCnt = 0
    if pets ~= nil then
        totalCnt = #pets
    end

    local usedPetCnt = 0

    for i = 1, #teamData do
        if teamData[i].petId > 0 then
            usedPetCnt = usedPetCnt + 1
        end
    end

    return usedPetCnt < unlockedPetSlotCnt and totalCnt > usedPetCnt and usedPetCnt < 4
end

function BattleFailedTipsMgr:CheckUnusedQuickBattle()
    return ManagerContainer.LuaBattleMgr:UsedQuickBattleTimes() == 0
end

return BattleFailedTipsMgr