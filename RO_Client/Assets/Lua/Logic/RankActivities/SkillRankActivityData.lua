local SkillRankActivityData = class("SkillRankActivityData")
local ProtocalDataNormal = require("ProtocalDataNormal")

local countlimit = 10
function SkillRankActivityData:ctor()
    self.rankData = nil
    self.type = Enum.RankActivitiesType.Skill
end

function SkillRankActivityData:Clear()
    self.rankData = nil
end

function SkillRankActivityData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_RUSH_ACTIVITY_ACK,self.OnSkillActivityAck, self)
end

function SkillRankActivityData:QueryRankActivityData(forceOpenUI)
    self.forceOpenUI = forceOpenUI
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_RUSH_ACTIVITY_REQ, {rush_type = self.type})
end

function SkillRankActivityData:OnSkillActivityAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end
    -- LogHRWarning(Inspect(data))
    self.rankData = ProtocalDataNormal.ParseSkillActivityData(data)

    self:RefreshRewardRPStatae()
    if self.forceOpenUI then
        --TODO 打开 冲榜界面
        if self.rankData.endTime > 0 then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIActivityTower, Enum.RankActivitiesType.Skill)
            self.forceOpenUI = false
        else
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RANK_ACTIVITY_DISPLAY_NTF, Enum.RankActivitiesType.Skill, false)
        end
    end
end

function SkillRankActivityData:RefreshRewardRPStatae()
    local type = Enum.RankActivitiesType.Skill
    local idx = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityIdx(type)
    local cfgDatas = ManagerContainer.CfgMgr:GetRushListCfgByTypeAndIdx(type, idx)
    if not cfgDatas then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.TowerRankCanReward, false)
        return
    end
    local cfgDatas = ManagerContainer.CfgMgr:GetRushListTargetCfgByTypeAndIdx(type,idx)
    countlimit = cfgDatas[1].Rank[1][1]

    local stage, endTime = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityStageEndTime(Enum.RankActivitiesType.Skill)
    local rankRewardState = stage == 2 and self.rankData.selfRank > 0 and not self.rankData.rankReward
    local challengeRewardState = self.rankData.selfLevel >= countlimit and not self.rankData.challengReward
    ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.SkillRankCanReward, rankRewardState or challengeRewardState)
end

function SkillRankActivityData:OnActivityRewardAck(data)
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

function SkillRankActivityData:GetCurRankActivityData()
    return self.rankData
end

function SkillRankActivityData:SendRewardReq(type)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_RUSH_ACTIVITY_REWARD_REQ, {reward_type = type, rush_type = self.type})
end

function SkillRankActivityData:QueryRankDatas(page)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_RUSH_SKILL_ACTIVITY_RANK_REQ, {page = page})
end

function SkillRankActivityData:QuerySkillRankDatasAck(data)
    -- LogHRWarning(Inspect(data))
    if data.error ~= Enum.NetErrorCode.ERROR_OK then
        return
    end

    if not self.rankData then return end

    if data.top_data then
        for i = 1,#data.top_data do
            local data1 = {}
            data1.name = data.top_data[i].name
            data1.data = data.top_data[i].data
            data1.rank = data.top_data[i].rank
            self.rankData.topData[data1.rank] = data1
        end
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_RANK_QUERY_ACK_REFRESH)
end

function SkillRankActivityData:Destroy()
    self:Clear()
end

return SkillRankActivityData