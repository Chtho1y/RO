local ActivityDailyComulativeRechargeItem = class('ActivityDailyComulativeRechargeItem', require('Activities/ActivityTypeItem'))

function ActivityDailyComulativeRechargeItem:ctor()
    self.curDay = 0
    self.rewardState = 0
    self.redPointType = Enum.RPNotifyType.DailyRecharge
end

function ActivityDailyComulativeRechargeItem:SyncSrvData(serverData)
    self.curDay = serverData[1]
    self.rewardState = serverData[3]
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Activity_Daily_Comulative_Refresh)
end

function ActivityDailyComulativeRechargeItem:SyncCurDayEndTime(curDayEndTime)
    return true
end

function ActivityDailyComulativeRechargeItem:SyncRewardState(rewardStateServer)
    return true
end

function ActivityDailyComulativeRechargeItem:GetCurDay()
    return self.curDay
end

function ActivityDailyComulativeRechargeItem:GetRewardState()
    return self.rewardState
end

function ActivityDailyComulativeRechargeItem:HasRedPoint()
    local displayCfgData = ManagerContainer.CfgMgr:GetNextActivitiesTiredChargeCfgById(self.rewardState, self.curDay)
    if not displayCfgData then return false end

    local dailyTiredCount = ManagerContainer.PayMgr:GetDayRecharge()
    return self.rewardState < displayCfgData.Id and dailyTiredCount >= displayCfgData.RechargeAmount
end

return ActivityDailyComulativeRechargeItem