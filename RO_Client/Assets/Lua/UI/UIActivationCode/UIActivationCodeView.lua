local UIActivationCodeView = require("UIActivationCode/UIActivationCodeView_Generate")

function UIActivationCodeView:OnAwake(data)
	self.controller = require("UIActivationCode/UIActivationCodeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIActivationCodeView:AddEventListener()

end

function UIActivationCodeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIActivationCodeView:Init()
end

function UIActivationCodeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIActivationCodeView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.okBtn.button,self, self.OnClickOkBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCancelBtn)
end

function UIActivationCodeView:OnClickCancelBtn()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_CLOSED_ACTIVATIONCODE)
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIActivationCodePage)
end

function UIActivationCodeView:OnClickOkBtn()
	local codeTxt = self.codeInput.inputField.text
	if codeTxt == nil or codeTxt == "" then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("请输入正确的冒险码!")
		return
	end

	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_USED_ACTIVATIONCODE,codeTxt)
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIActivationCodePage)
end

function UIActivationCodeView:OnHide()

end

function UIActivationCodeView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIActivationCodeView:OnClose()
end

function UIActivationCodeView:OnDispose()

end

return UIActivationCodeView

