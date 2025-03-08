local ActivityPetRewardItem = class("ActivityPetRewardItem",require("Activities/ActivityTypeItem"))

function ActivityPetRewardItem:ctor(actId)
    self.redPointType = Enum.RPNotifyType.ActivityCollect
    self.data = {}
    self.map = {}
    self.globalMap = {}

    self:InitData(actId)
end

function ActivityPetRewardItem:InitData(actId)
    self.data = {}
    self.map = {}
    local cfgList = ManagerContainer.CfgMgr:GetActivitiesPetExchangeCfg(actId)
    if cfgList ~= nil then 
        for i = 1,#cfgList do 
            local cfg = cfgList[i]
            if cfg ~= nil then
                local data = {cfgId = cfg.Id, rewardNum = 0, order = cfg.Order}
                self.data[#self.data + 1] = data
                self.map[data.cfgId] = data
            end
        end
    end

    CommonUtil.ArraySortSelections(self.data, Enum.TableSortRule.Up, "order")
end

function ActivityPetRewardItem:SyncSrvData(serverData)
    local collectionRewardData = serverData[3]
    if not collectionRewardData then
        return
    end
    for i = 1, #collectionRewardData do
        local data = self.map[collectionRewardData[i].id]
        if data then
            data.rewardNum = collectionRewardData[i].exchange_num
        end
    end
end

function ActivityPetRewardItem:RefreshCollectionGlobalData(list)
    for _,v in pairs(list) do
        local key = v.key
        local num = v.value
        self.globalMap[key] = num
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ACTIVITY_GLOBAL_REFRESH)
end

function ActivityPetRewardItem:GetGlobalCount(id)
    return self.globalMap[id] or 0
end

function ActivityPetRewardItem:GetAllDatas()
    return self.data
end

function ActivityPetRewardItem:HasRedPoint()
    if self:IsOutofDate() then
        return false
    end
    if next(self.data) == nil then
        return  false
    end

    for i = 1, #self.data do
        local data = self.data[i]
        local cfgData = ManagerContainer.CfgMgr:GetActivitiesPetExchangeCfgById(data.cfgId)
        local enterType = cfgData.Type
        if enterType == 0 then 
            if cfgData then
                local enough = true
    
                local showData = self.map[data.cfgId]
                local globalCount = self:GetGlobalCount(data.cfgId)
                if showData.rewardNum >= cfgData.Number or (globalCount >= cfgData.ServersReward and cfgData.ServersReward > 0) then
                    enough = false
                end
                if enough then
                    if cfgData.ExchangeCondition1 then
                        for i = 1, #cfgData.ExchangeCondition1 do
                            local reward = cfgData.ExchangeCondition1[i]
                            local curNum =ManagerContainer.DataMgr.PetDataMgr:GetPetCountByIdAndLv(reward[2],reward[3],reward[4])
                            if curNum < reward[5] then
                                enough = false
                            end
                        end
                    end
                    if cfgData.ExchangeCondition2 then
                        for i = 1, #cfgData.ExchangeCondition2 do
                            local reward = cfgData.ExchangeCondition2[i]
                            local curNum =ManagerContainer.DataMgr.PetDataMgr:GetPetCountByQulityAndLv(reward[2],reward[3],reward[4])
                            if curNum < reward[5] then
                                enough = false
                            end
                        end
                    end
                end
                if enough then
                    return true
                end
            end
        elseif enterType == 1 then
            if cfgData then
                local enough = true 
                local showData = self.map[data.cfgId]
                local globalCount = self:GetGlobalCount(data.cfgId)
                if showData.rewardNum >= cfgData.Number or (globalCount >= cfgData.ServersReward and cfgData.ServersReward > 0) then
                    enough = false
                end
                if enough then
                    if cfgData.ExchangeCondition1 then
                        for i = 1, #cfgData.ExchangeCondition1 do
                            local reward = cfgData.ExchangeCondition1[i]
                            local curNum = CommonUtil.GetOwnResCountByItemId(reward[3])
                            if curNum < reward[4] then
                                enough = false
                            end
                        end
                    end
                    if cfgData.ExchangeCondition2 then
                        for i = 1, #cfgData.ExchangeCondition2 do
                            local reward = cfgData.ExchangeCondition2[i]
                            local filtr = cfgData.Scope[i]
                            local curNum = 0
                            for i = 1, #filtr do
                                curNum = curNum + CommonUtil.GetOwnResCountByItemId(filtr[i])
                            end
                            if curNum < reward[4] then
                                enough = false
                            end
                        end
                    end
                end
                if enough then
                    return true
                end
            end
        end       
    end
    return  false
end

function ActivityPetRewardItem:SendRewardReq(day)
    ManagerContainer.DataMgr.ActsDataMgr:SendGetActivityRewardReq(self.actId,day)
end

function ActivityPetRewardItem:GetLeftTime()
    local leftTime = self.curDayEndTime - ManagerContainer.LuaTimerMgr:GetTimeSecond()
    if leftTime < 0 then
        leftTime = 0
    end
    return leftTime
end


return ActivityPetRewardItem