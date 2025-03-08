local ChatData = class("ChatData", require("DataBase"))
local ProtocalDataNormal = require("ProtocalDataNormal")

local maxPrivateNum = 10
local maxLimit = 100
local maxGuildLimit = 100

local privateChatPersistentSystem

local loggedin = true
function ChatData:ctor()
    self.data = {}
end

function ChatData:Init()
    loggedin = true
    self.data.chatDatas = {}
    self.data.offlineInfos = {}
    self.data.chatDatas.worldChats = {}
    self.data.chatDatas.guildChats = {}
    self.data.chatDatas.privateChatMap = {}
    self.data.chatDatas.privateSortChats = {}
    self.data.systemDatas = {}
    self.data.channelType = nil

    local welcomeSystemData = {}
    welcomeSystemData.type = 0
    welcomeSystemData.isSystem = true
    welcomeSystemData.nickname = "ChatNotice03"
    welcomeSystemData.sendTime = 0

    table.insert(self.data.systemDatas, 1, welcomeSystemData)
    table.insert(self.data.chatDatas.worldChats, 1, welcomeSystemData)

    if not privateChatPersistentSystem then
        privateChatPersistentSystem = require("PrivateChatPersistentSystem"):new()
    end
    self:ResetPersistentPrivateInfos()
end

local function TimeSortChat(a,b)
    return a.message.sendTime < b.message.sendTime
end

local function TimeSortSystem(a,b)
    local sendTimeA = a.sendTime or a.message.sendTime
    local sendTimeB = b.sendTime or b.message.sendTime
    return sendTimeA < sendTimeB
end

local function IsInList(data, list)
    for k,v in pairs(list) do
        if v.fromData.uid == tostring(data.uid) then
            return true, k
        end
    end
    return false, nil
end

function ChatData:InitOfflineTalkTargetIds(roleChat)
    if roleChat == nil then return end
    local offlineDatas = roleChat.offline_msg_player_list
    for _,v in pairs(offlineDatas) do
        local result, idx = IsInList(v, self.data.chatDatas.privateSortChats)
        local offlineData = ProtocalDataNormal.ParseChatPlayerBriefInfo(v)
        if not result then
            self.data.offlineInfos[#self.data.offlineInfos + 1] = offlineData

            local data = {}
            data.fromData = offlineData
            data.chats = {}
            data.isNew = true

            table.insert(self.data.chatDatas.privateSortChats, 1, data)
            if self.data.chatDatas.privateChatMap[offlineData.uid] == nil then
                self.data.chatDatas.privateChatMap[offlineData.uid] = {}
            end
            self.data.chatDatas.privateChatMap[offlineData.uid] = data
        else
            local data = self.data.chatDatas.privateSortChats[idx]
            data.fromData = offlineData
            data.isNew = true
            self.data.offlineInfos[#self.data.offlineInfos + 1] = offlineData
        end
    end

    self:CheckHasNewPrivateChat()
end

function ChatData:ResetPersistentPrivateInfos()
    local infos = privateChatPersistentSystem:GetSortPrivateInfos()
    if infos == nil then return end

    for i = 1, #self.data.offlineInfos do
        local offlineData = self.data.offlineInfos[i]
        for k,v in pairs(infos) do
            if offlineData.uid == v.uid then
                local data = privateChatPersistentSystem:GetPrivatePersistentChatById(v.uid)
                if data == nil then
                    data = {}
                    data.fromData = v
                    data.chats = {}
                end
                self.data.chatDatas.privateSortChats[i] = data
                if self.data.chatDatas.privateChatMap[v.uid] == nil then
                    self.data.chatDatas.privateChatMap[v.uid] = {}
                end
                self.data.chatDatas.privateChatMap[v.uid] = data
                table.remove(infos, k)
                break
            end
        end
    end
    if #self.data.chatDatas.privateSortChats < maxPrivateNum then
        local count = #self.data.chatDatas.privateSortChats
        local num = maxPrivateNum - #self.data.chatDatas.privateSortChats
        for i = 1, num do
            if infos[i] == nil then
                break
            end
            local data = privateChatPersistentSystem:GetPrivatePersistentChatById(infos[i].uid)
            if data == nil then
                data = {}
                data.fromData = infos[i]
                data.chats = {}
            end
            self.data.chatDatas.privateSortChats[count + i] = data
            if self.data.chatDatas.privateChatMap[infos[i].uid] == nil then
                self.data.chatDatas.privateChatMap[infos[i].uid] = {}
            end
            self.data.chatDatas.privateChatMap[infos[i].uid] = data
        end
    end

    for _,v in pairs(self.data.chatDatas.privateSortChats) do
        for _,v1 in pairs(v.chats) do
            if v1.message.subType == Enum.ChatSubType.Expedition then
                local curTime = ManagerContainer.LuaTimerMgr:GetTimeSecond()
                local isOneDay = ManagerContainer.LuaTimerMgr:TwoTimeSecondBetweenOneDay(v1.message.sendTime, curTime)
                if not isOneDay then
                    v1.message.used = true
                end
            end
        end
    end

    privateChatPersistentSystem:SetMapDatasAndSortDatas(self.data.chatDatas.privateChatMap, self.data.chatDatas.privateSortChats)
end

function ChatData:SortPrivateChatWithTime(key, newData, IsSort)
    local oldKey, oldData
    for k, v in pairs(self.data.chatDatas.privateSortChats) do
        if v.fromData.uid == key then
            oldData = v
            oldKey = k
            break
        end
    end
    if oldData ~= nil then
        table.remove(self.data.chatDatas.privateSortChats, oldKey)
        if  not IsSort then
            table.insert(self.data.chatDatas.privateSortChats, 1, newData)
        else
            table.insert(self.data.chatDatas.privateSortChats,newData)
        end
    else
        table.insert(self.data.chatDatas.privateSortChats,newData)
    end
end

function ChatData:AddNewChatData(data)
    local chatDatas = self.data.chatDatas
    if data.type == Enum.ChatDataType.World then
        --世界聊天
        local chatData = ProtocalDataNormal.ParseChatData(data)
        self:AddOneWorldChatData(chatData)
    elseif data.type == Enum.ChatDataType.Guild then
        --公会聊天
        local chatData = ProtocalDataNormal.ParseChatData(data)
        self:AddOneWorldChatData(chatData)
        self:AddOneGuildChatData(chatData)
    elseif data.type == Enum.ChatDataType.Private then
        --私聊
        if chatDatas.privateChatMap == nil then
            chatDatas.privateChatMap = {}
        end
        local chat = ProtocalDataNormal.ParseChatData(data)
        if chatDatas.privateChatMap[chat.fromData.uid] == nil then
            chatDatas.privateChatMap[chat.fromData.uid] = {}
        end
        local privateDatas = chatDatas.privateChatMap[chat.fromData.uid]
        privateDatas.isNew = true
        privateDatas.fromData = chat.fromData
        if privateDatas.chats == nil then
            privateDatas.chats = {}
        end

        table.insert(privateDatas.chats, chat)

        if #privateDatas.chats > 1 then
            table.sort(privateDatas.chats, TimeSortChat)
        end
            self:SortPrivateChatWithTime(chat.fromData.uid, chatDatas.privateChatMap[chat.fromData.uid],true)

        self:CheckChatCountLimit(privateDatas.chats)
        self:CheckPrivateChatsLimit()

        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_PRIVATE_CHAT, 1, chat.fromData.uid)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PrivateChat, true)
    end
end

function ChatData:ExpeditionHelpAck(targetUid, msgType)
    if msgType == Enum.ExpeditionHelpSource.Private then
        self:SendPrivateChat(I18N.T("ExpeditionHelp3"), targetUid)
    else
        local chatDatas = self.data.chatDatas
        if chatDatas.guildChats == nil then
            chatDatas.guildChats = {}
        end
        local nickname = ""
        for _,v in pairs(chatDatas.guildChats) do
            if v.type == Enum.ChatDataType.Guild and v.fromData.uid == tostring(targetUid) then
                nickname = v.fromData.nickname
                break
            end
        end
        local content = I18N.SetLanguageValue("ExpeditionHelp5", CommonUtil.GetVaildNickName(nickname))
        self:SendChatReq(content, Enum.ChatDataType.Guild)
    end
end

function ChatData:AddOneWorldChatData(chatData)
    if not chatData then return end
    local chatDatas = self.data.chatDatas
    if chatDatas.worldChats == nil then
        chatDatas.worldChats = {}
    end
    table.insert(chatDatas.worldChats, chatData)
    self:CheckTableCountLimit(chatDatas.worldChats, maxLimit)
    self.data.worldDirty = true
end

function ChatData:AddOneGuildChatData(chatData)
    if not chatData then return end
    local chatDatas = self.data.chatDatas
    if chatDatas.guildChats == nil then
        chatDatas.guildChats = {}
    end
    table.insert(chatDatas.guildChats, chatData)
    self:CheckTableCountLimit(chatDatas.guildChats, maxGuildLimit)
    self.data.guildDirty = true
end

function ChatData:ClearGuildChatData()
    local guildChats = self.data.chatDatas.guildChats
    if not guildChats then
        return
    end
    local worldChats = self.data.chatDatas.worldChats
    if worldChats then
        local offset = #worldChats
        for i = #guildChats, 1, -1 do
            local guildChat = guildChats[i]
            if guildChat then
                for j = offset, 1, -1 do
                    if guildChat == worldChats[j] then
                        table.remove(worldChats, j)
                        self.data.worldDirty = true
                        offset = j - 1
                        break
                    end
                end
            end
        end
    end
    self.data.chatDatas.guildChats = nil
    self.data.guildDirty = true
    self:SendEvents()
end

function ChatData:SendEvents()
    if self.data.worldDirty then
        self.data.worldDirty = false
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_WOLRD_CHAT, Enum.ChatChannel.World)
    end
    if self.data.guildDirty then
        self.data.guildDirty = false
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_WOLRD_CHAT, Enum.ChatChannel.Guild)
    end
    if self.data.systemDirty then
        self.data.systemDirty = false
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_WOLRD_CHAT, Enum.ChatChannel.System)
    end
end

function ChatData:CheckHasNewPrivateChat()
    local result = false
    for _,v in pairs(self.data.chatDatas.privateChatMap) do
        if v.isNew then
            result = true
            break
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PrivateChat, result)
end

function ChatData:NeedQueryOfflinePrivateInfo(fromData)
    for k,v in pairs(self.data.offlineInfos) do
        if v.uid == fromData.uid then
            self.data.offlineInfos[k] = nil
            return true
        end
    end
    return false
end

function ChatData:GetWorldChatDatas()
    return self.data.chatDatas.worldChats
end

function ChatData:GetGuildChatDatas()
    return self.data.chatDatas.guildChats
end

function ChatData:GetPrivateSortChatDatas()
    return self.data.chatDatas.privateSortChats
end

function ChatData:RemovePrivateChatData(idx)
    local data = table.remove(self.data.chatDatas.privateSortChats, idx)
    if data then
        self.data.chatDatas.privateChatMap[data.fromData.uid] = nil
        privateChatPersistentSystem:RemovePrivateBriefInfo(data.fromData)
    end
end

function ChatData:GetPrivateChatDataMap()
    return self.data.chatDatas.privateChatMap
end

function ChatData:GetTargetIdxInSortedDatas(fromData)
    for k,v in pairs(self.data.chatDatas.privateSortChats) do
        if v.fromData.uid == fromData.uid then
            v.fromData.imgId = fromData.imgId
            v.fromData.nickname = fromData.nickname
            v.fromData.headFrameId = fromData.headFrameId
            v.fromData.jobId = fromData.jobId
            v.fromData.level = fromData.level
            v.fromData.sex = fromData.sex
            return k
        end
    end
    local data = privateChatPersistentSystem:GetPrivatePersistentChatById(fromData.uid)
    if data == nil then
        data = {}
        data.isNew = false
        data.fromData = fromData
        data.chats = {}
    end
    table.insert(self.data.chatDatas.privateSortChats, 1, data)
    self.data.chatDatas.privateChatMap[fromData.uid] = data

    self:CheckChatCountLimit(data.chats)
    self:CheckPrivateChatsLimit()
    return 1
end

function ChatData:CheckPrivateChatsLimit()
    if #self.data.chatDatas.privateSortChats > maxPrivateNum then
        for i = #self.data.chatDatas.privateSortChats, 11 do
            self:RemovePrivateChatData(i)
        end
    end
end

function ChatData:CheckChatCountLimit(chats)
    if #chats > maxLimit then
        local num = #chats - maxLimit
        for i = 1, num do
            table.remove(chats, 1)
        end
    end
end

function ChatData:CheckTableCountLimit(ls, limit)
    if #ls > limit then
        local num = #ls - limit
        for i = 1, num do
            table.remove(ls, 1)
        end
    end
end

function ChatData:AddOfflinePrivateChat(data)
    local targetData = ProtocalDataNormal.ParseChatPlayerBriefInfo(data.target_player)
    local datas = self.data.chatDatas.privateChatMap[targetData.uid]
    if datas == nil then
        datas = {}
    end
    datas.fromData = targetData
    if datas.chats == nil then
        datas.chats = {}
    end
    for _, v in pairs(data.msg_list) do
        local data1 = {}
        data1.fromData = targetData
        data1.message = ProtocalDataNormal.ParseChatMessageInfo(v)
        data1.type = 1
        datas.chats[#datas.chats + 1] = data1
    end

    if #datas.chats > 1 then
        table.sort(datas.chats, TimeSortChat)
    end

    local key = 1
    for k, v in pairs(self.data.chatDatas.privateSortChats) do
        if v.fromData.uid == targetData.uid then
            self.data.chatDatas.privateSortChats[k] = datas
            key = k
            break
        end
    end

    self:CheckChatCountLimit(datas.chats)
    self:CheckPrivateChatsLimit()

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_PRIVATE_CHAT, key)
end

function ChatData:AddPrivateChatBack(data)
    local targetUid = tostring(data.target_id)

    local chat = {}
    chat.fromData = {}
    chat.fromData.uid = tostring(ManagerContainer.DataMgr.UserData:GetUserId())
    chat.fromData.nickname = ManagerContainer.DataMgr.UserData:GetUserNickname()
    chat.fromData.imgId = ManagerContainer.DataMgr.UserData:GetUserHeadIcon()
    chat.fromData.sex = ManagerContainer.DataMgr.UserData:GetSex()
    chat.type = 1
    chat.message = ProtocalDataNormal.ParseChatMessageInfo(data.message)

    local datas = self.data.chatDatas.privateChatMap[targetUid]
    if datas == nil then
        datas = {}
        self.data.chatDatas.privateChatMap[targetUid] = datas
    end
    if datas.chats == nil then
        datas.chats = {}
    end
    table.insert(datas.chats, chat)
    if not datas.fromData then
        datas.fromData = {}
        datas.fromData.uid = targetUid
    end

    if #datas.chats > 1 then
        table.sort(datas.chats, TimeSortChat)
    end

    self:SortPrivateChatWithTime(datas.fromData.uid, self.data.chatDatas.privateChatMap[datas.fromData.uid])

    local key = 1
    if #self.data.chatDatas.privateSortChats == 0 then
        self.data.chatDatas.privateSortChats[1] = datas
    else
        for k, v in pairs(self.data.chatDatas.privateSortChats) do
            if v.fromData.uid == targetUid then
                self.data.chatDatas.privateSortChats[k] = datas
                key = k
                break
            end
        end
    end

    self:CheckChatCountLimit(datas.chats)
    self:CheckPrivateChatsLimit()

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_PRIVATE_CHAT, key)
end

function ChatData:AddNewSystemData(datas, needSort)
    if datas == nil then return end

    if self.data.systemDatas == nil then
        self.data.systemDatas = {}
    end
    for _, v in pairs(datas) do
        local systemData = ProtocalDataNormal.ParseSystemMessageData(v)

        local needSkip = false
        local type = systemData.type
        if type == Enum.ChatSystemType.Item and systemData.paramIds then
            local sourceType = systemData.paramIds[3]
            local sourceItemId = systemData.paramIds[4]
            if not sourceType or (sourceType == Enum.DropSource.Gift and sourceItemId ~= 514) then
                needSkip = true
            end
        elseif type == Enum.ChatSystemType.Competition and systemData.paramIds then
            local score = systemData.paramIds[1] or 0
            if score >= 101 and score < 401 then
                needSkip = true
            end
        end
        if not needSkip then
            systemData.isSystem = true
            if systemData.type == Enum.ChatSystemType.Guild then
                self:AddOneGuildChatData(systemData)
            else
                self.data.systemDatas[#self.data.systemDatas + 1] = systemData
                self.data.systemDirty = true
                self:AddOneWorldChatData(systemData)
            end
        end
    end

    if needSort then
        if #self.data.systemDatas > 1 then
            table.sort(self.data.systemDatas, TimeSortSystem)
        end
    end
end

function ChatData:AddLocalNewSystemData(content)
    if self.data.systemDatas == nil then
        self.data.systemDatas = {}
    end
    local systemData = {}
    systemData.type = 0
    systemData.isSystem = true
    systemData.nickname = content
    local time = ManagerContainer.LuaTimerMgr:GetTimeSecond()
    systemData.sendTime = time

    self.data.systemDatas[#self.data.systemDatas + 1] = systemData
    self.data.systemDirty = true
    self:AddOneWorldChatData(systemData)

    self:SendEvents()
end

function ChatData:GetSystemDatas()
    return self.data.systemDatas
end

function ChatData:RefreshChatTargetBriefInfo(briefInfos)
    for k, v in pairs(self.data.chatDatas.privateSortChats) do
        for _,v1 in pairs(briefInfos) do
            if v.fromData.uid == tostring(v1.uid) then
                v.fromData.nickname = v1.nick_name
                v.fromData.imgId = CommonUtil.GetPlayerHeadIcon(v1)
                v.fromData.headFrameId = v1.head_frame_id
                v.fromData.jobId = v1.config_id
                v.fromData.level = v1.level
                v.fromData.onlineState = v1.online_state
                v.fromData.sex = v1.gender
            end
        end
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_PRIVATE_BRIEFINFO)
end

function ChatData:SendChatReq(content, chatDataType)
    content = StringUtil.TrimEdgeSpace(content)
    local data = {type = chatDataType, message = {message = content}}
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CHAT_MESSAGE_REQ, data)
end

function ChatData:SendPrivateChat(content, targetId)
    content = StringUtil.TrimEdgeSpace(content)
    local data = {type = 1, message = {message = content}, target_id = int64.new(targetId)}
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CHAT_MESSAGE_REQ, data)
end

function ChatData:RegisterNetEvents()

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CHAT_OFFLINE_PLAYER_NTF, function(data)
        self:InitOfflineTalkTargetIds(data.offline_player_list)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CHAT_MESSAGE_NTF, function(data)
        for _,v in pairs(data.msg_list) do
            self:AddNewChatData(v)
        end

        self:AddNewSystemData(data.s_msg_list)

        if loggedin then
            loggedin = false
            self:SortWorldChats()
            if self.data.systemDatas and #self.data.systemDatas > 1 then
                table.sort(self.data.systemDatas, TimeSortSystem)
            end
            --for k,v in pairs(self.data.chatDatas.worldChats) do
            --    local sendTimeA = v.sendTime or v.message.sendTime
            --    v.time = os.date('%yyyy-%m-%d %H:%M:%S', tostring(sendTimeA))
            --end
            --LogHRWarning(Inspect(self.data.chatDatas.worldChats))
        end
        self:SendEvents()
    end)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SYSTEM_MESSAGE_NTF, function(data)
        self:AddNewSystemData(data.sys_msg, true)
        self:SendEvents()
    end)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CHAT_MESSAGE_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK or data.error == Enum.NetErrorCode.ERROR_CHAT_WORLD_TARGET_OFFLINE then
            if data.type == 1 then
                --自己 的私聊返回
                self:AddPrivateChatBack(data)
            end
        end
    end)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CHAT_OFFLINE_MSG_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:AddOfflinePrivateChat(data)
        end
    end)
end

function ChatData:SortWorldChats()
    if self.data.chatDatas.worldChats and #self.data.chatDatas.worldChats > 1 then
        table.sort(self.data.chatDatas.worldChats, TimeSortSystem)
    end
end

function ChatData:SavePrivateDatas()
    if privateChatPersistentSystem then
        privateChatPersistentSystem:SavePrivateChats()
    end
end

function ChatData:Save()
    if privateChatPersistentSystem ~= nil then
        privateChatPersistentSystem:Dispose()
        privateChatPersistentSystem = nil
    end
end

function ChatData:Clear()
    self:Save()
    self.data = {}
end

function ChatData:Destroy()
    self.data = {}

    self:UnRegisterNetEvents()
end

function ChatData:UnRegisterNetEvents()

end
function ChatData:SetChatChannelType(type)
	self.data.channelType  = type
end

function ChatData:GetChatChannelType()
	return self.data.channelType or Enum.ChatChannel.World
end

return ChatData