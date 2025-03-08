local UIPetStampListView = require("UIPet/UIPetStampListView_Generate")
local IconItemCtr = require("Common/IconItemCtr")
local EquipListItemCtr = require("Common/EquipListItemCtr")

function UIPetStampListView:OnAwake(data)
	self.controller = require("UIPet/UIPetStampListCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetStampListView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIPetStampListView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPetStampListView:Init()
	self:InitGrid()
	self:Refresh()
end

function UIPetStampListView:InitGrid()
	self.scrollView.loopListView:InitListView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIPetStampListView:Refresh()
	self:RefreshTop()
end

function UIPetStampListView:OnPageInEnd()
	self:RefreshStampList()
	self.super.OnPageInEnd(self)
end

function UIPetStampListView:RefreshTop()
	local equipedStampData = self.controller:GetStampData()
	self.equipBlank:SetActive(equipedStampData == nil)
	self.equipListEquippedItem:SetActive(equipedStampData ~= nil)
	if equipedStampData then
		IconItemCtr:SetData(self, self.iconItem, equipedStampData, Enum.ItemIEnterType.PetStamp)

		local cfgData = ManagerContainer.CfgMgr:GetPetEquipCfgDataById(equipedStampData.cfgId)
		if not cfgData then
			return
		end

		local stampLvCfgData = ManagerContainer.CfgMgr:GetPetEquipExpCfgDataByLvAndCfgId(equipedStampData.lv, equipedStampData.cfgId)

		if not stampLvCfgData then
			return
		end

		self.topItem.textName.uILocalizeScript:SetContent(cfgData.Name)

		local baseAttrs = clone(stampLvCfgData.Nature)
		table.sort(baseAttrs, function (a,b)
			return a[1] < b[1]
		end)
		local idx = 0
		for i = 1, #baseAttrs do
			idx = idx + 1
			CommonUtil.BatchCreateItemsLoopWithMould(self, self.equipBaseAttrItem, self.topItem.grid.transform, baseAttrs[i], i)
		end
	end
end

function UIPetStampListView:RefreshStampList()
	local stampList = self.controller:GetAllTypeStampDatas()
	local length = #stampList
	self.scrollView.loopListView:SetListItemCount(length, true)
	--self.scrollView.loopListView:RefreshAllShownItem()
end

function UIPetStampListView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local showData = self.controller:GetShowDataByIdx(itemIndex)
	if not showData then
		return
	end
	local item = gridView:NewListViewItem("EquipListItem")
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, "EquipListItem", item.gameObject)
	local equipLua = itemlua.iconItem
	IconItemCtr:SetData(self, equipLua, showData, Enum.ItemIEnterType.PetStamp)
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(showData.cfgId)
	itemlua.textName.text.text = I18N.T(itemCfgData.Name)
	local stampLvCfgData = ManagerContainer.CfgMgr:GetPetEquipExpCfgDataByLvAndCfgId(showData.lv, showData.cfgId)

	if not stampLvCfgData then
		return
	end

	local baseAttrs = clone(stampLvCfgData.Nature)
	table.sort(baseAttrs, function (a,b)
		return a[1] < b[1]
	end)

	local idx = 0
	for i = 1, #baseAttrs do
		idx = idx + 1
		CommonUtil.BatchCreateItemsLoopWithMould(self, itemlua.equipBaseAttrItem, itemlua.grid.transform, baseAttrs[i], i)
	end
	itemlua.btnChange:SetActive(true)
	itemlua.btnDown:SetActive(false)
	self.uiBase:AddButtonUniqueEventListener(itemlua.btnChange.button, self, self.SendStampChange, showData.id)

	itemlua.contentSizeFitter:SetLayoutVertical()
	local minHeight = itemlua.layoutElement.minHeight
	if #baseAttrs > 2 then
		local addtional = #baseAttrs - 2
		itemlua.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, minHeight + addtional * 50);
	else
		itemlua.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, minHeight);
	end
	return item
end

function UIPetStampListView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIPetStampListView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnDown.button, self, self.OnDownClick)
end

function UIPetStampListView:OnCloseClick()
	self:UIClose()
end

function UIPetStampListView:OnDownClick()
	self.controller:SendDownStamp()
	self:UIClose()
end

function UIPetStampListView:SendStampChange(button, params)
	local id = params[0]
	self.controller:SendChangeStamp(id)
	self:UIClose()
end

function UIPetStampListView:OnHide()

end

function UIPetStampListView:OnShow(data)
	self.controller:SetData(data)

end

function UIPetStampListView:OnClose()
	self.scrollView.loopListView:Dispose()
end

function UIPetStampListView:OnDispose()
	self.controller:OnDispose()
end

return UIPetStampListView

