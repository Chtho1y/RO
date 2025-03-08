local FriendRecruitCtr = class("FriendRecruitCtr")

function FriendRecruitCtr:ctor()

end

function FriendRecruitCtr:GetMasterUId()
    local masterUId = ManagerContainer.DataMgr.FriendDataMgr:GetMasterUId()
    return masterUId
end

function FriendRecruitCtr:QueryPlayerInfo(uids)
    local data = {player_list = uids, type = Enum.FriendTogglePageType.FriendInvitation}
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_OTHER_PLAYER_BRIEF_INFO_REQ, data)
end

function FriendRecruitCtr:GetAllTaskCfgDatas()
    local taskCfgDatas = ManagerContainer.CfgMgr:GetAllInvitationTaskDatas()
    self.showDatas = {}
    for _,v in pairs(taskCfgDatas) do
        local cfgId = v.TaskId
        local logicData = ManagerContainer.DataMgr.FriendDataMgr:GetRecruitTaskDataByCfgId(cfgId)

        local data = {}
        data.cfgId = cfgId
        data.state = logicData and logicData.state or Enum.InvitationTaskStateType.NoCompeleted
        table.insert(self.showDatas, data)
    end

    table.sort(self.showDatas, function (a,b)
        return a.state < b.state
    end)
    return self.showDatas
end

function FriendRecruitCtr:GetAllStudentDatas()
    self.showDatas = ManagerContainer.DataMgr.FriendDataMgr:GetMyStudentInfoDatas()
    if #self.showDatas == 0 then
        self:QueryNextStudentBriefInfo()
    end
    return self.showDatas
end

function FriendRecruitCtr:GetShowDatasLength()
    return #self.showDatas
end

function FriendRecruitCtr:GetShowDataByIdx(idx)
    return self.showDatas[idx + 1]
end

function FriendRecruitCtr:SendTaskReward(cfgId)
    ManagerContainer.DataMgr.FriendDataMgr:InvitationTaskRewardReq({cfgId})
end

function FriendRecruitCtr:GetRecruitCode()
    return ManagerContainer.DataMgr.FriendDataMgr:GetMyRecruitCode()
end

function FriendRecruitCtr:SendInvitationNumberUserInfoReq(code)
    local number = int64.new(code)
    ManagerContainer.DataMgr.FriendDataMgr:InvitationNumberUserInfoReq(number)
end

function FriendRecruitCtr:ClapStudents(uid)
    ManagerContainer.DataMgr.FriendDataMgr:InvitationClickReq({uid})
end

function FriendRecruitCtr:OneKeyClapStudents()
    ManagerContainer.DataMgr.FriendDataMgr:InvitationClickReq()
end

function FriendRecruitCtr:GetStudentCount()
    return ManagerContainer.DataMgr.FriendDataMgr:GetMyStudentCount()
end

function FriendRecruitCtr:GetRemainClapCount()
    return ManagerContainer.DataMgr.FriendDataMgr:GetRemainClapCount()
end

function FriendRecruitCtr:QueryNextStudentBriefInfo()
    local errorCode = 0
    if not ManagerContainer.DataMgr.FriendDataMgr:QueryNextStudentBriefInfo() then
        return 100007
    end
    return errorCode
end

function FriendRecruitCtr:IsStudentListWhole()
    return ManagerContainer.DataMgr.FriendDataMgr:IsStudentListWhole()
end

function FriendRecruitCtr:GetStudentListTotalCount()
    return ManagerContainer.DataMgr.FriendDataMgr:GetMyStudentCount()
end

function FriendRecruitCtr:Dispose()
    self.showDatas = nil
    ManagerContainer.DataMgr.FriendDataMgr:ClearStudentDatas()
end

return FriendRecruitCtr
