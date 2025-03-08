local IdolData = class("IdolData", require("DataBase"))
local BitUtil = require("BitUtil")

local PlayerInfoReqLimit = 10
local PlayerInfoMaxLimit = 50
local hotValShowLimit = 0
local ProtocalDataNormal = require("ProtocalDataNormal")
function IdolData:ctor()
    PlayerInfoMaxLimit = GlobalConfig.Instance:GetConfigIntValue(343) or 50
    hotValShowLimit    = GlobalConfig.Instance:GetConfigIntValue(345) or 0
    self.feedbackRP = false
    self.showDataList = {}
    self.idolRankInfo = {}
    self.idolRankLength = 0
    self.idolFansLength = 0
    self.idolFansInfo = {}
    self.fansRewardInfo = {}
    self.RankInfoReqLimit = PlayerInfoMaxLimit
    self.FansInfoReqLimit = PlayerInfoMaxLimit
    self.rankListReqPage = 1
    self.rewardRankListReqPage = 1
end

function IdolData:ClearIdolRankInfos()
    self.idolRankInfo = nil
    self.rankList = nil
    self.rankListReqPage = 1
end

function IdolData:ClearIdolFansRankInfos()
    self.rewardRankList = nil
    self.fansRewardInfo = nil
    self.idolFansInfo = nil
    self.rewardRankListReqPage = 1
end

function IdolData:ClearTempPlayerBirefInfos()
    self.tempPlayerBirefInfos = nil
end

function IdolData:InitRewardData(data)
    self.showDataList = self:InitDetailData(data.detail_list,data.vote_list)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_RANK_MODEL_INFO)
    local rewards = data.day_reward or {}
    local firstState = false
    local secondState = false
    for i = 1, #rewards do
        if rewards[i] == 1 then
            firstState = true
        elseif rewards[i] == 2 then
            secondState = true
        end
    end
    self.TimeList = {{data.first_begin,data.first_end,firstState},{data.second_begin,data.second_end,secondState}}
    self.feedbackRP = data.has_box_reward
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_DAYS_REWARD_INFO)
end

function IdolData:InitDetailData(detail_list,vote_list)
    local list = {}
    if detail_list and vote_list then
        local showList = {}
        local uids = {}
        for i = 1, #detail_list do
            if not showList[detail_list[i].uid] then
                showList[detail_list[i].uid] = {}
            end
            local roleBase = detail_list[i].role_base
            local heroData = roleBase.role_data.hero_data
            showList[detail_list[i].uid].roleCfgId = CommonUtil.JobIdToRoleId(heroData.config_id, roleBase.sex)
            showList[detail_list[i].uid].viewData = ProtocalDataNormal.FashionDataToViewData(roleBase.fashion_data)
            local extGoesShowData = {}
            if heroData.skill_equip_slot and heroData.skill_equip_slot.slot_list then
                local curSkillEquipData = heroData.skill_equip_slot.slot_list[1]
                if curSkillEquipData then
                    extGoesShowData[Enum.HeroExtGoesShowType.God_Art] = curSkillEquipData.skill_equip_config_id
                end
            end
            showList[detail_list[i].uid].extGoesShowData = extGoesShowData
            showList[detail_list[i].uid].nickName = CommonUtil.GetVaildNickName(roleBase.nick_name)
            table.insert(uids,detail_list[i].uid)
        end
        local selfUid = ManagerContainer.DataMgr.UserData:GetUserId()
        for i = 1, #vote_list do
            if not showList[vote_list[i].uid] then
                showList[vote_list[i].uid] = {}
            end
            showList[vote_list[i].uid].vote_list = vote_list[i]
            if vote_list[i].uid == selfUid then
                ManagerContainer.DataMgr.CompetitionData:SetRankAndScore(vote_list[i])
            end
        end
        for k, v in pairs(showList) do
            table.insert(list,v)
        end
        table.sort(list,function(a, b)
            return a.vote_list.rank < b.vote_list.rank
        end)
        self.isCanSendInfoReq = true
        self:SendIdolInfoReq(Enum.FriendTogglePageType.TempPlayerBirefInfos,uids)
    end
    return list
end

function IdolData:OnGetPlayerVoteInfoAck(data)
    if data.error == 0 then
        if data.idol_rank_data and self.VoteInfoUid and data.idol_rank_data.uid == self.VoteInfoUid then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_SUPPORTTIPSVIEW,data.idol_rank_data)
        end
    end
end

function IdolData:ClearVoteInfoUid()
    self.VoteInfoUid = nil
end

function IdolData:GetVoteInfoUid()
    return self.VoteInfoUid
end

function IdolData:OnSureSupport(logicData)	--确认投票
	local num = logicData[1]
	local uid = logicData[2]
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_ON_VOTE_REQ, { ticket_count = num,uid = uid})
end

function IdolData:RegisterNetEvents()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.IDOL_GET_OTHER_PLAYER_BRIEF_INFO_ACK,self,self.OnIdolPlayerBriefInfoAck)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMPETITION_FANS_DAY_REWARD_ACK, self.OnDayRewardAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMPETITION_SELF_FANS_INFO_ACK, self.OnSelfFansInfoAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMPETITION_VOTE_RANK_ACK, self.OnVoteRankAck,self) 
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMPETITION_FANS_REWARD_RANK_ACK, self.OnFansRewardRankAck,self) 
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMPETITION_FANS_GET_REWARD_ACK, self.OnGetFansRewardAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMPETITION_ON_VOTE_ACK, self.OnVoteAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMPETITION_GET_PLAYER_VOTE_RANK_ACK, self.OnGetPlayerVoteInfoAck,self)
end

function IdolData:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_COMPETITION_FANS_DAY_REWARD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_COMPETITION_SELF_FANS_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_COMPETITION_VOTE_RANK_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_COMPETITION_FANS_REWARD_RANK_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_COMPETITION_FANS_GET_REWARD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_COMPETITION_ON_VOTE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_COMPETITION_GET_PLAYER_VOTE_RANK_ACK)
end

function IdolData:OnVoteAck(data)
    if data.error == 0 then
        if data.detail and #data.detail > 0 and data.vote_list and #data.vote_list > 0 then
            self.showDataList = self:InitDetailData(data.detail,data.vote_list)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_RANK_MODEL_INFO)
        end
        local selfUid = ManagerContainer.DataMgr.UserData:GetUserId()
        if data.vote_target.uid == selfUid then
            ManagerContainer.DataMgr.CompetitionData:SetRankAndScore(data.vote_target)
        end
        if data.vote_target.rank > 0 and self.rankList then
            local index = nil
            for i = 1, #self.rankList do
                if self.rankList[i].uid == data.vote_target.uid then
                    index = i
                    break
                end
            end
            if index then
                table.remove(self.rankList,index)
            end
            if  data.vote_target.rank <= #self.rankList then
                table.insert(self.rankList, data.vote_target.rank, data.vote_target)
            else
                table.insert(self.rankList,data.vote_target)
            end
            for i = 1, #self.rankList do
                self.rankList[i].rank = i
                if self.rankList[i].uid == selfUid then
                    ManagerContainer.DataMgr.CompetitionData:SetRankAndScore(self.rankList[i])
                end
            end
        end
        local limti = self:GetRankInfoLimit()
        if self.rankList and #self.rankList > limti then
            for i = limti + 1, #self.rankList do
                table.remove(self.rankList,i)
            end
        end
        local rewardData = data.reward_data
        if self.fansRewardInfo and rewardData and #rewardData > 0 then
            for i = 1, #rewardData do
                if not self.fansRewardInfo[rewardData[i].key] then
                    self.fansRewardInfo[rewardData[i].key] = {}
                end
                self.fansRewardInfo[rewardData[i].key].hotVal = rewardData[i].value
                local rewardState = {}
                local val  = rewardData[i].value2
                local len = ManagerContainer.CfgMgr:GetAidouluCfgLength()
                for i = 1, len do
                    rewardState[i] = BitUtil.RshiftNumBandOne(val, i - 1) == 1
                end
                self.fansRewardInfo[rewardData[i].key].rewardState = rewardState
            end
        end
        local currTicket = data.ticket_count

        if currTicket > 0 and currTicket < hotValShowLimit then
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("SupportSucessTips")
        else
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.IdolSuccessTips)
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_VOTE_VIEW_INFO)
    end
end

function IdolData:OnVoteRankAck(data)
    if data.error == 0 then
        if not self.rankList then 
            self.rankList = {}
        end
        local rankList = data.rank_data
        local uids = {}
        for i = 1, #rankList do
            table.insert(self.rankList,rankList[i])
            table.insert(uids,rankList[i].uid)
        end
        self.rankListReqPage = self.rankListReqPage + 1
        if data.is_end then
            self.RankInfoReqLimit = self.rankList and #self.rankList or 0
            if data.page == 1 then
                --通知排行界面改变
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_IDOL_RANK_PLAYER_RANK_INFO) 
            end
        end
        self.isCanSendInfoReq = true
        self:SendIdolInfoReq(Enum.FriendTogglePageType.IdolRankInfo,uids)
    end
end

function IdolData:OnFansRewardRankAck(data)
    if data.error == 0 then
        if not self.rewardRankList then 
            self.rewardRankList = {}
            self.rewardRankListReqPage = 1
        end
        if data.page == 1 and data.reward_data then
           if not self.fansRewardInfo then
                self.fansRewardInfo = {}
           end
           local info = self.fansRewardInfo
           local rewardData = data.reward_data 
           if rewardData and #rewardData > 0 then
            for i = 1, #rewardData do
                if not info[rewardData[i].key] then
                    info[rewardData[i].key] = {}
                end
                info[rewardData[i].key].hotVal = rewardData[i].value
                local rewardState = {}
                local val  = rewardData[i].value2
                local len = ManagerContainer.CfgMgr:GetAidouluCfgLength()
                for i = 1, len do
                    rewardState[i] = BitUtil.RshiftNumBandOne(val, i - 1) == 1
                end
                info[rewardData[i].key].rewardState = rewardState
            end
        end
        end
        local rankList = data.data_list
        local uids = {}
        for i = 1, #rankList do
            table.insert(self.rewardRankList,rankList[i])
            table.insert(uids,rankList[i].uid)
        end
        self.rewardRankListReqPage = self.rewardRankListReqPage + 1
        if data.is_end then
            self.FansInfoReqLimit = self.rewardRankList and #self.rewardRankList or 0
            if data.page == 1 then
                --通知回馈界面改变
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_IDOL_FANS_PLAYER_RANK_INFO)
            end
        end
        self.isCanSendInfoReq = true
        self:SendIdolInfoReq(Enum.FriendTogglePageType.IdolFansInfo,uids)
    end
end

function IdolData:OnGetFansRewardAck(data)
    if data.error == 0 then
        if self.fansRewardInfo then
                if self.fansRewardInfo[data.uid] then
                    local rewardState = {}
                    local val  = data.reward_flag
                    local len = ManagerContainer.CfgMgr:GetAidouluCfgLength()
                    for i = 1, len do
                        rewardState[i] = BitUtil.RshiftNumBandOne(val, i - 1) == 1
                    end
                    self.fansRewardInfo[data.uid].rewardState = rewardState
                    if data.reward_list and #data.reward_list > 0 then
                        local rewards = {}
                        for key, value in pairs(data.reward_list) do
                            table.insert(rewards,{cfgId = value.key, num = value.value})
                        end
                        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot,{rewards = rewards})
                    end
                    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_FASN_REWARD_INFO) 
                end
        end
    end
end

--粉丝排行票数请求
function IdolData:SendGetPlayerVoteRankReq(uid)
    self.VoteInfoUid = uid
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_GET_PLAYER_VOTE_RANK_REQ, {uid = uid})
end
--粉丝领回馈请求
function IdolData:SendFansGetRewardReq(uid)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_FANS_GET_REWARD_REQ, {uid = uid})
end
    
--粉丝得票排行请求
function IdolData:SendGetVoteRankInfoReq()
    if not self.rankListReqPage then
        self.rankListReqPage = 1
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_VOTE_RANK_REQ, {page = self.rankListReqPage})
end

--回馈宝箱数据请求
function IdolData:SendGetGiftRankInfoReq()
    if not self.rewardRankListReqPage then
        self.rewardRankListReqPage = 1
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_FANS_REWARD_RANK_REQ, {page = self.rewardRankListReqPage})
end

--获取自己粉丝数据请求
function IdolData:SendGetSelfFansInfoReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_SELF_FANS_INFO_REQ)
end

--分批请求玩家数据
function IdolData:SendIdolInfoReq(type,uids)
    if self.isCanSendInfoReq then
        self.isCanSendInfoReq = false
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_OTHER_PLAYER_BRIEF_INFO_REQ, {type = type,player_list=uids})
    end
end

function IdolData:OnSelfFansInfoAck(data)
    if data.error == 0 then
        self.fansVoteList = data.fan_list
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_IDOL_MYFANS_INFO) 
    end
end

function IdolData:OnDayRewardAck(data)
    if data.error == 0 then
        if self.TimeList and self.TimeList[data.id] then
            self.TimeList[data.id][3] = true
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_DAYS_REWARD_INFO) 
    end
end

function IdolData:OnIdolPlayerBriefInfoAck(data)
    self.isCanSendInfoReq = true
    if not data  then
        return
    end
    if data.type == Enum.FriendTogglePageType.IdolRankInfo then
        if not self.idolRankInfo then
            self.idolRankInfo = {}
            self.idolRankLength = 0
        end
        local brief_info = data.brief_info
        if brief_info and #brief_info > 0 then
            local list = self.idolRankInfo
            for i = 1, #brief_info do
                local info = brief_info[i]
                if not list[info.uid] then
                    self.idolRankLength = self.idolRankLength + 1
                end
                list[info.uid] = info
            end
        end
        --通知排行界面改变
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_IDOL_RANK_PLAYER_RANK_INFO) 
    elseif data.type == Enum.FriendTogglePageType.IdolFansInfo then
        if not self.idolFansInfo then
            self.idolFansInfo = {}
            self.idolFansLength = 0
        end
        local brief_info = data.brief_info
        if brief_info and #brief_info > 0 then
            local list =  self.idolFansInfo
            for i = 1, #brief_info do
                local info = brief_info[i]
                if not list[info.uid] then
                    self.idolFansLength = self.idolFansLength + 1
                end
                list[info.uid] = info
            end
        end
        --通知回馈界面改变
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_IDOL_FANS_PLAYER_RANK_INFO)
    elseif data.type ==  Enum.FriendTogglePageType.TempPlayerBirefInfos then
        if not self.tempPlayerBirefInfos then
            self.tempPlayerBirefInfos = {}
        end
        local brief_info = data.brief_info
        if brief_info and #brief_info > 0 then
            local list =  self.tempPlayerBirefInfos
            for i = 1, #brief_info do
                local info = brief_info[i]
                list[info.uid] = info
            end
        end
    end
end

function IdolData:GetRankInfoLimit()
    return self.RankInfoReqLimit or PlayerInfoMaxLimit
end

function IdolData:GetGiftInfoLimit()
    return self.FansInfoReqLimit or PlayerInfoMaxLimit
end

function IdolData:GetIdolGiftInfos()
    return self.rewardRankList or {}
end

function IdolData:GetRankInfosLength()
    return self.idolRankLength or 0
end

function IdolData:GetGiftInfosLength()
    return self.idolFansLength or 0
end

function IdolData:GetMyFansData()
    return self.fansVoteList or {}
end

function IdolData:GetRankInfoData()
    local tab = {}
    if self.rankList and #self.rankList > 0 then
        for i = 1, #self.rankList do
            table.insert(tab,self.rankList[i])
        end
    end
    return tab
end

function IdolData:GetRedState()
    return self.feedbackRP or false
end

function IdolData:SetRedState(flag)
    self.feedbackRP = flag
end

function IdolData:GetRewardsTimeList()
    return self.TimeList or nil
end

function IdolData:GetFansInfoLimit()
    return self.FansInfoReqLimit or 0
end

function IdolData:GetShowDataList()
    return  self.showDataList or {}
end

function IdolData:GetFansRewardInfoByUid(uid)
    return self.fansRewardInfo and self.fansRewardInfo[uid]
end

function IdolData:GetPlayerBriefInfoByUid(uid)
    if self.idolRankInfo and self.idolRankInfo[uid] then
        return self.idolRankInfo and self.idolRankInfo[uid]
    end
    if self.idolFansInfo and self.idolFansInfo[uid] then
        return self.idolFansInfo and self.idolFansInfo[uid]
    end
    if self.tempPlayerBirefInfos and self.tempPlayerBirefInfos[uid] then
        return self.tempPlayerBirefInfos and self.tempPlayerBirefInfos[uid]
    end
    return nil
end

function IdolData:Clear()
    self.feedbackRP = nil
    self.showDataList = nil
    self.idolRankInfo = nil
    self.idolRankLength = nil
    self.idolFansLength = nil
    self.idolFansInfo = nil
    self.RankInfoReqLimit = nil
    self.FansInfoReqLimit = nil
    self.rankListReqPage = nil
    self.rewardRankListReqPage = nil
end

function IdolData:Destroy()
    if self.Clear then
        self:Clear()
    end
    self:UnRegisterNetEvents()
end


return IdolData