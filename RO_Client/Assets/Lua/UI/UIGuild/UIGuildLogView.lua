local UIGuildLogView = require("UIGuild/UIGuildLogView_Generate")
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')

function UIGuildLogView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildLogCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildLogView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_LOG_CHANGED, self, self.OnGuildLogChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_DISBAND_SUCCESS, self, self.OnGuildDisBandSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_QUIT_SUCCESS, self, self.OnGuildQuitSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_KICKOUT_SUCCESS, self, self.OnGuildKickoutSuccess)
end

function UIGuildLogView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildLogView:Init()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	local logMaxNum = self.controller:GetLogMaxNum()
	self.loadStatusLoopListCtr = LoadStatusLoopListCtr:new(self, self.changeList.loopListView, 0, logMaxNum,
															false, 'LoadingItem', Enum.ListLoadingStatus.None,
															true, 'LoadingItem', Enum.ListLoadingStatus.WaitLoad,
															self.GetItemByIndex,nil, self.OnBeginLoad)

	self.changeList.loopListView.ScrollRect.enabled = false
	local errorCode = self.controller:SendGetGuildLogInfoReq(true)
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildLogView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuildLogView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCancelBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCancelBtn)
end

function UIGuildLogView:OnHide()

end

function UIGuildLogView:OnShow(data)
	self.controller:SetData(data)
end

function UIGuildLogView:OnClose()
end

function UIGuildLogView:OnDispose()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	self.controller:OnDispose()
end

function UIGuildLogView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.changeList.loopListView.ScrollRect.enabled = true
end

function UIGuildLogView:OnGuildDisBandSuccess()
	self:UIClose()
end

function UIGuildLogView:OnGuildQuitSuccess()
	self:UIClose()
end

function UIGuildLogView:OnGuildKickoutSuccess()
	self:UIClose()
end

function UIGuildLogView:OnGuildLogChanged(changed, startChanged, endChanged)
	self:RefreshList(startChanged)
end

function UIGuildLogView:OnClickCancelBtn()
	self:UIClose()
end

function UIGuildLogView:GetItemByIndex(loopListView, idx, dataIdx)
	local itemData = self.controller:GetLogById(dataIdx)
	if not itemData then return nil end
	local item = loopListView:NewListViewItem('GuildLogItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'GuildLogItem', item.gameObject)
	if itemLua then
		local guildLogType = itemData.type
		local time = itemData.time
		itemLua.timeTxt.text.text = ManagerContainer.LuaTimerMgr:ParseTimeStamp2Format(time, '%Y-%m-%d     %H:%M:%S')
		if guildLogType == Enum.GuildLogType.AuditEnter then
			itemLua.contentTxt.text.text = string.formatbykey('GuildLog_002', CommonUtil.GetGuildPostStr(itemData.opPost), tostring(itemData.opName), CommonUtil.GetGuildPostStr(itemData.beOpPost), tostring(itemData.beOpName))
		elseif guildLogType == Enum.GuildLogType.Kickout then
			itemLua.contentTxt.text.text = string.formatbykey('GuildLog_003', CommonUtil.GetGuildPostStr(itemData.opPost), tostring(itemData.opName), CommonUtil.GetGuildPostStr(itemData.beOpPost), tostring(itemData.beOpName))
		elseif guildLogType == Enum.GuildLogType.Exit then
			itemLua.contentTxt.text.text = string.formatbykey('GuildLog_004', CommonUtil.GetGuildPostStr(itemData.opPost), tostring(itemData.opName), CommonUtil.GetGuildPostStr(itemData.beOpPost), tostring(itemData.beOpName))
		elseif guildLogType == Enum.GuildLogType.UpVicePresident then
			itemLua.contentTxt.text.text = string.formatbykey('GuildLog_005', CommonUtil.GetGuildPostStr(itemData.opPost), tostring(itemData.opName), CommonUtil.GetGuildPostStr(itemData.beOpPost), tostring(itemData.beOpName))
		elseif guildLogType == Enum.GuildLogType.DownMember then
			itemLua.contentTxt.text.text = string.formatbykey('GuildLog_009', CommonUtil.GetGuildPostStr(itemData.opPost), tostring(itemData.opName), CommonUtil.GetGuildPostStr(itemData.beOpPost), tostring(itemData.beOpName))
		elseif guildLogType == Enum.GuildLogType.UpPresident then
			itemLua.contentTxt.text.text = string.formatbykey('GuildLog_006', CommonUtil.GetGuildPostStr(itemData.opPost), tostring(itemData.opName), CommonUtil.GetGuildPostStr(itemData.beOpPost), tostring(itemData.beOpName))
		elseif guildLogType == Enum.GuildLogType.Enter then
			itemLua.contentTxt.text.text = string.formatbykey('GuildLog_001', CommonUtil.GetGuildPostStr(itemData.opPost), tostring(itemData.opName), CommonUtil.GetGuildPostStr(itemData.beOpPost), tostring(itemData.beOpName))
		elseif guildLogType == Enum.GuildLogType.EliteBoss then
			itemLua.contentTxt.text.text = string.formatbykey('GuildLog_010', CommonUtil.GetGuildPostStr(itemData.opPost), tostring(itemData.opName), CommonUtil.GetGuildPostStr(itemData.beOpPost), tostring(itemData.beOpName))
		elseif guildLogType == Enum.GuildLogType.AutoDownPresident then
			itemLua.contentTxt.text.text = string.formatbykey('GuildLog_011', CommonUtil.GetGuildPostStr(itemData.opPost), tostring(itemData.opName), CommonUtil.GetGuildPostStr(itemData.beOpPost), tostring(itemData.beOpName))
		else
			itemLua.contentTxt.text.text = ''
		end
	end
	ManagerContainer.LuaUIMgr:ForceRebuildLayoutImmediate(item.CachedRectTransform)
	return item
end

function UIGuildLogView:OnBeginLoad(isBegin)
	local errorCode = self.controller:SendGetGuildLogInfoReq(isBegin)
	if errorCode ~= 0 then
		self:RefreshList(isBegin)
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildLogView:RefreshList(isBegin)
	local whole = self.controller:GetLogWhole()
	local dataLength = self.controller:GetLogNum()
	self.loadStatusLoopListCtr:SetHasBegin(true)
	self.loadStatusLoopListCtr:OnAllLoaded()
	self.loadStatusLoopListCtr:RefreshMaxDataLength((whole and dataLength or (dataLength + 1)))
	self.loadStatusLoopListCtr:RefreshDataLength(dataLength)
end

return UIGuildLogView

