local StageGoalData = class("StageGoalData", require("DataBase"))
local ProtocalDataNormal = require("ProtocalDataNormal")

function StageGoalData:ctor()
    self.data = {}
end

function StageGoalData:InitGoalData(data)
    self.data.goalData = ProtocalDataNormal.ParseTaskData(data)
end

function StageGoalData:GetCurGoalData()
    return self.data.goalData
end

function StageGoalData:GetCurGoalDataProgress()
    local num = 0
    if self.data.goalData == nil then return num end
    for k,v in pairs(self.data.goalData.progress) do
        num = num + v.value
    end
    return num
end

function StageGoalData:RegisterNetEvents()
    --ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_MAIN_TASK_CHANGE_NTF, function(data)
    --    self:InitGoalData(data.task_data)
    --    local progress = self:GetCurGoalDataProgress()
    --    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.STAGEGOAL_DATA_REFRESH, progress > 0)
    --end)
    --ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GET_MAIN_TASK_REWARD_ACK, function(data)
    --    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.STAGEGOAL_AWARDED, data.item_list)
    --end)
end

function StageGoalData:Clear()
    self.data = {}
end

function StageGoalData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function StageGoalData:UnRegisterNetEvents()

end

return StageGoalData