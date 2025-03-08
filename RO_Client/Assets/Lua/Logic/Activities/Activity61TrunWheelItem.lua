local Activity61TrunWheelItem = class("Activity61TrunWheelItem",require("Activities/ActivityTypeItem"))

function Activity61TrunWheelItem:ctor()
    self.redPointType = Enum.RPNotifyType.Activity61Days
    self.wheel_data = nil
    self.ActivityData = require("SeasonTurnWheel/TrunWheeActivtylDataMgr"):new()
    self.ActivityData:SetCurActivity(self)
    self.ActivityData:RegisterNetEvents()
end

function Activity61TrunWheelItem:HasRedPoint()
    if self:LeftTime() > 0 then
        return true      
    else
        return false
    end
end

function Activity61TrunWheelItem:SyncSrvData(serverData)    
    self.wheel_data = serverData[3]    
    self.ActivityData:OnDataChangeNtf(self.wheel_data)
end

function Activity61TrunWheelItem:GetActivityData()
    return self.ActivityData
end

return Activity61TrunWheelItem