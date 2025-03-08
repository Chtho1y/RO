local ActivityKingTaskItem = class("ActivityKingTaskItem",require("Activities/ActivityTypeItem"))
local ActivityTaskItem = require("Activities/ActivityTaskItem")

function ActivityKingTaskItem:ctor()
    self.curDay = 0
    self.curDayEndTime = 0
    self.taskList = nil
    self.dayTaskList = nil

    self.redPointType = Enum.RPNotifyType.KingTask
end

function ActivityKingTaskItem:SyncSrvData(serverData)
    if not self.taskList then
        self.taskList = {}
    end
    if not self.dayTaskList then
        self.dayTaskList = {}
    end
    if self.curDay ~=  serverData[1] then
        self.curDay = serverData[1]
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Activity_Day_Change,self.actId)
    end
    self.curDayEndTime = tonumber(tostring(serverData[2] / 1000))

    local idx = 0
    local kingTasks = serverData[3]
    for i = 1, #kingTasks do
        local taskData = kingTasks[i]
        local task = self:GetTaskById(taskData.task_id)
        if not task then
            task = ActivityTaskItem:new(taskData.task_id)
            if taskData.task_type == 5 then
                self.taskList[#self.taskList+1] = task
            else
                idx = idx + 1
                if idx == 1 then
                    self.dayTaskList = {}
                end
                self.dayTaskList[#self.dayTaskList+1] = task
            end
            --if task.taskType == Enum.TaskType.Eve_Fight_value then
            --    LogHRWarning(Inspect(taskData))
            --    task.doNum = serverData[4]
            --    task.finishedNum = task.finishedNum + serverData[4]
            --    task.finishedNum1 = ManagerContainer.DataMgr.UserData:GetTotalFightPower()
            --
            --    task.progress = (task.finishedNum1 - task.doNum)/(task.finishedNum - task.doNum)
            --
            --    task.SyncServerData = function(task1, taskData1)
            --        if taskData1.progress ~= nil and  #taskData1.progress > 0 then
            --            task1:IsFinished(taskData1.progress[1].value)
            --        end
            --
            --        task1.isGotReward = (taskData1.state == 2)
            --        if task1.isGotReward then
            --            task1.showPriority = 3
            --        end
            --    end
            --    task.IsFinished = function(task1)
            --        return task1.finishedNum1 >= task.finishedNum
            --    end
            --    task.SetOutofDate = function(task1, bOut)
            --        if task1:IsFinished() then
            --            return
            --        end
            --        task1.outOfDate = bOut
            --        if task1.outOfDate then
            --            task1.showPriority = 4
            --        end
            --    end
            --end
        else
            --if task.taskType == Enum.TaskType.Eve_Fight_value then
            --    LogHRWarning(Inspect(taskData))
            --    local fighter = ManagerContainer.DataMgr.UserData:GetTotalFightPower()
            --    task.finishedNum1 = taskData.progress and taskData.progress[1].value or fighter
            --    task.progress = (task.finishedNum1 - task.doNum)/(task.finishedNum - task.doNum)
            --end
        end
        task:SyncServerData(taskData)
    end

    self:SortTask(self.taskList)
    self:SortTask(self.dayTaskList)
end

function ActivityKingTaskItem:SortTask(taskList)
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

function ActivityKingTaskItem:GetTaskById(id)
    if self.taskList == nil then
        return nil
    end

    for i = 1, #self.taskList do
        if self.taskList[i].taskId == id then
            return self.taskList[i]
        end
    end

    for i = 1, #self.dayTaskList do
        if self.dayTaskList[i].taskId == id then
            return self.dayTaskList[i]
        end
    end

    return nil
end

function ActivityKingTaskItem:GetTaskList()
    return self.taskList
end

function ActivityKingTaskItem:GetDayTaskList()
    return self.dayTaskList
end

function ActivityKingTaskItem:HasRedPoint()
    return self:HasGrowTaskRP() or self:HasDayTaskRP()
end

function ActivityKingTaskItem:HasGrowTaskRP()
    if self.taskList == nil then
        return false
    end
    for i = 1, #self.taskList do
        local task = self.taskList[i]
        if task:HasRedPoint() then
            return true
        end
    end
    return false
end

function ActivityKingTaskItem:HasDayTaskRP()
    if self.dayTaskList == nil then
        return false
    end
    for i = 1, #self.dayTaskList do
        local task = self.dayTaskList[i]
        if task:HasRedPoint() then
            return true
        end
    end
    return false
end

function ActivityKingTaskItem:GetDayLeftTime()
    local leftTime = self.curDayEndTime - ManagerContainer.LuaTimerMgr:GetTimeSecond()
    if leftTime < 0 then
        leftTime = 0
    end
    return leftTime
end

return ActivityKingTaskItem