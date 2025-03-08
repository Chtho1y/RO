local UIPetStampView = require("UIPet/UIPetStampView_Generate")
local PetMatsGridView = require("UIPet/PetMatsGridView")
local RectOffset = UnityEngine.RectOffset

function UIPetStampView:OnAwake(data)
	self.controller = require("UIPet/UIPetStampCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetStampView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIPetStampView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPetStampView:Init()
	--补充宠物装备
	self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self:InitEquipGridData()
end

function UIPetStampView:OnPageInEnd()
	self.super.OnPageInEnd(self)

	self:RefreshStamps()
end

function UIPetStampView:InitEquipGridData()
	local loopGridView = self.scrollView.loopGridView

	local itemSize = loopGridView.ItemSize
	local itemPadding = loopGridView.ItemPadding
	local padding = loopGridView.Padding
	local itemSizeWithPadding = itemPadding + itemSize
	local width = loopGridView.ViewPortWidth - padding.left - padding.right + itemPadding.x
	local height = loopGridView.ViewPortHeight - padding.top
	local row = Mathf.Floor(width / (itemSizeWithPadding.x))
	local column = Mathf.Ceil(height / (itemSizeWithPadding.y))
	local realWidth = row * itemSizeWithPadding.x
	local offset = width - realWidth
	if offset > 0 then
		offset = offset * 0.5
		local newPadding = RectOffset(offset + padding.left, offset + padding.right, padding.top, padding.bottom)
		loopGridView:SetPadding(newPadding)
	end
	loopGridView:SetGridFixedGroupCount(SuperScrollView.GridFixedType.ColumnCountFixed, row)
	self.controller:SetGridRowColumn(row, column)
end

function UIPetStampView:RefreshStamps()
	self.controller:RefreshShowDataType()

	local loopGridView = self.scrollView.loopGridView
	local length = self.controller:GetShowDataLength()
	local realLength = self.controller:GetShowDataRealLength()
	self.noStamp:SetActive(realLength == 0)
	if realLength > 0 then
		loopGridView:SetListItemCount(length, true)
		loopGridView:RefreshAllShownItem()
	end
end


function UIPetStampView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local length = self.controller:GetShowDataLength()
	if (itemIndex < 0 or itemIndex >= length) then
		return nil
	end
	local showData = self.controller:GetShowData(itemIndex)
	local item = nil
	if showData then
		item = gridView:NewListViewItem("IconItem")
		item.gameObject.name = itemIndex
		local itemlua = CommonUtil.BindGridViewItem2Lua(self, "IconItem", item.gameObject)
		CommonUtil.UpdateItemPrefab(self, itemlua, showData, Enum.ItemIEnterType.PetStamp, self, self.OnStampClick)
	else
		item = gridView:NewListViewItem('IconEmptyItem')
	end
	return item
end

function UIPetStampView:OnStampClick(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIPetStampView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPetStampView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)
end

function UIPetStampView:OnCloseClick()
	self:UIClose()
end

function UIPetStampView:OnHide()

end

function UIPetStampView:OnShow(data)
	self.controller:SetData(data)

end

function UIPetStampView:OnClose()
	self.scrollView.loopGridView:Dispose()
end

function UIPetStampView:OnDispose()
	self.controller:OnDispose()
end

return UIPetStampView

