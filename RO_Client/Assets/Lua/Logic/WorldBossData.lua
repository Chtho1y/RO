local WorldBossData = class("WorldBossData", require("DataBase"))
local CreateActorSystem = require("CreateActorSystem")
local SelfActorSystem = require("SelfActorSystem")

local BossListRequestInterval = 1000
local ChallengeBossRequestInterval = 1000

function WorldBossData:ctor()
    self.worldBossCount = nil                   -- 世界bosss剩余挑战次数
    self.worldBossLs = nil                      -- 世界boss列表 (只在UI界面中显示的Boss列表)
    self.lastBossListRequestTime = nil          -- 上一次boss列表请求时间
    self.lastChallengeBossRequestTime = nil
end

function WorldBossData:Clear()
    self.worldBossLs = nil
    self.lastBossListRequestTime = nil
    self.lastChallengeBossRequestTime = nil

    self:ExitWorldBossBattle()
end

function WorldBossData:Destroy()
    if self.Clear then
        self:Clear()
    end
    self:UnRegisterNetEvents()
end

function WorldBossData:ClearActorData()
    if nil ~= self.selfActorSystem then
        --self.selfActorSystem:Dispose()
        self.selfActorSystem = {}
    end
    if nil ~= self.actorSystems then
        for i=1, #self.actorSystems do
            self.actorSystems[i]:Dispose()
        end
        self.actorSystems = {}
    end    
end

function WorldBossData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ROLE_MAP_CHANGE_NTF, self.ResponseWorldBossCountNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_WORLD_BOSS_LIST_ACK, self.ResponseWorldBossListAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_CHALLENGE_SUMMON_ACK, self.ResponseChallengeBossAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_CHALLENGE_SUMMON_NTF, self.ResponseChallengeBossNtf, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_CHALLENGE_HP_NTF, self.ResponseChallengeHpNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_LEAVE_CHALLENGE_NTF, self.ResponseChallengeLeaveNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_CHALLENGE_RESULT_NTF, self.ResponseChallengeResultNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_WORLD_BOSS_RAND_NTF, self.ResponseWorldBossRandNtf, self)
end

function WorldBossData:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_ROLE_MAP_CHANGE_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PLAYER_WORLD_BOSS_LIST_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PLAYER_CHALLENGE_SUMMON_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PLAYER_CHALLENGE_SUMMON_NTF)

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PLAYER_CHALLENGE_HP_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PLAYER_LEAVE_CHALLENGE_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PLAYER_CHALLENGE_RESULT_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PLAYER_WORLD_BOSS_RAND_NTF)
end

function WorldBossData:ResponseWorldBossCountNtf(data)
    -- LogError("[Wboy] SC_ROLE_MAP_CHANGE_NTF " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    self:ChangeWorldBossCount(data.world_boss_count)
end

function WorldBossData:ResponseWorldBossListAck(data)
    --LogError("[Wboy] CS_PLAYER_WORLD_BOSS_LIST_ACK " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local worldBossList = data.world_boss_list
    local worldBossLs = {}
    for i = 1, #worldBossList do
        local infoData = ProtocalDataNormal.ParseWorldBossContentInfoData(worldBossList[i])
        if infoData then
            worldBossLs[#worldBossLs + 1] = infoData
        end
    end
    table.sort(worldBossLs, function(a, b)
        local A = 10000 * a.boss_summon_type - a.bossId
        local B = 10000 * b.boss_summon_type - b.bossId    
        return A > B              
    end)

    self.worldBossLs = worldBossLs
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.WORLD_BOSS_LIST_CHANGED)
end

function WorldBossData:ResponseChallengeBossAck(data)
    --LogError("[Wboy] SC_PLAYER_CHALLENGE_SUMMON_ACK " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        -- 更新数据
        local infoData = ProtocalDataNormal.ParseWorldBossContentInfoData(data.boss_info)
        local changed = false
        if infoData then
            if self.worldBossLs then
                for i = 1, #self.worldBossLs do
                    local item = self.worldBossLs[i]
                    if infoData.bossId == item.bossId and infoData.bossSummonIdx == item.bossSummonIdx then
                        self.worldBossLs[i] = infoData
                        changed = true
                        break
                    end
                end
            end
        end
        if changed then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.WORLD_BOSS_LIST_CHANGED)
        end
        -- self:SendWorldBossListRequest()
    end
end

function WorldBossData:ResponseChallengeBossNtf(data)
    --LogError("[Wboy] SC_PLAYER_CHALLENGE_SUMMON_NTF " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local uid = data.self_uid
    local fighters = data.fight_list
    local bossId = data.boss_uid
    local ChangePetId = data.self_change_play_id 
    local BossType = data.summon_boss_type
    bossId = type(bossId) == "number" and bossId or #bossId
    local isSelf = (uid == ManagerContainer.DataMgr.UserData:GetUserId())
    local actorSystems = {}
    if fighters then
        for i = 1, #fighters do
            local fighter = fighters[i]
            if fighters then
                local actorSystem = CreateActorSystem:new()
                if nil ~= actorSystem then
                    actorSystem:ParseFightRoleInfo(fighter)
                    actorSystems[#actorSystems + 1] = actorSystem               
                end
            end
        end
    end
    
    if isSelf then
        self:EnterWorldBossBattle(uid, bossId, actorSystems,ChangePetId,BossType)
    else
        -- 其它玩家进入挑战boss
        self:OtherEnterWorldBossBattle(uid, bossId, actorSystems,ChangePetId,BossType)
    end
end

function WorldBossData:ResponseChallengeHpNtf(data)
    -- LogError("[Wboy] SC_PLAYER_CHALLENGE_HP_NTF " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local life = data.cur_boss_hp
    self:WorldBossHpChanged(life)
end

function WorldBossData:ResponseChallengeLeaveNtf(data)
    -- LogError("[Wboy] SC_PLAYER_LEAVE_CHALLENGE_NTF " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local uid = data.uid
    self:OtherExitWorldBossBattle(uid)
end

function WorldBossData:ResponseChallengeResultNtf(data)
    --LogError("[Wboy] SC_PLAYER_CHALLENGE_RESULT_NTF " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    -- 1：胜利；2：超时战斗结束
    local result = data.result
    self:ForceExitWorldBossBattle(result)
end

function WorldBossData:ResponseWorldBossRandNtf(data)
    --LogError("[Wboy] SC_PLAYER_WORLD_BOSS_RAND_NTF " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        self.worldBossPointInfo = nil
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.WORLD_BOSS_ROLL_POINT_LIST_CHANGED)
        return
    end
    self.worldBossPointInfo = ProtocalDataNormal.ParseWorldBossRandPointInfoData(data.point_info)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.WORLD_BOSS_ROLL_POINT_LIST_CHANGED)
end


--- 获得世界boss列表
---@return integer 0:发送成功；1:客户端限制发送
function WorldBossData:SendWorldBossListRequest()
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    if self.lastBossListRequestTime ~= nil and (curTime - self.lastBossListRequestTime) < BossListRequestInterval then
        return 1
    end
    self.lastBossListRequestTime = curTime
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PLAYER_WORLD_BOSS_LIST_REQ, {})
    return 0
end

--- 请求挑战boss
---@param bossId integer
---@param bossSummonIdx integer
function WorldBossData:SendChallengeBossRequest(bossId, bossSummonIdx)
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    if self.lastChallengeBossRequestTime ~= nil and (curTime - self.lastChallengeBossRequestTime) < ChallengeBossRequestInterval then
        return 1
    end
    self.lastChallengeBossRequestTime = curTime
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PLAYER_CHALLENGE_SUMMON_REQ, {uid = uid, challenge_boss_uid = bossId, boss_summon_idx = bossSummonIdx})
    return 0
end


function WorldBossData:HasWorldBossList()
    return self.worldBossLs ~= nil
end

--- 获得世界boss列表
function WorldBossData:GetWorldBossList()
    return self.worldBossLs
end

function WorldBossData:ClearWorldBossList()
    self.worldBossLs = nil
end

function WorldBossData:HasWorldBossPointInfo()
    return self.worldBossPointInfo ~= nil
end

function WorldBossData:GetWorldBossPointInfo()
    return self.worldBossPointInfo
end

function WorldBossData:ClearWorldBossPointInfo()
    self.worldBossPointInfo = nil
end

function WorldBossData:GetWorldBossCount()
    return self.worldBossCount
end

function WorldBossData:ChangeWorldBossCount(count)
    if self.worldBossCount ~= count then
        self.worldBossCount = count
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.WORLD_BOSS_CHALLENGE_COUNT_CHANGED)
    end
end


function WorldBossData:GetWorldBossDataById(bossId,bosstype)
    if bosstype > 0 then
        return ManagerContainer.CfgMgr:GetWorldPetBossDataById(bossId)
    else
        return ManagerContainer.CfgMgr:GetWorldBossDataById(bossId)
    end
end

-------------------------------------------- 挑战世界boss中的数据 -------------------------------
local MaxPlayerNumSomeTime = 8
--- 世界boss战斗中玩家入场和出场的表现时间 (用于保持战斗和UI在进出时一致)
local WorldBossEnterExitTime = 1
local WorldBossUpLoadTime = 1

function WorldBossData:EnterWorldBossBattle(bossOwnerUid, bossId, actorSystems,ChangePetId,BossType)
    -- 避免服务器回两次包，导致重复进入战斗
    if self.isBattling then return end
    self.bossId = bossId
    self.bossOwnerUid = bossOwnerUid
    self.actorSystemNum = 0            -- 当前在战场中的人数
    self.actorSystemMap = {}
    self.lastEnterExitTime = nil
    self.defaultInBattleUIds = {}        -- 初始的时候就在战斗场景中的玩家
    self.preActorSystemInfos = {}      -- 进出战斗的玩家队列
    self.preActorSystemTimer = Timer.New(function()
        self:ExecuteEnterExit()
    end, WorldBossEnterExitTime, -1)     -- 进出战斗的表现，需要让玩家队列执行
    self.totalDamage = 0                 -- 在上传伤害的CD中累计的伤害值
    self.worldBossUpLoadTimer = Timer.New(function()
        self:SendChallengeBossDamageRequest()
    end, WorldBossUpLoadTime, -1)
    self.curHp = 1
    self.maxHp = 1
    self.isBattling = nil             -- 是否在战斗中
    self.isBattleLoading = nil        -- 是否在战斗加载中
    self.isBattleUIReady = nil        -- 是否战斗界面准备好了

    local num = #actorSystems
    local NextNum = num + 1
    local actorArray = System.Array.CreateInstance(Enum.TypeInfo.ActorData, NextNum)

    self.selfActorSystem = SelfActorSystem:new()
    local uid = self.selfActorSystem:GetUserId()
    --是否有变身ID
    if nil ~= ChangePetId and ChangePetId > 0 then
        self.selfActorSystem:CreatePetBossActor(ChangePetId)       
    end
    actorArray[0] = self.selfActorSystem:GetPlayerActorParam()
    actorArray[0].ID = uid
    self.defaultInBattleUIds[NextNum] = uid
    self.actorSystemMap[uid] = self.selfActorSystem
    self.actorSystemNum = self.actorSystemNum + 1

    for i = 1, num do
        local actorSystem = actorSystems[i]
        uid = actorSystem:GetUserId()
         --是否有变身ID
         if nil ~= actorSystem.userData.change_play_id and actorSystem.userData.change_play_id>0 then
            actorSystem:CreatePetBossActor(actorSystem.userData.change_play_id)   
        end
        actorArray[i] = actorSystem:GetPlayerActorParam()
        self.defaultInBattleUIds[i] = uid
        actorArray[i].ID = uid
        self.actorSystemMap[uid] = actorSystem
        self.actorSystemNum = self.actorSystemNum + 1       
    end

    -- 启动世界boss的战斗
    if ManagerContainer.LuaGameMgr then
        self.isBattling = true
        self.isBattleLoading = true
        local summonId = 0
        local summonScene = 0
        local worldBossCfgData = self:GetWorldBossDataById(bossId,BossType)
        if worldBossCfgData then
            summonId = worldBossCfgData.SummonId
            summonScene = worldBossCfgData.SummonScence
            local npcCfgData = ManagerContainer.CfgMgr:GetNpcCfgById(summonId)
            if npcCfgData then
                self.curHp = npcCfgData.Hp
                self.maxHp = npcCfgData.Hp
            end
        end
        if self.worldBossLs then
            -- 找出当前血量
            for i = 1, #self.worldBossLs do
                local item = self.worldBossLs[i]
                if bossId == item.bossId then
                    self.curHp = item.curHp
                    self.maxHp = item.totalHp
                    break
                end
            end
        end

        local battleEndCondList = System.Array.CreateInstance(Enum.TypeInfo.BattleEndCondition, 2)
        battleEndCondList[0] = BattleEndCondition.New(Constants.EndBattle_By_MainRoleDead,Constants.ResultType_Normal)
        battleEndCondList[1] = BattleEndCondition.New(Constants.EndBattle_By_BossDead,Constants.ResultType_Normal)

        ManagerContainer.LuaGameMgr:EnterWorldBoss(actorArray, summonId, summonScene,battleEndCondList)
    end
end

function WorldBossData:ExitWorldBossBattle()
    -- 退出战斗后数据的清理
    self:ClearActorData()
    self.bossId = nil
    self.bossOwnerUid = nil
    self.actorSystemNum = nil
    self.actorSystemMap = nil
    self.lastEnterExitTime = nil
    self.defaultInBattleUIds = nil
    self.preActorSystemInfos = nil
    if self.preActorSystemTimer and self.preActorSystemTimer.running then
        self.preActorSystemTimer:Stop()
    end
    self.preActorSystemTimer = nil
    self.totalDamage = nil
    if self.worldBossUpLoadTimer and self.worldBossUpLoadTimer.running then
        self.worldBossUpLoadTimer:Stop()
    end
    self.worldBossUpLoadTimer = nil
    self.curHp = nil
    self.maxHp = nil
    self.isBattling = nil
    self.isBattleLoading = nil
    self.isBattleUIReady = nil
end

function WorldBossData:WorldBossBattleLoadBegin()
    self.isBattleLoading = true
end

function WorldBossData:WorldBossBattleLoadComplete()
    self.isBattleLoading = false
    self:ExecuteEnterExit()
end

function WorldBossData:WorldBossBattleUIReady()
    self.isBattleUIReady = true
    self:ExecuteEnterExit()
end

function WorldBossData:RecordBossDamage(damage)
    if not self.isBattling then return end
    if not damage or damage <= 0 then return end
    self.totalDamage = self.totalDamage + damage
    if not self.worldBossUpLoadTimer then
        self:SendChallengeBossDamageRequest()
        return
    end
    if not self.worldBossUpLoadTimer.running then
        self:SendChallengeBossDamageRequest()
        self.worldBossUpLoadTimer:Start()
    end
end

function WorldBossData:SendChallengeBossDamageRequest()
    if not self.isBattling then return end
    if not self.totalDamage or self.totalDamage <= 0 then return end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PLAYER_CHALLENGE_HP_REQ, {damage_hp = self.totalDamage})
    self.totalDamage = 0
end

function WorldBossData:SendLeaveChallengeBossRequest()
    self:SendChallengeBossDamageRequest()
    if not self.isBattling then return end   
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PLAYER_LEAVE_CHALLENGE_REQ, {})
end

function WorldBossData:ForceExitWorldBossBattle(result)
    if result == 1 then
        -- boss死亡
        self:WorldBossHpChanged(0)
    end
    if not self.isBattling then return end
    self.isBattling = false
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.WORLD_BOSS_SERVER_KICKOUT_BATTLE, result)
end

function WorldBossData:OtherEnterWorldBossBattle(bossOwnerUid, bossId, actorSystems,ChangePetId,BossType)
    if not self.isBattling then return end
    if self.bossOwnerUid == bossOwnerUid then return end
    if self.bossId ~= bossId then return end
    for i = 1, #actorSystems do
        local actorSystem = actorSystems[i]
        local data = {isEnter = true, data = actorSystem}
        table.insert(self.preActorSystemInfos, data)
    end
    self:ExecuteEnterExit()
end

function WorldBossData:OtherExitWorldBossBattle(uid)
    if not self.isBattling then return end
    local data = {isEnter = false, data = uid}
    table.insert(self.preActorSystemInfos, data)
    self:ExecuteEnterExit()
end

function WorldBossData:WorldBossHpChanged(hp)
    if not self.isBattling then return end
    if self.curHp == hp then return end
    self.curHp = hp
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.WORLD_BOSS_HP_CHANGED)
end

function WorldBossData:ExecuteEnterExit()
    if self.isBattleLoading or not self.isBattling or not self.isBattleUIReady then return end
    if self.preActorSystemTimer and self.preActorSystemTimer.running then
        return
    end
    if not self.preActorSystemInfos then return end
    local num = #self.preActorSystemInfos
    if num <= 0 then return end
    local enters = {}
    local exits = {}
    local index = nil
    local uid
    --- 找出一段有效数据
    for i = 1, num do
        local preActorSystemInfo = self.preActorSystemInfos[i]
        local isEnter = preActorSystemInfo.isEnter
        local data = preActorSystemInfo.data
        local vaild = true
        if isEnter then
            uid = data:GetUserId()
            if uid then
                for j = 1, #exits do
                    if uid == exits[j] then
                        -- 当前玩家正在退出，又要进入，则需要在下次表现时，再处理
                        vaild = false
                        break
                    end
                end
                if not vaild then break end
                -- 进入玩家导致当前场景中玩家数超出上限
                if self.actorSystemNum + 1 > MaxPlayerNumSomeTime then break end
                if self.actorSystemMap[uid] then
                    index = i
                    break
                end
                self.actorSystemMap[uid] = data
                self.actorSystemNum = self.actorSystemNum + 1
                table.insert(enters, {uid = uid, data = data})
                index = i
            end
        else
            uid = data
            if uid then
                for j = 1, #enters do
                    if uid == enters[j].uid then
                        -- 当前玩家正在进入，又要退出，则需要在下次表现时，再处理
                        vaild = false
                        break
                    end
                end
                if not vaild then break end
                self.actorSystemMap[uid] = nil
                self.actorSystemNum = self.actorSystemNum - 1
                table.insert(exits, uid)
                index = i
            end
        end
    end
    if index then
        if index >= num then
            self.preActorSystemInfos = {}
        else
            local newInfos = {}
            -- table.move(self.preActorSystemInfos, index + 1, num, 1, newInfos)
            -- self.preActorSystemInfos = newInfos
            for j = index + 1, num do
                table.insert(newInfos, self.preActorSystemInfos[j])
            end
            self.preActorSystemInfos = newInfos
        end
    else
        LogError('[Wboy] Logic error of player entering and exiting in world boss battle !!!')
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.WORLD_BOSS_PLAYER_CHANGED, enters, exits)
    if #self.preActorSystemInfos > 0 then
        if not self.preActorSystemTimer.running then
            self.preActorSystemTimer:Start()
        end
    else
        self.preActorSystemTimer:Stop()
    end
end

function WorldBossData:GetCurHp()
    return self.curHp
end

function WorldBossData:GetMaxHp()
    return self.maxHp
end

function WorldBossData:GetBattleBossId()
    return self.bossId
end

function WorldBossData:GetActorSystemByUID(uid)
    if uid == nil then return nil end
    return self.actorSystemMap[uid]
end

function WorldBossData:GetActorSystem()
    return self.actorSystemMap
end

--- 默认进入场景的玩家uid列表
function WorldBossData:GetDefaultInBattleUIds()
    return self.defaultInBattleUIds
end

return WorldBossData