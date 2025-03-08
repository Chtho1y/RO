local UIGuildHuntLogView = require("UIGuild/UIGuildHuntLogView_Generate")
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')

function UIGuildHuntLogView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildHuntLogCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildHuntLogView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_HUNT_BOSS_BATTLE_LOG_CHANGED, self, self.OnGuildHuntBossBattleLogChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_DISBAND_SUCCESS, self, self.OnGuildDisBandSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_QUIT_SUCCESS, self, self.OnGuildQuitSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_KICKOUT_SUCCESS, self, self.OnGuildKickoutSuccess)
end

function UIGuildHuntLogView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildHuntLogView:Init()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	local logMaxNum = self.controller:GetLogMaxNum()
	self:SetListShowStatus((0 ~= logMaxNum))
	self.loadStatusLoopListCtr = LoadStatusLoopListCtr:new(self, self.damageList.loopListView, 0, logMaxNum,
															false, 'LoadingItem', Enum.ListLoadingStatus.None,
															true, 'LoadingItem', Enum.ListLoadingStatus.WaitLoad,
															self.GetItemByIndex,nil, self.OnBeginLoad)

	self.damageList.loopListView.ScrollRect.enabled = false
	local errorCode = self.controller:SendGuildHuntBossLogReq(true)
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildHuntLogView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuildHuntLogView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCancelBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCancelBtn)
end

function UIGuildHuntLogView:OnHide()

end

function UIGuildHuntLogView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildHuntLogView:OnClose()
end

function UIGuildHuntLogView:OnDispose()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	self.controller:OnDispose()
end

function UIGuildHuntLogView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.damageList.loopListView.ScrollRect.enabled = true
end

function UIGuildHuntLogView:OnGuildDisBandSuccess()
	self:UIClose()
end

function UIGuildHuntLogView:OnGuildQuitSuccess()
	self:UIClose()
end

function UIGuildHuntLogView:OnGuildKickoutSuccess()
	self:UIClose()
end

function UIGuildHuntLogView:OnGuildHuntBossBattleLogChanged(bossId)
	if self.controller:GetBossId() ~= bossId then return end
	self:RefreshList()
end

function UIGuildHuntLogView:OnClickCancelBtn()
	self:UIClose()
end

function UIGuildHuntLogView:OnClickHeadItem(_, params)
	local uid = params[0]
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

function UIGuildHuntLogView:GetItemByIndex(loopListView, idx, dataIdx)
	local itemData = self.controller:GetLogById(dataIdx)
	if not itemData then return nil end
	local item = loopListView:NewListViewItem('GuildPeopleHurtItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'GuildPeopleHurtItem', item.gameObject)
	if itemLua then
		local playerBrief = itemData.playerBrief
		local data = {}
		local uid
		local headFrameId = nil
		if playerBrief then
			uid = playerBrief.uid
			headFrameId = playerBrief.headFrame
			if int64.equals(uid, ManagerContainer.DataMgr.UserData:GetUserId()) then
				headFrameId = ManagerContainer.DataMgr.UserData:GetHeadFrameId()
			end
			local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(playerBrief.configId)
			local jobIcon = ''
			if jobCfg then
				jobIcon = jobCfg.JobIcon
			end
			
			data = {Level = playerBrief.level, ProfessionIcon = jobIcon, HeadIcon = playerBrief.headPortraitName, IsHero = true}
			itemLua.nameTxt.text.text = tostring(playerBrief.nickName)
		else
			itemLua.nameTxt.text.text = ''
		end
		CommonUtil.SetPlayerHeadAndFrame(self, itemLua.headItem, data, false, headFrameId, self, self.OnClickHeadItem, uid)
		itemLua.damageTxt.text.text = tostring(itemData.damage)
	end
	ManagerContainer.LuaUIMgr:ForceRebuildLayoutImmediate(item.CachedRectTransform)
	return item
end

function UIGuildHuntLogView:OnBeginLoad(isBegin)
	local errorCode = self.controller:SendGuildHuntBossLogReq(isBegin)
	if errorCode ~= 0 then
		self:RefreshList()
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildHuntLogView:RefreshList()
	local whole = self.controller:GetLogWhole()
	local dataLength = self.controller:GetLogNum()

	self.loadStatusLoopListCtr:SetHasBegin(true)
	self.loadStatusLoopListCtr:OnAllLoaded()
	self.loadStatusLoopListCtr:RefreshMaxDataLength((whole and dataLength or (dataLength + 1)))
	self.loadStatusLoopListCtr:RefreshDataLength(dataLength)

	self:SetListShowStatus(not (whole and dataLength == 0))
end

function UIGuildHuntLogView:SetListShowStatus(state)
	self.emptyTips:SetActive(not state)
	self.damageList:SetActive(state)
end

return UIGuildHuntLogView

