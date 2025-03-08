local UIBagCtr = class("UIBagCtr", require("UICtrBase"))

function UIBagCtr:Init(view)
	self.view = view
end

function UIBagCtr:SetData(data)
	self.asyncIdx = 0
	self:ClearData()
	self.selectPageType = data or self.selectPageType or Enum.BagViewPageType.Item

	if self.filterData == nil then
		self.filterData = {}
		self.filterData.raritySelections = {}
		self.filterData.attrSelections = {}
		self.filterData.typeSelections = {}
		self.isFilter = false
	end
end

function UIBagCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIBagCtr:GetData()
	return self.data
end

function UIBagCtr:OnDispose()
	self.data = nil
	self.view = nil

	self:ClearData()

	self.selectPageType = nil
	self.filterData = nil
	self.isFilter = false
end

function UIBagCtr:ClearData()
	--self.selectPageType = nil
	self.showDatas = nil
	self.showDataLength = nil
	self.equipDatas = nil
	self.itemDatas = nil
	self.cardDatas = nil
	-- self.row = nil
	-- self.minColumn = nil
end

function UIBagCtr:GetBagViewPageType()
	return self.selectPageType
end

function UIBagCtr:SetBagViewPageType(bagViewPageType)
	if self.selectPageType == bagViewPageType then
		return false
	end
	self.selectPageType = bagViewPageType
	self:RefreshShowDataType()
	return true
end

function UIBagCtr:RefreshShowDataType()
	if self.selectPageType == Enum.BagViewPageType.Equip then
		if not self.equipDatas then
			self.equipDatas = self:RefreshEquipDatas()
		end
		self.showDatas = self.equipDatas
	elseif self.selectPageType == Enum.BagViewPageType.Item then
		if not self.itemDatas then
			self.itemDatas = self:RefreshItemDatas()
		end
		self.showDatas = self.itemDatas
	elseif self.selectPageType == Enum.BagViewPageType.Card then
		if not self.cardDatas then
			self.cardDatas = self:RefreshCardDatas()
		end
		self.showDatas = self.cardDatas
	elseif self.selectPageType == Enum.BagViewPageType.SkillEquip then
		-- if not self.skillEquipDatas then
			self.skillEquipDatas = self:RefreshSkillEquipDatas()
		-- end
		self.showDatas = self.skillEquipDatas
	else
		self.showDatas = nil
	end
	local showDataLength = 0
	if self.showDatas then
		showDataLength = #self.showDatas
		-- if self.row and self.minColumn then
		-- 	local curColumn = Mathf.Ceil(showDataLength / self.row) + 2
		-- 	if curColumn < self.minColumn then
		-- 		curColumn = self.minColumn
		-- 	end
		-- 	showDataLength = curColumn * self.row
		-- end
	end
	self.showDataLength = showDataLength
end

-- function UIBagCtr:SetGridRowColumn(row, minColumn)
-- 	self.row = row
-- 	self.minColumn = minColumn
-- end

function UIBagCtr:GetShowDataLength()
	return self.showDataLength or 0
end

function UIBagCtr:GetShowData(itemIndex)
	return self.showDatas and self.showDatas[itemIndex + 1] or nil
end

function UIBagCtr:GetAllShowDatas()
	return self.showDatas
end

function UIBagCtr:RefreshViewDatas(bagViewPageType)
	if bagViewPageType == Enum.BagViewPageType.Equip then
		self.equipDatas = nil
	elseif bagViewPageType == Enum.BagViewPageType.Item then
		self.itemDatas = nil
	elseif bagViewPageType == Enum.BagViewPageType.Card then
		self.cardDatas = nil
	elseif bagViewPageType == Enum.BagViewPageType.SkillEquip then
		self.skillEquipDatas = nil
	end
	if self.selectPageType == bagViewPageType then
		self:RefreshShowDataType()
	end
end

function UIBagCtr:RefreshEquipDatas()
	local equipDatasSource = ManagerContainer.DataMgr.EquipData:GetAllEquipDataMap()
	local ls = {}
	for _,v in pairs(equipDatasSource) do
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(v.cfgId)
		local composition = itemCfgData.Composition
		local num = v.num
		while (num > composition) do
			table.insert(ls, {cfgId = v.cfgId, num = composition, fightPower = v.fightPower})
			num = num - composition
		end
		-- 最后还需要把剩余的单独占格
		if num > 0 then
			table.insert(ls, {cfgId = v.cfgId, num = num, fightPower = v.fightPower})
		end
	end
	table.sort(ls, function(a, b)
		local equipCfgDataA = ManagerContainer.CfgMgr:GetEquipById(a.cfgId)
		local equipCfgDataB = ManagerContainer.CfgMgr:GetEquipById(b.cfgId)
		if equipCfgDataA.EquipLevel == equipCfgDataB.EquipLevel then
			if equipCfgDataA.Id == equipCfgDataB.Id then
				return a.num > b.num
			else
				return equipCfgDataA.Id > equipCfgDataB.Id
			end
		else
			return equipCfgDataA.EquipLevel > equipCfgDataB.EquipLevel
		end
	end)
	return ls
end

function UIBagCtr:RefreshItemDatas()
	local itemDatasSource = ManagerContainer.DataMgr.BagData:GetAllItemDatas()
	local ls = {}
	for _,v in pairs(itemDatasSource) do
		if v.num > 0 then
			table.insert(ls, v)
		end
	end
	-- local fashionPaperMap = ManagerContainer.DataMgr.FashionData:GetFashionPaperMap()
	-- for key,value in pairs(fashionPaperMap) do
	-- 	if value > 0 then
	-- 		table.insert(ls, { cfgId = key, num = value })
	-- 	end
	-- end
	table.sort(ls, function(a, b)
		local itemCfgDataA = ManagerContainer.CfgMgr:GetItemById(a.cfgId)
		local itemCfgDataB = ManagerContainer.CfgMgr:GetItemById(b.cfgId)
		if itemCfgDataA.Quality == itemCfgDataB.Quality then
			return a.id < b.id
		else
			return itemCfgDataA.Quality > itemCfgDataB.Quality
		end
	end)
	return ls
end

function UIBagCtr:RefreshCardDatas()
	local cardDatasSource = ManagerContainer.DataMgr.CardData:GetAllCardDataMap()
	local ls = {}
	for _,v in pairs(cardDatasSource) do
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(v.cfgId)
		local composition = itemCfgData.Composition
		local num = v.num
		while (num > composition) do
			local data = {cfgId = v.cfgId, num = composition,  CardType = v.CardType,
						  CardLevel = v.CardLevel,FightPower = v.FightPower,Profession = v.Profession,Attribute2 = v.Attribute2,CardLocation = v.CardLocation}
			table.insert(ls, data)
			num = num - composition
		end
		-- 最后还需要把剩余的单独占格
		if num > 0 then
			local data = {cfgId = v.cfgId, num = num,  CardType = v.CardType,
						  CardLevel = v.CardLevel,FightPower = v.FightPower,Profession = v.Profession,Attribute2 = v.Attribute2,CardLocation = v.CardLocation}
			table.insert(ls, data)
		end
	end
	--table.sort(ls, function(a, b)
	--	local itemCfgDataA = ManagerContainer.CfgMgr:GetItemById(a.cfgId)
	--	local itemCfgDataB = ManagerContainer.CfgMgr:GetItemById(b.cfgId)
	--	if itemCfgDataA.Quality == itemCfgDataB.Quality then
	--		if a.cfgId == b.cfgId then
	--			return a.num > b.num
	--		else
	--			return a.cfgId > b.cfgId
	--		end
	--	else
	--		return itemCfgDataA.Quality > itemCfgDataB.Quality
	--	end
	--end)
	local cardDatas
	cardDatas = CommonUtil.ArrayFilterSelections(ls, Enum.FilterType.AND, {"CardType", "Attribute2", "CardLocation"}, {self.filterData.raritySelections, self.filterData.attrSelections, self.filterData.typeSelections})

	if cardDatas ~= nil then
		CommonUtil.ArraySortSelections(cardDatas, Enum.TableSortRule.Down, "CardType", "CardLevel", "FightPower", "cfgId")
	end

	if cardDatas == nil then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NoCardTips3")
	end
	--LogHRWarning(Inspect(cardDatas))
	return cardDatas
end

function UIBagCtr:RefreshSkillEquipDatas()
	local skillEquipDatas = ManagerContainer.DataMgr.SkillEquipData:GetSkillEquips()
	if skillEquipDatas then
		CommonUtil.ArraySortSelections(skillEquipDatas, Enum.TableSortRule.Down,  "quality", "starLv", "cfgId", "id")
	end
	return skillEquipDatas
end

function UIBagCtr:SetFilterData(data, isFilter)
	self.filterData = data
	self.isFilter = isFilter
end

function UIBagCtr:GetFilterData()
	return self.filterData
end

function UIBagCtr:GetIsFilter()
	return self.isFilter
end

return UIBagCtr

