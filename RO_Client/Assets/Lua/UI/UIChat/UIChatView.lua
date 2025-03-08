local UIChatView = require("UIChat/UIChatView_Generate")
local UIChatRoot = require("UIChat/UIChatRoot")

local pageToggleData = {}

local regexPattern = "%[e%d+%]"
local emojiFormat = "[e%s]"

local uIChatRootWorld
function UIChatView:OnAwake(data)
	self.controller = require("UIChat/UIChatCtr")
    self.controller:Init(self)
    self.controller:SetData(data)
end

function UIChatView:AddEventListener()
	--ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_WOLRD_CHAT, function()
	--	self:OnChannelChange(Enum.ChatChannel.World)
	--end)
end

function UIChatView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

    self:OnceInit()
	self:Init()
end

function UIChatView:OnceInit()
    self:InitEmojiPanel()
end

function UIChatView:Init()
	local channel = ManagerContainer.DataMgr.ChatData:GetChatChannelType()
	if uIChatRootWorld == nil then
		uIChatRootWorld = UIChatRoot:new()
		uIChatRootWorld:Init(self,channel, self.chatWindow, self.inputField)
	end
	self:SetToggleGroupStatus(channel)
	self:OnChannelChange(nil, channel, true)
end

function UIChatView:InitEmojiPanel()
	local emojis = ManagerContainer.CfgMgr:GetEmojiCfg()
	CommonUtil.LoopGridViewEleCreateNoItem(self,
			self.emojiWindow.loopVerticalScrollRect,
			emojis,
			0,
			self, function (owner, go, idx, logicData)
				local textTrans = go.transform:Find("Text")
				local text = textTrans:GetComponent(Enum.TypeInfo.SymbolText)
				local index = idx
				if idx < 10 then
					index = "0"..idx
				end
				text.text = string.format(emojiFormat, index)
				local uiTrigger = textTrans:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
				uiTrigger.onClick = function()
					self:OnEmojiClick(idx)
				end

				uiTrigger.onBeginDrag = function()
					self.emojiWindow.loopVerticalScrollRect:OnBeginDrag(UIEventTriggerListener.currentEventData)
				end

				uiTrigger.onDrag = function()
					self.emojiWindow.loopVerticalScrollRect:OnDrag(UIEventTriggerListener.currentEventData)
				end

				uiTrigger.onEndDrag = function()
					self.emojiWindow.loopVerticalScrollRect:OnEndDrag(UIEventTriggerListener.currentEventData)
				end
			end)
end

function UIChatView:OnEmojiClick(idx)
	local count = 0
	for k, v in string.gmatch(self.inputField.inputField.text, regexPattern) do
		count = count + 1
	end
	if count >= 5 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatError2")
		return
	end

	if idx < 10 then
		idx = "0"..idx
	end
	self.inputField.inputField.text = self.inputField.inputField.text..string.format(emojiFormat, idx)
end

function UIChatView:OnChannelChange(toggle, chatType, isOn)
	if not isOn then return end
	if self:IsSomeFrameCount('ChatChannelToggle') then
		return
	end
	if chatType == Enum.ChatChannel.World then
		uIChatRootWorld:SetChannelType(Enum.ChatChannel.World)
	elseif chatType == Enum.ChatChannel.System then
		uIChatRootWorld:SetChannelType(Enum.ChatChannel.System)
	elseif chatType == Enum.ChatChannel.Guild then
		local errorCode = ManagerContainer.DataMgr.GuildDataMgr:GetGuildDataStateErrorCode()
		if errorCode then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
			self:SetToggleGroupStatus(uIChatRootWorld:GetChannelType())
			return
		end
		uIChatRootWorld:SetChannelType(Enum.ChatChannel.Guild)
	end

	ManagerContainer.DataMgr.ChatData:SetChatChannelType(chatType)
end

function UIChatView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIChatView:OnBtnClose(button, params)
	if self.emojiWindow.activeSelf then
		self:OnEmojiBgClick()
		return
	end
	self:UIClose()
end

function UIChatView:OnEmojiBgClick(button, params)
	self.emojiWindow:SetActive(not self.emojiWindow.activeSelf)
end

function UIChatView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	-- CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.toggle, Enum.ChatChannel.World, self.OnChannelChange)
	self.uiBase:AddToggleEventListener(self.chWorld.toggle, self, self.OnChannelChange, Enum.ChatChannel.World)
	self.uiBase:AddToggleEventListener(self.chGuild.toggle, self, self.OnChannelChange, Enum.ChatChannel.Guild)
	self.uiBase:AddToggleEventListener(self.chSystem.toggle, self, self.OnChannelChange, Enum.ChatChannel.System)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnBtnClose)

	uIChatRootWorld:AddUIEventListener()

	self.uiBase:AddButtonEventListener(self.btnEmoji.button, self, self.OnEmojiBgClick)
	self.uiBase:AddButtonEventListener(self.BtnClose.button, self, self.OnBtnClose)
end

function UIChatView:OnHide()

end

function UIChatView:OnShow(data)
	self:OnChannelChange(nil, ManagerContainer.DataMgr.ChatData:GetChatChannelType(), true)
	self:Init()
end

function UIChatView:OnClose()
	if not self.closed then
		self.closed = true
	end

	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.WORLD_CHAT_UI_CLOSE)

	if uIChatRootWorld then
		uIChatRootWorld:Dispose()
		uIChatRootWorld = nil
	end
end

function UIChatView:OnDispose()
	self.emojiWindow:SetActive(false)
	self.inputField.inputField:DeactivateInputField()

	self.emojiWindow.loopVerticalScrollRect:ClearCells()
end

function UIChatView:IsSomeFrameCount(keyName)
	local value = self[keyName]
	if value and value >= Time.frameCount then
		return true
	end
	self[keyName] = Time.frameCount
	return false
end

function UIChatView:SetToggleGroupStatus(chatChannelType)
	local toggleGroup = self.toggle.toggleGroup
	local oldAllowSwitchOff = toggleGroup.allowSwitchOff
	toggleGroup.allowSwitchOff = false
	self.chWorld.toggle.isOn = (chatChannelType == Enum.ChatChannel.World)
	self.chGuild.toggle.isOn = (chatChannelType == Enum.ChatChannel.Guild)
	self.chSystem.toggle.isOn = (chatChannelType == Enum.ChatChannel.System)
	toggleGroup.allowSwitchOff = oldAllowSwitchOff
end

return UIChatView

