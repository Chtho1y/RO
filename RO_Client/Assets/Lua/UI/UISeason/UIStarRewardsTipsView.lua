local UIStarRewardsTipsView = require("UISeason/UIStarRewardsTipsView_Generate")
local rewards

function UIStarRewardsTipsView:OnAwake(data)
	self.controller = require("UISeason/UIStarRewardsTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIStarRewardsTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIStarRewardsTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIStarRewardsTipsView:Init()
	rewards = self.controller:GetData()
	self.goodsList.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self.goodsList.loopGridView:RefreshListByIndex(rewards and #rewards or 0, 0)
end

function UIStarRewardsTipsView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local item = gridView:NewListViewItem('StarSingItem')
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'StarSingItem', item.gameObject)
	itemlua.num.text.text = itemIndex + 1
	CommonUtil.UpdateItemPrefab(self, itemlua.iconItem, rewards[itemIndex + 1], Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
	return item
end

function UIStarRewardsTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIStarRewardsTipsView:OnClickCloseBtn()
	self:UIClose()
end

function UIStarRewardsTipsView:ShowItemTips(button, params)
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

function UIStarRewardsTipsView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
end

function UIStarRewardsTipsView:OnHide()

end

function UIStarRewardsTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIStarRewardsTipsView:OnClose()

end

function UIStarRewardsTipsView:OnDispose()
	self.controller:OnDispose()
	self.goodsList.loopGridView:Dispose()
end

return UIStarRewardsTipsView

