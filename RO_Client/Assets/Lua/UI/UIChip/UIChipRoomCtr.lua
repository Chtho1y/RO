local UIChipRoomCtr = class("UIChipRoomCtr", require("UICtrBase"))

function UIChipRoomCtr:Init(view)
	self.view = view
end

function UIChipRoomCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIChipRoomCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIChipRoomCtr:GetData()
	return self.data
end

function UIChipRoomCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.chipDatas = nil
end

function UIChipRoomCtr:RefreshCanDecomposeChips()
	local chipDatas = ManagerContainer.DataMgr.ChipData:GetAllChipDatas()
	local newChipDatas = {}
	local owned = false
	local parterId = nil
	for cfgId, value in pairs(chipDatas) do
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
		local composeItem = itemCfgData.ComposeItem
		if composeItem and #composeItem > 0 then
			if type(composeItem[1]) == 'number' then
				-- 单个
				parterId = composeItem[1]
				local data = ManagerContainer.DataMgr.PartnerData:GetPartnerDataById(parterId)
				owned = ((data and data.owned) and data.owned or false)
			else
				owned = true
			end
		end
		if owned then
			local chipData = clone(value)
			local selected = false
			if self.data then
				for _,v in pairs(self.data) do
					if v == cfgId then
						selected = true
						break
					end
				end
			end
			chipData.cost = selected and chipData.num or 0
			table.insert(newChipDatas, chipData)
		end
	end

	table.sort(newChipDatas, function(a, b)
		local itemCfgDataA = ManagerContainer.CfgMgr:GetItemById(a.cfgId)
		local itemCfgDataB = ManagerContainer.CfgMgr:GetItemById(b.cfgId)
		if itemCfgDataA.Quality == itemCfgDataB.Quality then
			return a.cfgId < b.cfgId
		else
			return itemCfgDataA.Quality > itemCfgDataB.Quality
		end
	end)

	self.chipDatas = newChipDatas
end

function UIChipRoomCtr:ResetChipsCost()
	for i = 1, #self.chipDatas do
		self.chipDatas[i].cost = 0
	end
end

function UIChipRoomCtr:GetCanDecomposeChips()
	return self.chipDatas
end

function UIChipRoomCtr:GetExpectDecomposeChips(oneKey)
	if oneKey then
		return self.chipDatas, #self.chipDatas
	else
		local num = 0
		for i = 1, #self.chipDatas do
			if self.chipDatas[i].cost > 0 then
				num = num + 1
			end
		end
		return self.chipDatas, num
	end
end

return UIChipRoomCtr

