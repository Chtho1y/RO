local UIActivityChipRewardPetExchangeCtr = class("UIActivityChipRewardPetExchangeCtr", require("UICtrBase"))

function UIActivityChipRewardPetExchangeCtr:Init(view)
	self.view = view
end

function UIActivityChipRewardPetExchangeCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIActivityChipRewardPetExchangeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIActivityChipRewardPetExchangeCtr:GetData()
	return self.data
end

function UIActivityChipRewardPetExchangeCtr:GetRuleKey()
	return self.activityData and self.activityData.infoLangKey ~= '' and self.activityData.infoLangKey  or "not configuration"
end

function UIActivityChipRewardPetExchangeCtr:GetActId()
	return self.data.actId
end

function UIActivityChipRewardPetExchangeCtr:GetShowListByItemTypeAndFiltrList(itemType,filtrList)
	local list = {}
	if itemType == Enum.ItemType.Item or itemType == Enum.ItemType.Gift then
		local datas = ManagerContainer.DataMgr.BagData:GetAllItemDatas()
		for i = 1, #filtrList do
			local itemId = datas[filtrList[i]]
			for _,v in pairs(datas) do
				if v.cfgId == itemId and v.num > 0 then
					table.insert(list, CommonUtil.TableClone(v))
					break
				end
			end
		end
		--CommonUtil.ArraySortSelections(list, Enum.TableSortRule.Down, "CardType", "CardLevel", "cfgId")
	elseif itemType == Enum.ItemType.Card then
		local datas = ManagerContainer.DataMgr.CardData:GetAllCardDataMap()
		for i = 1, #filtrList do
			local data = datas[filtrList[i]]
			if data and data.num > 0 then
				table.insert(list, CommonUtil.TableClone(data))
			end
		end
		CommonUtil.ArraySortSelections(list, Enum.TableSortRule.Down, "CardType", "CardLevel", "cfgId")
	elseif itemType == Enum.ItemType.Equip then
		local datas = ManagerContainer.DataMgr.EquipData:GetAllEquipDataMap()
		for i = 1, #filtrList do
			local data = datas[filtrList[i]]
			if data and data.num > 0 then
				table.insert(list, CommonUtil.TableClone(data))
			end
		end
		--CommonUtil.ArraySortSelections(list, Enum.TableSortRule.Down, "CardType", "CardLevel", "cfgId")
	end
	return list
end

function UIActivityChipRewardPetExchangeCtr:GetShowListByItemTypeAndId(itemType,itemId)
	local list = {}
	if itemType == Enum.ItemType.Item or itemType == Enum.ItemType.Gift then
		local datas = ManagerContainer.DataMgr.BagData:GetAllItemDatas()
		for _,v in pairs(datas) do
			if v.cfgId == itemId and v.num > 0 then
				table.insert(list, CommonUtil.TableClone(v))
				break
			end
		end
	elseif itemType == Enum.ItemType.Card then
		local datas = ManagerContainer.DataMgr.CardData:GetAllCardDataMap()
		local data = datas[itemId]
		if data and data.num > 0 then
			table.insert(list, CommonUtil.TableClone(data))
		end
	elseif itemType == Enum.ItemType.Equip then
		local datas = ManagerContainer.DataMgr.EquipData:GetAllEquipDataMap()
		local data = datas[itemId]
		if data and data.num > 0 then
			table.insert(list, CommonUtil.TableClone(data))
		end
	end
	return list
end


function UIActivityChipRewardPetExchangeCtr:RefreshChipDatas()
	local actId = self:GetActId()
	self.activityData = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(actId)
end

function UIActivityChipRewardPetExchangeCtr:GetRemainTime(id)
	return self.activityData:LeftTime()
end

function UIActivityChipRewardPetExchangeCtr:GetIndexByCfgId(id)
	local List = self.activityData.data
	for i = 1, #List do
		if List[i].cfgId == id then
			return i
		end
	end
	return 0
end

function UIActivityChipRewardPetExchangeCtr:GetChipShowDataByIdx(idx)
	return self.activityData.data[idx + 1]
end

function UIActivityChipRewardPetExchangeCtr:GetGlobalCount(id)
	return self.activityData:GetGlobalCount(id)
end

function UIActivityChipRewardPetExchangeCtr:GetChipDataLength()
	return #self.activityData.data
end

function UIActivityChipRewardPetExchangeCtr:SendGetActivityRewardReq(idx,data)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVITIES_EXCHANGE_REQ,{reward_idx = idx,activity_id = self:GetActId(),data = data})
end

function UIActivityChipRewardPetExchangeCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.activityData = nil
end

return UIActivityChipRewardPetExchangeCtr

