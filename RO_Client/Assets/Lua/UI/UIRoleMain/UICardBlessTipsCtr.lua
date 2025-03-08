local UICardBlessTipsCtr = class("UICardBlessTipsCtr", require("UICtrBase"))

function UICardBlessTipsCtr:Init(view)
	self.view = view
end

function UICardBlessTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UICardBlessTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UICardBlessTipsCtr:GetData()
	return self.data
end

function UICardBlessTipsCtr:GetCurLv()
	return self.data.curLv
end

function UICardBlessTipsCtr:GetSuitCount()
	return self.data.count, self.data.totalCount
end

function UICardBlessTipsCtr:GetState()
	return self.data.state
end

function UICardBlessTipsCtr:GetSlot()
	return self.data.slot
end

function UICardBlessTipsCtr:GetCurCardSuitLv()
	local curLv = self:GetCurLv()
	local allCfgDatas = ManagerContainer.CfgMgr:GetAllCardSuitNewCfg()
	local isMax = curLv == #allCfgDatas
	return curLv, isMax
end

function UICardBlessTipsCtr:GetSatisfyCardCountByLv(lv)
	local slot = self:GetSlot()
	local equipedCards = {}
	for _,v in pairs(slot.slot_list) do
		local cardList = v.card_id_list
		for _,v1 in pairs(cardList) do
			if v1 and v1 > 0 then
				equipedCards[#equipedCards + 1] = v1
			end
		end
	end

	local cfgData = ManagerContainer.CfgMgr:GetCardSuitNewCfgById(lv)
	local enoughCount = {}
	local count = {}
	for j = #cfgData.TriggerConditions, 1, -1 do
		local condition = cfgData.TriggerConditions[j]
		local type = condition[1]
		local lv = condition[2]
		local num = condition[3]
		enoughCount[j] = num
		if not count[j] then
			count[j] = 0
		end

		for i = #equipedCards, 1, -1 do
			local cfgId = equipedCards[i]
			local cardCfgData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)
			if cardCfgData and cardCfgData.CardType >= type and cardCfgData.CardLevel >= lv then
				count[j] = count[j] + 1
				table.remove(equipedCards, i)
				if count[j] >= enoughCount[j] then
					break
				end
			end
		end
		count[j] = math.min(count[j], enoughCount[j])
	end

	return enoughCount, count
end

function UICardBlessTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UICardBlessTipsCtr

