local UIGuildInfoView = require("UIGuild/UIGuildInfoView_Generate")
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')

function UIGuildInfoView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildInfoCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildInfoView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_OTHER_MORE_INFO_CHANGED, self, self.OnGuildMoreInfoChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_MEMBER_MORE_INFO_CHANGED, self, self.OnGuildMemberMoreInfoChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_SUBMIT_APPLY_CHANGED, self, self.OnGuildSubmitChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_ENTER_SUCCESS, self, self.OnGuildEnterSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_CREATE_SUCCESS, self, self.OnGuildCreateSuccess)
end

function UIGuildInfoView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildInfoView:Init()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
	end
	self.loadStatusLoopListCtr = LoadStatusLoopListCtr:new(self, self.peopleList.loopListView, 0, 50,
															false, nil, nil,
															true, 'LoadingItem', Enum.ListLoadingStatus.WaitLoad,
															self.GetItemByIndex, nil, self.OnBeginLoad)

	self.peopleList.loopListView.ScrollRect.enabled = false
	self.noticeTxt.text.text = ''
	self.bottom:SetActive(not self.controller:IsInGuild())

	self:RefreshBriefView()
	self:RefreshMoreInfoView()
	self:RefreshApplyBtn()
	-- 界面准备好了，等待服务器数据到来
	local errorCode = self.controller:SendGetGuildMoreInfoReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildInfoView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuildInfoView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnEnter.button, self, self.OnClickSubmitApply)
	self.uiBase:AddButtonUniqueEventListener(self.btnCancel.button, self, self.OnClickCancelBtn)
end

function UIGuildInfoView:OnHide()

end

function UIGuildInfoView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildInfoView:OnClose()
end

function UIGuildInfoView:OnDispose()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	self.controller:OnDispose()
end


function UIGuildInfoView:OnPageInEnd()
	UIGuildInfoView.super.OnPageInEnd(self)
	self.peopleList.loopListView.ScrollRect.enabled = true
end

function UIGuildInfoView:OnGuildMoreInfoChanged()
	if not self.controller:RefreshGuildData() then return end
	self:RefreshBriefView()
	self:RefreshMoreInfoView()
	self:RefreshApplyBtn()
	self:OnBeginLoad()
end

function UIGuildInfoView:OnGuildMemberMoreInfoChanged(guild)
	if guild ~= self.controller:GetId() then return end
	self:RefreshMemberInfoView()
end

function UIGuildInfoView:OnGuildSubmitChanged()
	self:RefreshApplyBtn()
end

function UIGuildInfoView:OnGuildEnterSuccess()
	if not self.controller:IsInGuild() then
		return
	end
	self:UIClose()
end

function UIGuildInfoView:OnGuildCreateSuccess()
	if not self.controller:IsInGuild() then
		return
	end
	self:UIClose()
end

function UIGuildInfoView:OnClickCloseBtn()
	self:UIClose()
end

function UIGuildInfoView:OnClickSubmitApply()
	local cdTime = self.controller:GetNextCDTime()
	if cdTime then
		local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(cdTime)
		if remainTime > 0 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam('GuildTips_004', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true))
			return
		end
	end
	local errorCode = self.controller:SendSubmitApplyReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildInfoView:OnClickCancelBtn()
	local errorCode = self.controller:SendCancelApplyReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildInfoView:OnClickGuildPeopleItem(btn, param)
	local uid = param[0]
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end


function UIGuildInfoView:GetItemByIndex(loopListView, idx, dataIdx)
	local itemData = self.controller:GetMemberMoreInfoByItemidx(dataIdx)
	if not itemData then return nil end
	local item = loopListView:NewListViewItem('GuildPeopleItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'GuildPeopleItem', item.gameObject)
	if itemLua then
		local brief = itemData.brief
		local playerBrief = itemData.playerBrief
		local uid
		local data = {IsHero = true}
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
			data.Level = playerBrief.level
			data.ProfessionIcon = jobIcon
			data.HeadIcon = playerBrief.headPortraitName
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
		itemLua.select:SetActive(false)

		self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickGuildPeopleItem, uid)
	end
	return item
end

function UIGuildInfoView:OnBeginLoad(isLeft)
	-- 发送获得后续公会玩家信息
	local errorCode = self.controller:SendGetGuildMemberInfoReq()
	if errorCode ~= 0 then
		if errorCode == 1 then
			self:RefreshMemberInfoView()
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end

function UIGuildInfoView:RefreshBriefView()
	local brief = self.controller:GetGuildBriefData()
	local itemLua = self.guildBadgeItem
	itemLua.badge.image.enabled = false
	itemLua.badge.image.sprite = nil
	CommonUtil.LoadIcon(self, brief and brief.badgeResPath or nil, function(sprite)
		itemLua.badge.image.enabled = true
		itemLua.badge.image.sprite = sprite
	end, itemLua, 'BadgeIcon')
	if brief then
		self.lvTxt.text.text = tostring(brief.level)
		self.nameTxt.text.text = tostring(brief.name)
		self.idTxt.text.text = tostring(brief.id)
		self.activeTxt.text.text = tostring(brief.active)
	else
		self.lvTxt.text.text = '-'
		self.nameTxt.text.text = '-'
		self.idTxt.text.text = '-'
		self.activeTxt.text.text = '-'
	end
end

function UIGuildInfoView:RefreshMoreInfoView()
	local moreInfo = self.controller:GetGuildMoreInfoData()
	if not moreInfo then
		self.noticeTxt.text.text = ''
		self.enterLimitTxt.text.text = '-'
		self.peopleTxt.text.text = '-'
		self.verifyTypeTxt.text.text = '-'
		return
	end
	if not moreInfo.recruitNotice or moreInfo.recruitNotice == '' then
		self.noticeTxt.text.text = string.formatbykey('GuildInfo_033')
	else
		self.noticeTxt.text.text = tostring(moreInfo.recruitNotice)
	end
	self.enterLimitTxt.text.text = tostring((moreInfo.recuritLevel or 999))
	self.peopleTxt.text.text = tostring(self.controller:GetGuildMemberNum()) .. '/' .. tostring(self.controller:GetGuildMemberLimit())
	self.verifyTypeTxt.text.text = self:GetGuildVerifyTypeStr(moreInfo.recuritType)
end

function UIGuildInfoView:RefreshMemberInfoView()
	local dataLength = self.controller:GetGuildMemberNum()
	local validLength = self.controller:GetValidMemberNum()
	self.loadStatusLoopListCtr:OnAllLoaded()
	self.loadStatusLoopListCtr:RefreshMaxDataLength(dataLength)
	self.loadStatusLoopListCtr:RefreshDataLength(validLength)
end

function UIGuildInfoView:RefreshApplyBtn()
	local moreInfo = self.controller:GetGuildMoreInfoData()
	if not moreInfo then
		self.btnEnter:SetActive(false)
		self.btnCancel:SetActive(false)
		self.appliedTag:SetActive(false)
		return
	end
	self.btnEnter.text.uILocalizeScript:SetContent(moreInfo.recuritType == Enum.GuildEnterVerifyType.NotVerify and 'BtnJoin' or 'BtnApplyJoin')
	local apply = not self.controller:IsInGuild() and self.controller:GetIsSubmitApply()
	self.btnEnter.button.interactable = (moreInfo.recuritType ~= Enum.GuildEnterVerifyType.Ban)
	self.btnEnter:SetActive(not apply)
	self.btnCancel:SetActive(apply)
	self.appliedTag:SetActive(apply)
end

function UIGuildInfoView:GetGuildVerifyTypeStr(VerifyType)
	if VerifyType == Enum.GuildEnterVerifyType.NotVerify then
		return string.formatbykey('GuildEnterType_01')
	elseif VerifyType == Enum.GuildEnterVerifyType.NeedVerify then
		return string.formatbykey('GuildEnterType_02')
	else
		return string.formatbykey('GuildEnterType_03')
	end
end

return UIGuildInfoView

