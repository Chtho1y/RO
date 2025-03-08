local UIGuildAuditApplyView = require("UIGuild/UIGuildAuditApplyView_Generate")

local HeadItemCtr = require('Common/HeadItemCtr')

function UIGuildAuditApplyView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildAuditApplyCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildAuditApplyView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_GET_AUDIT_APPLY_BASE_LIST_CHANGED, self, self.OnGetAuditApplyBaseListChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_GET_AUDIT_APPLY_LIST_CHANGED, self, self.OnGetAuditApplyListChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_GET_OTHER_PLAYER_BRIEF_INFO_ACK, self, self.OnGetOtherPlayerBriefInfoAck)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_DISBAND_SUCCESS, self, self.OnGuildDisBandSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_QUIT_SUCCESS, self, self.OnGuildQuitSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_KICKOUT_SUCCESS, self, self.OnGuildKickoutSuccess)
end

function UIGuildAuditApplyView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildAuditApplyView:Init()
	self.peopleList.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self:RefreshPeople()
	self:RefreshList()

	local errorCode = self.controller:SendGetAuditApplyListReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildAuditApplyView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuildAuditApplyView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)

	self.uiBase:AddButtonUniqueEventListener(self.allRefuseBtn.button, self, self.OnClickAllRefuseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.allAllowBtn.button, self, self.OnClickAllAllowBtn)
end

function UIGuildAuditApplyView:OnHide()

end

function UIGuildAuditApplyView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildAuditApplyView:OnClose()
end

function UIGuildAuditApplyView:OnDispose()
	self.peopleList.loopGridView:Dispose()
	self.controller:OnDispose()
end

function UIGuildAuditApplyView:OnGetAuditApplyBaseListChanged()
	local isHasReq = self.controller:SendGetAuditApplyInfoListReq()
	if not isHasReq then
		self:RefreshPeople()
		self:RefreshList()
	end
end

function UIGuildAuditApplyView:OnGetAuditApplyListChanged()
	self:RefreshPeople()
	self:RefreshList()
end

function UIGuildAuditApplyView:OnGetOtherPlayerBriefInfoAck(data)
	self.controller:SetAuditApplyPlayBrief(data.brief_info)
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.GuildAuditApply, self.controller:GetIsHasApply())
	local isHasReq = self.controller:SendGetAuditApplyInfoListReq()
	if not isHasReq then
		self:RefreshPeople()
		self:RefreshList()
	end
end

function UIGuildAuditApplyView:OnGuildDisBandSuccess()
	self:UIClose()
end

function UIGuildAuditApplyView:OnGuildQuitSuccess()
	self:UIClose()
end

function UIGuildAuditApplyView:OnGuildKickoutSuccess()
	self:UIClose()
end


function UIGuildAuditApplyView:OnClickCloseBtn()
	self:UIClose()
end

function UIGuildAuditApplyView:OnClickAllRefuseBtn()
	local errorCode = self.controller:SendAllRefuseReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildAuditApplyView:OnClickAllAllowBtn()
	local errorCode = self.controller:SendAllAllowReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildAuditApplyView:OnClickPlayerHead(btn, param)
	local uid = param[0]
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

function UIGuildAuditApplyView:OnClickRefuseBtn(btn, param)
	local uid = param[0]
	local errorCode = self.controller:SendRefuseReq(uid)
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildAuditApplyView:OnClickAllowBtn(btn, param)
	local uid = param[0]
	local errorCode = self.controller:SendAllowReq(uid)
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildAuditApplyView:RefreshPeople()
	local curNum = self.controller:GetGuildMemberNum()
	local limitNum = self.controller:GetGuildMemberLimit()
	self.peopleNum.text.text = tostring(curNum) .. '/' .. tostring(limitNum)
end

function UIGuildAuditApplyView:RefreshList()
	local length = self.controller:GetAuditApplyNum()
	self.bottom:SetActive(length > 0)
	if length <= 0 then
		self.bottom:SetActive(false)
		self.peopleList:SetActive(false)
		self.emptyTips:SetActive(true)
		return
	end
	self.bottom:SetActive(true)
	self.peopleList:SetActive(true)
	self.emptyTips:SetActive(false)
	self.peopleList.loopGridView:RefreshListByIndex(length, 0)
end

function UIGuildAuditApplyView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local showData = self.controller:GetNextAuditApplyById(itemIndex)
	local item = nil
	if showData then
		item = gridView:NewListViewItem('GuildPeopleApplyItem')
		local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'GuildPeopleApplyItem', item.gameObject)
		local playerBrief = showData.playerBrief
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
			itemLua.onlineTxt.text.text = CommonUtil.GetOnlineStatus(playerBrief.onlineState, playerBrief.onlineTime)
		else
			itemLua.nameTxt.text.text = ''
			itemLua.atkTxt.text.text = ''
			itemLua.onlineTxt.text.text = ''
		end
		CommonUtil.SetPlayerHeadAndFrame(self, itemLua.headItem, data, false, headFrameId, self, self.OnClickPlayerHead, uid)
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

		self.uiBase:AddButtonUniqueEventListener(itemLua.refuseBtn.button, self, self.OnClickRefuseBtn, uid)
		self.uiBase:AddButtonUniqueEventListener(itemLua.allowBtn.button, self, self.OnClickAllowBtn, uid)
	end
	return item
end

return UIGuildAuditApplyView

