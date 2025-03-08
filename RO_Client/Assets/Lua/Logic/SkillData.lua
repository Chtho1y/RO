--[[
    数据说明
    unlockSkillMap = {
        [skillId] = {
            ['skillId'] = skillId,
            ['skillLv'] = skillLv,
        }
    }

    slotSkills = {
        [1] = {
            ['skillId'] = skillId,
            ['isUnlock'] = isUnlock,
            ['defaultSkillId'] = defaultSkillId,
        }
    }
]]

local SkillData = class("SkillData")

function SkillData:ctor()
    self.unlockSkillMap = nil
    self.slotSkills = nil
    self.advanceSkillMap = nil
    self.currPress = 0
    self.maxPress = 0
end

function SkillData:Clear()
    self.unlockSkillMap = nil
    self.slotSkills = nil
    self.advanceSkillMap = nil
    self.currPress = 0
    self.maxPress = 0
end

function SkillData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function SkillData:InitData(data)
    self:Clear()
    self:InitJobSkillData(data.job_skill_list)
    self:InitSlotSkillData(data.skill_list)
end

function SkillData:InitJobSkillData(jobSkillList, newSkills, upLevelSkills, downLevelSkills)
    local unlockSkillMap = self.unlockSkillMap
    if not self.advanceSkillMap then
        self.advanceSkillMap = {}
    end
    if not unlockSkillMap then
        unlockSkillMap = {}
        self.unlockSkillMap = unlockSkillMap
    end
    for i = 1, #jobSkillList do
        local jobSkillItem = jobSkillList[i]
        local unlockSkillList = jobSkillItem.unlock_skill_list
        if unlockSkillList then
            for j = 1, #unlockSkillList do
                local skillInfo = unlockSkillList[j]
                local skillId = skillInfo.key or 0
                local skillLv = skillInfo.value or 0
                local unlockSkillItem = unlockSkillMap[skillId]
                if unlockSkillItem then
                    if unlockSkillItem.skillLv < skillLv then
                        if upLevelSkills then
                            table.insert(upLevelSkills, { skillType = Enum.SkillType.Active, skillId = skillId })
                        end
                    elseif unlockSkillItem.skillLv > skillLv then
                        if downLevelSkills then
                            table.insert(downLevelSkills, { skillType = Enum.SkillType.Active, skillId = skillId })
                        end
                        -- TODO: 2020-05-18 出现道具洗技能等级，所以这个Log没用了
                        -- LogError('[Wboy] skill can not lv degradation ' .. tostring(skillId) .. '   ' .. tostring(unlockSkillItem.skillLv) .. '   ' .. tostring(skillLv))
                    end
                else
                    if newSkills then
                        table.insert(newSkills, { skillType = Enum.SkillType.Active, skillId = skillId })
                    end
                    unlockSkillItem = {}
                    unlockSkillMap[skillId] = unlockSkillItem
                    local IsLeaderHero = math.floor(skillId / 10000) == 1
                    local skillTreeCfgData
                    if IsLeaderHero then
                        skillTreeCfgData = ManagerContainer.CfgMgr:GetSkillTreeCfgById(skillId)
                    else
                        skillTreeCfgData = ManagerContainer.CfgMgr:GetParterSkillTreeCfgById(skillId)
                    end
                    if skillTreeCfgData and skillTreeCfgData.beforeSkill and skillTreeCfgData.beforeSkill ~= 0 then
                        self.advanceSkillMap[skillId] = skillId
                        if unlockSkillMap[skillTreeCfgData.beforeSkill] then
                            unlockSkillMap[skillTreeCfgData.beforeSkill] = nil
                            self.advanceSkillMap[skillTreeCfgData.beforeSkill] = nil
                            if self.slotSkills and #self.slotSkills > 0 then
                                for i = 1, #self.slotSkills do
                                   if self.slotSkills[i].skillId == skillTreeCfgData.beforeSkill then
                                    self.slotSkills[i].skillId = skillId
                                   end
                                end
                            end
                        end
                    end
                end
                unlockSkillItem.skillId = skillId
                unlockSkillItem.skillLv = skillLv
            end
        end
    end
    --刷新技能数据同时刷新压力值
    self:RefreshUnlockSkillPress()
    --刷新技能数据同时刷新勇气祝福等级
    self:RefreshNerveBenediction()
end

function SkillData:RefreshNerveBenediction()
    if  not self.NerveBenedIction then
        self.NerveBenedIction = {}
    end
    local allCfgDatas = ManagerContainer.CfgMgr:GetAllSkillSuitNewCfg()
    for i = #allCfgDatas, 1, -1 do
        if not self.NerveBenedIction[i]  then
            self.NerveBenedIction[i] = {}
        end
        self.NerveBenedIction[i].needNum = 0
        self.NerveBenedIction[i].currcount = 0
        local cfgData = allCfgDatas[i]
        local conditions = cfgData.TriggerConditions
        if conditions and #conditions > 0 then
            for j = 1, #conditions do
                local needLv  =  conditions[j][2]
                local needNum =  conditions[j][1]
                self.NerveBenedIction[i].needNum = self.NerveBenedIction[i].needNum + needNum
                local currcount = 0
                for k, v in pairs(self.advanceSkillMap) do
                    local skillLv = self:GetSkillLv(v)
                    if skillLv >= needLv then
                        currcount = currcount + 1
                    end
                end
                self.NerveBenedIction[i].currcount = self.NerveBenedIction[i].currcount + currcount
            end
            if self.NerveBenedIction[i].currcount >= self.NerveBenedIction[i].needNum then
                self.NerveBenedIction[i].currcount = self.NerveBenedIction[i].needNum
                self.currNerveLv = i
                return
            end
        else
            self.currNerveLv = 1
        end
    end
end

function SkillData:GetCurrNerveLv()
    return self.currNerveLv or 0
end

function SkillData:GetNerveCurrDataById(id)
    return self.NerveBenedIction[id]
end

function SkillData:IsCanResetSkill(type)
    if type == 1 then  --进阶技能重置
        for k, v in pairs(self.advanceSkillMap) do
            local skillLv = self:GetSkillLv(v)
            if skillLv > 1 then
                return true
            end
        end
    else               --所有技能重置
        for k, v in pairs(self.unlockSkillMap) do
            if v.skillLv > 1 then
                return true
            end
        end
    end
    return false
end

function SkillData:InitSlotSkillData(slotSkillList)
    local slotSkills = {}
    for i = 1, #slotSkillList do
        local item = slotSkillList[i]
        local slotSkillItem = {}
        slotSkillItem.skillId = item.skill_id or 0
        slotSkillItem.isUnlock = (item.unlock and item.unlock > 0) and true or false
        slotSkillItem.defaultSkillId = item.default_skill_id or 0
        slotSkills[i] = slotSkillItem
    end
    self.slotSkills = slotSkills
end

function SkillData:OnJobSkillDataChange(data)
    local jobSkillList = data.job_skill_list
    local newSkills = {}
    local upLevelSkills = {}
    local downLevelSkills = {}
    self:InitJobSkillData(jobSkillList, newSkills, upLevelSkills, downLevelSkills)
    local isSlotChanged = false
    if not isSlotChanged and newSkills then
        for k,v in pairs(newSkills) do
            -- 是否槽位上填充了新技能
            if self:GetSkillIsAtSlot(v.skillId) then
                isSlotChanged = true
                break
            end
        end
    end
    if not isSlotChanged and upLevelSkills then
        for k,v in pairs(upLevelSkills) do
            -- 是否槽位上的技能升级了
            if self:GetSkillIsAtSlot(v.skillId) then
                isSlotChanged = true
                break
            end
        end
    end
    if not isSlotChanged and downLevelSkills then
        for k,v in pairs(downLevelSkills) do
            -- 是否槽位上的技能降级了
            if self:GetSkillIsAtSlot(v.skillId) then
                isSlotChanged = true
                break
            end
        end
    end
    return isSlotChanged, newSkills, upLevelSkills, downLevelSkills
end

--- 当单个技能槽位数据发生变化
function SkillData:OnOneSkillSlotDataChange(data)
    local idx = data.idx
    local slotInfo = data.slot_info
    local item = self.slotSkills[idx]
    if not item then
        item = {}
        self.slotSkills[idx] = item
    end
    item.skillId = slotInfo.skill_id or 0
    item.isUnlock = (slotInfo.unlock and slotInfo.unlock > 0) and true or false
    item.defaultSkillId = slotInfo.default_skill_id or 0
end

--- 当技能槽位数据发生变化
function SkillData:OnSkillSlotDataChange(data)
    local slots = data.slot_info
    for i = 1, #slots do
        local slot = slots[i]
        local item = self.slotSkills[i]
        if not item then
            item = {}
            self.slotSkills[i] = item
        end
        item.skillId = slot.skill_id or 0
        item.isUnlock = (slot.unlock and slot.unlock > 0) and true or false
        item.defaultSkillId = slot.default_skill_id or 0
    end
end

function SkillData:GetUnlockSkillMap()
    return self.unlockSkillMap
end

--- 获得技能是否解锁了
---@param skillId integer 技能Id
function SkillData:GetIsUnlock(skillId)
    if self.unlockSkillMap then
        return self.unlockSkillMap[skillId] and true or false
    end
    return false
end

--- 获得技能等级
---@param skillId integer 技能Id
function SkillData:GetSkillLv(skillId)
    if self.unlockSkillMap and self.unlockSkillMap[skillId] then
        return self.unlockSkillMap[skillId].skillLv or 0
    end
    return 0
end

--- 槽位的技能信息列表
function SkillData:GetSlotSkills()
    return self.slotSkills
end

--- 技能是否已在槽位中
---@param skillId integer 技能Id
function SkillData:GetSkillIsAtSlot(skillId)
    for i = 1, #self.slotSkills do
        local slotSkill = self.slotSkills[i]
        if slotSkill then
            if slotSkill.skillId == skillId and slotSkill.isUnlock then
                return true
            end
        end
    end
    return false
end

--- 获得槽位上的技能Id
---@param idx integer 槽位ID 1-4
function SkillData:GetSlotSkillId(idx)
    local slotSkill = self.slotSkills[idx]
    if slotSkill then
        if not slotSkill.isUnlock then
            return 0
        end
        return slotSkill.skillId
    end
    return 0
end

--- 获得槽位是否解锁
---@param idx integer 槽位ID 1-4
function SkillData:GetSlotIsUnlock(idx)
    local slotSkill = self.slotSkills[idx]
    if slotSkill then
        return slotSkill.isUnlock
    end
    return false
end

--- 获得槽位解锁的数量
function SkillData:GetUnlockSlotNum()
    local num = 0
    for i = 1, #self.slotSkills do
        local slotSkill = self.slotSkills[i]
        if slotSkill.isUnlock then
            num = num + 1
        end
    end
    return num
end

--- 解锁的槽位上已放置的技能
function SkillData:GetSlotVaildSkillNum()
    local num = 0
    for i = 1, #self.slotSkills do
        local slotSkill = self.slotSkills[i]
        if slotSkill.isUnlock and slotSkill.skillId > 0 then
            num = num + 1
        end
    end
    return num
end

--- 获得槽位上最低等级的技能等级
function SkillData:GetSlotVaildSkillLowerLv()
    local lowerLv = nil
    local lowerId = nil
    for i = 1, #self.slotSkills do
        local slotSkill = self.slotSkills[i]
        if slotSkill.isUnlock and slotSkill.skillId > 0 then
            local lv = self:GetSkillLv(slotSkill.skillId)
            if lv > 0 then
                if not lowerLv or lowerLv > lv then
                    lowerLv = lv
                    lowerId = slotSkill.skillId
                end
            end
        end
    end
    return lowerLv, lowerId
end

--- 获得不在槽位中的所有解锁的主动技能
function SkillData:GetUnlockSkillsExceptSlot()
    local slotSkillIds = {}
    for i = 1, #self.slotSkills do
        local slotSkill = self.slotSkills[i]
        if slotSkill.skillId and slotSkill.skillId > 0 then
            table.insert(slotSkillIds, slotSkill.skillId)
        end
    end
    local num = #slotSkillIds
    local isVaild = false
    local unlockSkills = {}
    if self.unlockSkillMap then
        for _, skillInfo in pairs(self.unlockSkillMap) do
            if skillInfo then
                local skillId = skillInfo.skillId
                isVaild = true
                for j = num, 1, -1 do
                    if slotSkillIds[j] == skillId then
                        table.remove(slotSkillIds, j)
                        num = num - 1
                        isVaild = false
                        break
                    end
                end
                if isVaild then
                    table.insert(unlockSkills, skillId)
                end
            end
        end
    end
    return unlockSkills
end

function SkillData:GetUsedSkillParams()
    local len = #self.slotSkills
    local usedSkills = System.Array.CreateInstance(typeof(SkillParam), len)
    for i = 1, len do
        local skillParam = nil
        local slotSkill = self.slotSkills[i]
        if slotSkill then
            if slotSkill.skillId <= 0 or not slotSkill.isUnlock then
                skillParam = SkillParam.New(slotSkill.defaultSkillId, 1)
            else
                skillParam = SkillParam.New(slotSkill.skillId, self:GetSkillLv(slotSkill.skillId))
            end
        else
            skillParam = SkillParam.New(0, 0)
        end
        usedSkills[i - 1] = skillParam
    end
    return usedSkills
end

function SkillData:GetUsedSkills()
    local skills = {}
    for i = 1, #self.slotSkills do
        local slotSkill = self.slotSkills[i]
        if slotSkill then
            if slotSkill.skillId <= 0 or not slotSkill.isUnlock then
                skills[i] = { skillId = slotSkill.defaultSkillId, lv = 1 }
            else
                skills[i] = { skillId = slotSkill.skillId, lv = self:GetSkillLv(slotSkill.skillId) }
            end
        else
            skills[i] = { skillId = 0, lv = 0 }
        end
    end
    return skills
end

function SkillData:GetUnlockSkillAttrs()
    local attr = nil
    if self.unlockSkillMap then
        attr = {}
        local attrId, attrValue
        for _, skillInfo in pairs(self.unlockSkillMap) do
            if skillInfo then
                local skillId = skillInfo.skillId
                local skillLv = skillInfo.skillLv
                for i = skillLv, 1, -1 do
                    local cfgId = CommonUtil.GetSkillUpEffectCfgIdByIdAndLv(skillId, i)
                    local cfgData = ManagerContainer.CfgMgr:GetSkillUpEffectCfgById(cfgId)
                    if cfgData then
                        local addAttributes = cfgData.AddAttributes
                        if addAttributes then
                            for _, value in pairs(addAttributes) do
                                attrId = value[1]
                                attrValue = value[2]
                                if attr[attrId] == nil then
                                    attr[attrId] = attrValue
                                else
                                    attr[attrId] = attr[attrId] + attrValue
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    self:GetAvanceSkillAttrs(attr)
    return attr
end

function SkillData:RefreshUnlockSkillPress()
    local currPress = 0
    local maxPress = 0
    if self.unlockSkillMap then
        local attrId, attrValue
        for _, skillInfo in pairs(self.unlockSkillMap) do
            if skillInfo then
                local skillId = skillInfo.skillId
                local skillLv = skillInfo.skillLv
                local skilltreeData = self:GetSkillTreeDataById(skillId)
                if skilltreeData and skilltreeData.PressPoint then
                    local advancePress = self:GetAdvancePressByRecursion(skillId)
                    maxPress  = maxPress + skilltreeData.PressPoint * (skilltreeData.MaxLv - 1) + advancePress +skilltreeData.StartPressPoint
                end
            end
        end
    end
    self.maxPress  = maxPress
end

function SkillData:GetMaxPress()
    return self.maxPress or 0
end

function SkillData:GetAdvancePressByRecursion(skillId)
    local maxPress = 0 
    local skillcfg = self:GetSkillTreeDataById(skillId)
    if skillcfg and skillcfg.beforeSkill and skillcfg.beforeSkill ~= 0 then
        local beforeskillId = skillcfg.beforeSkill
        local beforeSkillcfg = self:GetSkillTreeDataById(beforeskillId)
        if beforeSkillcfg and beforeSkillcfg.StartPressPoint then
            local advancePress = 0
            if beforeskillId ~= skillId then
                local advancePress = self:GetAdvancePressByRecursion(beforeskillId)
            end
            maxPress = maxPress + skillcfg.StartPressPoint + advancePress
        end
    end
    return maxPress
end

-- 获取进阶技能属性列表
function SkillData:GetAvanceSkillAttrs(attr,skillList)
        --判断是否是进阶技能 如果是  将之前进阶的所有属性加入属性列表
    if self.unlockSkillMap then
        for _, skillInfo in pairs(self.unlockSkillMap) do
            if skillInfo then
                self:GetAdvanceSkillAttrByRecursion(attr,skillList,skillInfo.skillId)
            end
        end
    end
end

function SkillData:GetSkillTreeDataById(skillId)
    local IsLeaderHero = math.floor(skillId / 10000) == 1
    local skillTreeCfgData
    if IsLeaderHero then
        skillTreeCfgData = ManagerContainer.CfgMgr:GetSkillTreeCfgById(skillId)
    else
        skillTreeCfgData = ManagerContainer.CfgMgr:GetParterSkillTreeCfgById(skillId)
     end
     return skillTreeCfgData
end

function SkillData:GetAdvanceSkillAttrByRecursion(attr,skillList,skillId)
    local attrId, attrValue
    
    local skillcfg = self:GetSkillTreeDataById(skillId)
    if skillcfg and skillcfg.beforeSkill and skillcfg.beforeSkill ~= 0 then
        local beforeskillId = skillcfg.beforeSkill
        local beforeSkillcfg = self:GetSkillTreeDataById(beforeskillId)
        if beforeSkillcfg then
            if skillList  then
                skillList[#skillList + 1] = beforeskillId
            end
            local skillLv = beforeSkillcfg.MaxLv
            for i = skillLv, 1, -1 do
                local cfgId = CommonUtil.GetSkillUpEffectCfgIdByIdAndLv(beforeskillId, i)
                local cfgData = ManagerContainer.CfgMgr:GetSkillUpEffectCfgById(cfgId)
                if cfgData then
                    local addAttributes = cfgData.AddAttributes
                    if addAttributes then
                        for _, value in pairs(addAttributes) do
                            attrId = value[1]
                            attrValue = value[2]
                            if attr[attrId] == nil then
                                attr[attrId] = attrValue
                            else
                                attr[attrId] = attr[attrId] + attrValue
                            end
                        end
                    end
                end
            end
        end
        if beforeskillId ~= skillId then
            self:GetAdvanceSkillAttrByRecursion(attr,skillList,beforeskillId)
        end
    end
end

--- 检查技能等级变化，是否会导致属性变化
function SkillData:CheckSkillChangeAttr(skillId, oldSkillLv, newSkillLv)
    if not skillId then return false end
    if oldSkillLv == newSkillLv then return false end
    if oldSkillLv == nil then oldSkillLv = 0 end
    if newSkillLv == nil then newSkillLv = 0 end
    local iterSign = 1
    if oldSkillLv > newSkillLv then iterSign = -1 end
    for lv = oldSkillLv + iterSign, newSkillLv, iterSign do
        local cfgId = CommonUtil.GetSkillUpEffectCfgIdByIdAndLv(skillId, lv)
        local cfgData = ManagerContainer.CfgMgr:GetSkillUpEffectCfgById(cfgId)
        if cfgData then
            return true
        end
    end
    return false
end

return SkillData