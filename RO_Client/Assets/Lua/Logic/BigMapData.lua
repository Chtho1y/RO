local BigMapData = class('BigMapData', require('DataBase'))

--- 正在同步数据，需要等待数据返回
--- 如果数据一直没返回，则认为服务器丢失了这个请求，则在这个时候后，还可以请求
local SendCD = 5

local rankProcessParam, rankProcessParam1 = 0.75, 500

function BigMapData:ctor()
    self.data = {}
end

function BigMapData:Clear()
    self.data = {}
end

function BigMapData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function BigMapData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GET_MAP_RANK_ACK, function(data)
        -- LogError("[wboy] SC_GET_MAP_RANK_ACK = " .. Inspect(data))
        if ManagerContainer.NetManager:IsErrorData(data) then return end
        self:RefreshData(data)
    end)
end

function BigMapData:UnRegisterNetEvents()
end

function BigMapData:RefreshData(data)
    local val = GlobalConfig.Instance:GetConfigStrValue(178)
    if val ~= "" and val ~= nil then
        local t = CommonUtil.DeserializeGlobalStrToTable(val)
        if t and t[1] then
            rankProcessParam = t[1][1] and tonumber(t[1][1])*0.0001 or 0.75
            rankProcessParam1 = t[1][2] and tonumber(t[1][2]) or 500
        end
    end

    local selfRank = data.self_rank
    local totalRank = data.total_rank
    local topPlayerList = self.data.topPlayerList or {}
    local topPlayerChanged = false
    for i = 1, #data.top_player_list do
        local item = data.top_player_list[i]
        local mapLevel = item.map_level
        local mapId = item.map_id
        local brief = item.brief
        local uid = brief.uid
        local headId = brief.img_id
        local sex = brief.gender
        local headFrameId = brief.head_frame_id
        local jobId = brief.config_id
        local level = brief.level
        local nickName = CommonUtil.GetVaildNickName(brief.nick_name)
        if selfRank == i then
            nickName = ManagerContainer.DataMgr.UserData:GetUserNickname()
        end
        local playerInfo = topPlayerList[i]
        if playerInfo then
            if playerInfo.uid ~= uid or playerInfo.mapLevel ~= mapLevel or playerInfo.mapId ~= mapId
                or playerInfo.nickName ~= nickName or playerInfo.headId ~= headId or playerInfo.sex ~= sex then
                topPlayerChanged = true
            end
        else
            playerInfo = {}
            topPlayerList[i] = playerInfo
            topPlayerChanged = true
        end
        playerInfo.uid = uid
        playerInfo.mapLevel = mapLevel
        playerInfo.mapId = mapId
        playerInfo.nickName = nickName
        playerInfo.headId = headId
        playerInfo.sex = sex
        playerInfo.headFrameId = headFrameId
        playerInfo.jobId = jobId
        playerInfo.level = level
    end

    local selfRankChanged = (self.data.selfRank ~= selfRank or self.data.totalRank ~= totalRank)

    self.data.selfRank = selfRank
    self.data.totalRank = totalRank
    self.data.topPlayerList = topPlayerList
    self.data.waitTime = nil

    --- 自身排名变化了
    if selfRankChanged then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BIGMAP_SELF_RANK_CHANGED)
    end
    --- 前几名的玩家变化了
    if topPlayerChanged then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BIGMAP_TOPPLAYER_RANK_CHANGED)
    end
end

--- 获得当前玩家的排名信息
---@return integer 不为nil,说明100名内,名次
---@return number 不为nil,说明100名外,百分制
function BigMapData:GetSelfRankInfo()
    local totalRank = self.data.totalRank
    local selfRank = self.data.selfRank
    if not totalRank or totalRank <= 0 or not selfRank or selfRank <= 0 then
        return nil, nil
    end
    if selfRank <= 100 then
        return selfRank, nil
    else
        return nil, self:GetSelfRankPercent()
    end
end

function BigMapData:GetSelfRankPercent()
    local totalRank = self.data.totalRank
    local selfRank = self.data.selfRank

    if selfRank == nil or totalRank == nil then
        return 0
    end
    --1- 实际排名 * 0.75 / MAX（总人数，500）
    return (1 - (selfRank*rankProcessParam)/math.max(totalRank, rankProcessParam1)) * 100
end

--- 获得前几名的玩家信息
---@return table[] 玩家信息数组
function BigMapData:GetTopRankPlayerList()
    return self.data.topPlayerList
end

function BigMapData:SendGetData()
    local waitTime = self.data.waitTime
    local time = Time.GetTimestamp()
    if waitTime and (time - waitTime) < SendCD then
        return
    end
    self.data.waitTime = time
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_MAP_RANK_REQ, {})
end

return BigMapData