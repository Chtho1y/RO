local UIGuildSettingsView = require("UIGuild/UIGuildSettingsView_Generate")

function UIGuildSettingsView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildSettingsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildSettingsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_DISBAND_SUCCESS, self, self.OnGuildDisBandSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_QUIT_SUCCESS, self, self.OnGuildQuitSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_KICKOUT_SUCCESS, self, self.OnGuildKickoutSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_NAME_CHANGED, self, self.OnGuildNameChanged)
end

function UIGuildSettingsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildSettingsView:Init()
	local min, max = self.controller:GetRecuritLevelLimit()
	self.lvSlider.slider.minValue = min
	self.lvSlider.slider.maxValue = max

	local recuritLevel = self.controller:GetRecuritLevel()
	self.lvSlider.slider.value = recuritLevel

	local _, costNum = self.controller:GetCostInfo()
	self.costTxt.text.text = tostring(costNum)

	self:RefreshName()
	self:RefreshBadge()
	self:RefreshRecurit()
end

function UIGuildSettingsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

	self.lvInput.inputField.onEndEdit:RemoveAllListeners()
	self.lvSlider.slider.onValueChanged:RemoveAllListeners()
	self.recruitInput.inputField.onValidateInput = nil
	self.recruitInput.inputField.onEndEdit:RemoveAllListeners()
end

function UIGuildSettingsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)

	self.uiBase:AddButtonUniqueEventListener(self.changeBtn.button, self, self.OnClickChangeBtn)
	self.uiBase:AddButtonUniqueEventListener(self.name.button, self, self.OnClickChangeNameBtn)
	self.uiBase:AddButtonUniqueEventListener(self.sureBtn.button, self, self.OnClickSureBtn)

	self.uiBase:AddToggleEventListener(self.toggleGroup.allToggle.toggle, self, self.OnClickToggle, Enum.GuildEnterVerifyType.NotVerify)
	self.uiBase:AddToggleEventListener(self.toggleGroup.applyToggle.toggle, self, self.OnClickToggle, Enum.GuildEnterVerifyType.NeedVerify)
	self.uiBase:AddToggleEventListener(self.toggleGroup.noToggle.toggle, self, self.OnClickToggle, Enum.GuildEnterVerifyType.Ban)

	self.lvInput.inputField.onEndEdit:RemoveAllListeners()
	self.lvInput.inputField.onEndEdit:AddListener(function(text)
		self:OnEndEditLvInput(text)
	end)

	self.lvSlider.slider.onValueChanged:RemoveAllListeners()
	self.lvSlider.slider.onValueChanged:AddListener(function(value)
		self:OnValueChangedLvSlider(value)
	end)

	self.btnMinus.repeatButton:AddRepeatClickEventListener(self, self.OnClickMinusBtn)
	self.btnPlus.repeatButton:AddRepeatClickEventListener(self, self.OnClickPlusBtn)

	self.recruitInput.inputField.onValidateInput = self.recruitInput.inputField.OnValidateInput(self.OnValidateRecruitInput, self)
	self.recruitInput.inputField.onEndEdit:RemoveAllListeners()
	self.recruitInput.inputField.onEndEdit:AddListener(function(text)
		self:OnEndEditRecruitInput(text)
	end)
end

function UIGuildSettingsView:OnHide()

end

function UIGuildSettingsView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildSettingsView:OnClose()
end

function UIGuildSettingsView:OnDispose()
	self.controller:OnDispose()
end

function UIGuildSettingsView:OnGuildDisBandSuccess()
	self:UIClose()
end

function UIGuildSettingsView:OnGuildQuitSuccess()
	self:UIClose()
end

function UIGuildSettingsView:OnGuildKickoutSuccess()
	self:UIClose()
end

function UIGuildSettingsView:OnGuildNameChanged()
	self:RefreshName()
end

function UIGuildSettingsView:OnSelectGuildBadgeChange(badgeId, isChanged)
	if isChanged then
		if self.controller:SetBadge(badgeId) then
			self:RefreshBadge()
		end
	end
end

function UIGuildSettingsView:OnClickCloseBtn()
	local hasChanged = self.controller:HasChanged()
	if hasChanged then
		local data = {"GuildSettingSure", nil, nil, self, self.OnClickSureBtn, self.UIClose}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
	else
		self:UIClose()
	end
end

function UIGuildSettingsView:OnClickChangeBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildChangeBadge, {self.controller:GetBadge(), self, self.OnSelectGuildBadgeChange})
end

function UIGuildSettingsView:OnClickChangeNameBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildChangeName)
end

function UIGuildSettingsView:OnClickSureBtn()
	local errorCode = self.controller:SendGuildSettingsReq()
	if errorCode == 0 then
		self:UIClose()
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildSettingsView:OnClickToggle(_, params, isOn)
	if isOn then
		local verifyType = params
		self.controller:SetRecuritType(verifyType)
	end
end

function UIGuildSettingsView:OnEndEditLvInput(text)
	local ok, result = pcall(tonumber, text)
	local min, max = self.controller:GetRecuritLevelLimit()
	if not ok or not result then
		self.lvInput.inputField.text = tostring(min)
		self.lvSlider.slider.value = 0
		return
	end
	if result < min then result = min end
	if result > max then result = max end
	self.lvInput.inputField.text = tostring(result)
	self.lvSlider.slider.value = result
	self.controller:SetRecuritLevel(result)
end

function UIGuildSettingsView:OnValueChangedLvSlider(value)
	local min, max = self.controller:GetRecuritLevelLimit()
	local result = Mathf.Clamp(value, min, max)
	self.lvInput.inputField.text = tostring(result)
	self.lvSlider.slider.value = result
	self.controller:SetRecuritLevel(result)
end

function UIGuildSettingsView:OnClickMinusBtn()
	local recuritLevel = self.controller:GetRecuritLevel()
	recuritLevel = recuritLevel - 1
	local min, max = self.controller:GetRecuritLevelLimit()
	local result = Mathf.Clamp(recuritLevel, min, max)
	self.lvInput.inputField.text = tostring(result)
	self.lvSlider.slider.value = result
	self.controller:SetRecuritLevel(result)
end

function UIGuildSettingsView:OnClickPlusBtn()
	local recuritLevel = self.controller:GetRecuritLevel()
	recuritLevel = recuritLevel + 1
	local min, max = self.controller:GetRecuritLevelLimit()
	local result = Mathf.Clamp(recuritLevel, min, max)
	self.lvInput.inputField.text = tostring(result)
	self.lvSlider.slider.value = result
	self.controller:SetRecuritLevel(result)
end

function UIGuildSettingsView:OnValidateRecruitInput(text, charIndex, addedChar)
	local len = GetActualStringLength(text) + 1
	local max = self.controller:GetRecuritNoticeMaxLength()
	if len > max then return 0 end
	return addedChar
end


function UIGuildSettingsView:OnEndEditRecruitInput(text)
	self.controller:SetRecuritNotice(text)
end

function UIGuildSettingsView:RefreshName()
	self.name.text.text.text = self.controller:GetCurName()
end

function UIGuildSettingsView:RefreshBadge()
	local resPath = self.controller:GetCurBadgeResPath()
	local itemLua = self.guildBadgeItem
	itemLua.badge.image.enabled = false
	itemLua.badge.image.sprite = nil
	CommonUtil.LoadIcon(self, resPath, function(sprite)
		itemLua.badge.image.enabled = true
		itemLua.badge.image.sprite = sprite
	end, itemLua, 'BadgeIcon')
end

function UIGuildSettingsView:RefreshRecurit()
	local recuritType = self.controller:GetRecuritType()
	local recuritLevel = self.controller:GetRecuritLevel()
	local recuritNotice = self.controller:GetRecuritNotice()
	self.toggleGroup.allowSwitchOff = true
	self.toggleGroup.allToggle.toggle.isOn = (recuritType == Enum.GuildEnterVerifyType.NotVerify)
	self.toggleGroup.applyToggle.toggle.isOn = (recuritType == Enum.GuildEnterVerifyType.NeedVerify)
	self.toggleGroup.noToggle.toggle.isOn = (recuritType == Enum.GuildEnterVerifyType.Ban)
	self.toggleGroup.allowSwitchOff = false
	self.lvInput.inputField.text = tostring(recuritLevel)
	self.recruitInput.inputField.text = recuritNotice and tostring(recuritNotice) or ''
end



return UIGuildSettingsView

