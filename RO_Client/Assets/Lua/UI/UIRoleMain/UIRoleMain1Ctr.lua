local UIRoleMain1Ctr = class("UIRoleMain1Ctr", require("UICtrBase"))

local canAdvence = false

local activationList = {}

local isLeader = false
local curOwnIndex = 1
local battledPartnerCount = 0
local battleStatus = false

local allRecruitDscs
local sortedPartnerDatas
function UIRoleMain1Ctr:Init(view)
	self.view = view
end

function UIRoleMain1Ctr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data

	isLeader = data == 1
    self:SetCurOwnerIndexById(data)
end

function UIRoleMain1Ctr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIRoleMain1Ctr:GetData()
	return self.data
end

function UIRoleMain1Ctr:SetCurOwnerIndexById(id)
    if id == 1 then
        curOwnIndex = 1
    else
		sortedPartnerDatas = nil
		if sortedPartnerDatas == nil then
			self:GetSlotSortPartnerDatas()
		end
		for k,v in pairs(sortedPartnerDatas) do
			if v.id == id then
				curOwnIndex = k + 1
			end
		end
    end
end

function UIRoleMain1Ctr:GetIsLeader()
	return isLeader
end

function UIRoleMain1Ctr:GetCurSLotIndex()
	if isLeader then
		return 1
	else
		local logicData = self:GetHeroLogicData()
		--if logicData.isBattle then
			return logicData.id
		--end
	end
	return nil
end

function UIRoleMain1Ctr:PartnerLvUpReq(id)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HERO_LEVEL_UP_REQ, {hero_id = id})
end

function UIRoleMain1Ctr:PartnerAdvenceLvUpReq(id)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HERO_ADVANCE_REQ, {hero_id = id})
end

function UIRoleMain1Ctr:PartnerBattleReq(id, isBattle)
	battleStatus = isBattle
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HERO_BATTLE_REQ, {hero_id = id, is_battle = isBattle})
end

function UIRoleMain1Ctr:GetBattleStatus()
	return battleStatus
end

function UIRoleMain1Ctr:GetHeroLogicData()
	if isLeader then
		return ManagerContainer.DataMgr.UserData:GetHeroData()
	else
		return ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(self.data)
	end
end

function UIRoleMain1Ctr:GetHeroJobType()
	local jobType
	if isLeader then
		local logicData = ManagerContainer.DataMgr.UserData:GetHeroData()
		local jobData = ManagerContainer.CfgMgr:GetJobDataById(logicData.configId)
		jobType = jobData.JobType
	else
		local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(self.data)
		local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
		jobType = cfgData.JobType
	end
	return jobType
end

function UIRoleMain1Ctr:GetHeroStepData()
	local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(self.data)
	local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
	return ManagerContainer.CfgMgr:GetParterProgressById(cfgData.ParterJob)
end

function UIRoleMain1Ctr:GetPartnerLogicDataByPostId(slot)
	local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
	for _,v in pairs(partnerDatas) do
		if v.post == slot then
			return v
		end
	end
	return nil
end

function UIRoleMain1Ctr:GetSlotSortPartnerDatas()
	local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
	sortedPartnerDatas = {}
	for _,v in pairs(partnerDatas) do
		sortedPartnerDatas[#sortedPartnerDatas + 1] = v
	end
	table.sort(sortedPartnerDatas, function (a, b)
		if a.owned and b.owned then
			return a.post < b.post
		else
			if a.owned and not b.owned then
				return true
			elseif not a.owned and b.owned then
				return false
			else
				return a.post < b.post
			end
		end
	end)
end

function UIRoleMain1Ctr:GetSortedPartnerDatas()
	if sortedPartnerDatas == nil then
		self:GetSlotSortPartnerDatas()
	end
	return sortedPartnerDatas
end

function UIRoleMain1Ctr:GetHeroLogicId()
	local logicData = self:GetHeroLogicData()
	return logicData.id
end

function UIRoleMain1Ctr:GetPartnerCurMaxLv()
	local logicData = self:GetHeroLogicData()
	local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
	local stepData = ManagerContainer.CfgMgr:GetParterProgressById(cfgData.ParterJob)
	if stepData == nil then
		canAdvence = false
		return logicData.baseLevel
	end
	local advenceMaxLv = logicData.advanceLevel < #stepData.AddLv and stepData.AddLv[logicData.advanceLevel + 1] or stepData.AddLv[#stepData.AddLv]

	local curMaxLv = logicData.strengthLevel == 0 and advenceMaxLv or (advenceMaxLv + stepData.BreachAddLv[logicData.strengthLevel])

	canAdvence = advenceMaxLv == logicData.baseLevel and logicData.advanceLevel < #stepData.AddLv

	if #stepData.AddLv <= logicData.advanceLevel then
		advenceMaxLv = nil
	end
	return curMaxLv, advenceMaxLv
end

function UIRoleMain1Ctr:GetPartnerNextMaxLv()
	local logicData = self:GetHeroLogicData()
	local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
	local stepData = ManagerContainer.CfgMgr:GetParterProgressById(cfgData.ParterJob)
	return stepData.AddLv[logicData.advanceLevel + 1]
end

function UIRoleMain1Ctr:GetPartmerLastMaxLv()
	local logicData = self:GetHeroLogicData()

	local stepData = ManagerContainer.CfgMgr:GetParterProgressById(logicData.configId)
	return stepData.AddLv[logicData.advanceLevel]
end

function UIRoleMain1Ctr:CanAdvence()
	return canAdvence
end

local function IsActivationPartner(partnerId, activationList)
	for _,v in pairs(activationList) do
		if v.configId == partnerId then
			return v
		end
	end
	return nil
end

function UIRoleMain1Ctr:GetSlotsList()
	return ManagerContainer.DataMgr.UserData:GetAllSlotInfos()
end

function UIRoleMain1Ctr:GetActivationPartnerCount()
	local activationPartners = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
	local index = 0
	for k,v in pairs(activationPartners) do
		index = index + 1
	end
	return index
end

function UIRoleMain1Ctr:GetBattlePartnerCount()
	return battledPartnerCount
end

function UIRoleMain1Ctr:RefreshPartnersLists()
	activationList = {}
	battledPartnerCount = 0
	local activationPartners = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
	local partnerDatas = ManagerContainer.CfgMgr:GetAllPartnerDatas()
	for k,v in pairs(partnerDatas) do
		local data = IsActivationPartner(k, activationPartners)

		if data ~= nil and data.owned and data.isBattle then
			activationList[#activationList + 1] = {id = v.ParterId, NatureId = v.NatureId, baseLevel = data.base_level}
			battledPartnerCount = battledPartnerCount + 1
		end
	end
	CommonUtil.ArraySortSelections(activationList, Enum.TableSortRule.Down, "status", "baseLevel")

	return activationList
end

function UIRoleMain1Ctr:SendCurEquipDress(index, id)
	if isLeader then
		local oldSlot = CommonUtil.TableClone(ManagerContainer.DataMgr.UserData:GetCurSlotInfos(1))
		ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EQUIP_UP_REQ, {hero_id = 1, slot_index = index, equip_id = id})
	else
		local logicData = self:GetHeroLogicData()
		--if logicData.isBattle then
			local slots = ManagerContainer.DataMgr.UserData:GetSlotInfosByHeroId(logicData.id)
			local oldSlot = CommonUtil.TableClone(slots)
			ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
			ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EQUIP_UP_REQ, {hero_id = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(logicData.id), slot_index = index, equip_id = id})
		--end
	end
end

function UIRoleMain1Ctr:SendFightPowerReq(id)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HERO_FIGH_POWER_REQ, {hero_id = id})
end

function UIRoleMain1Ctr:SendOneKeyEquipDress()
	if isLeader then
		local oldSlot = CommonUtil.TableClone(ManagerContainer.DataMgr.UserData:GetCurSlotInfos(1))
		ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EQUIP_UP_REQ, {hero_id = 1, slot_index = 0})
	else
		local logicData = self:GetHeroLogicData()
		--if logicData.isBattle then
			local slots = ManagerContainer.DataMgr.UserData:GetSlotInfosByHeroId(logicData.id)
			local oldSlot = CommonUtil.TableClone(slots)
			ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
			ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EQUIP_UP_REQ, {hero_id = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(logicData.id), slot_index = 0})
		--end
	end
end

function UIRoleMain1Ctr:SendCurEquipPutOff(index, id)
	if isLeader then
		local oldSlot = CommonUtil.TableClone(ManagerContainer.DataMgr.UserData:GetCurSlotInfos(1))
		ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EQUIP_DOWN_REQ, {hero_id = 1, sub_index = index})
	else
		local logicData = self:GetHeroLogicData()
		--if logicData.isBattle then
			local slots = ManagerContainer.DataMgr.UserData:GetSlotInfosByHeroId(logicData.id)
			local oldSlot = CommonUtil.TableClone(slots)
			ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
			ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EQUIP_DOWN_REQ, {hero_id = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(logicData.id), sub_index = index})
		--end
	end
end

function UIRoleMain1Ctr:SendOneKeyEquipPutOff()
	if isLeader then
		local oldSlot = CommonUtil.TableClone(ManagerContainer.DataMgr.UserData:GetCurSlotInfos(1))
		ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EQUIP_DOWN_REQ, {hero_id = 1})
	else
		local logicData = self:GetHeroLogicData()
		--if logicData.isBattle then
			local slots = ManagerContainer.DataMgr.UserData:GetSlotInfosByHeroId(logicData.id)
			local oldSlot = CommonUtil.TableClone(slots)
			ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
			ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EQUIP_DOWN_REQ, {hero_id = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(logicData.id)})
		--end
	end
end

function UIRoleMain1Ctr:SendOneKeyUp()
	local slotIdx = nil
	if isLeader then
		slotIdx = 1
	else
		local logicData = self:GetHeroLogicData()
		slotIdx = logicData.id
	end
	local canForge, list, lackCoin, lackEquip = ManagerContainer.DataMgr.EquipData:GetForgeStatus(slotIdx, true)

	if not canForge and lackCoin then
		CommonUtil.ItemNotEnoughHandle(Enum.ItemType.Coin)
		return
	end

	if not canForge and lackEquip then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(Enum.ActionNotiveType.MetaLack)
		return
	end

	if isLeader then
		local oldSlot = CommonUtil.TableClone(ManagerContainer.DataMgr.UserData:GetCurSlotInfos(1))
		ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EQUIP_LEVEL_UP_ALL_REQ, {hero_id = 1})
	else
		local logicData = self:GetHeroLogicData()
		--if logicData.isBattle then
			local slots = ManagerContainer.DataMgr.UserData:GetSlotInfosByHeroId(logicData.id)
			local oldSlot = CommonUtil.TableClone(slots)
			ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
			ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EQUIP_LEVEL_UP_ALL_REQ, {hero_id = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(logicData.id)})
		--end
	end
end

function UIRoleMain1Ctr:GetSlotIndex()
	local logicData = self:GetHeroLogicData()
	return ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(logicData.id)
end

function UIRoleMain1Ctr:HasEquipOn()
	local slots = nil
	if isLeader then
		slots = ManagerContainer.DataMgr.UserData:GetCurSlotInfos(1)
	else
		local logicData = self:GetHeroLogicData()
		--if not logicData.isBattle then return false end

		slots = ManagerContainer.DataMgr.UserData:GetSlotInfosByHeroId(logicData.id)
	end

	if slots == nil or #slots == 0 then
		return false
	end
	for _, v in pairs(slots) do
		if v.equip_id > 0 then
			return true
		end
	end
	return false
end

function UIRoleMain1Ctr:SendRecruit(configId)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HERO_ACTIVE_REQ, {hero_id = configId})
end

function UIRoleMain1Ctr:GetCurRecruitCondDsc()
    if allRecruitDscs == nil then
        self:GetAllRecruitCondDsc()
    end
	local curLevel = ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId()
    for i = 1, #allRecruitDscs do
		local num = tonumber(allRecruitDscs[i])
        if num > curLevel then
			local levelData = ManagerContainer.CfgMgr:GetLevelDataById(num)
            return levelData.Name
        end
    end
	local levelData = ManagerContainer.CfgMgr:GetLevelDataById(tonumber(allRecruitDscs[#allRecruitDscs]))
    return levelData.Name
end

function UIRoleMain1Ctr:GetAllRecruitCondDsc()
	local val = GlobalConfig.Instance:GetConfigStrValue(267)
	allRecruitDscs = CommonUtil.DeserializeGlobalStrToTable(val)
end

function UIRoleMain1Ctr:GetSkillById(skillId)
	local hero = self:GetHeroLogicData()
	if hero == nil then
		return nil
	end

	if hero.skills == nil then
		return nil
	end

	for  i = 1, #hero.skills do
		if hero.skills[i].skillId == skillId then
			return hero.skills[i]
		end
	end
	return nil
end

function UIRoleMain1Ctr:GetModelRawImageTex()
	if self.view == nil then return nil end

	return self.view:GetModelRawImageTex()
end

function UIRoleMain1Ctr:SetCurOwnerIndex(index)
	curOwnIndex = index
end

local function IndexOffset(curIndex, offset)
	local max = 6
	local num = curIndex + offset
	local index = num
	if num <= 0 then
		index = max
	elseif num > max then
		index = 1
	end
	return index
end

function UIRoleMain1Ctr:GetCurOwnerIndex()
	return curOwnIndex
end

function UIRoleMain1Ctr:SwichParterHero(offset)
	local curIndex = curOwnIndex

	curOwnIndex = IndexOffset(curIndex, offset)
	if curOwnIndex == 1 then
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SWICH_PARTNER_VIEW, 1)
	else
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SWICH_PARTNER_VIEW, sortedPartnerDatas[curOwnIndex - 1].id)
	end
end

function UIRoleMain1Ctr:GetSkillList()
	local logicData = self:GetHeroLogicData()
	local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
	local skillList = ManagerContainer.CfgMgr:GetParterSkillTreeByFeature(cfgData.JobType, cfgData.ParterId)

	if skillList then
		table.sort(skillList, function(a, b)
			return a.Pos < b.Pos
		end)
	end
	self.skillList = skillList
	return skillList
end

function UIRoleMain1Ctr:GetSkillItemInfoByIndex(itemIndex)
	return self.skillList and self.skillList[itemIndex + 1] or nil
end

function UIRoleMain1Ctr:OnOneKeyCardUp()
	local logicData = self:GetHeroLogicData()
	local jobType = self:GetHeroJobType()
	if jobType == nil then return end

	local slot = ManagerContainer.DataMgr.UserData:GetSlotInfoById(self.data)
	local slotList = slot.slot_list

	if slotList == nil then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CardHandling")
		return
	end

	local noEquip = true
	local result = false
	local hasEmpty, hasCard = false, false
	local slotCards = {}
	for i = 1, 6 do
		local emptySlot = 0
		if slotList[i] ~= nil and slotList[i].equip_id > 0 then
			noEquip = false
			local cardList = slotList[i].card_id_list
			local cardSlotCount = ManagerContainer.RedPointMgr.HeroRPCtr:GetCardSlotCountByType(i)
			local idxes = {}
			for j = 1, cardSlotCount do
				if cardList[j] == 0 or cardList[j] == nil then
					idxes[#idxes + 1] = j
					emptySlot = emptySlot + 1
				end
			end
			if emptySlot > 0 then
				hasEmpty = true
				local list = ManagerContainer.DataMgr.CardData:GetAllCardDatasByType(i)
				local cardDatas = CommonUtil.ArrayFilterSelections(list, Enum.FilterType.AND, {"Profession"}, {jobType})
				if list ~= nil and cardDatas ~= nil then
					if not hasCard then
						hasCard = #list > #cardDatas
					end
				end
				if cardDatas ~= nil and next(cardDatas) then
					local data = {}
					data.slot_id = i
					data.card_slot_info = {}
					slotCards[#slotCards + 1] = data

					CommonUtil.ArraySortSelections(cardDatas, Enum.TableSortRule.Down, "CardType", "CardLevel", "FightPower", "cfgId")
					local cardIdx = 1
					local cfgId, count
					for j = 1, emptySlot do
						if idxes[j] and cardDatas[cardIdx] then
							if cfgId ~= cardDatas[cardIdx].cfgId then
								cfgId = cardDatas[cardIdx].cfgId
								count = cardDatas[cardIdx].num
							end
							result = true
							local data1 = {key = idxes[j], value = cardDatas[cardIdx].cfgId}
							data.card_slot_info[#data.card_slot_info + 1] = data1

							count = count - 1
							if count <= 0 then
								cardIdx = cardIdx + 1
							end
						end
					end
				end
			end
		end
	end

	if noEquip then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CardHandling")
		return
	end

	if result then
		local data2 = {}
		data2.hero_id = logicData.id
		data2.eqiup_slot_data = slotCards

		local slots = ManagerContainer.DataMgr.UserData:GetSlotInfosByHeroId(logicData.id)
		local oldSlot = CommonUtil.TableClone(slots)
		ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_EQUIP_ALL_REQ, data2)

		ManagerContainer.RedPointMgr.HeroRPCtr:RefreshRoleCardSlotRP(self.data)
	else
		if hasEmpty then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(hasCard and "NoCardTips2" or "NoCardTips")
		end
	end
end

function UIRoleMain1Ctr:OnOneKeyCardForge()
	local slot = ManagerContainer.DataMgr.UserData:GetSlotInfoById(self.data)
	local slotList = slot.slot_list

	if slotList == nil then return end

	local costId = Enum.ItemIds.Coin
	--local costCount = ManagerContainer.DataMgr.CardData:GetComposeOnceCostNum()
	local remainRes = CommonUtil.GetOwnResCountByItemId(costId)
	--if CommonUtil.ResLackErrorNotice(costId, costCount) then
	--	return
	--end

	local forgeResult = false
	local resultType = 0
	local hasMvpResult = false
	local forgeRepeat = {}
	for i = 1, 6 do
		if slotList[i] ~= nil then
			local cardList = slotList[i].card_id_list
			for j = 1, #cardList do
				local cfgId = cardList[j]
				if cfgId > 0 then
					local result, remainRes1, hasMvp  = ManagerContainer.DataMgr.CardData:CanCurCardUp(cfgId, 1, remainRes, true)
					if result then
						forgeResult = true
						remainRes = remainRes1

						if hasMvp then
							hasMvpResult = hasMvp
						end

						forgeRepeat[#forgeRepeat + 1] = {key = i, value = j}
					else
						if resultType == 0 or resultType == 3 then
							resultType = remainRes1
						end
					end
				end
			end
		end
	end

	if forgeResult then
		if hasMvpResult then
			local data = {"CardForgeMvpTip", nil, forgeRepeat, self, self.ForgeResultFunc}
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			return
		else
			self:ForgeResultFunc(forgeRepeat)
		end
	else
		if resultType == 1 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam(CommonUtil.GetItemNotEnoughInfo(Enum.ItemIds.Coin))
		elseif resultType == 2 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LackCard")
		elseif resultType == 3 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("154")
		end
	end
end

function UIRoleMain1Ctr:ForgeResultFunc(forgeRepeat)
	local protoData = {}
	protoData.hero_id = self.data
	protoData.data = forgeRepeat

	local slots = ManagerContainer.DataMgr.UserData:GetSlotInfosByHeroId(self.data)
	local oldSlot = CommonUtil.TableClone(slots)
	ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_UP_GRADE_ALL_REQ, protoData)
end

function UIRoleMain1Ctr:InsertedCards()
	local slot = ManagerContainer.DataMgr.UserData:GetSlotInfoById(self.data)
	local slotList = slot.slot_list
	if slotList == nil then return false end

	local result = false
	for i = 1, 6 do
		if slotList[i] ~= nil then
			local cardList = slotList[i].card_id_list
			for _,v in pairs(cardList) do
				if v > 0 then
					result = true
				end
			end
		end
	end

	return result
end

function UIRoleMain1Ctr:OnOneKeyCardDown()
	local slot = ManagerContainer.DataMgr.UserData:GetSlotInfoById(self.data)
	local slotList = slot.slot_list

	if slotList == nil then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CardHandling")
		return
	end

	local noEquip = true
	for i = 1, 6 do
		if slotList[i] ~= nil and slotList[i].equip_id > 0 then
			noEquip = false
			break
		end
	end

	if noEquip then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CardHandling")
		return
	end

	local slots = ManagerContainer.DataMgr.UserData:GetSlotInfosByHeroId(self:GetHeroLogicId())
	local oldSlot = CommonUtil.TableClone(slots)
	ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_EQUIP_DOWN_REQ, {hero_id = self.data})
end

function UIRoleMain1Ctr:GetCurHeroSkillEquipSlotData()
	local heroData = CommonUtil.GetHeroLogicDataByUid(self.data)
	local skillDataSlot = heroData.skillEquipSlot
	local curSkillEquipData = (skillDataSlot and skillDataSlot.slotList) and skillDataSlot.slotList[1] or nil
	return curSkillEquipData
end

function UIRoleMain1Ctr:SendSkillEquipDownReq()
	ManagerContainer.DataMgr.SkillEquipData:SendSkillEquipDownReq(self.data, 1)
end

function UIRoleMain1Ctr:SendSkillEquipUpReq(id)
	ManagerContainer.DataMgr.SkillEquipData:SendSkillEquipUpReq(self.data, 1, id)
end

function UIRoleMain1Ctr:OnDispose()
	-- if ManagerContainer.DataMgr.SkillsData.skillDirty then
	-- 	ManagerContainer.LuaBattleMgr:UpdateTeamSkills()
	-- 	ManagerContainer.DataMgr.SkillsData.skillDirty  = false
	-- end
	sortedPartnerDatas = nil
	allRecruitDscs = nil;
	self.skillList = nil

	self.data = nil
	self.view = nil
end

return UIRoleMain1Ctr

