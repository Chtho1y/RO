local FashionData = class("FashionData", require("DataBase"))
local JSON = require('json')

local CACHE_FASHION_KEY_NAME = "Cache_Fashion_Key"

function FashionData:ctor()
    self.data = {}
    self.data.fashionMap = {}
    self.data.fashionSuitMap = {}
end

function FashionData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FASHION_NTF, function(data)
        if ManagerContainer.NetManager:IsErrorData(data) then
            return
        end
        if data.lvs then
            for _,v in pairs(data.lvs) do
                local lv = self:GetSuitLvByFashionLv(v.key, v.value)

                local lvUp = false
                local oldLv = self.data.fashionSuitMap[v.key]
                local isNew = oldLv == nil
                if oldLv then
                    lvUp = lv > oldLv
                end
                self.data.fashionSuitMap[v.key] = lv
                self:FashionSuitClacAttrs(v.key, lv, lvUp, isNew)
            end
        end

        local changed, addFashionMap, upFashionList, downFashionList = self:RefreshFashionData(data.fashion_data)
        if changed then
            ManagerContainer.DataMgr.UserData:CalcFashionAttrs()
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.FASHION_LIST_CHANGE)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_FASHION_ADD, addFashionMap)
        else
            -- upFashionList 表示新穿的时装
            -- 需要跟原来身上的时装进行比较
            local viewChanged = false
            local viewData = ManagerContainer.DataMgr.UserData:GetViewData()
            local totalUpFashionList = {}
            if viewData and viewData.fashionData then
                for _,v in pairs(viewData.fashionData) do
                    totalUpFashionList[#totalUpFashionList + 1] = v
                end
            end
            if upFashionList then
                for _,v in pairs(upFashionList) do
                    local result, idx = CommonUtil.EleInTable(v, totalUpFashionList)
                    if not result then
                        totalUpFashionList[#totalUpFashionList + 1] = v
                        viewChanged = true
                    end
                end
            end
            if downFashionList then
                for _,v in pairs(downFashionList) do
                    local result, idx = CommonUtil.EleInTable(v, totalUpFashionList)
                    if result then
                        table.remove(totalUpFashionList, idx)
                        viewChanged = true
                    end
                end
            end
            if viewChanged then
                ManagerContainer.DataMgr.UserData:UpdateFashionUpData(totalUpFashionList)
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.FASHION_WEAR_CHANGE)
            end
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FASHION_UP_LVL_ACK,self.OnFashionLvUpAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FASHION_RESET_ATTR_ACK,self.OnFashionWashAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FASHION_PAPER_DECOMPOSE_ACK,self.OnFashionPagerDecomposeAck, self)
end

function FashionData:Clear()
    self.data = {}
    self.data.fashionMap = {}
    self.data.fashionSuitMap = {}
end

function FashionData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function FashionData:UnRegisterNetEvents()

end

function FashionData:InitFashionData(roleFashion)
    if not roleFashion or not roleFashion.fashion_data then return end
    self.washState = false

    local userSex = ManagerContainer.DataMgr.UserData:GetSex()
    local cacheFashionData = self:ReadCacheFashionData()
    local fashionData = roleFashion.fashion_data
    local cfgMgr = ManagerContainer.CfgMgr
    for _,v in pairs(fashionData) do
        local cfgId = v.fashion_id
        local fashionCfgData = cfgMgr:GetFashionById(cfgId)
        if not fashionCfgData then
            LogError("[Wboy] .. ".. cfgId .. " 时装ID不存在")
        elseif not fashionCfgData.FashionOpen then
            LogError("[Wboy] 无力吐槽 不能获得的时装，策划竟然让玩家获得了 ".. cfgId)
        elseif fashionCfgData.FashionSex > 0 and fashionCfgData.FashionSex ~= userSex then
            LogError("[Wboy] 无力吐槽 不能获得异性的时装，策划竟然让玩家获得了 ".. cfgId)
        else
            local isNew
            if cacheFashionData then
                isNew = cacheFashionData[cfgId]
                if isNew == nil then
                    isNew = false
                end
            else
                isNew = false
            end

            local data = self.data.fashionMap[cfgId]
            if not data then
                data = {cfgId = cfgId}
                self.data.fashionMap[cfgId] = data
            end
            data.isNew = isNew
            data.lv = v.fashion_lvl
            data.wear = v.fashion_wear
            data.oldAttrs = {}
            data.attrs = {}
            for _,v1 in pairs(v.attrs) do
                data.attrs[#data.attrs + 1] = v1
            end
            data.resetAttrs = {}
            for _,v1 in pairs(v.resetAttrs) do
                data.resetAttrs[#data.resetAttrs + 1] = v1
            end

            self:FashionLvUpCanState(data)
        end
    end

    if roleFashion.lvs then
        for _,v in pairs(roleFashion.lvs) do
            local lv = self:GetSuitLvByFashionLv(v.key, v.value)
            self.data.fashionSuitMap[v.key] = lv
        end
    end

    self:ClacFashionAttrs()
    self:FashionDataNotify()
end

function FashionData:FashionDataNotify()
    local result = false
    for _,v in pairs(self.data.fashionMap) do
        if v.canLvUp then
            result = true
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.FashionLvUp, result)
end

function FashionData:RefreshAllFashionLvUpNotify()
    local result = false
    for _,v in pairs(self.data.fashionMap) do
        self:FashionLvUpCanState(v)
        if v.canLvUp then
            result = true
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.FashionLvUp, result)
end

function FashionData:ClacFashionAttrs()
    self.data.fashionAttrs = {}
    for k,v in pairs(self.data.fashionMap) do
        for _,v1 in pairs(v.attrs) do
            local jobType = v1.jobType + 1
            local attrId = v1.attrId
            local value = v1.value
            if not self.data.fashionAttrs[jobType] then
                self.data.fashionAttrs[jobType] = {}
            end
            if not self.data.fashionAttrs[jobType][attrId] then
                self.data.fashionAttrs[jobType][attrId] = 0
            end
            value = attrId > 21 and CommonUtil.GetPreciseDecimal(value, 4) or math.floor(value)
            self.data.fashionAttrs[jobType][attrId] = self.data.fashionAttrs[jobType][attrId] + value
        end
    end

    self.data.suitAttrs = {}
    for k,v in pairs(self.data.fashionSuitMap) do
        local suitCfgData = ManagerContainer.CfgMgr:GetFashionSuitDataById(k)
        if suitCfgData and v > 0 then
            local curAttrs = suitCfgData.Attribute[v]
            if curAttrs then
                for _,v in pairs(curAttrs) do
                    local str = string.split(v, '-')
                    local key = tonumber(str[1])
                    local val = tonumber(str[2])
                    if not self.data.suitAttrs[key] then
                        self.data.suitAttrs[key] = 0
                    end
                    val = key > 21 and CommonUtil.GetPreciseDecimal(val, 4) or math.floor(val)
                    self.data.suitAttrs[key] = self.data.suitAttrs[key] + val
                end
            end
        end
    end
end

function FashionData:FashionLvUpCanState(data)
    data.canLvUp = false
    local lvUpState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(68)
    if not lvUpState then
        return
    end
    local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(data.cfgId)

    local lvCfgData = ManagerContainer.CfgMgr:GetFashionLvDataByLv(data.lv + 1)
    if not lvCfgData then
        data.canLvUp = false
        return
    end

    local quality = fashionCfgData.FashionQuality
    local costs = lvCfgData['UpMaterial'..quality]

    for i = 1, 3 do
        local cost = costs and costs[i] or nil
        if cost then
            local ownedCount = CommonUtil.GetOwnResCountByItemId(cost[1])
            if ownedCount < cost[2] then
                data.canLvUp = false
                return
            end
        end
    end

    data.canLvUp = true
end

function FashionData:FashionLvUpOrNewClacAttrs(data, isNew)
    if not self.data.fashionAttrs then return end
    if not isNew and not next(data.oldAttrs) then return end

    for _,v1 in pairs(data.oldAttrs) do
        local jobType = v1.jobType + 1
        local attrId = v1.attrId
        local value = v1.value
        if self.data.fashionAttrs[jobType] and self.data.fashionAttrs[jobType][attrId] then
            value = attrId > 21 and CommonUtil.GetPreciseDecimal(value, 4) or math.floor(value)
            self.data.fashionAttrs[jobType][attrId] = self.data.fashionAttrs[jobType][attrId] - value
        end
    end

    for _,v1 in pairs(data.attrs) do
        local jobType = v1.jobType + 1
        local attrId = v1.attrId
        local value = v1.value
        if not self.data.fashionAttrs[jobType] then
            self.data.fashionAttrs[jobType] = {}
        end
        if not self.data.fashionAttrs[jobType][attrId] then
            self.data.fashionAttrs[jobType][attrId] = 0
        end
        value = attrId > 21 and CommonUtil.GetPreciseDecimal(value, 4) or math.floor(value)
        self.data.fashionAttrs[jobType][attrId] = self.data.fashionAttrs[jobType][attrId] + value
    end

    if isNew or (next(data.oldAttrs) and not next(data.resetAttrs)) then
        ManagerContainer.DataMgr.UserData:CalcFashionAttrs()
        ManagerContainer.DataMgr.PartnerData:CalcAllPartnerFashionAttrs()
        data.oldAttrs = {}
    end
end

function FashionData:FashionSuitClacAttrs(suitId, lv, isLvUp, isNew)
    if not isNew and not isLvUp then return end
    if not self.data.suitAttrs then return end

    local suitCfgData = ManagerContainer.CfgMgr:GetFashionSuitDataById(suitId)
    if not suitCfgData then return end

    if lv > 1 then
        local lastLv = lv - 1
        local lastAttrs = suitCfgData.Attribute[lastLv]
        if lastAttrs then
            for _,v in pairs(lastAttrs) do
                local str = string.split(v, '-')
                local key = tonumber(str[1])
                local val = tonumber(str[2])
                if self.data.suitAttrs[key] then
                    val = key > 21 and CommonUtil.GetPreciseDecimal(val, 4) or math.floor(val)
                    self.data.suitAttrs[key] = self.data.suitAttrs[key] - val
                end
            end
        end
    end

    local curAttrs = suitCfgData.Attribute[lv]
    if curAttrs then
        for _,v in pairs(curAttrs) do
            local str = string.split(v, '-')
            local key = tonumber(str[1])
            local val = tonumber(str[2])
            if not self.data.suitAttrs[key] then
                self.data.suitAttrs[key] = 0
            end
            val = key > 21 and CommonUtil.GetPreciseDecimal(val, 4) or math.floor(val)
            self.data.suitAttrs[key] = self.data.suitAttrs[key] + val
        end
    end

    ManagerContainer.DataMgr.UserData:CalcFashionAttrs()
    --套装升级提示
    ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam("SuitLevelUp", I18N.T(suitCfgData.SuitName), lv)
end

function FashionData:GetSuitLvByFashionLv(suitId, fashionLv)
    local suitCfgData = ManagerContainer.CfgMgr:GetFashionSuitDataById(suitId)
    if not suitCfgData then
        return 0
    end

    local result, idx = CommonUtil.EleInTable(fashionLv, suitCfgData.LevelCondition)
    return idx or 0
end

function FashionData:GetFashionAllAttrs()
    return self.data.fashionAttrs
end

function FashionData:GetFashionAllAttrsByJobType(jobType)
    return self.data.fashionAttrs and self.data.fashionAttrs[jobType + 1] or nil
end

function FashionData:GetFashionSuitLvById(suitId)
    return self.data.fashionSuitMap[suitId] or 0
end

function FashionData:GetFashionSuitAttrs()
    return self.data.suitAttrs
end

--- 获得已合成的时装列表
---@return table
function FashionData:GetFashionMap()
    return self.data.fashionMap
end

--- 查询是否已获得该时装
function FashionData:Contains(cfgId)
    return self.data.fashionMap[cfgId] ~= nil
end

function FashionData:GetFashionById(cfgId)
    return self.data.fashionMap[cfgId]
end

function FashionData:IsNew(cfgId)
    local fashionData = self.data.fashionMap[cfgId]
    if fashionData then
        if fashionData.isNew then
            return true
        end
    end
    return false
end

function FashionData:CanLvUp(cfgId)
    local fashionData = self.data.fashionMap[cfgId]
    if fashionData then
        if fashionData.canLvUp then
            return true
        end
    end
    return false
end

function FashionData:CancelNewState(cfgId)
    local fashionData = self.data.fashionMap[cfgId]
    if fashionData then
        if not fashionData.isNew then
            return false
        end
        fashionData.isNew = false
        self:WriteCacheFashionData()
        ManagerContainer.RedPointMgr.HeroRPCtr:FashionDataNotify()
        return true
    end
    return false
end

function FashionData:ReadCacheFashionData()
    local cacheFashionDataStr = ManagerContainer.PlayerPrefsMgr:GetString(CACHE_FASHION_KEY_NAME, '')
    local cacheFashionDatas = JSON:decode(cacheFashionDataStr)
    local cacheFashionDataMap = {}
    if cacheFashionDatas then
        for key, value in pairs(cacheFashionDatas) do
            cacheFashionDataMap[value] = true
        end
    end
    return cacheFashionDataMap
end

function FashionData:WriteCacheFashionData()
    local cacheFashionDatas = {}
    if self.data.fashionMap then
        for cfgId, fashionData in pairs(self.data.fashionMap) do
            if fashionData.isNew then
                table.insert(cacheFashionDatas, cfgId)
            end
        end
    end
    local valueStr = JSON:encode(cacheFashionDatas)
    ManagerContainer.PlayerPrefsMgr:SetString(CACHE_FASHION_KEY_NAME, valueStr)
end

function FashionData:RefreshFashionData(fashionData)
    if not fashionData then return end

    local addFashionMap = {}
    local downFashionList = {}
    local upFashionList = {}
    local addNum = 0
    local cfgMgr = ManagerContainer.CfgMgr
    for _,v in pairs(fashionData) do
        local cfgId = v.fashion_id
        local fashionCfgData = cfgMgr:GetFashionById(cfgId)
        if not fashionCfgData then
            LogError("[Wboy] .. ".. cfgId .. " 时装ID不存在")
        elseif not fashionCfgData.FashionOpen then
            LogError("[Wboy] 无力吐槽 不能获得的时装，策划竟然让玩家获得了 ".. cfgId)
        else
            local oldWearState
            local data = self.data.fashionMap[cfgId]
            local isNew = false
            if not data then
                isNew = true
                data = {cfgId = cfgId, isNew = true, wear = false,lv=1}

                addNum = addNum + 1
                addFashionMap[cfgId] = 1
                self.data.fashionMap[cfgId] = data
            end
            oldWearState = data.wear

            local lvUpState = v.fashion_lvl > data.lv
            data.lv = v.fashion_lvl
            data.wear = v.fashion_wear

            data.oldAttrs = {}
            if (lvUpState or #v.resetAttrs == 0) and not isNew then
                data.oldAttrs = clone(data.attrs)
            end

            data.attrs = {}
            for _,v1 in pairs(v.attrs) do
                data.attrs[#data.attrs + 1] = v1
            end
            data.resetAttrs = {}
            for _,v1 in pairs(v.resetAttrs) do
                data.resetAttrs[#data.resetAttrs + 1] = v1
            end

            if data.wear then
                upFashionList[#upFashionList + 1] = cfgId
            else
                downFashionList[#downFashionList + 1] = cfgId
            end

            self:FashionLvUpOrNewClacAttrs(data, isNew)
            --self:FashionLvUpCanState(data)
        end
    end
    -- 新获得
    if addNum > 0 then
        self:WriteCacheFashionData()
        ManagerContainer.RedPointMgr.HeroRPCtr:FashionDataNotify()
    end
    self:FashionDataNotify()
    self:RefreshAllFashionLvUpNotify()
    return addNum > 0, addFashionMap, upFashionList, downFashionList
end

function FashionData:SendFashionLvUp(fashionId)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FASHION_UP_LVL_REQ, {fashion_cfg_id = fashionId})
end

function FashionData:SendFashionWash(fashionId, state)
    if self.washState then
        return
    end
    self.washState = true
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FASHION_RESET_ATTR_REQ, {enter = state, fashion_cfg_id = fashionId})
end

function FashionData:OnFashionLvUpAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.FASHION_LV_UP_CHANGE, true)
end

function FashionData:OnFashionWashAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end
    self.washState = false
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.FASHION_WASH_CHANGE)
end

function FashionData:OnFashionPagerDecomposeAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end
    CommonUtil.ACKShowRewardList(data.item_list)
end

return FashionData