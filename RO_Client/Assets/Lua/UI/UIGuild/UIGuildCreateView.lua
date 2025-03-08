local UIGuildCreateView = require("UIGuild/UIGuildCreateView_Generate")

function UIGuildCreateView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildCreateCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildCreateView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_ENTER_SUCCESS, self, self.OnGuildEnterSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_CREATE_SUCCESS, self, self.OnGuildCreateSuccess)
end

function UIGuildCreateView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildCreateView:Init()
	self.input.inputField.text = ''
	self:RefreshBadge()
	self:RefreshCost()
end

function UIGuildCreateView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	self.input.inputField.onValidateInput = nil
	self.input.inputField.onEndEdit:RemoveAllListeners()
end

function UIGuildCreateView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)

	self.uiBase:AddButtonUniqueEventListener(self.changeBtn.button, self, self.OnClickChangeBtn)
	self.uiBase:AddButtonUniqueEventListener(self.createBtn.button, self, self.OnClickCreateBtn)

	self.input.inputField.onValidateInput = self.input.inputField.OnValidateInput(self.OnValidateInput, self)
	self.input.inputField.onEndEdit:RemoveAllListeners()
	self.input.inputField.onEndEdit:AddListener(function(text)
		self:OnEndEditInput(text)
	end)
end

function UIGuildCreateView:OnHide()

end

function UIGuildCreateView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildCreateView:OnClose()
end

function UIGuildCreateView:OnDispose()
	self.controller:OnDispose()
end

function UIGuildCreateView:OnGuildEnterSuccess()
	self:UIClose()
end

function UIGuildCreateView:OnGuildCreateSuccess()
	self:UIClose()
end

function UIGuildCreateView:OnSelectGuildBadgeChange(badgeId, isChanged)
	if isChanged then
		if self.controller:SetBadgeId(badgeId) then
			self:RefreshBadge()
		end
	end
end

function UIGuildCreateView:OnClickCloseBtn()
	self:UIClose()
end

function UIGuildCreateView:OnClickChangeBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildChangeBadge, {self.controller:GetBadgeId(), self, self.OnSelectGuildBadgeChange})
end

function UIGuildCreateView:OnClickCreateBtn()
	local errorCode = self.controller:SendCreateGuildReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildCreateView:OnValidateInput(text, charIndex, addedChar)
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

function UIGuildCreateView:OnEndEditInput(text)
	self.controller:SetGuildName(text)
end

function UIGuildCreateView:RefreshBadge()
	local itemLua = self.guildBadgeItem
	if not itemLua then return end
	itemLua.badge.image.sprite = nil
	itemLua.badge.image.enabled = false
	local badgeId = self.controller:GetBadgeId()
	local badgeCfg = ManagerContainer.CfgMgr:GetGuildBadgeCfgById(badgeId)
	if badgeCfg and badgeCfg.Pic and badgeCfg.Pic ~= '' then
		CommonUtil.LoadIcon(self, badgeCfg.Pic, function (sprite)
			itemLua.badge.image.sprite = sprite
			itemLua.badge.image.enabled = true
		end, 'BadgeIcon')
	end
end

function UIGuildCreateView:RefreshCost()
	self.icon.image.sprite = nil
	self.icon.image.enabled = false
	local itemCfgId, costNum = self.controller:GetCostInfo()
	local itemCfg = ManagerContainer.CfgMgr:GetItemById(itemCfgId)
	if itemCfg then
		local ownNum = self.controller:GetOwnResCountByItemId(itemCfgId)
		if itemCfg.Icon and itemCfg.Icon ~= '' then
			CommonUtil.LoadIcon(self, itemCfg.Icon, function (sprite)
				self.icon.image.sprite = sprite
				self.icon.image.enabled = true
			end, 'ItemIcon')
		end
		local content = tostring(itemCfg.Name) .. ' x ' .. tostring(costNum)
		if ownNum < costNum then
			self.desTxt.text.text = string.format(Constant.PinkColorText, content)
		else
			self.desTxt.text.text = content
		end
	else
		self.desTxt.text.text = ''
	end
end

return UIGuildCreateView

