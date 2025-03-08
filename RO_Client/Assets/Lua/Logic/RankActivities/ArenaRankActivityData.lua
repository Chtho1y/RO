local ArenaRankActivityData = class("ArenaRankActivityData")
local ProtocalDataNormal = require("ProtocalDataNormal")

local countlimit = 10
function ArenaRankActivityData:ctor()
    self.rankData = nil
    self.type = Enum.RankActivitiesType.Dojo
end

function ArenaRankActivityData:Clear()
    self.rankData = nil
end

function ArenaRankActivityData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ARENA_ACTIVITY_ACK,self.OnArenaActivityAck, self)
end

function ArenaRankActivityData:QueryRankActivityData(forceOpenUI)
    self.forceOpenUI = forceOpenUI
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ARENA_ACTIVITY_REQ, {})
end

function ArenaRankActivityData:OnArenaActivityAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end

    local oldData = clone(self.rankData)
    self.rankData = ProtocalDataNormal.ParseArenaActivityData(data)
    self.rankData.rankIdx = self:GetRankIdx(self.rankData.selfRank)

    if oldData then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.ArenaRankChanged, oldData.rankIdx ~= self.rankData.rankIdx)
    end

    self:RefreshRewardRPStatae()
    if self.forceOpenUI then
        --TODO 打开 冲榜界面
        if self.rankData.endTime > 0 then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIActivityTower, Enum.RankActivitiesType.Dojo)
            self.forceOpenUI = false
        else
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RANK_ACTIVITY_DISPLAY_NTF, Enum.RankActivitiesType.Dojo, false)
        end
    end
end

function ArenaRankActivityData:GetRankIdx(rank)
    local type = Enum.RankActivitiesType.ClimbingTower
    local idx = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityIdx(type)
    local cfgDatas = ManagerContainer.CfgMgr:GetRushListCfgByTypeAndIdx(type, idx)
    if not cfgDatas then
        return 0
    end
    local cfgDatas = ManagerContainer.CfgMgr:GetRushListTargetCfgByTypeAndIdx(type,idx)

    local rankIdx = 0
    if rank > 0 then
        for i = #cfgDatas, 1, -1 do
            local cfgData = cfgDatas[i]
            if rank <= cfgData.Rank[1][2] then
                rankIdx = cfgData.RankGrade
            end
        end
    end
    return rankIdx
end

function ArenaRankActivityData:RefreshRewardRPStatae()
    local type = Enum.RankActivitiesType.Dojo
    local idx = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityIdx(type)
    local cfgDatas = ManagerContainer.CfgMgr:GetRushListCfgByTypeAndIdx(type, idx)
    if not cfgDatas then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.TowerRankCanReward, false)
        return
    end

    local RewardCountcfgDatas = ManagerContainer.CfgMgr:GetRushListTargetCfgByTypeAndIdx(type,idx)
    countlimit = RewardCountcfgDatas[1].Rank[1][1]

    local rankIdx = 0
    if self.rankData.selfRank > 0 then
        for i = #cfgDatas, 1, -1 do
            local cfgData = cfgDatas[i]
            if self.rankData.selfRank <= cfgData.Rank[1][2] then
                rankIdx = cfgData.RankGrade
            end
        end
    end

    local stage, endTime = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityStageEndTime(Enum.RankActivitiesType.Dojo)
    local rankRewardState = rankIdx > 0 and stage == 2 and self.rankData.selfRank > 0 and not self.rankData.rankReward
    local challengeRewardState = self.rankData.fightCount >= countlimit and not self.rankData.challengReward
    ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.ArenaRankCanReward, rankRewardState or challengeRewardState)
end

function ArenaRankActivityData:OnActivityRewardAck(data)
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

function ArenaRankActivityData:GetCurRankActivityData()
    return self.rankData
end

function ArenaRankActivityData:SendRewardReq(type)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_RUSH_ACTIVITY_REWARD_REQ, {reward_type = type, rush_type = self.type})
end

function ArenaRankActivityData:Destroy()
    self:Clear()
end

return ArenaRankActivityData