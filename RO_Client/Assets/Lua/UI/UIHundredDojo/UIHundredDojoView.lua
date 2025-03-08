local UIHundredDojoView = require("UIHundredDojo/UIHundredDojoView_Generate")
local ColorExtension = require('ColorExtension')

local SloganState = {
	Idle = 1,
	CheckOpening = 2,
	Opening = 3,
	Showing = 4,
	Hiding = 5,
}


function UIHundredDojoView:OnAwake(data)
	self.controller = require("UIHundredDojo/UIHundredDojoCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIHundredDojoView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HUNDRED_DOJO_CHALLENGE_NUM_CHANGED, self, self.OnChallengeNumChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HUNDRED_DOJO_BASE_TIME_CHANGED, self, self.OnBaseTimeChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HUNDRED_DOJO_SELF_AREA_DATA_CHANGED, self, self.OnSelfAreaDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HUNDRED_DOJO_OTHER_AREA_DATA_CHANGED, self, self.OnOtherAreaDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HUNDRED_DOJO_GET_REWARD_COMPLETED, self, self.OnGetRewardCompleted)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HUNDRED_DOJO_LOCATION_AREA_CHANGED, self, self.OnLocationAreaChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HUNDRED_DOJO_SLOGAN_CHANGED, self, self.OnSloganChanged)
end

function UIHundredDojoView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIHundredDojoView:Init()
	self.controller:InitData()
	local initParam = SuperScrollView.LoopGridViewInitParam()
	initParam.mSmoothDumpRate = 0.05
	self.scrollView.loopGridView.ItemSnapEnable = false
	self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, function(gridView, itemIndex, row, column, loopGridViewItem)
		self:RecycleItem(gridView, itemIndex, row, column, loopGridViewItem)
	end, nil, initParam)
	self.treasureTip:SetActive(self.controller:IsTreasureShow())
	self.isInitGrid = nil
	self.alignAreaId = nil
	self:CloseMenu()
	self.controller:SendGetSelfInfoReq()
	self:RefreshChallengeCount()
	self:RefreshBaseReward()
	self:RefreshReward()
	self:RefreshOccupy()
	self:RefreshArea()
	self:OpenSlogan()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIDojoExit)
end

function UIHundredDojoView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	self.scrollView.loopGridView.mOnBeginDragAction = nil
	self.scrollView.loopGridView.mOnEndDragAction = nil
	self.scrollView.loopGridView.mOnSnapItemFinished = nil
end

function UIHundredDojoView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnBack.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnInfo.button, self, self.OnClickInfoBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnLog.button, self, self.OnClickLogBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnAdd.button, self, self.OnClickAddBtn)
	self.uiBase:AddButtonUniqueEventListener(self.rewardBox.button, self, self.OnClickRewardBoxBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnShop.button, self, self.OnClickShopBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnRank.button, self, self.OnClickRankBtn)

	self.uiBase:AddButtonUniqueEventListener(self.menu.AnyBtn.button, self, self.OnClickMenuCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.menu.btnClg.button, self, self.OnClickMenuChallengeBtn)
	self.uiBase:AddButtonUniqueEventListener(self.menu.btnInfo.button, self, self.OnClickMenuInfoBtn)

	self.uiBase:AddButtonUniqueEventListener(self.mySloganitem.button, self, self.OnClickMySloganBtn)

	self.scrollView.loopGridView.mOnBeginDragAction = function(gridView)
		self:OnBeginDragAction(gridView)
	end
	self.scrollView.loopGridView.mOnEndDragAction = function(gridView)
		self:OnEndDragAction(gridView)
	end
	self.scrollView.loopGridView.mOnSnapItemFinished = function(gridView, gridViewItem)
		self:OnSnapItemFinished(gridView, gridViewItem)
	end
end

function UIHundredDojoView:OnHide()
	if self.refreshAreaTimer then
		self.refreshAreaTimer:Stop()
	end
	if self.rewardTimer then
		self.rewardTimer:Stop()
	end
	if self.occupyTimer then
		self.occupyTimer:Stop()
	end
	if self.menuLeftTimer then
		self.menuLeftTimer:Stop()
	end
	self:CloseSlogan()
end

function UIHundredDojoView:OnShow(data)
	self.controller:SetData(data)
	if self.refreshAreaTimer then
		if not self.refreshAreaTimer.running then
			self.refreshAreaTimer:Start()
		end
		if self.refreshAreaTimer.time > 1 then
			self.refreshAreaTimer.time = 1
		end
	end
	if self.rewardTimer then
		self.rewardTimer.func()
	end
	if self.occupyTimer then
		self.occupyTimer:func()
	end
	if self.menuLeftTimer then
		self.menuLeftTimer:func()
	end
	self:OpenSlogan()
end

function UIHundredDojoView:OnClose()
end

function UIHundredDojoView:OnDispose()
	if self.refreshAreaTimer then
		self.refreshAreaTimer:Stop()
		self.refreshAreaTimer = nil
	end
	if self.rewardTimer then
		self.rewardTimer:Stop()
		self.rewardTimer = nil
	end
	if self.occupyTimer then
		self.occupyTimer:Stop()
		self.occupyTimer = nil
	end
	if self.menuLeftTimer then
		self.menuLeftTimer:Stop()
		self.menuLeftTimer = nil
	end
	self.isInitGrid = nil
	self.alignAreaId = nil
	self.scrollView.loopGridView:Dispose()
	self:CloseMenu()
	self:DisposeAreaItemLua()
	self:DisposeSlogan()
	self.controller:OnDispose()
end

function UIHundredDojoView:OnChallengeNumChanged()
	self:RefreshChallengeCount()
end

function UIHundredDojoView:OnBaseTimeChanged()
	self:RefreshReward()
end

function UIHundredDojoView:OnSelfAreaDataChanged(oldId, newId)
	self:RefreshOccupy()
	if not self.isInitGrid then
		self:RefreshArea()
	else
		self:RefreshItemLua(oldId)
		if oldId ~= newId then
			self:RefreshItemLua(newId)
		end
		if self.curSelectAreaId == oldId or self.curSelectAreaId == newId then
			self:OpenMenu(self.curSelectAreaId)
		end
		if self.sloganState == SloganState.Showing or self.sloganState == SloganState.Hiding then
			self:RefreshSelfSlogan()
		end
	end
end

function UIHundredDojoView:OnOtherAreaDataChanged(areaChangeIds)
	if not self.isInitGrid then
		return
	end
	if not areaChangeIds then
		return
	end
	for _, id in pairs(areaChangeIds) do
		self:RefreshItemLua(id)
		if self.curSelectAreaId == id then
			self:OpenMenu(self.curSelectAreaId)
		end
		if self.sloganState == SloganState.Showing or self.sloganState == SloganState.Hiding then
			self:RefreshOtherSloganByAreaId(id)
		end
	end
end

function UIHundredDojoView:OnGetRewardCompleted(rewardNum, rewardList)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIHundredDojoReward, {rewardNum, rewardList})
end

function UIHundredDojoView:OnLocationAreaChanged(uid, areaId)
	if not areaId or areaId <= 0 then return end
	local loopGridView = self.scrollView.loopGridView
	if loopGridView.IsDraging then return end
	if loopGridView.ScrollRect.velocity ~= Vector2.zero then return end
	local padding = loopGridView.Padding
	local height = (loopGridView.ViewPortHeight - loopGridView.ItemSizeWithPadding.y) * 0.5 - padding.top
	local itemIdx = self.controller:GetRawIdxByAreaId(areaId)
	local count  = self.controller:GetRawCount()
	loopGridView:RefreshListByIndex(count, itemIdx, 0, -height)
	self:OpenMenu(areaId)
end

function UIHundredDojoView:OnSloganChanged()
	if self.sloganState == SloganState.Showing or self.sloganState == SloganState.Hiding then
		self:RefreshSelfSlogan()
	end
end



function UIHundredDojoView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIHundredDojoView:OnClickInfoBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'HundredDojoPlayExplain'})
end

function UIHundredDojoView:OnClickLogBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIHundredDojoLog)
end

function UIHundredDojoView:SureBuyChallengeNumBtn()
	local errorCode, costCfgId = self.controller:SendBuyChallengeNumReq()
	if errorCode ~= 0 then
		if errorCode == 1 then
			CommonUtil.ItemNotEnoughHandle(costCfgId, Enum.UIPageName.UIHundredDojo)
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end

function UIHundredDojoView:OnClickAddBtn()
	local costCfgId, costNum = self.controller:GetBuyChallengeCountCost()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoBuyTimes, {costNum, nil, self.SureBuyChallengeNumBtn, self})
end

function UIHundredDojoView:OnClickRewardBoxBtn()
	local errorCode = self.controller:SendGetRewardReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIHundredDojoView:OnClickShopBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIShop, 6, self.uiData.id)
end

function UIHundredDojoView:OnClickRankBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIHundredDojoGuildRank)
end

function UIHundredDojoView:OnClickAreaSlotItem(btn, params)
	local itemLua = params[0]
	if not itemLua then return end
	if self.curSelectAreaItemLua == itemLua then return end
	local funType = itemLua.funType
	if funType == Enum.HundredDojoFunType.Normal then
		local areaId = itemLua.areaId
		local areaData = self.controller:GetAreaDataById(areaId)
		if not areaData or not areaData:IsValidData() then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('HundredDojoView2')
			return
		else
			if not areaData:IsOccupy() then
				self:CloseMenu()
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIHundredDojoChallenge, areaId)
				return
			end
		end
		if self.controller:IsSelfArea(areaId) then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('HundredDojoView1')
			return
		end
		self:LocationAndOpenMenu(areaId)
	else
		if Constant.OpenPay then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('FunctionLock')
		end
	end
end

function UIHundredDojoView:OnBeginDragAction(gridView)
	gridView.ItemSnapEnable = false
	self.alignAreaId = nil
	if self.refreshAreaTimer then
		self.refreshAreaTimer:Stop()
	end
	self:CloseSlogan()
end

function UIHundredDojoView:OnEndDragAction(gridView)
	gridView.ItemSnapEnable = false
	self.alignAreaId = nil
	if self.refreshAreaTimer then
		if self.refreshAreaTimer.time > 1 then
			self.refreshAreaTimer.time = 1
		end
		if not self.refreshAreaTimer.running then
			self.refreshAreaTimer:Start()
		end
	end
	self:OpenSlogan()
end

function UIHundredDojoView:OnSnapItemFinished(gridView, gridViewItem)
	gridView.ItemSnapEnable = false
	if self.refreshAreaTimer then
		if self.refreshAreaTimer.time > 1 then
			self.refreshAreaTimer.time = 1
		end
		if not self.refreshAreaTimer.running then
			self.refreshAreaTimer:Start()
		end
	end
	if not self.alignAreaId then return end
	local itemIdx, idx = self.controller:GetRawIdxByAreaId(self.alignAreaId)
	if itemIdx == 0
		or itemIdx == gridViewItem.ItemIndex
		or (itemIdx + 1) == self.controller:GetRawCount()  then
		self:OpenMenu(self.alignAreaId)
	end
	self.alignAreaId = nil
	self:OpenSlogan()
end


function UIHundredDojoView:RefreshChallengeCount()
	self.challengeTimesTxt.text.text = tostring(self.controller:GetChallengeCount())
end

function UIHundredDojoView:RefreshBaseReward()
	local rewardRate = self.controller:GetRewardRate()
	local baseRewards = self.controller:GetBaseRewards()
	if baseRewards then
		self:RefreshRewardItem(self.baseReward.currency1, baseRewards[1], rewardRate)
		self:RefreshRewardItem(self.baseReward.currency2, baseRewards[2], rewardRate)
		self:RefreshRewardItem(self.baseReward.currency3, baseRewards[3], rewardRate)
	else
		self:RefreshRewardItem(self.baseReward.currency1, nil, rewardRate)
		self:RefreshRewardItem(self.baseReward.currency2, nil, rewardRate)
		self:RefreshRewardItem(self.baseReward.currency3, nil, rewardRate)
	end
end

function UIHundredDojoView:RefreshRewardItem(currency, reward, rewardRate)
	if not currency then return end
	currency.icon.image.enabled = false
	currency.icon.image.sprite = nil
	if reward then
		local cfgId = reward[1] or 0
		local num = reward[2] or 0
		local cfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
		if cfgData then
			CommonUtil.LoadIcon(self, cfgData.MiniIcon, function(sprite)
				if sprite then
					currency.icon.image.sprite = sprite
					currency.icon.image.enabled = true
				end
			end)
		end
		if rewardRate and rewardRate > 0 then
			currency.text.text.text = tostring(Mathf.Floor(num * rewardRate))
		else
			currency.text.text.text = '--'
		end
		currency:SetActive(true)
	else
		currency:SetActive(false)
	end
end

function UIHundredDojoView:RefreshReward()
	local nextTime = nil
	local baseRewardTime = self.controller:GetBaseRewardStartTime()
	local remainTime = 0
	if baseRewardTime and baseRewardTime > 0 then
		remainTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime() - baseRewardTime
		remainTime = remainTime / 1000
		if type(remainTime) == 'userdata' then
			remainTime = #remainTime
		end
	end
	if remainTime > 0 then
		local rewardMaxTime = self.controller:GetRewardMaxTime()
		if remainTime >= rewardMaxTime then
			self.rewardBox.redPointItem.text.text.text = string.formatbykey('Max')
			self.rewardBox.redPointItem:SetActive(true)
			self.controller:ForceHandleRewardRedPoint()
		else
			local rewardInterval = self.controller:GetRewardInterval()
			local rewardNum = Mathf.Floor(remainTime / rewardInterval)
			if rewardNum > 99 then
				self.rewardBox.redPointItem.text.text.text = '99+'
				self.rewardBox.redPointItem:SetActive(true)
			elseif rewardNum >= 1 then
				self.rewardBox.redPointItem.text.text.text = tostring(rewardNum)
				self.rewardBox.redPointItem:SetActive(true)
			else
				self.rewardBox.redPointItem:SetActive(false)
			end
			nextTime = ((rewardInterval * (rewardNum + 1)) - remainTime)
		end
	else
		nextTime = self.controller:GetRewardInterval()
		self.rewardBox.redPointItem:SetActive(false)
	end
	if nextTime then
		if nextTime <= 0 then
			nextTime = 1
		end
		if self.rewardTimer then
			self.rewardTimer.time = 0
			self.rewardTimer.duration = nextTime
		else
			self.rewardTimer = Timer.New(slot(self.RefreshReward, self), nextTime, -1)
		end
		if not self.rewardTimer.running then
			self.rewardTimer:Start()
		end
	else
		if self.rewardTimer then
			self.rewardTimer:Stop()
			self.rewardTimer = nil
		end
	end
end

function UIHundredDojoView:RefreshOccupy()
	if self.occupyTimer and self.occupyTimer.running then
		self.occupyTimer:Stop()
	end
	local areaData = self.controller:GetSelfAreaData()
	if not areaData or not areaData:IsOccupy() then
		self.dojoNameTxt.text.text = string.formatbykey('HundredDojoView4')
		self.timerTxt.text.text = DateTimeUtil.convertSeconds2TimeStr1(0, true, true, false)
		local areaCfgData = ManagerContainer.CfgMgr:GetHundredDojoCfgById(1)
		if areaCfgData then
			local rewards = areaCfgData.ShowRewardList
			if rewards then
				self:RefreshRewardItem(self.dojoReward.currency1, rewards[1], 0)
				self:RefreshRewardItem(self.dojoReward.currency2, rewards[2], 0)
				self:RefreshRewardItem(self.dojoReward.currency3, rewards[3], 0)
			else
				self:RefreshRewardItem(self.dojoReward.currency1, nil, 0)
				self:RefreshRewardItem(self.dojoReward.currency2, nil, 0)
				self:RefreshRewardItem(self.dojoReward.currency3, nil, 0)
			end
		else
			self:RefreshRewardItem(self.dojoReward.currency1, nil, 0)
			self:RefreshRewardItem(self.dojoReward.currency2, nil, 0)
			self:RefreshRewardItem(self.dojoReward.currency3, nil, 0)
		end
	else
		local areaCfgData = ManagerContainer.CfgMgr:GetHundredDojoCfgById(areaData.id)
		if areaCfgData then
			local rewards = areaCfgData.ShowRewardList
			self.dojoNameTxt.text.text = string.formatbykey(areaCfgData.Name)
			self:RefreshOccupyTime(true)
			local rewardRate = self.controller:GetRewardRate()
			if rewards then
				self:RefreshRewardItem(self.dojoReward.currency1, rewards[1], rewardRate)
				self:RefreshRewardItem(self.dojoReward.currency2, rewards[2], rewardRate)
				self:RefreshRewardItem(self.dojoReward.currency3, rewards[3], rewardRate)
			else
				self:RefreshRewardItem(self.dojoReward.currency1, nil, rewardRate)
				self:RefreshRewardItem(self.dojoReward.currency2, nil, rewardRate)
				self:RefreshRewardItem(self.dojoReward.currency3, nil, rewardRate)
			end
		else
			self.dojoNameTxt.text.text = string.formatbykey('HundredDojoView5')
			self.timerTxt.text.text = DateTimeUtil.convertSeconds2TimeStr1(0, true, true, false)
			self:RefreshRewardItem(self.dojoReward.currency1, nil, 0)
			self:RefreshRewardItem(self.dojoReward.currency2, nil, 0)
			self:RefreshRewardItem(self.dojoReward.currency3, nil, 0)
		end
	end
end

function UIHundredDojoView:RefreshOccupyTime(isFirst)
	local areaData = self.controller:GetSelfAreaData()
	if not areaData or not areaData:IsOccupy() then
		if self.occupyTimer and self.occupyTimer.running then
			self.occupyTimer:Stop()
		end
		if not isFirst then
			self.controller:SendGetSelfInfoReq()
		end
	else
		local endTime = areaData:GetEndTime()
		local remainTime = 0
		if endTime and endTime > 0 then
			remainTime = endTime - ManagerContainer.LuaTimerMgr:CurLuaServerTime()
			remainTime = remainTime / 1000
			if type(remainTime) == 'userdata' then
				remainTime = #remainTime
			end
		end
		self.timerTxt.text.text = DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false)
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
		if not self.occupyTimer then
			self.occupyTimer = Timer.New(slot(self.RefreshOccupyTime, self), 1, -1)
		else
			self.occupyTimer.time = 0
			self.occupyTimer.duration = validTime
		end
		if not self.occupyTimer.running then
			self.occupyTimer:Start()
		end
	end
end

function UIHundredDojoView:RefreshArea()
	local loopGridView = self.scrollView.loopGridView
	local areaData = self.controller:GetSelfAreaData()
	if not areaData or not areaData:IsValidData() then
		loopGridView:RefreshListByIndex(0, 0)
		if self.refreshAreaTimer then
			self.refreshAreaTimer:Stop()
		end
		return
	end
	local itemCount = loopGridView.ItemTotalCount
	local count  = self.controller:GetRawCount()
	if itemCount ~= count then
		local areaId = self.controller:GetLastAttackAreaId()
		if not areaId or areaId <= 0 then
			areaId = areaData.id
		end
		if areaId and areaId > 0 then
			local padding = loopGridView.Padding
			local height = (loopGridView.ViewPortHeight - loopGridView.ItemSizeWithPadding.y) * 0.5 - padding.top
			local itemIdx = self.controller:GetRawIdxByAreaId(areaId)
			loopGridView:RefreshListByIndex(count, itemIdx, 0, -height)
		else
			loopGridView:RefreshListByIndex(count, 0)
		end

		self.isInitGrid = true
		self:SendGetOtherInfosReq()
		if not self.refreshAreaTimer then
			self.refreshAreaTimer = Timer.New(slot(self.SendGetOtherInfosReq, self), 5, -1)
		end
		if not self.refreshAreaTimer.running then
			self.refreshAreaTimer:Start()
		end
	end
end

function UIHundredDojoView:SendGetOtherInfosReq()
	local areaData = self.controller:GetSelfAreaData()
	if not areaData or not areaData:IsValidData() then
		return
	end
	local showRawIdxs = self.controller:GetShowRawIdxs()
	local startId, endId
	for i = 1, #showRawIdxs do
		local startId1, endId1 = self.controller:GetRawAreaStartAndEnd(showRawIdxs[i])
		if not startId or not endId then
			startId = startId1
			endId = endId1
		else
			if startId > startId1 then
				startId = startId1
			end
			if endId < endId1 then
				endId = endId1
			end
		end
	end
	if not startId or not endId then
		LogError('[wboy] not find need get data')
		return
	end
	if endId < startId then
		LogError('[wboy] not find need get valid data')
		return
	end
	local areaIds = {}
	if (endId - startId) > 30 then
		LogWarning('[Wboy] Need Get Data is Num' .. tostring((endId - startId)))
	end
	local selfId = areaData.id
	for i = startId, endId do
		if i ~= selfId then
			local areaCfgData = ManagerContainer.CfgMgr:GetHundredDojoCfgById(i)
			if areaCfgData and areaCfgData.FunType == Enum.HundredDojoFunType.Normal then
				areaIds[#areaIds+1] = i
			end
		end
	end
	self.controller:SendGetOtherInfosReq(areaIds)
end



function UIHundredDojoView:GetItemByRowColumn(gridView, itemIndex, row, column)
	self.controller:AddShowRawIdx(itemIndex)
	local startId, endId = self.controller:GetRawAreaStartAndEnd(itemIndex)
	local item = gridView:NewListViewItem('HundredDojoRawItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'HundredDojoRawItem', item.gameObject)
	if itemLua then
		for i = startId, endId do
			self:RefreshAreaItemLuaByAreaId(itemLua, i)
		end
	end
	ManagerContainer.LuaUIMgr:ForceRebuildLayoutImmediate(item.CachedRectTransform)
	return item
end

function UIHundredDojoView:FindAreaItemLuaByAreaId(areaId)
	local itemIdx, idx = self.controller:GetRawIdxByAreaId(areaId)
	local item = self.scrollView.loopGridView:GetShownItemByItemIndex(itemIdx)
	if item then
		local itemLua = CommonUtil.GetBindGridViewItem2Lua(self, 'HundredDojoRawItem', item.gameObject)
		if itemLua then
			if itemLua.childrenLua then
				return itemLua.childrenLua[idx]
			end
		end
	end
	return nil
end


function UIHundredDojoView:RefreshItemLua(areaId)
	if not areaId then return end
	local itemIdx, idx = self.controller:GetRawIdxByAreaId(areaId)
	local item = self.scrollView.loopGridView:GetShownItemByItemIndex(itemIdx)
	if item then
		local itemLua = CommonUtil.GetBindGridViewItem2Lua(self, 'HundredDojoRawItem', item.gameObject)
		if itemLua then
			self:RefreshAreaItemLuaByAreaId(itemLua, areaId)
		end
	end
end

function UIHundredDojoView:RefreshAreaItemLuaByAreaId(itemLua, areaId)
	local childrenLua = itemLua.childrenLua
	if not childrenLua then
		childrenLua = {}
		itemLua.childrenLua = childrenLua
	end
	local areaCfgData = ManagerContainer.CfgMgr:GetHundredDojoCfgById(areaId)
	if areaCfgData then
		local itemIdx, idx = self.controller:GetRawIdxByAreaId(areaId)
		local areaItemLua = childrenLua[idx]
		if not areaItemLua or areaItemLua.funType ~= areaCfgData.FunType or areaItemLua.areaType ~= areaCfgData.AreaType then
			self:ReleaseAreaItemLua(areaItemLua)
			areaItemLua = self:GetAreaItemLua(areaCfgData.FunType, areaCfgData.AreaType, itemLua.transform)
			childrenLua[idx] = areaItemLua
		end
		self:RefreshAreaItemLua(areaItemLua, areaId)
	end
end

function UIHundredDojoView:RefreshAreaItemLua(areaItemLua, areaId, hideName)
	if not areaItemLua then return end
	areaItemLua.areaId = areaId
	local areaCfgData = ManagerContainer.CfgMgr:GetHundredDojoCfgById(areaId)
	if areaCfgData then
		areaItemLua:SetActive(true)
		if areaCfgData.FunType == Enum.HundredDojoFunType.Normal then
			local heroCutePath = nil
			local areaData = self.controller:GetAreaDataById(areaId)
			if areaData and areaData:IsOccupy() then
				local robotId = areaData:GetRobotId()
				local playName = nil
				local atkPower = 0
				local color = nil
				if robotId and robotId > 0 then
					heroCutePath = self.controller:GetRobotHeroCute()
					local robotCfgData = ManagerContainer.CfgMgr:GetRobotDataByCfgId(robotId)
					if robotCfgData then
						playName = robotCfgData.RobotName
						atkPower = robotCfgData.FightPower and robotCfgData.FightPower[1] or 0
					end
					color = ColorExtension.HexStringToColor(string.formatbykey('ColorID4'))
				else
					local isSelfArea = self.controller:IsSelfArea(areaId)
					local uid = nil
					if isSelfArea then
						playName = self.controller:GetUserNickname()
						atkPower = self.controller:GetTotalFightPower()
						local roleId = self.controller:GetUserRoleId()
						local roleCfgData = ManagerContainer.CfgMgr:GetRoleDataById(roleId)
						if roleCfgData then
							heroCutePath = roleCfgData.HeroCute
						end
					else
						local playBrief = areaData:GetPlayBrief()
						if playBrief then
							playName = playBrief.nickName
							atkPower = playBrief.fightPower
							uid = playBrief.uid
							local roleId = CommonUtil.JobIdToRoleId(playBrief.configId, playBrief.gender)
							local roleCfgData = ManagerContainer.CfgMgr:GetRoleDataById(roleId)
							if roleCfgData then
								heroCutePath = roleCfgData.HeroCute
							end
						end
					end
					if isSelfArea then
						color = ColorExtension.HexStringToColor(string.formatbykey('ColorID2'))
					elseif self.controller:IsLastBeAtkArea(uid) then
						color = ColorExtension.HexStringToColor(string.formatbykey('ColorID6'))
					elseif self.controller:IsSameGuild(areaData:GetGuildId()) then
						color = ColorExtension.HexStringToColor(string.formatbykey('ColorID3'))
					else
						color = ColorExtension.HexStringToColor(string.formatbykey('ColorID5'))
					end
				end
				if not color then
					color = ColorExtension.HexStringToColor(string.formatbykey('ColorID1'))
				end
				if areaData:IsProtected() then
					areaItemLua.animator:Play('ShieldKeep')
				elseif areaData:IsFighting() then
					areaItemLua.animator:Play('BattleKeep')
				else
					areaItemLua.animator:Play('NormalKeep')
				end
				areaItemLua.nameBoard.bG.image.color = color
				areaItemLua.nameBoard.nameTxt.text.text = (playName and tostring(playName) or '')
				areaItemLua.nameBoard.power.text.text = tostring(atkPower)
				if hideName then
					areaItemLua.nameBoard:SetActive(false)
				else
					areaItemLua.nameBoard:SetActive(true)
				end
				if not heroCutePath or heroCutePath == '' then
					heroCutePath = self.controller:GetDefaultHeroCute()
				end
			elseif not areaData or not areaData:IsValidData() then
				if not heroCutePath or heroCutePath == '' then
					heroCutePath = self.controller:GetDefaultHeroCute()
				end
				areaItemLua.animator:Play('NormalKeep')
				areaItemLua.nameBoard:SetActive(false)
			else
				if areaData:IsFighting() then
					areaItemLua.animator:Play('BattleKeep')
				else
					areaItemLua.animator:Play('EmptyKeep')
				end
				areaItemLua.nameBoard:SetActive(false)
			end
			areaItemLua.player.image.enabled = false
			areaItemLua.player.image.sprite = nil
			areaItemLua.shadow:SetActive(false)
			CommonUtil.LoadIcon(self, heroCutePath, function(sprite)
				areaItemLua.player.image.sprite = sprite
				areaItemLua.player.image.enabled = true
				areaItemLua.shadow:SetActive(true)
			end, areaItemLua, 'AreaItemHeroCute')
		end
	else
		areaItemLua:SetActive(false)
	end
end

function UIHundredDojoView:RecycleItem(gridView, itemIndex, row, column, loopGridViewItem)
	self.controller:RemoveShowRawIdx(itemIndex)
	local itemLua = CommonUtil.GetBindGridViewItem2Lua(self, 'HundredDojoRawItem', loopGridViewItem.gameObject)
	if not itemLua then return end
	local childrenLua = itemLua.childrenLua
	if childrenLua then
		for _, areaItemLua in pairs(childrenLua) do
			self:ReleaseAreaItemLua(areaItemLua)
		end
	end
	itemLua.childrenLua = nil
end

function UIHundredDojoView:GetAreaItemLua(funType, areaType, parent)
	if self.areaPool then
		if self.areaPool[funType] then
			local ls = self.areaPool[funType][areaType]
			if ls then
				local item = ls[#ls]
				if item then
					ls[#ls] = nil
					item.transform:SetParent(parent)
					item.transform.localPosition = Vector3.zero
					item.transform.localScale = Vector3.one
					item.transform.localRotation = Quaternion.identity
					item:SetActive(true)
					return item
				end
			end
		end
	end
	local source = nil
	if funType == Enum.HundredDojoFunType.Box then
		source = self.hundredDojoBoxSlotItem
	elseif funType == Enum.HundredDojoFunType.Normal then
		if areaType == Enum.HundredDojoAreaType.FirstArea then
			source = self.hundredDojoSlotItem1
		elseif areaType == Enum.HundredDojoAreaType.SuperArea then
			source = self.hundredDojoSlotItem2
		elseif areaType == Enum.HundredDojoAreaType.OneLvArea then
			source = self.hundredDojoSlotItem3
		elseif areaType == Enum.HundredDojoAreaType.TwoLvArea then
			source = self.hundredDojoSlotItem4
		elseif areaType == Enum.HundredDojoAreaType.ThreeArea then
			source = self.hundredDojoSlotItem5
		elseif areaType == Enum.HundredDojoAreaType.FourArea then
			source = self.hundredDojoSlotItem6
		else
			source = self.hundredDojoSlotItem6
		end
	end
	if not source then return nil end
	local newGo = UnityEngine.GameObject.Instantiate(source.gameObject)
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, source.prefabName, newGo)
	itemLua.transform:SetParent(parent)
	itemLua.transform.localPosition = Vector3.zero
	itemLua.transform.localScale = Vector3.one
	itemLua.transform.localRotation = Quaternion.identity
	itemLua.funType = funType
	itemLua.areaType = areaType
	itemLua:SetActive(true)
	if funType == Enum.HundredDojoFunType.Box then
		self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickAreaSlotItem, itemLua)
	elseif funType == Enum.HundredDojoFunType.Normal then
		self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickAreaSlotItem, itemLua)
	end
	return itemLua
end

function UIHundredDojoView:ReleaseAreaItemLua(itemLua)
	if not itemLua then return end
	local funType = itemLua.funType
	local areaType = itemLua.areaType
	if not funType or not areaType then
		local go = itemLua.gameObject
		CommonUtil.ClearBindGridViewItem2Lua(self, itemLua.prefabName, go)
		CommonUtil.DestroyGO(go)
		return
	end
	if not self.areaPool then
		self.areaPool = {}
	end
	if not self.areaPool[funType] then
		self.areaPool[funType] = {}
	end
	local ls = self.areaPool[funType][areaType]
	if not ls then
		ls = {}
		self.areaPool[funType][areaType] = ls
	end
	itemLua.transform:SetParent(self.scrollView.transform)
	itemLua:SetActive(false)
	ls[#ls + 1] = itemLua
end

function UIHundredDojoView:DisposeAreaItemLua()
	if not self.areaPool then
		return
	end
	for _, areaMap in pairs(self.areaPool) do
		for _, ls in pairs(areaMap) do
			for _, itemLua in pairs(ls) do
				if itemLua.gameObject then
					CommonUtil.DestroyGO(itemLua.gameObject)
				end
			end
		end
	end
	self.areaPool = nil
end

function UIHundredDojoView:LocationAndOpenMenu(areaId)
	local itemIdx = self.controller:GetRawIdxByAreaId(areaId)
	local loopGridView = self.scrollView.loopGridView
	local pair1 = loopGridView:GetRowColumnByItemIndex(itemIdx)
	local pair2 = loopGridView:GetRowColumnByItemIndex(itemIdx + 1)
	local offset = loopGridView.ContainerTrans.anchoredPosition
	local itemPosStart = loopGridView:GetItemPos(pair1.mRow, pair1.mColumn) + offset
	local itemPosEnd = loopGridView:GetItemPos(pair2.mRow, pair2.mColumn) + offset
	local rect = self.viewRect.rectTransform.rect
	local min = self.viewRect.rectTransform:TransformPoint(rect.min)
	local max = self.viewRect.rectTransform:TransformPoint(rect.max)
	local scrollRect = loopGridView.ScrollRect
	local viewport = scrollRect.viewport
	min = viewport:InverseTransformPoint(min)
	max = viewport:InverseTransformPoint(max)

	local isStart1 = ((itemPosStart.y - min.y) >= 0.001)
	local isStart2 = ((itemPosStart.y - max.y) <= 0.001)
	local isEnd1 = ((itemPosEnd.y - min.y) >= 0.001)
	local isEnd2 = ((itemPosEnd.y - max.y) <= 0.001 )

	if isStart1 and isStart2 and isEnd1 and isEnd2 then
		self:OpenMenu(areaId)
		return
	end
	local val = scrollRect.verticalNormalizedPosition
	if val <= 0 or val >= 1 then
		self:OpenMenu(areaId)
		return
	end
	self:CloseSlogan()
	self.alignAreaId = areaId
	if self.refreshAreaTimer then
		self.refreshAreaTimer:Stop()
	end
	loopGridView.ItemSnapEnable = true
	loopGridView:SetSnapTargetItemRowColumn(pair1.mRow, pair1.mColumn)
	local rect1 = viewport.rect
	if isEnd1 then
		loopGridView.ItemSnapPivot = Vector2.one
		local pivotOffset = (rect1.yMax - max.y)
		if pivotOffset <= 0 then
			pivotOffset = 1
		else
			pivotOffset = 1 - pivotOffset / rect1.height
		end
		loopGridView.ViewPortSnapPivot = Vector2(0, pivotOffset)
		return
	end
	loopGridView.ItemSnapPivot = Vector2.zero
	local pivotOffset = (min.y - rect1.yMin)
	if pivotOffset <= 0 then
		pivotOffset = 0
	else
		pivotOffset = pivotOffset / rect1.height
	end
	loopGridView.ViewPortSnapPivot = Vector2(0, pivotOffset)
end




function UIHundredDojoView:OpenMenu(areaId)
	if not areaId then return end
	self.curSelectAreaId = areaId
	if self.controller:IsSelfArea(areaId) then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('HundredDojoTip1')
		return
	end
	local areaData = self.controller:GetAreaDataById(areaId)
	if not areaData or not areaData:IsValidData() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('HundredDojoTip2')
		return
	else
		if not areaData:IsOccupy() then
			self:CloseMenu()
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIHundredDojoChallenge, areaId)
			return
		end
	end
	local itemIdx, idx = self.controller:GetRawIdxByAreaId(areaId)
	local item = self.scrollView.loopGridView:GetShownItemByItemIndex(itemIdx)
	if not item then return end
	local itemLua = CommonUtil.GetBindGridViewItem2Lua(self, 'HundredDojoRawItem', item.gameObject)
	if not itemLua then return end
	local childrenLua = itemLua.childrenLua
	if not childrenLua then return end
	local areaItemLua = childrenLua[idx]
	if not areaItemLua then return end
	local areaCfgData = ManagerContainer.CfgMgr:GetHundredDojoCfgById(areaId)
	if not areaCfgData then return end
	local robotId = areaData:GetRobotId()
	local playName = nil
	local atkPower = 0
	local color = nil
	if robotId and robotId > 0 then
		local robotCfgData = ManagerContainer.CfgMgr:GetRobotDataByCfgId(robotId)
		if robotCfgData then
			playName = robotCfgData.RobotName
			atkPower = robotCfgData.FightPower and robotCfgData.FightPower[1] or 0
		end
		color = ColorExtension.HexStringToColor(string.formatbykey('ColorID4'))
	else
		local uid = nil
		local playBrief = areaData:GetPlayBrief()
		if playBrief then
			playName = playBrief.nickName
			atkPower = playBrief.fightPower
			uid = playBrief.uid
		end
		if self.controller:IsSelfArea(areaId) then
			color = ColorExtension.HexStringToColor(string.formatbykey('ColorID2'))
		elseif self.controller:IsLastBeAtkArea(uid) then
			color = ColorExtension.HexStringToColor(string.formatbykey('ColorID6'))
		elseif self.controller:IsSameGuild(areaData:GetGuildId()) then
			color = ColorExtension.HexStringToColor(string.formatbykey('ColorID3'))
		else
			color = ColorExtension.HexStringToColor(string.formatbykey('ColorID5'))
		end
	end
	if not color then
		color = ColorExtension.HexStringToColor(string.formatbykey('ColorID1'))
	end
	self.menu:SetActive(true)
	if not self.curSelectAreaItemLua or self.curSelectAreaItemLua.funType ~= areaCfgData.FunType or self.curSelectAreaItemLua.areaType ~= areaCfgData.AreaType then
		self:ReleaseAreaItemLua(self.curSelectAreaItemLua)
		self.curSelectAreaItemLua = self:GetAreaItemLua(areaCfgData.FunType, areaCfgData.AreaType, self.menu.transform)
	end
	if self.curSelectAreaItemLua then
		self.curSelectAreaItemLua.transform.position = areaItemLua.transform.position
		self:RefreshAreaItemLua(self.curSelectAreaItemLua, areaId, true)
	end
	self.menu.panel.transform.position = areaItemLua.transform.position
	self.menu.panel.transform:SetAsLastSibling()
	self.menu.nameBoard.bG.image.color = color
	self.menu.nameBoard.nameTxt.text.text = (playName and tostring(playName) or '')
	self.menu.nameBoard.power.text.text = tostring(atkPower)
	self.menu.nameBoard:SetActive(true)
	self:RefreshMenuLeftTimer()
	self:ReleaseOtherSloganByAreaId(areaId)
end

function UIHundredDojoView:CloseMenu()
	self.curSelectAreaId = nil
	if self.menuLeftTimer then
		self.menuLeftTimer:Stop()
	end
	if self.curSelectAreaItemLua then
		self:ReleaseAreaItemLua(self.curSelectAreaItemLua)
		self.curSelectAreaItemLua = nil
	end
	self.menu:SetActive(false)
end

function UIHundredDojoView:RefreshMenuLeftTimer()
	local areaId = self.curSelectAreaId
	if not areaId then
		if self.menuLeftTimer then
			self.menuLeftTimer:Stop()
		end
		return
	end
	if self.controller:IsSelfArea(areaId) then
		self:CloseMenu()
		return
	end
	local areaData = self.controller:GetAreaDataById(areaId)
	if not areaData or not areaData:IsValidData() then
		self:CloseMenu()
		return
	else
		if not areaData:IsOccupy() then
			self:CloseMenu()
			return
		end
	end
	local robotId = areaData:GetRobotId()
	if robotId and robotId > 0 then
		if self.menuLeftTimer then
			self.menuLeftTimer:Stop()
		end
		self.menu.leftTimer:SetActive(false)
		self.menu.shield:SetActive(false)
		self.menu.btnInfo:SetActive(false)
		self.menu.btnClg:SetActive(true)
		return
	end
	self.menu.btnInfo:SetActive(true)
	self.menu.btnClg:SetActive(true)

	local isProtected = areaData:IsProtected()
	local remainTime = 0
	if isProtected then
		local endTime = areaData:GetProtectEndTime()
		if endTime and endTime > 0 then
			remainTime = endTime - ManagerContainer.LuaTimerMgr:CurLuaServerTime()
			remainTime = remainTime / 1000
			if type(remainTime) == 'userdata' then
				remainTime = #remainTime
			end
		end
		self.menu.shield.text.text.text = DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false)
		self.menu.leftTimer:SetActive(false)
		self.menu.shield:SetActive(true)
	else
		local endTime = areaData:GetEndTime()
		if endTime and endTime > 0 then
			remainTime = endTime - ManagerContainer.LuaTimerMgr:CurLuaServerTime()
			remainTime = remainTime / 1000
			if type(remainTime) == 'userdata' then
				remainTime = #remainTime
			end
		end
		self.menu.leftTimer.text.text.text = DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false)
		self.menu.leftTimer:SetActive(true)
		self.menu.shield:SetActive(false)
	end
	if remainTime <= 0 then
		if self.menuLeftTimer then
			self.menuLeftTimer:Stop()
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
		if self.menuLeftTimer then
			self.menuLeftTimer.time = 0
			self.menuLeftTimer.duration = validTime
		else
			self.menuLeftTimer = Timer.New(slot(self.RefreshMenuLeftTimer, self), validTime, -1)
		end
		if not self.menuLeftTimer.running then
			self.menuLeftTimer:Start()
		end
	end
end

function UIHundredDojoView:OnClickMenuCloseBtn()
	self:CloseMenu()
end

function UIHundredDojoView:OnClickMenuChallengeBtn()
	local areaId = self.curSelectAreaId
	if not areaId then return end
	if self.controller:IsSelfArea(areaId) then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('HundredDojoView1')
		return
	end
	local areaData = self.controller:GetAreaDataById(areaId)
	if not areaData or not areaData:IsValidData() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('HundredDojoView2')
		return
	end
	self:CloseMenu()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIHundredDojoChallenge, areaId)
end

function UIHundredDojoView:OnClickMenuInfoBtn()
	local areaId = self.curSelectAreaId
	if not areaId then return end
	if self.controller:IsSelfArea(areaId) then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('HundredDojoView1')
		return
	end
	local areaData = self.controller:GetAreaDataById(areaId)
	if not areaData or not areaData:IsValidData() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('HundredDojoView2')
		return
	else
		if not areaData:IsOccupy() then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('HundredDojoView2')
			return
		end
	end
	local robotId = areaData:GetRobotId()
	if robotId and robotId > 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('HundredDojoView2')
		return
	end
	self:CloseMenu()
	local playBrief = areaData:GetPlayBrief()
	if playBrief then
		ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(playBrief.uid)
	end
end


function UIHundredDojoView:OnClickMySloganBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIHundredDojoSlogan)
end





function UIHundredDojoView:OpenSlogan()
	if not self.sloganTimer then
		self.sloganTimer = Timer.New(slot(self.UpdateSloganTimer, self), 0.03, -1)
	else
		self.sloganTimer.duration = 0.03
		self.sloganTimer.time = 0.03
	end
	self.sloganState = SloganState.CheckOpening
	if not self.sloganTimer.running then
		self.sloganTimer:Start()
	end
end


function UIHundredDojoView:CloseSlogan()
	self.mySloganitem:SetActive(false)
	self:HideSlogan()
	if self.sloganTimer then
		self.sloganTimer:Stop()
	end
	self.sloganState = SloganState.Idle
end

function UIHundredDojoView:ShowSlogan()
	self:RefreshOtherSlogans()
end

function UIHundredDojoView:HideSlogan()
	if self.otherSloganDic then
		for areaId, sloganItemLua in pairs(self.otherSloganDic) do
			self:ReleaseOtherSloganItemLua(sloganItemLua)
			self.otherSloganDic[areaId] = nil
		end
	end
end

function UIHundredDojoView:DisposeSlogan()
	if self.sloganTimer then
		self.sloganTimer:Stop()
		self.sloganTimer = nil
	end
	if self.otherSloganDic then
		for areaId, sloganItemLua in pairs(self.otherSloganDic) do
			self:DisposeOtherSloganItemLua(sloganItemLua)
		end
		self.otherSloganDic = nil
	end
	if self.sloganPool then
		for areaId, sloganItemLua in pairs(self.sloganPool) do
			self:DisposeOtherSloganItemLua(sloganItemLua)
		end
		self.sloganPool = nil
	end
end

function UIHundredDojoView:UpdateSloganTimer()
	if self.sloganState == SloganState.CheckOpening then
		local loopGridView = self.scrollView.loopGridView
		if not loopGridView.IsDraging then
			if loopGridView.ScrollRect.velocity == Vector2.zero then
				self.sloganState = SloganState.Opening
				self.sloganTimer.time = self.controller:GetSloganStartTime()
			end
		end
	elseif self.sloganState == SloganState.Opening then
		self:RefreshSelfSlogan()
		self:ShowSlogan()
		self.sloganState = SloganState.Showing
		self.sloganTimer.time = self.controller:GetSloganShowTime()
	elseif self.sloganState == SloganState.Showing then
		self:HideSlogan()
		self.sloganState = SloganState.Hiding
		self.sloganTimer.time = self.controller:GetSloganHideTime()
	elseif self.sloganState == SloganState.Hiding then
		self:ShowSlogan()
		self.sloganState = SloganState.Showing
		self.sloganTimer.time = self.controller:GetSloganShowTime()
	else
		self:CloseSlogan()
	end
end



function UIHundredDojoView:RefreshSelfSlogan()
	local areaData = self.controller:GetSelfAreaData()
	if areaData and areaData:IsOccupy() then
		if self.curSelectAreaId ~= areaData.id then
			local areaItemLua = self:FindAreaItemLuaByAreaId(areaData.id)
			if areaItemLua then
				self.mySloganitem.transform.position = areaItemLua.transform.position
				self.mySloganitem:SetActive(true)
				local slogan = self.controller:GetSelfSlogan()
				if not slogan or slogan == '' then
					self.mySloganitem.light:SetActive(true)
					self.mySloganitem.slogan:SetActive(false)
					self.mySloganitem.dsc:SetActive(true)
				else
					self.mySloganitem.light:SetActive(false)
					self.mySloganitem.slogan:SetActive(true)
					self.mySloganitem.dsc:SetActive(false)
					self.mySloganitem.slogan.text.text = tostring(slogan)
				end
				return
			end
		end
	end
	self.mySloganitem:SetActive(false)
end

function UIHundredDojoView:RefreshOtherSlogans()
	local startItemId, endItemId
	local viewRectTrans = self.sloganViewRect.rectTransform
	local rect = viewRectTrans.rect
	local min = viewRectTrans:TransformPoint(rect.min)
	local max = viewRectTrans:TransformPoint(rect.max)
	local loopGridView = self.scrollView.loopGridView
	local updateAreaIds = nil
	startItemId, endItemId = loopGridView:FindItemIdxInWorldRect(min, max, startItemId, endItemId)
	endItemId = endItemId - 1
	if endItemId >= startItemId then
		local sloganNumMax = self.controller:GetSloganNumMax()
		if sloganNumMax > 0 then
			local validAreaIds = {}
			local num = 0
			for i = startItemId, endItemId do
				local startId, endId = self.controller:GetRawAreaStartAndEnd(i)
				for j = startId, endId do
					num = num + 1
					validAreaIds[num] = j
				end
			end
			if num > 0 then
				updateAreaIds = {}
				if sloganNumMax >= num then
					for i = 1, num do
						local areaId = validAreaIds[i]
						updateAreaIds[areaId] = true
						self:InitOtherSloganByAreaId(areaId)
					end
				else
					for i = 1, sloganNumMax do
						local idx = math.random(1, num)
						local areaId = validAreaIds[idx]
						updateAreaIds[areaId] = true
						self:InitOtherSloganByAreaId(areaId)
						table.remove(validAreaIds, idx)
						num = num - 1
					end
				end
			end
		end
	end
	if self.otherSloganDic then
		for areaId, sloganItemLua in pairs(self.otherSloganDic) do
			if not updateAreaIds or not updateAreaIds[areaId] then
				self:ReleaseOtherSloganItemLua(sloganItemLua)
				self.otherSloganDic[areaId] = nil
			end
		end
	end
end

function UIHundredDojoView:InitOtherSloganByAreaId(areaId)
	if self.curSelectAreaId ~= areaId then
		if not self.controller:IsSelfArea(areaId) then
			local areaData = self.controller:GetAreaDataById(areaId)
			if areaData and areaData:IsOccupy() then
				local slogan = areaData:GetSlogan()
				if slogan and slogan ~= '' then
					local areaItemLua = self:FindAreaItemLuaByAreaId(areaId)
					if areaItemLua then
						local otherSloganItemLua = nil
						if self.otherSloganDic then
							otherSloganItemLua = self.otherSloganDic[areaId]
						else
							self.otherSloganDic = {}
						end
						if not otherSloganItemLua then
							otherSloganItemLua = self:GetOtherSloganItemLua()
							self.otherSloganDic[areaId] = otherSloganItemLua
						end
						otherSloganItemLua.sloganTxt.text = tostring(slogan)
						otherSloganItemLua.transform.position = areaItemLua.transform.position
						return
					end
				end
			end
		end
	end
	self:ReleaseOtherSloganByAreaId(areaId)
end

function UIHundredDojoView:RefreshOtherSloganByAreaId(areaId)
	if self.otherSloganDic then
		local otherSloganItemLua = self.otherSloganDic[areaId]
		if otherSloganItemLua then
			if not self.controller:IsSelfArea(areaId) then
				local areaData = self.controller:GetAreaDataById(areaId)
				if areaData and areaData:IsOccupy() then
					local slogan = areaData:GetSlogan()
					if slogan and slogan ~= '' then
						local areaItemLua = self:FindAreaItemLuaByAreaId(areaId)
						if areaItemLua then
							otherSloganItemLua.sloganTxt.text = tostring(slogan)
							otherSloganItemLua.transform.position = areaItemLua.transform.position
							return
						end
					end
				end
			end
			self:ReleaseOtherSloganItemLua(otherSloganItemLua)
			self.otherSloganDic[areaId] = nil
		end
	end
end

function UIHundredDojoView:ReleaseOtherSloganByAreaId(areaId)
	if self.otherSloganDic then
		local otherSloganItemLua = self.otherSloganDic[areaId]
		if otherSloganItemLua then
			self:ReleaseOtherSloganItemLua(otherSloganItemLua)
			self.otherSloganDic[areaId] = nil
		end
	end
end

function UIHundredDojoView:GetOtherSloganItemLua()
	if self.sloganPool then
		local itemLua = self.sloganPool[#self.sloganPool]
		if itemLua then
			self.sloganPool[#self.sloganPool] = nil
			itemLua.gameObject:SetActive(true)
			return itemLua
		end
	end
	local newGo = UnityEngine.GameObject.Instantiate(self.otherSloganitem.gameObject)
	newGo:SetActive(true)
	local itemLua = {}
	itemLua.gameObject = newGo
	local trans = newGo.transform
	itemLua.transform = trans
	trans:SetParent(self.sloganGroup.transform)
	trans.localScale = Vector3.one
	trans.localRotation = Quaternion.identity
	itemLua.sloganTxt = trans:Find('Bubble/Slogan'):GetComponent(Enum.TypeInfo.Text)
	return itemLua
end

function UIHundredDojoView:ReleaseOtherSloganItemLua(sloganItemLua)
	if not sloganItemLua then return end
	sloganItemLua.gameObject:SetActive(false)
	if not self.sloganPool then
		self.sloganPool = {}
	end
	self.sloganPool[#self.sloganPool] = sloganItemLua
end

function UIHundredDojoView:DisposeOtherSloganItemLua(sloganItemLua)
	if not sloganItemLua then return end
	CommonUtil.DestroyGO(sloganItemLua.gameObject)
	sloganItemLua.gameObject = nil
	sloganItemLua.transform = nil
	sloganItemLua.sloganTxt = nil
end


return UIHundredDojoView

