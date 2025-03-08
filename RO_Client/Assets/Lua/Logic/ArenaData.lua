local ArenaData = class("ArenaData",require("DataBase"))
local PlayerRankData = require("Rank/PlayerRankData")
local CreateActorSystem = require("CreateActorSystem")

function ArenaData:ctor()
    self.winRate = 0
    self.winCount = 0           --胜的次数
    self.totalCount = 0         --总战斗次数
    self.winStreakCount = 0     --连胜次数
    self.failStreakCount = 0    --连败次数
    self.lastDanScore = 0       --上次段位积分
    self.danScore = 0           --当前段位积分
    self.zoneId = 1

    self.dan = 0                --当前段位
    self.danIcon = ""           --当前段位ICON
    self.danName = ""           --当前段位名字
    self.danReward = nil        --当前段位奖励 
    self.winReward = nil        --胜利奖励
    self.failReward = nil       --失败奖励

    self.nextDanScore = 0       --下个段位需要的积分
    self.nextDanName = ""       --下一段位名字
    self.nextDanIcon = ""       --下一段位icon
    self.nextDanReward = nil    --下一段位奖励

    self.curSeasonId = 0        --当前赛季id   0是表示赛季为开始，1表示处于赛季中
    self.inSeason = false       --是否处于赛季中
    self.leftSeasonSeconds = 0  --本赛季剩余时长/距离下赛季开始时长 [s]
    self.curSeasonEndTime = 0       --当前赛季结束时间
    self.nextSeasonBeginTime = nil  --下赛季开始时间   

    self.leftTimes = 0          --今日剩余次数
    self.leftRewardTimes = 0    --今日剩下领取奖励次数
    self.leftBuyTimes = 0       --今日剩余可买次数
    self.battleActorIds = nil   --上阵角色
    self.actorTotalFightPower = 0   --上阵玩家总战斗力

    self.serverBattleActorIds = nil  --服务器保存的上阵角色ID

    self.curDanRankReward = nil     --当前段位的排名奖励

    self.curSeasonRank = 0      --当前赛季排名
    self.lastSeasonRank = 0     --上次赛季排名
    self.curSeasonRankReqIdx = 1     --当前赛季排名请求索引
    self.lastSeasonRankReqIdx = 1    --上次赛季排名请求索引
    self.curSeasonRankList = nil     --当前赛季排名列表
    self.lastSeasonRankList = nil    --上次赛季排名列表

    self.minTopScore = 0
    self.curShowRewardItemId = 0

    self.battleSceneName = "scenes_test_pvp"
    self.battleEndCondList = nil
end

function ArenaData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ARENA_NTF,self.OnArenaNtf,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ARENA_CHANGE_NTF,self.OnArenaChangeNtf,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ARENA_BUY_COUNT_ACK,self.OnArenaBuyCountAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ARENA_RANK_LIST_ACK,self.OnArenaRankListAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ARENA_MATCH_ACK,self.OnArenaMatchAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ARENA_RESULT_ACK,self.OnArenaResultAck,self)

end

function ArenaData:Clear()
    self.danReward = nil        
    self.winReward = nil        
    self.failReward = nil       
    self.battleActorIds = nil
    self.serverBattleActorIds = nil
    self.curDanRankReward = nil
    self.curSeasonRankList = nil
    self.lastSeasonRankList = nil
    self.battleEndCondList = nil
end

function ArenaData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function ArenaData:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_ARENA_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_ARENA_CHANGE_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_ARENA_BUY_COUNT_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_ARENA_RANK_LIST_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_ARENA_MATCH_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_ARENA_RESULT_ACK)
end

function ArenaData:InitArenaData(data)
    if data == nil then
        LogError("服务器发送数据为空")
        return
    end

    self.winCount = data.win_count
    self.totalCount = data.total_count
    self.danScore = data.score

    self.leftTimes = data.challenge_count
    self.leftRewardTimes = data.reward_count
    self.leftBuyTimes = data.buy_count
    self.curSeasonId = data.season_id
    self.curSeasonEndTime = data.season_end_time + 1
    self.nextSeasonBeginTime = data.next_season_start_time + 1
    self.minTopScore = data.minTopScore
    self.lastDanScore = self.danScore
    self.actorTotalFightPower = 0


    if data.self_hero_list~= nil  and #data.self_hero_list > 0 then
        self.serverBattleActorIds = data.self_hero_list
        self:SetBattleActorIds(data.self_hero_list)
    else
        self:ApplyNormalTeam()
    end

    self:UpdateWinRate()
    self:UpdateDan()
    self:UpdateSeasonInfo()
end

function ArenaData:ChangeArenaData(data)
    if data == nil then
        return
    end

    -- LogError(Inspect(data))

    if data.challenge_count ~= nil then
        self.leftTimes = data.challenge_count
        if self.leftTimes <= 0 then
            self.leftTimes = 0
        end
    end

    if data.reward_count ~= nil then
        self.leftRewardTimes = data.reward_count
    end

    if data.buy_count ~= nil then
        self.leftBuyTimes = data.buy_count
    end

    if data.win_count ~= nil then
        self.winCount = data.win_count
    end

    if data.total_count ~= nil then
        self.totalCount = data.total_count
    end

    if data.score ~= nil then
        self.lastDanScore = self.danScore
        self.danScore = data.score
    end

    if data.rank_idx ~= nil then
        self.curSeasonRank = data.rank_idx
    end

    if data.win_streak_count ~= nil then
        self.winStreakCount = data.win_streak_count     --连胜次数
    end

    if data.fail_streak_count ~= nil then
        self.failStreakCount = data.fail_streak_count    --连败次数
    end

    if data.season_id ~= nil then
        self.curSeasonId = data.season_id
        self:UpdateSeasonInfo()
    end

    if data.minTopScore ~= nil then
        self.minTopScore = data.minTopScore
    end

    self:UpdateWinRate()
    self:UpdateDan()
end

function ArenaData:UpdateWinRate()
    if self.totalCount == 0 then
        self.winRate = 0
    else
        self.winRate = self.winCount / self.totalCount
    end
end

function ArenaData:UpdateDan()
    local levelCfg, nextKey = CommonUtil.GetCurDunData(self.danScore)
    self.dan = levelCfg.ArenaLevelId
    self.danIcon = levelCfg.LevelIcon
    self.danName = levelCfg.ArenaLevelName
    self.danReward = levelCfg.ArenaLevelReward
    self.winReward = levelCfg.WinReward
    self.failReward = levelCfg.FailReward
    self.nextDanScore = levelCfg.ArenaLevelScore

    if nextKey > 0 then
        local cfg = ManagerContainer.CfgMgr:GetArenaLevelById(nextKey)
        if cfg ~= nil then
            --self.nextDanScore = cfg.ArenaLevelScore
            self.nextDanReward = cfg.ArenaLevelReward
            self.nextDanName = cfg.ArenaLevelName
            self.nextDanIcon = cfg.LevelIcon      --下一段位icon
        else
            --self.nextDanScore = levelCfg.ArenaLevelScore
            self.nextDanReward = levelCfg.ArenaLevelReward
            self.nextDanName = levelCfg.ArenaLevelName
            self.nextDanIcon = levelCfg.LevelIcon
        end
    end

     --LogError(" dan = " .. self.dan .. " danScore = " .. self.danScore .. " danName = " .. self.danName .. " nextDanScore = ".. self.nextDanScore)
end

function ArenaData:GetCurDanInfo()    
    if nil ~= self.self_rank_score then
        local levelCfg, nextKey = CommonUtil.GetCurDunData(self.self_rank_score)
        return levelCfg.LevelIcon,levelCfg.ArenaLevelName
    else
        return self.danIcon, self.danName
    end
end

function ArenaData:GetLastCurDanInfo()
    if nil ~= self.self_lastrank_score then
        local levelCfg, nextKey = CommonUtil.GetCurDunData(self.self_lastrank_score)
        return levelCfg.LevelIcon,levelCfg.ArenaLevelName
    else
        return self.danIcon, self.danName
    end    
end

function ArenaData:GetCurDanInfoByRank(rankType)
    if rankType == 0 and self:InSeason() then    --在赛季
        return self:GetCurDanInfo()
    elseif rankType == 0 then--不在赛季
        return self.danIcon, self.danName
    elseif rankType == 1 then--上个赛季
        return self:GetLastCurDanInfo()
    end
end

--function ArenaData:GetCurDanInfo()
--    return self.danIcon, self.danName
--end

function ArenaData:GetCurDanScore()
    return self.danScore
end

function ArenaData:GetCurShowRewardItemId()
    return self.curShowRewardItemId
end

function ArenaData:UpdateSeasonInfo()
    if self.curSeasonId == nil then
        return
    end
    
    local rewardDatas = ManagerContainer.CfgMgr:GetArenaRewardDatas()
    -- LogError("-----UpdateSeasonInfo " .. #rewardDatas)

    self.curDanRankReward = {}
    for i= 1, #rewardDatas do
        local rewardCfg = rewardDatas[i]
        if rewardCfg~= nil and rewardCfg.Zone == self.zoneId then
            local item = {}
            item.rankId = rewardCfg.RankId
            if rewardCfg.ArenaRank~= nil then
                if #rewardCfg.ArenaRank == 1 then
                    item.minLevel = rewardCfg.ArenaRank[1]
                    item.maxLevel = item.minLevel
                elseif #rewardCfg.ArenaRank == 2 then
                    item.minLevel = rewardCfg.ArenaRank[1]
                    item.maxLevel = rewardCfg.ArenaRank[2]
                end
            end

            local itemList = {}
            if rewardCfg.ArenaReward ~= nil then
                for i =1, #rewardCfg.ArenaReward do
                    local rewardTbl = rewardCfg.ArenaReward[i]
                    itemList[#itemList+1] = rewardTbl
                end
            end

            item.itemList = itemList

            self.curDanRankReward[#self.curDanRankReward+1] = item
            if rewardCfg.ShowReward > 0 then
                self.curShowRewardItemId = rewardCfg.ShowReward
            end
        end
    end

    -- self.inSeason = LuaBattleBridge.InSeason(self.seasonBeginTime,self.seasonEndTime)
    self.inSeason = self.curSeasonId > 0
    if self.inSeason then
        self.leftSeasonSeconds =LuaBattleBridge.CaclLeftTimeWitTimeStamp(tostring(self.curSeasonEndTime))
    else
        if self.nextSeasonBeginTime ~= nil then
            self.leftSeasonSeconds = LuaBattleBridge.CaclLeftTimeWitTimeStamp(tostring(self.nextSeasonBeginTime))
        else
            self.leftSeasonSeconds = 2592001
        end
    end

    self:CleanSeasonTimer()
    if self.leftSeasonSeconds > 0 then
        self.leftTimeTimer = ManagerContainer.LuaTimerMgr:AddTimer(1000, self.leftSeasonSeconds, self, self.OnRefreshSeasonTime, nil)
    end

    -- LogError("self.seasonBeginTime = " .. self.seasonBeginTime .. " self.seasonEndTime = " .. self.seasonEndTime .. " self.inSeason = " .. tostring(self.inSeason) .. " self.leftSeasonSeconds = " ..self.leftSeasonSeconds)
end

function ArenaData:InSeason()
    return self.inSeason
end

function ArenaData:GetLeftTime()
    return self.leftSeasonSeconds
end

function ArenaData:TimeOver()
    --self.curSeasonId = nil
    if self.inSeason then--赛季结束
        self.inSeason = false       
    else--赛季开始
        self.inSeason = true         
    end   
     --刷新下赛季时间
     --LogError("Send Arena Req.........")
     ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ARENA_REQ, {})
    --刷新赛季结果
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Arena_Season_End)
end

function ArenaData:OnRefreshSeasonTime()   
    self.leftSeasonSeconds = self.leftSeasonSeconds -1
    if tonumber(self.leftSeasonSeconds) == 0 then
        self:TimeOver()
        self:CleanSeasonTimer()
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Arena_Season_LeftTime,self.leftSeasonSeconds)
end

function ArenaData:CleanSeasonTimer()
    if self.leftTimeTimer ~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.leftTimeTimer)
        self.leftTimeTimer = nil
    end
end

function ArenaData:GetDanRankReward()
    return self.curDanRankReward
end

function ArenaData:ApplyNormalTeam()
    self.battleActorIds = {};
    local teamData = ManagerContainer.DataMgr.UserData:GetTeamData(true)
    for i=1,#teamData do
        self:OnBattle(teamData[i].uid)
    end
end

function ArenaData:SetBattleActorIds(actorIds)
    if actorIds == nil then
        return
    end

    self.battleActorIds = {}
    for i = 1, #actorIds do
        self.battleActorIds[#self.battleActorIds+1] = actorIds[i]
        local fightPower = ManagerContainer.DataMgr.UserData:GetSlotFightPower(actorIds[i])
        self.actorTotalFightPower = self.actorTotalFightPower + fightPower
    end
end

function ArenaData:GetWinRate()
    return self.winRate
end

function ArenaData:GetLeftTimes()
    return self.leftTimes
end

function ArenaData:GetLeftRewardTimes()
    return self.leftRewardTimes
end

function ArenaData:GetLeftBuyTimes()
    return self.leftBuyTimes
end

function ArenaData:GetTeamActorIds()
    return self.battleActorIds
end

function ArenaData:GetTeamFighterPower()
    return self.actorTotalFightPower
end

function ArenaData:OnBattle(actorId)
    if self.battleActorIds == nil then
        self.battleActorIds = {}
    end

    if self:CurMemberCnt() >= 4  then
        return
    end

    if self:IsInBattleTeam(actorId) then
        return
    end

    self.battleActorIds[#self.battleActorIds + 1] = actorId
    local fightPower = ManagerContainer.DataMgr.UserData:GetSlotFightPower(actorId)
    self.actorTotalFightPower = self.actorTotalFightPower + fightPower
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Arena_Team_FightPower)
end

function ArenaData:OffBattle(actorId)
    if self.battleActorIds == nil then
        return
    end

    local removed = false
    for i=1, #self.battleActorIds do
        if self.battleActorIds[i] == actorId then
            local fightPower = ManagerContainer.DataMgr.UserData:GetSlotFightPower(actorId)
            self.actorTotalFightPower = self.actorTotalFightPower - fightPower
            table.remove(self.battleActorIds, i)
            removed = true;
            return
        end
    end

    if removed then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Arena_Team_FightPower)
    end
end

function ArenaData:ReplaceBattleActorId(orgUid,newUid)
    if self.battleActorIds == nil then
        return
    end

    local changed = false
    for i=1, #self.battleActorIds do
        if self.battleActorIds[i] == orgUid then
            local fightPower = ManagerContainer.DataMgr.UserData:GetSlotFightPower(orgUid)
            self.actorTotalFightPower = self.actorTotalFightPower - fightPower
            self.battleActorIds[i] = newUid

            fightPower = ManagerContainer.DataMgr.UserData:GetSlotFightPower(newUid)
            self.actorTotalFightPower = self.actorTotalFightPower + fightPower
            changed = true
            break;
        end
    end

    if changed then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Arena_Team_FightPower)
    end
end

function ArenaData:IsInBattleTeam(actorId)
    if self.battleActorIds == nil then
        return false
    end

    for i = 1, #self.battleActorIds do
        local memberId = self.battleActorIds[i]
        if tostring(memberId)  == tostring(actorId) then
            return true
        end
    end

    return false
end

function ArenaData:CurMemberCnt()
    if self.battleActorIds == nil then
        return 0
    end

    return #self.battleActorIds
end

function ArenaData:GetSeasonRanList(rankType)
    if rankType == 0 and self.inSeason then    
        return self.curSeasonRankList
    elseif rankType == 1 then
        return self.lastSeasonRankList
    end
    return nil
end

function ArenaData:GetSelfSeasonScore(rankType)
    if rankType == 0 and self.inSeason then    
        return self.danScore
    elseif rankType == 1 then
        return  self.self_lastrank_score or 0
    end
    return 0
end

function ArenaData:GetRank(rankType) 
    if rankType == 0 then
        -- LogError("self.minTopScore = " .. self.minTopScore .. " self.curSeasonRank = " .. self.curSeasonRank)
        if self.danScore < self.minTopScore and self:InSeason() == false then
            return 0
        else
            return self.curSeasonRank
        end
    else
        return self.lastSeasonRank
    end
end

function ArenaData:SendArenaDataReq(fromUIId, backUIId)
    self.fromUIId = fromUIId
    self.backUIId = backUIId
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ARENA_REQ, {})
end

function ArenaData:OnArenaNtf(data)
    --LogError("--------------------OnArenaNtf----------------" .. Inspect(data))
    self:InitArenaData(data)
    if self.fromUIId == Enum.UIPageName.UISeason or self.fromUIId == Enum.UIPageName.UIRoleMessage then
        --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SEASON_SELECTION_NTF)
    elseif self.fromUIId == Enum.UIPageName.UIDojo2D then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojo2D,nil, self.backUIId or Enum.UIPageName.UIMainCity1)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_CLOSE_TASK_PAGE)
    end

    self.fromUIId = nil
    self.backUIId = nil
end

function ArenaData:OnArenaChangeNtf(data)
    --LogError("--------------------OnArenaChangeNtf----------------"..Inspect(data))
    self:ChangeArenaData(data)    
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Arena_Data_Change)
end

function ArenaData:SendBuyTimesReq(cnt)
    if cnt == 0 then
        return
    end

    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ARENA_BUY_COUNT_REQ, {buy_count=cnt})
end

function ArenaData:OnArenaBuyCountAck(data)
    -- if data.error ~= nil and data.error > 0 then
    --     LogError("OnArenaBuyCountAck " .. data.error)
    -- end
end

function ArenaData:SendArenaRankReq(rankType,startIdx)
    if self.isRequestingRank == true then
        return    
    end

    -- 上赛季
    if rankType == 1 then
        if self.lastSeasonRankReqIdx >= 10 then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Arena_Season_Rank_List,rankType)
            return
        end
    end

    self.isRequestingRank = true
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ARENA_RANK_LIST_REQ, {rank_type = rankType, start_idx = startIdx})

    self.cancelTimerId =  ManagerContainer.LuaTimerMgr:AddTimer(2000, 1, self, self.CancelRequestingRankStatus, nil)
end

function ArenaData:OnArenaRankListAck(data)
    --LogError("------OnArenaRankListAck--" .. Inspect(data))
    self.isRequestingRank = false
    if self.cancelTimerId ~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.cancelTimerId);
        self.cancelTimerId = nil
    end

    if data.error ~= nil and data.error > 0 then
        return
    end

    if data.rank_type == 0 then   
        self:SaveCurSeasonRankData(data.rank_list,data.self_rank,data.start_idx,data.self_rank_score)
    elseif data.rank_type == 1 then
        self:SaveLastSeasonRankData(data.rank_list,data.self_rank,data.start_idx,data.self_rank_score)
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Arena_Season_Rank_List,data.rank_type)
end

function ArenaData:SaveCurSeasonRankData(rank_list,self_rank,start_idx,self_rank_score)
    self.curSeasonRankReqIdx = start_idx
    
    if self_rank ~= nil then
        self.curSeasonRank = self_rank
    end

    if self_rank_score ~= nil then
        self.self_rank_score = self_rank_score
    end

    if rank_list ~= nil then
        if self.curSeasonRankList == nil then
            self.curSeasonRankList = {}
        end

        for i=1, #rank_list do
            local rankData = rank_list[i]
            local playerRank =  PlayerRankData:new(rankData.rank,rankData.brief_info,rankData.score);
            local idx = (self.curSeasonRankReqIdx-1)*10+i
            self.curSeasonRankList[idx] = playerRank
        end
    end
end

function ArenaData:SaveLastSeasonRankData(rank_list,self_rank,start_idx,self_rank_score)
    self.lastSeasonRankReqIdx = start_idx

    if self_rank ~= nil then
        self.lastSeasonRank = self_rank
    end

    if self_rank_score ~= nil then
        self.self_lastrank_score = self_rank_score
    end

    if rank_list ~= nil then
        if self.lastSeasonRankList == nil then
            self.lastSeasonRankList = {}
        end

        for i=1, #rank_list do
            local rankData = rank_list[i]
            local playerRank =  PlayerRankData:new(rankData.rank,rankData.brief_info,rankData.score);
            local idx = (self.lastSeasonRankReqIdx-1)*10+i
            self.lastSeasonRankList[idx] = playerRank
        end
    end
end

function ArenaData:CancelRequestingRankStatus()
    self.isRequestingRank = false
    self.cancelTimerId = nil
end

function ArenaData:SetReward(zeny,cruise)
    self.zeny = zeny
    self.cruise = cruise
end

function ArenaData:GetEnemyMembers()
    return self.enemyActors
end

function ArenaData:GetOurMembers()
    return self.ourMembers
end

function ArenaData:GetBattleSceneName()
    return self.battleSceneName
end

function ArenaData:GetBattleEndConds()
    return self.battleEndCondList
end

function ArenaData:GetMatchFighterName()
    return self.matchFighterName
end

-- 发送匹配请求
function ArenaData:SendMatchReq(battleActorIds)
    if ManagerContainer.DataMgr.ArenaData:CurMemberCnt() <= 0 then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("至少需要一名角色参战!")
        return
    end

    if ManagerContainer.DataMgr.ArenaData:GetLeftTimes() <= 0 then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("今日剩余次数为0，请明天再来!")
        return
    end
 
    self.matchFailed = false
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ARENA_MATCH_REQ, {hero_list=battleActorIds})
end


function ArenaData:OnArenaMatchAck(data)
    if data.error ~= 0 then
        self.enemyActors = {}
        self.matchFailed = true
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("竞技场匹配失败!")
        return
    end

    LogHRWarning(Inspect(data))
    -- repress_skill_pvp_val
    ManagerContainer.LuaGameMgr:RefreshTeamData()
    local actorSystem = CreateActorSystem:new()
    actorSystem:ParseFightRoleInfo(data.fight_info)
    LogHRWarning(Inspect(actorSystem.userData))
    if not actorSystem.userData.inited then
        self.enemyActors = {}
        self.matchFailed = true
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("竞技场匹配失败!")
        return
    end

    self.matchFighterName = actorSystem:GetUserNickname()

    self.enemyActors = {}

    if actorSystem:GetPlayerActorParam()~= nil then
        self.enemyActors[#self.enemyActors+1] = actorSystem:GetPlayerActorParam()
    end

    local fellowActors = actorSystem:GetFellowActorParam()
    if fellowActors~= nil then
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

	if self.battleActorIds~= nil then
		self.ourMembers = {}
		for i = 1, #self.battleActorIds do
			local actor = ManagerContainer.LuaActorDataMgr:GetActorsById(self.battleActorIds[i])
			if actor ~= nil then
				self.ourMembers[#self.ourMembers+1] = actor
			end
		end
	end

    self:InitEndBattleCondition()
    ManagerContainer.LuaGameMgr:EnterDojo(self:GetBattleSceneName(), self:GetOurMembers(), self:GetEnemyMembers(), selfMaskDatas,IsPresspoint,OurPvPVal+enemyPvPVal,self:GetBattleEndConds())
end



function ArenaData:InitEndBattleCondition()
    if self.battleEndCondList ~= nil then
        return
    end

    self.battleEndCondList = System.Array.CreateInstance(Enum.TypeInfo.BattleEndCondition, 1)
    self.battleEndCondList[0] = BattleEndCondition.New(Constants.EndBattle_By_UndeadCount,Constants.ResultType_Normal)
end

-- //挑战结果(失败/成功)//0失败，1成功
function ArenaData:SendBattleResultReq(result)
    self.result = result
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ARENA_RESULT_REQ, {fight_result=result})
end

function ArenaData:OnArenaResultAck(data)
    -- LogError("----OnArenaResultAck---" .. Inspect(data))
    local zeny = 0
    local cruise = 0
    if data.reward_list ~= nil then
        for i =1, #data.reward_list do
            local item = data.reward_list[i];
            if item.key == Enum.ItemType.Coin then
                zeny =  item.value
            elseif item.key == Enum.ItemType.HeroSpirit then
                cruise = item.value
            end
        end    
    end
    self:SetReward(zeny,cruise)
    
    if self.result == 1 then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoBattleWin,{data.old_score,data.cur_score})
    else
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoBattleFail,{data.old_score,data.cur_score})
    end

    ManagerContainer.DataMgr.RankActivitiesMgr:QueryCurRankActivityData(Enum.RankActivitiesType.Dojo)
end

function ArenaData:BattleEnd(result)
    self:SendBattleResultReq(result)
    self.enemyActors = nil
    self.ourMembers = nil
end

return ArenaData