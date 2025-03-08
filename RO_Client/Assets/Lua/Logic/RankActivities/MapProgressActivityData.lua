local MapProgressActivityData = class("MapProgressActivityData")
local ProtocalDataNormal = require("ProtocalDataNormal")

function MapProgressActivityData:ctor()
    self.rankData = nil
    self.type = Enum.RankActivitiesType.MapProgress
end

function MapProgressActivityData:Clear()
    self.rankData = nil
end

function MapProgressActivityData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_MAP_ACTIVITY_ACK,self.OnMapActivityAck, self)
end

function MapProgressActivityData:QueryRankActivityData(forceOpenUI)
    self.forceOpenUI = forceOpenUI
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_MAP_ACTIVITY_REQ, {})
end

function MapProgressActivityData:OnMapActivityAck(data)
    --data = {}
    --data.error = 0
    --data.map_score = 100
    --data.self_rank = 10
    --data.self_level = 100
    --data.end_time = 0
    --data.challeng_reward = false
    --data.rank_reward = false

    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end

    local oldData = clone(self.rankData)
    self.rankData = ProtocalDataNormal.ParseTowerActivityData(data)
    self.rankData.mapScore = data.map_score
    self.rankData.bagScore = data.bag_score
    self.rankData.rankIdx = self:GetRankIdx(self.rankData.selfRank)

    if oldData then
        local needRp = false
        local type = Enum.RankActivitiesType.MapProgress
        local idx = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityIdx(type)
        local taskCfgDatas = ManagerContainer.CfgMgr:GetRushListTargetCfgByTypeAndIdx(type, idx)
        for i = #taskCfgDatas, 1, -1 do
            local cfgData = taskCfgDatas[i]
            if oldData.rushLevel < cfgData.Rank[1][1] and self.rankData.rushLevel >= cfgData.Rank[1][1] then
                if cfgData.Rank[1][2] == 0 or self.rankData.rushLevel <= cfgData.Rank[1][2] then
                    needRp = true
                    break
                end
            end
        end
        if not ManagerContainer.RedPointSimpleMgr:CheckRPStateByType(Enum.RPNotifyType.MapRankChanged) then
            ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.MapRankChanged, needRp or (self.rankData.rankIdx ~= oldData.rankIdx))
        end
    end

    self:RefreshRewardRPStatae()
    if self.forceOpenUI then
        --TODO 打开 冲榜界面
        if self.rankData.endTime > 0 then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIActivityTower, Enum.RankActivitiesType.MapProgress)
            self.forceOpenUI = false
        else
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RANK_ACTIVITY_DISPLAY_NTF, Enum.RankActivitiesType.MapProgress, false)
        end
    end
end

function MapProgressActivityData:GetRankIdx(rank)
    local type = Enum.RankActivitiesType.MapProgress
    local idx = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityIdx(type)

    local taskCfgDatas = ManagerContainer.CfgMgr:GetRushListTargetCfgByTypeAndIdx(type, idx)
    local cfgDatas = ManagerContainer.CfgMgr:GetRushListCfgByTypeAndIdx(type, idx)
    if not taskCfgDatas and not cfgDatas then
        return 0
    end

    local rankIdx = 0
    if rank > 0 then
        for i = #cfgDatas, 1, -1 do
            local cfgData = cfgDatas[i]
            if cfgData.Rank[1][2] == 0 then
                rankIdx = cfgData.RankGrade
            elseif rank <= cfgData.Rank[1][2] then
                rankIdx = cfgData.RankGrade
            end
        end
    end
    return rankIdx
end

function MapProgressActivityData:RefreshRewardRPStatae()
    local type = Enum.RankActivitiesType.MapProgress
    local idx = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityIdx(type)

    local taskCfgDatas = ManagerContainer.CfgMgr:GetRushListTargetCfgByTypeAndIdx(type, idx)
    local cfgDatas = ManagerContainer.CfgMgr:GetRushListCfgByTypeAndIdx(type, idx)
    if not taskCfgDatas and not cfgDatas then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.MapRankCanReward, false)
        return
    end
    local stage, endTime = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityStageEndTime(Enum.RankActivitiesType.MapProgress)

    local rankIdx = 0
    if self.rankData.selfRank > 0 then
        for i = #cfgDatas, 1, -1 do
            local cfgData = cfgDatas[i]
            if cfgData.Rank[1][2] == 0 then
                rankIdx = cfgData.RankGrade
            elseif self.rankData.selfRank <= cfgData.Rank[1][2] then
                rankIdx = cfgData.RankGrade
            end
        end
    end
    local rankRewardState = rankIdx > 0 and stage == 2 and self.rankData.selfRank > 0 and not self.rankData.rankReward

    local rankIdx = 0
    for i = #taskCfgDatas, 1, -1 do
        local cfgData = taskCfgDatas[i]
        if self.rankData.rushLevel >= cfgData.Rank[1][1] then
            if cfgData.Rank[1][2] == 0 or self.rankData.rushLevel <= cfgData.Rank[1][2] then
                rankIdx = cfgData.TargetGrade
            end
        end
    end
    local challengeRewardState = rankIdx > 0 and stage == 2 and not self.rankData.challengReward

    ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.MapRankCanReward, rankRewardState or challengeRewardState)
end

function MapProgressActivityData:OnActivityRewardAck(data)
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

function MapProgressActivityData:GetCurRankActivityData()
    return self.rankData
end

function MapProgressActivityData:SendRewardReq(type)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_RUSH_ACTIVITY_REWARD_REQ, {reward_type = type, rush_type = self.type})
end

function MapProgressActivityData:Destroy()
    self:Clear()
end

return MapProgressActivityData