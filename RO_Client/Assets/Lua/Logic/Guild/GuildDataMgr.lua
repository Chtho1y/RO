local GuildDataMgr = class('GuildDataMgr', require('DataBase'))
local GuildData = require('Guild/GuildData')

local REQ_GUILD_CD = 1000

function GuildDataMgr:ctor()
    self.lastSendMsgTimeMap = nil           -- 发送消息的冷却时间，避免操作过快
    self.curGuildData = nil                 -- 自身公会数据
    self.recommendGuildDatas = nil          -- 推荐公会列表
    self.searchGuildDatas = nil             -- 查询的公会列表数据
    self.searchString = nil
    self.checkGuildData = nil               -- 查看的公会列表数据
end

function GuildDataMgr:Clear()
    self.lastSendMsgTimeMap = nil
    self.curGuildData = nil
    self.recommendGuildDatas = nil
    self.searchGuildDatas = nil
    self.searchString = nil
    self.checkGuildData = nil

    self:DisposeGuildHuntBattle()
end

function GuildDataMgr:Destroy()
    self:UnRegisterNetEvents()
    self.lastSendMsgTimeMap = nil
    self.curGuildData = nil
    self.recommendGuildDatas = nil
    self.searchGuildDatas = nil
    self.searchString = nil
    self.checkGuildData = nil

    self:DisposeGuildHuntBattle()
end

function GuildDataMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ONLINE_PLAYER_GUILD_ACK, self.OnGuildLoginAck, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_BUILD_GUILD_ACK, self.OnGuildCreateAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_APPLY_GUILD_ACK, self.OnGuildEnterApplyAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_INFO_ACK, self.OnGuildInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GET_SELF_GUILD_INFO_ACK, self.OnGuildSelfInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_RECOMMEND_GUILD_INFO_ACK, self.OnGuildRecommendListAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SEARCH_GUILD_ACK, self.OnGuildSearchListAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_MEMBER_INFO_ACK, self.OnGuildMemberMoreInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_LOG_INFO_ACK, self.OnGuildLogInfoAck, self)

    -- 公会管理操作
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_APPLY_DATA_ACK, self.OnGuildApplyDataAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_APPLY_INFO_HANDLE_ACK, self.OnApplyInfoHandleAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_APPLY_INFO_HANDLE_NTF, self.OnApplyInfoHandleNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SET_GUILD_INFO_ACK, self.OnSetGuildInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DISBAND_GUILD_ACK, self.OnDisbandGuildAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_QUIT_GUILD_ACK, self.OnQuitGuildAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_QUIT_GUILD_CD_NTF, self.OnQuitGuildCDNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_RE_NOTICE_ACK, self.OnGuildReNoticeAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_RENAME_ACK, self.OnGuildRenameAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_NAME_CHANGE_NTF, self.OnGuildRenameNtf, self)

    -- 公会人员操作
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CHANGE_MEMBER_TITLE_ACK, self.OnChangeMemeberPostAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CHANGE_MEMBER_TITLE_NTF, self.OnChangeMemeberPostNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_KICK_GUILD_MEMBER_ACK, self.OnKickGuildMemberAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_KICK_GUILD_MEMBER_NTF, self.OnKickGuildMemberNtf, self)

    -- 公会狩猎
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BOSS_INFO_ACK, self.OnGuildBossInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BOSS_LOG_ACK, self.OnGuildBossLogAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BOSS_CHALLENGE_ACK, self.OnGuildBossChallengeAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BOSS_SUMMON_ACK, self.OnGuildBossSummonAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BOSS_EXTRA_REWARD_ACK, self.OnGuildBossMasterRewardAck, self)
end

function GuildDataMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_ONLINE_PLAYER_GUILD_ACK)

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_BUILD_GUILD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_APPLY_GUILD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GET_SELF_GUILD_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_RECOMMEND_GUILD_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SEARCH_GUILD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_MEMBER_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_LOG_INFO_ACK)

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_APPLY_DATA_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_APPLY_INFO_HANDLE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_APPLY_INFO_HANDLE_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SET_GUILD_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_DISBAND_GUILD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_QUIT_GUILD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_QUIT_GUILD_CD_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_RE_NOTICE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_RENAME_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_NAME_CHANGE_NTF)

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CHANGE_MEMBER_TITLE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CHANGE_MEMBER_TITLE_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_KICK_GUILD_MEMBER_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_KICK_GUILD_MEMBER_NTF)

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BOSS_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BOSS_LOG_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BOSS_CHALLENGE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BOSS_SUMMON_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BOSS_EXTRA_REWARD_ACK)
end

function GuildDataMgr:IsCanSend(key, cdTime)
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    if not self.lastSendMsgTimeMap then
        self.lastSendMsgTimeMap = {}
        self.lastSendMsgTimeMap[key] = curTime
        return true
    end
    local lastTime = self.lastSendMsgTimeMap[key]
    if lastTime then
        local cd = cdTime or REQ_GUILD_CD
        if (curTime - lastTime) < cd then
            return false
        end
    end
    self.lastSendMsgTimeMap[key] = curTime
    return true
end

function GuildDataMgr:CheckErrorCode(data)
    if ManagerContainer.NetManager:IsErrorData(data) then
        if data and data.error then
            if data.error == Enum.NetErrorCode.ERROR_GUILD_NOT_IN_GUILD then
                if self:HasGuild() then
                    if self.curGuildData then
                        self.curGuildData:ClearGuildData()
                        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_QUIT_SUCCESS)
                    end
                end
            elseif data.error == Enum.NetErrorCode.ERROR_GUILD_IN_GUILD then
                if not self:HasGuild() then
                    ManagerContainer.DataMgr.GuildDataMgr:SendGuildLoginReq()
                end
            end
        end
        return true
    end
    return false
end

function GuildDataMgr:OnGuildLoginAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildLoginAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self.curGuildData then
        self.curGuildData = GuildData:new()
    end
    self.curGuildData:SetNotifyData(data.data)
    self.curGuildData:SetNextCDTime(data.next_join)
    if data.msgRec then
        local chatData = ManagerContainer.DataMgr.ChatData
        if chatData then
            local len = #data.msgRec
            if len > 0 then
                for i = 1, #data.msgRec do
                    chatData:AddNewChatData(data.msgRec[i])
                end
                chatData:SortWorldChats()
            end
        end
    end
    ManagerContainer.DataMgr.GuildWarDataMgr:SetOpenState(data.in_guild_battle)

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_LOGIN_SUCCESS)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.GuildHuntBoss, data.boss)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.GuildDemonBoss, data.boss)
end




function GuildDataMgr:OnGuildCreateAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildCreateAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if self:HasGuild() then
        LogError("[wboy]Already in the guild, Build Guild Ack ?")
    end
    if not self.curGuildData then
        self.curGuildData = GuildData:new()
    end
    self.curGuildData:SetBriefData(data.guild_brief)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_CREATE_SUCCESS)
end

function GuildDataMgr:OnGuildEnterApplyAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildEnterApplyAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    local id = data.guild_id
    if not self.checkGuildData or not self.checkGuildData:IsSameGuild(id) then return end
    local isSubmit = ((data.op_type == 1) and true or false)
    self.checkGuildData:SetSubmitApply(isSubmit)

    if self.searchGuildDatas then
        for k, v in pairs(self.searchGuildDatas) do
            if v:IsSameGuild(id) then
                v:SetSubmitApply(isSubmit)
            end
        end
    end

    if self.recommendGuildDatas then
        for k, v in pairs(self.recommendGuildDatas) do
            if v:IsSameGuild(id) then
                v:SetSubmitApply(isSubmit)
            end
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_SUBMIT_APPLY_CHANGED)
    self:ReportEnterApple(true)
end

function GuildDataMgr:ReportEnterApple(success)
    if not SDKMgr.Instance:IsReportAction() then
        return
    end
    local datas = System.Collections.Generic.Dictionary_object_object()
    datas:Add('event', 'mj_guild')
    datas:Add('is_achieve', (success and 1 or 0))
    SDKMgr.Instance:ReportAction(datas)
end

function GuildDataMgr:OnKickGuildMemberAck(data)
    -- LogError("[wboy] GuildDataMgr:OnKickGuildMemberAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    local uid = data.uid
    if not self.curGuildData then return end
    local changed = self.curGuildData:KickMember(uid)
    if changed then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_MEMBER_MORE_INFO_CHANGED, self.curGuildData:GetId())
    end
end

function GuildDataMgr:OnKickGuildMemberNtf(data)
    -- LogError("[wboy] GuildDataMgr:OnKickGuildMemberNtf " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    local id = data.guild_id
    local uid = data.uid
    if not self.curGuildData then return end
    if not self.curGuildData:IsSameGuild(id) then return end
    if ManagerContainer.DataMgr.UserData:GetUserId() ~= uid then return end
    self.curGuildData:ClearGuildData()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_KICKOUT_SUCCESS)
    ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildTips_025')
    ManagerContainer.DataMgr.ChatData:ClearGuildChatData()
    --清除本次上线公会BOSS和魔王BOSS红点消息
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.GuildDemonBoss, false)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.GuildHuntBoss, false)
end






function GuildDataMgr:OnGuildApplyDataAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildApplyDataAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self.curGuildData then return end
    self.curGuildData:SetAuditApplyData(data.uid_list)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_GET_AUDIT_APPLY_BASE_LIST_CHANGED)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.GuildAuditApply, self.curGuildData:GetIsHasApply())
end

function GuildDataMgr:OnApplyInfoHandleAck(data)
    -- LogError("[wboy] GuildDataMgr:OnApplyInfoHandleAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    local id = data.guild_id
    if not self.curGuildData then return end
    if not self.curGuildData:IsSameGuild(id) then return end
    local handleType = data.handle_type
    local status, errorCode = self.curGuildData:SetAuditApplyHandle(handleType, data.uid_list)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.GuildAuditApply, self.curGuildData:GetIsHasApply())
    if status == 1 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_GET_AUDIT_APPLY_LIST_CHANGED)
    elseif status == 2 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_GET_AUDIT_APPLY_LIST_CHANGED)
    end
    if errorCode and errorCode ~= 0 then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
    else
        if handleType == Enum.GuildAduitApplyHandleType.AllAllow then
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildTips_029')
        elseif handleType == Enum.GuildAduitApplyHandleType.AllRefuse then
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildTips_031')
        elseif handleType == Enum.GuildAduitApplyHandleType.One then
            if status == 1 then
                ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildTips_028')
            elseif status == 2 then
                ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildTips_026')
            end
        end
    end
end

function GuildDataMgr:OnApplyInfoHandleNtf(data)
    -- LogError("[wboy] GuildDataMgr:OnApplyInfoHandleNtf " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if data.apply_result ~= 1 then return end
    local uid = data.uid
    if ManagerContainer.DataMgr.UserData:GetUserId() ~= uid then return end
    local id = data.guild_id
    if self.curGuildData then
        if self:HasGuild() and not self.curGuildData:IsSameGuild(id) then
            LogError('[wboy] current guild is ' .. self.curGuildData:GetId() .. ',but new Guild is ' .. tostring(id))
        end
    else
        self.curGuildData = GuildData:new()
    end
    self.curGuildData:SetNotifyData(data.data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_ENTER_SUCCESS)
end

function GuildDataMgr:OnSetGuildInfoAck(data)
    -- LogError("[wboy] GuildDataMgr:OnSetGuildInfoAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self.curGuildData then return end
    if self.curGuildData:SetGuildBadge(data.guild_badge) then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_BADGE_CHANGED)
    end
    if self.curGuildData:SetGuildRecuitInfo(data.join_type, data.join_level, data.recruit_notice) then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_RECUIT_CHANGED)
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildTips_036')
    end
end

function GuildDataMgr:OnDisbandGuildAck(data)
    -- LogError("[wboy] GuildDataMgr:OnDisbandGuildAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self:HasGuild() then return end
    if not self.curGuildData then return end
    self.curGuildData:ClearGuildData()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_DISBAND_SUCCESS)
    ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildTips_008')
    ManagerContainer.DataMgr.ChatData:ClearGuildChatData()
    --清除本次上线公会BOSS和魔王BOSS红点消息
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.GuildDemonBoss, false)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.GuildHuntBoss, false)
end

function GuildDataMgr:OnQuitGuildAck(data)
    -- LogError("[wboy] GuildDataMgr:OnQuitGuildAck " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    if not self:HasGuild() then return end
    if not self.curGuildData then return end
    self.curGuildData:ClearGuildData()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_QUIT_SUCCESS)
    ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildTips_007')
    ManagerContainer.DataMgr.ChatData:ClearGuildChatData()
    --清除本次上线公会BOSS和魔王BOSS红点消息
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.GuildDemonBoss, false)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.GuildHuntBoss, false)
end

function GuildDataMgr:OnQuitGuildCDNtf(data)
    -- LogError("[wboy] GuildDataMgr:OnQuitGuildCDNtf " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self.curGuildData then return end
    if self.curGuildData:SetGuildQuitData(data.quit_num, data.next_join) then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_QUIT_CD_CHANGED)
    end
end


function GuildDataMgr:OnGuildReNoticeAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildReNoticeAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self:HasGuild() then return end
    if not self.curGuildData then return end
    if self.curGuildData:SetGuildNotice(data.guild_notice) then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_NOTICE_CHANGED)
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildTips_011')
    end
end

function GuildDataMgr:OnGuildRenameAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildRenameAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self:HasGuild() then return end
    if not self.curGuildData then return end
    if self.curGuildData:SetGuildName(data.guild_name) then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_NAME_CHANGED)
    end
end

function GuildDataMgr:OnGuildRenameNtf(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildRenameNtf " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self:HasGuild() then return end
    if not self.curGuildData then return end
    if not self.curGuildData:IsSameGuild(data.guild_id) then return end
    if self.curGuildData:SetGuildName(data.guild_name) then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_NAME_CHANGED)
    end
end




function GuildDataMgr:OnChangeMemeberPostAck(data)
    -- LogError("[wboy] GuildDataMgr:OnChangeMemeberPostAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self:HasGuild() then return end
    if not self.curGuildData then return end
    local uid = data.uid
    local post = data.title
    local lastPost = self.curGuildData:GetGuildMemberPost(uid, post)
    local changed = self.curGuildData:ChangeMemberPost(uid, post)
    if changed then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_MEMBER_MORE_INFO_CHANGED, self.curGuildData:GetId())
        if post == Enum.GuildPostType.President then
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildTips_016')
        else
            if lastPost == Enum.GuildPostType.None then
                ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildTips_018')
            elseif lastPost == Enum.GuildPostType.VicePresident then
                if post == Enum.GuildPostType.None then
                    ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildTips_020')
                else
                    ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildTips_018')
                end
            end
        end
    end
end

function GuildDataMgr:OnChangeMemeberPostNtf(data)
    -- LogError("[wboy] GuildDataMgr:OnChangeMemeberPostNtf " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self:HasGuild() then return end
    if not self.curGuildData then return end
    if not self.curGuildData:IsSameGuild(data.guild_id) then return end
    local changed = false
    if data.uid_list then
        for i = 1, #data.uid_list do
            local change = data.uid_list[i]
            if self.curGuildData:ChangeMemberPost(change.key, change.value) then
                changed = true
            end
        end
    end
    if changed then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_MEMBER_MORE_INFO_CHANGED, self.curGuildData:GetId())
    end
end

function GuildDataMgr:OnGuildInfoAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildInfoAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    local guildData = GuildData:new()
    guildData:SetBaseData(data.guild_Base)
    guildData:SetMemberBriefDatas(data.mem_brief)
    guildData:SetRoleGuildData(data.role_guild, data.total_active)
    guildData:SetSubmitApply(data.apply)
    self.checkGuildData = guildData
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_OTHER_MORE_INFO_CHANGED)
end

function GuildDataMgr:OnGuildSelfInfoAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildSelfInfoAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self.curGuildData then
        self.curGuildData = GuildData:new()
    end
    self.curGuildData:SetBaseData(data.guild_Base)
    self.curGuildData:SetMemberBriefDatas(data.mem_brief)
    self.curGuildData:SetRoleGuildData(data.role_guild, data.total_active)
    self.curGuildData:SetHasApply(data.apply_list)
    self.curGuildData:SetGuildWarInfo(data.guild_battle_state, data.next_state_begin, data.cp_num, data.guild_battle_rank)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_SELF_MORE_INFO_CHANGED)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.GuildAuditApply, self.curGuildData:GetIsHasApply())
end

function GuildDataMgr:OnGuildRecommendListAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildRecommendListAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self.recommendGuildDatas then
        self.recommendGuildDatas = {}
    end
    local len1 = #self.recommendGuildDatas
    local len2 = 0
    local notifyDatas  = data.data
    if notifyDatas then
        len2 = #notifyDatas
        for i = 1, len2 do
            local notifyData = notifyDatas[i]
            local guildData = nil
            if i <= len1 then
                guildData = self.recommendGuildDatas[i]
                guildData:Dispose()
            else
                guildData = GuildData:new()
                self.recommendGuildDatas[i] = guildData
            end
            guildData:SetNotifyData(notifyData)
        end
    end
    for i = len2 + 1, len1 do
        self.recommendGuildDatas[i] = nil
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_RECOMMEND_LIST_CHANGED)
end

function GuildDataMgr:OnGuildSearchListAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildSearchListAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    self.searchString = data.search_string
    if not self.searchGuildDatas then
        self.searchGuildDatas = {}
    end
    local len1 = #self.searchGuildDatas
    local len2 = 0
    local notifyDatas  = data.data
    if notifyDatas then
        len2 = #notifyDatas
        for i = 1, len2 do
            local notifyData = notifyDatas[i]
            local guildData = nil
            if i <= len1 then
                guildData = self.searchGuildDatas[i]
                guildData:Dispose()
            else
                guildData = GuildData:new()
                self.searchGuildDatas[i] = guildData
            end
            guildData:SetNotifyData(notifyData)
        end
    end
    for i = len2 + 1, len1 do
        self.searchGuildDatas[i] = nil
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_SEARCH_LIST_CHANGED)
end

function GuildDataMgr:OnGuildMemberMoreInfoAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildMemberMoreInfoAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    local id = data.guild_id
    if self.curGuildData and self.curGuildData:IsSameGuild(id) then
        self.curGuildData:SetMemberInfoDatas(data.member_data)
    end
    if self.checkGuildData and self.checkGuildData:IsSameGuild(id) then
        self.checkGuildData:SetMemberInfoDatas(data.member_data)
    end
    if self.recommendGuildDatas then
        for _, value in pairs(self.recommendGuildDatas) do
            if value and value:IsSameGuild(id) then
                value:SetMemberInfoDatas(data.member_data)
                break
            end
        end
    end
    if self.searchGuildDatas then
        for _, value in pairs(self.searchGuildDatas) do
            if value and value:IsSameGuild(id) then
                value:SetMemberInfoDatas(data.member_data)
                break
            end
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_MEMBER_MORE_INFO_CHANGED, id)
end

function GuildDataMgr:OnGuildLogInfoAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildLogInfoAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self:HasGuild() then return end
    if not self.curGuildData then return end
    local changed, startChanged, endChanged = self.curGuildData:SetLogs(data.log, data.is_end)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_LOG_CHANGED, changed, startChanged, endChanged)
end


function GuildDataMgr:OnGuildBossInfoAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildBossInfoAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self:HasGuild() then return end
    if not self.curGuildData then return end
    self.curGuildData:SetHuntBossList(data.boss_data, data.boss_fight, data.elite_boss_cd)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_HUNT_BOSS_LIST_CHANGED)
end

function GuildDataMgr:OnGuildBossLogAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildBossLogAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self:HasGuild() then return end
    if not self.curGuildData then return end
    self.curGuildData:SetHuntBossLogs(data.boss_id, data.logs, data.is_end)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_HUNT_BOSS_BATTLE_LOG_CHANGED, data.boss_id)
end

function GuildDataMgr:OnGuildBossChallengeAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildBossChallengeAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self:HasGuild() then return end
    if not self.curGuildData then return end
    if self.huntBattleInfo and self.huntBattleInfo.bossId == data.boss_id then
        local rewards = {}
        for i = 1, #data.reward do
            local reward = data.reward[i]
            rewards[#rewards + 1] = {cfgId = reward.key, num = reward.value}
        end
        self.huntBattleInfo.rewards = rewards
    end
    self:OpenHuntBattleRewardView()
end

function GuildDataMgr:OnGuildBossSummonAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildBossSummonAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self:HasGuild() then return end
    if not self.curGuildData then return end
    self.curGuildData:SetHuntBossInfo(data.boss_id, data.guild_active, data.fight_start, data.fight_count)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_ACTIVE_CHANGED)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_HUNT_BOSS_SUMMON_CHANGED, data.boss_id)
end

function GuildDataMgr:OnGuildBossMasterRewardAck(data)
    -- LogError("[wboy] GuildDataMgr:OnGuildBossMasterRewardAck " .. Inspect(data))
    if self:CheckErrorCode(data) then
        return
    end
    if not self:HasGuild() then return end
    if not self.curGuildData then return end
    self.curGuildData:SetHuntBossMasterReward(data.boss_id, data.brief, data.max_dam)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_HUNT_MASTER_REWARD_CHANGED, data.boss_id)
end














--- 登录的时候获得公会的基础信息，用于其它功能
function GuildDataMgr:SendGuildLoginReq()
    if not self:IsCanSend(1) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ONLINE_PLAYER_GUILD_REQ)
    return true
end

--- 发送创建公会请求
function GuildDataMgr:SendBuildGuildReq(name, badge)
    if not self:IsCanSend(2) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_BUILD_GUILD_REQ, {guild_name = name, guild_badge = badge})
    return true
end

--- 发送申请加入或取消申请公会请求
function GuildDataMgr:SendGuildApplyReq(guildId, isSubmit)
    if not self:IsCanSend(3) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_APPLY_GUILD_REQ, {guild_id = guildId, op_type = (isSubmit and 1 or 2)})
    return true
end

function GuildDataMgr:SendGetGuildMoreInfoReq(guildId)
    if not self:IsCanSend(4) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_INFO_REQ, {guild_id = guildId})
    return true
end

--- 获得公会推荐列表
function GuildDataMgr:SendGetRecommendListReq()
    if not self:IsCanSend(5) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_RECOMMEND_GUILD_INFO_REQ)
    return true
end

--- 查询公会
function GuildDataMgr:SendSearchGuildReq(text)
    if not self:IsCanSend(6) then return false end
    self.searchGuildDatas = nil
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SEARCH_GUILD_REQ, {search_string = text})
    return true
end

function GuildDataMgr:SendGetGuildSelfInfoReq()
    if not self:IsCanSend(7) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_SELF_GUILD_INFO_REQ)
    return true
end

function GuildDataMgr:SendGetGuildMemberInfoReq(guildId, uids)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_MEMBER_INFO_REQ, {guild_id = guildId, uid_list = uids})
    return true
end












function GuildDataMgr:SendGetAuditApplyListReq()
    if not self:IsCanSend(9) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_APPLY_DATA_REQ)
    return true
end

function GuildDataMgr:SendApplyInfoHandleReq(apply, handleType)
    if not self:IsCanSend(10) then return false end
    local sendData = {apply = apply, handle_type = handleType}
    if handleType ~= Enum.GuildAduitApplyHandleType.One then
        if self.curGuildData then
            local uids = self.curGuildData:GetAuditApplyUids()
            sendData.uid_list = uids
        end
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_APPLY_INFO_HANDLE_REQ, sendData)
    return true
end

--- 发送设置公会信息请求
function GuildDataMgr:SendSetGuildInfoReq(badge, recruitType, recruitLevel, recruitNotice)
    if not self:IsCanSend(11) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SET_GUILD_INFO_REQ, {guild_badge = badge, join_level = recruitLevel, join_type = recruitType, recruit_notice = recruitNotice})
    return true
end

--- 发送解散公会请求
function GuildDataMgr:SendDisbandGuildReq()
    if not self:IsCanSend(12) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_DISBAND_GUILD_REQ)
    return true
end

--- 发送退出公会请求
function GuildDataMgr:SendQuitGuildReq()
    if not self:IsCanSend(13) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_QUIT_GUILD_REQ)
    return true
end

function GuildDataMgr:SendChangeNoticeReq(newNotice)
    if not self:IsCanSend(14) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_RE_NOTICE_REQ, {guild_notice = newNotice})
    return true
end

function GuildDataMgr:SendGuildChangeNameReq(newName)
    if not self:IsCanSend(15) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_RENAME_REQ, {guild_name = newName})
    return true
end

function GuildDataMgr:SendGetGuildLogInfoReq(startTime)
    -- if not self:IsCanSend(16) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_LOG_INFO_REQ, {log_time = startTime})
    return true
end

--- 发送改变公会人员职位请求
function GuildDataMgr:SendChangeMemberTitleReq(uid, post)
    if not self:IsCanSend(17) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CHANGE_MEMBER_TITLE_REQ, {uid = uid, title = post})
    return true
end

--- 发送踢出公会请求
function GuildDataMgr:SendKickGuildMemeberReq(uid)
    if not self:IsCanSend(18) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_KICK_GUILD_MEMBER_REQ, {uid = uid})
    return true
end





function GuildDataMgr:SendGuildHuntBossListInfoReq()
    if not self:IsCanSend(19) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BOSS_INFO_REQ)
    return true
end

function GuildDataMgr:SendGuildHuntBossLogReq(bossId, logTime)
    if not self:IsCanSend(20) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BOSS_LOG_REQ, { boss_id = bossId, log_time = logTime })
    return true
end

function GuildDataMgr:SendGuildHuntBossChallengeReq(bossId, damage, battleTime)
    if not self:IsCanSend(21) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BOSS_CHALLENGE_REQ, { boss_id = bossId, damage = damage, battle_time = battleTime })
    return true
end

function GuildDataMgr:SendGuildHuntBossSummonReq(bossId)
    if not self:IsCanSend(22) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BOSS_SUMMON_REQ, { boss_id = bossId })
    return true
end

function GuildDataMgr:SendGuildMasterRewardReq(bossId)
    if not self:IsCanSend(23) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BOSS_EXTRA_REWARD_REQ, { boss_id = bossId })
    return true
end


























function GuildDataMgr:GetRecommendGuildDatas()
    return self.recommendGuildDatas
end

--- 由于除了推荐界面，其它地方不使用该数据，所以会清理数据
function GuildDataMgr:ClearRecommendGuildDatas()
    self.recommendGuildDatas = nil
end

function GuildDataMgr:GetSearchGuildDatas()
    return self.searchGuildDatas
end

function GuildDataMgr:ResetSearchGuildDatas(searchString)
    self.searchGuildDatas = {}
    self.searchString = searchString
end

--- 由于除了推荐界面，其它地方不使用该数据，所以会清理数据
function GuildDataMgr:ClearSearchGuildDatas()
    self.searchGuildDatas = nil
    self.searchString = nil
end




--- 获得当前公会数据的状态
---@return Enum.GuildDataState
function GuildDataMgr:GetGuildDataState()
    if self.curGuildData == nil then
        return Enum.GuildDataState.NoData
    end
    if self.curGuildData:GetBriefData() then
        return Enum.GuildDataState.HasGuild
    end
    return Enum.GuildDataState.NoGuild
end

function GuildDataMgr:GetGuildDataStateErrorCode()
    if self.curGuildData == nil then
        return 'GuildTips_037'
    end
    if self.curGuildData:GetBriefData() then
        return nil
    end
    return 'GuildTips_037'
end


--- 是否有公会
function GuildDataMgr:HasGuild()
    return self:GetGuildDataState() == Enum.GuildDataState.HasGuild
end

function GuildDataMgr:GetCurGuildData()
    return self.curGuildData
end

function GuildDataMgr:GetCheckGuildData()
    return self.checkGuildData
end

function GuildDataMgr:ClearCheckGuildData()
    self.checkGuildData = nil
end







-----------------------------  公会狩猎 -----------------------------

function GuildDataMgr:StartGuildHuntBattle(bossId)
    local huntBattleInfo = self.huntBattleInfo
    if huntBattleInfo and huntBattleInfo.isBattling then
        return
    end
    local bossCfgData = ManagerContainer.CfgMgr:GetGuildHuntBossCfgById(bossId)
    if not bossCfgData then return end
    if not huntBattleInfo then
        huntBattleInfo = {}
        self.huntBattleInfo = huntBattleInfo
    end
    huntBattleInfo.bossId = bossId
    huntBattleInfo.hurtValue = 0

    local teams = ManagerContainer.DataMgr.UserData:GetTeamData(true)
    local ourActors = System.Array.CreateInstance(Enum.TypeInfo.ActorData, #teams)
    for i = 1 , #teams do
        local actor = ManagerContainer.LuaActorDataMgr:GetActorsById(teams[i].uid,teams[i].id)
         --增加对应压制mark
         ManagerContainer.DataMgr.UserData:SetActorPveMark(teams[i].uid,actor)
        ourActors[i - 1] = actor
    end

    local enemyActors = System.Array.CreateInstance(Enum.TypeInfo.ActorData, 1)
    local npcId = bossCfgData.SummonId
    local npcCfgData = ManagerContainer.CfgMgr:GetNpcCfgById(npcId)
    local actor = ManagerContainer.LuaActorDataMgr:CreateNpc(10001, npcId, 1, npcCfgData.BaseLv)
    actor.IsBoss = (npcCfgData.NpcType == 2)
    actor.IgnoreLife = true
    enemyActors[0] = actor


    local battleEndCondList = System.Array.CreateInstance(Enum.TypeInfo.BattleEndCondition, 3)
    battleEndCondList[0] = BattleEndCondition.New(Constants.EndBattle_By_UndeadCount,Constants.ResultType_Normal)
    battleEndCondList[1] = BattleEndCondition.New(Constants.EndBattle_By_BattleTime,bossCfgData.BattleTime,Constants.ResultType_Special,true)
    battleEndCondList[2] = BattleEndCondition.New(Constants.EndBattle_By_TeamTotalDamage,bossCfgData.EndBattleDamage,Constants.ResultType_Special,true)

    ManagerContainer.LuaGameMgr:EnterGuildHuntBattle(bossCfgData.SummonScence, nil, bossCfgData.BattleTime, ourActors, enemyActors, battleEndCondList)
end

function GuildDataMgr:StopGuildHuntBattle(isPlayRecord, battleTime)
    if isPlayRecord then
        self:ExitHuntBattle()
        return
    end
    if self.huntBattleInfo then
        if self.huntBattleInfo.timeOut then
            self.huntBattleInfo.timeOut:Stop()
            self.huntBattleInfo.timeOut = nil
        end
        self.huntBattleInfo.timeOut = Timer.New(function()
            self:ExitHuntBattle()
        end, 10)
        self.huntBattleInfo.timeOut:Start()
    end
    local bossId = self:GetHuntBattleBossId()
    local bossCfgData = ManagerContainer.CfgMgr:GetGuildHuntBossCfgById(bossId)
    local hurtValue = Mathf.Floor(self:GetRecordHurtValue())
    if bossCfgData then
        if hurtValue > bossCfgData.EndBattleDamage then
            hurtValue = bossCfgData.EndBattleDamage
        end
    end
    self:SendGuildHuntBossChallengeReq(bossId, hurtValue, Mathf.Round(battleTime))
end

function GuildDataMgr:DisposeGuildHuntBattle()
    if self.huntBattleInfo and self.huntBattleInfo.timeOut then
        self.huntBattleInfo.timeOut:Stop()
        self.huntBattleInfo.timeOut = nil
    end
    self.huntBattleInfo = nil
end

function GuildDataMgr:RecordHurtValueChanged(hurtValue)
    if not hurtValue or hurtValue <= 0 then return end
    if not self.huntBattleInfo then return end
    self.huntBattleInfo.hurtValue = self.huntBattleInfo.hurtValue + hurtValue
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_HUNT_BOSS_HURT_CHANGED)
end

function GuildDataMgr:GetRecordHurtValue()
    if not self.huntBattleInfo then return 0 end
    return self.huntBattleInfo.hurtValue or 0
end

function GuildDataMgr:GetHuntBattleBossId()
    if not self.huntBattleInfo then return nil end
    return self.huntBattleInfo.bossId
end

function GuildDataMgr:OpenHuntBattleRewardView()
    if self.huntBattleInfo and self.huntBattleInfo.timeOut then
        self.huntBattleInfo.timeOut:Stop()
        self.huntBattleInfo.timeOut = nil
    end
    local rewards = self.huntBattleInfo and self.huntBattleInfo.rewards or {}
    local data = require('ExecuteSequenceData'):new()
    data:AppendUIListener(Enum.UIPageName.UIPOPGot, UIEventNames.UI_FILLCONTENT_COMPELETED, 5)
    data:AppendFuncAfterListener(false,  ManagerContainer.LuaUIMgr,  ManagerContainer.LuaUIMgr.Open, Enum.UIPageName.UIPOPGot, {rewards = rewards})
    data:AppendUIListener(Enum.UIPageName.UIPOPGot, UIEventNames.UI_PAGE_OUT_END_NTF)
    data:AppendFunc(true, self, self.ExitHuntBattle)
    ManagerContainer.ExecuteSequenceMgr:Execute(data)
end

function GuildDataMgr:ExitHuntBattle()
    if self:HasGuild() then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildHunt, self:GetHuntBattleBossId(), Enum.UIPageName.UIMainCity1)
    else
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIMainCity1, nil, false)
        if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIMain) then
            ManagerContainer.LuaUIMgr:Back2NormalBattleMain(Enum.MainViewPageType.Town)
        end
    end
    self:DisposeGuildHuntBattle()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE)
end



return GuildDataMgr