local PeakTowerDataMgr = class("PeakTowerDataMgr",require("DataBase"))
local PealTowerFloorData = require "PeakTower.PeakTowerFloorData"
local PeakTowerRankData = require "PeakTower.PeakTowerRankData"

function PeakTowerDataMgr:ctor()
    self.curTowerFloorIdx = nil
    self.towerFightList = {}

    self.startIdx = nil
    self.selfFloorIdx = nil
    self.selfScore = nil
    self.totalRank = nil

    self.forceWinRankList = {}
end

function PeakTowerDataMgr:Clear()
    self.curTowerFloorIdx = nil
    self.towerFightList = {}

    self.startIdx = nil
    self.selfFloorIdx = nil
    self.selfScore = nil
    self.totalRank = nil

    self.forceWinRankList = {}
    self.changeTowerState = nil
end

function PeakTowerDataMgr:Destroy()
    self:Clear()
end

function PeakTowerDataMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_TOP_TOWER_FIGHT_LIST_ACK,self.OnFightListAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_TOP_TOWER_CHALLENGE_RESULT_ACK,self.OnChallengeResultAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_TOP_TOWER_FORCE_WIN_ACK,self.OnForceWinAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_TOP_TOWER_FORCE_WIN_RANK_LIST_ACK,self.OnForceWinRankListAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_TOP_TOWER_CHALLENGE_ACK,self.OnChallengeAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_TOP_TOWER_CHALLENGE_VIEW_INFO_ACK,self.OnQueryCrossChallengeInfoAck,self)
end

function PeakTowerDataMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_TOP_TOWER_FIGHT_LIST_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_TOP_TOWER_CHALLENGE_RESULT_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_TOP_TOWER_FORCE_WIN_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_TOP_TOWER_FORCE_WIN_RANK_LIST_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_TOP_TOWER_CHALLENGE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_TOP_TOWER_CHALLENGE_VIEW_INFO_ACK)
end

function PeakTowerDataMgr:InitData()

end

function PeakTowerDataMgr:OnFightListAck(data)
    -- LogHRWarning("SC_CROSS_TOP_TOWER_FIGHT_LIST_ACK    "..Inspect(data))
    if data.error ~= Enum.NetErrorCode.ERROR_OK then 
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_REFRESH_CLIMBINGTOWER_DATA)
        return 
    end

    if not data.toptower_data then 
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_REFRESH_CLIMBINGTOWER_DATA)
        return 
    end
    
    local validEndTime = data.toptower_data.valid_end_time
    local fightList = data.toptower_data.fight_list
    for i = 1, #fightList do
        local idx = fightList[i].idx
        local data1 = self.towerFightList[idx]
        if not data1 then
            data1 = PealTowerFloorData:new({fightList[i], validEndTime})
            self.towerFightList[idx] = data1
        else
            data1:RefreshData(fightList[i], validEndTime)
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_CHANGE_TOWER_SHOW_REFRESH, self.changeTowerState)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_REFRESH_CLIMBINGTOWER_DATA)
end

function PeakTowerDataMgr:SendTowerFightListReq(changeTower)
    -- LogHRWarningStack("CS_CROSS_TOP_TOWER_FIGHT_LIST_REQ")
    self.changeTowerState = changeTower
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_TOP_TOWER_FIGHT_LIST_REQ, {})
end

function PeakTowerDataMgr:OnChallengeResultAck(data)
    --LogHRWarning("SC_CROSS_TOP_TOWER_CHALLENGE_RESULT_ACK    "..Inspect(data))
    if data.error ~= Enum.NetErrorCode.ERROR_OK then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIClimbingTowerBattleFailed,Enum.UIPageName.UIClimbingTower)
        return 
    end

    -- if data.reward_list then
    --     CommonUtil.ACKShowRewardList(data.reward_list)
    -- end

    if data.fight_info then
        local idx = data.fight_info.idx
        local data1 = self.towerFightList[idx]
        if data1 then
            data1:RefreshData(data.fight_info)
        end
    end

    if data.reward_list ~= nil then
        local rewards = {}
        for i = 1, #data.reward_list do
            local itemData = data.reward_list[i];
            rewards[#rewards+1] = {itemData.key, itemData.value,0}
        end

        if data.ex_reward_list  ~= nil then
            for i =1, #data.ex_reward_list do
                local itemData = data.ex_reward_list[i];
                rewards[#rewards+1] = {itemData.key, itemData.value,1}
            end
        end

        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIClimbingTowerBattleWin,{Enum.UIPageName.UIClimbingTower,rewards})
    else
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIClimbingTowerBattleWin,{Enum.UIPageName.UIClimbingTower,nil})
    end
end

function PeakTowerDataMgr:SendTowerChallengeResultReq(isWin, fightIdx)
    --LogHRWarning("CS_CROSS_TOP_TOWER_CHALLENGE_RESULT_REQ")
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_TOP_TOWER_CHALLENGE_RESULT_REQ, {is_win = isWin == 1, fight_idx = fightIdx})
end

function PeakTowerDataMgr:OnForceWinAck(data)
    --LogHRWarning("SC_CROSS_TOP_TOWER_FORCE_WIN_ACK    "..Inspect(data))
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end

    if data.reward_list then
        CommonUtil.ACKShowRewardList(data.reward_list)
    end

    local idx = nil
    if data.fight_info then
        idx = data.fight_info.idx
        local data1 = self.towerFightList[idx]
        if data1 then
            data1:RefreshData(data.fight_info)
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_REFRESH_PEAKTOWER_WIN_DATA, idx)
end

function PeakTowerDataMgr:SendTowerForceWinReq(fightIdx)
    --LogHRWarning("CS_CROSS_TOP_TOWER_FORCE_WIN_REQ")
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_TOP_TOWER_FORCE_WIN_REQ, {fight_idx = fightIdx})
end

function PeakTowerDataMgr:OnForceWinRankListAck(data)
    --LogHRWarning("SC_CROSS_TOP_TOWER_FORCE_WIN_RANK_LIST_ACK    "..Inspect(data))
    self.startIdx = data.start_idx
    self.selfFloorIdx = data.self_rank
    self.selfScore = data.self_score
    
    for i = 1, #data.rank_list do
        local idx = data.rank_list[i].rank
        local data1 = self.forceWinRankList[idx]
        if not data1 then
            data1 = PeakTowerRankData:new(data.rank_list[i])
            self.forceWinRankList[idx] = data1
        else
            data1:RefreshData(data.rank_list[i])
        end
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_ClimbingTower_RankData)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_ClimbingTower_RankDetailData)
end

function PeakTowerDataMgr:SendForceWinRankListReq(startIdx)
    --LogHRWarning("CS_CROSS_TOP_TOWER_CHALLENGE_REQ")
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_TOP_TOWER_FORCE_WIN_RANK_LIST_REQ, {uid = uid, start_idx = startIdx})
end

function PeakTowerDataMgr:OnChallengeAck(data)
    -- LogHRWarning("SC_CROSS_TOP_TOWER_CHALLENGE_ACK    "..Inspect(data))
    if data.error ~= Enum.NetErrorCode.ERROR_OK then 
        self.curFightIdx = nil
        return 
    end
    if not data.fight_info then return end

    local idx
    if data.fight_info then
        idx = data.fight_info.idx
        local data1 = self.towerFightList[idx]
        if data1 then
            data1:RefreshData(data.fight_info)
        end
    end
    --进入客户端战斗
    self:EnterBattle(idx, {})
    self.curFightIdx = nil
end

function PeakTowerDataMgr:SendChallengeReq(fightIdx)
    --验证合法性
    --LogHRWarning("CS_CROSS_TOP_TOWER_CHALLENGE_REQ")
    self.curFightIdx = fightIdx
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_TOP_TOWER_CHALLENGE_REQ, {fight_idx = fightIdx})
end

function PeakTowerDataMgr:OnQueryCrossChallengeInfoAck(data)
    -- LogHRWarning("SC_CROSS_TOP_TOWER_CHALLENGE_VIEW_INFO_ACK    "..Inspect(data))
    if data.error ~= Enum.NetErrorCode.ERROR_OK then 
        self.curFightIdx = nil
        return 
    end
    if not data.fight_info then return end

    local idx
    if data.fight_info then
        idx = data.fight_info.idx
        local data1 = self.towerFightList[idx]
        if data1 then
            data1:RefreshData(data.fight_info)
        end
    end
    ManagerContainer.DataMgr.UserData:SCGetOtherPlayerDetailInfoAck(data.fight_info.fight_info, true)
end

function PeakTowerDataMgr:QueryCrossChallengeInfoReq(fightIdx)
    --查询信息
    -- LogHRWarning("CS_CROSS_TOP_TOWER_CHALLENGE_VIEW_INFO_REQ")
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_TOP_TOWER_CHALLENGE_VIEW_INFO_REQ, {fight_idx = fightIdx})
end

function PeakTowerDataMgr:GetCurUITowerType()
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    local type = UnityEngine.PlayerPrefs.GetInt(tostring(uid).."_UITowerType")
    return type
end

function PeakTowerDataMgr:SaveCurUITowerType(type)
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    UnityEngine.PlayerPrefs.SetInt(tostring(uid).."_UITowerType", type)
end

function PeakTowerDataMgr:GetTowerFightList()
    return self.towerFightList
end

function PeakTowerDataMgr:GetForceWinRankList()
    return self.forceWinRankList
end

function PeakTowerDataMgr:GetSeflRankIdx()
    return self.selfFloorIdx
end

function PeakTowerDataMgr:GetSeflRankScore()
    return self.selfScore
end

function PeakTowerDataMgr:EnterBattle(towerLevel,factorList)
    local levelInfo = ManagerContainer.CfgMgr:GetTopTowerRewardCfgDataByLv(towerLevel)
    if levelInfo ~= nil then
        self.floorIdx = towerLevel
        local teams = ManagerContainer.DataMgr.UserData:GetTeamData(true);
        if teams ~= nil then 
            ManagerContainer.LuaGameMgr:SetTeamData(teams,{false})
        end   
        ManagerContainer.LuaGameMgr:RefreshTeamData()
        self.curMaxFightingTime = levelInfo.maxFightingTime
        local curOurActors = {}
        self.ourActors = System.Array.CreateInstance(Enum.TypeInfo.ActorData, #teams)
        for i = 1 , #teams do
            local actor = ManagerContainer.LuaActorDataMgr:GetActorsById(teams[i].uid,teams[i].id)
            --增加对应压制mark
            ManagerContainer.DataMgr.UserData:SetActorPveMark(teams[i].uid,actor)
            self.ourActors[i-1] = actor
            curOurActors[#curOurActors+1] = actor
        end

        local fightData = self.towerFightList[towerLevel]
        local actorSystem = fightData.actorSystem
        self.enemyActors = {}
        self.matchFighterName = actorSystem:GetUserNickname()
        if actorSystem:GetPlayerActorParam() ~= nil then
            self.enemyActors[#self.enemyActors+1] = actorSystem:GetPlayerActorParam()
        end
    
        local fellowActors = actorSystem:GetFellowActorParam()
        if fellowActors ~= nil then
            for k,actor in pairs(fellowActors) do
                self.enemyActors[#self.enemyActors +1] = actor
            end
        end

        local selfMaskDatas = nil
        local enemyPvPVal = actorSystem:GetSkillPvPVal()
        local OurPvPVal = ManagerContainer.DataMgr.UserData:GetCurrRoleSkillPress()
        local IsPresspoint,BuffId = ManagerContainer.CfgMgr:GetPresspointPvPCfg(OurPvPVal,enemyPvPVal)   
        if BuffId > -1 then
            --设置压制ID
            --LogError("添加压制markid"..tostring(BuffId))
            selfMaskDatas = {}
            selfMaskDatas[1] = GvGMark.New(BuffId, 1)
        end

        local battleFactors = System.Array.CreateInstance(Enum.TypeInfo.ValType, #factorList)
        for i = 1, #factorList do
            local factor = ValType.New(factorList[i].key,factorList[i].value)
            battleFactors[i-1] = factor
        end
        
        self.curEnterBattleTime = Time.realtimeSinceStartup

        self.isPlayRecord = false
        self:InitEndBattleCondition()
        ManagerContainer.LuaGameMgr:EnterClimbingTowerBattlePvP(levelInfo.SceneName,levelInfo.BgmName,self:GetLimitedTime(),self.ourActors, self.enemyActors,selfMaskDatas, IsPresspoint,OurPvPVal+enemyPvPVal,self.battleEndCondList)        
    end
end

function PeakTowerDataMgr:GetOurMembers()
    return self.ourActors
end

function PeakTowerDataMgr:GetEnemyMembers()
    return self.enemyActors
end

function PeakTowerDataMgr:GetMatchFighterName()
    return self.matchFighterName
end

function PeakTowerDataMgr:InitEndBattleCondition()
    if self.battleEndCondList ~= nil then
        return
    end
    local limitedTime = self:GetLimitedTime()
    self.battleEndCondList = System.Array.CreateInstance(Enum.TypeInfo.BattleEndCondition, 2)
    self.battleEndCondList[0] = BattleEndCondition.New(Constants.EndBattle_By_UndeadCount,Constants.ResultType_Normal)
    self.battleEndCondList[1] = BattleEndCondition.New(Constants.EndBattle_By_BattleTime, limitedTime, Constants.ResultType_Normal, false)
end

function PeakTowerDataMgr:BattleEnd(battleTime,isPlayRecord,timeStamp)
    self.enemyActors = nil
    self.ourMembers = nil
    if self.isPlayRecord then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE,Enum.UIPageName.UIClimbingTower)
        return
    end

    -- self:SendClimbingTowerEndReq(battleTime,self.curChallengeLevel,timeStamp)
    self:SendTowerChallengeResultReq(battleTime, self.floorIdx)
end

function PeakTowerDataMgr:GetLimitedTime()
    return GlobalConfig.Instance:GetConfigIntValue(251)
end

function PeakTowerDataMgr:NeedRefreshFightList()
    if #self.towerFightList == 0 then return true end

    local firstData = self.towerFightList[1]
    local currTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    return currTime > firstData.validEndTime
end

return PeakTowerDataMgr