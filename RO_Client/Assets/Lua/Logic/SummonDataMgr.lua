local SummonDataMgr = class('SummonDataMgr', require('DataBase'))
local JSON = require('json')
local CACHE_SUMMON_KEY_NAME = "Cache_Summon_Key"

local REQ_SUMMON_CD = 1000

function SummonDataMgr:ctor()
    self.lastSendMsgTimeMap = nil           -- 发送消息的冷却时间，避免操作过快
    self.summonData = nil                   -- 召唤后的表现数据
    self.summonMap = nil                    -- 各种召唤记录的额外奖励次数
    self.cacheSummonData = nil              -- 红点等本地缓存的数据
end

function SummonDataMgr:Clear()
    self.lastSendMsgTimeMap = nil
    self.summonData = nil
    self.summonMap = nil
    self.cacheSummonData = nil
end

function SummonDataMgr:Destroy()
    self.lastSendMsgTimeMap = nil
    self.summonData = nil
    self.summonMap = nil
    self.cacheSummonData = nil
    self:UnRegisterNetEvents()
end

function SummonDataMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DRAW_CARD_ACK, self.OnSummonAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVITY_SUMMON_ACK, self.OnActivitySummonAck, self)
end

function SummonDataMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_DRAW_CARD_ACK)
end

function SummonDataMgr:OnActivitySummonAck(data)
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    if self.summonData then return end
    local summonCfg = ManagerContainer.CfgMgr:GetAllSummonCfg()
    local type = 0
    for k, v in pairs(summonCfg) do
        if data.activity_id == v.ActivitiesId then
            type = v.Id
        end
    end
    local summonType = type
    local summonNum = data.draw_count
    local summonAdd = data.add_point
    local summonTotal = data.draw_times
    self:SetSummonNum(summonType, summonTotal)

    local rewards = nil
    local extraRewards = nil

    local itemList = data.item_list
    local item, cfgId, num, isNew
    if itemList then
        rewards = {}
        for i = 1, #itemList do
            item = itemList[i]
            if item then
                cfgId = item.item_id
                num = item.item_num
                isNew = item.is_new
                local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
                if not itemCfgData then
                    LogError("[Wboy] .. ".. tostring(cfgId) .. " 道具ID不存在")
                else
                    rewards[#rewards + 1] = {cfgId = cfgId, num = num, isNew = isNew}
                end
            end
        end
    end
    local extraItemList = data.extra_item
    if extraItemList then
        extraRewards = {}
        for i = 1, #extraItemList do
            item = extraItemList[i]
            if item then
                cfgId = item.item_id
                num = item.item_num
                isNew = item.is_new
                local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
                if not itemCfgData then
                    LogError("[Wboy] .. ".. tostring(cfgId) .. " 道具ID不存在")
                else
                    extraRewards[#extraRewards + 1] = {cfgId = cfgId, num = num, isNew = isNew}
                end
            end
        end
    end
    if not rewards or #rewards <= 0 then
        self.summonData = nil
        return
    end
    local summonData = {
        summonType = summonType,
        summonNum = summonNum,
        summonAdd = summonAdd,
        summonTotal = summonTotal,
        rewards = rewards,
        extraRewards = extraRewards,
    }
    self.summonData = summonData
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SUMMON_DATA_CHANGED)
end

function SummonDataMgr:OnSummonAck(data)
    -- LogError('[wboy] OnSummonAck ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    if self.summonData then return end
    local summonType = data.draw_type
    local summonNum = data.draw_count
    local summonAdd = data.add_point
    local summonTotal = data.draw_times
    self:SetSummonNum(summonType, summonTotal)

    local rewards = nil
    local extraRewards = nil

    local itemList = data.item_list
    local item, cfgId, num, isNew
    if itemList then
        rewards = {}
        for i = 1, #itemList do
            item = itemList[i]
            if item then
                cfgId = item.item_id
                num = item.item_num
                isNew = item.is_new
                local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
                if not itemCfgData then
                    LogError("[Wboy] .. ".. tostring(cfgId) .. " 道具ID不存在")
                else
                    rewards[#rewards + 1] = {cfgId = cfgId, num = num, isNew = isNew}
                end
            end
        end
    end
    local extraItemList = data.extra_item
    if extraItemList then
        extraRewards = {}
        for i = 1, #extraItemList do
            item = extraItemList[i]
            if item then
                cfgId = item.item_id
                num = item.item_num
                isNew = item.is_new
                local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
                if not itemCfgData then
                    LogError("[Wboy] .. ".. tostring(cfgId) .. " 道具ID不存在")
                else
                    extraRewards[#extraRewards + 1] = {cfgId = cfgId, num = num, isNew = isNew}
                end
            end
        end
    end
    if not rewards or #rewards <= 0 then
        self.summonData = nil
        return
    end
    local summonData = {
        summonType = summonType,
        summonNum = summonNum,
        summonAdd = summonAdd,
        summonTotal = summonTotal,
        rewards = rewards,
        extraRewards = extraRewards,
    }
    self.summonData = summonData
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SUMMON_DATA_CHANGED)
end

---@param summonType integer  召唤类型
---@param summonNum integer  召唤次数
function SummonDataMgr:SendSummonReq(summonType, summonNum)
    if not self:IsCanSend(1) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_DRAW_CARD_REQ, {draw_type = summonType, draw_count = summonNum})
    return true
end

function SummonDataMgr:SendActivitySummonReq(summonType, summonNum)
    if not self:IsCanSend(1) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVITY_SUMMON_REQ, {activity_id = summonType, summon_count = summonNum})
    return true
end

function SummonDataMgr:IsCanSend(key, cdTime)
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    if not self.lastSendMsgTimeMap then
        self.lastSendMsgTimeMap = {}
        self.lastSendMsgTimeMap[key] = curTime
        return true
    end
    local lastTime = self.lastSendMsgTimeMap[key]
    if lastTime then
        local cd = cdTime or REQ_SUMMON_CD
        if (curTime - lastTime) < cd then
            return false
        end
    end
    self.lastSendMsgTimeMap[key] = curTime
    return true
end

function SummonDataMgr:InitSummonMap(datas)
    if datas then
        local summonMap = self.summonMap
        if not summonMap then
            summonMap = {}
            self.summonMap = summonMap
        end
        local drawDatas = datas.draw_system
        if drawDatas and #drawDatas > 0 then
            local drawData, summonType, summonNum
            for i = 1, #drawDatas do
                drawData = drawDatas[i]
                if drawData then
                    summonType = drawData.draw_type or 0
                    summonNum = drawData.draw_times or 0
                    summonMap[summonType] = summonNum
                end
            end
        end
    end
    self:CalcRedPoint(true)
end

function SummonDataMgr:GetSummonNum(summonType)
    if self.summonMap then
        return self.summonMap[summonType] or 0
    end
    return 0
end

function SummonDataMgr:SetSummonNum(summonType, summonNum)
    if not self.summonMap then
        self.summonMap = {}
    end
    self.summonMap[summonType] = summonNum
end


function SummonDataMgr:GetSummonData()
    return self.summonData
end

function SummonDataMgr:ClearSummonData()
    self.summonData = nil
end



function SummonDataMgr:GetSendSummonReqErrorCode(summonType, methodIdx)
    local cfg = ManagerContainer.CfgMgr:GetSummonCfgById(summonType)
    local method = cfg.Method
	if not method then
		return 2
	end
	local summonNum = method[methodIdx]
	if not summonNum then
		return 3
	end
	local costs = cfg.Cost
	if not costs then
		return 4
	end
	local costLength = #costs
	if costLength <= 0 then
		return 4
	end
	local vaildCosts = {}
	local remainSummonNum = summonNum
	local cost, costCfgId, costNum, costSummonNum, ownNum
	for i = 1, costLength do
		cost = costs[i]
		costCfgId = tonumber(cost[1])
		costNum = tonumber(cost[2])
		ownNum = CommonUtil.GetOwnResCountByItemId(costCfgId)
		costSummonNum = Mathf.Floor(ownNum / costNum)
		if costSummonNum >= remainSummonNum then
			vaildCosts[#vaildCosts + 1] = {costCfgId, ownNum, costNum, remainSummonNum}
			return 0, summonNum, 0, vaildCosts
		else
			remainSummonNum = remainSummonNum - costSummonNum
			vaildCosts[#vaildCosts + 1] = {costCfgId, ownNum, costNum, costSummonNum}
		end
	end
	return 1, summonNum, remainSummonNum, vaildCosts
end

function SummonDataMgr:IsRedPoint()
    local cfgSource = ManagerContainer.CfgMgr:GetAllSummonCfg()
    for id, cfg in pairs(cfgSource) do
        local method = cfg.Method
        if method then
            local summonNum = method[#method]
            local costs = cfg.Cost
            if costs then
                if #costs >= 1 then
                    local cost = costs[1]
                    local costCfgId = tonumber(cost[1])
                    local costNum = tonumber(cost[2])
                    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(costCfgId)
                    if itemCfgData and itemCfgData.ResType ~= Enum.ItemType.Diamond then
                        if costNum * summonNum <= CommonUtil.GetOwnResCountByItemId(costCfgId) then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

function SummonDataMgr:CalcRedPoint(forceSendMsg)
    if not self.cacheSummonData then
        self:ReadCacheSummonData()
    end
    local curTime = ManagerContainer.LuaTimerMgr:GetTimeSecond()
    if self.cacheSummonData then
        if self.cacheSummonData.rp then
            if forceSendMsg then
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.Summon, false)
            end
            return
        end
        local lastTime  = self.cacheSummonData.time
        if lastTime then
            if curTime < lastTime then
                if forceSendMsg then
                    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.Summon, false)
                end
                return
            end
        end
    end
    local isRedPoint = self:IsRedPoint()
    if isRedPoint then
        if not self.cacheSummonData then
            self.cacheSummonData = {}
        end
        local curDate = os.date("*t", curTime)
        -- 以本地时区计算的结果，并非精确值， 如果后续功能需要精确值，需要服务器下发
        local nextTime = os.time({year = curDate.year, month = curDate.month, day = curDate.day, hour = 5})
        if curDate.hour >= 5 then
            nextTime = nextTime + 24 * 3600
        end
        self.cacheSummonData.rp = isRedPoint
        self.cacheSummonData.time = nextTime
        self:WriteCacheSummonData()
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.Summon, true)
    end
end

function SummonDataMgr:ClearRedPoint()
    if self.cacheSummonData then
        if self.cacheSummonData.rp then
            self.cacheSummonData.rp = false
            self:WriteCacheSummonData()
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.Summon, false)
        end
    end
end

function SummonDataMgr:ReadCacheSummonData()
    local cacheSummonDataStr = ManagerContainer.PlayerPrefsMgr:GetString(CACHE_SUMMON_KEY_NAME, '')
    local cacheSummonData = JSON:decode(cacheSummonDataStr)
    if not cacheSummonData then
        cacheSummonData = {}
    end
    self.cacheSummonData = cacheSummonData
end

function SummonDataMgr:WriteCacheSummonData()
    if self.cacheSummonData then
        local cacheSummonDataStr = JSON:encode(self.cacheSummonData)
        ManagerContainer.PlayerPrefsMgr:SetString(CACHE_SUMMON_KEY_NAME, cacheSummonDataStr)
    else
        ManagerContainer.PlayerPrefsMgr:SetString(CACHE_SUMMON_KEY_NAME, '')
    end
end

return SummonDataMgr