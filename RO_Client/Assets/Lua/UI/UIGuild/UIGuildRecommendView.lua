local UIGuildRecommendView = require("UIGuild/UIGuildRecommendView_Generate")

local State = {
	Default = 1, -- 显示推荐列表
	Search 	= 2, -- 显示查询列表
}

function UIGuildRecommendView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildRecommendCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildRecommendView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_RECOMMEND_LIST_CHANGED, self, self.OnRecommendListChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_SEARCH_LIST_CHANGED, self, self.OnSearchListChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_SUBMIT_APPLY_CHANGED, self, self.OnGuildSubmitChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_ENTER_SUCCESS, self, self.OnGuildEnterSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_CREATE_SUCCESS, self, self.OnGuildCreateSuccess)
end

function UIGuildRecommendView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildRecommendView:Init()
	self.state = State.Default
	self.input.inputField.text = ''
	self.clearBtn:SetActive(false)
	self.btnCreate:SetActive(not self.controller:IsInGuild())
	self.guildList.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self:RefreshGuildList()
	local errorCode = self.controller:SendGetRecommendListReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildRecommendView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	self.input.inputField.onValidateInput = nil
	self.input.inputField.onValueChanged:RemoveAllListeners()
	self.input.inputField.onEndEdit:RemoveAllListeners()
end

function UIGuildRecommendView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.clearBtn.button, self, self.OnClickClearBtn)
	self.uiBase:AddButtonUniqueEventListener(self.searchBtn.button, self, self.OnClickSearchBtn)

	self.uiBase:AddButtonUniqueEventListener(self.closeBtn.button, self, self.OnClickBackBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnCreate.button, self, self.OnClickCreateBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnRefresh.button, self, self.OnClickRefreshBtn)

	self.input.inputField.onValidateInput = self.input.inputField.OnValidateInput(self.OnValidateInput, self)
	self.input.inputField.onValueChanged:RemoveAllListeners()
	self.input.inputField.onValueChanged:AddListener(function(text)
		self:OnValueChangedInput(text)
	end)
	self.input.inputField.onEndEdit:RemoveAllListeners()
	self.input.inputField.onEndEdit:AddListener(function(text)
		self:OnEndEditInput(text)
	end)
end

function UIGuildRecommendView:OnHide()
end

function UIGuildRecommendView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildRecommendView:OnClose()
end

function UIGuildRecommendView:OnDispose()
	self.state = nil
	self.guildList.loopGridView:Dispose()
	self.controller:OnDispose()
end

function UIGuildRecommendView:OnRecommendListChanged()
	if self.state and self.state ~= State.Default then return end
	self:RefreshGuildList()
end

function UIGuildRecommendView:OnSearchListChanged()
	if self.state ~= State.Search then return end
	self:RefreshGuildList()
end

function UIGuildRecommendView:OnGuildSubmitChanged()
	self:RefreshGuildList()
end

function UIGuildRecommendView:OnCheckMoreInfoSuccess(guildMoreData)
end

function UIGuildRecommendView:OnGuildEnterSuccess()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIGuildRecommendView:OnGuildCreateSuccess()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIGuildRecommendView:OnClickClearBtn()
	self.input.inputField.text = ''
	self:OnEndEditInput()
end

function UIGuildRecommendView:OnClickSearchBtn()
	self.state = State.Search
	local text = self.input.inputField.text
	if not text or text == '' then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildInfo_002')
		return
	end
	local len = GetActualStringLength(text)
	local min = self.controller:GetNameLengthMin()
	local max = self.controller:GetNameLengthMax()
	if len < min or len > max then
		-- 肯定找不到公会，不需要发消息
		self.controller:ClearSearchList()
		self:RefreshGuildList()
		return
	end
	local errorCode = self.controller:SendSearchGuildReq(text)
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		return
	end
	self:RefreshGuildList()
end

function UIGuildRecommendView:OnClickBackBtn()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIGuildRecommendView:OnClickCreateBtn()
	if self.controller:IsInGuild() then
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildCreate)
end

function UIGuildRecommendView:OnClickRefreshBtn()
	self.input.inputField.text = ''
	if self.state == State.Search then
		self:OnEndEditInput(nil)
	end
	local errorCode = self.controller:SendGetRecommendListReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildRecommendView:OnValidateInput(text, charIndex, addedChar)
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

function UIGuildRecommendView:OnValueChangedInput(text)
	self.clearBtn:SetActive((text and text ~= ''))
end

function UIGuildRecommendView:OnEndEditInput(text)
	if self.state ~= State.Search then return end
	if text and text ~= '' then return end
	self.state = State.Default
	self:RefreshGuildList()
end

function UIGuildRecommendView:RefreshGuildList()
	self.controller:RefreshShowDatas(self.state)
	local guildDatas = self.controller:GetShowDatas()
	if not guildDatas then
		self.guildList:SetActive(false)
		self.emptyTips:SetActive(true)
		self.emptyTips.desTxt.text.text = string.formatbykey('GuildTips_038')
		return
	end
	local len = #guildDatas
	if len <= 0 then
		self.guildList:SetActive(false)
		self.emptyTips:SetActive(true)
		self.emptyTips.desTxt.text.text = ((self.state == State.Search) and string.formatbykey('GuildTips_003') or string.formatbykey('GuildTips_002'))
		return
	end
	self.guildList:SetActive(true)
	self.emptyTips:SetActive(false)
	self.guildList.loopGridView:RefreshListByIndex(len, 0)
end

function UIGuildRecommendView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local guildData = self.controller:GetShowDataByItemIndex(itemIndex)
	if not guildData then return nil end
	local item = gridView:NewListViewItem('GuildRecommendItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'GuildRecommendItem', item.gameObject)
	if itemLua then
		local data = guildData:GetBriefData()
		itemLua.guildBadgeItem.badge.button.enabled = false
		itemLua.guildBadgeItem.badge.image.enabled = false
		itemLua.guildBadgeItem.badge.image.sprite = nil
		if data.badgeResPath and data.badgeResPath ~= nil then
			CommonUtil.LoadIcon(self, data.badgeResPath, function(sprite)
				itemLua.guildBadgeItem.badge.image.enabled = true
				itemLua.guildBadgeItem.badge.image.sprite = sprite
			end, itemLua, 'BadgeIcon')
		end
		itemLua.nameTxt.text.text = tostring(data.name)
		itemLua.lvTxt.text.text = tostring(data.level)
		itemLua.peopleTxt.text.text = tostring(guildData:GetGuildMemberNum()) .. '/' .. tostring(guildData:GetGuildMemberLimit())
		itemLua.activeTxt.text.text = tostring(data.active)
		itemLua.appliedTag:SetActive(guildData:GetIsSubmitApply())

		self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickGuildItem, data.id)
	end
	return item
end

function UIGuildRecommendView:OnClickGuildItem(btn, param)
	local id = param[0]
	if not id then return end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildInfo, id)
end

return UIGuildRecommendView

