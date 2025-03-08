local RuneShopDataMgr = class("RuneShopDataMgr", require("DataBase"))

local RuneShopBaseData = require('RuneShop/RuneShopBaseData')

local RuneShopReardsBaseData = require('RuneShop/RuneShopRewardsBaseData')

local RUNESHOP_REQ_CD = 2000

function RuneShopDataMgr:ctor()
    self.runeShopDatas = {}
    self.forceCheck = false
end

function RuneShopDataMgr:Clear()
    self.runeShopDatas = {}
    self.forceCheck = false
end

function RuneShopDataMgr:Destroy()
    self.runeShopDatas = nil
    self.lastSendMsgTimeMap = nil
    self:UnRegisterNetEvents()
end

function RuneShopDataMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_RUNE_SHOP_INFO_ACK, self.OnRuneShopInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_RUNE_SHOP_BUY_ITEM_NTF, self.OnRuneShopInfoNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_RUNE_FREE_RED_CHANGE_INFO_NTF, self.OnRuneShopFreeItemChangeNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPLORE_INFO_ACK, self.OnRuneShopRewardInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPLORE_EXTRA_REWARD_ACK, self.OnRuneShopRewardExtraAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPLORE_REWARD_ACK, self.OnRuneShopRewardACK, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPLORE_EXP_CHANGE_NTF, self.OnRuneShopExchangeNtf, self)
end

function RuneShopDataMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_RUNE_SHOP_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_RUNE_SHOP_BUY_ITEM_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_RUNE_FREE_RED_CHANGE_INFO_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EXPLORE_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EXPLORE_EXTRA_REWARD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EXPLORE_REWARD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EXPLORE_EXP_CHANGE_NTF, self.OnRuneShopExchangeNtf, self)
end

function RuneShopDataMgr:OnRuneShopInfoAck(data)
    --  LogError('[wboy] SC_RUNE_SHOP_INFO_ACK ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local runeShopType = data.shop_type
    local runeShopSubType = data.sub_shop
    local shopData = self:GetShopData(runeShopType, runeShopSubType, true)
    if not shopData then return end
    shopData:SetData(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RUNE_SHOP_DATA_CHANGED, runeShopType, runeShopSubType)
    if runeShopType == Enum.RuneShopType.LimitTime then
        ManagerContainer.RedPointMgr.RSLimitGiftRPCtr:RefreshLimitGiftRedPointByShopData(shopData)
    end
end

function RuneShopDataMgr:OnRuneShopInfoNtf(data)
    --  LogError('[wboy] SC_RUNE_SHOP_BUY_ITEM_NTF ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local shopItem = data.shop_item
    if not shopItem then return end
    local runeShopType = data.shop_type
    local runeShopSubType = data.sub_shop
    local shopData = self:GetShopData(runeShopType, runeShopSubType)
    if not shopData then return end
    shopData:RefreshOneGoodsData(shopItem)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RUNE_SHOP_DATA_CHANGED, runeShopType, runeShopSubType)
end

function RuneShopDataMgr:OnRuneShopFreeItemChangeNtf(data)
    -- LogError('[wboy] SC_RUNE_FREE_RED_CHANGE_INFO_NTF ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local runeReds = data.rune_red
    local red1 = false
    local red2 = false
    local red3 = false
    for i = 1, #runeReds do
        local runeRed = runeReds[i]
        if runeRed.key == Enum.RuneShopType.Gifts then
            if runeRed.value == Enum.RuneShopSubType.Daily then
                red1 = true
            elseif runeRed.value == Enum.RuneShopSubType.Week then
                red2 = true
            elseif runeRed.value == Enum.RuneShopSubType.Month then
                red3 = true
            end
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopDaily, red1)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopWeek, red2)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopMonth, red3)
    ManagerContainer.RedPointMgr.RSLimitGiftRPCtr:RefreshLimitGiftRedPointByIds(data.limit_red)
end

function RuneShopDataMgr:RefreshRewardsData(data)
    local shopData = self:GetRewardsData()
    if not shopData then LogError('战令数据类不存在') return end
    shopData:SetRewardData(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RUNE_SHOP_REWARDS_DATA_CHANGED)
end

function RuneShopDataMgr:RefreshRecieveRewardsData(data)
    local shopData = self:GetRewardsData()
    if not shopData then return end
    
    shopData:SetRecRewardData(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RUNE_SHOP_REWARDS_DATA_CHANGED)
end

function  RuneShopDataMgr:RefreshExtraRewardsData(data)
    local shopData = self:GetRewardsData()
    if not shopData then return end
    
    shopData:SetRecExtraRewardData(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RUNE_SHOP_REWARDS_DATA_CHANGED)
end

function RuneShopDataMgr:RefreshExploreExpChange(data)
    local shopData = self:GetRewardsData()
    if not shopData then return end
    shopData:SetExpChangeData(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RUNE_SHOP_REWARDS_DATA_CHANGED)
end

function RuneShopDataMgr:OnRuneShopRewardInfoAck(data)
    --LogError('[xyh] SC_EXPLORE_REWARD_ACK ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    self.isRewardsDataDirty = false
    self.hasRewardData = true
    self:OnOnlineAirShipInfoAck(data)
    if self:GetAirShipIsOpen() then
        self:RefreshRewardsData(data)
    end
end

function RuneShopDataMgr:OnRuneShopRewardExtraAck(data)
    
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    if not data then return end
        self:RefreshExtraRewardsData(data)
    
    if  #data.award_item == 0 then return end 
    --LogError('[xyh] SC_EXPLORE_EXTRA_REWARD_ACK ' .. Inspect(data))
    
    local rewardList = { {cfgId= data.award_item[1].key,num = data.award_item[1].value}}
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot,{rewards = rewardList})
    
    
end

function RuneShopDataMgr:OnOnlineAirShipInfoAck(data)
    if data.bUnlock then
        self.isCash = 1
    else
        self.isCash = 0
    end
    self.airShipRewardEndTime = data.endTime
    self.airShipRewardStartTime = data.startTime
    self.airShipRewardsNextTime = data.nextStartTime
    if self.isCash == 0 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.AIRSHIP_ACTIVITY_DISPLAY_NTF,self:GetAirShipIsOpen())
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.AIRSHIP_ACTIVITY_DISPLAY_NTF,false)
    end
    
    --self:CheckAirShipActivityOpenTime()
end

function RuneShopDataMgr:OnRuneShopRewardACK(data)
    --LogError('[xyh] SC_EXPLORE_REWARD_ACK ' .. Inspect(data))
    if  #data.award_item == 0 then return end 
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local rewardList = { {cfgId= data.award_item[1].key,num = data.award_item[1].value}}
    --LogError('[xyh] SC_EXPLORE_REWARD_ACK ' .. Inspect(rewardList))
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot,{rewards = rewardList})

    self:RefreshRecieveRewardsData(data)
end

function RuneShopDataMgr:OnRuneShopExchangeNtf(data)
    --LogError('[xyh] SC_EXPLORE_EXP_CHANGE_NTF' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    self:RefreshExploreExpChange(data)
end


function RuneShopDataMgr:SendShopInfoReq(runeShopType, runeShopSubType)
    local id = runeShopType * 100 + (runeShopSubType or 0)
    if not self:IsCanSend(id) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_RUNE_SHOP_INFO_REQ, {shop_type = runeShopType, sub_shop = runeShopSubType})
    return true
end

function RuneShopDataMgr:SendRewardsInfoReq()
    local id = 7 * 100
    if not self:IsCanSend(id) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPLORE_INFO_REQ)
    self.isRewardsDataDirty = true
end

function RuneShopDataMgr:IsCanSend(key, cdTime)
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    if not self.lastSendMsgTimeMap then
        self.lastSendMsgTimeMap = {}
        self.lastSendMsgTimeMap[key] = curTime
        return true
    end
    local lastTime = self.lastSendMsgTimeMap[key]
    if lastTime then
        local cd = cdTime or RUNESHOP_REQ_CD
        if (curTime - lastTime) < cd then
            return false
        end
    end
    self.lastSendMsgTimeMap[key] = curTime
    return true
end


function RuneShopDataMgr:RefreshShopData(runeShopType, runeShopSubType, forceRefresh)
    if not forceRefresh then
        local shopData = self:GetShopData(runeShopType, runeShopSubType)
        if shopData then
            if shopData:IsValidData() then
                return
            end
        end
    end
    self:SendShopInfoReq(runeShopType, runeShopSubType)
end

function RuneShopDataMgr:RefreshRewardData()
    self:SendRewardsInfoReq()
end

function RuneShopDataMgr:GetShopData(runeShopType, runeShopSubType, isNewNil)
    local runeShopDatas = self.runeShopDatas[runeShopType]
    if not runeShopDatas then
        if not isNewNil then
            return nil
        end
        if runeShopType == Enum.RuneShopType.MonthCard then
            runeShopDatas = RuneShopBaseData:new()
            self.runeShopDatas[runeShopType] = runeShopDatas
        elseif runeShopType == Enum.RuneShopType.Gifts then
            runeShopDatas = {}
            self.runeShopDatas[runeShopType] = runeShopDatas
        elseif runeShopType == Enum.RuneShopType.LimitTime then
            runeShopDatas = RuneShopBaseData:new()
            self.runeShopDatas[runeShopType] = runeShopDatas
        elseif runeShopType == Enum.RuneShopType.RushTower then
            runeShopDatas = RuneShopBaseData:new()
            self.runeShopDatas[runeShopType] = runeShopDatas
        elseif runeShopType == Enum.RuneShopType.RushArena then
            runeShopDatas = RuneShopBaseData:new()
            self.runeShopDatas[runeShopType] = runeShopDatas
        elseif runeShopType == Enum.RuneShopType.RushMap then
            runeShopDatas = RuneShopBaseData:new()
            self.runeShopDatas[runeShopType] = runeShopDatas
        elseif runeShopType == Enum.RuneShopType.GuildWar then
            runeShopDatas = RuneShopBaseData:new()
            self.runeShopDatas[runeShopType] = runeShopDatas
        elseif runeShopType == Enum.RuneShopType.RushPet then
            runeShopDatas = RuneShopBaseData:new()
            self.runeShopDatas[runeShopType] = runeShopDatas
        elseif runeShopType == Enum.RuneShopType.RushSkill then
            runeShopDatas = RuneShopBaseData:new()
            self.runeShopDatas[runeShopType] = runeShopDatas
        elseif runeShopType == Enum.RuneShopType.IdolShop then
            runeShopDatas = RuneShopBaseData:new()
            self.runeShopDatas[runeShopType] = runeShopDatas
        end
    end
    if runeShopType ~= Enum.RuneShopType.Gifts then
        return runeShopDatas
    end
    if runeShopDatas[runeShopSubType] then
        return runeShopDatas[runeShopSubType]
    end
    if not isNewNil then
        return nil
    end
    runeShopDatas[runeShopSubType] = RuneShopBaseData:new()
    return runeShopDatas[runeShopSubType]
end

function RuneShopDataMgr:GetRewardsData()
    if not self.runeShopRewardsData then
        self.runeShopRewardsData = RuneShopReardsBaseData:new()
    end
    return self.runeShopRewardsData
end

function RuneShopDataMgr:GetCurAirShipActivityEndTime()
    return  self.airShipRewardEndTime
end

function RuneShopDataMgr:GetAirShipIsOpen()
    if not self.airShipRewardEndTime or not self.airShipRewardStartTime then
        return false
    end
    local endt =ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(self.airShipRewardEndTime, false)
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    local startt = curTime - self.airShipRewardStartTime
    if endt and startt then
        if endt > 0 and startt > 0 then
            return true
        end
    end
    return false
end

function RuneShopDataMgr:CheckAirShipActivityOpenTime()
    
    local needSend = false
    if self:GetAirShipIsOpen() then
        if not self.isCash then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.AIRSHIP_ACTIVITY_DISPLAY_NTF, false)
        else
            if self.isCash == 0 then
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.AIRSHIP_ACTIVITY_DISPLAY_NTF, true)
            else
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.AIRSHIP_ACTIVITY_DISPLAY_NTF, false)
            end
        end
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopRewards, false)
        local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
        if self.airShipRewardsNextTime then
            if curTime > self.airShipRewardsNextTime and self.airShipRewardsNextTime ~= 0 then
                needSend = true
            end
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.AIRSHIP_ACTIVITY_DISPLAY_NTF, false)
    end

    if not self.hasRewardData then
        needSend = true
    end

    if needSend then
        self:QueryAirShipActivityData()
    end

end

function RuneShopDataMgr:QueryAirShipActivityData()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPLORE_INFO_REQ)
end

function  RuneShopDataMgr:CheckMonthData()
    local monthShopData = self:GetShopData(Enum.RuneShopType.MonthCard, nil)
    if not monthShopData then
        self:SendShopInfoReq(Enum.RuneShopType.MonthCard,nil)
    else
        local mgoodsData = monthShopData:GetGoodsDataByIdx(1)
        if mgoodsData then
            local outTime = mgoodsData:HasResidueTime()
            if not outTime then
                return true
            end
        end
    end
    return false
end

function RuneShopDataMgr:CheckSuperMonth()
	local monthShopData = self:GetShopData(Enum.RuneShopType.MonthCard, nil)
    if not monthShopData then
        self:SendShopInfoReq(Enum.RuneShopType.MonthCard,nil)
    else
        local mgoodsData = monthShopData:GetGoodsDataByIdx(2)
        if mgoodsData then
            local outTime = mgoodsData:HasResidueTime()
            if not outTime then
                return true
            end
        end
	end
	return false
end


return RuneShopDataMgr