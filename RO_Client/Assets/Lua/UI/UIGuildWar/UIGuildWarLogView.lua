local UIGuildWarLogView = require("UIHundredDojo/UIHundredDojoLogView_Generate")
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')

function UIGuildWarLogView:OnAwake(data)
	self.controller = require("UIGuildWar/UIGuildWarLogCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildWarLogView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_BATTLE_LOG_DATA_CHANGED, self, self.OnLogChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_OPEN_STATE_CHANGED, self, self.OnOpenStateChanged)
end

function UIGuildWarLogView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildWarLogView:Init()
	self.textTitle.uILocalizeScript:SetContent('GuildWarBattle12')
	self.controller:InitData()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	local logMaxNum = 0
	if self.controller:GetLogWhole() then
		logMaxNum = self.controller:GetLogNum()
	else
		logMaxNum = self.controller:GetLogMaxNum()
	end
	self.loadStatusLoopListCtr = LoadStatusLoopListCtr:new(self, self.changeList.loopListView, 0, logMaxNum,
															false, 'LoadingItem', Enum.ListLoadingStatus.None,
															true, 'LoadingItem', Enum.ListLoadingStatus.WaitLoad,
															self.GetItemByIndex,nil, self.OnBeginLoad)
	self.changeList.loopListView.ScrollRect.enabled = false
	local errorCode = self.controller:SendGetLogInfoReq(true)
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildWarLogView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuildWarLogView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCancelBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCancelBtn)
end

function UIGuildWarLogView:OnHide()

end

function UIGuildWarLogView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildWarLogView:OnClose()
end

function UIGuildWarLogView:OnDispose()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	self.controller:OnDispose()
end

function UIGuildWarLogView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.changeList.loopListView.ScrollRect.enabled = true
end

function UIGuildWarLogView:OnLogChanged(changed, startChanged, endChanged)
	self.controller:RefreshLogData()
	self:RefreshList(startChanged)
end

function UIGuildWarLogView:OnOpenStateChanged(isOpen)
	if isOpen then return end
	self:UIClose()
end

function UIGuildWarLogView:OnClickCancelBtn()
	self:UIClose()
end

function UIGuildWarLogView:GetItemByIndex(loopListView, idx, dataIdx)
	local itemData = self.controller:GetLogById(dataIdx)
	if not itemData then return nil end
	local item = loopListView:NewListViewItem('HundredDojoLogItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'HundredDojoLogItem', item.gameObject)
	if itemLua then
		itemLua.fightBtn:SetActive(false)
		local logType = itemData.type
		local time = itemData.time
		itemLua.timeTxt.text.text = ManagerContainer.LuaTimerMgr:ParseTimeStamp2Format(time, '%Y-%m-%d     %H:%M:%S')
		-- local areaCfgData = nil
		-- if itemData.areaId then
		-- 	areaCfgData = ManagerContainer.CfgMgr:GetGuildWarDojoCfgById(itemData.areaId)
		-- end
		-- local areaName = string.formatbykey(areaCfgData and areaCfgData.Name or '')
		local guildName, guildColor = self.controller:GetGuildNameAndColor(itemData.guildId)
		local challengeGuildName, challengeGuildColor = self.controller:GetGuildNameAndColor(itemData.challengeGuildId)
		if logType == 1 then
			if itemData.winSteak > 0 then
				itemLua.contentTxt.text.text = string.formatbykey('GuildWarBattle16', guildName, itemData.playerName, challengeGuildName, itemData.challengePlayerName, tostring(itemData.winSteak), guildColor, challengeGuildColor)
			else
				itemLua.contentTxt.text.text = string.formatbykey('GuildWarBattle18', guildName, itemData.playerName, challengeGuildName, itemData.challengePlayerName, tostring(itemData.winSteak), guildColor, challengeGuildColor)
			end
		elseif logType == 2 then
			if itemData.winSteak > 0 then
				itemLua.contentTxt.text.text = string.formatbykey('GuildWarBattle22', guildName, itemData.playerName, challengeGuildName, itemData.challengePlayerName, tostring(itemData.winSteak), guildColor, challengeGuildColor)
			else
				itemLua.contentTxt.text.text = string.formatbykey('GuildWarBattle17', guildName, itemData.playerName, challengeGuildName, itemData.challengePlayerName, tostring(itemData.winSteak), guildColor, challengeGuildColor)
			end
		else
			itemLua.contentTxt.text.text = ''
		end
	end
	ManagerContainer.LuaUIMgr:ForceRebuildLayoutImmediate(item.CachedRectTransform)
	return item
end

function UIGuildWarLogView:OnBeginLoad(isBegin)
	local errorCode = self.controller:SendGetLogInfoReq(isBegin)
	if errorCode ~= 0 then
		self:RefreshList(isBegin)
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildWarLogView:RefreshList(isBegin)
	local whole = self.controller:GetLogWhole()
	local dataLength = self.controller:GetLogNum()
	self.loadStatusLoopListCtr:SetHasBegin(true)
	self.loadStatusLoopListCtr:OnAllLoaded()
	self.loadStatusLoopListCtr:RefreshMaxDataLength((whole and dataLength or (dataLength + 1)))
	self.loadStatusLoopListCtr:RefreshDataLength(dataLength)
end

return UIGuildWarLogView

