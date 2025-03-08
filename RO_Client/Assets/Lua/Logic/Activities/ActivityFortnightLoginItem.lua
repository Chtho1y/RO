local ActivityFortnightLoginItem = class("ActivityFortnightLoginItem",require("Activities/ActivityTypeItem"))

function ActivityFortnightLoginItem:ctor(actId)
    self.curDay = 0
    self:InitData(actId)
end

function ActivityFortnightLoginItem:InitData(actId)
    self.data = {}
    local cfgList = ManagerContainer.CfgMgr:GetFortnightOnlineCfg(actId)
    if cfgList ~= nil  then
        table.sort(cfgList, function (a,b)
            return a.Day < b.Day
        end)
        for i = 1, 14 do
            local cfg = cfgList[i]
            if cfg ~= nil then
                self.data[#self.data+1] = {day = i, qualityIcon = cfg.RewardBg,txtClr = cfg.TextColour, rewards = cfg.Rewards, isGotReward = false, isOutdate = false,isFinished = false}
            end
        end
    end
    self:SetRPType(Enum.RPNotifyType.FortnightLogin)
end

function ActivityFortnightLoginItem:SyncSrvData(serverData)
    self.curDay = serverData[1]
    local loginRewardData = serverData[2]

    for i = 1, self.curDay do
        local item = self:GetDayData(i)
        if item ~= nil then
            item.isGotReward = false
            item.isFinished = true
            item.isOutdate = (i < self.curDay)
        end
    end

    if loginRewardData ~= nil then
        for i = 1, #loginRewardData do
            local item = self:GetDayData(loginRewardData[i].key)
            if item ~= nil then
                item.isOutdate = false
                item.isGotReward = loginRewardData[i].value > 0
            end
        end
    end
end

function ActivityFortnightLoginItem:GetDayData(d)
    if self.data == nil then
        return nil
    end

    for i = 1, #self.data do
        if self.data[i].day == d then
            return self.data[i]
        end
    end

    return nil
end

function ActivityFortnightLoginItem:HasRedPoint()
    if self.data == nil then
        return  false
    end

    for i = 1, #self.data do
        local  redPoint = self.data[i].isFinished and (not self.data[i].isOutdate) and (not self.data[i].isGotReward)
        if redPoint then
            return true
        end
    end
    
    return  false
end

function ActivityFortnightLoginItem:SendRewardReq(day)
    ManagerContainer.DataMgr.ActsDataMgr:SendGetActivityRewardReq(self.actId,day)
end

return ActivityFortnightLoginItem