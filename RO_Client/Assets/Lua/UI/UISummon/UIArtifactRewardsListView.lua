local UIArtifactRewardsListView = require("UISummon/UIArtifactRewardsListView_Generate")

function UIArtifactRewardsListView:OnAwake(data)
	self.controller = require("UISummon/UIArtifactRewardsListCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIArtifactRewardsListView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIArtifactRewardsListView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIArtifactRewardsListView:Init()
	self:InitGrid()
end

function UIArtifactRewardsListView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.scrollView.scrollRect.enabled = true
end

function UIArtifactRewardsListView:InitGrid()
	self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self.scrollView.scrollRect.enabled = false
	local len = self.controller:GetShowDataLength()
	self.scrollView.loopGridView:RefreshListByIndex(len,0)
end

function UIArtifactRewardsListView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIArtifactRewardsListView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local showData = self.controller:GetShowDataByIdx(itemIndex + 1)
    local item = nil
    if showData then
        item = gridView:NewListViewItem("IconItem")
        item.gameObject.name = itemIndex
        local itemlua = CommonUtil.BindGridViewItem2Lua(self, "IconItem", item.gameObject)
		local logicData = {cfgId = showData}
        CommonUtil.UpdateItemPrefab(self, itemlua, logicData, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
    else
        item = gridView:NewListViewItem('IconEmptyItem')
    end
    return item
end

function UIArtifactRewardsListView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)
end

function UIArtifactRewardsListView:ShowItemTips(btn,params)
	local showData = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(showData)
end

function UIArtifactRewardsListView:OnCloseClick()
	self:UIClose()
end

function UIArtifactRewardsListView:OnHide()

end

function UIArtifactRewardsListView:OnShow(data)
	self.controller:SetData(data)

end

function UIArtifactRewardsListView:OnClose()
	self.scrollView.loopGridView:Dispose()
end

function UIArtifactRewardsListView:OnDispose()
	self.controller:OnDispose()
end

return UIArtifactRewardsListView

