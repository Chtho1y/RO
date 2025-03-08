local ShopDataMgr = class("ShopDataMgr", require("DataBase"))
local ShopData = require('Shop/ShopData')

local SHOP_REQ_CD = 1000

function ShopDataMgr:ctor()
    self.shopDataMap = {}
end

function ShopDataMgr:Clear()
    self.shopDataMap = {}
end

function ShopDataMgr:Destroy()
    self.shopDataMap = nil
    self.lastSendMsgTimeMap = nil
    self:UnRegisterNetEvents()
end

function ShopDataMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SHOP_INFO_ACK, self.OnShopInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SHOP_REFRESH_ACK, self.OnShopRefreshAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SHOP_BUY_ITEM_ACK, self.OnShopBuyItemAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_RED_BAG_EXCHANGE_ACK, self.OnRedBagExchangeAck, self)
end

function ShopDataMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SHOP_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SHOP_REFRESH_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SHOP_BUY_ITEM_ACK)
end

function ShopDataMgr:OnShopInfoAck(data)
     --LogError('[wboy] SC_SHOP_INFO_ACK '.. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local shopDataMsg = data.shop_data
    if not shopDataMsg then return end
    local shopId = shopDataMsg.goods_type
    local shopData = self.shopDataMap[shopId]
    --LogError('[wboy] SC_SHOP_INFO_ACK '.. Inspect(self.shopDataMap))
    if not shopData then
        shopData = ShopData:new()
        self.shopDataMap[shopId] = shopData
    end
    shopData:SetData(shopDataMsg)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SHOP_DATA_CHANGED, shopId)
    if shopId == 1 then
        self:ReportEnterShop(true)
    end
end

function ShopDataMgr:ReportEnterShop(success)
    if not SDKMgr.Instance:IsReportAction() then
        return
    end
    local datas = System.Collections.Generic.Dictionary_object_object()
    datas:Add('event', 'mj_store')
    datas:Add('is_achieve', (success and 1 or 0))
    SDKMgr.Instance:ReportAction(datas)
end

function ShopDataMgr:OnShopRefreshAck(data)
    -- LogError('[wboy] SC_SHOP_REFRESH_ACK '.. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local shopDataMsg = data.shop_data
    if not shopDataMsg then return end
    local shopId = shopDataMsg.goods_type
    local shopData = self.shopDataMap[shopId]
    if not shopData then
        shopData = ShopData:new()
        self.shopDataMap[shopId] = shopData
    end
    shopData:SetData(shopDataMsg)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SHOP_DATA_CHANGED, shopId)
end

function ShopDataMgr:OnShopBuyItemAck(data)
     --LogError('[wboy] SC_SHOP_BUY_ITEM_ACK '.. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local shopId = data.goods_type
    local shopData = self.shopDataMap[shopId]
    if shopData then
        shopData:RefreshBuyInfoData(data)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SHOP_DATA_CHANGED, shopId)
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SHOP_BUY_SUCCESS)
    local itemList = data.item_list
    if itemList then
        local itemLength = #itemList
        if itemLength > 0 then
            local addItemMap = {}
            local cfgId, addNum, item
            for i = 1, itemLength do
                item = itemList[i]
                cfgId = item.key
                addNum = item.value
                if addItemMap[cfgId] then
                    addItemMap[cfgId] = addItemMap[cfgId] + addNum
                else
                    addItemMap[cfgId] = addNum
                end
            end
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_EQUIP_AND_ITEM_ADD, addItemMap)
        end
    end
end

function ShopDataMgr:SendShopInfoReq(shopId)
    if self:IsCanSend('ShopInfo' .. tostring(shopId)) then
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SHOP_INFO_REQ, {goods_type = shopId})
        return true
    end
    return false
end

function ShopDataMgr:SendRefreshShopReq(shopId)
    if self:IsCanSend(2) then
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SHOP_REFRESH_REQ, {goods_type = shopId})
        return true
    end
    return false
end

function ShopDataMgr:SendShopBuyItemReq(shopId, goodsId, goodsNum)
    if self:IsCanSend(3) then
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SHOP_BUY_ITEM_REQ, {goods_type = shopId, goods_id = goodsId, goods_num = goodsNum})
        return true
    end
    return false
end

function ShopDataMgr:SendRedBagExchangeReq()
    if self:IsCanSend(1000) then
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_RED_BAG_EXCHANGE_REQ, {})
        return true
    end
    return false
end

function ShopDataMgr:OnRedBagExchangeAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end

    CommonUtil.ACKShowRewardList(data.reward)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_ENVELOPE_CASH_EXCHANGE_SUCCESS)
end

function ShopDataMgr:GetShopData(shopId, forceRefresh)
    local shopData = self.shopDataMap[shopId]
    if shopData then
        -- 数据是否过期了，如果过期了，需要去服务器上请求新数据
        if forceRefresh or ManagerContainer.LuaTimerMgr:GetRemainSeconds(shopData:GetNeedRefreshDataTime()) <= 0 then
            self:SendShopInfoReq(shopId)
        end
    else
        self:SendShopInfoReq(shopId)
    end
    return shopData
end


function ShopDataMgr:IsCanSend(key, cdTime)
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    if not self.lastSendMsgTimeMap then
        self.lastSendMsgTimeMap = {}
        self.lastSendMsgTimeMap[key] = curTime
        return true
    end
    local lastTime = self.lastSendMsgTimeMap[key]
    if lastTime then
        local cd = cdTime or SHOP_REQ_CD
        if (curTime - lastTime) < cd then
            return false
        end
    end
    self.lastSendMsgTimeMap[key] = curTime
    return true
end

return ShopDataMgr