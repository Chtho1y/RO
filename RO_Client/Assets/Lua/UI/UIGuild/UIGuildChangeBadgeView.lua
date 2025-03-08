local UIGuildChangeBadgeView = require("UIGuild/UIGuildChangeBadgeView_Generate")

function UIGuildChangeBadgeView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildChangeBadgeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildChangeBadgeView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(UIEventNames.GUILD_CREATE_SUCCESS, self, self.OnGuildCreateSuccess)
end

function UIGuildChangeBadgeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildChangeBadgeView:Init()
	self.changeList.loopVerticalScrollRect:StopMovement()
	self.changeList.loopVerticalScrollRect.content.anchoredPosition = Vector2.zero
	self:RefreshList()
	self:RefreshBtn()
end

function UIGuildChangeBadgeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuildChangeBadgeView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)

	self.uiBase:AddButtonUniqueEventListener(self.usedBtn.button, self, self.OnClickUsedBtn)
end

function UIGuildChangeBadgeView:OnHide()

end

function UIGuildChangeBadgeView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildChangeBadgeView:OnClose()
end

function UIGuildChangeBadgeView:OnDispose()
	self.changeList.loopVerticalScrollRect:ClearCells()
	self.controller:OnDispose()
end

function UIGuildChangeBadgeView:OnGuildCreateSuccess()
	self:UIClose()
end

function UIGuildChangeBadgeView:OnClickCloseBtn()
	self.controller:OnExitGuildBadge(false)
	self:UIClose()
end

function UIGuildChangeBadgeView:OnClickUsedBtn()
	local curBadgeId = self.controller:GetCurBadgeId()
	local used = (self.controller:GetDefaultBadgeId() == curBadgeId)
	if used then return end
	self.controller:OnExitGuildBadge(true)
	self:UIClose()
end

function UIGuildChangeBadgeView:RefreshList()
	local badgeCfgs = self.controller:GetBadgeCfgs()
	local curBadgeId = self.controller:GetCurBadgeId()
	local moveTo = nil
	for index, badgeId in pairs(badgeCfgs) do
		if badgeId == curBadgeId then
			moveTo = index
			break
		end
	end
	CommonUtil.LoopGridViewEleCreateNew(self, self.changeList.loopVerticalScrollRect, nil,
											badgeCfgs, 0, self, self.RefreshBadgeItem, nil, nil, moveTo)
end

function UIGuildChangeBadgeView:RefreshBadgeItem(itemLua, idx, itemData)
	if not itemLua or not itemData then return end
	itemLua.badge.image.sprite = nil
	itemLua.badge.image.enabled = false
	if itemData.Pic and itemData.Pic ~= '' then
		CommonUtil.LoadIcon(self, itemData.Pic, function (sprite)
			itemLua.badge.image.sprite = sprite
			itemLua.badge.image.enabled = true
		end)
	end
	itemLua.used:SetActive(self.controller:GetDefaultBadgeId() == itemData.Id)
	itemLua.selected:SetActive(self.controller:GetCurBadgeId() == itemData.Id)

	self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickBadgeItem, itemData)
end

function UIGuildChangeBadgeView:OnClickBadgeItem(btn, param)
	local itemData = param[0]
	if not itemData then return end
	local isChanged = self.controller:SetCurBadgeId(itemData.Id)
	if not isChanged then return end
	self.changeList.loopVerticalScrollRect:RefreshCells()
	self:RefreshBtn()
end

function UIGuildChangeBadgeView:RefreshBtn()
	local curBadgeId = self.controller:GetCurBadgeId()
	-- local unlocked = true
	local used = (self.controller:GetDefaultBadgeId() == curBadgeId)
	self.usedBtn.button.interactable = (not used);
	if used then
		self.usedBtn.text.text.text = I18N.T("BtnUsing");	--使用中
	else
		self.usedBtn.text.text.text = I18N.T("BtnChange");	--更换
	end
end

return UIGuildChangeBadgeView

