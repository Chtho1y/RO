local UIHundredDojoLogView = require("UIHundredDojo/UIHundredDojoLogView_Generate")
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')

function UIHundredDojoLogView:OnAwake(data)
	self.controller = require("UIHundredDojo/UIHundredDojoLogCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIHundredDojoLogView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HUNDRED_DOJO_LOG_CHANGED, self, self.OnLogChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HUNDRED_DOJO_QUERY_AREA_DATA_COMPLETED, self, self.OnQueryCompleted)
end

function UIHundredDojoLogView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIHundredDojoLogView:Init()
	self.textTitle.uILocalizeScript:SetContent('BtnChallengeLog')
	-- self.controller:ClearLogState()
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

function UIHundredDojoLogView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIHundredDojoLogView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCancelBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCancelBtn)
end

function UIHundredDojoLogView:OnHide()

end

function UIHundredDojoLogView:OnShow(data)
	self.controller:SetData(data)

end

function UIHundredDojoLogView:OnClose()
end

function UIHundredDojoLogView:OnDispose()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	self.controller:OnDispose()
end

function UIHundredDojoLogView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.changeList.loopListView.ScrollRect.enabled = true
end

function UIHundredDojoLogView:OnLogChanged(changed, startChanged, endChanged)
	self.controller:RefreshLogData()
	self:RefreshList(startChanged)
end

function UIHundredDojoLogView:OnQueryCompleted(uid, areaId)
	if self.battleUid ~= uid then
		return
	end
	if not areaId then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('HundredDojoLogView1')
		self:OnClickCancelBtn()
		return
	end
	local areaCfgData = ManagerContainer.CfgMgr:GetHundredDojoCfgById(areaId)
	if not areaCfgData then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('HundredDojoLogView1')
		self:OnClickCancelBtn()
		return
	end
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HUNDRED_DOJO_LOCATION_AREA_CHANGED, uid, areaId)
	self:OnClickCancelBtn()
end

function UIHundredDojoLogView:OnClickCancelBtn()
	self:UIClose()
end

function UIHundredDojoLogView:OnClickFightBtn(btn, params)
	local itemData = params[0]
	if not itemData then return end
	self.battleUid = itemData.uid
	if not self.battleUid then
		return
	end
	local errorCode = self.controller:SendGetAreaInfoReq(self.battleUid)
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIHundredDojoLogView:GetItemByIndex(loopListView, idx, dataIdx)
	local itemData = self.controller:GetLogById(dataIdx)
	if not itemData then return nil end
	local item = loopListView:NewListViewItem('HundredDojoLogItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'HundredDojoLogItem', item.gameObject)
	if itemLua then
		itemLua.fightBtn:SetActive(false)
		local logType = itemData.type
		local time = itemData.time
		local areaCfgData = nil
		if itemData.areaId then
			areaCfgData = ManagerContainer.CfgMgr:GetHundredDojoCfgById(itemData.areaId)
		end
		itemLua.timeTxt.text.text = ManagerContainer.LuaTimerMgr:ParseTimeStamp2Format(time, '%Y-%m-%d     %H:%M:%S')
		if logType == 1 then
			itemLua.contentTxt.text.text = string.formatbykey('HundredDojoLog_1', tostring(areaCfgData and areaCfgData.Name or ''), itemData.playerName, itemData.guildName)
		elseif logType == 2 then
			if itemData.state then
				itemLua.contentTxt.text.text = string.formatbykey('HundredDojoLog_2', tostring(areaCfgData and areaCfgData.Name or ''), itemData.playerName, itemData.guildName)
			else
				itemLua.contentTxt.text.text = string.formatbykey('HundredDojoLog_3', tostring(areaCfgData and areaCfgData.Name or ''), itemData.playerName, itemData.guildName)
			end
		elseif logType == 3 then
			if itemData.state then
				if itemData.guildName and itemData.guildName ~= '' then
					itemLua.contentTxt.text.text = string.formatbykey('HundredDojoLog_4', tostring(areaCfgData and areaCfgData.Name or ''), itemData.playerName, itemData.guildName)
				else
					itemLua.contentTxt.text.text = string.formatbykey('HundredDojoLog_5', tostring(areaCfgData and areaCfgData.Name or ''), itemData.playerName, itemData.guildName)
				end
			else
				if itemData.guildName and itemData.guildName ~= '' then
					itemLua.contentTxt.text.text = string.formatbykey('HundredDojoLog_6', tostring(areaCfgData and areaCfgData.Name or ''), itemData.playerName, itemData.guildName)
				else
					itemLua.contentTxt.text.text = string.formatbykey('HundredDojoLog_7', tostring(areaCfgData and areaCfgData.Name or ''), itemData.playerName, itemData.guildName)
				end
			end
		elseif logType == 4 then
			if itemData.state then
				if itemData.guildName and itemData.guildName ~= '' then
					itemLua.contentTxt.text.text = string.formatbykey('HundredDojoLog_8', tostring(areaCfgData and areaCfgData.Name or ''), itemData.playerName, itemData.guildName)
				else
					itemLua.contentTxt.text.text = string.formatbykey('HundredDojoLog_9', tostring(areaCfgData and areaCfgData.Name or ''), itemData.playerName, itemData.guildName)
				end
				self.uiBase:AddButtonUniqueEventListener(itemLua.fightBtn.button, self, self.OnClickFightBtn, itemData)
				itemLua.fightBtn:SetActive(true)
			else
				if itemData.guildName and itemData.guildName ~= '' then
					itemLua.contentTxt.text.text = string.formatbykey('HundredDojoLog_10', tostring(areaCfgData and areaCfgData.Name or ''), itemData.playerName, itemData.guildName)
				else
					itemLua.contentTxt.text.text = string.formatbykey('HundredDojoLog_11', tostring(areaCfgData and areaCfgData.Name or ''), itemData.playerName, itemData.guildName)
				end
			end
		elseif logType == 5 then
			local rewardTime = itemData.rewardTime
			if itemData.rewardTime then
				if type(rewardTime) == 'userdata' then
					rewardTime = #rewardTime
				end
			else
				rewardTime = 0
			end
			itemLua.contentTxt.text.text = string.formatbykey('HundredDojoLog_12', tostring(areaCfgData and areaCfgData.Name or ''), DateTimeUtil.convertSeconds2TimeStr1(rewardTime, true, false, true))
		else
			itemLua.contentTxt.text.text = ''
		end
	end
	ManagerContainer.LuaUIMgr:ForceRebuildLayoutImmediate(item.CachedRectTransform)
	return item
end

function UIHundredDojoLogView:OnBeginLoad(isBegin)
	local errorCode = self.controller:SendGetLogInfoReq(isBegin)
	if errorCode ~= 0 then
		self:RefreshList(isBegin)
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIHundredDojoLogView:RefreshList(isBegin)
	local whole = self.controller:GetLogWhole()
	local dataLength = self.controller:GetLogNum()
	self.loadStatusLoopListCtr:SetHasBegin(true)
	self.loadStatusLoopListCtr:OnAllLoaded()
	self.loadStatusLoopListCtr:RefreshMaxDataLength((whole and dataLength or (dataLength + 1)))
	self.loadStatusLoopListCtr:RefreshDataLength(dataLength)
end

return UIHundredDojoLogView

