local UIMaterialsTipsView = require("UICollect/UIMaterialsTipsView_Generate")

function UIMaterialsTipsView:OnAwake(data)
	self.controller = require("UICollect/UIMaterialsTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIMaterialsTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIMaterialsTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIMaterialsTipsView:Init()
	self.controller:GetAllMaterialDatas()
	self:InitGrid()
end

function UIMaterialsTipsView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self:RefreshGrid()
end

function UIMaterialsTipsView:RefreshGrid()
	local loopGridView = self.mats.loopGridView
	local length = self.controller:GetShowDataLength()
	self.mats:SetActive(length > 0)
	self.noPets:SetActive(length == 0)
	loopGridView:RefreshListByIndex(length, 0)
end

function UIMaterialsTipsView:InitGrid()
	self.mats.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIMaterialsTipsView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local showData = self.controller:GetShowDataItem(itemIndex)
	local item = nil
	if showData then
		item = gridView:NewListViewItem('IconItem')
		local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'IconItem', item.gameObject)
		CommonUtil.UpdateItemPrefab(self, itemlua, showData, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
	else
		item = gridView:NewListViewItem('IconEmptyItem')
	end
	return item
end

function UIMaterialsTipsView:ShowItemTips(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIMaterialsTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIMaterialsTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
end

function UIMaterialsTipsView:OnCloseClick()
	self:UIClose()
end

function UIMaterialsTipsView:OnHide()

end

function UIMaterialsTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIMaterialsTipsView:OnClose()
	self.mats.loopGridView:Dispose()
end

function UIMaterialsTipsView:OnDispose()
	self.controller:OnDispose()
end

return UIMaterialsTipsView

