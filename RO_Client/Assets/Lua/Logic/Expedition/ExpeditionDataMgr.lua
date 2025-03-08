local ExpeditionDataMgr = class("ExpeditionDataMgr",require("DataBase"))
local ExpeditionMapData = require("Expedition/ExpeditionMapData")
local ExpeditionBuff = require("Expedition/ExpeditionBuff")
local FriendData = require("Friend/FriendData")
local BitUtil = require("BitUtil")

function ExpeditionDataMgr:ctor()
    self.allMaps = {}
    self.bInited = false
    self.battleHeros = {}
    self.leftChanllengeNum = 0      
    self.curChanllengeMapId = 0         --当前挑战的地图类型id
    self.curChanllengeLevelId = 0           --当前挑战的关卡id
    self.curChanllengeSlotIdx = 0            --当前挑战的位置
    self.curChallengeLevelBossList = nil    --当前挑战关卡随机出来的boss  [id,level,hp,sp]
    self.serverHerosData           = nil
    self.buffs = nil
    
    self.maxAssistNum = 0                   --最大可使用救援次数
    self.usedAssistNum = 0                  --已经使用的救援次数
    self.maxRescuedNum = 0                  --最大可被救援次数
    self.usedRescuedNum = 0                 --已经使用的被救援次数
    self.inAssisting = false                --求助中
    self.guildAssistingEndTime = nil        
    
    self.myRescuerIds = nil
    self.myRescuers = nil


    self.curChallengingBossId = 0
    self.curChallengingBossLevel = 0
    self.bossPreLife = 0    --boss上一秒的血量
    self.bossPreSp = 0      --boss上一秒的蓝量
    self.preSycnHPAndSpTime = 0

    self.lastFinishedMap = 0

    self.battleEndCondList = nil

    self.isSingleReward = false
end

function ExpeditionDataMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPEDITION_CHANGE_NTF,self.OnExpeditionDataNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPEDITION_CHALLENGE_PRE_ACK,self.OnChallengeMapAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPEDITION_CHALLENGE_ACK,self.OnChallengeBossEndAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPEDITION_SELECT_BUFF_ACK,self.OnSelectBuffAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPEDITION_REWARD_ACK,self.OnGotRewardAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPEDITION_BATTLE_HERO_ACK,self.OnApplyBattleTeamAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPEDITION_CALL_FOR_HELP_ACK,self.OnAssistReqAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPEDITION_CALL_FOR_HELP_NTF,self.OnAssistNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPEDITION_HELP_ACK,self.OnRescueFriendAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPEDITION_SCORE_RANK_LIST_ACK,self.OnScoreRankListAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EXPEDITION_PASS_REWARD_ACK,self.OnPassRewardAck, self)
    
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Expedition_GET_OTHER_PLAYER_BRIEF_INFO,self,self.OnGetBriefInfoAck)
end

function ExpeditionDataMgr:Clear()
    self.bInited = false
    self.allMaps = {}
    self.battleHeros = {}
    self.curChallengeLevelBossList = nil    
    self.serverHerosData           = nil
    self.buffs = nil
    self.battleEndCondList = nil
    self.lastFinishedMap = 0
end

function ExpeditionDataMgr:Destroy()
end

function ExpeditionDataMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EXPEDITION_CHANGE_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EXPEDITION_CHALLENGE_PRE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EXPEDITION_CHALLENGE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EXPEDITION_SELECT_BUFF_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EXPEDITION_REWARD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EXPEDITION_BATTLE_HERO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EXPEDITION_CALL_FOR_HELP_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EXPEDITION_CALL_FOR_HELP_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EXPEDITION_SCORE_RANK_LIST_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EXPEDITION_PASS_REWARD_ACK)

    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Expedition_GET_OTHER_PLAYER_BRIEF_INFO,self,self.OnGetBriefInfoAck)
end


function ExpeditionDataMgr:InitData()
    if self.bInited then
        return
    end
    
    self.allMaps = {}
    for typeId=1, 100 do 
        local cfg = ManagerContainer.CfgMgr:GetExpeditionCfgByTypeAndLevelId(typeId,1)
        if cfg == nil then
            break
        end

        local mapData = ExpeditionMapData:new(typeId,cfg)
        self.allMaps[#self.allMaps + 1] = mapData
    end
end

function ExpeditionDataMgr:GetAllMaps()
    return self.allMaps
end

function ExpeditionDataMgr:FindMapByTypeId(typeId)
    if self.allMaps == nil then
        return nil
    end

    for i = 1, #self.allMaps do
        if self.allMaps[i].mapId == typeId then
            return self.allMaps[i]
        end
    end

    return nil
end

function ExpeditionDataMgr:Reset()
    if self.allMaps == nil then
        return
    end

    for i = 1, #self.allMaps do
        self.allMaps[i]:Reset()
    end
end

--
function ExpeditionDataMgr:ResetSvrIdx()
    self.StartSvrIdx = 1
end

--获取服务器数据排行榜 起始IDX
function ExpeditionDataMgr:GetListSvrStartIdx()
    if nil == self.StartSvrIdx then
        self.StartSvrIdx = 1
    end
    return self.StartSvrIdx
end

function ExpeditionDataMgr:GetSelfRank()
    return self.SelfScoreRank
end

function ExpeditionDataMgr:GetListfRank()
    return self.ScoreRankList
end

function ExpeditionDataMgr:GetRankDataByIdx(Idx)
    if #self.ScoreRankList >= Idx then
        return self.ScoreRankList[Idx]
    end
end

function ExpeditionDataMgr:GetNextRankListNum()
    if nil == self.StartSvrIdx then
        self.StartSvrIdx = 1
    end
    local step = 20
    local Max = 100
    local IsOver = false
    self.StartSvrIdx = self.StartSvrIdx + step
    
    if self.StartSvrIdx >= Max then
        self.StartSvrIdx = Max
        IsOver = true
    end
    -- if self.StartSvrIdx > #self.ScoreRankList then
    --     self.StartSvrIdx = #self.ScoreRankList   
    -- end
    return self.StartSvrIdx,IsOver
end

function ExpeditionDataMgr:CreateRankListSvrData(svrdata)
    if nil == self.SelfScoreRank then
        self.SelfScoreRank = {}
    end
    if nil == self.ScoreRankList then
        self.ScoreRankList = {}
    end

    if svrdata.error == 0 then        
        for i = 1, #svrdata.rank_list do
            self.ScoreRankList[svrdata.rank_list[i].rank] = svrdata.rank_list[i]
        end
        self.SelfScoreRank = svrdata.self_rank_info
        --self.StartSvrIdx = svrdata.start_idx    
    end    
end

--收到勇士积分排行榜
function ExpeditionDataMgr:OnScoreRankListAck(data)
    --LogError(Inspect(data))
    if data.error == Enum.NetErrorCode.ERROR_OK then
        self:CreateRankListSvrData(data)  
        
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Expedition_RankData)
    end
end

--请求通过奖励
function ExpeditionDataMgr:SendPassRewardReq(mapId)
    --LogError("Send..."..tostring(mapId))
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPEDITION_PASS_REWARD_REQ, {expedition_type = mapId})    
end

--收到通过奖励
function ExpeditionDataMgr:OnPassRewardAck(data)
    -- LogError("OnPassRewardAck")
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    if data.reward_item_list ~= nil then
        local rewardList = {}
        for i = 1, #data.reward_item_list do
            local _itemData = data.reward_item_list[i]
            rewardList[#rewardList+1] = {cfgId = _itemData.key, num = _itemData.value}
        end
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot,{rewards = rewardList})
    end
end

function ExpeditionDataMgr:IsGetPassReward(mapId)    
    -- LogError("mapId"..tostring(mapId))
    -- LogError("expedition_type_reward"..tostring(self.expedition_type_reward))
    local isGet = BitUtil.RshiftNumBandOne(self.expedition_type_reward,mapId) == 1
    return isGet
end

function ExpeditionDataMgr:SendScoreRankListReq(Idx)
    --LogError("Sending"..tostring(Idx))
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPEDITION_SCORE_RANK_LIST_REQ, {start_idx = Idx})
end

function ExpeditionDataMgr:OnExpeditionDataNtf(data)
    --LogError(Inspect(data.expedition_info))
    self:SetData(data.expedition_info)
    if data.day_reset then
        if self.curChallengingBossId > 0 then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE,Enum.UIPageName.UIExpedition,false)
            self.curChallengingBossId = 0
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Expedition_ResetData)
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ExpeReset")
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Expedition_RefreshData, self.isSingleReward)
    self.isSingleReward = false
end

function ExpeditionDataMgr:SaveUnlockMap(expedition_type)
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    UnityEngine.PlayerPrefs.SetString(tostring(uid).."_ExpeditionUnlockMap",tostring(expedition_type))
end

function ExpeditionDataMgr:LoadUnlockMap()
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    local expedition_type = UnityEngine.PlayerPrefs.GetString(tostring(uid).."_ExpeditionUnlockMap")
    if expedition_type ~= nil and expedition_type ~= "" then
        local temp = tonumber(expedition_type)
        for i = 1, temp do
            local map = self:FindMapByTypeId(i)
            if map ~= nil then
                map:SetNewState(false)
            end
        end
    end
end

function ExpeditionDataMgr:SetData(expeditionInfo)
    --LogError("ExpeditionDataMgr:SetData:" .. Inspect(expeditionInfo))
    self:InitData()
    self:Reset()
    
    self.expedition_type_reward = expeditionInfo.expedition_type_reward

    if expeditionInfo == nil then
        return
    end

    --设置解锁的地图
    if expeditionInfo.expedition_type ~= nil then
        for i = 1, expeditionInfo.expedition_type do
            local map = self:FindMapByTypeId(i)
            if map ~= nil then
                map:SetUnlockState(true)
                map:SetNewState(true)
            end
        end
    end

    self:LoadUnlockMap()
    self:SaveUnlockMap(expeditionInfo.expedition_type)

    --老的当天 会清空
    --设置通关地图信息
    -- if expeditionInfo.finish_expedition_list ~= nil then
    --     for i =1, #expeditionInfo.finish_expedition_list do
    --         local map = self:FindMapByTypeId(expeditionInfo.finish_expedition_list[i])
    --         if map ~= nil then
    --             map:SetMapPassed(true)
    --         end
    --     end

    --     self.lastFinishedMap = expeditionInfo.finish_expedition_list[#expeditionInfo.finish_expedition_list]
    -- end

    --小于通过地图信息 重置    
    for i =1, expeditionInfo.expedition_type - 1 do
        local map = self:FindMapByTypeId(i)
        if map ~= nil then
            map:SetMapPassed(true)
            self.lastFinishedMap = i
        end
    end

    self.buffs = {}
    if expeditionInfo.battle_buff_list ~= nil then
        for i = 1, #expeditionInfo.battle_buff_list do
            local buff = ManagerContainer.CfgMgr:GetExpeditionBuffCfgById(expeditionInfo.battle_buff_list[i])
            if buff ~= nil then
                self.buffs[#self.buffs+1] = buff
            end
        end
    end
    CommonUtil.ArraySortSelections(self.buffs, Enum.TableSortRule.Down, "Quality", "Id")

    --设置上阵玩家ID
    self.battleHeros = expeditionInfo.battle_hero_list
    self.curChallengeLevelBossList = expeditionInfo.boss_list
    self.serverHerosData = expeditionInfo.battle_hero_hp_list

    self.maxAssistNum = expeditionInfo.assist_num.key
    self.usedAssistNum = expeditionInfo.assist_num.value
    self.maxRescuedNum = expeditionInfo.be_assist_num.key
    self.usedRescuedNum = expeditionInfo.be_assist_num.value
    self.inAssisting = expeditionInfo.assist_state
    self.guildAssistingEndTime = tonumber(tostring(expeditionInfo.assist_guild_end_time/1000))
    
    if expeditionInfo.be_assist_uid_list ~= nil  then
        self.myRescuers = {}
        self.myRescuerIds = {}
        for i = 1, #expeditionInfo.be_assist_uid_list do
            local assist = expeditionInfo.be_assist_uid_list[i]
            self.myRescuerIds[#self.myRescuerIds+1] = {uid = assist.key, time = assist.value}
        end
    else
        self.myRescuerIds = nil
        self.myRescuers = nil
    end

    --设置当前挑战地图关卡信息
    local lastChanllengeMapId = self.curChanllengeMapId
    self.leftChanllengeNum = expeditionInfo.challenge_num
    self.curChanllengeMapId = expeditionInfo.cur_expedition_type
    self.curChanllengeLevelId = expeditionInfo.cur_battle_level
    self.curChanllengeSlotIdx = expeditionInfo.battle_idx
    
    self.curexpeditionscore = expeditionInfo.cur_expedition_score--当前关卡积分
    self.curexpeditionscoremax = expeditionInfo.cur_expedition_score_max--当前总积分

    local map = self:FindMapByTypeId(self.curChanllengeMapId)
    if map ~= nil then
        map:SetChallengeState(true)
        map:SetPassedLevels(self.curChanllengeLevelId)
    end
    
    --当为挑战过界面，默认预览最新开启的界面
    if self.curChanllengeMapId == 0 then
        for i = #self.allMaps, 1, -1 do
            if self.allMaps[i].unlocked then
                self.allMaps[i]:SetUnfold(true)
                break
            end
        end
    end
   
    --设置地图关卡奖励领取信息
    if expeditionInfo.reward_state_list ~= nil then
        for i =1, #expeditionInfo.reward_state_list do
            local map = self:FindMapByTypeId(expeditionInfo.reward_state_list[i].expedition_type)
            if map ~= nil then                
                map:SetGotRewardLevels(expeditionInfo.reward_state_list[i].reward_state)
            end
        end
    end

    --设置奖励以领取   
    for i = #self.allMaps, 1, -1 do
        if self.allMaps[i].isPassed then
            self.allMaps[i]:SetMapGotReward()               
        end
    end    

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Expedition_RefreshScroe)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.Expedition, self:HasRedPoint())
end

--获取怪物积分
function ExpeditionDataMgr:GetCurBossScore(bossId)
    local BossInfo = ManagerContainer.CfgMgr:GetExpeditionBossCfg(bossId)
    if BossInfo then
        return BossInfo.WarriorScore
    end
    return 0
end

--buff 积分系数
function ExpeditionDataMgr:GetScoreRatio(Scroe)
    --系数获取
    local mapData = self:FindMapByTypeId(self.curChanllengeMapId)     
    if mapData then
        local levelData = mapData:FindLevelByLevelId(1)
        if levelData then            
            local LevelCoefficient = levelData:GetLevelCoefficient()           
            if LevelCoefficient then
               return math.ceil(LevelCoefficient * 0.01 * Scroe) --向上取整
            end
        end
    end
    return Scroe
end

--根据BUFFid 获取积分
function ExpeditionDataMgr:GetScoreByBuffId(BuffID)
    --LogError(tostring(BuffID))
    local buff = ManagerContainer.CfgMgr:GetExpeditionBuffCfgById(BuffID)   
    if buff then
        return self:GetScoreRatio(buff.WarriorScore)
    end
    return 0
end

--当前关卡总积分 
function ExpeditionDataMgr:GetCurScore()
    return self.curexpeditionscore  
end

--历史最高总积分 
function ExpeditionDataMgr:GetMaxScore()
    return  self.curexpeditionscoremax 
end

--是否新纪录
function ExpeditionDataMgr:IsNewRecord()
    return self:GetMaxScore() <= self:GetCurScore()
end

function ExpeditionDataMgr:SaveLastMonster(BossName,Score)
    self.LastBossName = BossName
    self.LastBossScore = Score
end

function ExpeditionDataMgr:GetLastMonsterNameScore()
    return self.LastBossName,self.LastBossScore
end

function ExpeditionDataMgr:SaveLastBuffScore(BuffID)
    self.LastBuffScore = self:GetScoreByBuffId(BuffID)                
end

function ExpeditionDataMgr:GetLastBuffScore()
    return self.LastBuffScore
end

function ExpeditionDataMgr:GetLastFinishedMapState()
    if self.lastFinishedMap == 0 then return false end

    local map = self:FindMapByTypeId(self.lastFinishedMap)
    if not map then
        return
    end
    return map:HasRedPoint() and map.isPassed
end

function ExpeditionDataMgr:CheckUnlockMaps()
    for i = 1, #self.allMaps do
        self.allMaps[i]:CheckUnlock()
    end
end

function ExpeditionDataMgr:RefreshUnfold()
    -- self:CheckUnlockMaps()

    for i = 1, #self.allMaps do
        self.allMaps[i]:SetUnfold(false)
    end
    
    if self.curChanllengeMapId > 0 then
        local map = self:FindMapByTypeId(self.curChanllengeMapId)
        map:SetUnfold(true)
    else
        for i = #self.allMaps, 1, -1 do
            if self.allMaps[i].unlocked then
                self.allMaps[i]:SetUnfold(true)
                break
            end
        end
    end
end

function ExpeditionDataMgr:CurChallengingMap()
    if self.curChanllengeMapId == 0 then
        return nil
    end

    return self:FindMapByTypeId(self.curChanllengeMapId)
end

function ExpeditionDataMgr:IsChallenging()
    return self.curChanllengeMapId > 0
end

function ExpeditionDataMgr:HasRedPoint()
    if self.allMaps == nil then
        return false
    end

    for i = 1, #self.allMaps do
        if self.allMaps[i]:HasRedPoint() then
            return true
        end
    end

    for i = 1, self.lastFinishedMap do
        if self.allMaps[i].isPassed then
            local IsShowReward = not self:IsGetPassReward(self.allMaps[i].mapId)--是否领取
            if IsShowReward then
                return IsShowReward
            end
        end
    end    
    return false
end

function ExpeditionDataMgr:GetCurLevelId()
    return self.curChanllengeLevelId
end

function ExpeditionDataMgr:GetBossList()
    return self.curChallengeLevelBossList
end

function ExpeditionDataMgr:GetBuffs()
    return self.buffs
end

function ExpeditionDataMgr:ChanllengeSlotIdx()
    return self.curChanllengeSlotIdx
end

function ExpeditionDataMgr:GetCurrBattleTeamMembers()
    if #self.battleHeros == 0 then
        local teamData = ManagerContainer.DataMgr.UserData:GetTeamData(true)
        for i = 1, #teamData do
            self.battleHeros[#self.battleHeros+1] = teamData[i].uid
        end
        self:SendApplyBattleTeamReq(self.battleHeros)
    end
    return self.battleHeros
end

function ExpeditionDataMgr:CurMemberCnt()
    return #self.battleHeros
end

function ExpeditionDataMgr:IsInBattleTeam(uid)
    for i = 1, #self.battleHeros do
        if self.battleHeros[i] == uid then
            return true
        end
    end

    return false
end

function ExpeditionDataMgr:OnBattle(actorId)
    if self:CurMemberCnt() >= 4 then
        return
    end

    if self:IsInBattleTeam(actorId) then
        return
    end
    self.battleHeros[#self.battleHeros + 1] = actorId
    self:SendApplyBattleTeamReq(self.battleHeros)
end

function ExpeditionDataMgr:ReplaceBattleActorId(orgUid,newUid)
    for i=1, #self.battleHeros do
        if self.battleHeros[i] == orgUid then
            self.battleHeros[i] = newUid
            self:SendApplyBattleTeamReq(self.battleHeros)
            break;
        end
    end
end

function ExpeditionDataMgr:GetTeamTotalFightPower()
    local TotalPower = 0
    for i = 1, #self.battleHeros do      
        local Power = ManagerContainer.DataMgr.UserData:GetAsideFighterSvrPower(self.battleHeros[i],false)    
        if nil ~= Power and -1 ~= Power then	
            TotalPower = TotalPower + Power	
            local PetPower = ManagerContainer.DataMgr.UserData:GetAsideFighterSvrPower(self.battleHeros[i],true)            
            if nil ~= PetPower and -1 ~= PetPower then
                TotalPower = TotalPower + PetPower
            end
        else
            --local power
            Power = ManagerContainer.DataMgr.UserData:GetSlotFightPower(self.battleHeros[i])
            TotalPower = TotalPower + Power
        end    
    end
    return TotalPower
end

function ExpeditionDataMgr:GetHeroHPAndSP(uid)
    if self.serverHerosData == nil then
        return 100,100
    end

    for i = 1, #self.serverHerosData do
        if tostring(self.serverHerosData[i].id) == tostring(uid) then            
            return self.serverHerosData[i].hp, self.serverHerosData[i].sp
        end
    end
    return 100, 100
end

function ExpeditionDataMgr:SetHeroHPAndSp(uid, hpPercent,spPercent)
    if self.serverHerosData == nil then
        return
    end

    for i = 1, #self.serverHerosData do
        if self.serverHerosData[i].id == uid then
            self.serverHerosData[i].hp = hpPercent
            self.serverHerosData[i].sp = spPercent
            return
        end
    end
end

function ExpeditionDataMgr:EnterBattle()
    local map = self:FindMapByTypeId(self.curChanllengeMapId)
    if map ~= nil then
        local levelInfo = map:FindLevelByLevelId(self.curChanllengeLevelId)       
        self.curMaxFightingTime = levelInfo.maxFightingTime        
        ManagerContainer.LuaGameMgr:RefreshTeamData()
        local maxHP = 0
        local maxHPActorId = 0
        local heroIds = {}        
        for i = 1, #self.battleHeros do
            local hpPercent,spPercent = self:GetHeroHPAndSP(self.battleHeros[i])
            local actor = ManagerContainer.LuaActorDataMgr:GetActorsById(self.battleHeros[i])         
            if hpPercent > 0 then     
                local MaxHp = SDataUtil.InvConvert(actor.Life) * hpPercent * 0.01    
                heroIds[#heroIds + 1] = self.battleHeros[i]                
                if MaxHp > maxHP then
                    maxHP = MaxHp
                    maxHPActorId = self.battleHeros[i]
                end
            end
        end

        if #heroIds == 0 then
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("队伍全部阵亡")
            return
        end

        --清空現有dropbuff 戰鬥結束清理 有bug 
        ManagerContainer.LuaActorDataMgr:ResetData()
        
        local ourActors = System.Array.CreateInstance(Enum.TypeInfo.ActorData, #heroIds)
        for i = 1 , #heroIds do
            local actor = ManagerContainer.LuaActorDataMgr:GetActorsById(heroIds[i])
            ourActors[i-1] = actor

            --增加对应压制mark
            ManagerContainer.DataMgr.UserData:SetActorPveMark(heroIds[i],actor)

            --设置掉落buff
            local dropBuffs = self:GetDropBuffs(actor,maxHPActorId)
            if dropBuffs ~= nil then
                local dropBuffParamList = System.Array.CreateInstance(Enum.TypeInfo.BuffParam, #dropBuffs)
                for j = 1, #dropBuffs do
                    local buffParam = dropBuffs[j]
                    dropBuffParamList[j-1] = BuffParam.New(buffParam.buffId, buffParam.buffRatio, buffParam.buffCd, buffParam.buffType,buffParam.extendPara,buffParam:ConvertFunToStr())
                end
                actor:SetDropBuffs(dropBuffParamList)
            end

            if actor.HasPet then
                local petDropBuffs = self:GetDropBuffs(actor.PetData,maxHPActorId)
                if petDropBuffs ~= nil then
                    local dropBuffParamList = System.Array.CreateInstance(Enum.TypeInfo.BuffParam, #petDropBuffs)
                    for j = 1, #petDropBuffs do
                        local buffParam = petDropBuffs[j]
                        dropBuffParamList[j-1] = BuffParam.New(buffParam.buffId, buffParam.buffRatio, buffParam.buffCd, buffParam.buffType,buffParam.extendPara,buffParam:ConvertFunToStr())
                    end
                    actor.PetData:SetDropBuffs(dropBuffParamList)
                end
            end
        end

        local bossInfo = self.curChallengeLevelBossList[self.curChanllengeSlotIdx]
        local enemyActors = System.Array.CreateInstance(Enum.TypeInfo.ActorData, 1)
        local bossActor = ManagerContainer.LuaActorDataMgr:CreateNpc(bossInfo.id,bossInfo.id,2,bossInfo.level)
        bossActor.IsBoss = true
        enemyActors[0] = bossActor

        local srvActorData = System.Array.CreateInstance(Enum.TypeInfo.ServerFighterParam, #heroIds + 1)
        for i = 1 , #heroIds do
            local hpPercent,spPercent = self:GetHeroHPAndSP(heroIds[i])
            local param = ServerFighterParam.New(heroIds[i],0,0,hpPercent * 0.01,spPercent * 0.01)
            srvActorData[i-1] = param
        end

        self:InitEndBattleCondition()
        local bossParam = ServerFighterParam.New(bossInfo.id,bossInfo.hp,bossInfo.sp,0,0)
        srvActorData[#heroIds] = bossParam

        self.bossPreLife = bossInfo.hp
        self.bossPreSp = bossInfo.sp
        self.curChallengingBossId = bossInfo.id
        self.curChallengingBossLevel = bossInfo.level
        self.preSycnHPAndSpTime = Time.realtimeSinceStartup   
 
        --保存最后一次 BOSS信息
        local bossid = bossInfo.id
        local bossCfg = ManagerContainer.CfgMgr:GetNpcCfgById(bossid)
        if bossCfg ~= nil then
            local CurBossScore = self:GetCurBossScore(bossid)
            self:SaveLastMonster(bossCfg.Name,CurBossScore)
        end

        ManagerContainer.LuaGameMgr:EnterExpeditionBattle(map.sceneName,map.bgm,self.curMaxFightingTime,ourActors,enemyActors,map.loadingId,srvActorData,self.battleEndCondList,levelInfo.RestoreSp)
    end
end

function ExpeditionDataMgr:InitEndBattleCondition()
    if self.battleEndCondList ~= nil then
        return
    end

    self.battleEndCondList = System.Array.CreateInstance(Enum.TypeInfo.BattleEndCondition, 2)
    self.battleEndCondList[0] = BattleEndCondition.New(Constants.EndBattle_By_UndeadCount,Constants.ResultType_Normal)
    self.battleEndCondList[1] = BattleEndCondition.New(Constants.EndBattle_By_BattleTime,Constants.ResultType_Normal)
end

function ExpeditionDataMgr:SyncBossLife(curLife)
    local deltaTime = Time.realtimeSinceStartup - self.preSycnHPAndSpTime 
    if deltaTime >= 0.3 then
        local deltaHP = curLife - self.bossPreLife
        local bossList = {{id=self.curChallengingBossId,level=self.curChallengingBossLevel,hp=deltaHP}}

        self:SendRefreshBattleData(bossList)

        self.bossPreLife = curLife
        self.preSycnHPAndSpTime = Time.realtimeSinceStartup
    end
end

function ExpeditionDataMgr:SyncBossSP(curSp)
    local deltaTime = Time.realtimeSinceStartup - self.preSycnHPAndSpTime 
    if deltaTime >= 0.3 then
        local deltaSp = curSp - self.bossPreSp
        local bossList = {{id=self.curChallengingBossId,level=self.curChallengingBossLevel,sp=deltaSp}}
        self:SendRefreshBattleData(bossList)

        self.bossPreSp = curSp
        self.preSycnHPAndSpTime = Time.realtimeSinceStartup
    end
end

function ExpeditionDataMgr:BattleEnd(battleTime,fighterParams,bossLife,bossSp)
    local heroInfos = {}
    if fighterParams ~= nil then
        for i =1, fighterParams.Count do
            local param = fighterParams[i-1]
            heroInfos[#heroInfos+1] = { id = param.uid,
                                        hp = param.hpPercent * 100,
                                        sp = param.spPercent * 100}
        end
    end

    local deltaSp = bossSp - self.bossPreSp
    local deltaHP = bossLife - self.bossPreLife
    local bossList = {{id=self.curChallengingBossId,level=self.curChallengingBossLevel,hp=deltaHP,sp=deltaSp}}

    self:SendChallengeBossEnd(battleTime,heroInfos,bossList)

    self.curChallengingBossId = 0
    self.curChallengingBossLevel = 0
end

function ExpeditionDataMgr:SendChallengeMapReq(mapId)
    self.reqEnterMapId = mapId
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPEDITION_CHALLENGE_PRE_REQ, {expedition_type = mapId})
end

function ExpeditionDataMgr:OnChallengeMapAck(data)
    if data.error == 0 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Expedition_EnterMap_Success)
        if self.reqEnterMapId ~= nil then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExpeditionDungeonInfo, self.reqEnterMapId)
            self.reqEnterMapId = nil
        end
    end
end

function ExpeditionDataMgr:SendChallengeBossStart(slotIdx)
    self.curChanllengeSlotIdx = slotIdx
    local heroInfos = {}
    local battleTeamIds = self:GetCurrBattleTeamMembers()
    for i = 1, #battleTeamIds do
        local hpPercent,spPercent = self:GetHeroHPAndSP(battleTeamIds[i])
        if hpPercent > 0 then
            heroInfos[#heroInfos+1] = {id = battleTeamIds[i],hp = hpPercent, sp = spPercent}
        end
    end

    local data = {expedition_type = self.curChanllengeMapId,
                  battle_level = self.curChanllengeLevelId,
                  battle_idx = self.curChanllengeSlotIdx, 
                  hero_info_list = heroInfos, 
                  flag = 1}
    -- LogError("SendChallengeBossStart: " .. Inspect(data))
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPEDITION_CHALLENGE_REQ, data)
end

function ExpeditionDataMgr:SendRefreshBattleData(bossInfo)
    if self.curChanllengeMapId == 0 then
        return
    end

    local data = {expedition_type = self.curChanllengeMapId,
                  battle_level = self.curChanllengeLevelId,
                  battle_idx = self.curChanllengeSlotIdx,  
                  boss_change_hp_list = bossInfo,
                  flag = 2}
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPEDITION_CHALLENGE_REQ, data)
end

function ExpeditionDataMgr:SyncHeroLifeAndSp(actorId,life,maxLife,sp,maxSp)
    if self.curChanllengeMapId == 0 then
        return
    end

    local hpPercent = life * 100 / maxLife
    local spPercent = sp * 100 / maxSp
    self:SetHeroHPAndSp(actorId,hpPercent,spPercent)

    local heroInfos = {}
    heroInfos[#heroInfos+1] = { id = actorId,hp = hpPercent, sp = spPercent}
    local data = { expedition_type = self.curChanllengeMapId,
                    battle_level = self.curChanllengeLevelId,
                    battle_idx = self.curChanllengeSlotIdx, 
                    hero_info_list = heroInfos, 
                    flag = 2}
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPEDITION_CHALLENGE_REQ, data)
end

function ExpeditionDataMgr:SendChallengeBossEnd(battleTime,heroInfo,bossInfo)  
    if self.curChanllengeMapId == 0 then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleFailed,true)
        return
    end

    local data = {expedition_type = self.curChanllengeMapId,
                  battle_level = self.curChanllengeLevelId,
                  battle_idx = self.curChanllengeSlotIdx, 
                  hero_info_list = heroInfo, 
                  boss_change_hp_list = bossInfo,
                  battle_time = battleTime,
                  flag = 3}
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPEDITION_CHALLENGE_REQ, data)
end

function ExpeditionDataMgr:OnChallengeBossEndAck(data)   
    if data.error == 0 then
        if data.flag == 1 then
            if data.buff_list ~= nil and #data.buff_list > 0 then
                ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExpeditionWin,{data.buff_list,false})
            else
                self:EnterBattle()
            end
        elseif data.flag == 3 then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleFailed,true)
        elseif data.flag == 4 then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExpeditionWin,{data.buff_list,true})
        end
    else
        --LogError("OnChallengeBossEndAck Error ="..tostring(data.error))
        -- 超过最大挑战时间
        if data.error == 27 then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleFailed,true)
        end
    end
end

function ExpeditionDataMgr:SendSelectBuffReq(buffId)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPEDITION_SELECT_BUFF_REQ, {select_buff_id = buffId})
    self:SaveLastBuffScore(buffId)
end

function ExpeditionDataMgr:OnSelectBuffAck(data)
    if data.error == 0 then       
        self:RemoveTimer()
        self.TimeShowTipsId =  ManagerContainer.LuaTimerMgr:AddTimer(800, 1, self, self.ShowTips,nil)
    end
end

function ExpeditionDataMgr:ShowTips(Score)
    local score = self:GetLastBuffScore()
    if not ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UIErrorTips) then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIErrorTips, {errorId="ExpeditionArtifact", params ={ tostring(score)}}, nil, nil, nil, Enum.UISibling[Enum.UIType.Top + 1] + 11)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ERROR_DESC_DISPLAY, {errorId="ExpeditionArtifact",params = { tostring(score)}})
    end
end

function ExpeditionDataMgr:RemoveTimer()
    if self.TimeShowTipsId then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.TimeShowTipsId);
        self.TimeShowTipsId = nil;
    end
end

--levelId: 0 表示一键领取
function ExpeditionDataMgr:SendGotRewardReq(mapId,levelId)
    -- LogError("mapId = " .. mapId .. " levelId = " .. levelId)
    self.isSingleReward = levelId > 0
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPEDITION_REWARD_REQ, {expedition_type = mapId, boss_idx = levelId})
end

function ExpeditionDataMgr:OnGotRewardAck(data)
    if data.error == 0 then
        local rewardList = {}
        for i = 1, #data.reward_item_list do
            local itemData = data.reward_item_list[i];
            rewardList[#rewardList+1] = {cfgId = itemData.key, num = itemData.value}
        end
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot,{rewards = rewardList})
    end
end

function ExpeditionDataMgr:SendApplyBattleTeamReq(teamIds)
    -- LogError(Inspect(teamIds))
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPEDITION_BATTLE_HERO_REQ, {battle_hero_list = teamIds})
end

function ExpeditionDataMgr:OnApplyBattleTeamAck(data)
    -- LogError(data.error)
end

function ExpeditionDataMgr:SendAssistReq(uid)
    -- LogError("SendAssistReq = " .. tostring(uid))
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPEDITION_CALL_FOR_HELP_REQ, {assist_help_uid = uid})
end

function ExpeditionDataMgr:OnAssistReqAck(data)
    -- LogError(data.error)
end

function ExpeditionDataMgr:OnAssistNtf(data)
    if data.assist_state == 1 then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ExpeditionHelp")
    end
end

function ExpeditionDataMgr:SendRescueFriendReq(uid,msgType, time)
    self.targetUid = uid
    self.msgType = msgType
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPEDITION_HELP_REQ, {be_helped_uid = uid, msg_type = msgType, help_msg_send_time = time})
end

function ExpeditionDataMgr:OnRescueFriendAck(data)
    if data.error == Enum.NetErrorCode.ERROR_OK then
        local uid = tostring(self.targetUid)
        ManagerContainer.DataMgr.ChatData:ExpeditionHelpAck(uid, self.msgType)
        self.targetUid = nil
        self.msgType = nil
        --策划需求 不用显示 奖励界面
        --if data.reward_item_list ~= nil and #data.reward_item_list > 0 then
        --    local rewardList = {}
        --    for i = 1, #data.reward_item_list do
        --        local itemData = data.reward_item_list[i];
        --        rewardList[#rewardList+1] = {cfgId = itemData.key, num = itemData.value}
        --    end
        --    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot,{rewards = rewardList})
        --end
    end
end

function ExpeditionDataMgr:GetRescuerCnt()
    if self.myRescuerIds ~= nil then
        return #self.myRescuerIds
    end

    return 0 
end

function ExpeditionDataMgr:GetRescuers()
    return self.myRescuers
end

function ExpeditionDataMgr:ReqestRescuerBriefData()
    if self.myRescuerIds == nil or #self.myRescuerIds == 0 then
        return
    end

    local cnt = 10
	local uid_list = {}

	if cnt > #self.myRescuerIds then
		cnt = #self.myRescuerIds
	end
	for i = 1, cnt do
		uid_list[#uid_list+1] = self.myRescuerIds[i].uid
    end
    
    ManagerContainer.DataMgr.FriendDataMgr:ReqFriendBriefData(Enum.FriendTogglePageType.ExpedtionHelpLog,uid_list)
end

function ExpeditionDataMgr:OnGetBriefInfoAck(data)
    if data.type == Enum.FriendTogglePageType.ExpedtionHelpLog then
        if data.brief_info ~= nil then
            for i = 1,#data.brief_info do
                local info = data.brief_info[i]
                self:AddRescuer(info)
                self:RemoveRescuerId(info.uid)
            end
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Expedition_REFRESH_HELP_LOG)
    end
end

function ExpeditionDataMgr:GetRescuerTime(uid)
    if self.myRescuerIds == nil  then
        return 0
    end

    for i = 1, #self.myRescuerIds do
        if self.myRescuerIds[i].uid == uid then
            return self.myRescuerIds[i].time
        end
    end

    return 0
end

function ExpeditionDataMgr:RemoveRescuerId(uid)
    for i = 1, #self.myRescuerIds do
        if self.myRescuerIds[i].uid == uid then
            table.remove(self.myRescuerIds,i)
            return
        end
    end
end

function ExpeditionDataMgr:FindRescuerById(uid)
    if self.myRescuers == nil then
        return nil
    end

    for i = 1, #self.myRescuers do
        if self.myRescuers[i].uid == uid then
            return self.myRescuers[i]
        end
    end

    return nil
end

function ExpeditionDataMgr:AddRescuer(briefInfo)
    if briefInfo == nil then
        return
    end
    
    local obj = self:FindRescuerById(briefInfo.uid)
    if obj ~= nil then
        obj:SetData(briefInfo)
    else
        obj = FriendData:new(briefInfo.uid)
        obj:SetData(briefInfo)
        self.myRescuers[#self.myRescuers+1] = obj
    end
    local time = self:GetRescuerTime(briefInfo.uid)
    obj.param = time
end

function ExpeditionDataMgr:GetDropBuffs(actorData,maxHPActorId)
    if self.buffs == nil or #self.buffs == 0 then
        return nil
    end

    local buffList = {}
    for i = 1, #self.buffs do
        local buffCfg = self.buffs[i]
        local buffCfg = self.buffs[i]        
        local filterActorType,filterParamType,filterParamVal = self:ParseFilterParam(buffCfg.FilterParam)
        local matchAType = (filterActorType == -1) or (filterActorType == actorData.IActorType) or (filterActorType == 5 and (actorData.IsHero or actorData.IsFellow))
        local bMatch = false
        if filterParamType == nil then            
            if matchAType then
                bMatch = true
            end
        else                
            if filterParamType == 1  then           --职业
                if matchAType and (filterParamVal == -1 or filterParamVal == actorData.JobType) then
                    if buffCfg.FilterExtendParam ~= nil then
                        local jobStage = buffCfg.FilterExtendParam[1]
                        local jobBranch = buffCfg.FilterExtendParam[2]
                        if jobStage == actorData.JobStage and jobBranch == actorData.JobBranch then
                            bMatch = true
                        end
                    else
                        bMatch =  true
                    end
                end
            elseif filterParamType == 2 then        --属性
                if matchAType and (filterParamVal == -1 or filterParamVal == actorData.NatureId) then
                    bMatch = true
                end
            elseif filterParamType == 3 then         --宠物ID
                if matchAType and (filterParamVal == actorData.BaseId) then
                    bMatch = true
                end
            elseif filterParamType == 4 then        --血量最高的人      
                if matchAType and (tostring(actorData.ID) == tostring(maxHPActorId)) then                   
                    bMatch = true
                end
            end
        end        
        if bMatch then
            local buff = self:FindBuff(buffList,buffCfg.BuffId)
            if buff == nil then               
                local buff = ExpeditionBuff:new(buffCfg.BuffId,buffCfg.Ratio,buffCfg.CD,buffCfg.ConditionType,buffCfg.ExtendPara,buffCfg.Function)
                buffList[#buffList+1] = buff
            else               
                buff:AddFun(buffCfg.Function)
            end
        end
    end

    return buffList
end

function ExpeditionDataMgr:FindBuff(buffList,buffId)
    if buffList == nil then  return nil end

    for i = 1, #buffList do
        if buffList[i].buffId == buffId then
            return buffList[i]
        end
    end
    return nil
end

--返回过滤参数类型：paramType:参数类型[1:职业； 2:属性; 3: 宠物ID]
function ExpeditionDataMgr:ParseFilterParam(params)
    local filterActorType = params[1]
    local filterParamType = nil
    local filterParamVal = nil
    if #params > 1 then
        filterParamType = params[2]
    end

    if #params > 2 then
        filterParamVal = params[3]
    end
    return filterActorType,filterParamType,filterParamVal
end

return ExpeditionDataMgr