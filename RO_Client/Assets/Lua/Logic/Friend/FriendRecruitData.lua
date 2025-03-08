local FriendRecruitData = class("FriendRecruitData")

function FriendRecruitData:ctor()

end

function FriendRecruitData:RegisterEvents()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.FRIEND_INVITATION_QUERY_STUDENT_LIST_INFO, self, self.OnStudentDatasRefresh)
end

function FriendRecruitData:UnRegisterEvents()
    ManagerContainer.LuaEventMgr:UnRegisterEvent(UIEventNames.FRIEND_INVITATION_QUERY_STUDENT_LIST_INFO, self, self.OnStudentDatasRefresh)

end

function FriendRecruitData:RegisterNetEvents()
    self:RegisterEvents()

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_INVITATION_CHANG_NTF,self.RefreshData,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_INVITATION_NUMBER_ACK,self.InvitationNumberAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_INVITATION_NUMBER_USER_INFO_ACK,self.InvitationNumberUserInfoAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_INVITATION_BE_TO_MEMBER_ACK,self.InvitationBeToMemberAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_INVITATION_CLICK_ACK,self.InvitationClickAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_INVITATION_CLICK_REPLAY_ACK,self.InvitationClickReplayAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_INVITATION_DEL_MEMBER_ACK,self.InvitationDelMemberAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_INVITATION_TASK_REWARD_ACK,self.InvitationTaskRewardAck,self)
end

function FriendRecruitData:UnRegisterNetEvents()
    self:UnRegisterEvents()

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_INVITATION_CHANG_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_INVITATION_NUMBER_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_INVITATION_NUMBER_USER_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_INVITATION_CLICK_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_INVITATION_CLICK_REPLAY_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_INVITATION_DEL_MEMBER_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_INVITATION_TASK_REWARD_ACK)
end

function FriendRecruitData:InitData(data)
    self.recruitData = ProtocalDataNormal.ParseRoleInvitation(data.invitation_info)

    table.sort(self.recruitData.memberUidList, function (a,b)
        if a.resVal == b.resVal then
            return a.uid < b.uid
        end
        return a.resVal > b.resVal
    end)

    self.studentDatas = {}
end

function FriendRecruitData:ClearStudentDatas()
    self.studentDatas = {}
end

function FriendRecruitData:RefreshData(data)
    if data.invitation_info then
        self:InitData(data.invitation_info)
    end
    self.delMemberUidList = data.del_member_uid_list
end

function FriendRecruitData:GetMasterUId()
    return self.recruitData.masterUid
end

function FriendRecruitData:GetRecruitTaskDataByCfgId(cfgId)
    return self.recruitData.taskList[cfgId]
end

function FriendRecruitData:GetMyRecruitCode()
    return self.recruitData.selfInvitationNumber
end

function FriendRecruitData:GetMyStudentInfoDatas()
    return self.studentDatas
end

function FriendRecruitData:GetMyStudentCount()
    return #self.recruitData.memberUidList
end

function FriendRecruitData:GetRemainClapCount()
    return self.recruitData.clickNum
end

function FriendRecruitData:GetMyStudentDataByUid(uid)
    for _,v in pairs(self.recruitData.memberUidList) do
        if v.uid == uid then
            return v
        end
    end
    return nil
end

function FriendRecruitData:IsStudentClappedByUid(uid)
    return CommonUtil.EleInTable(uid, self.recruitData.clickMemberList)
end

function FriendRecruitData:InvitationNumberReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_INVITATION_NUMBER_REQ, {})
end

function FriendRecruitData:InvitationNumberAck(data)
    if data.error == Enum.NetErrorCode.ERROR_OK then

    end
end

function FriendRecruitData:InvitationNumberUserInfoReq(number)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_INVITATION_NUMBER_USER_INFO_REQ, {invitation_number = number})
end

function FriendRecruitData:InvitationNumberUserInfoAck(data)
    if data.error == Enum.NetErrorCode.ERROR_OK then
        local invitationTeaherBrief = ProtocalDataNormal.ParseCommonPlayerBriefInfo(data.brief)
        local teacherInvitationCount = data.member_num

        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.FRIEND_INVITATION_QUERY_MASTER_INFO, invitationTeaherBrief, teacherInvitationCount)
    end
end

function FriendRecruitData:InvitationBeToMemberReq(teacherNumber, teacherUid)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_INVITATION_BE_TO_MEMBER_REQ, {master_invitation_number = teacherNumber, master_uid = teacherUid})
end

function FriendRecruitData:InvitationBeToMemberAck(data)
    if data.error == Enum.NetErrorCode.ERROR_OK then

    end
end

function FriendRecruitData:InvitationClickReq(list)
    if self.recruitData.clickNum == 0 then
        return
    end
    if not list then
        list = {}
        for _,v in pairs(self.recruitData.memberUidList) do
            local uid = v.uid
            if not CommonUtil.EleInTable(uid, self.recruitData.clickMemberList) then
                if self.recruitData.clickNum == 0 then
                    break
                end
                if self.recruitData.clickNum > 0 then
                    self.recruitData.clickNum = self.recruitData.clickNum - 1
                    list[#list + 1] = uid
                end
            end
        end
    else
        self.recruitData.clickNum = self.recruitData.clickNum - 1
    end

    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_INVITATION_CLICK_REQ, {member_uid_list = list})
end

function FriendRecruitData:InvitationClickAck(data)
    if data.error == Enum.NetErrorCode.ERROR_OK then
        CommonUtil.ACKShowRewardList(data.reward_item_list)
    end
end

function FriendRecruitData:InvitationClickReplayReq(uid)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_INVITATION_CLICK_REPLAY_REQ, {master_uid = uid})
end

function FriendRecruitData:InvitationClickReplayAck(data)
    if data.error == Enum.NetErrorCode.ERROR_OK then
        CommonUtil.ACKShowRewardList(data.reward_item_list)
    end
end

function FriendRecruitData:InvitationDelMemberReq(list)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_INVITATION_DEL_MEMBER_REQ, {del_member_uid_list = list})
end

function FriendRecruitData:InvitationDelMemberAck(data)
    if data.error == Enum.NetErrorCode.ERROR_OK then
        --删除学员
        if self.recruitData.memberUidList then
            local memberUidList = self.recruitData.memberUidList
            for i = 1,#data.del_member_uid_list do
                local uid = data.del_member_uid_list[i]
                for j = #memberUidList, 1, -1 do
                    if uid == memberUidList[j].strVal then
                        table.remove(memberUidList, j)
                    end
                end
            end
        end
    end
end

function FriendRecruitData:InvitationTaskRewardReq(taskList)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_INVITATION_TASK_REWARD_REQ, {task_id_list = taskList})
end

function FriendRecruitData:InvitationTaskRewardAck(data)
    if data.error == Enum.NetErrorCode.ERROR_OK then

        CommonUtil.ACKShowRewardList(data.reward_item_list)
    end
end

function FriendRecruitData:QueryNextStudentBriefInfo()
    local count = #self.studentDatas
    local memberCount = #self.recruitData.memberUidList
    if count == memberCount then
        return false
    end

    local startIdx, endIdx = count + 1, count + 10
    if memberCount == 0 then
        return false
    end
    local length = math.min(endIdx, memberCount)

    local list = {}
    for i = startIdx, length do
        local data = self.recruitData.memberUidList[i]
        table.insert(list, data.uid)
    end

    if #list == 0 then
        return true
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_OTHER_PLAYER_BRIEF_INFO_REQ, {type=Enum.FriendTogglePageType.InvitationStudentListQuery, player_list=list})
    return true
end

function FriendRecruitData:OnStudentDatasRefresh(briefInfos)
    for i = 1, #briefInfos do
        local briefInfo = ProtocalDataNormal.ParseCommonPlayerBriefInfo(briefInfos[i])
        self.studentDatas[i] = briefInfo
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.FRIEND_INVITATION_QUERY_STUDENT_LIST_INFO)
end

function FriendRecruitData:IsStudentListWhole()
    return #self.studentDatas == #self.recruitData.memberUidList
end

function FriendRecruitData:Clear()
    self.recruitData = nil
    self.delMemberUidList = nil
    self.studentDatas = nil

    self.invitationTeaherBrief = nil
    self.teacherInvitationCount = nil
end

return FriendRecruitData