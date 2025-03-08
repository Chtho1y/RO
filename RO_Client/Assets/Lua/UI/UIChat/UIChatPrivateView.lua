local UIChatPrivateView = require("UIChat/UIChatPrivateView_Generate")
local NickNameCtr = require("Common/NickNameCtr")

local curSelectedIdx
local curSelectedHead
local curSelectedUid

local regexPattern = "%[e%d+%]"
local emojiFormat = "[e%s]"

local lastClickLogTime
local lastClickNum

function UIChatPrivateView:OnAwake(data)
	self.controller = require("UIChat/UIChatPrivateCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIChatPrivateView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_PRIVATE_CHAT, function(idx, uid)
		--self.inputField.inputField.text = ""
		--if curSelectedIdx == nil then
		--	self:RefreshPrivateTargets()
		--end
		--if curSelectedIdx ~= idx then return end

		--self:RefreshCurTargetPrivateChats(idx)

		local needRefreshHeads, needRefreshChats = false, false
		if curSelectedUid ~= uid or curSelectedIdx ~= idx then
			needRefreshHeads = true
		else
			needRefreshChats = true
		end
		if uid == nil then
			curSelectedIdx = 1
		end
		if needRefreshHeads then
			self:RefreshLeftHeads()
		else
			 if needRefreshChats then
			 	self:RefreshCurTargetPrivateChats(curSelectedIdx)
			 end
		end
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_PRIVATE_BRIEFINFO, function(briefInfo)
		self:RefreshLeftHeads()
		--self:RefreshTargetBrief(briefInfo)
	end)
end

function UIChatPrivateView:FillContent(data, uiBase)
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

function UIChatPrivateView:OnceInit()
	self:InitEmojiPanel()
	self:InitPrivatePanel()
end

function UIChatPrivateView:Init()
	self.headItemLuaList = {}
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PRIVATER_CHAT_BTN_DISPLAY, false)
	local data = self.controller:GetData()
	curSelectedIdx = data
	lastClickLogTime = nil
	lastClickNum = nil
	self:RefreshPrivateTargets()
end

function UIChatPrivateView:InitPrivatePanel()
	local loopGridViewInitParam = SuperScrollView.LoopGridViewInitParam.CopyDefaultInitParam()
	loopGridViewInitParam.mSnapVecThreshold = 9999

	self.scrollView.loopListView:InitListView(0, function(gridView, itemIndex)
		return self:RefreshPrivateChats(gridView, itemIndex)
	end)
end

function UIChatPrivateView:InitEmojiPanel()
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

function UIChatPrivateView:OnEmojiClick(idx)
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

function UIChatPrivateView:RefreshPrivateTargets()
	local privateChats = ManagerContainer.DataMgr.ChatData:GetPrivateSortChatDatas()
	self.empty:SetActive(#privateChats == 0)
	self.exist:SetActive(#privateChats > 0)

	if #privateChats > 0 and curSelectedIdx == nil then
		curSelectedIdx = 1
	end
	if curSelectedIdx ~= nil then
		self.controller:QueryAllPrivateBriefInfo()
		--self:RefreshLeftHeads()
		self:RefreshCurTargetPrivateChats(curSelectedIdx)
	end
end

function UIChatPrivateView:RefreshLeftHeads()
	local privateChats = ManagerContainer.DataMgr.ChatData:GetPrivateSortChatDatas()
	CommonUtil.LoopGridViewEleCreateNoItem(self,
			self.headList.loopVerticalScrollRect,
			privateChats,
			0,
			self, self.UpdatePrivateTargets)
end

function UIChatPrivateView:UpdatePrivateTargets(go, idx, logicData)
	local transform = go.transform
	local toggle = transform:GetComponent(Enum.TypeInfo.Toggle)
	local on = transform:Find("On")
	local off = transform:Find("Off")
	-- local frameImage = transform:Find("Image"):GetComponent(Enum.TypeInfo.Image)
	-- local headImage = transform:Find("Head"):GetComponent(Enum.TypeInfo.Image)
	local headItem = transform:Find("HeadBox/HeadItem")
	local redPoint = transform:Find("RedPoint")
	local Closed = transform:Find("Closed")
	local closedBtn = Closed:GetComponent(Enum.TypeInfo.Button)
	local nameText = transform:Find("Name"):GetComponent(Enum.TypeInfo.Text)

	on.gameObject:SetActive(curSelectedIdx == idx + 1)
	off.gameObject:SetActive(curSelectedIdx ~= idx + 1)
	Closed.gameObject:SetActive(curSelectedIdx == idx + 1)

	local jobIcon = nil
	if logicData.fromData.jobId ~= nil then
		local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(logicData.fromData.jobId)
		if jobCfg ~= nil then
			jobIcon = jobCfg.JobIcon;
		end
	end

	local tempData = {HeadIcon = logicData.fromData.imgId, ProfessionIcon = jobIcon, Level = logicData.fromData.level, IsHero = true};
	local headItemLua = CommonUtil.BindGridViewItem2Lua(self, "HeadItem", headItem.gameObject)
	CommonUtil.SetPlayerHeadAndFrame(self,headItemLua,tempData,false,logicData.fromData.headFrameId)
	headItemLua.head.image.raycastTarget = false

	CommonUtil.SetTotalChildrenGray(headItem.gameObject, logicData.fromData.onlineState == false)

	redPoint.gameObject:SetActive(curSelectedIdx ~= idx + 1 and logicData.isNew)

	go.name = logicData.fromData.uid
	if curSelectedIdx == idx + 1 then
		curSelectedHead = go
		curSelectedUid = logicData.fromData.uid

		logicData.isNew = false

		local needQuery = ManagerContainer.DataMgr.ChatData:NeedQueryOfflinePrivateInfo(logicData.fromData)
		if needQuery then
			self.controller:SendOfflinePrivateChatQuery(logicData.fromData.uid)
		else
			self:RefreshCurTargetPrivateChats(curSelectedIdx)
		end
		--self.controller:QueryPrivateBriefInfo(logicData.fromData.uid)
	end

	nameText.text = CommonUtil.GetVaildNickName(logicData.fromData.nickname)

	self.uiBase:AddButtonUniqueEventListener(closedBtn,self, self.OnTargetCloseClick, idx + 1)
	self.uiBase:AddToggleUniqueEventListener(toggle, self, self.OnPrivateTargetSelected, idx + 1)
end

function UIChatPrivateView:OnPrivateTargetSelected(toggle, params, result)
	if not result then return end
	local idx = params[0]
	if not idx or curSelectedIdx == idx then return end
	local privateChats = ManagerContainer.DataMgr.ChatData:GetPrivateSortChatDatas()
	local fromData = privateChats[idx].fromData
	curSelectedUid = fromData.uid
	curSelectedIdx = idx
	curSelectedHead = toggle.gameObject
	self:RefreshLeftHeads()
end

function UIChatPrivateView:OnTargetCloseClick(button, params)
	local idx = params[0]
	ManagerContainer.DataMgr.ChatData:RemovePrivateChatData(idx)
	curSelectedIdx = 1
	local privateChats = ManagerContainer.DataMgr.ChatData:GetPrivateSortChatDatas()
	if #privateChats == 0 then
		curSelectedIdx = nil
		self:RefreshPrivateTargets()
	else
		self:RefreshLeftHeads()
	end
end

function UIChatPrivateView:RefreshTargetBrief(briefInfo)
	local privateChats = ManagerContainer.DataMgr.ChatData:GetPrivateSortChatDatas()
	local curTargetFromData = privateChats[curSelectedIdx].fromData

	if briefInfo.uid ~= curTargetFromData.uid then return end

	--curTargetFromData = briefInfo

	local nameText = curSelectedHead.transform:Find("Name"):GetComponent(Enum.TypeInfo.Text)
	nameText.text = CommonUtil.GetVaildNickName(briefInfo.nickname)

	local jobIcon = nil
	if curTargetFromData.jobId ~= nil then
		local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(curTargetFromData.jobId)
		if jobCfg ~= nil then
			jobIcon = jobCfg.JobIcon;
		end
	end
	local headTrans = curSelectedHead.transform:Find("HeadBox/HeadItem")
	local tempData = {HeadIcon = curTargetFromData.imgId, ProfessionIcon = jobIcon, Level = curTargetFromData.level, IsHero = true};
	local headItemLua = CommonUtil.GetBindGridViewItem2Lua(self, "HeadItem", headTrans.gameObject)
	CommonUtil.SetPlayerHeadAndFrame(self,headItemLua,tempData,false,curTargetFromData.headFrameId)

	CommonUtil.SetTotalChildrenGray(headItemLua.gameObject, curTargetFromData.onlineState == false)
end

function UIChatPrivateView:RefreshCurTargetPrivateChats(idx)
	local privateChats = ManagerContainer.DataMgr.ChatData:GetPrivateSortChatDatas()

	if curSelectedHead ~= nil then
		local fromData = privateChats[idx].fromData
		local nameText = curSelectedHead.transform:Find("Name"):GetComponent(Enum.TypeInfo.Text)
		nameText.text = CommonUtil.GetVaildNickName(fromData.nickname)
	end

	--self.controller:QueryPrivateBriefInfo(privateChats[idx].fromData.uid)

	local datas = privateChats[idx].chats
	local max = #datas
	self.scrollView.loopListView:SetListItemCount(max, true)
	--self.scrollView.loopListView:FinishSnapImmediately()
	self.scrollView.loopListView:MovePanelToItemIndex(max - 1, 0)
	--local scrollView = self.scrollView
	--CommonUtil.LoopGridViewEleCreateNew(self,
	--		scrollView.loopVerticalScrollRect,
	--		nil,
	--		datas,
	--		0,
	--		self, self.RefreshPrivateChats)
	--
	--if #datas > 0 then
	--	scrollView.loopVerticalScrollRect:MoveTo(#datas - 1)
	--end
end

function UIChatPrivateView:RefreshPrivateChats(gridView, itemIndex)
	local item = gridView:NewListViewItem(Enum.PrefabNames.PrivateChatItem)
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, Enum.PrefabNames.PrivateChatItem, item.gameObject)

	local privateChats = ManagerContainer.DataMgr.ChatData:GetPrivateSortChatDatas()
	local datas = privateChats[curSelectedIdx]
	local lastChat = datas.chats[itemIndex]
	local logicData = {lastChat, datas.chats[itemIndex + 1]}
	CommonUtil.UpdateItemPrefab(self, itemLua, logicData)
	return item
end

--function UIChatPrivateView:RefreshPrivateChats(itemlua, idx)
--	local privateChats = ManagerContainer.DataMgr.ChatData:GetPrivateSortChatDatas()
--	local datas = privateChats[curSelectedIdx]
--	local lastChat = datas.chats[idx]
--	local logicData = {lastChat, datas.chats[idx + 1]}
--	CommonUtil.UpdateItemPrefab(self, itemlua, logicData)
--end

function UIChatPrivateView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIChatPrivateView:OnBtnClose(button, params)
	if self.emojiWindow.activeSelf then
		self:OnEmojiBgClick()
		return
	end

	self:UIClose()
end

function UIChatPrivateView:OnClickBtnLog(button, params)
	local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	if not lastClickLogTime or (curTime - lastClickLogTime) > 15000 then
		lastClickLogTime = curTime
		lastClickNum = 0
	end
	if not lastClickNum then
		lastClickNum = 0
	end
	lastClickNum = lastClickNum + 1
	if lastClickNum >= 30 then
		lastClickNum = 0
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('Egg1')
	end
end

function UIChatPrivateView:OnEmojiBgClick(button, params)
	self.emojiWindow:SetActive(not self.emojiWindow.activeSelf)
end

function UIChatPrivateView:OnInputChanged(content)
	local temp = self.inputField.inputField.text
	--local length = StringUtil.GetTextLeng(self.inputField.inputField.textComponent, temp)
	--LogError(length)
	if string.len(temp) > Constant.CHAT_BYTE_LIMIT then
		temp = string.sub(temp, 0, Constant.CHAT_BYTE_LIMIT)
	end

	temp = string.gsub(temp, "#h", "")
	temp = string.gsub(temp, "#t", "")
	temp = string.gsub(temp, "#", "")

	temp = StringUtil.FilterEmoji(temp)
	self.inputField.inputField.text = temp
end

function UIChatPrivateView:OnSendClick(button, params)
	if self.emojiWindow.activeSelf then
		self:OnEmojiBgClick()
	end

	local _openCreateName = NickNameCtr:NeedOpenCreate()
	if _openCreateName then
		NickNameCtr:OpenNickNamePage(true);
		return;
	end

    local emojis = ManagerContainer.CfgMgr:GetEmojiCfg()
    for k, v in string.gmatch(self.inputField.inputField.text, regexPattern) do
        local num = tonumber(string.match(k, '%d+'))
        if num >= #emojis then
            self.inputField.inputField.text = string.gsub(self.inputField.inputField.text, k, "")
        end
    end
    if self.inputField.inputField.text == "[]" then
        self.inputField.inputField.text = ""
    end

	if self.inputField.inputField.text == "" then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatContentEmpty")
		return
	end
	local privateChats = ManagerContainer.DataMgr.ChatData:GetPrivateSortChatDatas()
	local datas = privateChats[curSelectedIdx]

	local content = self.inputField.inputField.text
	local level = ManagerContainer.DataMgr.UserData:GetRoleLv()
    if SDKMgr.Instance:CheckSpeech(level, ChannelType.PRIVATE, content) then
		self.controller:SendPrivateChat(content, datas.fromData.uid)
		self.inputField.inputField.text = ""
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ShieldTips01")
	end
end

function UIChatPrivateView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

    self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnBtnClose)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnBtnClose)
	self.uiBase:AddButtonUniqueEventListener(self.btnLog.button, self, self.OnClickBtnLog)
	self.uiBase:AddButtonEventListener(self.btnSend.button,self, self.OnSendClick)
	self.uiBase:AddButtonEventListener(self.btnEmoji.button, self, self.OnEmojiBgClick)

	self.uiBase:AddInputFileEventListener(self.inputField.inputField, function(input, content)
		self:OnInputChanged(content)
	end)

    self.scrollView.uIEventTriggerListener.onClick = function()
        if self.emojiWindow.activeSelf then
            self:OnEmojiBgClick()
            return
        end
    end
end

function UIChatPrivateView:OnHide()
end

function UIChatPrivateView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIChatPrivateView:OnClose()
	CommonUtil.ClearGridViewItem(self,"HeadItem")
	local privateChats = ManagerContainer.DataMgr.ChatData:GetPrivateSortChatDatas()
	if #privateChats > 0 then
		local logicData = privateChats[curSelectedIdx]
		if logicData then
			logicData.isNew = false
		end
	end

	ManagerContainer.DataMgr.ChatData:CheckHasNewPrivateChat()
	ManagerContainer.DataMgr.ChatData:SavePrivateDatas()
end

function UIChatPrivateView:OnDispose()
	self.emojiWindow:SetActive(false)
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PRIVATER_CHAT_BTN_DISPLAY, true)

	curSelectedIdx = nil
	curSelectedHead = nil
	curSelectedUid = nil
	lastClickLogTime = nil
	lastClickNum = nil

	self.scrollView.uIEventTriggerListener.onClick = nil
	self.scrollView.loopListView:Dispose()
	self.emojiWindow.loopVerticalScrollRect:ClearCells()
end

return UIChatPrivateView

