local FriendDataMgr = class("FriendDataMgr",require("DataBase"))
local FriendData = require("Friend/FriendData")
local FriendRecruitData = require("Friend/FriendRecruitData")

function FriendDataMgr:ctor()
    self.lastReqFriendListTime = 0
    self.lastReqFansListTime = 0
    self.lastReqBlackListTime = 0
    self.lastGetFriendRecommendTime = 0

    self.reqFriendListCDTime = 0
    self.reqFansListCDTime = 0
    self.reqBlackListCDTime = 0
    self.reqFriendRecommendCDTime = 1

    self.allInterestIds = nil        --我关注的ID列表
    self.allFansIds = nil            --我的粉丝的ID列表
    self.allBlackIds = nil           --屏蔽名单的ID列表

    self.interestList = nil        --我关注的列表
    self.fansList = nil          --我的粉丝列表
    self.blackList = nil         --屏蔽列表
    self.recommentList = {}     --推荐列表

    self.maxFriendNum = 0       --我的关注数量上限
    self.maxFansNum = 0         --我的粉丝数量上限
    self.maxBlackNum = 0        --我的黑名单数量上限
    self.ExpeditionHelpList = nil  --远征之门可求助列表（互相关注好友列表）
    self.AllExpeditionHelpIdList = nil 

    self.totalFriendNum = 0
    self.totalFansNum = 0
    self.totalBlackNum = 0

    self.searchFriendPlayers = nil
    self.hasNewFans = false
    self.newFansIds = nil
end

function FriendDataMgr:Clear()
    self.allInterestIds = nil        
    self.allFansIds = nil            
    self.allBlackIds = nil           

    self.interestList = nil        
    self.fansList = nil          
    self.blackList = nil      
    self.ExpeditionHelpList = nil   
    self.AllExpeditionHelpIdList = nil 
    self.recommentList = {}     

    self.searchFriendPlayers = nil
    self.hasNewFans = false
    self.newFansIds = nil

    if self.friendRecruitData then
        self.friendRecruitData:Clear()
        self.friendRecruitData = nil
    end
end

function FriendDataMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FRIEND_ACK,self.OnGetFriendListAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GET_OTHER_PLAYER_BRIEF_INFO_ACK, self.OnGetFriendBriefInfoAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FRIEND_RECOMMEND_ACK,self.OnGetFriendRecommendListAck,self)
    
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FRIEND_ADD_ACK,self.OnAddFriendAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FRIEND_DEL_ACK,self.OnDeleteFriendAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FRIEND_SEARCH_ACK,self.OnSearchFriendAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FRIEND_BLACK_ACK,self.OnAddOrRemoveBlackAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FRIEND_RECOMMEND_NTF,self.OnRecommendFriendNtf,self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FRIEND_ADD_NTF,self.OnAddFriendNtf,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FRIEND_DEL_NTF,self.OnDeleteFriendNtf,self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_INVITATION_STARTUP_NTF,self.InitInvitationData,self)

    if self.friendRecruitData then
        self.friendRecruitData:RegisterNetEvents()
    end
end

function FriendDataMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_FRIEND_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GET_OTHER_PLAYER_BRIEF_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_FRIEND_BLACK_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_FRIEND_RECOMMEND_ACK)

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_FRIEND_ADD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_FRIEND_DEL_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_FRIEND_SEARCH_ACK)

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_FRIEND_ADD_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_FRIEND_DEL_NTF)

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_INVITATION_STARTUP_NTF)

    if self.friendRecruitData then
        self.friendRecruitData:UnRegisterNetEvents()
    end
end

function FriendDataMgr:InitInterestData(data)
    self.totalFriendNum = data.total_count
    self.maxFriendNum = data.total_limit
    self.interestList = {}
    self.allInterestIds = {}

    if data.uid_list ~= nil then
        for i = 1,#data.uid_list do
            self.allInterestIds[#self.allInterestIds+1] = data.uid_list[i]
        end
    end
end

function FriendDataMgr:InitFansData(data)
    self.totalFansNum = data.total_count
    self.maxFansNum = data.total_limit
    self.fansList = {}
    self.allFansIds = {}
    
    
    if data.uid_list ~= nil then
        for i =1, #data.uid_list do
            self.allFansIds[#self.allFansIds+1] = data.uid_list[i]
        end
    end
end

function FriendDataMgr:InitBlackData(data)
    self.totalBlackNum = data.total_count
    self.maxBlackNum = data.total_limit
    self.blackList = {}
    self.allBlackIds = {}

    if data.uid_list ~= nil then
        for i = 1, #data.uid_list do
            self.allBlackIds[#self.allBlackIds+1] = data.uid_list[i]
        end
    end
end

function FriendDataMgr:RefreshInterestListData(briefListData)
    if briefListData == nil or #briefListData == 0 then return end

    for i = 1, #briefListData do 
        self:AddInterestPlayer(briefListData[i])
    end
    -- self:SortInterestLit()
end

function FriendDataMgr:RefreshFansListData(briefListData)
    if briefListData == nil or #briefListData == 0 then
        return
    end

    for i = 1, #briefListData do
        self:AddFansPlayer(briefListData[i])
    end
    -- self:SortFansList()
end

function FriendDataMgr:RefreshBlackListData(briefListData)
    if briefListData == nil or #briefListData == 0 then return end

    for i = 1, #briefListData do
        self:AddBlackPlayer(briefListData[i])
    end
    -- self:SortBlackList()
end

function FriendDataMgr:GetDataListByType(type)
    if type == Enum.FriendTogglePageType.InterestList then
        return self.interestList
    elseif type == Enum.FriendTogglePageType.FansList then
        self:SetNewFansData(false)
        return self.fansList
    elseif type == Enum.FriendTogglePageType.BlackList then
        return self.blackList
    elseif type == Enum.FriendTogglePageType.FriendRecommend then
        return self.recommentList
    end
    return nil
end

function FriendDataMgr:GetUidListByType(type,cnt)
    local uids = {}
    if type == Enum.FriendTogglePageType.InterestList then
        if cnt > #self.allInterestIds then
            cnt = #self.allInterestIds
        end
        for i = 1, cnt do
            uids[#uids+1] = self.allInterestIds[i]
        end
    elseif type == Enum.FriendTogglePageType.FansList then
        if cnt > #self.allFansIds then
            cnt = #self.allFansIds
        end
        for i = 1, cnt do
            uids[#uids+1] = self.allFansIds[i]
        end
    elseif type == Enum.FriendTogglePageType.BlackList then
        if cnt > #self.allBlackIds then
            cnt = #self.allBlackIds
        end
        for i = 1, cnt do
            uids[#uids+1] = self.allBlackIds[i]
        end
    end
    return uids
end

function FriendDataMgr:GetInterestDataById(uid)
    if self.interestList then
        for i = 1, #self.interestList do
            local friend = self.interestList[i]
            if friend.uid == uid then
                return friend
            end
        end
    end
    return nil
end

function FriendDataMgr:GetFansDataById(uid)
    if self.fansList then
        for i = 1, #self.fansList do
            local fans = self.fansList[i]
            if fans.uid == uid then
                return fans
            end
        end
    end
    return nil
end

function FriendDataMgr:GetBlackDataById(uid)
    if self.blackList then
        for i = 1, #self.blackList do
            local black = self.blackList[i]
            if black.uid == uid then
                return black
            end
        end
    end
    return nil
end

function FriendDataMgr:GetStatus(uid)
    local state = 0
    if self:HasInterestPlayer(uid) then
        state = CommonUtil.Or(state,Enum.FriendStatusType.MyInterest)
    end

    if self:HasFansPlayer(uid) then
        state = CommonUtil.Or(state,Enum.FriendStatusType.MyFans)
    end

    return state
end

function FriendDataMgr:GetRecommendPlayerById(uid)
    if self.recommentList == nil then
        return nil
    end

    for i=1, #self.recommentList do
        if self.recommentList[i].uid == uid then
            return self.recommentList[i]
        end
    end

    return nil
end

function FriendDataMgr:GetSearchPlayerById(uid)
    if self.searchFriendPlayers == nil then
        return nil
    end

    for i=1, #self.searchFriendPlayers do
        if self.searchFriendPlayers[i].uid == uid then
            return self.searchFriendPlayers[i]
        end
    end

    return nil
end

function FriendDataMgr:AddInterestPlayer(briefInfo)
    if briefInfo == nil or self.interestList == nil then
        return
    end
    
    local obj = self:GetInterestDataById(briefInfo.uid)
    if obj ~= nil then
        obj:SetData(briefInfo)
    else
        obj = FriendData:new(briefInfo.uid)
        obj:SetData(briefInfo)
        self.interestList[#self.interestList+1] = obj
    end
    if self.AllExpeditionHelpIdList and  self.ExpeditionHelpList then
        for i = 1, #self.AllExpeditionHelpIdList do
            if self.AllExpeditionHelpIdList[i] == obj.uid then
                table.remove(self.AllExpeditionHelpIdList, i)
                self.ExpeditionHelpList[#self.ExpeditionHelpList + 1] = obj
                break
            end
        end
    end
    self:RefreshPlayerStatus(briefInfo.uid)
    self:RemoveInterestId(briefInfo.uid)
end

function FriendDataMgr:AddFansPlayer(briefInfo)
    if briefInfo == nil or self.fansList == nil then
        return
    end

    local obj = self:GetFansDataById(briefInfo.uid)
    if obj ~= nil then
        obj:SetData(briefInfo)
    else
        obj = FriendData:new(briefInfo.uid)
        obj:SetData(briefInfo)
        if self:InRedPoint(briefInfo.uid) then
            obj:SetNewState(true)
        end
        self.fansList[#self.fansList+1] = obj
    end
    self:RefreshPlayerStatus(briefInfo.uid)
    self:RemoveFansId(briefInfo.uid)
end

function FriendDataMgr:AddBlackPlayer(briefInfo)
    if briefInfo == nil or self.blackList == nil then
        return
    end

    local obj = self:GetBlackDataById(briefInfo.uid)
    if obj ~= nil then
        obj:SetData(briefInfo)
    else
        obj = FriendData:new(briefInfo.uid)
        obj:SetData(briefInfo)
        self.blackList[#self.blackList+1] = obj
    end 
    self:RefreshPlayerStatus(briefInfo.uid)
    self:RemoveBlackId(briefInfo.uid)
end

function FriendDataMgr:RemoveInterestById(uid)
    if not self.interestList then return end
    for i=1, #self.interestList do
        if self.interestList[i].uid == uid then
            table.remove(self.interestList, i)
            return
        end
    end
end

function FriendDataMgr:RemoveFansById(uid)
    if not self.fansList then return end
    for i = 1, #self.fansList do
        if self.fansList[i].uid == uid then
            table.remove(self.fansList,i)
            self.totalFansNum = self.totalFansNum - 1
            return
        end
    end
end

function FriendDataMgr:RemoveBlackById(uid)
    if not self.blackList then return end
    for i = 1, #self.blackList do
        if self.blackList[i].uid == uid then
            table.remove(self.blackList,i)
            self.totalBlackNum = self.totalBlackNum - 1
            return
        end
    end
end

function FriendDataMgr:RemoveRecommendById(uid)
    if self.recommentList == nil then
        return
    end

    for i = 1, #self.recommentList do
        if self.recommentList[i].uid == uid then
            table.remove(self.recommentList,i)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.FriendRecommend)
            return
        end
    end
end

function FriendDataMgr:RemoveInterestId(uid)
    if not self.allInterestIds then return end
    for i = 1, #self.allInterestIds do
        if self.allInterestIds[i] == uid then
            table.remove(self.allInterestIds,i)
            return
        end
    end
end

function FriendDataMgr:RemoveFansId(uid)
    if not self.allFansIds then return end
    for i =1, #self.allFansIds do
        if self.allFansIds[i] == uid then
            table.remove(self.allFansIds,i)
            return
        end
    end
end

function FriendDataMgr:RemoveBlackId(uid)
    if not self.allBlackIds then return end
    for i=1, #self.allBlackIds do
        if self.allBlackIds[i] == uid then
            table.remove(self.allBlackIds,i)
            return
        end
    end
end

function FriendDataMgr:IsBlackPlayer(uid)
    if self.allBlackIds then
        for i = 1, #self.allBlackIds do
            if self.allBlackIds[i] == uid then
                return true
            end
        end
    end

    local data = self:GetBlackDataById(uid) 
    if data ~= nil then
        return true
    end
    return false
end

function FriendDataMgr:HasInterestPlayer(uid)
    if self.allInterestIds then
        for i = 1, #self.allInterestIds do
            if self.allInterestIds[i] == uid then
                return true
            end
        end
    end

    local data = self:GetInterestDataById(uid) 
    if data ~= nil then
        return true
    end
    

    return false
end

function FriendDataMgr:HasFansPlayer(uid)
    if self.allFansIds then
        for i =1, #self.allFansIds do
            if self.allFansIds[i] == uid then
                return true
            end
        end
    end
    local data = self:GetFansDataById(uid)
    if data ~= nil then
        return true
    end

    return false
end

function FriendDataMgr:HasBlackPlayer(uid)
    if self.allBlackIds then
        for i =1, #self.allBlackIds do
            if self.allBlackIds[i] == uid then
                return true
            end
        end
    end

    local data = self:GetBlackDataById(uid)
    if data ~= nil then
        return true
    end

    return false
end

function FriendDataMgr:GetSearchData()
    return self.searchFriendPlayers
end

function FriendDataMgr:SetExpedotopmHelpList(flag)
    if flag then
        self.ExpeditionHelpList = {};
        self.AllExpeditionHelpIdList = self:GetAllFriendIdList()
    else
        self.ExpeditionHelpList = nil;
    end
end
function FriendDataMgr:GetExpedotopmHelpList()
    return self.ExpeditionHelpList
end
function FriendDataMgr:GetAllExpedotopmHelpIDList()
    return self.AllExpeditionHelpIdList
end

function FriendDataMgr:RequestAllData()
    self:RequestDataList(Enum.FriendTogglePageType.InterestList)
    self:RequestDataList(Enum.FriendTogglePageType.FansList)
    self:RequestDataList(Enum.FriendTogglePageType.BlackList)
end

function FriendDataMgr:GetAllFriendIdList()
    local list = {}
    if self.interestList then
        for i = 1,#self.interestList do
            if self.interestList[i].status == 3 then                
                list[#list+1] = self.interestList[i].uid
            end
        end
    end       
    if self.allInterestIds then
        for i = 1, #self.allInterestIds do
            local bFans = self:HasFansPlayer(self.allInterestIds[i])
            if bFans then
                list[#list+1] = self.allInterestIds[i]
            end
        end
    end
    return list
end

function FriendDataMgr:GetFriendIdList()
    local idList = {}
    if self.allInterestIds then
        for i = 1, #self.allInterestIds do
            local bFans = self:HasFansPlayer(self.allInterestIds[i])
            if bFans then
                idList[#idList+1] = self.allInterestIds[i]
            end
        end
    end
    return idList
end

function FriendDataMgr:GetFriendDataList()
    local list = {}
    if self.interestList then
        for i = 1,#self.interestList do
            if self.interestList[i].status == 3 then
                list[#list+1] = self.interestList[i]
            end
        end
    end
    return list
end

-- type: FriendTogglePageType 
function FriendDataMgr:RequestDataList(reqType)
    if self:CanSendReq(reqType) then
        -- LogError("FriendDataMgr:RequestDataList:" .. reqType)
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FRIEND_REQ, {type = reqType})
        self:RecordReqTime(reqType)
    else  
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,reqType)
    end
end

function FriendDataMgr:CanSendReq(reqType)
    local curTime = Time.realtimeSinceStartup
    if reqType == Enum.FriendTogglePageType.InterestList then
        return (curTime - self.lastReqFriendListTime) >= self.reqFriendListCDTime or self.lastReqFriendListTime == 0
    elseif reqType == Enum.FriendTogglePageType.FansList then
        return (curTime - self.lastReqFansListTime) >= self.reqFansListCDTime or self.lastReqFansListTime == 0
    elseif reqType == Enum.FriendTogglePageType.BlackList then
        return (curTime - self.lastReqBlackListTime) >= self.reqBlackListCDTime or self.lastReqBlackListTime == 0
    else
        return false
    end
end

function FriendDataMgr:RecordReqTime(reqType)
    local curTime = Time.realtimeSinceStartup
    if reqType == Enum.FriendTogglePageType.InterestList then
        self.lastReqFriendListTime = curTime
    elseif reqType == Enum.FriendTogglePageType.FansList then
        self.lastReqFriendListTime = curTime
    elseif reqType == Enum.FriendTogglePageType.BlackList then
        self.lastReqBlackListTime = curTime
    elseif reqType == Enum.FriendTogglePageType.FriendRecommend then
        self.lastGetFriendRecommendTime = curTime
    end
end

function FriendDataMgr:OnGetFriendListAck(data)
    -- LogError("OnGetFriendListAck : " .. Inspect(data))
    if data == nil then 
        return
    end
    
    if data.type == Enum.FriendTogglePageType.InterestList then
        self:InitInterestData(data)
    elseif data.type == Enum.FriendTogglePageType.FansList then
        self:InitFansData(data)
    elseif data.type == Enum.FriendTogglePageType.BlackList then
        self:InitBlackData(data)
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Update_FriendDataList,data.type)
end

-- 获取好友简介信息
function FriendDataMgr:ReqFriendBriefData(reqType,uids)
    if uids == nil or #uids == 0 then
        -- LogError("FriendDataMgr:ReqFriendBriefData:" .. reqType)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,reqType)
        return
    end

    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_OTHER_PLAYER_BRIEF_INFO_REQ, {type=reqType, player_list=uids})
end

-- message SCGetOtherPlayerBriefInfoAck {
--     repeated CommonPlayerBriefInfo brief_info                = 1;
--     int32 type                                               = 2;
-- }
function FriendDataMgr:OnGetFriendBriefInfoAck(data)
    if data.type == Enum.FriendTogglePageType.GuildPlayerBriefQuery then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_GET_OTHER_PLAYER_BRIEF_INFO_ACK, data)
        return
    end
    if data.type == Enum.FriendTogglePageType.ClimbingTower then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SC_GET_OTHER_PLAYER_BRIEF_INFO_ACK,data)
        return
    end

    if data.type == Enum.FriendTogglePageType.GuildDemonPlayerInfo or data.type == Enum.FriendTogglePageType.GuildDemonMvpInfo then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_DEMON_GET_OTHER_PLAYER_BRIEF_INFO_ACK,data)
        return
    end

    if data.type == Enum.FriendTogglePageType.IdolRankInfo or data.type == Enum.FriendTogglePageType.IdolFansInfo or data.type == Enum.FriendTogglePageType.TempPlayerBirefInfos then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.IDOL_GET_OTHER_PLAYER_BRIEF_INFO_ACK,data)
        return
    end

    if data.type == Enum.FriendTogglePageType.ExpedtionHelpLog then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Expedition_GET_OTHER_PLAYER_BRIEF_INFO,data)
        return
    end

    if data.type == Enum.FriendTogglePageType.InterestList then
        self:RefreshInterestListData(data.brief_info)
    elseif data.type == Enum.FriendTogglePageType.FansList then
        self:RefreshFansListData(data.brief_info)
    elseif data.type == Enum.FriendTogglePageType.BlackList then
        self:RefreshBlackListData(data.brief_info)
    end
    if data.type >= Enum.FriendTogglePageType.InterestList and data.type <= Enum.FriendTogglePageType.BlackList then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,data.type)
    elseif data.type == Enum.FriendTogglePageType.PrivateChatBriefQuery then
        if data.brief_info[1] then
            ManagerContainer.DataMgr.ChatData:RefreshChatTargetBriefInfo(data.brief_info)
        end
    elseif data.type == Enum.FriendTogglePageType.FriendInvitation then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.FRIEND_INVITATION_MASTER_INFO_REFRESH,data.brief_info[1])
    elseif data.type == Enum.FriendTogglePageType.InvitationStudentListQuery then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.FRIEND_INVITATION_QUERY_STUDENT_LIST_INFO,data.brief_info)
    elseif data.type == Enum.FriendTogglePageType.InvitationStudentSingleQuery then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.FRIEND_INVITATION_QUERY_STUDENT_SINGLE_INFO,data.brief_info[1])
    end
end

-- 获取推荐列表
function FriendDataMgr:GetFriendRecommendReq()
    local curTime = Time.realtimeSinceStartup

    if ((curTime - self.lastGetFriendRecommendTime) >= self.reqFriendRecommendCDTime) or #self.recommentList == 0 then
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FRIEND_RECOMMEND_REQ, {})
        self.lastGetFriendRecommendTime = curTime
    else
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(string.formatbykey("FrequentOperation")) 
    end
end

function FriendDataMgr:OnGetFriendRecommendListAck(data)
    -- LogError("FriendDataMgr:OnGetFriendRecommendListAck:" .. Inspect(data))
    if data.error == Enum.NetErrorCode.ERROR_OK then
        if data.brief_info_list then
            self.recommentList = {}
            for i=1, #data.brief_info_list do
                local playerBriefInfo = data.brief_info_list[i]
                local obj = FriendData:new(playerBriefInfo.uid)
                obj:SetData(playerBriefInfo)
                self.recommentList[#self.recommentList+1] = obj
                obj:SetStatus(self:GetStatus(playerBriefInfo.uid))
            end
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.FriendRecommend)
        end
    else
        -- todo 提示error
    end
end

function FriendDataMgr:OnRecommendFriendNtf(data)
    if not data.brief_info_list then return end
    for i=1, #data.brief_info_list do
        local playerBriefInfo = data.brief_info_list[i]
        local obj = FriendData:new(playerBriefInfo.uid)
        obj:SetData(playerBriefInfo)
        self.recommentList[#self.recommentList+1] = obj
        obj:SetStatus(self:GetStatus(playerBriefInfo.uid))
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.FriendRecommend)
end

-- 添加关注请求
function FriendDataMgr:AddFriendReq(uid)
    if uid == 0 then
        return
    end

    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FRIEND_ADD_REQ, {add_uid = uid})
end

function FriendDataMgr:OnAddFriendAck(data)
    -- LogError("FriendDataMgr:OnAddFriendAck:" .. Inspect(data))
    if data.error == Enum.NetErrorCode.ERROR_OK then 
        self.totalFriendNum = self.totalFriendNum + 1
        self:AddInterestPlayer(data.brief_info)
        self:RemoveRecommendById(data.brief_info.uid)
        -- self:SortInterestLit()

        local player = self:GetFansDataById(data.brief_info.uid)
        if player~= nil then
            -- self:SortFansList()
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.FansList)
        end
        
        player = self:GetBlackDataById(data.brief_info.uid)
        if player ~= nil then
            -- self:SortBlackList()
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.BlackList)
        end
     
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.InterestList)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Show_SearchFriendData)
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(string.formatbykey("FollowFriendsSuccess",CommonUtil.GetVaildNickName(data.brief_info.nick_name)))   
    else
        -- ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("关注失败: " .. data.error)
    end
end

function FriendDataMgr:OnAddFriendNtf(nftData)
    -- LogError("OnAddFriendNtf: " .. Inspect(nftData))
    if not self.fansList then return end

    local briefInfo = nftData.brief_info
    local obj = self:GetFansDataById(briefInfo.uid)
    if obj ~= nil then
        obj:SetData(briefInfo)
    else
        obj = FriendData:new(briefInfo.uid)
        obj:SetData(briefInfo)
        obj:SetNewState(true)
        if self.newFansIds == nil then
            self.newFansIds = {}
        end
        self.newFansIds[#self.newFansIds+1] = briefInfo.uid
        self.fansList[#self.fansList+1] = obj
    end
    self:SetNewFansData(true)
    self:RefreshPlayerStatus(briefInfo.uid)
    -- self:SortFansList()

    local player = self:GetInterestDataById(nftData.brief_info.uid)
    if player~= nil then
        -- self:SortInterestLit()
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.InterestList)
    end

    player = self:GetBlackDataById(nftData.brief_info.uid)
    if player ~= nil then
        -- self:SortBlackList()
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.BlackList)
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.FansList)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Show_SearchFriendData)
end

function FriendDataMgr:DeleteFriendReq(uid)
    if uid == 0 then
        return
    end

    -- LogError("DeleteFriendReq:" .. tostring(uid))
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FRIEND_DEL_REQ, {del_uid = uid})
end

function FriendDataMgr:OnDeleteFriendAck(data)
    -- LogError("FriendDataMgr:OnDeleteFriendAck:" .. Inspect(data))

    if data.error == Enum.NetErrorCode.ERROR_OK then
        self.totalFriendNum = self.totalFriendNum - 1
        self:RemoveInterestId(data.del_uid)
        self:RemoveInterestById(data.del_uid)
        self:RefreshPlayerStatus(data.del_uid)
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(string.formatbykey("RemoveFollowConfirm"))
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.InterestList)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.FansList)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Show_SearchFriendData)
    else
        -- ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("取关失败: " .. data.error)
    end
end

function FriendDataMgr:OnDeleteFriendNtf(ntfData)
    -- LogError("OnDeleteFriendNtf: " .. tostring(ntfData.del_uid))
    self:RemoveFansById(ntfData.del_uid)
    self:RemoveFansId(ntfData.del_uid)
    self:RefreshPlayerStatus(ntfData.del_uid)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.InterestList)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.FansList)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.BlackList)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Show_SearchFriendData)
end

function FriendDataMgr:AddBlackReq(uid)
    if uid == 0 then
        return
    end

    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FRIEND_BLACK_REQ, {black_uid = uid})
end

-- 移除屏蔽名单
function FriendDataMgr:RemoveBlackReq(uid)
    if uid == 0 then
        return
    end

    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FRIEND_BLACK_REQ, {black_uid = uid})
end

function FriendDataMgr:OnAddOrRemoveBlackAck(data)
    -- LogError("FriendDataMgr:OnAddOrRemoveBlackAck:" .. Inspect(data))

    if data.error == Enum.NetErrorCode.ERROR_OK then
        local info = data.brief_info
        local black = self:GetBlackDataById(info.uid)
        if black ~= nil then
            self:RemoveBlackById(info.uid)
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(string.formatbykey("CancelBlacklistSuccess"))
        else
            self:AddBlackPlayer(info)
            -- self:SortBlackList()
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(string.formatbykey("AddBlackListSuccess",CommonUtil.GetVaildNickName(info.nick_name)))
        end
       
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.BlackList)
    else
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("移除黑名单失败!!" .. data.error)
    end
end

function FriendDataMgr:SearchFriendReq(userName)
    self.searchFriendPlayers = nil
    -- LogError("SearchFriendReq = " .. userName)
    if userName == "新玩家" then
        userName = ""
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FRIEND_SEARCH_REQ, {target_name = userName})
end

function FriendDataMgr:OnSearchFriendAck(data)
    -- LogError("OnSearchFriendAck = " .. Inspect(data))
    if data.error == Enum.NetErrorCode.ERROR_OK then
        self.searchFriendPlayers = {}
        for i = 1, #data.brief_info_list do
            local playerBriefInfo = data.brief_info_list[i]
            local obj = FriendData:new(playerBriefInfo.uid)
            obj:SetData(playerBriefInfo)
            self.searchFriendPlayers[#self.searchFriendPlayers+1] = obj
            obj:SetStatus(self:GetStatus(playerBriefInfo.uid))
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Show_SearchFriendData)
    else
        -- todo 提示检索失败
    end
end

function FriendDataMgr:RefreshPlayerStatus(uid)
    local status = self:GetStatus(uid)
    local player = self:GetInterestDataById(uid)
    if player~= nil then
        player:SetStatus(status)
    end

    player = self:GetFansDataById(uid)
    if player ~= nil then
        player:SetStatus(status)
    end

    player = self:GetBlackDataById(uid)
    if player ~= nil then
        player:SetStatus(status)
    end

    player = self:GetRecommendPlayerById(uid)
    if player ~= nil then
        player:SetStatus(status)
    end

    player = self:GetSearchPlayerById(uid)
    if player~= nil then
        player:SetStatus(status)
    end
end

function FriendDataMgr:HasNewFans()
    return self.hasNewFans
end

function FriendDataMgr:SetNewFansData(val)
    self.hasNewFans = val
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.Friend, self.hasNewFans)
end

function FriendDataMgr:CleanRedPoint()
    for i=1, #self.fansList do
        local fans = self.fansList[i]
        fans:SetNewState(false)
    end
    self.newFansIds  = nil
end

function FriendDataMgr:InRedPoint(uid)
    if self.newFansIds == nil or #self.newFansIds == 0 then
        return false
    end

    for i = 1,#self.newFansIds do
        if self.newFansIds[i] == uid then
            return true
        end
    end

    return false
end

function FriendDataMgr:SortInterestLit()
    if self.interestList == nil or #self.interestList < 2 then
        return
    end

    table.sort(
        self.interestList,
        function(a, b)
            if a.onlineStatus and b.onlineStatus == false then
                return true
            end

            if a.onlineStatus == false and  b.onlineStatus then
                return false
            end

            if a.onlineStatus and b.onlineStatus then
                if a.status == Enum.FriendStatusType.All and b.status ~= Enum.FriendStatusType.All then
                    return true
                end

                if a.status ~= Enum.FriendStatusType.All and b.status == Enum.FriendStatusType.All then
                    return false
                end

                if a.fightPower > b.fightPower then
                    return true
                end

                if a.fightPower < b.fightPower then
                    return false
                end

                return a.uid > b.uid
            end

            return a.lastOnlineTime > b.lastOnlineTime
        end
    )
end

function FriendDataMgr:SortFansList()
    if self.fansList == nil or #self.fansList < 2 then
        return
    end

    table.sort(
        self.fansList,
        function(a, b)
            if a.onlineStatus and b.onlineStatus == false then
                return true
            end

            if a.onlineStatus == false and  b.onlineStatus then
                return false
            end

            if a.onlineStatus and b.onlineStatus then
                if a.status == Enum.FriendStatusType.All and b.status ~= Enum.FriendStatusType.All then
                    return true
                end

                if a.status ~= Enum.FriendStatusType.All and b.status == Enum.FriendStatusType.All then
                    return false
                end

                if a.fightPower > b.fightPower then
                    return true
                end

                if a.fightPower < b.fightPower then
                    return false
                end

                return a.uid > b.uid
            end

            return a.lastOnlineTime > b.lastOnlineTime
        end
    )
end

function FriendDataMgr:SortBlackList()
    if self.blackList == nil or #self.blackList < 2 then
        return
    end

    table.sort(
        self.blackList,
        function(a, b)
            if a.onlineStatus and b.onlineStatus == false then
                return true
            end

            if a.onlineStatus == false and  b.onlineStatus then
                return false
            end

            if a.onlineStatus and b.onlineStatus then
                if a.status == Enum.FriendStatusType.All and b.status ~= Enum.FriendStatusType.All then
                    return true
                end

                if a.status ~= Enum.FriendStatusType.All and b.status == Enum.FriendStatusType.All then
                    return false
                end

                if a.fightPower > b.fightPower then
                    return true
                end

                if a.fightPower < b.fightPower then
                    return false
                end

                return a.uid > b.uid
            end

            return a.lastOnlineTime > b.lastOnlineTime
        end
    )
end

function FriendDataMgr:InitInvitationData(data)
    if self.friendRecruitData == nil then
        self.friendRecruitData = FriendRecruitData:new()
    end

    self.friendRecruitData:InitData(data)
end

function FriendDataMgr:GetMasterUId()
    if self.friendRecruitData then
       return self.friendRecruitData:GetMasterUId()
    end
    return 0
end

function FriendDataMgr:GetRecruitTaskDataByCfgId(cfgId)
    if self.friendRecruitData then
        return self.friendRecruitData:GetRecruitTaskDataByCfgId(cfgId)
    end
    return nil
end

function FriendDataMgr:InvitationTaskRewardReq(list)
    if self.friendRecruitData then
        self.friendRecruitData:InvitationTaskRewardReq(list)
    end
end

function FriendDataMgr:GetMyRecruitCode()
    if self.friendRecruitData then
        return self.friendRecruitData:GetMyRecruitCode()
    end
    return nil
end

function FriendDataMgr:InvitationNumberUserInfoReq(code)
    if self.friendRecruitData then
        self.friendRecruitData:InvitationNumberUserInfoReq(code)
    end
end

function FriendDataMgr:GetMyStudentInfoDatas()
    if self.friendRecruitData then
        return self.friendRecruitData:GetMyStudentInfoDatas()
    end
end

function FriendDataMgr:QueryNextStudentBriefInfo()
    if self.friendRecruitData then
        return self.friendRecruitData:QueryNextStudentBriefInfo()
    end
    return false
end

function FriendDataMgr:GetMyStudentCount()
    if self.friendRecruitData then
        return self.friendRecruitData:GetMyStudentCount()
    end
    return 0
end

function FriendDataMgr:GetMyStudentDataByUid(uid)
    if self.friendRecruitData then
        return self.friendRecruitData:GetMyStudentDataByUid(uid)
    end
    return 0
end

function FriendDataMgr:IsStudentClappedByUid(uid)
    if self.friendRecruitData then
        return self.friendRecruitData:IsStudentClappedByUid(uid)
    end
    return false
end

function FriendDataMgr:InvitationClickReq(list)
    if self.friendRecruitData then
        return self.friendRecruitData:InvitationClickReq(list)
    end
end

function FriendDataMgr:GetRemainClapCount()
    if self.friendRecruitData then
        return self.friendRecruitData:GetRemainClapCount()
    end
    return 0
end

function FriendDataMgr:ClearStudentDatas()
    if self.friendRecruitData then
        self.friendRecruitData:ClearStudentDatas()
    end
end

function FriendDataMgr:IsStudentListWhole()
    if self.friendRecruitData then
        return self.friendRecruitData:IsStudentListWhole()
    end
    return false
end

return FriendDataMgr