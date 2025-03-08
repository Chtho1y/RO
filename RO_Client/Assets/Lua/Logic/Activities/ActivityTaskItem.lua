local ActivityTaskItem = class("ActivityTaskItem")

function ActivityTaskItem:ctor(taskId)
    self.taskId = taskId        --活动目标id
    self.taskType = 0           --目标类型
    self.taskDesc = 0
    self.name = nil
    self.finishedNum = 0        --目标个数
    self.rewards = nil              --完成获得的奖励
    self.gotoPageId = 0             --跳转界面id
    self.transferUnlockFunIds = nil
    self.showState = false
    self.isInited = false
    self.outOfDate = false           -- 是否超时

    self.doNum = 0              --当前完成个数
    self.isGotReward = false        --是否领取奖励
    self.showPriority = 2        
    self:Init()
end

function ActivityTaskItem:Init()
    local cfg = ManagerContainer.CfgMgr:GetActivityTaskCfgById(self.taskId)
    if cfg == nil then
        LogError(self.taskId .. " 在ActivityTaskCfg 表中未配置!!!!!!!")
        self.isInited = false
        return
    end

    if cfg.TaskCondition ~= nil then
        local len = #cfg.TaskCondition[1]
        self.taskType = cfg.TaskCondition[1][1]
        self.finishedNum = cfg.TaskCondition[1][len]
    end

    self.name = cfg.Title
    self.taskDesc = cfg.Desc
    self.rewards = cfg.Reward
    self.gotoPageId = cfg.GoPageId
    self.showState = cfg.ShowState
    self.transferUnlockFunIds = cfg.UnlockFunIds        
    self.showPriority = 2
    self.isInited = true
end

function ActivityTaskItem:SetDoNum(num)
    self.doNum = num or 0
    if self:IsFinished() then
        self.showPriority = 1
    else
        self.showPriority = 2
    end
end

function ActivityTaskItem:IsGotReward()
    return self.isGotReward
end

function ActivityTaskItem:IsFinished()
    return self.doNum >= self.finishedNum
end

function ActivityTaskItem:IsOutofDate()
    return self.outOfDate
end

function ActivityTaskItem:SetOutofDate(bOut)
    if self:IsFinished() then
        return
    end
    self.outOfDate = bOut
    if self.outOfDate then
        self.showPriority = 4
    end
end

function ActivityTaskItem:ShowRewards()
    return self.rewards
end

function ActivityTaskItem:SyncServerData(taskData)
    if taskData.progress ~= nil and  #taskData.progress > 0 then
        self:SetDoNum(taskData.progress[1].value)
    else
        self:SetDoNum(0)
    end

    self.isGotReward = (taskData.state == 2)
    if self.isGotReward then
        self.showPriority = 3
    end
end

function ActivityTaskItem:HasRedPoint()
    return (self:IsFinished() and (not self.isGotReward))
end

function ActivityTaskItem:CanJump()
    if self.transferUnlockFunIds == nil then
        return true
    end

    for i = 1, #self.transferUnlockFunIds do
        local funId = self.transferUnlockFunIds[i]
        if not ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(funId) then
            return false
        end
    end

    return true
end

return ActivityTaskItem