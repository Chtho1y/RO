local FriendData = class("FriendData")

function FriendData:ctor(id)
    self.uid = id
    self.head = 0
    self.job = 0
    self.level = 1
    self.fightPower = 0
    self.sex = 0
    self.status = 0
    self.onlineStatus = false
    self.lastOnlineTime = 0
    self.isNew = false
    self.param = nil
end

-- message CommonPlayerBriefInfo {
--     uint64  uid                 = 1; //玩家唯一ID
--     string  nick_name           = 2; //玩家nickname
--     int32   img_id              = 3; //头像ID
--     int32   gender              = 4; //性別
--     int32   level               = 5; //等级
--     int32   config_id           = 6; //职业ID
--     int32 fight_power           = 7; //战斗力(历史最高战力)
--     bool    online_state        = 8; //玩家在线状态
--     uint64  online_time         = 9; //玩家最后在线时间

-- }
-- //0无状态 1关注该玩家  2该玩家关注自己  3互相关注
function FriendData:SetData(brief_info)
    if brief_info == nil or brief_info.uid ~= self.uid then
        return
    end
    self.head = CommonUtil.GetPlayerHeadIcon(brief_info)
    self.job = brief_info.config_id
    self.level = brief_info.level
    self.sex = brief_info.gender
    self.name = CommonUtil.GetVaildNickName(brief_info.nick_name)
    self.fightPower = brief_info.fight_power
    self.onlineStatus = brief_info.online_state       --在线状态
    self.lastOnlineTime = brief_info.online_time      --玩家最后在线时间
    self.headFrameId = brief_info.head_frame_id       --头像框id
end

function FriendData:SetStatus(status)
    self.status = status                               --关注状态 0无状态 1关注该玩家  2该玩家关注自己  3互相关注
end

function FriendData:GetOnlineStatus()
    if self.onlineStatus then
        return string.formatbykey("FriendsOnline")
    else
        return self:GetOfflineTimeStr()
    end
end

function FriendData:GetOfflineTime()
    if self.onlineStatus then
        return 0
    end

    return (ManagerContainer.LuaTimerMgr:CurLuaServerTime() - self.lastOnlineTime)/1000
end

function FriendData:GetOfflineTimeStr()
    local offlineTime = self:GetOfflineTime()
    if offlineTime < 3600 then
        return string.formatbykey("FriendsOffline")
    elseif offlineTime < 86400 then
        local hours = math.floor(#offlineTime/3600)  
        return string.formatbykey("FriendsOfflineHour",hours)
    elseif  offlineTime < 259200 then
        return string.formatbykey("FriendsOfflineDay",1)
    else
        return string.formatbykey("FriendsOfflineDay",3)
    end
end

function FriendData:StatusStr()
    if self.status == 0 then
        return ""
    elseif self.status == Enum.FriendStatusType.MyInterest then
        return "关注"
    elseif self.status == Enum.FriendStatusType.MyFans then
        return "被关"
    elseif self.status == Enum.FriendStatusType.All then
        return "互关"
    end

    return ""
end

function FriendData:StatusImage()
    if self.status == 0 then
        return "ic_follow_0"
    elseif self.status == Enum.FriendStatusType.MyInterest then
        return "ic_follow_1"
    elseif self.status == Enum.FriendStatusType.MyFans then
        return "ic_follow_2"
    elseif self.status == Enum.FriendStatusType.All then
        return "ic_follow_3"
    end
    return "ic_follow_0"
end

function FriendData:IsNew()
    return self.isNew
end

function FriendData:SetNewState(val)
    self.isNew = val
end

return FriendData