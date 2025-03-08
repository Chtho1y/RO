local RankActivitiesMgr = class("RankActivitiesMgr",require("DataBase"))
local TowerRankActivityData = require("RankActivities/TowerRankActivityData")
local ArenaRankActivityData = require("RankActivities/ArenaRankActivityData")
local MapProgressActivityData = require("RankActivities/MapProgressActivityData")
local PetRankActivityData = require("RankActivities/PetRankActivityData")
local SkillRankActivityData = require("RankActivities/SkillRankActivityData")
local ProtocalDataNormal = require("ProtocalDataNormal")

function RankActivitiesMgr:ctor()
    self.curRnakDatas = {}
    self.forceCheck = false

    self.curCount = 0
    self.countLimit = 3

    self.rankDatas = {}
    self.rankRewardType = {}
end

function RankActivitiesMgr:Clear()
    self.curRnakDatas = {}
    self.forceCheck = false

    for _,v in pairs(self.rankDatas) do
        v:Clear()
    end

    self.rankDatas = {}
end

function RankActivitiesMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ONLINE_RUSH_INFO_ACK,self.OnOnlineRushInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_RUSH_ACTIVITY_REWARD_ACK,self.OnActivityRewardAck, self)

   for _,v in pairs(self.rankDatas) do
        v:RegisterNetEvents()
    end
end

function RankActivitiesMgr:QueryRankActivitiesData(init)
    self.isInitQuery = init
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ONLINE_RUSH_INFO_REQ, {})
end

function RankActivitiesMgr:OnOnlineRushInfoAck(data)
    --data = {}
    --data.rush_data = {}
    --local data1 = {}
    --data1.rush_type = 3
    --data1.in_rush = true
    --data1.next_rush = 0
    --data1.stage = 1
    --data1.stage_end = int64.new("1605247823000")
    --data1.rush_count = 1
    --data.rush_data[1] = data1
    -- LogHRWarning(Inspect(data))
    for i = 1, #data.rush_data do
        local data1 = ProtocalDataNormal.RushActivityData(data.rush_data[i])
        self.curRnakDatas[data1.rushType] = data1
        if data1.inRush then
            self:InitRankData(data1)
        end
    end

    if self.forceCheck then
        self:CheckRancActivityOpenTime()
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RANK_ACTIVITY_REWARD_SUCCESS_NTF)

    if self.isInitQuery then
        self.isInitQuery = false
        ManagerContainer.DataMgr.RankActivitiesMgr:QueryCurRankActivityData(Enum.RankActivitiesType.ClimbingTower)
        ManagerContainer.DataMgr.RankActivitiesMgr:QueryCurRankActivityData(Enum.RankActivitiesType.Dojo)
        ManagerContainer.DataMgr.RankActivitiesMgr:QueryCurRankActivityData(Enum.RankActivitiesType.MapProgress)
        ManagerContainer.DataMgr.RankActivitiesMgr:QueryCurRankActivityData(Enum.RankActivitiesType.Pet)
        ManagerContainer.DataMgr.RankActivitiesMgr:QueryCurRankActivityData(Enum.RankActivitiesType.Skill)
    end
end

function RankActivitiesMgr:OnActivityRewardAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end
    if not self.curRnakDatas[data.rush_type] then return end

    if self.rankDatas[data.rush_type] then
        return self.rankDatas[data.rush_type]:OnActivityRewardAck(data)
    end
end

function RankActivitiesMgr:InitRankData(data)
    if not self.rankDatas[data.rushType] then
        local rankData = nil
        if data.rushType == Enum.RankActivitiesType.ClimbingTower then
            rankData = TowerRankActivityData:new()
            self.rankDatas[data.rushType] = rankData
            self.rankRewardType[data.rushType] = Enum.RPNotifyType.TowerRankCanReward
        elseif data.rushType == Enum.RankActivitiesType.Dojo then
            rankData = ArenaRankActivityData:new()
            self.rankDatas[data.rushType] = rankData
            self.rankRewardType[data.rushType] = Enum.RPNotifyType.ArenaRankCanReward
        elseif data.rushType == Enum.RankActivitiesType.MapProgress then
            rankData = MapProgressActivityData:new()
            self.rankDatas[data.rushType] = rankData
            self.rankRewardType[data.rushType] = Enum.RPNotifyType.MapRankCanReward
        elseif data.rushType == Enum.RankActivitiesType.Pet then
            rankData = PetRankActivityData:new()
            self.rankDatas[data.rushType] = rankData
            self.rankRewardType[data.rushType] = Enum.RPNotifyType.PetRankCanReward
        elseif data.rushType == Enum.RankActivitiesType.Skill then
            rankData = SkillRankActivityData:new()
            self.rankDatas[data.rushType] = rankData
            self.rankRewardType[data.rushType] = Enum.RPNotifyType.SkillRankCanReward
        end
        if rankData then
            rankData:RegisterNetEvents()
        end
    end
end

function RankActivitiesMgr:GetCurRankActivityIdx(type)
    if not self.curRnakDatas[type] then
        return
    end
    return self.curRnakDatas[type].rushCount
end

function RankActivitiesMgr:GetCurRankActivityStageEndTime(type)
    if not self.curRnakDatas[type] then
        return
    end
    return self.curRnakDatas[type].stage, self.curRnakDatas[type].stageEnd, self.curRnakDatas[type].inRush
end

function RankActivitiesMgr:GetCurRankActivityData(type)
    if not self.curRnakDatas[type] then return end

    if self.rankDatas[type] then
        return self.rankDatas[type]:GetCurRankActivityData()
    end
    return
end

function RankActivitiesMgr:QueryCurRankActivityData(type, forceOpenUI)
    if not self.curRnakDatas[type] then return end

    if self.rankDatas[type] and self.curRnakDatas[type].inRush then
        self.rankDatas[type]:QueryRankActivityData(forceOpenUI)
    end
end

function RankActivitiesMgr:SendRewardReq(type, rewardType)
    if not self.curRnakDatas[type] then return end

    if self.rankDatas[type] then
        self.rankDatas[type]:SendRewardReq(rewardType)
    end
end

function RankActivitiesMgr:QueryPetRankDatas(page)
    if self.rankDatas[Enum.RankActivitiesType.Pet] then
        self.rankDatas[Enum.RankActivitiesType.Pet]:QueryPetRankDatas(page)
    end
end

function RankActivitiesMgr:QueryRankActivityData(type, page)
	if type == Enum.RankActivitiesType.Pet then
		self:QueryPetRankDatas(page)
	else
		if self.rankDatas[type] then
			self.rankDatas[type]:QueryRankDatas(page)
		end
	end
end

function RankActivitiesMgr:CheckRancActivityOpenTime()
    if not self.curRnakDatas then return end
    self.forceCheck = false
    local needQuery = false

    if not next(self.curRnakDatas) then
        for _,v in pairs(Enum.RankActivitiesType) do
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RANK_ACTIVITY_DISPLAY_NTF, v, false)
        end
        return
    end

    for _,v in pairs(Enum.RankActivitiesType) do
        local type = v
        local rankData = self.curRnakDatas[type]
        if rankData then
            local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
            if rankData.inRush then
                local stage, endTime = self:GetCurRankActivityStageEndTime(type)
                if (stage == 1 and curTime >= endTime) or (stage == 2 and curTime >= endTime) then
                    if not needQuery then
                        needQuery = true
                    end
                else
                    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RANK_ACTIVITY_DISPLAY_NTF, rankData.rushType, true)
                end
            else
                if curTime > rankData.nextRush and rankData.nextRush > 0 then
                    if not needQuery then
                        needQuery = true
                    end
                else
                    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RANK_ACTIVITY_DISPLAY_NTF, rankData.rushType, false)
                end
            end
        else
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RANK_ACTIVITY_DISPLAY_NTF, type, false)
        end
    end

    if needQuery then
        self.forceCheck = true
        self.curCount = self.curCount + 1
        if self.curCount >= self.countLimit then
            self.curCount = 0
            return
        end
        for k, v in pairs(self.rankDatas) do
            if v.rankData ~= nil and k ~= Enum.RankActivitiesType.MapProgress then
                local rankRewardState =v.rankData.selfRank > 0 and not v.rankData.rankReward
                ManagerContainer.RedPointSimpleMgr:RPNotify(self.rankRewardType[k], rankRewardState)
            end
        end
        self:QueryRankActivitiesData()
    end
end

function RankActivitiesMgr:Destroy()
    for _,v in pairs(self.rankDatas) do
        v:Destroy()
    end
    self.rankDatas = nil
    self.curRnakData = nil
end

return RankActivitiesMgr