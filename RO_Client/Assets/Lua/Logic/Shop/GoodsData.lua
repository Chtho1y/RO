local GoodsData = class('GoodsData')

function GoodsData:ctor()
    self.count       = 0
    self.buyNum      = 0
end

function GoodsData:Dispose()
    self.id          = nil
    self.price       = nil
    self.curPrice    = nil
    self.disPercent  = nil
    self.hot         = nil
    self.limitType   = nil
    self.count       = nil
    self.startTime   = nil
    self.endTime     = nil

    self.buyNum      = nil
    self.buyLastTime = nil
    self.cfgData     = nil
end

function GoodsData:SetBaseData(data, cfgData, refreshTime, dayEndTime, weekEndTime)
    self.id          = data.goods_id
    self.price       = data.price
    self.curPrice    = data.cur_price
    self.disPercent  = data.dispercent
    self.hot         = data.hot
    self.limitType   = data.limit_type
    self.count       = data.count or 0
    self.startTime   = data.start_time
    self.endTime     = data.end_time
    self.cfgData     = cfgData

    if not self:IsDiscount() then
        self.curPrice    = self.price
    end

    if self.limitType == Enum.LimitBuyType.Forever then
        self.endTime = dayEndTime
    elseif self.limitType == Enum.LimitBuyType.Daily then
        self.endTime = dayEndTime
    elseif self.limitType == Enum.LimitBuyType.Week then
        self.endTime = weekEndTime
    elseif self.limitType == Enum.LimitBuyType.Special then
        self.endTime = refreshTime
    end

    self.buyNum      = 0
    self.buyLastTime = nil
end

function GoodsData:SetBuyData(data)
    self.buyNum      = data.buy_num or 0
    self.buyLastTime = data.buy_time
end

function GoodsData:GetCurTime()
    return ManagerContainer.LuaTimerMgr:GetTimeSecond()
end

function GoodsData:IsValidTime()
    if self.limitType == Enum.LimitBuyType.NoLimit then
        return true
    end
    if self.limitType == Enum.LimitBuyType.Forever then
        return true
    elseif self.limitType == Enum.LimitBuyType.Daily then
        local curTime = self:GetCurTime()
        return (curTime <= self.endTime)
    elseif self.limitType == Enum.LimitBuyType.Week then
        local curTime = self:GetCurTime()
        return (curTime <= self.endTime)
    elseif self.limitType == Enum.LimitBuyType.Time then
        local curTime = self:GetCurTime()
        return (curTime >= self.startTime and curTime <= self.endTime)
    elseif self.limitType == Enum.LimitBuyType.Special then
        local curTime = self:GetCurTime()
        return (curTime <= self.endTime)
    end
    return true
end

function GoodsData:IsCanBuy()
    if self.limitType == Enum.LimitBuyType.NoLimit then
        return true
    end
    if self:GetRemainBuyNumInternal() <= 0 then
        return false
    end
    if self.limitType == Enum.LimitBuyType.Forever then
        return true
    elseif self.limitType == Enum.LimitBuyType.Daily then
        local curTime = self:GetCurTime()
        return (curTime <= self.endTime)
    elseif self.limitType == Enum.LimitBuyType.Week then
        local curTime = self:GetCurTime()
        return (curTime <= self.endTime)
    elseif self.limitType == Enum.LimitBuyType.Time then
        local curTime = self:GetCurTime()
        return (curTime >= self.startTime and curTime <= self.endTime)
    elseif self.limitType == Enum.LimitBuyType.Special then
        local curTime = self:GetCurTime()
        return (curTime <= self.endTime)
    end
    return true
end

function GoodsData:GetRemainBuyNumInternal()
    if not self.count or self.count <= 0 then
        return 0
    end
    if self.buyNum then
        return (self.count - self.buyNum)
    else
        return self.count
    end
end

--- 返回剩余可购买次数
---@return integer -1时为无限次
function GoodsData:GetRemainBuyNum()
    if self.limitType == Enum.LimitBuyType.NoLimit then
        return -1
    end
    local remainNum = self:GetRemainBuyNumInternal()
    if remainNum <= 0 then
        return 0
    end
    return remainNum
    -- if self.limitType == Enum.LimitBuyType.Forever then
    --     return remainNum
    -- elseif self.limitType == Enum.LimitBuyType.Daily then
    --     local curTime = self:GetCurTime()
    --     if curTime <= self.endTime then
    --         return remainNum
    --     else
    --         return 0
    --     end
    -- elseif self.limitType == Enum.LimitBuyType.Week then
    --     local curTime = self:GetCurTime()
    --     if curTime <= self.endTime then
    --         return remainNum
    --     else
    --         return 0
    --     end
    -- elseif self.limitType == Enum.LimitBuyType.Time then
    --     local curTime = self:GetCurTime()
    --     if (curTime >= self.startTime and curTime <= self.endTime) then
    --         return remainNum
    --     else
    --         return 0
    --     end
    -- elseif self.limitType == Enum.LimitBuyType.Special then
    --     local curTime = self:GetCurTime()
    --     if curTime <= self.endTime then
    --         return remainNum
    --     else
    --         return 0
    --     end
    -- end
    -- return 0
end

--- 是否卖光了
function GoodsData:IsSoldout()
    if self.limitType == Enum.LimitBuyType.NoLimit then
        return false
    end
    if self.limitType == Enum.LimitBuyType.Forever
        or self.limitType == Enum.LimitBuyType.Daily
        or self.limitType == Enum.LimitBuyType.Week
        or self.limitType == Enum.LimitBuyType.Time
        or self.limitType == Enum.LimitBuyType.Special then
        if self:GetRemainBuyNumInternal() <= 0 then
            return true
        end
        return false
    end
    return true
end

--- 获得商品的显示规则数据
---@return boolean,int64,int64   是否显示，显示需要刷新的时间，数据需要刷新的时间
function GoodsData:GetShowInfo()
    if self.limitType == Enum.LimitBuyType.NoLimit then
        return true, nil, nil
    elseif self.limitType == Enum.LimitBuyType.Forever then
        -- if self:GetRemainBuyNumInternal() > 0 then
            return true, nil, nil
        -- else
        --     if self.buyLastTime then
        --         if (self.endTime - self.buyLastTime) > ManagerContainer.LuaTimerMgr:GetOneDaySeconds() then
        --             return false, nil, nil
        --         else
        --             return true, self.endTime, self.endTime
        --         end
        --     else
        --         return true, self.endTime, self.endTime
        --     end
        -- end
    elseif self.limitType == Enum.LimitBuyType.Daily then
        return true, nil, self.endTime
    elseif self.limitType == Enum.LimitBuyType.Week then
        return true, nil, self.endTime
    elseif self.limitType == Enum.LimitBuyType.Time then
        local curTime = self:GetCurTime()
        if curTime < self.startTime then
            return false, self.startTime, self.endTime
        elseif curTime > self.endTime then
            return false, nil, nil
        else
            return true, self.endTime, self.endTime
        end
    elseif self.limitType == Enum.LimitBuyType.Special then
        return true, nil, self.endTime
    end
    return false, nil, nil
end

function GoodsData:IsDiscount()
    return self.disPercent and self.disPercent > 0 and self.disPercent < 100
end


function GoodsData:GetSortId()
    return self.cfgData.SortId
end

function GoodsData:GetGoodsCfgData()
    return self.cfgData
end

function GoodsData:CalculateLimitTime()
    local time = ManagerContainer.LuaTimerMgr:GetRemainSeconds(self.endTime)
    local timerStr, outTime = CommonUtil.FormatTimeDMS(time)
    return timerStr, outTime
end

return GoodsData