local ActivitySignItem = class("ActivitySignItem",require("Activities/ActivityTypeItem"))

function ActivitySignItem:ctor()
    self.canSignToday = false
    self.currSignDay = 0
end

function ActivitySignItem:HasRedPoint()
    return self:GetCanSignToDay()
end

function ActivitySignItem:SyncSrvData(serverData)    
    local sing_data = serverData[3]
    if not sing_data then
        return
    end
    self.currSignDay = sing_data.sign_days
    self.next_sign_time = sing_data.next_sign_time
end

function ActivitySignItem:GetCanSignToDay()
    local signTime = self.next_sign_time
    local currTime =     ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    if signTime and  signTime > 0  and signTime <=  currTime then
        self.canSignToday = true
    else
        self.canSignToday = false
    end
    return self.canSignToday
end

function ActivitySignItem:GetSignDays()
    return self.currSignDay
end

function ActivitySignItem:GetActivityData()
    return self.ActivityData
end

return ActivitySignItem