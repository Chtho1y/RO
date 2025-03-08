local ActivityFirstRechargeItem = class('ActivityFirstRechargeItem', require('Activities/ActivityTypeItem'))

function ActivityFirstRechargeItem:ctor()
    self.reachTime = nil
    self.rewardStateServer = nil
    self.curDayEndTime = nil
    self.rewardStates = {}
    self.hasReward = false
    self.redPointType = Enum.RPNotifyType.FirstRecharge
end

function ActivityFirstRechargeItem:SyncSrvData(serverData, curDayEndTime)
    self.reachTime = serverData.first_charge_time
    self.rewardStateServer = serverData.first_charge_reward_state
    self.curDayEndTime = curDayEndTime
    self:CheckRewardState()
end

function ActivityFirstRechargeItem:SyncCurDayEndTime(curDayEndTime)
    if self.curDayEndTime == curDayEndTime then return false end
    self.curDayEndTime = curDayEndTime
    self:CheckRewardState()
    return true
end

function ActivityFirstRechargeItem:SyncRewardState(firstChargeTime, rewardStateServer)
    if self.firstChargeTime == firstChargeTime
        and self.rewardStateServer == rewardStateServer
    then
        return false
    end
    self.firstChargeTime = firstChargeTime
    self.rewardStateServer = rewardStateServer
    self:CheckRewardState()
    return true
end

function ActivityFirstRechargeItem:CheckRewardState()
    local remainTime = -1
    if self.reachTime and self.reachTime > 0 and self.curDayEndTime and self.curDayEndTime > 0 then
        remainTime = self.curDayEndTime - self.reachTime
        remainTime = remainTime / 1000
        remainTime = type(remainTime) == "number" and remainTime or #remainTime
    end
    local hasReward = false
    if remainTime >= 172800 then
        if (Bit.band(self.rewardStateServer, 2) == 2) then
            self.rewardStates[1] = Enum.ActivityRewardState.GotAndHas
        else
            self.rewardStates[1] = Enum.ActivityRewardState.Got
            hasReward = true
        end
        if (Bit.band(self.rewardStateServer, 4) == 4) then
            self.rewardStates[2] = Enum.ActivityRewardState.GotAndHas
        else
            self.rewardStates[2] = Enum.ActivityRewardState.Got
            hasReward = true
        end
        if (Bit.band(self.rewardStateServer, 8) == 8) then
            self.rewardStates[3] = Enum.ActivityRewardState.GotAndHas
        else
            self.rewardStates[3] = Enum.ActivityRewardState.Got
            hasReward = true
        end
    elseif remainTime >= 86400 then
        if (Bit.band(self.rewardStateServer, 2) == 2) then
            self.rewardStates[1] = Enum.ActivityRewardState.GotAndHas
        else
            self.rewardStates[1] = Enum.ActivityRewardState.Got
            hasReward = true
        end
        if (Bit.band(self.rewardStateServer, 4) == 4) then
            self.rewardStates[2] = Enum.ActivityRewardState.GotAndHas
        else
            self.rewardStates[2] = Enum.ActivityRewardState.Got
            hasReward = true
        end
        self.rewardStates[3] = Enum.ActivityRewardState.NotGot
    elseif remainTime >= 0 then
        if (Bit.band(self.rewardStateServer, 2) == 2) then
            self.rewardStates[1] = Enum.ActivityRewardState.GotAndHas
        else
            self.rewardStates[1] = Enum.ActivityRewardState.Got
            hasReward = true
        end
        self.rewardStates[2] = Enum.ActivityRewardState.NotGot
        self.rewardStates[3] = Enum.ActivityRewardState.NotGot
    else
        self.rewardStates[1] = Enum.ActivityRewardState.NotGot
        self.rewardStates[2] = Enum.ActivityRewardState.NotGot
        self.rewardStates[3] = Enum.ActivityRewardState.NotGot
    end
    self.hasReward = hasReward
end

function ActivityFirstRechargeItem:HasRedPoint()
    return self.hasReward
end

function ActivityFirstRechargeItem:GetRewardState()
    if self.hasReward then
        return Enum.ActivityRewardState.Got
    end
    if (self.reachTime and self.reachTime > 0) then
        return Enum.ActivityRewardState.GotAndHas
    end
    return Enum.ActivityRewardState.NotGot
end

function ActivityFirstRechargeItem:GetRewardStateByDay(day)
    return self.rewardStates[day] or Enum.ActivityRewardState.NotGot
end

function ActivityFirstRechargeItem:IsAllRewardGotAndHas()
    if not self.rewardStates then return false end
    for _, rewardState in pairs(self.rewardStates) do
        if rewardState ~= Enum.ActivityRewardState.GotAndHas then
            return false
        end
    end
    return true
end


function ActivityFirstRechargeItem:IsNeedOpen()
    if self:IsAllRewardGotAndHas() then
        return false
    end
    if not ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(66) then
        return false
    end

    local isOpenState = ManagerContainer.PlayerPrefsMgr:GetBoolean("FirstRechargeOpenState", false)
    if not isOpenState then
        ManagerContainer.PlayerPrefsMgr:SetBoolean("FirstRechargeOpenState", true)
        return true
    end
    return false
end


return ActivityFirstRechargeItem