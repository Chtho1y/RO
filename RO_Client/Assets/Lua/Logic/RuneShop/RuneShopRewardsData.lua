local RuneShopRewardsData = class('RuneShopRewardsData')

function RuneShopRewardsData:ctor()
    self.id = nil
    self.rewardId = nil
    self.cashRewardId = nil
    self.cfgData = nil
    self.exploreLv = nil
    self.isRewardSign = nil
    self.upExp = nil
    self.curLv = nil

    self.isReward = nil
    self.isCashReward = nil

end

function RuneShopRewardsData:Dispose()
    self.id = nil
    self.rewardId = nil
    self.cashRewardId = nil
    self.cfgData = nil
    self.exploreLv = nil
    self.isRewardSign = nil
    self.upExp = nil
    self.curLv = nil

    self.isReward = nil
    self.isCashReward = nil
end

function RuneShopRewardsData:SetData(data, cfgData)
    self:RefreshData(data)
    self.cfgData = cfgData
end

function RuneShopRewardsData:RefreshData(data)
    if data == nil then return end
    self.datat = data
    --self.id = data.ID
    if data[1] then 
        self.isReward = data[1]
    end
    if data[2] then
        self.isCashReward = data[2]
    end
    
    --self.endTime = data.end_time
end



function RuneShopRewardsData:IsValidTime()
    if self.endTime and self.endTime > 0 then
        return self.endTime < self:GetCurTime()
    end
    return true
end

function RuneShopRewardsData:IsSoldout()
    return self.remainNum <= 0
    
end

function RuneShopRewardsData:GetRemainBuyNumInternal()
    return self.remainNum
end


function RuneShopRewardsData:GetShowInfo()
    if self.endTime and self.endTime > 0 then
        --if self.endTime < self:GetCurTime() then
        --    return false, nil, nil
        --else
        LogError('time'..self.endTime)
            return true, self.endTime, self.endTime
           
        --end
    end
    return true, nil, nil
end

function RuneShopRewardsData:GetId()
    
end

function RuneShopRewardsData:GetData()
    return self.datat
end

function RuneShopRewardsData:GetCfgData()
    return self.cfgData
end

function RuneShopRewardsData:HasEndTime()
    return (self.endTime and self.endTime > 0)
end


function RuneShopRewardsData:CalculateLimitTime()
    if self.endTime and self.endTime > 0 then
        local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(self.endTime)
        local timerStr, outTime = CommonUtil.FormatTimeDMS(remainTime)
        return timerStr, outTime, remainTime
    end
    return nil, true, nil
end

function RuneShopRewardsData:GetCurTime()
    return ManagerContainer.LuaTimerMgr:CurLuaServerTime()
end

return RuneShopRewardsData

