local UIEquipTipsCtr = class("UIEquipTipsCtr", require("UICtrBase"))
local ConditionJudge = require("Common/ConditionJudge")

function UIEquipTipsCtr:Init(view)
	self.view = view
end

function UIEquipTipsCtr:SetData(data)
	self.data = data
	self.asyncIdx = 0
end

function UIEquipTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIEquipTipsCtr:GetData()
	return self.data
end

function UIEquipTipsCtr:GetHeroId()
	return self.data[1].id
end

function UIEquipTipsCtr:GetHeroConfigId()
	return self.data[1].heroConfigId
end

-- 获得道具配置id
function UIEquipTipsCtr:GetCfgId()
	return self.data[1].cfgId
end

function UIEquipTipsCtr:GetNickName()
	return self.data[1].nickName
end

function UIEquipTipsCtr:GetSlotIndex()
	return self.data[1].slotIndex
end

function UIEquipTipsCtr:GetSlotType()
	return self.data[1].slotType
end

function UIEquipTipsCtr:GetNeedChange()
	return self.data[1].noChange
end

function UIEquipTipsCtr:GetCanRefine()
	return self.data[1].canRefine
end

--这个界面打开是否只是为了查看，不做任何更改的操作
function UIEquipTipsCtr:GetIsView()
	return self.data[1]._isView or false;
end

function UIEquipTipsCtr:GetEnterType()
	return self.data[2]
end

function UIEquipTipsCtr:GetNeedBtns()
	return self.data[3]
end

function UIEquipTipsCtr:GetSlot()
	if self.data[1]._slots then
		return self.data[1]._slots;
	else
		local _output = ManagerContainer.DataMgr.UserData:GetCurSlotInfos(self:GetSlotIndex());
		return _output;
	end
end

function UIEquipTipsCtr:GetCardIdList()
	return self.data[1]._cardIdList;
end

function UIEquipTipsCtr:CanEquipCard()
	local cardData = ManagerContainer.CfgMgr:GetCardDataById(self.data[1].cfgId)
	local slotType = cardData.CardLocation
	local slotsRoot = ManagerContainer.DataMgr.UserData:GetAllSlotInfos()
	for _,v in pairs(slotsRoot) do
		if #v.slot_list > 0 then
			local slot = v.slot_list[slotType]
			if slot.equip_id > 0 then
				for j = 1, Constant.CARD_SLOT_LIMIT do
					local id = slot.card_id_list[j] or 0
					local condition = ManagerContainer.CfgMgr:GetCardUnlockConditionById(slotType * 100 + j)
					if condition ~= nil then
						local result = ConditionJudge:ConditionPassResult1(condition.UnlockingCondition)
						if result then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

function UIEquipTipsCtr:OnOneKeyCardUp()
	local id = self:GetHeroId()
	local logicData, jobType
	if id == 1 then
		logicData = ManagerContainer.DataMgr.UserData:GetHeroData()
		local jobData = ManagerContainer.CfgMgr:GetJobDataById(logicData.configId)
		jobType = jobData.JobType
	else
		logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(id)
		local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
		jobType = cfgData.JobType
	end

	if jobType == nil then return end

	local slot = ManagerContainer.DataMgr.UserData:GetSlotInfoById(id)
	local slotList = slot.slot_list

	if slotList == nil then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CardHandling")
		return
	end

	local slotType = self:GetSlotType()

	local result = false
	local hasEmpty, hasCard = false, false
	local slotCards = {}
	local emptySlot = 0
	if slotList[slotType] ~= nil then
		local cardList = slotList[slotType].card_id_list
		local cardSlotCount = ManagerContainer.RedPointMgr.HeroRPCtr:GetCardSlotCountByType(slotType)
		local idxes = {}
		for j = 1, cardSlotCount do
			if cardList[j] == 0 or cardList[j] == nil then
				idxes[#idxes + 1] = j
				emptySlot = emptySlot + 1
				hasEmpty = true
			end
		end
		if emptySlot == 0 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NoCardTips2")
			return
		end
		local list = ManagerContainer.DataMgr.CardData:GetAllCardDatasByType(slotType)
		local cardDatas = CommonUtil.ArrayFilterSelections(list, Enum.FilterType.AND, {"Profession"}, {jobType})
		if list ~= nil and cardDatas ~= nil then
			if not hasCard then
				hasCard = #list > #cardDatas
			end
		end
		if cardDatas ~= nil and next(cardDatas) then
			local data = {}
			data.slot_id = slotType
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
	if result then
		local data2 = {}
		data2.hero_id = id
		data2.eqiup_slot_data = slotCards

		local oldSlot = CommonUtil.TableClone(ManagerContainer.DataMgr.UserData:GetCurSlotInfos(id))
		ManagerContainer.LuaUIMgr:SetOldSlot(oldSlot)
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_EQUIP_ALL_REQ, data2)
	else
		if hasEmpty then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(hasCard and "NoCardTips2" or "NoCardTips")
		end
	end
end

function UIEquipTipsCtr:OnOneKeyCardDown()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_DOWN_REQ, {hero_id = self:GetHeroId(), sub_slot_index = self:GetSlotType(), card_slot_index = 0})
end

function UIEquipTipsCtr:InsertedCards(slotType)
	local id = self:GetHeroId()
	local slot = ManagerContainer.DataMgr.UserData:GetSlotInfoById(id)
	local slotList = slot.slot_list
	if slotList == nil then return false end

	local result = false
	if slotList[slotType] ~= nil then
		local cardList = slotList[slotType].card_id_list
		for _,v in pairs(cardList) do
			if v > 0 then
				result = true
			end
		end
	end

	return result
end

function UIEquipTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIEquipTipsCtr

