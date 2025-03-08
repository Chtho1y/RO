local RuneShopBaseData = class('RuneShopBaseData')
local RuneShopGoodsData = require('RuneShop/RuneShopGoodsData')

local function CompValidTimeData(a, b)
    if a and a > 0 then
        if not b or b > a then
            b = a
        end
    end
    return b
end

function RuneShopBaseData:ctor()
    self.runeShopType           = nil
    self.runeShopSubType        = nil
    self.endTime                = nil
    self.goodsDataMap           = nil

    self.needRefreshTime        = nil
    self.needRefreshDataTime    = nil
    self.showGoodsDatas         = nil
    self.hasFreeCanBuy          = nil
end

function RuneShopBaseData:Dispose()
    self.endTime                = nil
    self.goodsDataMap           = nil

    self.needRefreshTime        = nil
    self.needRefreshDataTime    = nil
    self.showGoodsDatas         = nil
    self.hasFreeCanBuy          = nil
end

function RuneShopBaseData:SetData(data)
    local runeShopType = data.shop_type
    local runeShopSubType = data.sub_shop
    local goodsList = data.goods_list
    local endTime = data.end_time
    local goodsDataMap = {}
    local goodsData = nil
    if goodsList then
        local curNum = #goodsList
        for i = 1, curNum do
            local goods = goodsList[i]
            if goods then
                local id = goods.goods_id
                local cfgData = ManagerContainer.CfgMgr:GetRuneShopCfgByFeature(runeShopType, runeShopSubType, id)
                if cfgData then
                    if self.goodsDataMap then
                        goodsData = self.goodsDataMap[id]
                    else
                        goodsData = nil
                    end
                    if not goodsData then
                        goodsData = RuneShopGoodsData:new()
                    end
                    goodsData:SetData(goods, cfgData)
                    if goodsDataMap[id] then
                        LogWarning('[wboy] Find Same Goods Info !!! id = ' .. tostring(id))
                    end
                    goodsDataMap[id] = goodsData
                else
                    LogError('[wboy] Config Not Find Goods Info !!! id = ' .. tostring(id) .. '   runeShopType = ' .. tostring(runeShopType) .. '    runeShopSubType = ' .. tostring(runeShopSubType))
                end
            end
        end
    end
    self.runeShopType = runeShopType
    self.runeShopSubType = runeShopSubType
    self.endTime = endTime
    self.goodsDataMap   = goodsDataMap
    self:RefreshShowGoodsDatas()
end

function RuneShopBaseData:RefreshOneGoodsData(data)
    local id = data.goods_id
    local goodsData = self.goodsDataMap[id]
    if goodsData then
        local isShow, refreshTime, refreshDataTime = goodsData:GetShowInfo()
        goodsData:RefreshData(data)
        local isShowNew, refreshTimeNew, refreshDataTimeNew = goodsData:GetShowInfo()
        if isShow ~= isShowNew or refreshTime ~= refreshTimeNew or refreshDataTime ~= refreshDataTimeNew then
            self:RefreshShowGoodsDatas()
        else
            local hasFreeCanBuy = false
            for _,goodsData in pairs(self.showGoodsDatas) do
                if not hasFreeCanBuy and goodsData:IsFree() and goodsData:IsCanBuy() then
                    hasFreeCanBuy = true
                    break
                end
            end
            local rpChange = (self.hasFreeCanBuy ~= hasFreeCanBuy)
            self.hasFreeCanBuy = hasFreeCanBuy
            if rpChange then
                self:RedPointNotify()
            end
        end
    end
end

function RuneShopBaseData:RefreshShowGoodsDatas()
    local needRefreshTime       = nil
    local needRefreshDataTime   = nil
    local hasFreeCanBuy         = false
    local showGoodsDatas = {}
    for _, goodsData in pairs(self.goodsDataMap) do
        local isShow, refreshTime, refreshDataTime = goodsData:GetShowInfo()
        if isShow then
            showGoodsDatas[#showGoodsDatas+1] = goodsData
            if not hasFreeCanBuy and goodsData:IsFree() and goodsData:IsCanBuy() then
                hasFreeCanBuy = true
            end
        end
        needRefreshTime = CompValidTimeData(refreshTime, needRefreshTime)
        needRefreshDataTime = CompValidTimeData(refreshDataTime, needRefreshDataTime)
    end
    needRefreshTime = CompValidTimeData(self.endTime, needRefreshTime)
    needRefreshDataTime = CompValidTimeData(self.endTime, needRefreshDataTime)

    local rpChange = (self.hasFreeCanBuy ~= hasFreeCanBuy)

    self.needRefreshTime        = needRefreshTime
    self.needRefreshDataTime    = needRefreshDataTime
    self.showGoodsDatas         = showGoodsDatas
    self.hasFreeCanBuy          = hasFreeCanBuy
    self:SortShowData()

    if rpChange then
        self:RedPointNotify()
    end
end

function RuneShopBaseData:SortShowData()
    if not self.showGoodsDatas then return end
    table.sort(self.showGoodsDatas, function (a, b)
        local isSoldOutA = a:IsSoldout()
        local isSoldOutB = b:IsSoldout()
        if isSoldOutA == isSoldOutB then
            return a:GetSortId() < b:GetSortId()
        else
            return not isSoldOutA
        end
    end)
end

function RuneShopBaseData:GetGoodsDataByIdx(idx)
    return self.goodsDataMap[idx]
end

function RuneShopBaseData:GetShowGoodsDatas()
    return self.showGoodsDatas
end

function RuneShopBaseData:IsValidShow()
    if not self.needRefreshTime then
        return true
    end
    local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(self.needRefreshTime)
    return remainTime >= 0
end

function RuneShopBaseData:IsValidData()
    if not self.needRefreshDataTime then
        return true
    end
    local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(self.needRefreshDataTime)
    return remainTime >= 0
end

function RuneShopBaseData:RefreshRemainTime()
    if not self.needRefreshDataTime then
        return nil
    end
    return ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(self.needRefreshDataTime)
end

function RuneShopBaseData:RedPointNotify()
    if self.runeShopType == Enum.RuneShopType.Gifts then
        if self.runeShopSubType == Enum.RuneShopSubType.Daily then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopDaily, self.hasFreeCanBuy)
        elseif self.runeShopSubType == Enum.RuneShopSubType.Week then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopWeek, self.hasFreeCanBuy)
        elseif self.runeShopSubType == Enum.RuneShopSubType.Month then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopMonth, self.hasFreeCanBuy)
        end
    end
end

return RuneShopBaseData