local ActivityLimitRechargeItem = class('ActivityLimitRechargeItem', require('Activities/ActivityTypeItem'))

function ActivityLimitRechargeItem:ctor()
    self.activeitesMap = {}
    self.activeitesList = {}

    self.needOpen = false
end

function ActivityLimitRechargeItem:SyncSrvData(datas, init)
    if not datas then
        return
    end
    --datas = {
    --    {
    --        activities_id = 1,
    --        start_time = int64.new('1603185150303'),
    --        end_time = int64.new('1603267780000'),
    --    },
    --    {
    --        activities_id = 2,
    --        start_time = int64.new('1603185150303'),
    --        end_time = int64.new('1603267780000'),
    --    }
    --}

    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    local cloneMap = clone(self.activeitesMap)
    self.activeitesMap = {}
    self.activeitesList = {}
    local needDisplayState = false
    for _,v in pairs(datas) do
        if curTime <= v.end_time then
            if not self.activeitesMap[v.activities_id] then
                local data = {}
                data.activitiesId = v.activities_id
                data.startTime = v.start_time
                data.endTime = v.end_time
                --data.rpState = false
                if data.endTime > 0 then
                    data.remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(data.endTime)
                end

                local cfgData = ManagerContainer.CfgMgr:GetActivitiesDiscountsCfgById(data.activitiesId)

                if cfgData then
                    self.activeitesMap[data.activitiesId] = data
                    self.activeitesList[#self.activeitesList + 1] = data
    
                    if not cloneMap[v.activities_id] then
                        if not init then
                            if cfgData.PopupWindow == 1 then
                                self.needOpen = true
                            end
                            data.rpState = true
                            self:SaveLocalRPState(data.activitiesId, data.rpState)
                        else
                            local state = self:GetLocalRPState(data.activitiesId)
                            data.rpState = state
                        end
    
                        if cfgData.TriggeringCondition then
                            if cfgData.TriggeringCondition[1][1] == Enum.UnlockChargeType.BaseLevel
                                    or cfgData.TriggeringCondition[1][1] == Enum.UnlockChargeType.PayAmount
                                    or cfgData.TriggeringCondition[1][1] == Enum.UnlockChargeType.HeroStrength
                                    or cfgData.TriggeringCondition[1][1] == Enum.UnlockChargeType.HeroLevel
                                    or cfgData.TriggeringCondition[1][1] == Enum.UnlockChargeType.SkillLevelUp
                            then
                                needDisplayState = true
                            end
                        end
                    else
                        data.rpState = cloneMap[v.activities_id].rpState
                    end
                end
            else
                local data = self.activeitesMap[v.activities_id]
                data.activitiesId = v.activities_id
                data.startTime = v.start_time
                data.endTime = v.end_time
                data.rpState = false
                self:SaveLocalRPState(data.activitiesId, data.rpState)
                if data.endTime > 0 then
                    data.remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(data.endTime)
                end
            end
        end
    end

    CommonUtil.ArraySortSelections(self.activeitesList, Enum.TableSortRule.Up, "startTime")

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.LIMIT_RECHARGE_OPEN_NTF)

    if needDisplayState then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.LIMIT_RECHARGE_OPEN_UI_NTF)
    end

    self:RefreshLimitRechargeRPState()

    self:StopTimer()
    if #self.activeitesList > 0 then
        self.updateTimer = Timer.New(function()
            self:UpdateActivitiesTime()
        end, 1, -1)
        self.updateTimer:Start()
    end
end

function ActivityLimitRechargeItem:SaveLocalRPState(id, state)
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    UnityEngine.PlayerPrefs.SetInt(tostring(uid).."_ActivityLimitRecharge_"..tostring(id), state and 1 or 0)
end

function ActivityLimitRechargeItem:GetLocalRPState(id)
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    local state = UnityEngine.PlayerPrefs.GetInt(tostring(uid).."_ActivityLimitRecharge_"..tostring(id))
    return state == 1
end

function ActivityLimitRechargeItem:UpdateActivitiesTime()
    local removed = false
    for i = #self.activeitesList, 1, -1 do
        local data = self.activeitesList[i]
        data.remainTime = data.remainTime - 1
        if data.remainTime <= 0 then
            self.activeitesMap[data.activitiesId] = nil
            table.remove(self.activeitesList, i)
            removed = true
        end
    end
    if removed then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.LIMIT_RECHARGE_OPEN_NTF)
    end

    if #self.activeitesList == 0 then
        self:StopTimer()
    end
end

function ActivityLimitRechargeItem:StopTimer()
    if self.updateTimer then
        self.updateTimer:Stop()
        self.updateTimer = nil
    end
end

function ActivityLimitRechargeItem:GetRemainTime(id)
    if not self.activeitesMap[id] then return 0 end
    return FormatTime2(self.activeitesMap[id].remainTime)
end

function ActivityLimitRechargeItem:RemoveEndTimeActivity(id)
    for i = 1, #self.activeitesList do
        if self.activeitesList[i].activitiesId == id then
            self.activeitesMap[self.activeitesList[i].activitiesId] = nil
            table.remove(self.activeitesList, i)
            return
        end
    end
end

function ActivityLimitRechargeItem:RefreshRemainTime(id)
    if not self.activeitesMap[id] then return 0 end

    if self.activeitesMap[id].remainTime <= 0 then return end
    self.activeitesMap[id].remainTime = self.activeitesMap[id].remainTime - 1
    return FormatTime2(self.activeitesMap[id].remainTime)
end

function ActivityLimitRechargeItem:HasOpened(id)
    self.needOpen = false

    if self.activeitesMap[id] then
        self.activeitesMap[id].rpState = false
        self:SaveLocalRPState(id, false)
    end

    self:RefreshLimitRechargeRPState()
end

function ActivityLimitRechargeItem:GetCount()
    return #self.activeitesList
end

function ActivityLimitRechargeItem:RefreshLimitRechargeRPState()
    for _,v in pairs(self.activeitesMap) do
        if v.rpState then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.LimitRecharge, true)
            return
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.LimitRecharge, false)
end

function ActivityLimitRechargeItem:AutoGetOpenActivityId()
    if #self.activeitesList == 0 then return end

    for i = #self.activeitesList, 1, -1 do
        local data = self.activeitesList[i]
        if data.rpState then
            return data.activitiesId, i
        end
    end
    return self.activeitesList[1].activitiesId, 1
end

function ActivityLimitRechargeItem:GetIdxById(id)
    for i = #self.activeitesList, 1, -1 do
        local data = self.activeitesList[i]
        if data.activitiesId == id then
            return i
        end
    end
    return
end

function ActivityLimitRechargeItem:GetIdByIdx(idx)
    for i = #self.activeitesList, 1, -1 do
        local data = self.activeitesList[i]
        if i == idx then
            return data.activitiesId
        end
    end
    return
end

function ActivityLimitRechargeItem:GetLimitDataByIdx(idx)
    return self.activeitesList[idx]
end

function ActivityLimitRechargeItem:IsLimitRechargeExist()
    if #self.activeitesList == 0 then return false end

    local result = false
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    for _,v in pairs(self.activeitesMap) do
        if v.endTime > 0 and curTime < v.endTime then
            result = true
            break
        end
    end
    return result
end

return ActivityLimitRechargeItem