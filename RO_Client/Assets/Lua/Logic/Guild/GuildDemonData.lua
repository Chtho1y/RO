local GuildDemonData = class('GuildDemonData',require("DataBase"))
local PlayerInfoReqLimit = 10
local PlayerInfoMaxLimit = 50
function GuildDemonData:ctor()
    self.SommonId = 0
    self.GuildRankReqPage = 1
    self.GuildMvpRankReqPage = 1
end

function GuildDemonData:InitData(data)

end


function GuildDemonData:StartGuildDemonBattle()
    local demoBattleInfo = self.demoBattleInfo
    if demoBattleInfo and demoBattleInfo.isBattling then
        return
    end
    local demonId = self:GetdemonId()
    local bossCfgData = ManagerContainer.CfgMgr:GetGuildDemonCfgCfgById(demonId)
    if not bossCfgData then return end
    if not demoBattleInfo then
        demoBattleInfo = {}
        self.demoBattleInfo = demoBattleInfo
    end
    demoBattleInfo.bossId = demonId
    demoBattleInfo.hurtValue = 0

    local teams = ManagerContainer.DataMgr.UserData:GetTeamData(true)
    local ourActors = System.Array.CreateInstance(Enum.TypeInfo.ActorData, #teams)
    for i = 1 , #teams do
        local actor = ManagerContainer.LuaActorDataMgr:GetActorsById(teams[i].uid,teams[i].id)
         --增加对应压制mark
         ManagerContainer.DataMgr.UserData:SetActorPveMark(teams[i].uid,actor)
        ourActors[i - 1] = actor
    end

    local enemyActors = System.Array.CreateInstance(Enum.TypeInfo.ActorData, 1)
    local bossLv = ManagerContainer.DataMgr.GuildDemonData:GetBossLv()
	local npcId = bossCfgData.SummonId or 0
    self.SommonId = npcId
    local npcCfgData = ManagerContainer.CfgMgr:GetNpcCfgById(npcId)
    if not npcCfgData then
        LogError("策划配表问题  怪物ID不存在 "..npcId)
        return
    end
    local actor = ManagerContainer.LuaActorDataMgr:CreateNpc(10001, npcId, 1, npcCfgData.BaseLv)
    actor.IsBoss = (npcCfgData.NpcType == 2)
    actor.IgnoreLife = true
    enemyActors[0] = actor


    local battleEndCondList = System.Array.CreateInstance(Enum.TypeInfo.BattleEndCondition, 2)
    battleEndCondList[0] = BattleEndCondition.New(Constants.EndBattle_By_UndeadCount,Constants.ResultType_Normal)
    battleEndCondList[1] = BattleEndCondition.New(Constants.EndBattle_By_BattleTime,bossCfgData.BattleTime,Constants.ResultType_Special,true)

    ManagerContainer.LuaGameMgr:EnterGuildHuntExBattle(bossCfgData.SummonScence, nil, bossCfgData.BattleTime, ourActors, enemyActors, battleEndCondList)
end

function GuildDemonData:RefreshRewardRankData()
    local demonId = self:GetdemonId()
    local demonData = ManagerContainer.CfgMgr:GetGuildDemonCfgCfgById(demonId)
    if not demonData then
        return
    end
    local totalHarm = self:GettotalHarm()
    local HarmSection = CommonUtil.DeserializeGlobalStrToNumberTable(demonData.DamageSegment)
    if HarmSection and #HarmSection > 0 then
        if totalHarm > HarmSection[#HarmSection][2]  then
            self.DemonData.currRewardRank = HarmSection[#HarmSection][1]
            self.DemonData.nextRewardRank = HarmSection[#HarmSection][1] + 1
            return
        end
        for i = 1, #HarmSection - 1 do
            local lastvalue = HarmSection[i][2]
            local nextvalue = HarmSection[i][3]
            if totalHarm >= lastvalue and totalHarm <= nextvalue then
                self.DemonData.currRewardRank = HarmSection[i][1]
                self.DemonData.nextRewardRank = HarmSection[i][1] + 1
                -- if i == #HarmSection then
                --     self.DemonData.nextRewardRank = 0
                -- end
                break
            end
        end
    end
end

function GuildDemonData:StopGuildDemonBattle(isPlayRecord, battleTime)
    if isPlayRecord then
        self:ExitDemonBattle()
        return
    end
    if self.demoBattleInfo then
        if self.demoBattleInfo.timeOut then
            self.demoBattleInfo.timeOut:Stop()
            self.demoBattleInfo.timeOut = nil
        end
        self.demoBattleInfo.timeOut = Timer.New(function()
            self:ExitDemonBattle()
        end, 10)
        self.demoBattleInfo.timeOut:Start()
    end
    local bossId = self.demoBattleInfo.bossId
    local bossCfgData = ManagerContainer.CfgMgr:GetGuildDemonCfgCfgById(bossId)
    local hurtValue = Mathf.Floor(self:GetRecordDemonValue())
    self:SendGuildDemonBossChallengeReq(bossId, hurtValue, Mathf.Round(battleTime))
end

function GuildDemonData:RecordDemonValueChanged(hurtValue)
    if not hurtValue or hurtValue <= 0 then return end
    if not self.demoBattleInfo then return end
    self.demoBattleInfo.hurtValue = self.demoBattleInfo.hurtValue + hurtValue
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_HUNT_BOSS_HURT_CHANGED,true)
end

function GuildDemonData:ExitDemonBattle()
    if self:HasGuild() then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildDemon, nil, Enum.UIPageName.UIMainCity1)
    else
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIMainCity1, nil, false)
        if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIMain) then
            ManagerContainer.LuaUIMgr:Back2NormalBattleMain(Enum.MainViewPageType.Town)
        end
    end
    self:DisposeGuildDemonBattle()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE)
end

function GuildDemonData:OpenDemonBattleRewardView()
    if self.demoBattleInfo and self.demoBattleInfo.timeOut then
        self.demoBattleInfo.timeOut:Stop()
        self.demoBattleInfo.timeOut = nil
    end
    local rewards = self.demoBattleInfo and self.demoBattleInfo.rewards or {cfgId = 2, num = 1000}
    local data = require('ExecuteSequenceData'):new()
    data:AppendUIListener(Enum.UIPageName.UIPOPGot, UIEventNames.UI_FILLCONTENT_COMPELETED, 5)
    data:AppendFuncAfterListener(false,  ManagerContainer.LuaUIMgr,  ManagerContainer.LuaUIMgr.Open, Enum.UIPageName.UIPOPGot, {rewards = rewards})
    data:AppendUIListener(Enum.UIPageName.UIPOPGot, UIEventNames.UI_PAGE_OUT_END_NTF)
    data:AppendFunc(true, self, self.ExitDemonBattle)
    ManagerContainer.ExecuteSequenceMgr:Execute(data)
end

function GuildDemonData:DisposeGuildDemonBattle()
    if self.demoBattleInfo and self.demoBattleInfo.timeOut then
        self.demoBattleInfo.timeOut:Stop()
        self.demoBattleInfo.timeOut = nil
    end
    self.demoBattleInfo = nil
end

function GuildDemonData:GetRecordDemonValue()
    if not self.demoBattleInfo then return 0 end
    return self.demoBattleInfo.hurtValue or 0
end

function GuildDemonData:HasGuild()
    return ManagerContainer.DataMgr.GuildDataMgr:GetGuildDataState() == Enum.GuildDataState.HasGuild
end


-- function GuildDemonData:GetNextLvDay()
--     return self.DemonData and self.DemonData.nextLvDay or 0
-- end

function GuildDemonData:GetcurrRank()
    return self.DemonData and self.DemonData.currRewardRank or 0
end

function GuildDemonData:GetnextRank()
    return self.DemonData and self.DemonData.nextRewardRank or 0
end

function GuildDemonData:GetdemonId()
    return self.DemonData and self.DemonData.demonId or 0
end

function GuildDemonData:GetbuyCount()
    return self.DemonData and self.DemonData.buyCount or 0
end

function GuildDemonData:GetfightCount()
    return self.DemonData and self.DemonData.fightCount or 0
end

function GuildDemonData:GettotalHarm()
    return self.DemonData and self.DemonData.totalHarm or 0
end

function GuildDemonData:GetmyHarm()
    return self.DemonData and self.DemonData.myHarm or 0
end

function GuildDemonData:GetmvpHarm()
    return self.DemonData and self.DemonData.mvpHarm or 0
end

function GuildDemonData:GetmvpInfo()
    return self.DemonData and self.DemonData.mvpInfo
end

function GuildDemonData:GetMyGuildRankList()
    return self.DemonData and self.DemonData.allPlayerData
end

function GuildDemonData:GetSommonId()
    return self.SommonId
end


function GuildDemonData:GetGuildInfos()
    return self.GuildRankData and self.GuildRankData.allGuildInfos or {}
end

function GuildDemonData:GetGuildInfosLength()
    return self.GuildRankData and self.GuildRankData.allGuildInfos and #self.GuildRankData.allGuildInfos or 0
end

function GuildDemonData:GetGuildMvpInfos()
    return self.GuildMvpRankData and self.GuildMvpRankData.allMvpInfos or {}
end

function GuildDemonData:GetGuildMvpInfosLength()
    return self.GuildMvpRankData and self.GuildMvpRankData.allMvpInfos and #self.GuildMvpRankData.allMvpInfos or 0
end

function GuildDemonData:GetPlayerInfoLimit()
    return self.DemonData.PlayerInfoReqLimit and self.PlayerInfoReqLimit or 0
end

function GuildDemonData:GetGuildRankMvpLimit()
    return self.GuildMvpRankData and self.GuildMvpRankData.GuildRankMvpReqLimit or 5
end

function GuildDemonData:GetGuildRankLimit()
    return self.GuildRankData and self.GuildRankData.GuildRankReqLimit or 0
end

function GuildDemonData:GetBossEndTime()
    return self.DemonData and self.DemonData.endTime or 0
end

function GuildDemonData:GetBossLv()
    return self.DemonData and self.DemonData.bossLv or 1
end


function GuildDemonData:GetPlayerInfos()
    return self.DemonData and self.DemonData.playerInfos
end

function GuildDemonData:GetPlayerInfosLength()
    return self.DemonData and self.DemonData.playersLength or 0
end

function GuildDemonData:GetMvpInfos()
    return self.GuildMvpRankData and self.GuildMvpRankData.mvpBirefInfos
end

function GuildDemonData:GetMvpInfosLength()
    return self.GuildMvpRankData and self.GuildMvpRankData.mvpsLength or 0
end

function GuildDemonData:GetRankSelfGuildBrief()
    return self.GuildRankData and self.GuildRankData.selfGuildInfo
end

function GuildDemonData:GetRankSelfMvpBrief()
    return self.GuildMvpRankData and self.GuildMvpRankData.selfMvpBrief
end

function GuildDemonData:GetRankSelfMvpInfo()
    return self.GuildMvpRankData and self.GuildMvpRankData.selfMvpInfo
end

function GuildDemonData:OnGuildDemonInfoAck(data)
    if data  then
        if not self.DemonData then
            self.DemonData = {}
            self.DemonData.playerReqIndex = 0
            self.DemonData.PlayerInfoReqLimit = GlobalConfig.Instance:GetConfigIntValue(338) or 50
        end
        self.DemonData.demonId = data.demon_id  or 0
        -- local servertime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
        -- local time = (data.next_up_time - servertime)/1000/60/60
        -- time = type(time) == "number" and time or #time
        -- self.DemonData.nextLvDay = math.ceil(time / 24) or 0
        self.DemonData.bossLv  = data.demon_level or 0
        self.DemonData.endTime  = data.end_time or 0
        self.DemonData.fightCount = data.left_fight_count or 0
        self.DemonData.buyCount = data.left_buy_count or 0
        self.DemonData.totalHarm = (type(data.total_boss_damage) == "number" and data.total_boss_damage or #data.total_boss_damage) or 0
        self.DemonData.myHarm =   (type(data.damage) == "number" and data.damage or #data.damage) or 0
        self.DemonData.mvpHarm = (type(data.mvp_damage) == "number" and data.mvp_damage or #data.mvp_damage) or 0
        if data.mvp_brief then
            self.DemonData.mvpInfo = data.mvp_brief
        end
        local ranklist = data.rank_list
        if ranklist and #ranklist > 0 then
            table.sort(ranklist,function(a,b)
                if a.damage == b.damage then
                    return a.fight_time < b.fight_time
                else
                    return a.damage > b.damage
                end
            end)
        end
        local allPlayerData = {}
        self.DemonData.playerInfos = {}
        self.DemonData.playersLength = 0
        for i = 1, #ranklist do
            local rank = ranklist[i]
            table.insert(allPlayerData,{rank = i,damage = rank.damage,uid = rank.uid})
        end
        self.isCanSendInfoReq = true
        self.DemonData.allPlayerData = allPlayerData
        self.DemonData.PlayerInfoReqLimit = self.DemonData.allPlayerData and #self.DemonData.allPlayerData or 0
        local uids = self:GetPlayerUids()
        self:SendGetGuildMemberInfoReq(Enum.FriendTogglePageType.GuildDemonPlayerInfo,uids)
        self:RefreshRewardRankData()
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_DEMON_VIEW_INFO) 
    end
end

function GuildDemonData:GetPlayerUids()
    local uids = {}
    local data =  self:GetMyGuildRankList()
    local lastReqIndex = self:GetPlayerInfosLength()
    for i = lastReqIndex, lastReqIndex + PlayerInfoReqLimit do
        if data[i] then
            table.insert(uids,data[i].uid)
        end
    end
    return uids
end

function GuildDemonData:OnGuildPlayerBriefInfoAck(data)
    self.isCanSendInfoReq = true
    if data then
        if not self.DemonData then
            self.DemonData = {}
        end
        if not self.DemonData.playerInfos then
            self.DemonData.playerInfos = {}
            self.DemonData.playersLength = 0
        end
        if data.type == Enum.FriendTogglePageType.GuildDemonPlayerInfo then
            local brief_info = data.brief_info
            if brief_info and #brief_info > 0 then
                local list = self.DemonData.playerInfos
                for i = 1, #brief_info do
                    local info = brief_info[i]
                    if not list[info.uid] then
                        self.DemonData.playersLength = self.DemonData.playersLength + 1
                    end
                    list[info.uid] = info
                end
            end
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_DEMON_PLAYER_RANK_INFO) 
        elseif data.type == Enum.FriendTogglePageType.GuildDemonMvpInfo then
            local brief_info = data.brief_info
            if brief_info and #brief_info > 0 then
                local list = self.GuildMvpRankData.mvpBirefInfos
                for i = 1, #brief_info do
                    local info = brief_info[i]
                    if not list[info.uid] then
                        self.GuildMvpRankData.mvpsLength = self.GuildMvpRankData.mvpsLength + 1
                    end
                    list[info.uid] = info
                end
            end
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_DEMON_RANK_INFO)
        end
    end
end

function GuildDemonData:OnGuildDemonFightAck(data)
    if data and data.error == 0 then
        if not self:HasGuild() then return end
        if self.demoBattleInfo and self.demoBattleInfo.bossId == data.demon_id then
            local rewards = {}
            for i = 1, #data.base_reward do
                local reward = data.base_reward[i]
                rewards[#rewards + 1] = {cfgId = reward.key, num = reward.value}
            end
            self.demoBattleInfo.rewards = rewards
        end
        if not self.DemonData then
            self.DemonData = {}
        end
        self.DemonData.fightCount = data.left_fight_count or 0
        self.DemonData.demonId = data.demon_id  or 0
        self.DemonData.totalHarm = (type(data.total_damage) == "number" and data.total_damage or #data.total_damage) or 0
        self.DemonData.myHarm =   (type(data.self_damage) == "number" and data.self_damage or #data.self_damage) or 0
        self:OpenDemonBattleRewardView()
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_DEMON_VIEW_INFO) 
    end
end

function GuildDemonData:OnGuildBuyFightCountAck(data)
    if data and data.error == 0 then
        self.DemonData.fightCount = data.left_fight_count or 0
        self.DemonData.buyCount = data.left_buy_count  or 0
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_DEMON_FIGHT_VIEW_INFO) 
    end
end


function GuildDemonData:OnGuildDemonGuildRankAck(data)
    if data and data.error == 0 then
        if not self.GuildRankData then
            self.GuildRankData = {}
            self.GuildRankData.allGuildInfos = {}
            self.GuildRankData.GuildRankReqLimit = GlobalConfig.Instance:GetConfigIntValue(338) or 50
        end
        if data.self_guild then
            self.GuildRankData.selfGuildInfo = data.self_guild
        end
        local ranklist = data.rank_list
        if ranklist and #ranklist > 0 then
            for i = 1, #ranklist do
                table.insert(self.GuildRankData.allGuildInfos,{rank = ranklist[i].rank,damage = ranklist[i].damage,brief = ranklist[i].data.brief})
            end
            self.GuildRankReqPage = self.GuildRankReqPage + 1
        end
        if data.is_end then
            self.GuildRankData.GuildRankReqLimit = self.GuildRankData.allGuildInfos and #self.GuildRankData.allGuildInfos or 0
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_DEMON_RANK_INFO)
    end
end

function GuildDemonData:OnGuildDemonMvpRankAck(data)
    if data and data.error == 0 then
        if not self.GuildMvpRankData then
            self.GuildMvpRankData = {}
            self.GuildMvpRankData.allMvpInfos = {}
            self.GuildMvpRankData.mvpBirefInfos = {}
            self.GuildMvpRankData.refreshBriefInfoCount = 1
            self.GuildMvpRankData.mvpsLength = 0
            self.GuildMvpRankData.GuildRankMvpReqLimit = GlobalConfig.Instance:GetConfigIntValue(338) or 50
        end
        if data.self_guild_mvp then
            self.GuildMvpRankData.selfMvpInfo = data.self_guild_mvp
        end
        if data.mvp_brief then
            self.GuildMvpRankData.selfMvpBrief = data.mvp_brief
        end
        local ranklist = data.rank_list
        local uids = {}
        if ranklist and #ranklist > 0 then
            for i = 1, #ranklist do
                table.insert(self.GuildMvpRankData.allMvpInfos,{rank = ranklist[i].rank,damage = ranklist[i].damage,guildName = ranklist[i].guild_name,guildBadeg = ranklist[i].guild_badge,uid = ranklist[i].uuid})
                table.insert(uids,ranklist[i].uuid)
            end
            self.GuildMvpRankReqPage = self.GuildMvpRankReqPage + 1
        end
        self.isCanSendInfoReq = true
        self:SendGetGuildMemberInfoReq(Enum.FriendTogglePageType.GuildDemonMvpInfo,uids)
        if data.is_end then
            self.GuildMvpRankData.GuildRankMvpReqLimit = self.GuildMvpRankData.allMvpInfos and #self.GuildMvpRankData.allMvpInfos or 0
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_DEMON_RANK_INFO)
    end
end

function GuildDemonData:RegisterNetEvents()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.GUILD_DEMON_GET_OTHER_PLAYER_BRIEF_INFO_ACK,self,self.OnGuildPlayerBriefInfoAck)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_DEMON_INFO_ACK, self.OnGuildDemonInfoAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_DEMON_FIGHT_ACK, self.OnGuildDemonFightAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_DEMON_GUILD_RANK_ACK, self.OnGuildDemonGuildRankAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_DEMON_MVP_RANK_ACK, self.OnGuildDemonMvpRankAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_DEMON_BUY_FIGHT_COUNT_ACK,self.OnGuildBuyFightCountAck,self)
end

function GuildDemonData:Clear()

end

function GuildDemonData:ClearGuildDemonViewInfos()
    self.DemonData = nil
end

function GuildDemonData:ClearGuildRankViewInfos()
    self.GuildRankData = nil
    self.GuildRankReqPage = 1
end

function GuildDemonData:ClearGuildMvpRankViewInfos()
    self.GuildMvpRankData = nil
    self.GuildMvpRankReqPage = 1
end

function GuildDemonData:Destroy()
    if self.Clear then
        self.DemonData = nil
        self.SommonId = nil
        self.GuildRankData = nil
        self.GuildMvpRankData = nil
        self.GuildRankReqPage = nil
        self.GuildMvpRankReqPage = nil
    end
    self:UnRegisterNetEvents()
end

function GuildDemonData:UnRegisterNetEvents()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.GUILD_DEMON_GET_OTHER_PLAYER_BRIEF_INFO_ACK,self,self.OnGuildPlayerBriefInfoAck);
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_DEMON_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_DEMON_FIGHT_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_DEMON_GUILD_RANK_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_DEMON_MVP_RANK_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_DEMON_BUY_FIGHT_COUNT_ACK)
end

--分批请求玩家信息数据
function GuildDemonData:SendGetGuildMemberInfoReq(type,uids)
    if self.isCanSendInfoReq then
        self.isCanSendInfoReq = false
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_OTHER_PLAYER_BRIEF_INFO_REQ, {type = type,player_list=uids})
    end
end

--分批请求公会排名消息
function GuildDemonData:SendGetGuildDemonRankInfoReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_DEMON_GUILD_RANK_REQ, {page = self.GuildRankReqPage})
end

--分批请求公会Mvp排名消息
function GuildDemonData:SendGetGuildDemonMvpRankInfoReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_DEMON_MVP_RANK_REQ, {page = self.GuildMvpRankReqPage})
end

--获取魔王信息数据
function GuildDemonData:SendGuildDemonInfoReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_DEMON_INFO_REQ)
end

--发送魔王战斗消息
function GuildDemonData:SendGuildDemonBossChallengeReq(bossId, damage, battleTime)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_DEMON_FIGHT_REQ, { demon_id = bossId, damage = damage})
end

--发送购买魔王战斗次数
function GuildDemonData:SendGuildDemonBuyFighCountReq(count)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_DEMON_BUY_FIGHT_COUNT_REQ, { fight_count = count})
end

return GuildDemonData