local RuneShopRewardsBaseData = class('RuneShopRewardsBaseData')
--local RuneShopRewardsBaseData = require('RuneShop/RuneShopGoodsData')
local RuneShopRewardsData = require('RuneShop/RuneShopRewardsData')
local BitUtil = require("BitUtil")

local function CompValidTimeData(a, b)
    if a and a > 0 then
        if not b or b > a then
            b = a
        end
    end
    return b
end

function RuneShopRewardsBaseData:ctor()
    self.runeShopType           = nil
    self.runeShopSubType        = nil
    self.endTime                = nil
    self.goodsDataMap           = nil

    self.needRefreshTime        = nil
    self.needRefreshDataTime    = nil
    self.showGoodsDatas         = nil
    self.hasFreeCanBuy          = nil

    self.curRewardsRound        = nil
    self.curRewardsLv           = nil
    self.totalRewardsExp        = nil
    self.maxRewardNum          = 0
    self.missionExp             = nil
end

function RuneShopRewardsBaseData:Dispose()
    self.endTime                = nil
    self.goodsDataMap           = nil

    self.needRefreshTime        = nil
    self.needRefreshDataTime    = nil
    self.showGoodsDatas         = nil
    self.hasFreeCanBuy          = nil

    self.curRewardsRound        = nil
    self.curRewardsLv           = nil
    self.totalRewardsExp        = nil
    self.maxRewardNum          = nil
    self.missionExp             = nil
end


function RuneShopRewardsBaseData:SetRewardData(data)
    local goodsData = nil
    local goodsDataMap = {}
    self.normalTotalExp = 0
    self.curRewardsRound = data.curRoune
    self.curRewardsLv = data.level
    self.totalRewardsExp = data.total_exp
    self.curRewardsExp = self.totalRewardsExp
    if data.bUnlock then
        self.isCash = 1
    else
        self.isCash = 0
    end
    self.endTime = data.endTime
    self.startTime = data.startTime
    self.nextStartTime = data.nextStartTime
    self.maxRewardNum = 0
    self.missionExp = data.missionExp
    self.isMax = data.fullAward
    self.drawRewar =  data.draw_rewar
    if self.endTime == 0  then
        return
    end
    local cfg = ManagerContainer.CfgMgr:GetRShopRewardsCfgByRound(self.curRewardsRound)
    if not cfg  then
        return
    end
    local stateData = {}
    for i=1 , #cfg do
        local goods = cfg[i]
        goodsData = nil
        if not goodsData then
            goodsData = RuneShopRewardsData:new()
        end
        self.normalTotalExp = self.normalTotalExp + goods.Exp
        
        if i < self.curRewardsLv or i == self.curRewardsLv then
            if self.isCash == 1 then
                stateData[i] = {2,2}
            else
                stateData[i] = {2,0}
            end
            local nor
            local cash
            if #self.drawRewar ~= 0 then
                if  i < 32 or i == 32 then
                    if  BitUtil.RshiftNumBandOne(self.drawRewar[1].key ,i -1  ) == 1   then
                        nor = 1
                    end
                    if  BitUtil.RshiftNumBandOne(self.drawRewar[1].value ,i-1  ) == 1   then
                        
                        cash = 1
                    end
                else
                    local n = 1
                    
                    while(i>32)
                    do
                        i = i -32
                        n = n +1
                    end
                    if  BitUtil.RshiftNumBandOne(self.drawRewar[n].key ,i-1  ) == 1   then
                        nor = 1
                    end
                    if  BitUtil.RshiftNumBandOne(self.drawRewar[n].value ,i-1  ) == 1   then
                        cash = 1
                    end
                end
            end
    
            if nor then
                stateData[i] = {nor ,stateData[i][2] }
            end
            if cash then
                stateData[i] = {stateData[i][1] , cash}
            end
            if stateData[i][1] == 2 or stateData[i][2] == 2 then
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopRewards, true)
            end
            if self.curRewardsLv ~= 0 then
                self.curRewardsExp = self.curRewardsExp - goods.Exp
            end
        end
        goodsData:SetData(stateData[i],cfg[i])
        goodsDataMap[i] = goodsData
    end
    self.goodsDataMap   = goodsDataMap
    if self.curRewardsLv == #cfg then
        local ne = (self.totalRewardsExp - self.normalTotalExp)/ManagerContainer.CfgMgr:GetRuneShopExploreCfgByRound(self.curRewardsRound).ExpCost
        self.maxRewardNum =  self:Toint(ne)
    end
    self:RefreshShowRewardsData()
end

function  RuneShopRewardsBaseData:SetRecRewardData(data)
    local goodData = self:GetGoodsDataByIdx(data.level)
    local da = goodData:GetData()
    local cfg = goodData:GetCfgData()
    if data.type == 1 then
        da = {1 ,da[2]}
    elseif data.type == 2 then
        da = {da[1] ,1}
    end
    goodData:SetData(da, cfg)
    self.goodsDataMap[data.level] = goodData
    self:RefreshShowRewardsData()
end

function RuneShopRewardsBaseData:SetRecExtraRewardData(data)
    
    self.missionExp = data.missionExp
    self.curRewardsExp = self.curRewardsExp - (self.totalRewardsExp - data.total_exp)
    self.totalRewardsExp =data.total_exp
    local ne = (self.totalRewardsExp - self.normalTotalExp)/ManagerContainer.CfgMgr:GetRuneShopExploreCfgByRound(self.curRewardsRound).ExpCost
    self.maxRewardNum =  self:Toint(ne)
end
function RuneShopRewardsBaseData:Toint(n)
    local s = tostring(n)
    local i,j = s:find('%.')
    if i then
        return tonumber(s:sub(1,i-1))
    else
        return n
    end
end

function RuneShopRewardsBaseData:SetExpChangeData(data)
    if not self.curRewardsLv then
        return
    end
    if data.level > self.curRewardsLv then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopRewards, true)
    end
    self.curRewardsLv = data.level
    self.totalRewardsExp =data.total_exp
    self.missionExp = data.missionExp
end

function RuneShopRewardsBaseData:RefreshShowRewardsData()
    local showGoodsDatas        = {}
    local needRefreshTime       = nil
    local needRefreshDataTime   = nil
    self.showRewardsData        = {}
    for _, goodsData in pairs(self.goodsDataMap) do
        local isShow, refreshTime, refreshDataTime = goodsData:GetShowInfo()
        showGoodsDatas[#showGoodsDatas+1] = goodsData
        needRefreshTime = CompValidTimeData(refreshTime, needRefreshTime)
        needRefreshDataTime = CompValidTimeData(refreshDataTime, needRefreshDataTime)
    end
    self.showRewardsData = showGoodsDatas
    self.needRefreshDataTime    = needRefreshDataTime
    self.needRefreshTime        = needRefreshTime
end

function RuneShopRewardsBaseData:SortShowData()
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

function RuneShopRewardsBaseData:GetGoodsDataByIdx(idx)
    return self.goodsDataMap[idx]
end

function RuneShopRewardsBaseData:GetShowGoodsDatas()
    return self.showGoodsDatas
end

function RuneShopRewardsBaseData:GetShowRewardsData()
    return self.showRewardsData
end

function RuneShopRewardsBaseData:GetShowRewardsRoundData()
    return self.curRewardsRound
end

function RuneShopRewardsBaseData:GetShowRewardsCurLv()
    return self.curRewardsLv
end

function RuneShopRewardsBaseData:GetRewardsCurRoundCfg()
    return ManagerContainer.CfgMgr:GetRuneShopExploreCfgByRound(self.curRewardsRound)
end

function RuneShopRewardsBaseData:GetShowRewaradsTotalExp()
    return self.totalRewardsExp
end

function RuneShopRewardsBaseData:GetShowRewardsCurExp()
    return self.curRewardsExp
end

function RuneShopRewardsBaseData:GetRewardsIsCash()
    return self.isCash
end

function RuneShopRewardsBaseData:GetMaxRewardsNum()
    return self.maxRewardNum
end

function RuneShopRewardsBaseData:GetRewardsGoldExp()
    return self.goldExp
end

function RuneShopRewardsBaseData:GetRewardsMissionExp()
    return self.missionExp
end

function RuneShopRewardsBaseData:GetRewardsIsMax()
    return self.isMax
end

function RuneShopRewardsBaseData:GetRewardsMaxRewardsNum()
    return self.maxRewardsNum
end

function RuneShopRewardsBaseData:GetShowReardsNearMinCashReward(min)
    if min == nil or min < 0 or min == 0 then return nil end
    local goods
    for i = min , 1 ,-1 do
        goods = self:GetGoodsDataByIdx(i)
        if goods then
            if goods.cfgData.RewardSign > 0 then
                if goods.cfgData.RewardSign == 1 then
                    if goods.isReward then
                        if  goods.isReward ~= 1 then
                            return i
                        end
                    else
                        return i
                    end
                elseif goods.cfgData.RewardSign == 2 then
                    if goods.isCashReward then
                        if  goods.isCashReward ~= 1 then
                            return i
                        end
                    else
                        return i
                    end
                end
            end
        end
    end
    return nil
end

function RuneShopRewardsBaseData:GetShowReardsNearMaxCashReward(max)
    if max == nil or max > #self:GetShowRewardsData() then return nil end
    local goods
    for i=max , #self:GetShowRewardsData() do
        goods = self:GetGoodsDataByIdx(i)
        if goods then
            if goods.cfgData.RewardSign > 0  then
                if goods.cfgData.RewardSign == 1 then
                    if goods.isReward then
                        if  goods.isReward ~= 1 then
                            return i
                        end
                    else
                        return i
                    end
                elseif goods.cfgData.RewardSign == 2 then
                    if goods.isCashReward then
                        if  goods.isCashReward ~= 1 then
                            return i
                        end
                    else
                        return i
                    end
                end
            end
        end
    end
    return nil
end

function RuneShopRewardsBaseData:IsValidShow()
    if not self.needRefreshTime then
        return true
    end
    local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(self.needRefreshTime)
    return remainTime >= 0
end

function RuneShopRewardsBaseData:IsValidData()
    if not self.needRefreshDataTime then
        return true
    end
    local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(self.needRefreshDataTime)
    return remainTime >= 0
end

function RuneShopRewardsBaseData:RefreshRemainTime()
    if not self.needRefreshDataTime then
        return nil
    end
    return ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(self.needRefreshDataTime)
end

function RuneShopRewardsBaseData:RefreshRewaradsRemainTime()
    return ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(self.endTime)
end


return RuneShopRewardsBaseData