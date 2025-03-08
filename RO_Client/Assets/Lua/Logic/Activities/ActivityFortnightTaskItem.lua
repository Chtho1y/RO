local ActivityFortnightTaskItem = class("ActivityFortnightTaskItem",require("Activities/ActivityTypeItem"))
local ActivityTaskItem = require("Activities/ActivityTaskItem")
local ActivityTaskBoxItem = require("Activities/ActivityTaskBoxItem")

function ActivityFortnightTaskItem:ctor()
    self.curDay = 0
    self.curDayEndTime = 0
    self.taskScore = 0 
    self.totalTaskScore = 0
    self.taskScoreReward = 0
    self.taskList = nil
    self.boxRewards = nil
    self.curShowBoxType = 0
    self:InitData()
end

function ActivityFortnightTaskItem:GetBg()
    local subfix = "_7"
    if self.curDay > 7 then
        subfix = "_14"
    end

    return self.bg .. subfix
end

function ActivityFortnightTaskItem:InitData()
    self.data = {}
    self.taskList = {}
    local cfgList = ManagerContainer.CfgMgr:GetFortnightDaysCfg()
    if cfgList ~= nil  then
        for i = 1, 14 do
            local cfg = cfgList[i]
            if cfg ~= nil then
                local taskList1 = {}
                local taskList2 = {}
                if cfg.TaskIds ~= nil then
                    for j = 1, #cfg.TaskIds do
                        local task = ActivityTaskItem:new(cfg.TaskIds[j])
                        taskList1[#taskList1 + 1]  = task
                        self.taskList[#self.taskList+1] = task
                    end
                end

                if cfg.DailyTaskIds ~= nil then
                    for j = 1, #cfg.DailyTaskIds do
                        local task = ActivityTaskItem:new(cfg.DailyTaskIds[j])
                        taskList2[#taskList2 + 1]  = task
                        self.taskList[#self.taskList+1] = task
                    end
                end

                self.data[#self.data+1] = {day = i, gTasks = taskList1, dTasks = taskList2}
            end
        end
    end
    self:SetRPType(Enum.RPNotifyType.FortnightTaskReward)
end

function ActivityFortnightTaskItem:RefreshBoxReward(pageId)
    self:InitBoxReward(pageId)
    self:RefreshBoxRewardState()
end

function ActivityFortnightTaskItem:InitBoxReward(boxType)
    if self.curShowBoxType == boxType then
        return
    end
    self.totalTaskScore = 0
    self.boxRewards = {}
    local cfgList = ManagerContainer.CfgMgr:GetActivityRewardCfg()
    if cfgList ~= nil then
        for k,v in pairs(cfgList) do
            if v.Type == boxType then
                local box = ActivityTaskBoxItem:new(v)
                self.boxRewards[#self.boxRewards+1] = box
                if box.score > self.totalTaskScore then
                    self.totalTaskScore = box.score
                end
            end
        end
    end

    if #self.boxRewards > 1 then
        table.sort(
            self.boxRewards,
            function(a, b)
                return a.score < b.score
            end
        )
    end
end

function ActivityFortnightTaskItem:RefreshBoxRewardState()
    if self.boxRewards == nil then
        return 
    end

    -- LogError(" taskScoreReward = " .. self.taskScoreReward)
    for i = 1, #self.boxRewards do
        local box = self.boxRewards[i]
        if self.taskScore >= box.score then
            box:SetCanGet(true)
        else
            box:SetCanGet(false)
        end
        local val = math.pow(2, box.boxId)
        if CommonUtil.And(self.taskScoreReward, val) == val then
            box:SetGoReward(true)
        else
            box:SetGoReward(false)
        end
    end
end

function ActivityFortnightTaskItem:GetBoxRewards(pageId)
    self:RefreshBoxReward(pageId)
    return self.boxRewards
end

function ActivityFortnightTaskItem:SyncSrvData(serverData)
    if self.curDay ~=  serverData[1] then
        self.curDay = serverData[1]
        for i = 1, #self.data do
            local dTasks = self.data[i].dTasks
            for j = 1, #dTasks do
                local task = dTasks[j]
                task:SetOutofDate(i < self.curDay)
            end
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Activity_Day_Change,self.actId)
    end
    self.curDayEndTime = tonumber(tostring(serverData[2] / 1000))

    local fortnightDaysData = serverData[3]
    if fortnightDaysData ~= nil then
        self.taskScore = fortnightDaysData.task_score
        self.taskScoreReward = fortnightDaysData.task_score_reward
    
        local taskList = fortnightDaysData.task_list
        for i = 1, #taskList do
            local taskData = taskList[i]
            local task = self:GetTaskById(taskData.task_id)
            if task ~= nil then
                task:SyncServerData(taskData)

                local isLimitedTask, inDay = self:IsLimitedTask(taskData.task_id)
                if isLimitedTask then
                    task:SetOutofDate(inDay < self.curDay)
                end
            end
        end 
    end

    for i = 1, #self.data do
        self:SortTask(self.data[i].gTasks)
        self:SortTask(self.data[i].dTasks)
    end

    if self.curDay <= 7 then
        self:InitBoxReward(1)
    else
        self:InitBoxReward(2)
    end
    self:RefreshBoxRewardState()
end

function ActivityFortnightTaskItem:IsLimitedTask(taskId)
    if self.data == nil then
        return false, nil
    end

    for i = 1, #self.data do
        local dTasks = self.data[i].dTasks
        for j = 1, #dTasks do
            if dTasks[j].taskId == taskId then
                return true, i 
            end
        end
    end
    return false, nil
end

function ActivityFortnightTaskItem:SortTask(taskList)
    if taskList == nil or #taskList < 2 then
        return
    end

    table.sort(
        taskList,
        function(a, b)
            if  a.showPriority < b.showPriority then
                return true
            elseif a.showPriority > b.showPriority then
                return false
            else
                return a.taskId < b.taskId
            end
        end
    )
end

function ActivityFortnightTaskItem:GetTaskById(id)
    if self.taskList == nil then
        return nil
    end

    for i = 1, #self.taskList do
        if self.taskList[i].taskId == id then
            return self.taskList[i]
        end
    end

    return nil
end

function ActivityFortnightTaskItem:GetTaskListByDay(day)
    if self.data == nil then
        return nil
    end

    for i = 1, #self.data do
        if self.data[i].day == day then
            return self.data[i]
        end
    end
    return nil
end

function ActivityFortnightTaskItem:HasDayRedPoint(day)
    local data = self:GetTaskListByDay(day)
    if data == nil then
        return false
    end

    local gHasRedPoint = false
    local dHasRedPoint = false
    if data.gTasks ~= nil then
        for i =  1, #data.gTasks do
            if data.gTasks[i]:HasRedPoint() then
                gHasRedPoint = true
                break
            end
        end
    end

    if data.dTasks ~= nil then
        for i = 1, #data.dTasks do
            if data.dTasks[i]:HasRedPoint() then
                dHasRedPoint = true
                break
            end
        end
    end
    return gHasRedPoint,dHasRedPoint
end

function ActivityFortnightTaskItem:HasRedPoint()
    if self.taskList == nil then
        return false
    end

    for i = 1, #self.taskList do
        local task = self.taskList[i]
        if task:HasRedPoint() then
            return true
        end
    end

    if self.boxRewards ~= nil then
        for i = 1, #self.boxRewards do
            if self.boxRewards[i]:IsCanGet() and  not self.boxRewards[i]:IsGotReward() then
                return true
            end
        end
    end

    return false
end

function ActivityFortnightTaskItem:GetLeftTime()
    local leftTime = self.curDayEndTime - ManagerContainer.LuaTimerMgr:GetTimeSecond()
    if leftTime < 0 then
        leftTime = 0
    end
    return leftTime
end

return ActivityFortnightTaskItem