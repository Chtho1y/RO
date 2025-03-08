local ShopData = class('ShopData')
local GoodsData = require('Shop/GoodsData')

local function CompValidTimeData(a, b)
    if a and a > 0 then
        if not b or b > a then
            b = a
        end
    end
    return b
end



function ShopData:ctor()
end

function ShopData:Dispose()
    self.shopId                 = nil
    self.refreshTime            = nil
    self.refreshCount           = nil
    self.dayEndTime             = nil
    self.weekEndTime            = nil

    self.goodsDataMap           = nil

    self.needRefreshTime        = nil
    self.needRefreshDataTime    = nil
    self.showGoodsDatas         = nil
end

function ShopData:SetData(data)
    local shopId         = data.goods_type
    local refreshTime    = data.refresh_time
    local refreshCount   = data.refresh_count
    local dayEndTime     = data.day_end
    local weekEndTime    = data.week_end

    --- 初始化数据
    local goodsDataMap = {}
    local itemInfos = data.item_info
    if itemInfos then
        for i = 1, #itemInfos do
            local itemInfo = itemInfos[i]
            if itemInfo then
                local id = itemInfo.goods_id
                local cfgData = ManagerContainer.CfgMgr:GetShopCfgByGoodsId(id)
                if cfgData then
                    local goodsData = nil
                    if self.goodsDataMap then
                        goodsData = self.goodsDataMap[id]
                    end
                    if not goodsData then
                        goodsData = GoodsData:new()
                        goodsData:SetBaseData(itemInfo, cfgData, refreshTime, dayEndTime, weekEndTime)
                    else
                        goodsData:SetBaseData(itemInfo, cfgData, refreshTime, dayEndTime, weekEndTime)
                    end
                    if goodsDataMap[id] then
                        LogWarning('[wboy] Find Same Goods Info !!! id = ' .. tostring(id))
                    end
                    goodsDataMap[id] = goodsData
                else
                    LogError('[wboy] Config Not Find Goods Info !!! id = ' .. tostring(id))
                end
            end
        end
    end
    -- 记录购买过的数据
    local buyInfos = data.buy_info
    if buyInfos then
        for i = 1, #buyInfos do
            local buyInfo = buyInfos[i]
            if buyInfo then
                local id = buyInfo.goods_id
                local goodsData = goodsDataMap[id]
                if goodsData then
                    goodsData:SetBuyData(buyInfo)
                else
                    LogWarning('[wboy] buy_info has not exist goods, id = ' .. tostring(id))
                end
            end
        end
    end

    self.shopId         = shopId
    self.refreshTime    = refreshTime
    self.refreshCount   = refreshCount
    self.dayEndTime     = dayEndTime
    self.weekEndTime    = weekEndTime
    self.goodsDataMap   = goodsDataMap

    self:RefreshShowGoodsDatas()
end

function ShopData:RefreshBuyInfoData(data)
    local id = data.goods_id
    local goodsData = self.goodsDataMap[id]
    if goodsData then
        local isShow, refreshTime, refreshDataTime = goodsData:GetShowInfo()
        goodsData.buyNum      = data.cur_num
        goodsData.buyLastTime = data.cur_buy_time
        local isShowNew, refreshTimeNew, refreshDataTimeNew = goodsData:GetShowInfo()
        if isShow ~= isShowNew or refreshTime ~= refreshTimeNew or refreshDataTime ~= refreshDataTimeNew then
            self:RefreshShowGoodsDatas()
        end
    end
end

--- 整理数据，获得需要显示的商品，下次商店需要刷新界面的时间, 下次商店需要刷新数据的时间
function ShopData:RefreshShowGoodsDatas()
    local needRefreshTime       = nil
    local needRefreshDataTime   = nil
    local showGoodsDatas = {}
    for _, goodsData in pairs(self.goodsDataMap) do
        local isShow, refreshTime, refreshDataTime = goodsData:GetShowInfo()
        if isShow then
            showGoodsDatas[#showGoodsDatas+1] = goodsData
        end
        needRefreshTime = CompValidTimeData(refreshTime, needRefreshTime)
        needRefreshDataTime = CompValidTimeData(refreshDataTime, needRefreshDataTime)
    end
    needRefreshTime = CompValidTimeData(self.refreshTime, needRefreshTime)
    needRefreshDataTime = CompValidTimeData(self.refreshTime, needRefreshDataTime)
    needRefreshTime = CompValidTimeData(self.dayEndTime, needRefreshTime)
    needRefreshDataTime = CompValidTimeData(self.dayEndTime, needRefreshDataTime)
    needRefreshTime = CompValidTimeData(self.weekEndTime, needRefreshTime)
    needRefreshDataTime = CompValidTimeData(self.weekEndTime, needRefreshDataTime)

    self.needRefreshTime        = needRefreshTime
    self.needRefreshDataTime    = needRefreshDataTime
    self.showGoodsDatas         = showGoodsDatas
    self:SortShowData()
end

function ShopData:SortShowData()
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


function ShopData:GetGoodsDataById(id)
    return self.goodsDataMap[id]
end

function ShopData:GetShowGoodsDatas()
    return self.showGoodsDatas
end

function ShopData:GetNeedRefreshTime()
    return self.needRefreshTime
end

function ShopData:GetNeedRefreshDataTime()
    return self.needRefreshDataTime
end

function ShopData:GetRefreshTime()
    return self.refreshTime
end

function ShopData:GetRefreshCount()
    return self.refreshCount
end










return ShopData