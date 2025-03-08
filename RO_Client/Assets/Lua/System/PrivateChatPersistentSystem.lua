local PrivateChatPersistentSystem = class("PrivateChatPersistentSystem")

local timeId
function PrivateChatPersistentSystem:ctor()
    self.privateChats = {}
    self.privateBriefInfos = {}

    timeId = ManagerContainer.LuaTimerMgr:AddTimer(10* 60 * 1000, -1, self, self.SavePrivateChats, nil)
end

function PrivateChatPersistentSystem:SavePrivateChats()
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    local chats = ManagerContainer.DataMgr.ChatData:GetPrivateSortChatDatas()
    if chats == nil then
        return
    end
    self.privateChats = chats
    for k,v in pairs(chats) do
        if k <= 10 then
            self.privateBriefInfos[k] = v.fromData
        end
        local jsonStr = JSON:encode(v)
        UnityEngine.PlayerPrefs.SetString(tostring(uid).."PrivateChatData_"..tostring(v.fromData.uid), jsonStr)
    end

    local jsonStr = JSON:encode(self.privateBriefInfos)
    UnityEngine.PlayerPrefs.SetString(tostring(uid).."PrivateChatSortBriefInfos", jsonStr)
end

function PrivateChatPersistentSystem:GetSortPrivateInfos()
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    if #self.privateBriefInfos > 0 then return self.privateBriefInfos end

    local jsonStr = UnityEngine.PlayerPrefs.GetString(tostring(uid).."PrivateChatSortBriefInfos")
    local infos = JSON:decode(jsonStr)
    if infos == nil then
        infos = {}
    end

    self.privateBriefInfos = infos
    return infos
end

function PrivateChatPersistentSystem:RemovePrivateBriefInfo(data)
    for k,v in pairs(self.privateBriefInfos) do
        if v.uid == data.uid then
            self.privateBriefInfos[k] = nil
        end
    end
end

function PrivateChatPersistentSystem:SetMapDatasAndSortDatas(maps, sortDatas)
    self.privateChats = maps
    for i = 1,#sortDatas do
        if i <= 10 and sortDatas[i] then
            self.privateBriefInfos[i] = sortDatas[i].fromData
        end
    end
end

function PrivateChatPersistentSystem:GetPrivatePersistentChatById(uid)
    local uid1 = ManagerContainer.DataMgr.UserData:GetUserId()
    if self.privateChats[uid] ~= nil then
        return self.privateChats[uid]
    end
    local jsonStr = UnityEngine.PlayerPrefs.GetString(tostring(uid1).."PrivateChatData_"..tostring(uid))
    local data = JSON:decode(jsonStr)
    return data
end

function PrivateChatPersistentSystem:Dispose()

    if timeId then
        ManagerContainer.LuaTimerMgr:RemoveTimer(timeId)
        timeId = nil
    end
    self:SavePrivateChats()

    self.privateChats = nil
    self.privateBriefInfos = nil
end

return PrivateChatPersistentSystem