local GuildLobbyData = class('GuildLobbyData', require('DataBase'))
local LRUMap = require("LRUMap")

local MaxDataLimit = 2000
local TimeoutLimit = 30

local Contain = function(ls, item)
    for _, value in pairs(ls) do
        if value == item then
            return true
        end
    end
    return false
end

local Remove = function(ls, item)
    for i = 1, #ls do
        if ls[i] == item then
            table.remove(ls, i)
            -- 列表中数据不重复，不需要完全遍历, 如果需要完全遍历，请倒序遍历
            return
        end
    end
end

function GuildLobbyData:ctor()
    --- 获得玩家信息超时了，可能服务器抛弃了请求，需要继续请求
    self.timeOutGetPlayerData = nil
    --- 需要从服务器获得的玩家基本数据队列，table(uid)
    self.preGetPlayerDataQueue = {}
    self.playerDataMap = LRUMap.new(MaxDataLimit)
end

function GuildLobbyData:Clear()
    self.playerDataMap:Clear()
    for i = #self.preGetPlayerDataQueue, 1, -1 do
        table.remove(self.preGetPlayerDataQueue, i)
    end
end

function GuildLobbyData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function GuildLobbyData:RegisterNetEvents()
    --ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_MAP_OTHER_PLAYERS_INFO_NTF, self.OnOtherPlayerInfoNtf, self)
end

function GuildLobbyData:UnRegisterNetEvents()
    --ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_MAP_OTHER_PLAYERS_INFO_NTF)
end

function GuildLobbyData:OnOtherPlayerInfoNtf(msgData)
    LogError("[Wboy] SC_MAP_GET_OTHER_PLAYERS_INFO_NTF " .. Inspect(msgData))
    if not ManagerContainer.NetManager:IsErrorData(msgData) then
        local playerDatas = msgData.info_list
        for _, value in pairs(playerDatas) do
            local uid = value.uid
            -- 已获得了玩家数据，从队列中删除
            Remove(self.preGetPlayerDataQueue, uid)
            local data = self.playerDataMap:Get(uid)
            local playerData = {}
            playerData.uid              = uid
            if data then
                playerData.sex          = (value.sex and value.sex ~= 0) and value.sex or data.sex
                playerData.jobId        = (value.job_id and value.job_id ~= 0) and value.job_id or data.jobId
                playerData.nickName     = (value.nick_name and value.nick_name ~= '') and value.nick_name or data.nickName
                playerData.viewData     = data.viewData
                if value.fashion_data then
                    local viewData = ProtocalDataNormal.FashionDataToViewData(value.fashion_data)
                    ProtocalDataNormal.UpdateViewData(playerData.viewData, viewData)
                end
                playerData.actionId     = (value.action_id and value.action_id ~= 0) and value.action_id or data.actionId
            else
                playerData.sex      = value.sex
                playerData.jobId    = value.job_id
                playerData.nickName = value.nick_name
                if value.fashion_data then
                    playerData.viewData = ProtocalDataNormal.FashionDataToViewData(value.fashion_data)
                end
                playerData.actionId = value.action_id
            end
            playerData.roleCfgId    = CommonUtil.JobIdToRoleId(playerData.jobId, playerData.sex)
            self:AddPlayerData(playerData)

            -- 通知显示层更新显示
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_LOBBY_PLAYER_INFO_CHANGED, uid)
        end
    end
    -- 还有需要获得的用户信息，继续获得
    self:SendGetOtherPlayersInfo()
end


--- 发送消息给服务器，获得其它玩家的信息
function GuildLobbyData:SendGetOtherPlayersInfo()
    local length = #self.preGetPlayerDataQueue
    if length <= 0 then
        return
    end
    -- 服务器规定，一次最多获取10个玩家信息
    if length > 10 then length = 10 end
    local sendUids = {}
    for i = 1, length do
        sendUids[i] = self.preGetPlayerDataQueue[i]
    end
    LogError("[Wboy] CS_MAP_GET_OTHER_PLAYERS_INFO_REQ " .. Inspect(sendUids))
    self.timeOutGetPlayerData = ManagerContainer.LuaTimerMgr:CurServerTime()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_MAP_GET_OTHER_PLAYERS_INFO_REQ, { player_list = sendUids })
end


--- 获得玩家信息
---@param uid ulong
function GuildLobbyData:GetPlayerData(uid)
    local data = self.playerDataMap:Get(uid)
    if not data then
        if not Contain(self.preGetPlayerDataQueue, uid) then
            local isSending = (#self.preGetPlayerDataQueue > 0)
            if isSending then
                local time = ManagerContainer.LuaTimerMgr:CurServerTime()
                if self.timeOutGetPlayerData and (time - self.timeOutGetPlayerData) > TimeoutLimit then
                    isSending = false
                end
            end
            table.insert(self.preGetPlayerDataQueue, uid)
            if not isSending then
                self:SendGetOtherPlayersInfo()
            end
        end
    end
    return data
end

--- 添加玩家信息
---@param playerData table
function GuildLobbyData:AddPlayerData(playerData)
    self.playerDataMap:Add(playerData.uid, playerData)
end

function GuildLobbyData:ClearPlayerData()
    self.timeOutGetPlayerData = nil
    self.playerDataMap:Clear()
    self.preGetPlayerDataQueue = {}
end

return GuildLobbyData