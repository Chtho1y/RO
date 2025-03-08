local PayMgr = class('PayMgr')

local REQ_PAY_CD = 1000
local EXCPETION_WAIT_TIMESTAMP = 20000
local EXCPETION_WAIT_TIME = 20

PayGoodsType = {
    EPayType_None                 = 0,  -- 无效商品
    EPayType_Discount             = 1,  -- 超值礼包购买
    EPayType_MonthCard            = 2,  -- 月卡
    EPayType_NormalBag            = 3,  -- 普通礼包
    EPayType_LimitBag             = 4,  -- 限时礼包
    EPayType_RushTower            = 5,  -- 爬塔冲榜商店
    EPayType_RushArena            = 6,  --英灵殿冲榜商店
    EPayType_RushMap              = 7,  --推图冲榜商店
    EPayType_AirShipCash          = 8,  --高级战令
    EPayType_GuildWar             = 9,  -- 公会战
    EPayType_RushPet              = 10; --宠物冲榜
    EPayType_RushSkill            = 11; --技能冲榜
    EPayType_IdolShop             = 12  --偶像季礼包
}

PayState = {
    Idle = 1,           -- 空闲中
    Ordering = 2,       -- 正在获得订单号
    Ordered = 3,        -- 获得订单号完成（一般来说，会立即到 SDKPaying 状态）
    SDKPaying = 4,      -- 启动SDK支付中
    SDKPayComplete = 5, -- SDK支付完成
    ServerPayComplete = 6, --Server返回的支付完成 （一般来说，会立即回到 Idle 状态）
}

function PayMgr:ctor()
    self.lastSendMsgTimeMap = nil
    self.payState = PayState.Idle
    self.curPayData = nil
    self.rechargeData = {}
    self:RegisterNetEvents()
end

function PayMgr:Clear()
    self.lastSendMsgTimeMap = nil
    self.curPayData = nil
    self.payState = PayState.Idle
    self.rechargeData = {}
    if self.waitTimer then
        self.waitTimer:Stop()
        self.waitTimer = nil
    end
end

function PayMgr:Destroy()
    self.lastSendMsgTimeMap = nil
    self.payState = nil
    self.curPayData = nil
    self.rechargeData = nil
    if self.waitTimer then
        self.waitTimer:Stop()
        self.waitTimer = nil
    end
    self:UnRegisterNetEvents()
end

function PayMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PAY_INFO_GET_ACK, self.OnGetPayInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PAY_FOR_GOODS_NTF, self.OnPayCompleteNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PAY_INFO_NTF, self.OnPayInfoNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PAY_INFO_ORDER_OK_LIST_GET_ACK, self.OnStartUpPayCompleteAck, self)
end

function PayMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PAY_INFO_GET_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PAY_FOR_GOODS_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PAY_INFO_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PAY_INFO_ORDER_OK_LIST_GET_ACK)
end

function PayMgr:OnGetPayInfoAck(data)
    LogWarning('[wboy] SC_PAY_INFO_GET_ACK ' .. Inspect(data))
    if not data then
        LogError('[wboy] message data is Error !!!')
        return
    end
    if not self.curPayData then
        LogError('[wboy] cur pay data is Error !!!')
        return
    end
    if self.curPayData.goods_id ~= data.goods_id
        or self.curPayData.goods_type ~= data.goods_type
        or self.curPayData.count ~= data.count
    then
        LogError('[wboy] message data and cur pay data is not same !!!')
        return
    end
    if ManagerContainer.NetManager:IsErrorData(data) then
        LogWarning("Test Pay >>>>>>>>>>>>>>>>>>>>>>>>")
        if data then
            if data.error == Enum.NetErrorCode.ERROR_PAY_PRODUCTION_MODE then
                -- 测试环境
                self:SdkPayResult(true)
                return
            elseif data.error == Enum.NetErrorCode.ERROR_PAY_GOOD_PRICE_FREE then
                -- 商品免费
                self:SdkPayResult(true)
                return
            end
        end
        self:InterruptCurPay()
        return
    end
    if self.payState ~= PayState.Ordering then return end
    self.payState = PayState.Ordered
    self.curPayData.orderId = data.cp_order_id
    self.payState = PayState.SDKPaying
    self:StartWaiting(3)
    self:SdkPayResult(false)
    -- 启动支付SDK

    -- local ext_info = {
    --     playerId: ManagerContainer.LuaGameMgr.openId
    -- }

    local new_cp_id = tostring(data.cp_order_id) .."_" ..tostring(data.s_id)
    LogWarning("new_cp_id -----------> "..new_cp_id)
    ManagerContainer.LuaGameMgr:SdkPay(data.goods_id, data.goods_name, '感谢您的支付，祝你有个愉快的游戏体验', data.count, CommonUtil.GetValidPayPrice(data.amount), new_cp_id, tostring(ManagerContainer.DataMgr.UserData:GetUserId()))
end

function PayMgr:OnPayCompleteNtf(data)
    -- LogError('[wboy] SC_PAY_FOR_GOODS_NTF ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PAY_SERVER_COMPLETED, false)
        return
    end
    self:ServerPayComplete(data.goods_type, data.goods_id, data.goods_num, data.cp_order_id, data.item_list)
end

function PayMgr:OnPayInfoNtf(data)
    -- LogError('[wboy] SC_PAY_INFO_NTF ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local lastTotalRecharge = self.rechargeData.totalRecharge or 0
    local lastDayRecharge = self.rechargeData.dayRecharge or 0
    local totalRecharge = CommonUtil.GetValidPayPrice(data.total_recharge or 0)
    local dayRecharge = CommonUtil.GetValidPayPrice(data.day_recharge or 0)
    self.rechargeData.totalRecharge = totalRecharge
    self.rechargeData.dayRecharge = dayRecharge

    if totalRecharge ~= lastTotalRecharge then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PAY_TOTAL_RECHARGE_CHANGED)
        if dayRecharge > lastDayRecharge then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PAY_DAY_RECHARGE_CHANGED, false)
        else
            -- 当天充值数量重置了
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PAY_DAY_RECHARGE_CHANGED, true)
        end
    else
        if dayRecharge ~= lastDayRecharge then
            -- 当天充值数量重置了
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PAY_DAY_RECHARGE_CHANGED, true)
        end
    end
end

function PayMgr:OnStartUpPayCompleteAck(data)
    LogError('[wboy] SC_PAY_INFO_ORDER_OK_LIST_GET_ACK ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    self:CommonShowPayResult(data.reward_item_list)
end

function PayMgr:SendGetPayInfo(goodsType, goodsId, goodsNum)
    if not self:IsCanSend(1) then return false end
    self:ClearCurPayData()
    self.payState = PayState.Ordering
    local curPayData =
    {
        goods_type = goodsType,
        goods_id = goodsId,
        count = goodsNum,
    }

    LogWarning("PayMgr:SendGetPayInf : "..Inspect(curPayData))

    self.curPayData = curPayData
    self:RecordCurTime(2)
    self:StartWaiting()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PAY_INFO_GET_REQ, curPayData)
    return true
end

function PayMgr:SendStartUpPayComplete()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PAY_INFO_ORDER_OK_LIST_GET_REQ)
end

function PayMgr:IsCanSend(key, cdTime)
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    if not self.lastSendMsgTimeMap then
        self.lastSendMsgTimeMap = {}
        self.lastSendMsgTimeMap[key] = curTime
        return true
    end
    local lastTime = self.lastSendMsgTimeMap[key]
    if lastTime then
        local cd = cdTime or REQ_PAY_CD
        if (curTime - lastTime) < cd then
            return false
        end
    end
    self.lastSendMsgTimeMap[key] = curTime
    return true
end

function PayMgr:RecordCurTime(key)
    if not self.lastSendMsgTimeMap then
        self.lastSendMsgTimeMap = {}
    end
    self.lastSendMsgTimeMap[key] = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
end

function PayMgr:ClearCurPayData()
    self.curPayData = nil
    self.payState = PayState.Idle
end

function PayMgr:SdkPayResult(success)
    self.payState = PayState.SDKPayComplete
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PAY_CLIENT_COMPLETED, success)
    if not self.curPayData then
        -- 能到这里，说明已经收到了服务返回的支付结果，则不再做后续处理
        self:EndWaiting()
        self:ClearCurPayData()
        return
    end
    if success then
        self:StartWaiting()
    else
        self:EndWaiting()
        self:ClearCurPayData()
    end
end

function PayMgr:InterruptCurPay()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PAY_CLIENT_COMPLETED, false)
    self:EndWaiting()
    self:ClearCurPayData()
end



function PayMgr:InitRechargeData(data)
    if not data then return nil end
    self.rechargeData.totalRecharge = CommonUtil.GetValidPayPrice(data.total_recharge or 0)
    self.rechargeData.dayRecharge = CommonUtil.GetValidPayPrice(data.day_recharge or 0)
end

--- 支付
---@param goodsType Enum.PayGoodsType 支付类型
---@param goodsId integer 支付商品Id
---@param goodsNum integer 支付数量
---@return Enum.InitPayErrorCode
function PayMgr:Pay(goodsType, goodsId, goodsNum)
    if self.payState == PayState.Ordering or self.payState == PayState.Ordered then
        -- 处理超时，则丢弃上一次的支付
        if not self:IsCanSend(2, EXCPETION_WAIT_TIMESTAMP) then
            return Enum.InitPayErrorCode.Paying
        end
    elseif self.payState == PayState.SDKPaying then
        -- 处理超时，则丢弃上一次的支付
        if not self:IsCanSend(2, EXCPETION_WAIT_TIMESTAMP) then
            return Enum.InitPayErrorCode.Paying
        end
    end
    local success = self:SendGetPayInfo(goodsType, goodsId, goodsNum)
    if not success then
        return Enum.InitPayErrorCode.OperateFreq
    end
    return Enum.InitPayErrorCode.Success
end


function PayMgr:GetDayRecharge()
    return self.rechargeData and self.rechargeData.dayRecharge or 0
end

function PayMgr:GetTotalRecharge()
    return self.rechargeData and self.rechargeData.totalRecharge or 0
end

function PayMgr:CommonShowPayResult(itemList)
    if ManagerContainer.LuaUIMgr:IsBatting() then
        return
    end
    if not itemList then return end
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

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RANK_ACTIVITY_REWARD_SUCCESS_NTF)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.LIMIT_RECHARGE_PAY_SUCCESS_NTF)
end

function PayMgr:StartWaiting(time)
    if not self.waitTimer then
        self.waitTimer = Timer.New(slot(self.EndWaiting, self), time or EXCPETION_WAIT_TIME, 1, true)
    else
        self.waitTimer.time = time or EXCPETION_WAIT_TIME
        self.waitTimer.duration = time or EXCPETION_WAIT_TIME
    end
    if not self.waitTimer.running then
        self.waitTimer:Start()
    end
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPayWaiting)
end

function PayMgr:EndWaiting()
    if self.waitTimer and self.waitTimer.running then
        self.waitTimer:Stop()
    end
    ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIPayWaiting)
end






----------------------------- 以下接口是为每个支付方式单独提供支付传参API，这样外部就不用管传参不一样了 ------------------------

--- 由服务器返回的支付结果，不一定为当前购买的结果（有延迟的数据）
function PayMgr:ServerPayComplete(goodsType, goodsId, goodsNum, orderId, itemList)
    -- if goodsType == PayGoodsType.EPayType_Discount then
    -- elseif goodsType == PayGoodsType.EPayType_MonthCard then
    -- elseif goodsType == PayGoodsType.EPayType_NormalBag then
    -- elseif goodsType == PayGoodsType.EPayType_LimitBag then
    -- end
    self:CommonShowPayResult(itemList)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PAY_SERVER_COMPLETED, true)

    if self.curPayData then
        if self.curPayData.goods_id ~= goodsId
            or self.curPayData.goods_type ~= goodsType
            or self.curPayData.count ~= goodsNum
        then
            return
        end
        if (self.curPayData.orderId and self.curPayData.orderId ~= 0)
            and (orderId and orderId ~= 0)
            and self.curPayData.orderId ~= orderId
        then
            return
        end
    end
    self.payState = PayState.ServerPayComplete
    self:EndWaiting()
    self:ClearCurPayData()
end

function PayMgr:GetInitPayErrorCodeLangKey(errorCode)
    if errorCode == Enum.InitPayErrorCode.OperateFreq then
        return 'PayError_Frequency'
    elseif errorCode == Enum.InitPayErrorCode.Paying then
        return 'PayError_Paying'
    elseif errorCode == Enum.InitPayErrorCode.ValidPay then
        return 'PayError_ValidPay'
    end
    return nil
end

function PayMgr:RuneShopPay(runeShopType, runeShopSubType, goodsId)
    if runeShopType == Enum.RuneShopType.MonthCard then
        return self:Pay(PayGoodsType.EPayType_MonthCard, goodsId, 1)
    elseif runeShopType == Enum.RuneShopType.Gifts then
        if runeShopSubType == Enum.RuneShopSubType.Daily then
            return self:Pay(PayGoodsType.EPayType_NormalBag, goodsId, 1)
        elseif runeShopSubType == Enum.RuneShopSubType.Week then
            return self:Pay(PayGoodsType.EPayType_NormalBag, goodsId, 1)
        elseif runeShopSubType == Enum.RuneShopSubType.Month then
            return self:Pay(PayGoodsType.EPayType_NormalBag, goodsId, 1)
        elseif runeShopSubType == Enum.RuneShopSubType.Gold then
            return self:Pay(PayGoodsType.EPayType_NormalBag, goodsId, 1)
        end
    elseif runeShopType == Enum.RuneShopType.LimitTime then
        return self:Pay(PayGoodsType.EPayType_LimitBag, goodsId, 1)
    elseif runeShopType == Enum.RuneShopType.GuildWar then
        return self:Pay(PayGoodsType.EPayType_GuildWar, goodsId, 1)
    elseif runeShopType == Enum.RuneShopType.IdolShop then
        return self:Pay(PayGoodsType.EPayType_IdolShop, goodsId, 1)
    end
    return Enum.InitPayErrorCode.ValidPay
end

--- 超值礼包
function PayMgr:LimitedGiftPay(goodsId)
    return self:Pay(PayGoodsType.EPayType_Discount, goodsId, 1)
end

--冲榜
function PayMgr:RankActivityPay(type, goodsId)
    if type == Enum.RankActivitiesType.ClimbingTower then
        return self:Pay(PayGoodsType.EPayType_RushTower, goodsId, 1)
    elseif type == Enum.RankActivitiesType.Dojo then
        return self:Pay(PayGoodsType.EPayType_RushArena, goodsId, 1)
    elseif type == Enum.RankActivitiesType.MapProgress then
        return self:Pay(PayGoodsType.EPayType_RushMap, goodsId, 1)
    elseif type == Enum.RankActivitiesType.Pet then
        return self:Pay(PayGoodsType.EPayType_RushPet, goodsId, 1)
    elseif type == Enum.RankActivitiesType.Skill then
        return self:Pay(PayGoodsType.EPayType_RushSkill, goodsId, 1)
    end
end

--悬赏战令
function PayMgr:AirShipPay(goodsId)
    return self:Pay(PayGoodsType.EPayType_AirShipCash ,goodsId ,1 )
end
return PayMgr