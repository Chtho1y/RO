local PetRankActivityData = class("PetRankActivityData")
local ProtocalDataNormal = require("ProtocalDataNormal")

local countlimit = 10
function PetRankActivityData:ctor()
    self.rankData = nil
    self.type = Enum.RankActivitiesType.Pet
end

function PetRankActivityData:Clear()
    self.rankData = nil
end

function PetRankActivityData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_ACTIVITY_ACK,self.OnPetActivityAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_ACTIVITY_RANK_ACK,self.QueryPetRankDatasAck, self)
end

function PetRankActivityData:QueryRankActivityData(forceOpenUI)
    self.forceOpenUI = forceOpenUI
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_ACTIVITY_REQ, {})
end

function PetRankActivityData:OnPetActivityAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end
    -- LogHRWarning(Inspect(data))
    local oldData = clone(self.rankData)
    self.rankData = ProtocalDataNormal.ParsePetActivityData(data)

    if oldData then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetRankChanged, oldData.selfRank ~= self.rankData.selfRank)
    end

    self:RefreshRewardRPStatae()
    if self.forceOpenUI then
        --TODO 打开 冲榜界面
        if self.rankData.endTime > 0 then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIActivityTower, Enum.RankActivitiesType.Pet)
            self.forceOpenUI = false
        else
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RANK_ACTIVITY_DISPLAY_NTF, Enum.RankActivitiesType.Pet, false)
        end
    end
end

function PetRankActivityData:RefreshRewardRPStatae()
    local type = Enum.RankActivitiesType.Pet
    local idx = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityIdx(type)
    local cfgDatas = ManagerContainer.CfgMgr:GetRushListCfgByTypeAndIdx(type, idx)
    if not cfgDatas then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.TowerRankCanReward, false)
        return
    end
    local cfgDatas = ManagerContainer.CfgMgr:GetRushListTargetCfgByTypeAndIdx(type,idx)
    countlimit = cfgDatas[1].Rank[1][1]

    local stage, endTime = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityStageEndTime(Enum.RankActivitiesType.Pet)
    local rankRewardState = stage == 2 and self.rankData.selfRank > 0 and not self.rankData.rankReward
    local challengeRewardState = self.rankData.selfScore >= countlimit and not self.rankData.challengReward
    ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetRankCanReward, rankRewardState or challengeRewardState)
end

function PetRankActivityData:OnActivityRewardAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end

    if data.reward_type == 1 then
        self.rankData.challengReward = true
    elseif data.reward_type == 2 then
        self.rankData.rankReward = true
    end
    self:RefreshRewardRPStatae()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RANK_ACTIVITY_REWARD_SUCCESS_NTF, data.reward_type)

    CommonUtil.ACKShowRewardList(data.item_list)
end

function PetRankActivityData:GetCurRankActivityData()
    return self.rankData
end

function PetRankActivityData:SendRewardReq(type)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_RUSH_ACTIVITY_REWARD_REQ, {reward_type = type, rush_type = self.type})
end

function PetRankActivityData:QueryPetRankDatas(page)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_ACTIVITY_RANK_REQ, {page = page})
end

function PetRankActivityData:QueryPetRankDatasAck(data)
    -- LogHRWarning(Inspect(data))
    if data.error ~= Enum.NetErrorCode.ERROR_OK then
        return
    end

    if not self.rankData then return end

    if data.top_data then
        for i = 1,#data.top_data do
            local data1 = {}
            data1.name = data.top_data[i].name
            data1.totalScore = data.top_data[i].total_score
            data1.info = ProtocalDataNormal.ParseRushPetInfoData(data.top_data[i].pet_info.info)
            data1.rank = data.top_data[i].rank
            self.rankData.topData[data1.rank] = data1
        end
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_RANK_QUERY_ACK_REFRESH)
end

function PetRankActivityData:Destroy()
    self:Clear()
end

return PetRankActivityData