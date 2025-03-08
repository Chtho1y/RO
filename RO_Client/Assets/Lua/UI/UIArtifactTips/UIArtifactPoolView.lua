local UIArtifactPoolView = require("UIArtifactTips/UIArtifactPoolView_Generate")

function UIArtifactPoolView:OnAwake(data)
	self.controller = require("UIArtifactTips/UIArtifactPoolCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIArtifactPoolView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SKILL_EQUIP_POOL_REFRESH, self, self.OnAckBack)
end

function UIArtifactPoolView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIArtifactPoolView:Init()
	self:InitGrid()
	self.next:SetActive(false)
	self.controller:SendSkillEquipPoolReq()
end

function UIArtifactPoolView:OnAckBack()
	self.controller:RefreshRandomPool()
	self:RefreshPool()
	self:RefreshTextShow()
end

function UIArtifactPoolView:InitGrid()
	self.opend.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetOpenedItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)

	self.next.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetNextItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIArtifactPoolView:RefreshPool()
	local nextLength = self.controller:GetNextRandomPoolLength()
	self.next:SetActive(nextLength > 0)
	if nextLength > 0 then
		local nextLoopGridView = self.next.loopGridView
		nextLoopGridView:SetListItemCount(nextLength, true)
		nextLoopGridView:RefreshAllShownItem()
	end

	local openedLength = self.controller:GetOpenedRandomPoolLength()
	local curLoopGridView = self.opend.loopGridView
	curLoopGridView:SetListItemCount(openedLength, true)
	curLoopGridView:RefreshAllShownItem()
end

function UIArtifactPoolView:RefreshTextShow()
	local curId = self.controller:GetCurId()
	local nextRemainDay = self.controller:GetNextRemainDay()
	self.opend.text.uILocalizeScript:SetContent(curId == 1 and "TitleOpend" or "TitleOpendNew")
	self.next.text.uILocalizeScript:SetContentAndValues("TitleNextPool", {nextRemainDay})
	self.notice:SetActive(curId > 1)
end

function UIArtifactPoolView:GetOpenedItemByRowColumn(gridView, itemIndex, row, column)
	local showData = self.controller:GetOpendRandomPoolDataByIdx(itemIndex)
    local item = nil
    if showData then
        item = gridView:NewListViewItem("IconItem")
        item.gameObject.name = itemIndex
        local itemlua = CommonUtil.BindGridViewItem2Lua(self, "IconItem", item.gameObject)
        CommonUtil.UpdateItemPrefab(self, itemlua, showData, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
    else
        item = gridView:NewListViewItem('IconEmptyItem')
    end
    return item
end

function UIArtifactPoolView:GetNextItemByRowColumn(gridView, itemIndex, row, column)
	local showData = self.controller:GetNextRandomPoolDataByIdx(itemIndex)
    local item = nil
    if showData then
        item = gridView:NewListViewItem("IconItem")
        item.gameObject.name = itemIndex
        local itemlua = CommonUtil.BindGridViewItem2Lua(self, "IconItem", item.gameObject)
        CommonUtil.UpdateItemPrefab(self, itemlua, showData, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
    else
        item = gridView:NewListViewItem('IconEmptyItem')
    end
    return item
end

function UIArtifactPoolView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIArtifactPoolView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)
end

function UIArtifactPoolView:OnCloseClick()
	self:UIClose()
end

function UIArtifactPoolView:ShowItemTips(button, params)
	local skillEuipData = params[0]
	local params = {{cfgId = skillEuipData.cfgId, jobType = skillEuipData.JobType, logicData = skillEuipData}, Enum.ItemIEnterType.SkillEquip, self.uiData.id}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIArtifactTips, params)		
end

function UIArtifactPoolView:OnHide()

end

function UIArtifactPoolView:OnShow(data)
	self.controller:SetData(data)

end

function UIArtifactPoolView:OnClose()
	self.opend.loopGridView:Dispose()
	self.next.loopGridView:Dispose()
end

function UIArtifactPoolView:OnDispose()
	self.controller:OnDispose()
end

return UIArtifactPoolView

