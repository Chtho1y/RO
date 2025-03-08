local UIVoyageLogView = require("UIHundredDojo/UIHundredDojoLogView_Generate")
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')

function UIVoyageLogView:OnAwake(data)
	self.controller = require("UIVoyage/UIVoyageLogCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIVoyageLogView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VOYAGE_LOG_CHANGED, self, self.OnLogChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VOYAGE_CHECK_AIRSHIP_CHANGED, self, self.OnQueryCompleted)
end

function UIVoyageLogView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIVoyageLogView:Init()
	self.textTitle.uILocalizeScript:SetContent('VoyageLog')
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

function UIVoyageLogView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIVoyageLogView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCancelBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCancelBtn)
end

function UIVoyageLogView:OnHide()

end

function UIVoyageLogView:OnShow(data)
	self.controller:SetData(data)

end

function UIVoyageLogView:OnClose()
end

function UIVoyageLogView:OnDispose()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	self.battleUid = nil
	self.controller:OnDispose()
end

function UIVoyageLogView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.changeList.loopListView.ScrollRect.enabled = true
end

function UIVoyageLogView:OnLogChanged(changed, startChanged, endChanged)
	self.controller:RefreshLogData()
	self:RefreshList(startChanged)
end

function UIVoyageLogView:OnQueryCompleted(uid)
	if self.battleUid ~= uid then
		return
	end
	self.battleUid = nil
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.VOYAGE_LOCATION_CHANGED, uid)
	self:OnClickCancelBtn()
end

function UIVoyageLogView:OnClickCancelBtn()
	self:UIClose()
end

function UIVoyageLogView:OnClickFightBtn(btn, params)
	local itemData = params[0]
	if not itemData then return end
	self.battleUid = itemData.target_player_uid
	if not self.battleUid then
		return
	end
	local errorCode = self.controller:SendCheckInfoReq(self.battleUid)
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIVoyageLogView:GetItemByIndex(loopListView, idx, dataIdx)
	local itemData = self.controller:GetLogById(dataIdx)
	if not itemData then return nil end
	local item = loopListView:NewListViewItem('HundredDojoLogItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'HundredDojoLogItem', item.gameObject)
	if itemLua then
		itemLua.fightBtn:SetActive(false)
		local logType = itemData.type
		local time = itemData.record_time
		itemLua.timeTxt.text.text = ManagerContainer.LuaTimerMgr:ParseTimeStamp2Format(time, '%Y-%m-%d     %H:%M:%S')
		if logType == 1 then
			itemLua.contentTxt.text.text = string.formatbykey('VoyageLog01', CommonUtil.GetVaildNickName(itemData.target_player_name), self:GetItemDesc(itemData.item_list))
			self.uiBase:AddButtonUniqueEventListener(itemLua.fightBtn.button, self, self.OnClickFightBtn, itemData)
			itemLua.fightBtn:SetActive(true)
		elseif logType == 2 then
			itemLua.contentTxt.text.text = string.formatbykey('VoyageLog02', CommonUtil.GetVaildNickName(itemData.target_player_name), self:GetItemDesc(itemData.item_list))
		elseif logType == 3 then
			itemLua.contentTxt.text.text = string.formatbykey('VoyageLog03', CommonUtil.GetVaildNickName(itemData.target_player_name))
		else
			itemLua.contentTxt.text.text = ''
		end
	end
	ManagerContainer.LuaUIMgr:ForceRebuildLayoutImmediate(item.CachedRectTransform)
	return item
end

function UIVoyageLogView:OnBeginLoad(isBegin)
	local errorCode = self.controller:SendGetLogInfoReq(isBegin)
	if errorCode ~= 0 then
		self:RefreshList(isBegin)
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIVoyageLogView:RefreshList(isBegin)
	local whole = self.controller:GetLogWhole()
	local dataLength = self.controller:GetLogNum()
	self.loadStatusLoopListCtr:SetHasBegin(true)
	self.loadStatusLoopListCtr:OnAllLoaded()
	self.loadStatusLoopListCtr:RefreshMaxDataLength((whole and dataLength or (dataLength + 1)))
	self.loadStatusLoopListCtr:RefreshDataLength(dataLength)
end

function UIVoyageLogView:GetItemDesc(rewards)
	if not rewards then
		return ''
	end
	local reward
	local cfgId
	local num
	local itemCfgData
	local desc = ''
	for i = 1, #rewards do
		reward = rewards[i]
		cfgId = reward.key
		num = reward.value
		itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
		if itemCfgData then
			if desc then
				desc = desc .. ' ' .. string.formatbykey(itemCfgData.Name) .. '*' .. tostring(num)
			else
				desc = string.formatbykey(itemCfgData.Name) .. '*' .. tostring(num)
			end
		end
	end
	return desc
end

return UIVoyageLogView

