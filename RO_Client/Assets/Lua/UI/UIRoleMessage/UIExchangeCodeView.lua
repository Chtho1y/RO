local UIExchangeCodeView = require("UIRoleMessage/UIExchangeCodeView_Generate")

function UIExchangeCodeView:OnAwake(data)
	self.controller = require("UIRoleMessage/UIExchangeCodeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIExchangeCodeView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EXCHANGE_REWARD_SUCCESS, self, self.OnExchangeSuccess)
end

function UIExchangeCodeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIExchangeCodeView:Init()
	
end

function UIExchangeCodeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIExchangeCodeView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnBtnCloseClick);
	self.uiBase:AddButtonEventListener(self.exchangeBtn.button, self, self.OnBtnExchangeClick);
end

function UIExchangeCodeView:OnBtnCloseClick()
	self:UIClose()
end

function UIExchangeCodeView:OnBtnExchangeClick()
	if self.inputField.inputField.text == "" then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("InputExchangeCode")
		return
	end

	ManagerContainer.DataMgr.UserData:SendGiftCode(self.inputField.inputField.text)
end

function UIExchangeCodeView:OnHide()

end

function UIExchangeCodeView:OnShow(data)
	self.controller:SetData(data)

end

function UIExchangeCodeView:OnExchangeSuccess()
	self.inputField.inputField.text = ""
end

function UIExchangeCodeView:OnClose()
	self.inputField.inputField.text = ""
end

function UIExchangeCodeView:OnDispose()
	self.controller:OnDispose()
end

return UIExchangeCodeView

