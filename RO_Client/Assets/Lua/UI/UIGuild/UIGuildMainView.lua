local UIGuildMainView = require("UIGuild/UIGuildMainView_Generate")
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')

local ManageLanguageKeyMap = {
	[Enum.GuildManageType.AuditApply] = 'GuildManage_01',
	[Enum.GuildManageType.Settings] = 'GuildManage_02',
	[Enum.GuildManageType.Mail] = 'GuildManage_03',
	[Enum.GuildManageType.List] = 'GuildManage_04',
	[Enum.GuildManageType.Dismiss] = 'GuildManage_05',
	[Enum.GuildManageType.Exit] = 'GuildManage_06',
}

local PeopleHandleLanguageKeyMap = {
	[Enum.GuildPeopleHandleType.UpPresident] = 'GuildMemberHandle_01',
	[Enum.GuildPeopleHandleType.UpVicePresident] = 'GuildMemberHandle_02',
	[Enum.GuildPeopleHandleType.DownMember] = 'GuildMemberHandle_03',
	[Enum.GuildPeopleHandleType.PrivateChat] = 'GuildMemberHandle_04',
	[Enum.GuildPeopleHandleType.SeeInfo] = 'GuildMemberHandle_05',
	[Enum.GuildPeopleHandleType.Interest] = 'GuildMemberHandle_06',
	[Enum.GuildPeopleHandleType.CancelInterest] = 'GuildMemberHandle_07',
	[Enum.GuildPeopleHandleType.Kickout] = 'GuildMemberHandle_08',
}


local ManageMap = {
	[Enum.GuildPostType.None] = {
		Enum.GuildManageType.List,
		Enum.GuildManageType.Exit,
	},
	[Enum.GuildPostType.VicePresident] = {
		Enum.GuildManageType.AuditApply,
		Enum.GuildManageType.List,
		Enum.GuildManageType.Exit,
	},
	[Enum.GuildPostType.President] = {
		Enum.GuildManageType.AuditApply,
		Enum.GuildManageType.Settings,
		Enum.GuildManageType.Mail,
		Enum.GuildManageType.List,
		Enum.GuildManageType.Dismiss,
	},
}

local PeopleHandleMap = {
	[Enum.GuildPostType.None] = {
		[Enum.GuildPostType.None] = {
			Enum.GuildPeopleHandleType.PrivateChat,
			Enum.GuildPeopleHandleType.SeeInfo,
			Enum.GuildPeopleHandleType.Interest,
		},
		[Enum.GuildPostType.VicePresident] = {
			Enum.GuildPeopleHandleType.PrivateChat,
			Enum.GuildPeopleHandleType.SeeInfo,
			Enum.GuildPeopleHandleType.Interest,
		},
		[Enum.GuildPostType.President] = {
			Enum.GuildPeopleHandleType.PrivateChat,
			Enum.GuildPeopleHandleType.SeeInfo,
			Enum.GuildPeopleHandleType.Interest,
		},
	},
	[Enum.GuildPostType.VicePresident] = {
		[Enum.GuildPostType.None] = {
			Enum.GuildPeopleHandleType.PrivateChat,
			Enum.GuildPeopleHandleType.SeeInfo,
			Enum.GuildPeopleHandleType.Interest,
			Enum.GuildPeopleHandleType.Kickout,
		},
		[Enum.GuildPostType.VicePresident] = {
			Enum.GuildPeopleHandleType.PrivateChat,
			Enum.GuildPeopleHandleType.SeeInfo,
			Enum.GuildPeopleHandleType.Interest,
		},
		[Enum.GuildPostType.President] = {
			Enum.GuildPeopleHandleType.PrivateChat,
			Enum.GuildPeopleHandleType.SeeInfo,
			Enum.GuildPeopleHandleType.Interest,
		},
	},
	[Enum.GuildPostType.President] = {
		[Enum.GuildPostType.None] = {
			Enum.GuildPeopleHandleType.UpVicePresident,
			Enum.GuildPeopleHandleType.PrivateChat,
			Enum.GuildPeopleHandleType.SeeInfo,
			Enum.GuildPeopleHandleType.Interest,
			Enum.GuildPeopleHandleType.Kickout,
		},
		[Enum.GuildPostType.VicePresident] = {
			Enum.GuildPeopleHandleType.DownMember,
			Enum.GuildPeopleHandleType.UpPresident,
			Enum.GuildPeopleHandleType.PrivateChat,
			Enum.GuildPeopleHandleType.SeeInfo,
			Enum.GuildPeopleHandleType.Interest,
			Enum.GuildPeopleHandleType.Kickout,
		},
		[Enum.GuildPostType.President] = {
			Enum.GuildPeopleHandleType.PrivateChat,
			Enum.GuildPeopleHandleType.SeeInfo,
			Enum.GuildPeopleHandleType.Interest,
		},
	}
}

function UIGuildMainView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildMainCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildMainView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_SELF_MORE_INFO_CHANGED, self, self.OnGuildMoreInfoChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_MEMBER_MORE_INFO_CHANGED, self, self.OnGuildMemberMoreInfoChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_DISBAND_SUCCESS, self, self.OnGuildDisBandSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_QUIT_SUCCESS, self, self.OnGuildQuitSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_KICKOUT_SUCCESS, self, self.OnGuildKickoutSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_NOTICE_CHANGED, self, self.OnGuildNoticeChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_NAME_CHANGED, self, self.OnGuildNameChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_BADGE_CHANGED, self, self.OnGuildBadgeChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_ACTIVE_CHANGED, self, self.OnGuildActiveChanged)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_GET_AUDIT_APPLY_LIST_CHANGED, self, self.OnGetAuditApplyListChanged)
end

function UIGuildMainView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildMainView:Init()
	self:InitGuildTips()
	self.scrollView.scrollRect.horizontalNormalizedPosition = 0
	self.selectItemIdx = nil

	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	self.loadStatusLoopListCtr = LoadStatusLoopListCtr:new(self, self.peopleList.loopListView, 0, 50,
															false, nil, nil,
															true, 'LoadingItem', Enum.ListLoadingStatus.WaitLoad,
															self.GetItemByIndex, nil, self.OnBeginLoad)
	self.noticeInput.inputField.interactable = false
	self.noticeNumTxt:SetActive(false)

	self:OnClickClickMaskBtn()
	self:RefreshBriefView()
	self:RefreshMoreInfoView()
	self:RefreshGuildBattle()
	-- 界面准备好了，等待服务器数据到来
	local errorCode = self.controller:SendGetGuildInfoReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildMainView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	self.noticeInput.inputField.onValidateInput = nil
	self.noticeInput.inputField.onValueChanged:RemoveAllListeners()
	self.noticeInput.inputField.onEndEdit:RemoveAllListeners()
end

function UIGuildMainView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.btnAdmin.button, self, self.OnClickAdminBtn)

	self.uiBase:AddButtonUniqueEventListener(self.changeBtn.button, self, self.OnClickChangeBtn)
	self.noticeInput.inputField.onValidateInput = self.noticeInput.inputField.OnValidateInput(self.OnValidateInput, self)
	self.noticeInput.inputField.onValueChanged:RemoveAllListeners()
	self.noticeInput.inputField.onValueChanged:AddListener(function(text)
		self:OnValueChangedInput(text)
	end)
	self.noticeInput.inputField.onEndEdit:RemoveAllListeners()
	self.noticeInput.inputField.onEndEdit:AddListener(function(text)
		self:OnEndEditInput(text)
	end)

	self.uiBase:AddButtonUniqueEventListener(self.btnPlayRule.button, self, self.OnClickPlayRuleBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnBack.button, self, self.OnClickBackBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnGuildLog.button, self, self.OnClickGuildLogBtn)

	self.uiBase:AddButtonUniqueEventListener(self.active.button, self, self.OnClickActiveBtn)
	self.uiBase:AddButtonUniqueEventListener(self.guildCP.button, self, self.OnClickGuildCPBtn)
	self.uiBase:AddButtonUniqueEventListener(self.expBar.background.button, self, self.OnClickExpBarBtn)
	self.uiBase:AddButtonUniqueEventListener(self.clickMask.button, self, self.OnClickClickMaskBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnVenery.button, self, self.OnClickVeneryBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnShop.button, self, self.OnClickShopBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnDemon.button, self, self.OnClickDemonBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnBattle.button, self, self.OnClickBattleBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnL.button, self, self.OnClickLBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnR.button, self, self.OnClickRBtn)
end

function UIGuildMainView:OnHide()

end

function UIGuildMainView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildMainView:OnClose()
end

function UIGuildMainView:OnDispose()
	self.selectItemIdx = nil
	if self.endEditDelayTimer then
		self.endEditDelayTimer:Stop()
		self.endEditDelayTimer = nil
	end
	if self.guildBattleTimer then
		if self.guildBattleTimer.running then
			self.guildBattleTimer:Stop()
		end
		self.guildBattleTimer = nil
	end
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	self:DisposeGuildTips()
	self.controller:OnDispose()
end

function UIGuildMainView:OnGuildMoreInfoChanged()
	self:RefreshBriefView()
	self:RefreshMoreInfoView()
	self:RefreshGuildBattle()
	self:OnBeginLoad()
end

function UIGuildMainView:OnGuildMemberMoreInfoChanged(guild)
	if guild ~= self.controller:GetId() then return end
	self:RefreshMemberInfoView()
end

function UIGuildMainView:OnGuildDisBandSuccess()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIGuildMainView:OnGuildQuitSuccess()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIGuildMainView:OnGuildKickoutSuccess()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIGuildMainView:OnGuildNoticeChanged()
	self:RefreshGuildNotice()
end

function UIGuildMainView:OnGuildNameChanged()
	self:RefreshGuildName()
end

function UIGuildMainView:OnGuildBadgeChanged()
	self:RefreshGuildBadge()
end

function UIGuildMainView:OnGuildActiveChanged()
	self:RefreshGuildActive()
end

function UIGuildMainView:OnGetAuditApplyListChanged()
	local itemList = self.peopleList.loopListView.ItemList
	if not itemList then return end
	local count = itemList.Count
	if count <= 0 then return end
	local startList = itemList[0]
	local endList = itemList[count - 1]
	if not startList then return end
	local startIdx = startList.ItemIndex
	if not endList then return end
	local endIdx = endList.ItemIndex
	local uids = self.controller:GetNeedLoadMemberMoreInfo(startIdx, endIdx)
	if not uids or #uids == 0 then
		return
	end
	self.controller:SendGetGuildMemberInfoReq(uids)
end


function UIGuildMainView:OnClickAdminBtn()
	local guildPostType = self.controller:GetGuildPostType()
	local manages = ManageMap[guildPostType]
	if not manages then return end
	local len = #manages
	if len <= 0 then return end
	--- 如果界面不刷新数据，后续可在界面打开时初始化
	local menus = {}
	for i = 1, len do
		local guildManageType = manages[i]
		local langKey = ManageLanguageKeyMap[guildManageType] or ''
		menus[#menus + 1] = {langKey, guildManageType, (guildManageType == Enum.GuildManageType.Mail)}
	end
	local rectTransform = self.btnAdmin.rectTransform
	local min = rectTransform.rect.min
	local alignPos = rectTransform:TransformPoint(min)
	local data = {menus = menus, ownerCB = self, cb = self.ManageFuncMenuCallBack, alignPos = alignPos, alignment = Enum.Alignment.UpperLeft }
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFuncMenu, data)
end

function UIGuildMainView:OnClickChangeBtn()
	if self.endEditDelayTimer then
		self.endEditDelayTimer:Stop()
	end
	self.changeBtn:SetActive(false)
	self.noticeInput.inputField.interactable = true
	self.noticeInput.inputField:ActivateInputField()
	local text = self.noticeInput.inputField.text
	local len = GetActualStringLength(text)
	local max = self.controller:GetNoticeLengthMax()
	self.noticeNumTxt:SetActive(true)
	self.noticeNumTxt.text.text = tostring(len) .. '/' .. tostring(max)
end

function UIGuildMainView:OnValidateInput(text, charIndex, addedChar)
	local len = GetActualStringLength(text) + 1
	local max = self.controller:GetNoticeLengthMax()
	if len > max then return 0 end
	return addedChar
end

function UIGuildMainView:OnValueChangedInput(text)
	local len = GetActualStringLength(text)
	local max = self.controller:GetNoticeLengthMax()
	self.noticeNumTxt.text.text = tostring(len) .. '/' .. tostring(max)
end

function UIGuildMainView:OnEndEditInput(text)
	self.controller:SetChangeNotice(text)
	self.noticeNumTxt:SetActive(false)
	-- 不能同帧设置，So延迟
	if self.noticeInput.inputField.interactable then
		if self.endEditDelayTimer then
			self.endEditDelayTimer.count = Time.frameCount + 1
		else
			self.endEditDelayTimer = FrameTimer.New(function()
				local guildPostType = self.controller:GetGuildPostType()
				local canChangeNotice = (guildPostType == Enum.GuildPostType.President)
				if canChangeNotice then
					self.noticeInput.inputField.interactable = false
					self.changeBtn:SetActive(true)
				else
					self.noticeInput.inputField.interactable = false
					self.changeBtn:SetActive(false)
				end
			end, 1)
		end
		if not self.endEditDelayTimer.running then
			self.endEditDelayTimer:Start()
		end
	end
	local guildPostType = self.controller:GetGuildPostType()
	if (guildPostType == Enum.GuildPostType.President) then
		local errorCode = self.controller:SendChangeNoticeReq()
		if errorCode ~= 0 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end

function UIGuildMainView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'GuildPlayExplain'})
end

function UIGuildMainView:OnClickBackBtn()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIGuildMainView:OnClickGuildLogBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildLog)
end

function UIGuildMainView:OnClickActiveBtn(btn)
	local rectTransform = btn.transform
	local rect = rectTransform.rect
	local pos = Vector2(rect.xMin, rect.yMin)
	pos = rectTransform:TransformPoint(pos)
	self:SetGuildTips(true, 1, pos)
end

function UIGuildMainView:OnClickGuildCPBtn(btn)
	local rectTransform = btn.transform
	local rect = rectTransform.rect
	local pos = Vector2(rect.xMin, rect.yMin)
	pos = rectTransform:TransformPoint(pos)
	self:SetGuildTips(true, 3, pos)
end

function UIGuildMainView:OnClickExpBarBtn(btn)
	local rectTransform = btn.transform
	local rect = rectTransform.rect
	local pos = Vector2(rect.xMin, rect.yMin)
	pos = rectTransform:TransformPoint(pos)
	self:SetGuildTips(true, 2, pos)
end

function UIGuildMainView:OnClickClickMaskBtn()
	self:SetMemberActiveTips(false)
	self:SetGuildTips(false)
end

function UIGuildMainView:OnClickVeneryBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildHunt, nil, self.uiData.id)
end

function UIGuildMainView:OnClickDemonBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildDemon, nil, self.uiData.id)
end

function UIGuildMainView:OnClickShopBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIShop, 4, self.uiData.id)
end

function UIGuildMainView:OnClickBattleBtn()
	local guildWarInfo = self.controller:GetGuildWarInfo()
	local state = guildWarInfo and guildWarInfo.curState or 3
	local remainTime = 0
	if guildWarInfo and guildWarInfo.nextStateTime then
		remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(guildWarInfo.nextStateTime)
	end
	if state == 2 then
		if remainTime <= 0 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarEnterTips02')
		else
			if ManagerContainer.DataMgr.GuildWarDataMgr:GetOpenState() then
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildWarMatchMap, nil, self.uiData.id)
			else
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle20')
			end
		end
	elseif state == 3 then
		if remainTime <= 0 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarEnterTips02')
		else
			if ManagerContainer.DataMgr.GuildWarDataMgr:GetOpenState() then
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildWarMatchMap, nil, self.uiData.id)
			else
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle20')
			end
		end
	else
		if remainTime <= 0 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarEnterTips02')
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarEnterTips01')
		end
	end
end

function UIGuildMainView:OnClickLBtn()
	local scrollRect = self.scrollView.scrollRect
	local horizontalNormalizedPosition = scrollRect.horizontalNormalizedPosition
	if horizontalNormalizedPosition == 0 then return end
	scrollRect:DOHorizontalNormalizedPos(0, horizontalNormalizedPosition * 0.1)
end

function UIGuildMainView:OnClickRBtn()
	local scrollRect = self.scrollView.scrollRect
	local horizontalNormalizedPosition = scrollRect.horizontalNormalizedPosition
	if horizontalNormalizedPosition == 1 then return end
	scrollRect:DOHorizontalNormalizedPos(1, (1 - horizontalNormalizedPosition) * 0.1)
end

function UIGuildMainView:OnClickGuildPeopleItem(btn, params)
	local itemLua = params[0]
	local uid = params[1]
	local itemIdx = params[2]
	local guildPostType = self.controller:GetGuildPostType()
	local _userUid = ManagerContainer.DataMgr.UserData:GetUserId()
    if int64.equals(uid, _userUid) then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatError1")
		return
	end
	local interest = ManagerContainer.DataMgr.FriendDataMgr:HasInterestPlayer(uid)
	local handleGuildPostType = self.controller:GetGuildMemberPost(uid)
	local peopleHandleMap = PeopleHandleMap[guildPostType]
	local peopleHandle = nil
	if peopleHandleMap then
		peopleHandle = peopleHandleMap[handleGuildPostType]
	end
	if not peopleHandle then return end
	local len = #peopleHandle
	if len <= 0 then return end
	--- 如果界面不刷新数据，后续可在界面打开时初始化
	local menus = {}
	for i = 1, len do
		local guildPeopleHandleType = peopleHandle[i]
		if guildPeopleHandleType == Enum.GuildPeopleHandleType.Interest then
			if not interest then
				local langKey = PeopleHandleLanguageKeyMap[guildPeopleHandleType] or ''
				menus[#menus + 1] = {langKey, {guildPeopleHandleType, uid}}
			end
		elseif guildPeopleHandleType == Enum.GuildPeopleHandleType.CancelInterest then
			if interest then
				local langKey = PeopleHandleLanguageKeyMap[guildPeopleHandleType] or ''
				menus[#menus + 1] = {langKey, {guildPeopleHandleType, uid}}
			end
		else
			local langKey = PeopleHandleLanguageKeyMap[guildPeopleHandleType] or ''
			menus[#menus + 1] = {langKey, {guildPeopleHandleType, uid}}
		end
	end
	local rectTransform = itemLua.rectTransform
	local rect = rectTransform.rect
	local pos = Vector2(rect.xMin + rect.width * 0.5, rect.yMin)
	local alignPos = rectTransform:TransformPoint(pos)
	local data = {menus = menus, ownerCB = self, cb = self.PeopleHandleFuncMenuCallBack, cancelCb = self.PeopleHandleFuncMenuCancelCallBack, alignPos = alignPos, alignment = Enum.Alignment.UpperLeft }
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFuncMenu, data)
	self.selectItemIdx = itemIdx
	itemLua.select:SetActive(true)
end

function UIGuildMainView:OnClickGuildPeopleActiveItem(btn, params)
	local itemLua = params[0]
	local sevenActive = params[1]
	local rectTransform = itemLua.active.rectTransform
	local rect = rectTransform.rect
	local pos = Vector2(rect.xMin, rect.yMin + rect.height * 0.5)
	pos = rectTransform:TransformPoint(pos)
	self:SetMemberActiveTips(true, pos, sevenActive)
end



function UIGuildMainView:GetItemByIndex(loopListView, idx, dataIdx)
	local itemData = self.controller:GetMemberMoreInfoByItemidx(dataIdx)
	if not itemData then return nil end
	local item = loopListView:NewListViewItem('GuildPeopleItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'GuildPeopleItem', item.gameObject)
	if itemLua then
		local brief = itemData.brief
		local playerBrief = itemData.playerBrief
		local uid
		local data = {}
		local headFrameId = nil
		local vipLv = nil
		if playerBrief then
			uid = playerBrief.uid
			vipLv = playerBrief.vipLv
			headFrameId = playerBrief.headFrame
			if int64.equals(uid, ManagerContainer.DataMgr.UserData:GetUserId()) then
				headFrameId = ManagerContainer.DataMgr.UserData:GetHeadFrameId()
				vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
			end
			local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(playerBrief.configId)
			local jobIcon = ''
			if jobCfg then
				jobIcon = jobCfg.JobIcon
			end
			data = {Level = playerBrief.level, ProfessionIcon = jobIcon, HeadIcon = playerBrief.headPortraitName, IsHero = true}
			itemLua.nameTxt.text.text = tostring(playerBrief.nickName)
			itemLua.atkTxt.text.text = tostring(playerBrief.fightPower)
			local offlineTime = brief and brief.offlineTime or 0
			itemLua.onlineTxt.text.text = CommonUtil.GetOnlineStatus((offlineTime == 0), offlineTime)
		else
			itemLua.nameTxt.text.text = ''
			itemLua.atkTxt.text.text = ''
			itemLua.onlineTxt.text.text = ''
		end
		itemLua.headItem.head.button.enabled = false
		CommonUtil.SetPlayerHeadAndFrame(self, itemLua.headItem, data, false, headFrameId)
		itemLua.vipIcon.image.enabled = false
		itemLua.vipIcon.image.sprite = nil
		if vipLv and vipLv >= 0 then
			local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
			if vipCfg then
				CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
					if sprite then
						itemLua.vipIcon.image.sprite = sprite
						itemLua.vipIcon.image.enabled = true
					end
				end, itemLua, 'VipIcon')
			end
		end


		local post = brief and brief.post or Enum.GuildPostType.None
		if not uid then uid = brief and brief.uid or nil end

		itemLua.presidentTag:SetActive(post == Enum.GuildPostType.President)
		itemLua.vicePresidentTag:SetActive(post == Enum.GuildPostType.VicePresident)

		local active = itemData.active
		itemLua.activeTxt.text.text = (active and tostring(active) or '0')
		itemLua.select:SetActive(self.selectItemIdx == idx)

		self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickGuildPeopleItem, itemLua, uid, idx)
		self.uiBase:AddButtonUniqueEventListener(itemLua.active.button, self, self.OnClickGuildPeopleActiveItem, itemLua, active)
	end
	return item
end

function UIGuildMainView:OnBeginLoad(isLeft)
	-- 发送获得后续公会玩家信息
	local uids = self.controller:GetNextLoadMemberUids()
	local errorCode = self.controller:SendGetGuildMemberInfoReq(uids)
	if errorCode ~= 0 then
		self:RefreshMemberInfoView()
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)

	end
end


function UIGuildMainView:RefreshGuildName()
	local brief = self.controller:GetGuildBriefData()
	self.nameTxt.text.text = brief and tostring(brief.name) or ''
end

function UIGuildMainView:RefreshGuildBadge()
	local brief = self.controller:GetGuildBriefData()
	local itemLua = self.guildBadgeItem
	itemLua.badge.image.enabled = false
	itemLua.badge.image.sprite = nil
	local resPath = nil
	if brief then
		resPath = brief.badgeResPath
	end
	CommonUtil.LoadIcon(self, resPath, function(sprite)
		itemLua.badge.image.enabled = true
		itemLua.badge.image.sprite = sprite
	end, itemLua, 'BadgeIcon')
end

function UIGuildMainView:RefreshGuildActive()
	local brief = self.controller:GetGuildBriefData()
	self.activeTxt.text.text = brief and tostring(brief.active) or ''
end

function UIGuildMainView:RefreshGuildNotice()
	local moreInfo = self.controller:GetGuildMoreInfoData()
	if not moreInfo then return end
	if not self.noticeInput.inputField.interactable then
		self.noticeInput.inputField.text = tostring(moreInfo.notice)
	end

end

function UIGuildMainView:RefreshBriefView()
	local brief = self.controller:GetGuildBriefData()
	if not brief then
		self.lvTxt.text.text = ''
		self.nameTxt.text.text = ''
		self.idTxt.text.text = ''
		self.activeTxt.text.text = ''
		return
	end
	local itemLua = self.guildBadgeItem
	itemLua.badge.image.enabled = false
	itemLua.badge.image.sprite = nil
	if brief.badgeResPath and brief.badgeResPath ~= nil then
		CommonUtil.LoadIcon(self, brief.badgeResPath, function(sprite)
			itemLua.badge.image.enabled = true
			itemLua.badge.image.sprite = sprite
		end, itemLua, 'BadgeIcon')
	end
	self.lvTxt.text.text = tostring(brief.level)
	self.nameTxt.text.text = tostring(brief.name)
	self.idTxt.text.text = tostring(brief.id)
	self.activeTxt.text.text = tostring(brief.active)
end

function UIGuildMainView:RefreshMoreInfoView()
	local moreInfo = self.controller:GetGuildMoreInfoData()
	if not moreInfo then
		self.btnAdmin:SetActive(false)
		self.expBar:SetActive(false)
		self.noticeInput:SetActive(false)
		self.changeBtn:SetActive(false)
		self.btnVenery:SetActive(false)
		self.btnShop:SetActive(false)
		self.btnBattle:SetActive(false)
		return
	end
	local guildPostType = self.controller:GetGuildPostType()
	self.btnAdmin:SetActive(true)
	self.expBar:SetActive(true)
	self.noticeInput:SetActive(true)
	self.btnVenery:SetActive(true)
	self.btnShop:SetActive(true)
	self.btnBattle:SetActive(true)

	local canChangeNotice = (guildPostType == Enum.GuildPostType.President)
	self.changeImg:SetActive(canChangeNotice)

	local brief = self.controller:GetGuildBriefData()
	local isMaxLv = false
	if brief then
		if brief.level then
			if not ManagerContainer.CfgMgr:GetGuildLvCfgById(brief.level + 1) then
				isMaxLv = true
			end
		end
	end
	if isMaxLv then
		self.expBar.slider.value = 0
		self.expTxt.text.text = string.formatbykey('GuildExpTips_04')
	else
		self.expBar.slider.value = ((moreInfo.expLimit == 0) and 0 or moreInfo.exp / moreInfo.expLimit)
		self.expTxt.text.text = tostring(moreInfo.exp) .. '/' .. tostring(moreInfo.expLimit)
	end
	if not self.noticeInput.inputField.interactable then
		self.noticeInput.inputField.text = tostring(moreInfo.notice)
		self.changeBtn:SetActive(canChangeNotice)
	else
		if not canChangeNotice then
			self.noticeInput.inputField:DeactivateInputField()
			self.changeBtn:SetActive(false)
			self.noticeInput.inputField.text = tostring(moreInfo.notice)
			self.noticeInput.inputField.interactable = false
		end
	end

	local maxDataLength = self.controller:GetGuildMemberLimit()
	local dataLength = self.controller:GetGuildMemberNum()
	self.peopleTxt.text.text = tostring(dataLength) .. '/' .. tostring(maxDataLength)
end

function UIGuildMainView:RefreshMemberInfoView()
	local dataLength = self.controller:GetGuildMemberNum()
	local validLength = self.controller:GetValidMemberNum()
	self.loadStatusLoopListCtr:OnAllLoaded()
	self.loadStatusLoopListCtr:RefreshMaxDataLength(dataLength)
	self.loadStatusLoopListCtr:RefreshDataLength(validLength)
end

function UIGuildMainView:RefreshGuildBattle()
	local guildWarInfo = self.controller:GetGuildWarInfo()
	self.guildCPTxt.text.text = guildWarInfo and tostring(guildWarInfo.cp) or '0'
	local state = guildWarInfo and guildWarInfo.curState or 3
	local timer = self.btnBattle.timer
	if state == 1 then
		timer:SetActive(true)
		timer.sword:SetActive(false)
		timer.wait:SetActive(true)
	elseif state == 2 then
		timer:SetActive(true)
		timer.sword:SetActive(true)
		timer.wait:SetActive(false)
		timer.sword.animation:Play('GuildWarSword')
	elseif state == 3 then
		timer:SetActive(true)
		timer.sword:SetActive(true)
		timer.wait:SetActive(false)
		if timer.sword.animation:Play('GuildWarSword') then
			timer.sword.animation.this:get('GuildWarSword').normalizedTime = 0
			timer.sword.animation:Stop()
		end
		self.btnBattle.timer.timerTxt.text.text = string.formatbykey('GuildWarEnter_03')
		if self.guildBattleTimer and self.guildBattleTimer.running then
			self.guildBattleTimer:Stop()
		end
		return
	else
		timer:SetActive(false)
		if self.guildBattleTimer and self.guildBattleTimer.running then
			self.guildBattleTimer:Stop()
		end
		return
	end
	self:RefreshGuildBattleTime()
end

function UIGuildMainView:RefreshGuildBattleTime()
	local guildWarInfo = self.controller:GetGuildWarInfo()
	local remainTime = guildWarInfo and guildWarInfo.nextStateTime or nil
	if remainTime then
		remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(remainTime)
	else
		remainTime = 0
	end
	if guildWarInfo and guildWarInfo.curState == 2 then
		self.btnBattle.timer.timerTxt.text.text = string.formatbykey('GuildWarEnter_02', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false))
	else
		self.btnBattle.timer.timerTxt.text.text = string.formatbykey('GuildWarEnter_01', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false))
	end
	if not remainTime or remainTime <= 0 then
		if self.guildBattleTimer and self.guildBattleTimer.running then
			self.guildBattleTimer:Stop()
		end
	else
		local validTime = nil
		if remainTime >= 86400 then
			validTime = remainTime % 3600
			if validTime == 0 then validTime = 3600 end
		elseif remainTime >= 3600 then
			validTime = remainTime % 60
			if validTime == 0 then validTime = 60 end
		else
			validTime = 1
		end
		if validTime then
			if self.guildBattleTimer then
				self.guildBattleTimer.duration = validTime
			else
				self.guildBattleTimer = Timer.New(slot(self.RefreshGuildBattle, self), validTime, -1)
			end
			if not self.guildBattleTimer.running then
				self.guildBattleTimer:Start()
			end
		else
			if self.guildBattleTimer and self.guildBattleTimer.running then
				self.guildBattleTimer:Stop()
			end
		end
	end
end








function UIGuildMainView:SetMemberActiveTips(isShow, pos, active)
	if not isShow then
		self.clickMask:SetActive(false)
		self.memberActiveTips:SetActive(false)
		return
	end
	self.clickMask:SetActive(true)
	self.memberActiveTips:SetActive(true)
	self.memberActiveTips.text.text.text = string.formatbykey('MemberActiveTips') .. tostring(active)
	self.memberActiveTips.rectTransform.position = pos
end

function UIGuildMainView:SetGuildActiveTips(isShow)
	if not isShow then
		self.guildActiveTips:SetActive(false)
		return
	end
	self.clickMask:SetActive(true)
	self.guildActiveTips:SetActive(true)
	local brief = self.controller:GetGuildBriefData()
	if brief then
		self.guildActiveTips.activeItem.numTxt.text.text = tostring(brief.active) ..'/' .. tostring(brief.activeLimit)
	else
		self.guildActiveTips.activeItem.numTxt.text.text = '0'
	end

	local roleData = self.controller:GetRoleData()
	local activeDayLimit = self.controller:GetActiveDayLimit()
	if roleData then
		self.guildActiveTips.activeDayItem.numTxt.text.text = tostring(roleData.activeDay) .. '/' .. tostring(activeDayLimit)
		self.guildActiveTips.activeSevenDayItem.numTxt.text.text = tostring(roleData.active)
	else
		self.guildActiveTips.activeDayItem.numTxt.text.text = '0/' .. tostring(activeDayLimit)
		self.guildActiveTips.activeSevenDayItem.numTxt.text.text = '0'
	end
end




function UIGuildMainView:InitGuildTips()
	local item = self.guildTipItem
	if not item then
		local parentTrans = self.guildTips.transform:Find('Item')
		item = self:GenerateGuildTipItemLua(parentTrans)
		self.guildTipItem = item
	end
end

function UIGuildMainView:DisposeGuildTips()
	local items = self.guildTipItems
	if items then
		for _, item in pairs(items) do
			if item then
				local go = item.go
				item.go = nil
				item.nameGo = nil
				item.nameTxt = nil
				item.numGo = nil
				item.numTxt = nil
				if self.guildTipItem ~= item then
					CommonUtil.DestroyGO(go)
				end
			end
		end
		self.guildTipItems = nil
	end
	self.guildTipItem = nil
	self.guildTipItemCount = nil
end

function UIGuildMainView:GetGuildTipItem(idx)
	local items = self.guildTipItems
	if not items then
		if not self.guildTipItem then
			return nil
		end
		items = {self.guildTipItem}
		self.guildTipItemCount = 1
		self.guildTipItems = items
	end
	local item = self.guildTipItems[idx]
	if item then
		if item.go then
			item.go:SetActive(true)
		end
		return item
	end
	if not self.guildTipItem then
		return nil
	end
	local go = UnityEngine.GameObject.Instantiate(self.guildTipItem.go)
	go:SetActive(true)
	local trans = go.transform
	trans:SetParent(self.guildTips.transform)
    trans.localPosition = Vector3.zero
    trans.localScale = Vector3.one
	trans.localRotation = Quaternion.identity
	trans:SetAsLastSibling()
	item = self:GenerateGuildTipItemLua(trans)
	self.guildTipItems[idx] = item
	if not self.guildTipItemCount or self.guildTipItemCount < idx then
		self.guildTipItemCount = idx
	end
	return item
end

function UIGuildMainView:GenerateGuildTipItemLua(trans)
	if not trans then return nil end
	local item = {}
	local nameGo = trans:Find('NameTxt').gameObject
	local numGo = trans:Find('NumTxt').gameObject
	item.go = trans.gameObject
	item.nameGo = nameGo
	item.nameTxt = nameGo:GetComponent(Enum.TypeInfo.Text)
	item.numGo = numGo
	item.numTxt = numGo:GetComponent(Enum.TypeInfo.Text)
	return item
end

function UIGuildMainView:SetGuildTips(isShow, tipType, alginPos)
	if not isShow then
		self.clickMask:SetActive(false)
		self.guildTips:SetActive(false)
		return
	end
	self.clickMask:SetActive(true)
	self.guildTips:SetActive(true)
	if alginPos then
		local pos = self.guildTips.transform.parent:InverseTransformPoint(alginPos)
		self.guildTips.transform.localPosition = Vector2(0, pos.y, 0)
	end
	local offset = 1
	if tipType == 1 then
		offset = self:SetGuildActiveTips()
	elseif tipType == 2 then
		offset = self:SetGuildExpTips()
	elseif tipType == 3 then
		offset = self:SetGuildCPTips()
	else
		self.guildTips.text.text.text = string.formatbykey('None')
		self.guildTips.space:SetActive(false)
	end
	if self.guildTipItems and self.guildTipItemCount then
		for i = offset, self.guildTipItemCount do
			local item = self.guildTipItems[i]
			if item and item.go then
				item.go:SetActive(false)
			end
		end
	end
end

function UIGuildMainView:SetGuildActiveTips()
	self.guildTips.text.text.text = string.formatbykey('GuildActiveTips')
	self.guildTips.space:SetActive(true)
	local brief = self.controller:GetGuildBriefData()
	local itemLua = self:GetGuildTipItem(1)
	if itemLua then
		itemLua.nameTxt.text = string.formatbykey('GuildActiveTips_01')
		if brief then
			itemLua.numTxt.text = tostring(brief.active) ..'/' .. tostring(brief.activeLimit)
		else
			itemLua.numTxt.text = '0'
		end
	end

	local roleData = self.controller:GetRoleData()
	local activeDayLimit = self.controller:GetActiveDayLimit()
	if roleData then
		itemLua = self:GetGuildTipItem(2)
		if itemLua then
			itemLua.nameTxt.text = string.formatbykey('GuildActiveTips_02')
			itemLua.numTxt.text = tostring(roleData.activeDay) .. '/' .. tostring(activeDayLimit)
		end
		itemLua = self:GetGuildTipItem(3)
		if itemLua then
			itemLua.nameTxt.text = string.formatbykey('GuildActiveTips_03')
			itemLua.numTxt.text = tostring(roleData.active)
		end
	else
		itemLua = self:GetGuildTipItem(2)
		if itemLua then
			itemLua.nameTxt.text = string.formatbykey('GuildActiveTips_02')
			itemLua.numTxt.text = '0/' .. tostring(activeDayLimit)
		end
		itemLua = self:GetGuildTipItem(3)
		if itemLua then
			itemLua.nameTxt.text = string.formatbykey('GuildActiveTips_03')
			itemLua.numTxt.text = '0'
		end
	end
	return 4
end

function UIGuildMainView:SetGuildExpTips()
	self.guildTips.text.text.text = string.formatbykey('GuildExpTips')
	self.guildTips.space:SetActive(true)
	local brief = self.controller:GetGuildBriefData()
	local itemLua = self:GetGuildTipItem(1)
	if itemLua then
		if brief then
			if brief.level then
				local lvCfgData = ManagerContainer.CfgMgr:GetGuildLvCfgById(brief.level + 1)
				if lvCfgData then
					lvCfgData = ManagerContainer.CfgMgr:GetGuildLvCfgById(brief.level)
					if lvCfgData then
						itemLua.nameTxt.text = string.formatbykey('GuildExpTips_01')
						itemLua.numTxt.text = ''
						itemLua = self:GetGuildTipItem(2)
						if itemLua then
							itemLua.nameTxt.text = string.formatbykey('GuildExpTips_02')
							itemLua.numTxt.text = tostring(lvCfgData.PeopleAdd)
						end
						itemLua = self:GetGuildTipItem(3)
						if itemLua then
							itemLua.nameTxt.text = string.formatbykey('GuildExpTips_03')
							itemLua.numTxt.text = tostring(lvCfgData.ActiveAdd)
						end
						return 4
					end
				end
			end
		end
		itemLua.nameTxt.text = string.formatbykey('GuildExpTips_04')
		itemLua.numTxt.text = ''
	end
	return 2
end

function UIGuildMainView:SetGuildCPTips()
	local guildWarInfo = self.controller:GetGuildWarInfo()
	self.guildTips.text.text.text = string.formatbykey('GuildCPTips')
	self.guildTips.space:SetActive(true)
	local itemLua = self:GetGuildTipItem(1)
	if itemLua then
		itemLua.nameTxt.text = string.formatbykey('GuildCPTips_01')
		itemLua.numTxt.text = guildWarInfo and tostring(guildWarInfo.cp) or '0'
	end
	itemLua = self:GetGuildTipItem(2)
	if itemLua then
		itemLua.nameTxt.text = string.formatbykey('GuildCPTips_02')
		if guildWarInfo and guildWarInfo.rank > 0 then
			itemLua.numTxt.text = tostring(guildWarInfo.rank)
		else
			itemLua.numTxt.text = string.formatbykey('NoRank')
		end
	end
	return 3
end
























function UIGuildMainView:SureDisbandGuild()
	local errorCode = self.controller:SendDisbandGuildReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildMainView:SureQuitGuild()
	local errorCode = self.controller:SendQuitGuildReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end


function UIGuildMainView:ManageFuncMenuCallBack(guildManageType)
	if guildManageType == Enum.GuildManageType.AuditApply then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildAuditApply)
	elseif guildManageType == Enum.GuildManageType.Settings then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildSettings)
	elseif guildManageType == Enum.GuildManageType.Mail then
	elseif guildManageType == Enum.GuildManageType.List then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildRecommend)
	elseif guildManageType == Enum.GuildManageType.Dismiss then
		local data = {"GuildDismiss", nil, nil, self, self.SureDisbandGuild}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
	elseif guildManageType == Enum.GuildManageType.Exit then
		local cd = self.controller:GetEnterGuildCD()
		local data = {"GuildExit", {cd}, nil, self, self.SureQuitGuild}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
	end
end






function UIGuildMainView:SureChangePost(data)
	local uid = data.uid
	local post = data.post
	local errorCode = self.controller:SendChangeMemberTitleReq(uid, post)
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildMainView:SureKickout(data)
	local uid = data.uid
	local errorCode = self.controller:SendKickGuildMemeberReq(uid)
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildMainView:PeopleHandleFuncMenuCancelCallBack()
	local selectItemIdx = self.selectItemIdx
	self.selectItemIdx = nil
	self.peopleList.loopListView:RefreshItemByItemIndex(selectItemIdx)
end

function UIGuildMainView:PeopleHandleFuncMenuCallBack(params)
	local selectItemIdx = self.selectItemIdx
	self.selectItemIdx = nil
	self.peopleList.loopListView:RefreshItemByItemIndex(selectItemIdx)
	local guildPeopleHandleType = params[1]
	local uid = params[2]
	if guildPeopleHandleType == Enum.GuildPeopleHandleType.UpPresident then
		local guildData = self.controller:GetMemberMoreInfoByUid(uid)
		local nickName = nil
		if guildData and guildData.playerBrief then
			nickName = guildData.playerBrief.nickName
		end
		local data = {"GuildUpPresident", {nickName}, {uid = uid, post = Enum.GuildPostType.President}, self, self.SureChangePost}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
	elseif guildPeopleHandleType == Enum.GuildPeopleHandleType.UpVicePresident then
		local guildData = self.controller:GetMemberMoreInfoByUid(uid)
		local nickName = nil
		if guildData and guildData.playerBrief then
			nickName = guildData.playerBrief.nickName
		end
		local data = {"GuildUpVicePresident", {nickName}, {uid = uid, post = Enum.GuildPostType.VicePresident}, self, self.SureChangePost}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
	elseif guildPeopleHandleType == Enum.GuildPeopleHandleType.DownMember then
		local guildData = self.controller:GetMemberMoreInfoByUid(uid)
		local nickName = nil
		if guildData and guildData.playerBrief then
			nickName = guildData.playerBrief.nickName
		end
		local data = {"GuildDownMember", {nickName, CommonUtil.GetGuildPostStr(self.controller:GetGuildMemberPost(uid))}, {uid = uid, post = Enum.GuildPostType.None}, self, self.SureChangePost}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
	elseif guildPeopleHandleType == Enum.GuildPeopleHandleType.PrivateChat then
		local guildData = self.controller:GetMemberMoreInfoByUid(uid)
		local nickName = nil
		local imgId = nil
		local jobId, level,sex
		if guildData and guildData.playerBrief then
			nickName = guildData.playerBrief.nickName
			imgId = guildData.playerBrief.headPortraitName
			jobId = guildData.playerBrief.config_id
			level = guildData.playerBrief.level
			sex = guildData.playerBrief.gender
		end
		ManagerContainer.LuaUIMgr:PrivateChatOtherPlayer(uid, nickName, imgId,jobId,level,sex)
	elseif guildPeopleHandleType == Enum.GuildPeopleHandleType.SeeInfo then
		ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
	elseif guildPeopleHandleType == Enum.GuildPeopleHandleType.Interest then
		local friendState = ManagerContainer.DataMgr.FriendDataMgr:HasInterestPlayer(uid)
		if not friendState then
			ManagerContainer.DataMgr.FriendDataMgr:AddFriendReq(uid)
		end
	elseif guildPeopleHandleType == Enum.GuildPeopleHandleType.CancelInterest then
		local friendState = ManagerContainer.DataMgr.FriendDataMgr:HasInterestPlayer(uid)
		if friendState then
			ManagerContainer.DataMgr.FriendDataMgr:DeleteFriendReq(uid)
		end
	elseif guildPeopleHandleType == Enum.GuildPeopleHandleType.Kickout then
		local guildData = self.controller:GetMemberMoreInfoByUid(uid)
		local nickName = nil
		if guildData and guildData.playerBrief then
			nickName = guildData.playerBrief.nickName
		end
		local data = {"GuildKickout", {nickName}, {uid = uid}, self, self.SureKickout}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
	end
end


return UIGuildMainView

