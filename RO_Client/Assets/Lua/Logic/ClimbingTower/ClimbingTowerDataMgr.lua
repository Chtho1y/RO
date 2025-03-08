local ClimbingTowerDataMgr = class("ClimbingTowerDataMgr",require("DataBase"))
local ClimbingTowerLevelData = require("ClimbingTower/ClimbingTowerLevelData")
local ClimbingTowerRankData = require("ClimbingTower/ClimbingTowerRankData")

function ClimbingTowerDataMgr:ctor()
    self.curChallengeLevel = 1          --当前需要挑战的关卡
    self.lastPassedTime = 0
    self.levels = nil
    self.ranks = nil
    self.rankPlayerIds = nil
    self.showLevels = nil
    self.selfRank = 10000
    self.requested = false
    self.curMaxFightingTime = 0
    self.curEnterBattleTime = 0
    self.battleEndCondList = nil
    self.bInited = false
end

function ClimbingTowerDataMgr:Clear()
    self.bInited = false
    self.requested = false
    self.levels = nil
    self.ranks = nil
    self.rankPlayerIds = nil
    self.showLevels = nil
    self.battleEndCondList = nil

    self.changeTowerState = nil
end

function ClimbingTowerDataMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CLIMBING_TOWER_INFO_ACK,self.OnClimbingTowerInfoAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_FRIEND_PASS_TOWER_INFO_ACK,self.OnTowerFriendPassTowerInfoAck,self)
   -- ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_TOWER_LEVEL_MIN_FIGHT_POWER_NTF,self.OnTowerLevelMinFightPowerNtf,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CLIMBING_TOWER_BEGIN_ACK,self.OnClimbingTowerBeginAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CLIMBING_TOWER_END_ACK,self.OnClimbingTowerEndAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CLIMBING_TOWER_RANK_ACK,self.OnClimbingTowerRankAck,self)
   
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_SC_GET_OTHER_PLAYER_BRIEF_INFO_ACK,self,self.OnGetRankBriefInfoAck)
end

function ClimbingTowerDataMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CLIMBING_TOWER_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_FRIEND_PASS_TOWER_INFO_ACK)
    --ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_TOWER_LEVEL_MIN_FIGHT_POWER_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CLIMBING_TOWER_BEGIN_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CLIMBING_TOWER_END_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CLIMBING_TOWER_RANK_ACK)

    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_SC_GET_OTHER_PLAYER_BRIEF_INFO_ACK,self,self.OnGetRankBriefInfoAck);
end

function ClimbingTowerDataMgr:InitData()
    if self.bInited then
        return
    end

    self.levels = {}
    local cfgList = ManagerContainer.CfgMgr:GetClimbingTowerCfg()
    if cfgList ~= nil then
        for i = 1, #cfgList do
            self.levels[#self.levels+1] = ClimbingTowerLevelData:new(cfgList[i])
        end
    end
    self:SortLevelList()
    self.bInited = true
end

function ClimbingTowerDataMgr:SetShowLevels()
    self.showLevels = {}

    local maxLevel = self.curChallengeLevel + 4
    if maxLevel > #self.levels then
        maxLevel = #self.levels
    end

    for i = 1, maxLevel do
        local level = self:FindLevelData(i)
        level:SetPassed(level.levelId<self.curChallengeLevel)
        self.showLevels[#self.showLevels+1] = level
    end
end

function ClimbingTowerDataMgr:GetShowLevels()
    return self.showLevels
end

function ClimbingTowerDataMgr:SortLevelList()
    if self.levels == nil or #self.levels < 2 then
        return
    end

    table.sort(
        self.levels,
        function(a, b)
            return a.levelId > b.levelId
        end
    )
end

function ClimbingTowerDataMgr:ChangeData()

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_REFRESH_CLIMBINGTOWER_DATA);
end

function ClimbingTowerDataMgr:GetLevels()
    return self.levels
end

function ClimbingTowerDataMgr:FindLevelData(levelId)
    if self.levels == nil then
        return nil
    end

    for i = 1,#self.levels do
        local level = self.levels[i]
        if level.levelId == levelId then
            return level
        end
    end

    return nil
end

function ClimbingTowerDataMgr:FindRankerData(uid)
    if self.ranks == nil then
        return nil
    end

    for i=1, #self.ranks do
        if self.ranks[i].playerId == uid then
            return self.ranks[i]
        end 
    end

    return nil
end

function ClimbingTowerDataMgr:GetCurChallengeLevel()
    return self.curChallengeLevel
end

function ClimbingTowerDataMgr:GetRankList()
    return self.ranks
end

function ClimbingTowerDataMgr:GetCurrentLevelInfo()
    return self:FindLevelData(self.curChallengeLevel) 
end

function ClimbingTowerDataMgr:SendClimbingTowerInfoReq(changeTower)
    if self.requested then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_CHANGE_TOWER_SHOW_REFRESH, changeTower)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_REFRESH_CLIMBINGTOWER_DATA)
        return
    end
    self.changeTowerState = changeTower
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CLIMBING_TOWER_INFO_REQ, {})
end

function ClimbingTowerDataMgr:InitClimbingTowerInfo(data)
    self.curChallengeLevel = data.now_tower_level + 1
    self.lastPassedTime = data.now_tower_time
end

function ClimbingTowerDataMgr:OnClimbingTowerInfoAck(data)
    self:InitData()
    self.curChallengeLevel = data.now_tower_level + 1
    self.lastPassedTime = data.pass_time
    if data.infos ~= nil then
        for i = 1, #data.infos do
            local  friendTowerInfo = data.infos[i]
            local levelInfo = self:FindLevelData(friendTowerInfo.tower_level)
            if levelInfo ~= nil then
                levelInfo:SetFriendData(friendTowerInfo.infos)
            end
        end
    end
    self:SetShowLevels()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_CHANGE_TOWER_SHOW_REFRESH, self.changeTowerState)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_REFRESH_CLIMBINGTOWER_DATA)
    self.requested = true
end

function ClimbingTowerDataMgr:SendFriendPassTowerInfoReq(beginIdx,endIdx)
    -- LogError("SendFriendPassTowerInfoReq:" .. beginIdx .. "---" .. endIdx) 
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FRIEND_PASS_TOWER_INFO_REQ, {begin_index=beginIdx,end_index=endIdx})
end

function ClimbingTowerDataMgr:OnTowerFriendPassTowerInfoAck(data)
    -- LogError("OnTowerFriendPassTowerInfoAck:" .. Inspect(data))
    if data.infos ~= nil then
        local levelIds = {}
        for i = 1, #data.infos do
            local  friendTowerInfo = data.infos[i]
            local levelInfo = self:FindLevelData(friendTowerInfo.tower_level)
            if levelInfo ~= nil then
                levelInfo:SetFriendData(friendTowerInfo.infos)
                levelIds[#levelIds+1] = friendTowerInfo.tower_level
            end
        end

        if #levelIds > 0 then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_ClimbingTower_FriendInfo,levelIds)
        end
    end
end

function ClimbingTowerDataMgr:OnTowerLevelMinFightPowerNtf(data)
    -- LogError("OnTowerLevelMinFightPowerNtf:" .. Inspect(data))
    if data.min_tower_info ~= nil then
        for i=1, #data.min_tower_info do
            local info = data.min_tower_info[i]
            local levelInfo = self:FindLevelData(info.tower_level)
            if levelInfo ~= nil then
                levelInfo:SetLowestPlayerInfo(info.brief,info.fight_power,info.record_time,info.battle_time)
            end
        end
    end
end

function ClimbingTowerDataMgr:SendClimbingTowerBeginReq(towerLevel)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CLIMBING_TOWER_BEGIN_REQ, {tower_level = towerLevel})
end

function ClimbingTowerDataMgr:OnClimbingTowerBeginAck(data)
    -- LogError("OnClimbingTowerBeginAck:" .. Inspect(data))
    if data.error == 0 then
       self:EnterBattle(data.tower_level,data.factor_list)
    end
end

function ClimbingTowerDataMgr:SendClimbingTowerEndReq(loadingTime,towerLevel,timeStamp)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CLIMBING_TOWER_END_REQ, {loading_time = loadingTime, tower_level = towerLevel,record_time_stamp = timeStamp})
end

function ClimbingTowerDataMgr:OnClimbingTowerEndAck(data)
    -- LogError("OnClimbingTowerEndAck:" .. Inspect(data))
    if data.error == 0 then
        local levelInfo = self:GetCurrentLevelInfo()
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

        self.curChallengeLevel = data.tower_level + 1
        if data.pass_time ~= nil then
            self.lastPassedTime = data.pass_time
        end

        if data.pass_info ~= nil then
            local levelInfo = self:FindLevelData(data.pass_info.tower_level)
            if levelInfo ~= nil then
                levelInfo:SetFriendData(data.pass_info.infos)
            end
        end
        self:SetShowLevels()
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_REFRESH_CLIMBINGTOWER_DATA)

        ManagerContainer.DataMgr.RankActivitiesMgr:QueryCurRankActivityData(Enum.RankActivitiesType.ClimbingTower)
    else
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIClimbingTowerBattleFailed,Enum.UIPageName.UIClimbingTower)
    end
end

function ClimbingTowerDataMgr:SendClimbingTowerRankReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CLIMBING_TOWER_RANK_REQ, {})
end

function ClimbingTowerDataMgr:OnClimbingTowerRankAck(data)
    -- LogError("OnClimbingTowerRankAck:" .. Inspect(data))
    if data.error == 0 then
        self.ranks = {}
        self.rankPlayerIds = {}
        for i = 1, #data.rank_list do
            local player = ClimbingTowerRankData:new(data.rank_list[i].key,data.rank_list[i].value)
            self.ranks[#self.ranks+1] = player
            self.rankPlayerIds[#self.rankPlayerIds+1] = data.rank_list[i].key
        end
        self.selfRank = data.self_rank

        local uid_list = self:GetRankUidList(10)
        self:ReqTowerRankBriefData(uid_list)
    else
        self.ranks = nil
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_ClimbingTower_RankData)
end

function ClimbingTowerDataMgr:ReqTowerRankBriefData(uids)
    if uids == nil or #uids == 0 then
        return
    end

    -- LogError("ClimbingTowerDataMgr : " .. Inspect(uids))
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_OTHER_PLAYER_BRIEF_INFO_REQ, {type=Enum.FriendTogglePageType.ClimbingTower, player_list=uids})
end

function ClimbingTowerDataMgr:OnGetRankBriefInfoAck(data)
    -- LogError("OnGetRankBriefInfoAck:" .. Inspect(data))
    if data.type == Enum.FriendTogglePageType.ClimbingTower then
        if data.brief_info ~= nil then
            for i = 1,#data.brief_info do
                local info = data.brief_info[i]
                local ranker = self:FindRankerData(info.uid)
                if ranker ~= nil then
                    ranker:SetRankData(info)
                end
                self:RemoveTempRankerId(info.uid)
            end
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_ClimbingTower_RankDetailData)
    end
end

function ClimbingTowerDataMgr:RemoveTempRankerId(uid)
    if self.rankPlayerIds == nil then
        return
    end

    for i = 1, #self.rankPlayerIds do
        if self.rankPlayerIds[i] == uid then
            table.remove(self.rankPlayerIds,i)
            return
        end
    end
end

function ClimbingTowerDataMgr:GetRankUidList(cnt)
    local uids = {}
    if self.rankPlayerIds ~= nil then
        if cnt > #self.rankPlayerIds then
            cnt = #self.rankPlayerIds
        end
        for i = 1, cnt do
            uids[#uids+1] = self.rankPlayerIds[i]
        end
    end
    return uids
end

function ClimbingTowerDataMgr:InitEndBattleCondition()
    if self.battleEndCondList ~= nil then
        return
    end

    self.battleEndCondList = System.Array.CreateInstance(Enum.TypeInfo.BattleEndCondition, 2)
    self.battleEndCondList[0] = BattleEndCondition.New(Constants.EndBattle_By_UndeadCount,Constants.ResultType_Normal)
    self.battleEndCondList[1] = BattleEndCondition.New(Constants.EndBattle_By_BattleTime,Constants.ResultType_Normal)
end

function ClimbingTowerDataMgr:EnterBattle(towerLevel,factorList)
    local levelInfo = self:FindLevelData(towerLevel)
    if levelInfo ~= nil then
        local teams = ManagerContainer.DataMgr.UserData:GetTeamData(true);
        if teams ~= nil then 
            ManagerContainer.LuaGameMgr:SetTeamData(teams,{false})
        end   
        ManagerContainer.LuaGameMgr:RefreshTeamData()
        self.curMaxFightingTime = levelInfo.maxFightingTime
        local curOurActors = {}
        local curEnemyActors = {}
        local teams = ManagerContainer.DataMgr.UserData:GetTeamData(true)
        if teams ~= nil then 
            --会有技能 没有即使更新 此处同步属性 
            ManagerContainer.LuaGameMgr:SetTeamData(teams,{true})
            --打印
            for i = 1, #teams do                
                Log("ClimbingTowerDataMgr EnterBattle RoleID = "..tostring(teams[i].uid))
                Log("Pet Id"..tostring(petId))
                local Skills = teams[i].skills
                for i = 1, #Skills do
                    local skillId = Skills[i].skillId
                    local petId = Skills[i].petId
                    Log("Role Skill"..tostring(skillId))                    
                end
            end
        end   
        local ourActors = System.Array.CreateInstance(Enum.TypeInfo.ActorData, #teams)
        for i = 1 , #teams do
            local actor = ManagerContainer.LuaActorDataMgr:GetActorsById(teams[i].uid,teams[i].id)
            --增加对应压制mark
            ManagerContainer.DataMgr.UserData:SetActorPveMark(teams[i].uid,actor)
            ourActors[i-1] = actor
            curOurActors[#curOurActors+1] = actor
        end

        local enemyActors = System.Array.CreateInstance(Enum.TypeInfo.ActorData, #levelInfo.npcs)
        for i = 1, #levelInfo.npcs do
            local npcInfo = levelInfo.npcs[i]
			local actor = ManagerContainer.LuaActorDataMgr:CreateNpc(10000+i,npcInfo.npcId,npcInfo.npcPos,npcInfo.npcLevel)
            if actor ~= nil then
                actor.IsBoss = npcInfo.isBoss
                enemyActors[i-1] = actor
                curEnemyActors[#curEnemyActors+1] = actor
			end
        end

        local battleFactors = System.Array.CreateInstance(Enum.TypeInfo.ValType, #factorList)
        for i = 1, #factorList do
            local factor = ValType.New(factorList[i].key,factorList[i].value)
            battleFactors[i-1] = factor
        end
        
        self.curEnterBattleTime = Time.realtimeSinceStartup

        self.isPlayRecord = false
        self:InitEndBattleCondition()
        ManagerContainer.LuaGameMgr:EnterClimbingTowerBattle(levelInfo.sceneName,levelInfo.bgmName,levelInfo.maxFightingTime,ourActors,enemyActors,self.battleEndCondList,nil,battleFactors)
    end
end

function ClimbingTowerDataMgr:ReplayBattle(towerLevel,battleRecordStr,replayername)
    local levelInfo = self:FindLevelData(towerLevel)
    if levelInfo == nil then
        return
    end   
    self.isPlayRecord = true
    self.recordLevelId = towerLevel
    ManagerContainer.LuaGameMgr:EnterClimbingTowerBattle(levelInfo.sceneName,levelInfo.bgmName,levelInfo.maxFightingTime,nil,nil,nil,battleRecordStr,nil,replayername)
end

function ClimbingTowerDataMgr:IsPlayRecord()
    return self.isPlayRecord,self.recordLevelId
end


function ClimbingTowerDataMgr:GetCurrentMaxFightingTime()
    return self.curMaxFightingTime
end

function ClimbingTowerDataMgr:BattleEnd(battleTime,isPlayRecord,timeStamp)
    if self.isPlayRecord then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE,Enum.UIPageName.UIClimbingTower)
        return
    end

    self:SendClimbingTowerEndReq(battleTime,self.curChallengeLevel,timeStamp)
end

return ClimbingTowerDataMgr