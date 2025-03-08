local UIHundredDojoSloganView = require("UIHundredDojo/UIHundredDojoSloganView_Generate")

function UIHundredDojoSloganView:OnAwake(data)
	self.controller = require("UIHundredDojo/UIHundredDojoSloganCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIHundredDojoSloganView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HUNDRED_DOJO_SLOGAN_CHANGED, self, self.OnSloganChanged)
end

function UIHundredDojoSloganView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIHundredDojoSloganView:Init()
	self.controller:InitData()
	local changeSlogan = self.controller:GetChangeSlogan()
	self.inputField.inputField.text = changeSlogan
	self:OnValueChangedInput(changeSlogan)
end

function UIHundredDojoSloganView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	self.inputField.inputField.onValidateInput = nil
	self.inputField.inputField.onValueChanged:RemoveAllListeners()
	self.inputField.inputField.onEndEdit:RemoveAllListeners()
end

function UIHundredDojoSloganView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnConfirm.button, self, self.OnClickConfirmBtn)

	self.inputField.inputField.onValidateInput = self.inputField.inputField.OnValidateInput(self.OnValidateInput, self)
	self.inputField.inputField.onValueChanged:RemoveAllListeners()
	self.inputField.inputField.onValueChanged:AddListener(function(text)
		self:OnValueChangedInput(text)
	end)
	self.inputField.inputField.onEndEdit:RemoveAllListeners()
	self.inputField.inputField.onEndEdit:AddListener(function(text)
		self:OnEndEditInput(text)
	end)
end

function UIHundredDojoSloganView:OnHide()

end

function UIHundredDojoSloganView:OnShow(data)
	self.controller:SetData(data)

end

function UIHundredDojoSloganView:OnClose()
end

function UIHundredDojoSloganView:OnDispose()
	self.controller:OnDispose()
end

function UIHundredDojoSloganView:OnSloganChanged()
	local inputField = self.inputField.inputField
	if not inputField.isFocused then
		local curSlogan = self.controller:GetCurSlogan()
		if inputField.text == curSlogan then
			inputField.text = curSlogan
		end
	end
end

function UIHundredDojoSloganView:OnClickCloseBtn()
	self:UIClose()
end

function UIHundredDojoSloganView:OnClickConfirmBtn()
	local errorCode = self.controller:SendChangeSlogan()
	if errorCode ~= 0 and errorCode ~= 1 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
	self:UIClose()
end

function UIHundredDojoSloganView:OnValidateInput(text, charIndex, addedChar)
	local len = GetActualStringLength(text) + 1
	local max = self.controller:GetSloganLengthMax()
	if len > max then return 0 end
	return addedChar
end

function UIHundredDojoSloganView:OnValueChangedInput(text)
	local len = GetActualStringLength(text)
	local max = self.controller:GetSloganLengthMax()
	self.text.text.text = tostring(len) .. '/' .. tostring(max)
end

function UIHundredDojoSloganView:OnEndEditInput(text)
	self.controller:SetChangeSlogan(text)
end

return UIHundredDojoSloganView

