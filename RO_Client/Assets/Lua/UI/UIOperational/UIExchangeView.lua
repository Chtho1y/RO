local UIExchangeView = require("UIOperational/UIExchangeView_Generate")
local CompetitionExchange = require("UIOperational/CompetitionExchange")

function UIExchangeView:OnAwake(data)
	self.controller = require("UIOperational/UIExchangeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIExchangeView:AddEventListener()

end

function UIExchangeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIExchangeView:Init()
	local data = self.controller:GetData()

	if not self.exchangeView then
		if data == Enum.UIPageName.UISeason then
			self.exchangeView = CompetitionExchange:new()
		end
	end

	if not self.exchangeView then return end

	self.exchangeView:Init(self)
end

function UIExchangeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIExchangeView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.CloseSelf)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.CloseSelf)

	self.uiBase:AddButtonEventListener(self.item1.btnExchange.button,self, self.OnSureClick, 1)
	self.uiBase:AddButtonEventListener(self.item2.btnExchange.button,self, self.OnSureClick, 2)
    self.uiBase:AddButtonEventListener(self.item3.btnExchange.button,self, self.OnSureClick, 3)
    self.uiBase:AddButtonEventListener(self.item4.btnExchange.button,self, self.OnSureClick, 4)
end

function UIExchangeView:CloseSelf()
	self:UIClose()
end

function UIExchangeView:ShowItemTips(button, params)
	if self.exchangeView and self.exchangeView.ShowItemTips then
		self.exchangeView:ShowItemTips(button, params)
	end
end

function UIExchangeView:OnSureClick(button, params)
	if self.exchangeView and self.exchangeView.OnSureClick then
		self.exchangeView:OnSureClick(button, params)
	end
end

function UIExchangeView:OnHide()

end

function UIExchangeView:OnShow(data)
	self.controller:SetData(data)

end

function UIExchangeView:OnClose()
end

function UIExchangeView:OnDispose()
	if self.exchangeView then
		self.exchangeView:Dispose()
		self.exchangeView = nil
	end
	self.controller:OnDispose()
end

return UIExchangeView

