local ActivityChipRewardItem = class("ActivityChipRewardItem",require("Activities/ActivityTypeItem"))

function ActivityChipRewardItem:ctor(actId)
    self.redPointType = Enum.RPNotifyType.ActivityCollect
    self.data = {}
    self.map = {}
    self.globalMap = {}

    self:InitData(actId)
end

function ActivityChipRewardItem:InitData(actId)
    self.data = {}
    self.map = {}
    local cfgList = ManagerContainer.CfgMgr:GetActivitiesCollectionCfg(actId)
    if cfgList ~= nil then 
        for i = 1,#cfgList do 
            local cfg = cfgList[i]
            if cfg ~= nil then
                local data = {cfgId = cfg.Id, rewardNum = 0, order = cfg.Order,isNotice = false}
                self.data[#self.data + 1] = data
                self.map[data.cfgId] = data
            end
        end
    end

    CommonUtil.ArraySortSelections(self.data, Enum.TableSortRule.Up, "order")
end

function ActivityChipRewardItem:SyncSrvData(serverData)
    local collectionRewardData = serverData[3]
    for i = 1, #collectionRewardData do
        local data = self.map[collectionRewardData[i].id]
        if data then
            data.rewardNum = collectionRewardData[i].reward_num
            data.isNotice = collectionRewardData[i].no_notice
        end
    end
end

function ActivityChipRewardItem:SetWordNotice(collect_id,no_notice)
    local data = self.map[collect_id]
    if data then
        data.isNotice = no_notice
    end
end

function ActivityChipRewardItem:GetShowDataByCfgId(cfgId)
    local data = self.data
    for i = 1, #data do
        if data[i].cfgId == cfgId then
            return data[i],i
        end
    end
    return nil,nil
end

function ActivityChipRewardItem:RefreshCollectionGlobalData(list)
    for _,v in pairs(list) do
        local key = v.key
        local num = v.value
        self.globalMap[key] = num
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ACTIVITY_GLOBAL_REFRESH)
end

function ActivityChipRewardItem:GetGlobalCount(id)
    return self.globalMap[id] or 0
end

function ActivityChipRewardItem:GetAllDatas()
    return self.data
end

function ActivityChipRewardItem:HasRedPoint()
    if self:IsOutofDate() then
        return false
    end
    if next(self.data) == nil then
        return  false
    end

    for i = 1, #self.data do
        local data = self.data[i]
        local cfgData = ManagerContainer.CfgMgr:GetActivitiesCollectionCfgById(data.cfgId)
        if cfgData then
            local enough = true

            local showData = self.map[data.cfgId]
            local globalCount = self:GetGlobalCount(data.cfgId)
            if showData.rewardNum >= cfgData.Number or (globalCount >= cfgData.ServersReward and cfgData.ServersReward > 0) then
                enough = false
            end
            if enough then
                for i = 1, #cfgData.ExchangeCondition do
                    local reward = cfgData.ExchangeCondition[i]
                    local curNum = CommonUtil.GetOwnResCountByItemId(reward[1])
                    if curNum < reward[2] then
                        enough = false
                    end
                end
            end
            if enough and not showData.isNotice then
                return true
            end
        end
    end

    return  false
end

function ActivityChipRewardItem:SendRewardReq(day)
    ManagerContainer.DataMgr.ActsDataMgr:SendGetActivityRewardReq(self.actId,day)
end

function ActivityChipRewardItem:GetLeftTime()
    local leftTime = self.curDayEndTime - ManagerContainer.LuaTimerMgr:GetTimeSecond()
    if leftTime < 0 then
        leftTime = 0
    end
    return leftTime
end

return ActivityChipRewardItem