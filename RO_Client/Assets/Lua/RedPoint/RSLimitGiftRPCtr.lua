local RSLimitGiftRPCtr = class('RSLimitGiftRPCtr')

local CACHE_RP_KEY_NAME = 'Cache_RuneShopLimitGift_RP_Key'

function RSLimitGiftRPCtr:ctor()
    self.cacheRSLimitGiftRPMap = nil
end

function RSLimitGiftRPCtr:Init()
    self.cacheRSLimitGiftRPMap = nil
end

function RSLimitGiftRPCtr:Destory()
end

function RSLimitGiftRPCtr:RefreshLimitGiftRedPointByShopData(shopData)
    if not self.cacheRSLimitGiftRPMap then
        self:ReadCacheRSLimitGiftRPData()
    end
    if shopData then
        local showGoodsDatas = shopData:GetShowGoodsDatas()
        if showGoodsDatas and #showGoodsDatas > 0 then
            local redpoint = false
            local changed = false
            local id
            local newCacheRSLimitGiftRPMap = {}
            for _, showGoodsData in pairs(showGoodsDatas) do
                local cfgData = showGoodsData:GetCfgData()
                if cfgData and cfgData.RedPoint == 1 and not showGoodsData:IsSoldout() then
                    id = showGoodsData:GetId()
                    if self.cacheRSLimitGiftRPMap[id] == nil then
                        newCacheRSLimitGiftRPMap[id] = true
                        redpoint = true
                        changed = true
                    else
                        newCacheRSLimitGiftRPMap[id] = self.cacheRSLimitGiftRPMap[id]
                        if newCacheRSLimitGiftRPMap[id] then
                            redpoint = true
                        end
                    end
                end
            end
            if changed then
                self.cacheRSLimitGiftRPMap = newCacheRSLimitGiftRPMap
                self:WriteCacheRSLimitGiftRPData()
            end
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopLimitGift, redpoint)
            return
        end
    end
    if not CommonUtil.TableIsEmpty(self.cacheRSLimitGiftRPMap) then
        self.cacheRSLimitGiftRPMap = {}
        self:WriteCacheRSLimitGiftRPData()
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopLimitGift, false)
    end
end

function RSLimitGiftRPCtr:RefreshLimitGiftRedPointByIds(ids)
    if not self.cacheRSLimitGiftRPMap then
        self:ReadCacheRSLimitGiftRPData()
    end
    if not ids then
        if not CommonUtil.TableIsEmpty(self.cacheRSLimitGiftRPMap) then
            self.cacheRSLimitGiftRPMap = {}
            self:WriteCacheRSLimitGiftRPData()
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopLimitGift, false)
        end
        return
    end
    local redpoint = false
    local changed = false
    local newCacheRSLimitGiftRPMap = {}
    for _, id in pairs(ids) do
        local cfgData = ManagerContainer.CfgMgr:GetRuneShopCfgByFeature(Enum.RuneShopType.LimitTime, nil, id)
        if cfgData and cfgData.RedPoint == 1 then
            if self.cacheRSLimitGiftRPMap[id] == nil then
                newCacheRSLimitGiftRPMap[id] = true
                redpoint = true
                changed = true
            else
                newCacheRSLimitGiftRPMap[id] = self.cacheRSLimitGiftRPMap[id]
                if newCacheRSLimitGiftRPMap[id] then
                    redpoint = true
                end
            end
        end
    end
    if changed then
        self.cacheRSLimitGiftRPMap = newCacheRSLimitGiftRPMap
        self:WriteCacheRSLimitGiftRPData()
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopLimitGift, redpoint)
end

function RSLimitGiftRPCtr:GetRedPointStatusById(id)
    return self.cacheRSLimitGiftRPMap and self.cacheRSLimitGiftRPMap[id] or false
end

function RSLimitGiftRPCtr:CancelRedPointStatusById(id)
    if self.cacheRSLimitGiftRPMap then
        if not self.cacheRSLimitGiftRPMap[id] then
            return
        end
        self.cacheRSLimitGiftRPMap[id] = false
    else
        self.cacheRSLimitGiftRPMap = {}
    end
    self.cacheRSLimitGiftRPMap[id] = false
    self:WriteCacheRSLimitGiftRPData()
    for _, value in pairs(self.cacheRSLimitGiftRPMap) do
        if value then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopLimitGift, true)
            return
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopLimitGift, false)
end

function RSLimitGiftRPCtr:ReadCacheRSLimitGiftRPData()
    local cacheStr = ManagerContainer.PlayerPrefsMgr:GetString(CACHE_RP_KEY_NAME, '')
    local cacheRSLimitGiftRPMap = JSON:decode(cacheStr)
    if not cacheRSLimitGiftRPMap then
        cacheRSLimitGiftRPMap = {}
    end
    self.cacheRSLimitGiftRPMap = cacheRSLimitGiftRPMap
end

function RSLimitGiftRPCtr:WriteCacheRSLimitGiftRPData()
    if self.cacheRSLimitGiftRPMap then
        local valueStr = JSON:encode(self.cacheRSLimitGiftRPMap)
        ManagerContainer.PlayerPrefsMgr:SetString(CACHE_RP_KEY_NAME, valueStr)
    end
end

return RSLimitGiftRPCtr