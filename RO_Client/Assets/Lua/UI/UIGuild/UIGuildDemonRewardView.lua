local UIGuildDemonRewardView = require("UIGuild/UIGuildDemonRewardView_Generate")
local AwardList = {}

function UIGuildDemonRewardView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildDemonRewardCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildDemonRewardView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIGuildDemonRewardView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildDemonRewardView:Init()
	self.scrollView.scrollRect.enabled = false
	self:InitGrid()
end

function UIGuildDemonRewardView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.scrollView.scrollRect.enabled = true
end

function UIGuildDemonRewardView:InitGrid()
    self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
        return self:GetItemByRowColumn(gridView, itemIndex, row, column)
    end, nil)

    self:InitData()
end

function UIGuildDemonRewardView:InitData()
	AwardList = self.controller:GetShowData()
	local showId  = self.controller:GetShowId()
	self.scrollView.loopGridView:RefreshListByIndex(AwardList and #AwardList,showId)
end

function UIGuildDemonRewardView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local item = nil
	item = gridView:NewListViewItem('DemonRewardItem')
	local showData = AwardList[itemIndex + 1]
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'DemonRewardItem', item.gameObject)
	CommonUtil.UpdateItemPrefab(self, itemLua, showData)
	return item
end

function UIGuildDemonRewardView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuildDemonRewardView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	self.uiBase:AddButtonUniqueEventListener(self.closeBtn.button, self, self.OnClickCloseBtn)
end

function UIGuildDemonRewardView:OnClickCloseBtn()
	self:UIClose()
end

function UIGuildDemonRewardView:OnHide()

end

function UIGuildDemonRewardView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildDemonRewardView:OnClose()
end

function UIGuildDemonRewardView:OnDispose()
	self.scrollView.loopGridView:Dispose()
	self.controller:OnDispose()
end

return UIGuildDemonRewardView

