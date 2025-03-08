local UIActivityFirstRechargeCtr = class("UIActivityFirstRechargeCtr", require("UICtrBase"))

function UIActivityFirstRechargeCtr:Init(view)
	self.view = view
end

function UIActivityFirstRechargeCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIActivityFirstRechargeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIActivityFirstRechargeCtr:GetData()
	return self.data
end

function UIActivityFirstRechargeCtr:GetActId()
	return self.data.actId
end

function UIActivityFirstRechargeCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.giftType = nil
	self.cfgData = nil
	self.activityData = nil
	self.dayIdx = nil
end

function UIActivityFirstRechargeCtr:InitData()
	self.giftType = 1
	if self.view and self.view.uiBase and self.view.uiBase.MSourceUIID == Enum.UIPageName.UINotifyActivityTips then
		self.giftType = 2
	end
	self:RefreshData()
end

function UIActivityFirstRechargeCtr:RefreshData()
	if self.giftType then
		self.cfgData = ManagerContainer.CfgMgr:GetFirstChargeCfgById(self.giftType)
		if self.giftType == 1 then
			self.activityData = ManagerContainer.DataMgr.ActsDataMgr:GetFirstRechargeItem()
		else
			self.activityData = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemByType(Enum.ActivityType.ACTIVITY_TYPE_HUNDRED_Task)
		end
	else
		self.cfgData = nil
	end
	self.dayIdx = 1
end

function UIActivityFirstRechargeCtr:GetGiftType()
	return self.giftType
end

function UIActivityFirstRechargeCtr:ChangeGiftType(giftType)
	if self.giftType == giftType then
		return false
	end
	self.giftType = giftType
	self:RefreshData()
	return true
end

function UIActivityFirstRechargeCtr:GetDayIdx()
	return self.dayIdx
end

function UIActivityFirstRechargeCtr:ChangeDayIdx(dayIdx)
	if self.dayIdx == dayIdx then
		return false
	end
	self.dayIdx = dayIdx
	return true
end


function UIActivityFirstRechargeCtr:GetCfgData()
	return self.cfgData
end


function UIActivityFirstRechargeCtr:GetActivityData()
	return self.activityData
end

function UIActivityFirstRechargeCtr:GetRewardStateByDay(day)
	return self.activityData and self.activityData:GetRewardStateByDay(day) or Enum.ActivityRewardState.NotGot
end

function UIActivityFirstRechargeCtr:GetRewardState()
	return self.activityData and self.activityData:GetRewardState() or Enum.ActivityRewardState.NotGot
end

function UIActivityFirstRechargeCtr:GetTargetRechargeInfo()
	local curNum = 0
	if ManagerContainer.PayMgr then
		curNum = ManagerContainer.PayMgr:GetTotalRecharge()
	end
	local targetNum = self.cfgData and self.cfgData.RechargeAmount or 0
	targetNum = targetNum - curNum
	if targetNum < 0 then targetNum = 0 end
	return curNum, targetNum
end

function UIActivityFirstRechargeCtr:SendGetReward()
	if self.giftType == 1 then
		ManagerContainer.DataMgr.ActsDataMgr:SendGetFirstRechargeRewardReq()
	else
		if self.activityData then
			ManagerContainer.DataMgr.ActsDataMgr:SendGetActivityRewardReq(self.activityData.actId)
		end
	end
end


return UIActivityFirstRechargeCtr

