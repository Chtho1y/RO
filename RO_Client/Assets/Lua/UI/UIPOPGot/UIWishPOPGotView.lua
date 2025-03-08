local UIWishPOPGotView = require("UIPOPGot/UIWishPOPGotView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

function UIWishPOPGotView:OnAwake(data)
	self.controller = require("UIPOPGot/UIWishPOPGotCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIWishPOPGotView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIWishPOPGotView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIWishPOPGotView:Init()
	self.scrollView.scrollRect.enabled = false
	self.rewardData = self.controller:GetData()
	local len  = self.rewardData and #self.rewardData or 0
	self.isCanClose = len < 2
	if len >= 2 then
		if not self.timer then
			self.timer = Timer.New(function()
				self.isCanClose = true
			end,1.5,1)
			self.timer:Start()
		end
	end
	self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self.scrollView.loopGridView:RefreshListByIndex(len, 0)
end
function UIWishPOPGotView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.scrollView.scrollRect.enabled = true
end

function UIWishPOPGotView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local rewardData = self.rewardData[itemIndex + 1]
	local item
	local itemlua
	if rewardData.lucky then
		item = gridView:NewListViewItem('WishLuckyItem')
		itemlua = CommonUtil.BindGridViewItem2Lua(self, 'WishLuckyItem', item.gameObject)
		local data = {cfgId = rewardData.cfgId,num = rewardData.num}
		IconItemCtr:SetData(self, itemlua.iconItem, data,nil,self,self.OnItemClick)
	else
		item = gridView:NewListViewItem('IconItem')
		itemlua = CommonUtil.BindGridViewItem2Lua(self, 'IconItem', item.gameObject)
		local data = {cfgId = rewardData.cfgId,num = rewardData.num}
		IconItemCtr:SetData(self, itemlua, data,nil,self,self.OnItemClick)
	end
	return item
end

function UIWishPOPGotView:OnItemClick(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIWishPOPGotView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIWishPOPGotView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, function()
		if self.isCanClose then
			self:UIClose()
		end
	end)
end

function UIWishPOPGotView:OnHide()

end

function UIWishPOPGotView:OnShow(data)
	self.controller:SetData(data)

end

function UIWishPOPGotView:OnClose()
end

function UIWishPOPGotView:OnDispose()
	self.controller:OnDispose()
	if self.timer then
		self.timer:Stop()
	end
	self.timer = nil
	self.scrollView.loopGridView:Dispose()
end

return UIWishPOPGotView

