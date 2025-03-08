local UISkillSettingsCtr = class("UISkillSettingsCtr", require("UICtrBase"))

local Last_Select_SkillId_Key = 'Last_Select_SkillId_Key'

function UISkillSettingsCtr:Init(view)
	self.view = view
end

---@param data integer 英雄ID 
function UISkillSettingsCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:DisposeOwnedHeros()
	self:InitOwnedHeros()
	self:DisposeSkillData()
	self:InitSkillData()
	self:DisposeSlotData()
	self:InitSlotData()
	self:InitSkillEquipData()
end

function UISkillSettingsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISkillSettingsCtr:GetData()
	return self.data
end

function UISkillSettingsCtr:OnDispose()
	self:DisposeOwnedHeros()
	self:DisposeSkillData()
	self:DisposeSlotData()
	self:DisposeSkillEquipData()
	self.data = nil
	self.view = nil
end

function UISkillSettingsCtr:ChangeHero(next)
	local num = #self.heroIds
	local newHeroId = nil
	for i = 1, num do
		if self.heroIds[i] == self.heroId then
			if next then
				newHeroId = self.heroIds[i + 1]
			else
				newHeroId = self.heroIds[i - 1]
			end
			break
		end
	end
	if not newHeroId then
		if next then
			newHeroId = self.heroIds[1]
		else
			newHeroId = self.heroIds[num]
		end
	end
	if newHeroId then
		self.heroId = newHeroId
		self:DisposeSkillData()
		self:InitSkillData()
		self:DisposeSlotData()
		self:InitSlotData()
		self:InitSkillEquipData()
		return true
	end
	return false
end

function UISkillSettingsCtr:GetHeroVaildNum()
	return #self.heroIds
end

function UISkillSettingsCtr:GetHeroId()
	return self.heroId
end

function UISkillSettingsCtr:GetHeroData()
	return ManagerContainer.DataMgr.UserData:GetHeroData(self:GetHeroId())
end

function UISkillSettingsCtr:GetHeroCfgData()
	local heroId = self:GetHeroId()
	if self:IsLeaderHero(self:GetHeroId(heroId)) then
		local roleCfgId = ManagerContainer.DataMgr.UserData:GetUserRoleId()
		return ManagerContainer.CfgMgr:GetRoleDataById(roleCfgId)
    else
		local heroCfgId = ManagerContainer.DataMgr.PartnerData:GetHeroCfgId(heroId)
		return ManagerContainer.CfgMgr:GetPartnerDataById(heroCfgId)
	end
end

function UISkillSettingsCtr:GetHeroLv()
	return ManagerContainer.DataMgr.UserData:GetHeroLv(self:GetHeroId())
end

function UISkillSettingsCtr:GetCurMapAndLevel()
	local curMapId, curLevelId = ManagerContainer.LuaBattleMgr:GetCurMapAndLevel()
	return ManagerContainer.CfgMgr:GetLevelDataByMapAndLevel(curMapId, curLevelId)
end

function UISkillSettingsCtr:IsLeaderHero()
	return ManagerContainer.DataMgr.UserData:IsLeaderHero(self:GetHeroId())
end

function UISkillSettingsCtr:GetIsUnlock(skillId)
	local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(self:GetHeroId())
	return skillData and skillData:GetIsUnlock(skillId) or false
end

function UISkillSettingsCtr:GetIsCanUnlock(skillId)
	local errorCode = self:GetActiveSkillErrorCode(skillId)
	return errorCode == 0 or errorCode == 139
end

function UISkillSettingsCtr:GetSkilllv(skillId)
	local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(self:GetHeroId())
	return skillData and skillData:GetSkillLv(skillId) or 0
end

function UISkillSettingsCtr:GetSkillMaxLv(skillId)
	local skillTreeCfgData = self:GetSkillTreeCfgData(skillId)
	local UpGradeLevel = ManagerContainer.CfgMgr:GetSkillDemandCfgUpGradeLevelById(skillTreeCfgData.OpenLevel)
	local UpGradeCost  = ManagerContainer.CfgMgr:GetSkillDemandCfgUpGradeCostById(skillTreeCfgData.OpenLevel)
	if skillTreeCfgData then
		local maxLv = skillTreeCfgData.MaxLv or 0
		local upgradeLevelNum = UpGradeLevel and (#UpGradeLevel + 1) or 0
		if maxLv > upgradeLevelNum then maxLv = upgradeLevelNum end
		local upgradeCostNum = UpGradeCost and (#UpGradeCost + 1) or 0
		if maxLv > upgradeCostNum then maxLv = upgradeCostNum end
		return maxLv
	end
	return 0
end

function UISkillSettingsCtr:GetSkillIsAtSlot(skillId)
	local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(self:GetHeroId())
	return skillData and skillData:GetSkillIsAtSlot(skillId) or false
end

function UISkillSettingsCtr:GetUnlockSlotNum()
	local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(self:GetHeroId())
	return skillData and skillData:GetUnlockSlotNum() or 0
end

function UISkillSettingsCtr:GetSkillTreeCfgData(skillId)
	local skillTreeCfgData = nil
    if self:IsLeaderHero() then
		skillTreeCfgData = ManagerContainer.CfgMgr:GetSkillTreeCfgById(skillId)
	else
		skillTreeCfgData = ManagerContainer.CfgMgr:GetParterSkillTreeCfgById(skillId)
	end
	return skillTreeCfgData
end

function UISkillSettingsCtr:GetOwnResCountByItemId(itemCfgId)
	return CommonUtil.GetOwnResCountByItemId(itemCfgId)
end

function UISkillSettingsCtr:GetActiveSkillErrorCode(skillId)
	local heroId = self:GetHeroId()
    return self:CheckSkillCanUnlock(heroId, skillId)
end

--获取激活技能的进阶错误码返回
function UISkillSettingsCtr:GetActiveSkillAvanceErrorCode(skillId)
	local heroId = self:GetHeroId()
    return self:CheckSkillCanAvance(heroId, skillId)
end

function UISkillSettingsCtr:SendActiveSkill(skillId)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVE_SKILL_REQ, {hero_id = self:GetHeroId(), skill_id=skillId})
end


function UISkillSettingsCtr:GetUpgradeSkillErrorCode(skillId)
	local heroData = self:GetHeroData()
    return CommonUtil.CheckSkillCanLvUp(heroData, skillId)
end

function UISkillSettingsCtr:SendUpgradeSkill(skillId)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SKILL_LEVEL_UP_REQ, {hero_id = self:GetHeroId(), skill_id=skillId})
end


--- 检查技能是否能解锁
---@param heroId integer 英雄Id
---@param skillId integer 技能Id
---@return integer 0:能解锁;其它查看Error_Code文件
function UISkillSettingsCtr:CheckSkillCanUnlock(heroId, skillId)
    local skillTreeCfgData = nil
    if ManagerContainer.DataMgr.UserData:IsLeaderHero(heroId) then
		skillTreeCfgData = ManagerContainer.CfgMgr:GetSkillTreeCfgById(skillId)
	else
		skillTreeCfgData = ManagerContainer.CfgMgr:GetParterSkillTreeCfgById(skillId)
	end
    if not skillTreeCfgData then
        return 133
    end
    local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(heroId)
	if not skillData then
        return 133
    end
    if skillData:GetIsUnlock(skillId) then
        return 142
    end
	local openLevel = skillTreeCfgData.OpenLevel
    local openNeedCost = skillTreeCfgData.OpenNeedCost
	if openLevel and openLevel > 0 then
		if (ManagerContainer.DataMgr.UserData:GetHeroLv(heroId) < openLevel) then return 141 end
	end
	if openNeedCost then
		local openNeedCosts = nil
		if type(openNeedCost[1]) == 'number' then
			if #openNeedCost > 1 then
				openNeedCosts = {openNeedCost}
			end
		else
			openNeedCosts = openNeedCost
		end
		if openNeedCosts then
			for i = 1, #openNeedCosts do
				local itemCfgId = openNeedCosts[i][1]
				local itemNum = openNeedCosts[i][2]
				if CommonUtil.GetOwnResCountByItemId(itemCfgId) < itemNum then
					return 139, itemCfgId
				end
			end
		end
	end
    return 0
end

--------------------------------- 已有的影响列表 Start ----------------------------------
function UISkillSettingsCtr:InitOwnedHeros()
	local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
	local sortedPartnerDatas = {}
	for _,v in pairs(partnerDatas) do
		if v.owned then
			sortedPartnerDatas[#sortedPartnerDatas + 1] = v
		end
	end
	table.sort(sortedPartnerDatas, function (a, b)
		return a.post < b.post
	end)
	local heroIds = {}
	heroIds[1] = ManagerContainer.DataMgr.UserData:GetId()
	for i = 1, #sortedPartnerDatas do
		heroIds[i + 1] = sortedPartnerDatas[i].id
	end
	self.heroIds = heroIds
	local vaildHeroId = nil
	for _, heroId in pairs(heroIds) do
		if self.data[1] == heroId then
			vaildHeroId = heroId
		end
	end
	if not vaildHeroId then
		vaildHeroId = self.heroIds[1]
	end
	if self.heroId == vaildHeroId then return false end
	self.heroId = vaildHeroId
	return true
end

function UISkillSettingsCtr:DisposeOwnedHeros()
	self.heroId = nil
	self.heroIds = nil
end

function UISkillSettingsCtr:RefreshOwnedHeros()
	self:DisposeOwnedHeros()
	if self:InitOwnedHeros() then
		self:DisposeSkillData()
		self:InitSkillData()
		self:DisposeSlotData()
		self:InitSlotData()
		self:InitSkillEquipData()
		return true
	end
	return false
end

--------------------------------- 已有的影响列表   End ----------------------------------


--------------------------------- 技能列表 Start ----------------------------------

function UISkillSettingsCtr:InitSkillData()
	self:ReadDefaultSelectSkillMap()
	self:RefreshSkillList(true)
end

function UISkillSettingsCtr:DisposeSkillData()
	self.skillList = nil
	self.selectSkillId = nil
	-- 默认选择的技能, 记录了上一次打开界面时选择的技能
	self.defaultSelectSkillMap = nil
end

function UISkillSettingsCtr:ReadDefaultSelectSkillMap()
	local valueStr = ManagerContainer.PlayerPrefsMgr:GetString(Last_Select_SkillId_Key, '')
	self.defaultSelectSkillMap = JSON:decode(valueStr)
	if not self.defaultSelectSkillMap then
		self.defaultSelectSkillMap = {}
	end
end

function UISkillSettingsCtr:WriteDefaultSelectSkillMap()
	local valueStr = JSON:encode(self.defaultSelectSkillMap)
    ManagerContainer.PlayerPrefsMgr:SetString(Last_Select_SkillId_Key, valueStr)
end

function UISkillSettingsCtr:RefreshSkillList(resetSelect)
	local skillList = {}
	local heroId = self:GetHeroId()
	local heroData = ManagerContainer.DataMgr.UserData:GetHeroData(heroId)
	local cfgId = heroData.configId
	if ManagerContainer.DataMgr.UserData:IsLeaderHero(heroId) then
		local curJobCfgData = ManagerContainer.CfgMgr:GetJobDataById(cfgId)
		if curJobCfgData then
			local jobs = ManagerContainer.CfgMgr:GetLastJobs(cfgId)
			table.insert(jobs, curJobCfgData)
			local jobNum = #jobs
			local job
			for i = 1, jobNum do
				job = jobs[i]
				local ls = ManagerContainer.CfgMgr:GetSkillTreeByFeature(job.JobType, job.JobBranch, job.JobStage)
				if ls then
					local len = #ls
					if len > 0 then
						for j = 1, len do
							local skilltreeData = self:IsAdvance(heroData,ls[j])
							table.insert(skillList, skilltreeData)
						end
					end
				end
			end
		end
	else
		local curJobCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(cfgId)
		if curJobCfgData then
			local jobs = ManagerContainer.CfgMgr:GetParterLastJobs(cfgId)
			table.insert(jobs, curJobCfgData)
			local jobNum = #jobs
			local job
			for i = 1, jobNum do
				job = jobs[i]
				local ls = ManagerContainer.CfgMgr:GetParterSkillTreeByFeature(job.JobType, job.ParterId)
				if ls then
					local len = #ls
					if len > 0 then
						for j = 1, len do
							local skilltreeData = self:IsAdvance(heroData,ls[j])
							table.insert(skillList, skilltreeData)
						end
					end
				end
			end
		end
	end
	-- 排序
	table.sort(skillList, function(a, b)
		return a.Pos < b.Pos
	end)
	self.skillList = skillList

	if not resetSelect then return end
	local selectSkillId = nil
	if heroData and heroData.skillData then
		--神器标记跳转过来默认神器技能
		local artifactSkillId = self:GetDefaultSelectedSkillId()
		if artifactSkillId then
			selectSkillId = artifactSkillId
		else
			local validSlotNum = heroData.skillData:GetUnlockSlotNum()
			local lowerLv = nil
			local lv
			for i = 1, validSlotNum do
				local skillId = heroData.skillData:GetSlotSkillId(i)
				if CommonUtil.CheckSkillCanLvUp(heroData, skillId) == 0 then
					lv = heroData.skillData:GetSkillLv(skillId)
					if not lowerLv or lowerLv > lv then
						lowerLv = lv
						selectSkillId = skillId
					end
				end
			end
		end
	end

	if not selectSkillId then
		if self.defaultSelectSkillMap then
			selectSkillId = self.defaultSelectSkillMap[heroId]
		end
	end
	local vaildSelectSkillId = nil
	if selectSkillId then
		-- 是否技能还在
		for i = 1, #skillList do
			if selectSkillId == skillList[i].SkillId then
				vaildSelectSkillId = selectSkillId
				break
			end
		end
	end
	if vaildSelectSkillId then
		self.selectSkillId = vaildSelectSkillId
	else
		local skill = skillList[1]
		if skill then
			self.selectSkillId = skill.SkillId
			self.defaultSelectSkillMap[heroId] = self.selectSkillId
			self:WriteDefaultSelectSkillMap()
		end
	end
end

function UISkillSettingsCtr:IsAdvance(heroData,skilltreeData)
	if heroData and heroData.skillData then
		local skillId = skilltreeData.SkillId
		local unlockSkillMap = heroData.skillData:GetUnlockSkillMap()
		local cfgId = heroData.configId
		local curJobCfgData = ManagerContainer.CfgMgr:GetJobDataById(cfgId)
		if not curJobCfgData.JobBranch or  curJobCfgData.JobBranch == 0 then
			return skilltreeData
		end
		local skilltreedata = skilltreeData
		while not unlockSkillMap[skillId]  do
			local nextSkillIdList = skilltreedata.SuperSkill
			if nextSkillIdList then
				if #nextSkillIdList > 1 then
					skillId = nextSkillIdList[curJobCfgData.JobBranch][2]
				else
					skillId = nextSkillIdList[1][2]
				end
				skilltreedata = self:GetSkillTreeCfgData(skillId)
				if curJobCfgData.JobStage < skilltreedata.JobStage then
					break
				end
				if unlockSkillMap[skillId] then
					return skilltreedata
				end
			else
				break
			end
		end

	end
	return skilltreeData
end

function UISkillSettingsCtr:GetSelectSkillId()
	return self.selectSkillId
end

function UISkillSettingsCtr:SetSelectSkillId(skillId)
	if self.selectSkillId == skillId then
		return false
	end
	self.selectSkillId = skillId
	self.defaultSelectSkillMap[self:GetHeroId()] = skillId
	self:WriteDefaultSelectSkillMap()
	return true
end

function UISkillSettingsCtr:SetSkillList()
	return self.skillList
end

function UISkillSettingsCtr:GetSkillItemInfoByIndex(itemIndex)
	return self.skillList and self.skillList[itemIndex + 1] or nil
end

--获取当前技能列表是否有对应SKILLID数据
function UISkillSettingsCtr:GetSkilldataByIndex(id)
	for i = 1, #self.skillList do		
		if self.skillList[i].SkillId == id then
			return true
		end
	end
	return false
end

--------------------------------- 技能列表 End   ----------------------------------


---------------------------------- 技能槽 Start -----------------------------------

function UISkillSettingsCtr:GetSlotNum()
	return 4
end

function UISkillSettingsCtr:InitSlotData()
	local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(self:GetHeroId())
	local slotIdxs = {}
	local slotSkillIds = {}
	local slotNum = self:GetSlotNum()
	for i = 1, slotNum do
		slotIdxs[i] = i
		slotSkillIds[i] = skillData:GetSlotSkillId(i)
	end
	self.slotIdxs = slotIdxs
	self.slotSkillIds = slotSkillIds
end

function UISkillSettingsCtr:DisposeSlotData()
	self.slotIdxs = nil
	self.slotSkillIds = nil
end

function UISkillSettingsCtr:UpdateSlotIdxs(newSlotIdxs)
	local slotNum = self:GetSlotNum()
	local slotIdxs = {}
	for i = 1, slotNum do
		slotIdxs[i] = newSlotIdxs[i]
	end
	self.slotIdxs = slotIdxs
end

function UISkillSettingsCtr:UpdateSlotSkills()
	local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(self:GetHeroId())
	local slotNum = self:GetSlotNum()
	for i = 1, slotNum do
		self.slotSkillIds[self.slotIdxs[i]] = skillData:GetSlotSkillId(i)
	end
end

function UISkillSettingsCtr:GetSkillIdBySlotIdx(slotIdx)
	return self.slotSkillIds[slotIdx]
end

function UISkillSettingsCtr:GeSlotIdxById(id)
	return self.slotIdxs[id]
end

function UISkillSettingsCtr:GetSlotIdxByIdx(idx)
	local slotNum = self:GetSlotNum()
	for i = 1, slotNum do
		if self.slotIdxs[i] == idx then
			return i
		end
	end
	return nil
end

function UISkillSettingsCtr:GetSlotIsUnlock(idx)
	local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(self:GetHeroId())
	return skillData and skillData:GetSlotIsUnlock(idx) or false
end

function UISkillSettingsCtr:GetSlotVaildSkillNum()
	local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(self:GetHeroId())
	return skillData and skillData:GetSlotVaildSkillNum() or 0
end

function UISkillSettingsCtr:SendSlotSkillChange()
	local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(self:GetHeroId())
	local slotNum = self:GetSlotNum()
	local newSkills = {}
	local isChanged = false
	for i = 1, slotNum do
		local itemIdx = self:GeSlotIdxById(i)
		local skillId = self:GetSkillIdBySlotIdx(itemIdx) or 0
		newSkills[i] = skillId
		if skillId ~= skillData:GetSlotSkillId(i) then
			isChanged = true
		end
	end
	if isChanged then
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SET_SKILL_LIST_REQ, {hero_id = self:GetHeroId(), skill_list = newSkills})
	end
end
---------------------------------- 技能槽 End   -----------------------------------



function UISkillSettingsCtr:SendChangeSkill(skillId, slotIdx)
	local heroId = self:GetHeroId()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_REPLACE_SKILL_REQ, {hero_id = heroId, idx = slotIdx, skill_id = skillId})
	--后续添加到服务器回调
	ManagerContainer.LuaBattleMgr:SetTeamData(true,true)
end
--重置技能消息
function UISkillSettingsCtr:SendResetSkillLv(type)
	local heroId = self:GetHeroId()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_RESET_SKILL_LEVEL_REQ, {hero_id = heroId,is_advanced = type and type == 1 or false })
end


------------------------------------- 神器标记 -----------------------------------------

function UISkillSettingsCtr:GetDefaultSelectedSkillId()
	return self.data[2]
end

function UISkillSettingsCtr:InitSkillEquipData()
	local function IsTheJob(jobData, skillEquipCfgData)
		if not jobData then
			return false
		end
		return jobData.JobType == skillEquipCfgData.JobType and jobData.JobBranch == skillEquipCfgData.JobBranch and jobData.JobStage == skillEquipCfgData.JobStage
	end

	local heroId = self:GetHeroId()
	local heroData = CommonUtil.GetHeroLogicDataByUid(self:GetHeroId())
	local skillDataSlot = heroData.skillEquipSlot
	self.skillEquipData = (skillDataSlot and skillDataSlot.slotList) and skillDataSlot.slotList[1] or nil
	if self.skillEquipData then
		self.skillEquipCfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(self.skillEquipData.cfgId)
		if self.skillEquipCfgData then
			local heroCfgId = heroData.configId
			local jobData
			if heroData then
				if heroId == 1 then
					jobData = ManagerContainer.CfgMgr:GetJobDataById(heroCfgId)
				else
					jobData = ManagerContainer.CfgMgr:GetPartnerDataById(heroCfgId)
				end
			end
			self.isCorrectJob = IsTheJob(jobData, self.skillEquipCfgData)
			
			local itemCfgData = ManagerContainer.CfgMgr:GetItemById(self.skillEquipData.cfgId)
			self.skillEquipIcon = itemCfgData.Icon
		end
	end
end

function UISkillSettingsCtr:GetSkillInSkillEquipDataState(skillId)
	if not self.skillEquipData or not self.skillEquipCfgData then return 0 end

	local heroId = self:GetHeroId()
	if not self.isCorrectJob then return 0 end

	local isUnlock = self:GetIsUnlock(skillId)
	if not isUnlock then return 0 end

	local function IsInBeforeSkill(id)
		local skillTreeCfgData = self:GetSkillTreeCfgData(id)
		if not skillTreeCfgData then return false end

		local lastSkillId = skillTreeCfgData.beforeSkill

		if lastSkillId ~= skillId then
			return IsInBeforeSkill(lastSkillId)
		else
			return true
		end
	end

	local idx = 0
	local isOld = false
	local isNew = false
	local effectSkills = self.skillEquipCfgData.ArtifacFuncId
	for i = 1, #effectSkills do
		local data = effectSkills[i]
		local oldSkillId = heroId == 1 and data[2] or data[3]
		isNew = oldSkillId == skillId
		if not isNew and oldSkillId and oldSkillId ~= skillId then
			isOld = IsInBeforeSkill(oldSkillId)
		end
		idx = i
		
		if isOld or isNew then
			break
		end
	end
	if not isOld and not isNew then return 0 end

	if isOld then return 1, idx end

	local isEquip = self:GetSkillIsAtSlot(skillId)

	if not isOld and isNew and not isEquip then return 1, idx end
	if not isOld and isNew and isEquip and idx > self.skillEquipData.starLv then return 1, idx end

	if not isOld and isNew and isEquip then return 2, idx end

	return 0
end

function UISkillSettingsCtr:GetCurSkillEquipData()
	return self.skillEquipData
end

function UISkillSettingsCtr:GetSkillEquipIcon()
	return self.skillEquipIcon
end

function UISkillSettingsCtr:DisposeSkillEquipData()
	self.skillEquipData = nil
	self.skillEquipCfgData = nil
	self.skillEquipIcon = nil
end
---------------------------------  神器标记 End ---------------------------------
return UISkillSettingsCtr

