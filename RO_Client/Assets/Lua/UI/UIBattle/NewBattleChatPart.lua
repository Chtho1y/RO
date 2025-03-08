local NewBattleChatPart = class("NewBattleChatPart")
local UIChatRoot = require("UIChat/UIChatRoot")
local uIChatRootWorld
local chatDisplayDurationTime
local chatHideTimer
local pageToggleData = {}

function NewBattleChatPart:ctor()
    self.curChatType = nil
	self.uiview = nil
	self.ismainBattle = nil
end

function NewBattleChatPart:HandleChatToggleBtns(type)
	if type == 1 then
		self.viewLua.togworld.toggle.isOn = true
		self.viewLua.togsystem.toggle.isOn = false
		self.viewLua.togwarlog.toggle.isOn = false
	elseif type == 2 then
		self.viewLua.togworld.toggle.isOn = false
		self.viewLua.togsystem.toggle.isOn = true
		self.viewLua.togwarlog.toggle.isOn = false
	elseif type == 3 then
		self.viewLua.togworld.toggle.isOn = false
		self.viewLua.togsystem.toggle.isOn = false
		self.viewLua.togwarlog.toggle.isOn = true
	end
end
function NewBattleChatPart:GetChatChannelType()
	return ManagerContainer.DataMgr.ChatData:GetChatChannelType()
end

function NewBattleChatPart:SetChatChannelType(type)
    ManagerContainer.DataMgr.ChatData:SetChatChannelType(type)
end

function NewBattleChatPart:InitGo(host,uiGo,ismainBattle,btnchat)
	self.uiview = host
	self.uiData = host.uiData
	self.uiBase = host.uiBase
	self.viewLua = CommonUtil.BindGridViewItem2Lua(self.uiview, "NewBattleChat", uiGo)	
	self.viewLua.transform:SetAsFirstSibling()
	self.uieventhandler = self.viewLua.transform:GetComponent(Enum.TypeInfo.UIEventHandler)
    if uIChatRootWorld == nil then
        uIChatRootWorld = UIChatRoot:new()
    end
    
    local curChatType = self:GetChatChannelType()
	uIChatRootWorld:Init(self, curChatType, self.viewLua.chatView, nil, self.RefreshChatBg,true)
	self:SetChatChannelType(curChatType)
	if not ismainBattle then
		self.ismainBattle = ismainBattle
		self.viewLua.togwarlog:SetActive(false)
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPrivateChatBtn)
end
function NewBattleChatPart:RefreshChatBg()
	if not self.uiview or not self.uiview.uiBase or not self.uiBase  then
		return
	end
	if not chatDisplayDurationTime then
		chatDisplayDurationTime = GlobalConfig.Instance:GetConfigIntValue(229)*1000
	end

	if nil ~= self.viewLua.chltogBg then
		DG.Tweening.DOTween.Kill(self.viewLua.chltogBg.canvasGroup)
		self.viewLua.chltogBg.canvasGroup:DOFade(1, 0)
	end
	--self.chltogBg:SetActive(true)
	if chatHideTimer then
		ManagerContainer.LuaTimerMgr:RemoveTimer(chatHideTimer)
	end
	chatHideTimer = ManagerContainer.LuaTimerMgr:AddTimer(chatDisplayDurationTime, 1, self, self.HideChatBg, nil)
end

function NewBattleChatPart:HideChatBg()
	if not self.uiview or  not self.uiBase  then
		return
	end
	self.viewLua.chltogBg.canvasGroup:DOFade(0, 0.5)
end

function NewBattleChatPart:AddUIEventListener()
    CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.viewLua.chltogBg.toggleGroup, Enum.ChatChannel.World, self.OnValueChangedToggle)
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiview.uiData.name, UIEventNames.WORLD_CHAT_UI_CLOSE, self, self.WorldChatUIClosed)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiview.uiData.name, UIEventNames.EID_Add_New_BattleLog, self,self.OnAddNewBattleLog)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiview.uiData.name, UIEventNames.EID_CLEAR_New_BattleLog, self,self.ClearBattleLog)	
	if self.uieventhandler then
		self.uieventhandler:RemoveListener();
		self.uiBase:AddUIEventHandlerClickListener(self.uieventhandler, function (go)
			if not go or go.transform:IsChildOf(self.viewLua.transform) then
				return 
			end
			if self.viewLua.funcbg then
				self.viewLua.funcbg:SetActive(false)
			end
		end)
	end
	self.uiview.uiBase:AddButtonEventListener(self.viewLua.btnChat.button, self, self.OpenWorldChat)
    self.viewLua.chatView.uIEventTriggerListener.onClick = function()
		self:RefreshChatBg()
	end
	self.viewLua.chatView.uIEventTriggerListener.onPointerUp = function()
		self:RefreshChatBg()
	end
	self.viewLua.battleLogView.uIEventTriggerListener.onClick = function()
		self:RefreshChatBg()
	end
	self.viewLua.battleLogView.uIEventTriggerListener.onPointerUp = function()
		self:RefreshChatBg()
	end
	uIChatRootWorld:AddUIEventListener()
end

function NewBattleChatPart:ClearBattleLog()
	if not self.uiview or not self.uiBase  then
		return
	end
	self.logList = nil
	if self.bInitBattleLog then
		self.viewLua.battleLogView.loopVerticalScrollRect:ClearCells()
	end
end

function NewBattleChatPart:OnAddNewBattleLog()
	if not self.uiview or not self.uiBase  then
		return
	end
	self.logList = LuaBattleBridge.GetBattleLog()	
	if self.viewLua.battleLogView.loopVerticalScrollRect.ItemTypeStart >= 185 then
		self.viewLua.battleLogView.loopVerticalScrollRect:RefreshCellsData()
	else
		self.viewLua.battleLogView.loopVerticalScrollRect.totalCount = self.logList.Count	
		local nEndItem = self.viewLua.battleLogView.loopVerticalScrollRect.ItemTypeEnd		
		if self.logList.Count <= nEndItem + 2 then	
			self.viewLua.battleLogView.loopVerticalScrollRect:MoveTo(self.logList.Count-1)
		end	
	end
end

function NewBattleChatPart:OpenWorldChat()
	if not self.uiview or not self.uiBase  then
		return
	end
    self.viewLua.chatView:SetActive(false)
    if ManagerContainer.LuaBattleMgr:GetBossFightState() then
        self.viewLua.battleLogView:SetActive(false)
	end
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChat)
end

function NewBattleChatPart:WorldChatUIClosed()
	if not self.uiview or not self.uiBase  then
		return
	end
	self.viewLua.chatView:SetActive(true)
	if uIChatRootWorld then
		local curChatType = self:GetChatChannelType()
		self:SetToggleGroupStatus(curChatType)
		self:OnValueChangedToggle(curChatType, true)
    end
	self.viewLua.battleLogView:SetActive(false)
end
function NewBattleChatPart:SetToggleGroupStatus(chatType)
	local toggleGroup = self.viewLua.chltogBg.toggleGroup
	self.viewLua.togworld.toggle.isOn = (chatType == 1)
	self.viewLua.togguild.toggle.isOn = (chatType == 2)
	self.viewLua.togsystem.toggle.isOn = (chatType == 3)
	self.viewLua.togwarlog.toggle.isOn = (chatType == 4)
	pageToggleData.toggleDefaultIndex = chatType
end
function NewBattleChatPart:OnValueChangedToggle(idx, dontDisplay)
	if not self.uiview or not self.uiBase  then
		return
	end
		local forceRefresh = true 
		self.viewLua.btnChat:SetActive(pageToggleData.toggleDefaultIndex ~= Enum.ChatChannel.BattleRecord)	
		if pageToggleData.toggleDefaultIndex == Enum.ChatChannel.World then
			self.viewLua.chatView:SetActive(true)
			self.viewLua.battleLogView:SetActive(false)
			uIChatRootWorld:SetChannelType(Enum.ChatChannel.World, forceRefresh)
		elseif pageToggleData.toggleDefaultIndex == Enum.ChatChannel.Guild then
			local errorCode = ManagerContainer.DataMgr.GuildDataMgr:GetGuildDataStateErrorCode()
			if errorCode then
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
				self:SetToggleGroupStatus(self:GetChatChannelType())
				return
			end
			self.viewLua.chatView:SetActive(true)
			self.viewLua.battleLogView:SetActive(false)
			uIChatRootWorld:SetChannelType(Enum.ChatChannel.Guild, forceRefresh)
		elseif pageToggleData.toggleDefaultIndex == Enum.ChatChannel.System  then
			self.viewLua.chatView:SetActive(true)
			self.viewLua.battleLogView:SetActive(false)
			uIChatRootWorld:SetChannelType(Enum.ChatChannel.System, forceRefresh)
		elseif pageToggleData.toggleDefaultIndex == Enum.ChatChannel.BattleRecord  then
			self.viewLua.chatView:SetActive(false)
			self.viewLua.battleLogView:SetActive(true)
			self:ShowBattleLog()
		end
		self:SetChatChannelType(pageToggleData.toggleDefaultIndex)
	if not dontDisplay then
		self:RefreshChatBg()
	end
	--end
end
function NewBattleChatPart:ShowBattleLog()
	if not self.uiview or not self.uiBase  then
		return
	end
	if self.bInitBattleLog then
		return
	end

	self.bInitBattleLog = true
	self.viewLua.battleLogView.loopVerticalScrollRect:SetUpdateCellCallback(nil,nil)
	self.viewLua.battleLogView.loopVerticalScrollRect:ClearCells()
	self.logList = LuaBattleBridge.GetBattleLog()
	if self.logList ~= nil then
		CommonUtil.LoopGridViewEleCreateWithList(self,
								self.viewLua.battleLogView.loopVerticalScrollRect,
								self.viewLua.battleLogView.content.verticalLayoutGroup,self.logList,0,self,self.OnSetBattleLogData,false,nil,0)
		self.viewLua.battleLogView.loopVerticalScrollRect:MoveTo(self.logList.Count-1);
	end
end

function NewBattleChatPart:OnSetBattleLogData(itemLua,idx)
	if not self.uiview or not self.uiview.uiBase or not self.uiBase  then
		return
	end
	if idx < self.logList.Count and idx>=0 then
		itemLua.text.text.text = self.logList[idx]
	end	
end

function NewBattleChatPart:SetCanvasOrder(order)
	if not self.uiview or not self.uiview.uiBase or not self.uiBase  then
		return
	end
    self.viewLua.canvas.sortingOrder = order
end

function NewBattleChatPart:Show()
	uIChatRootWorld:Init(self, curChatType, self.viewLua.chatView, nil, self.RefreshChatBg,true)
	self.viewLua:SetActive(true)
end

function NewBattleChatPart:Dispose()
	pageToggleData.toggleList = nil;
	if chatHideTimer then
		ManagerContainer.LuaTimerMgr:RemoveTimer(chatHideTimer)
	end
	chatHideTimer = nil
	self.uieventhandler:RemoveListener();
	self.uieventhandler = nil
	self.viewLua.chatView.uIEventTriggerListener.onClick = nil
	self.viewLua.chatView.uIEventTriggerListener.onPointerUp = nil
	self.viewLua.battleLogView.uIEventTriggerListener.onClick = nil
	self.viewLua.battleLogView.uIEventTriggerListener.onPointerUp = nil
	ManagerContainer.DataMgr.ChatData:SetChatChannelType(Enum.ChatDataType.World)
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIChat)
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIPrivateChatBtn)
end
return NewBattleChatPart