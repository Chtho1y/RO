local RuneShopGoodsData = class('RuneShopGoodsData')

function RuneShopGoodsData:ctor()
    self.id = 0
    self.isFirstBuy = false
    self.isLimitBuy = false
    self.remainNum = -1
    self.price = 0
    self.endTime = 0
    self.cfgData = nil
end

function RuneShopGoodsData:Dispose()
    self.id = nil
    self.remainNum = nil
    self.endTime = nil
    self.cfgData = nil
end

function RuneShopGoodsData:SetData(data, cfgData)
    self:RefreshData(data)
    self.cfgData = cfgData
end

function RuneShopGoodsData:RefreshData(data)
    self.id = data.goods_id or 0
    self.isFirstBuy = data.first_buy or false
    self.isLimitBuy = data.buy_limit or false
    self.remainNum = data.buy_nums
    self.price = CommonUtil.GetValidPayPrice(data.price or 0)
    self.endTime = data.end_time
end

function RuneShopGoodsData:IsFirstBuy()
    return self.isFirstBuy
end

function RuneShopGoodsData:IsCanBuy()
    if not self.isLimitBuy then
        return true
    end
    if self:GetRemainBuyNumInternal() <= 0 then
        return false
    end
    return true
end

function RuneShopGoodsData:IsValidTime()
    if self.isLimitBuy then
        if self.endTime and self.endTime > 0 then
            return self.endTime < self:GetCurTime()
        end
    end
    return true
end

function RuneShopGoodsData:HasResidueTime()
    if self.endTime and self.endTime > 0 then
        return self.endTime < self:GetCurTime()
    end
    return true
end

function RuneShopGoodsData:IsSoldout()
    if self.isLimitBuy then
        return self.remainNum <= 0
    else
        return false
    end
end

function RuneShopGoodsData:GetRemainBuyNumInternal()
    return self.remainNum
end

--- 返回剩余可购买次数
---@return integer -1时为无限次
function RuneShopGoodsData:GetRemainBuyNum()
    if not self.isLimitBuy then
        return -1
    end
    local remainNum = self:GetRemainBuyNumInternal()
    if remainNum <= 0 then
        return 0
    end
    return remainNum
end

function RuneShopGoodsData:GetPrice()
    return self.price
end

function RuneShopGoodsData:GetShowInfo()
    if self.endTime and self.endTime > 0 then
        if self.endTime < self:GetCurTime() then
            return false, nil, nil
        else
            return true, self.endTime, self.endTime
        end
    end
    return true, nil, nil
end

function RuneShopGoodsData:GetId()
    return self.id
end

function RuneShopGoodsData:GetSortId()
    return self.cfgData.SortId or self.cfgData.Id
end

function RuneShopGoodsData:GetCfgData()
    return self.cfgData
end

function RuneShopGoodsData:HasEndTime()
    return (self.endTime and self.endTime > 0)
end

function RuneShopGoodsData:IsFree()
    if self.price and self.price > 0 then
        return false
    end
    return true
end

function RuneShopGoodsData:CalculateLimitTime()
    if self.endTime and self.endTime > 0 then
        local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(self.endTime)
        local timerStr, outTime = CommonUtil.FormatTimeDMS(remainTime)
        return timerStr, outTime, remainTime
    end
    return nil, true, nil
end

function RuneShopGoodsData:GetCurTime()
    return ManagerContainer.LuaTimerMgr:CurLuaServerTime()
end

return RuneShopGoodsData

