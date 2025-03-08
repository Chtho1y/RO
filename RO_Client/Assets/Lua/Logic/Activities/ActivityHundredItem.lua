local ActivityHundredItem = class("ActivityHundredItem",require("Activities/ActivityTypeItem"))

function ActivityHundredItem:ctor()
    self.reachTime = nil
    self.rewardStateServer = nil
    self.curDayEndTime = nil
    self.rewardStates = {}
    self.hasReward = false
    self.redPointType = Enum.RPNotifyType.HundredRecharge
end

function ActivityHundredItem:SyncSrvData(serverData, curDayEndTime)
    self.reachTime = serverData.param_time
    self.rewardStateServer = serverData.reward_state
    self.curDayEndTime = curDayEndTime
    self:CheckRewardState()
end

function ActivityHundredItem:SyncCurDayEndTime(curDayEndTime)
    if self.curDayEndTime == curDayEndTime then return false end
    self.curDayEndTime = curDayEndTime
    self:CheckRewardState()
    return true
end

function ActivityHundredItem:CheckRewardState()
    local remainTime = -1
    if self.reachTime and self.reachTime > 0 and self.curDayEndTime and self.curDayEndTime > 0 then
        remainTime = self.curDayEndTime - self.reachTime
        remainTime = remainTime / 1000
        remainTime = type(remainTime) == "number" and remainTime or #remainTime
    end
    local hasReward = false
    if remainTime > 172800 then
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
    elseif remainTime > 86400 then
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

function ActivityHundredItem:HasRedPoint()
    return self.hasReward
end

function ActivityHundredItem:GetRewardState()
    if self.hasReward then
        return Enum.ActivityRewardState.Got
    end
    if (self.reachTime and self.reachTime > 0) then
        return Enum.ActivityRewardState.GotAndHas
    end
    return Enum.ActivityRewardState.NotGot
end

function ActivityHundredItem:GetRewardStateByDay(day)
    return self.rewardStates[day] or Enum.ActivityRewardState.NotGot
end


return ActivityHundredItem