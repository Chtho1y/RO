local UIActivityChipRewardComView = require("UIActivity/UIActivityChipRewardComView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

function UIActivityChipRewardComView:OnAwake(data)
	self.controller = require("UIActivity/UIActivityChipRewardComCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIActivityChipRewardComView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_Data_Change,self,self.ActivityRefresh)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ACTIVITY_GLOBAL_REFRESH,self,self.Refresh)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CHIPREWARD_ISNOTICE_CHANHE,self,self.IsNoticeRefresh)
end

function UIActivityChipRewardComView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)
	self:Init()
end

function UIActivityChipRewardComView:Init()
	self.controller:RefreshChipDatas()
	local activeItem = self.controller.activityData
	CommonUtil.LoadIcon(self, activeItem.pageBg, function (sprite)
		self.banner.image.sprite = sprite
	end)
	self.isCanSendRedNoticeReq = false
	self:InitGrid()
	self:Refresh()--true
	if not self.timer then
		self.timer = FrameTimer.New(slot(self.DelayInitTop, self), 1)
	end
	if not self.timer.running then
		self.timer:Start()
	end
end

function UIActivityChipRewardComView:DelayInitTop()
	self:InitTop()
end

function UIActivityChipRewardComView:InitTop()
	if not self.updateTimer then
		self.updateTimer = Timer.New(slot(self.UpdateMinute, self), 60, -1)
	end
	if not self.updateTimer.running then
		self.updateTimer:Start()
	end

	local canOpen = self:RefreshRemainTime()
	if canOpen then
		local activeItem = self.controller.activityData
		ManagerContainer.DataMgr.ActsDataMgr:SendGetGlobalCollectionServerData(activeItem.actId)
	end
end

function UIActivityChipRewardComView:RefreshRemainTime()
	local leftTime = self.controller:GetRemainTime()
	if leftTime <= 0 then
		self.time.text.text = "0"
		ManagerContainer.DataMgr.ActsDataMgr:RefreshRedPointState(Enum.ActivityType.ACTIVITY_TYPE_FESTIVAL_REWARD)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ACTIVITY_PAGECLOSE)		
		self:OnClickCloseBtn()
		return false
	end
	local day,hour,minute,second = ConvertTimeForm(leftTime)
	local timeStr = ""
	if day > 0 then
		timeStr = day .. "天"..hour .. "时" .. minute .. "分"
	else
		if hour > 0 then
			timeStr = hour .. "时" .. minute .. "分"
		else
			if minute == 0 then
				minute = 1
			end
			timeStr = minute .. "分"
		end
	end
	self.time.text.text = timeStr
	return true
end

function UIActivityChipRewardComView:UpdateMinute()
	self:RefreshRemainTime()
end

function UIActivityChipRewardComView:InitGrid()
	self.boxExchange.loopListView:InitListView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIActivityChipRewardComView:Refresh()
	local loopListView = self.boxExchange.loopListView
	local length = self.controller:GetChipDataLength()
	loopListView:SetListItemCount(length)
	loopListView:RefreshAllShownItem()
end
function UIActivityChipRewardComView:ActivityRefresh(actid)
	if self.controller:GetActId() == actid then
		self:Refresh()
	end
end

function UIActivityChipRewardComView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local length = self.controller:GetChipDataLength()
	if (itemIndex < 0 or itemIndex >= length) then
		return nil
	end
	local showData = self.controller:GetChipShowDataByIdx(itemIndex)
	local cfgData = ManagerContainer.CfgMgr:GetActivitiesCollectionCfgById(showData.cfgId)
	local item = gridView:NewListViewItem("ExchangeItem")
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, "ExchangeItem", item.gameObject)

	for i = 1, 4 do
		itemlua["coastItem"..(i-1)]:SetActive(false)
	end
	itemlua.checkmark:SetActive(not showData.isNotice)

	itemlua.reward.iconSmallItem2:SetActive(false)
	itemlua.serverLimit:SetActive(cfgData.ServersReward > 0)
	itemlua.coast.scrollRect.enabled = #cfgData.ExchangeCondition > 4

	local globalCount = self.controller:GetGlobalCount(showData.cfgId)

	if cfgData.ServersReward > 0 then
		local remain = cfgData.ServersReward - globalCount
		itemlua.green:SetActive(remain > 0)
		itemlua.red:SetActive(remain == 0)
		itemlua.number.text.text = remain.."/"..cfgData.ServersReward
	end

	local globalLack = (globalCount >= cfgData.ServersReward and cfgData.ServersReward > 0)
	itemlua.mask:SetActive(showData.rewardNum >= cfgData.Number)

	local enough = true
	local maxExchangeCount = Mathf.Infinity
	for i = 1, #cfgData.ExchangeCondition do
		local reward = cfgData.ExchangeCondition[i]
		local curNum = CommonUtil.GetOwnResCountByItemId(reward[1])
		if curNum < reward[2] then
			enough = false
		else
			local count = math.floor(curNum / reward[2])
			if count < maxExchangeCount then
				maxExchangeCount = count
			end
		end
		local condata = {cfgId = reward[1], num = reward[2]}
		local itemGo = itemlua["coastItem"..(i-1)]
		itemGo:SetActive(true)

		IconItemCtr:SetData(self,itemGo.iconSmallItem1,condata, Enum.ItemIEnterType.Bag, self, self.OnItemClick)
		itemGo.iconSmallItem1.num:SetActive(false)

		local curNumStr = curNum < reward[2] and string.format(Constant.RedColorText, curNum) or string.format(Constant.GreenColorText, curNum)
		itemlua["text"..i].text.text = curNumStr.."/"..reward[2]
	end

	local remainTimes = cfgData.Number - showData.rewardNum
	if maxExchangeCount > remainTimes then
		maxExchangeCount = remainTimes
	end
	local rewarddata = nil
	rewarddata = { cfgId = cfgData.Reward[1][1], num = cfgData.Reward[1][2]}
	itemlua.reward.iconSmallItem2:SetActive(true)
	itemlua.numberReward.text.text = remainTimes
	if rewarddata~= nil  then
		IconItemCtr:SetData(self, itemlua.reward.iconSmallItem2, rewarddata, Enum.ItemIEnterType.Bag, self, self.OnItemClick)
	end

	itemlua.uIRedPointRP:SetActive(not showData.isNotice and enough and cfgData.Number > showData.rewardNum and ((globalCount < cfgData.ServersReward and cfgData.ServersReward > 0) or cfgData.ServersReward == 0))
	self.uiBase:AddButtonUniqueEventListener(itemlua.button.button, self, self.OnChipClick, itemIndex, enough, globalLack, maxExchangeCount)
	self.uiBase:AddButtonUniqueEventListener(itemlua.dscReminder.button, self, self.OnNoticeButtonClick, itemIndex)
	return item
end

function UIActivityChipRewardComView:OnNoticeButtonClick(button,param)
	local idx = param[0]
	if self.isCanSendRedNoticeReq then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("FrequentOperation")
		return
	end
	local showData = self.controller:GetChipShowDataByIdx(idx)
	if showData then
		self.isCanSendRedNoticeReq = true
		local activity_id = self.controller:GetActId()
		local data = {activity_id = activity_id, collect_id = showData.cfgId, no_notice = not showData.isNotice}
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVITIES_WORD_NOTICE_SET_REQ,data)
		if not self.ReqLimitTimer then
			self.ReqLimitTimer = Timer.New(slot(self.ReqLimitUpdate, self), 0.5, -1)
		end
		if not self.ReqLimitTimer.running then
			self.ReqLimitTimer:Start()
		end
	end
end

function UIActivityChipRewardComView:ReqLimitUpdate()
	self.isCanSendRedNoticeReq = false
	if self.ReqLimitTimer then
		self.ReqLimitTimer:Stop()
	end
end

function UIActivityChipRewardComView:IsNoticeRefresh(cfgId)
	local showData,idx = self.controller:GetChipShowDataByCfgId(cfgId)
	if showData then
		local itemLua = self:GetShowItemByIdx(idx - 1)
		if itemLua then
			local cfgData = ManagerContainer.CfgMgr:GetActivitiesCollectionCfgById(showData.cfgId)
			local globalCount = self.controller:GetGlobalCount(showData.cfgId)
			local enough = true
			for i = 1, #cfgData.ExchangeCondition do
				local reward = cfgData.ExchangeCondition[i]
				local curNum = CommonUtil.GetOwnResCountByItemId(reward[1])
				if curNum < reward[2] then
					enough = false
				end
			end
			itemLua.checkmark:SetActive(not showData.isNotice)
			itemLua.uIRedPointRP:SetActive(not showData.isNotice and enough and cfgData.Number > showData.rewardNum and ((globalCount < cfgData.ServersReward and cfgData.ServersReward > 0) or cfgData.ServersReward == 0))
		end
	end
end

function UIActivityChipRewardComView:GetShowItemByIdx(idx)
    local item = self.boxExchange.loopListView:GetShownItemByItemIndex(idx)
    if item then
        local itemlua = CommonUtil.GetBindGridViewItem2Lua(self, "ExchangeItem", item.gameObject)
        return itemlua
    end
end

function UIActivityChipRewardComView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIActivityChipRewardComView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.backBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.btnInfo.button, self, self.OnClickPlayRuleBtn)
end

function UIActivityChipRewardComView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', "SetsWordActivityText"})
end

function UIActivityChipRewardComView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
	if self.uiBase.MSourceUIID > 0 then
		ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID)
	end
end

function UIActivityChipRewardComView:OnChipClick(button, params)
	local idx = params[0]
	local enough = params[1]
	local globalEnough = params[2]
	local maxExchangeCount = params[3]

	if globalEnough then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("SetsWordActivity05")
		return
	end

	if not enough then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("SetsWordActivity01")
		return
	end

	local showData = self.controller:GetChipShowDataByIdx(idx)
	local cfgData = ManagerContainer.CfgMgr:GetActivitiesCollectionCfgById(showData.cfgId)
	if not cfgData then return end

	local data = {cfgId = cfgData.Reward[1][1], count = cfgData.Reward[1][2], maxExchangeCount = maxExchangeCount, idx = idx, owner = self, ownerCB = self.ItemClick1Sure,EnterType = Enum.UIPageName.UIActivityChipRewardCom}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UITipsExchange, data)
	--local data = {"ActivityCollectTip",nil,idx,self,self.ItemClick1Sure}
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
end

function UIActivityChipRewardComView:ItemClick1Sure(idx, num)
	self.controller:SendGetActivityRewardReq(idx, num)
end

function UIActivityChipRewardComView:OnItemClick(button,params)
	local data = params[0]
	local data1 = clone(data)
	--玉如意单独提示预览时间语言包 暂写死
	if data.cfgId == 15024 then
		data1.isPreview = true
	end
	ManagerContainer.LuaUIMgr:OpenTips(data1)
end

function UIActivityChipRewardComView:OnHide()

end

function UIActivityChipRewardComView:OnShow(data)
	self.controller:SetData(data)

end

function UIActivityChipRewardComView:OnClose()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UINoticeTips)
	if self.timer then
		self.timer:Stop()
		self.timer = nil
	end
	if self.updateTimer then
		self.updateTimer:Stop()
		self.updateTimer = nil
	end
	if self.ReqLimitTimer then
		self.ReqLimitTimer:Stop()
		self.ReqLimitTimer = nil
	end
end

function UIActivityChipRewardComView:OnDispose()
	self.boxExchange.loopListView:Dispose()
	self.controller:OnDispose()
end

return UIActivityChipRewardComView



