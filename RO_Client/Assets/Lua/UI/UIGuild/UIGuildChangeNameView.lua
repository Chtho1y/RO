local UIGuildChangeNameView = require("UIGuild/UIGuildChangeNameView_Generate")

function UIGuildChangeNameView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildChangeNameCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildChangeNameView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_NAME_CHANGED, self, self.OnGuildNameChanged)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_DISBAND_SUCCESS, self, self.OnGuildDisBandSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_QUIT_SUCCESS, self, self.OnGuildQuitSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_KICKOUT_SUCCESS, self, self.OnGuildKickoutSuccess)
end

function UIGuildChangeNameView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildChangeNameView:Init()
	self.input.inputField.text = tostring(self.controller:GetCurName())
	local _, costNum = self.controller:GetCostInfo()
	self.costTxt.text.text = tostring(costNum)
end

function UIGuildChangeNameView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	self.input.inputField.onValidateInput = nil
	self.input.inputField.onEndEdit:RemoveAllListeners()
end

function UIGuildChangeNameView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)

	self.uiBase:AddButtonUniqueEventListener(self.cancelBtn.button, self, self.OnClickCancelBtn)
	self.uiBase:AddButtonUniqueEventListener(self.saveBtn.button, self, self.OnClickSaveBtn)

	self.input.inputField.onValidateInput = self.input.inputField.OnValidateInput(self.OnValidateInput, self)
	self.input.inputField.onEndEdit:RemoveAllListeners()
	self.input.inputField.onEndEdit:AddListener(function(text)
		self:OnEndEditInput(text)
	end)
end

function UIGuildChangeNameView:OnHide()
end

function UIGuildChangeNameView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildChangeNameView:OnClose()
end

function UIGuildChangeNameView:OnDispose()
	self.controller:OnDispose()
end

function UIGuildChangeNameView:OnGuildNameChanged()
	if not self.input.inputField.isFocused then
		self.input.inputField.text = tostring(self.controller:GetCurName())
	end
end


function UIGuildChangeNameView:OnGuildDisBandSuccess()
	self:UIClose()
end

function UIGuildChangeNameView:OnGuildQuitSuccess()
	self:UIClose()
end

function UIGuildChangeNameView:OnGuildKickoutSuccess()
	self:UIClose()
end

function UIGuildChangeNameView:OnClickCloseBtn()
	self:UIClose()
end

function UIGuildChangeNameView:OnClickCancelBtn()
	self:UIClose()
end

function UIGuildChangeNameView:OnClickSaveBtn()
	local text = self.input.inputField.text
	if not text then
		return
	end
	local len = GetActualStringLength(text)
	local min = self.controller:GetNameLengthMin()
	local max = self.controller:GetNameLengthMax()
	if len < min or len > max then
		return
	end
	local errorCode = self.controller:SendGuildChangeNameReq()
	if errorCode == 0 then
		self:UIClose()
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildChangeNameView:OnValidateInput(text, charIndex, addedChar)
	local curLen = 0
	if addedChar >= 48 and addedChar <= 57 then -- 0-9
		curLen = 1
	elseif addedChar >= 65 and addedChar <= 90 then -- A-Z
		curLen = 1
	elseif addedChar >= 97 and addedChar <= 122 then -- a-z
		curLen = 1
	elseif addedChar >= 0x4E00 and addedChar <= 0x9FA5 then -- 中文字
		curLen = 1
	end
	if curLen <= 0 then return 0 end
	local len = GetActualStringLength(text) + curLen
	local max = self.controller:GetNameLengthMax()
	if len > max then return 0 end
	return addedChar
end

function UIGuildChangeNameView:OnEndEditInput(text)
	self.controller:SetChangedName(text)
end

return UIGuildChangeNameView

