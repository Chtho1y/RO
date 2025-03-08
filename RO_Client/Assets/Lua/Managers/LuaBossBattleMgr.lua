local LuaBossBattleMgr = class("LuaBossBattleMgr")

function LuaBossBattleMgr:ctor()
    self.battleMode = BattleSubMode.None
    self.isLoading = false
    self.isBattleEnd = false
    self.ShowSkip = false
    self:RegisterNetEvents();
end

function LuaBossBattleMgr:Destroy()
    self:UnRegisterNetEvents();
    if tolua.getpeer(self) ~= nil then
		    tolua.setpeer(self, nil)
    end
end

function LuaBossBattleMgr:RegisterNetEvents()
end

function LuaBossBattleMgr:UnRegisterNetEvents()
end

function LuaBossBattleMgr:Enter(mode)
    if mode == nil then
        LogError("请设置Boss战的类型")
        return
    end

    self.isBattleEnd = false

    self.battleMode = mode
    if self.battleMode == BattleSubMode.WorldBoss then
        self:RegisterWorldBossEvents()
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIWorldBossBattle)
    end
end

function LuaBossBattleMgr:OpenNewbieBattleUI()
    if self.battleMode == BattleSubMode.NewbieBoss then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINewbieBattle)
    end
end

function LuaBossBattleMgr:Exit()
    if self.battleMode == BattleSubMode.WorldBoss then
        self:UnRegisterWorldBossEvents()
    end
    self.battleMode = BattleSubMode.None
    self.isBattleEnd = true
    self.ShowSkip = false
end

--boss召唤出来
function LuaBossBattleMgr:OnBossSpawned(bossName,life,maxLife,skillParam)
    self.bossName = bossName
    self.bossMaxLife = maxLife
    self.bossSkillParam = skillParam
end

--boss召唤出来显示warning
function LuaBossBattleMgr:OnShowBossWarning()
end

--战斗失败
function LuaBossBattleMgr:OnBattleFailed()
    -- LogError("LuaBossBattleMgr:OnBattleFailed")
end

--战斗胜利
function LuaBossBattleMgr:OnBattleWin()
    -- LogError("LuaBossBattleMgr:OnBattleWin")
end

--- 战斗结束
---@param flag integer 1:boss死亡；2：自己死亡
function LuaBossBattleMgr:OnBattleEnd(flag)
    -- LogError("LuaBossBattleMgr:OnBattleEnd " .. tostring(flag))
    if self.isBattleEnd then return end
    self.isBattleEnd = true

    if self.battleMode == BattleSubMode.WorldBoss then
        ManagerContainer.DataMgr.WorldBossData:SendLeaveChallengeBossRequest()
        self:ExitFromWorldBossBattle(flag)
    elseif self.battleMode == BattleSubMode.NewbieBoss then
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ROLE_GUIDE_NTF, {guide_id = 1})
        local cb = function()
            ManagerContainer.LuaGameMgr:ShutDownBattle()
            ManagerContainer.LuaGameMgr:EnterBattle(false)
        end
        RegisterDelayStep(cb)
    end
end

--同步boss伤害
function LuaBossBattleMgr:OnSyncBossDamage(damage)
    -- LogError("[wboy] CS_PLAYER_CHALLENGE_HP_REQ " .. Inspect(damage))
    if self.isBattleEnd then return end
    if self.battleMode == BattleSubMode.WorldBoss then
        ManagerContainer.DataMgr.WorldBossData:RecordBossDamage(damage)
    end
end

--剩余多长时间进入狂暴状态
function LuaBossBattleMgr:OnShowBossRageLeftTime(leftTime)
end

--boss进入狂暴状态
function LuaBossBattleMgr:OnBossInRage()
end

--开始进行加载
function LuaBossBattleMgr:OnLoadBegin()
    self.isLoading = true
    LogWarning("LuaBattleMgr:OnLoadBegin ")

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Begin);
    if self.battleMode == BattleSubMode.WorldBoss then
        ManagerContainer.DataMgr.WorldBossData:WorldBossBattleLoadBegin()
    end
end

--加载进度的刷新
function LuaBossBattleMgr:OnLoadProgress(progress)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Progress,progress);
end

--加载完成
function LuaBossBattleMgr:OnLoadComplete()
    LogWarning("LuaBattleMgr:OnLoadComplete ")
    self.isLoading = false
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Complete);
    if self.battleMode == BattleSubMode.WorldBoss then
        ManagerContainer.DataMgr.WorldBossData:WorldBossBattleLoadComplete()
    end
end


function LuaBossBattleMgr:RegisterWorldBossEvents()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.WORLD_BOSS_HP_CHANGED, self, self.OnWorldBossHpChanged)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.WORLD_BOSS_PLAYER_CHANGED, self, self.OnWorldBossPlayerChanged)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.WORLD_BOSS_SERVER_KICKOUT_BATTLE, self, self.OnWorldBossServerKickoutBattle)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.WORLD_BOSS_ROLL_POINT_LIST_CHANGED, self, self.OnWorldBossRollPointList)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UI_CLOSE_COMPELETED, self, self.OnUICloseCompleted)
end

function LuaBossBattleMgr:UnRegisterWorldBossEvents()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.WORLD_BOSS_HP_CHANGED, self, self.OnWorldBossHpChanged)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.WORLD_BOSS_PLAYER_CHANGED, self, self.OnWorldBossPlayerChanged)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.WORLD_BOSS_SERVER_KICKOUT_BATTLE, self, self.OnWorldBossServerKickoutBattle)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.WORLD_BOSS_ROLL_POINT_LIST_CHANGED, self, self.OnWorldBossRollPointList)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UI_CLOSE_COMPELETED, self, self.OnUICloseCompleted)
    if self.playerChangeDeltaTimer and self.playerChangeDeltaTimer.running then
        self.playerChangeDeltaTimer:Stop()
    end
    self.playerChangeDeltaTimer = nil
    if self.waitRollTimer and self.waitRollTimer.running then
        self.waitRollTimer:Stop()
    end
    self.waitRollTimer = nil
end

function LuaBossBattleMgr:OnWorldBossHpChanged()
    local curHp = ManagerContainer.DataMgr.WorldBossData:GetCurHp()
    LuaBattleBridge.SyncWorldBossLife(curHp)
end

function LuaBossBattleMgr:OnWorldBossPlayerChanged(enters, exits)
    for i = 1, #exits do
        local uid = exits[i]
        LuaBattleBridge.SetActorDead(uid)
    end
    if not self.playerChangeDeltaTimer then
        self.playerChangeDeltaTimer = Timer.New(function()
            self:WorldBossPlayerChanged()
        end, 0.5, -1)
    end
    if self.playerChangeDeltaTimer.running then
        self:WorldBossPlayerChanged(true)
    end
    self.playerChangeDeltaTimer.time = 0.5
    self.playerChangeDeltaTimer.enters = enters
    self.playerChangeDeltaTimer.exits = exits
    self.playerChangeDeltaTimer:Start()
end

function LuaBossBattleMgr:WorldBossPlayerChanged(force)
    if not self.playerChangeDeltaTimer then
        return
    end
    local enters = self.playerChangeDeltaTimer.enters
    local exits = self.playerChangeDeltaTimer.exits
    for i = 1, #exits do
        local uid = exits[i]
        LuaBattleBridge.RemoveActorFromBattle(uid)
    end
    for i = 1, #enters do
        local enter = enters[i]
        local uid = enter.uid
        local actorSystem = enter.data
        if actorSystem then
            local actorParam = actorSystem:GetPlayerActorParam()
            if actorParam then
                if nil ~= actorSystem.userData.change_play_id and actorSystem.userData.change_play_id>0 then
                    actorParam = actorSystem:CreatePetBossActor(actorSystem.userData.change_play_id)
                    actorParam.ID = uid
                end                
                LuaBattleBridge.AddActorToBattle(actorParam)
            end
        end
    end
    self.playerChangeDeltaTimer.enters = nil
    self.playerChangeDeltaTimer.exits = nil
    if not force then
        self.playerChangeDeltaTimer:Stop()
    end
end

--- 服务器强制踢出世界boss战斗
---@param result 1：胜利
function LuaBossBattleMgr:OnWorldBossServerKickoutBattle(result)
    -- 设置boss血量为0，走战斗结束流程
    LuaBattleBridge.SyncWorldBossLife(0)
end

function LuaBossBattleMgr:ExitFromWorldBossBattle(flag)
    -- 不退出，等待Roll点界面
    if not self.waitRollTimer then
        -- 请求超时60秒，退出战斗
        self.waitRollTimer = Timer.New(function()
            self:ExitWorldBossBattle()
        end, 60, 1)
    end
    self.waitRollTimer:Start()
    return nil
end

function LuaBossBattleMgr:ExitWorldBossBattle()
    -- 清理数据，避免干扰其它战斗
    local actorSystemMap = ManagerContainer.DataMgr.WorldBossData:GetActorSystem()
    for uid,_ in pairs(actorSystemMap) do
        LuaBattleBridge.RemoveActorFromBattle(uid)
    end
    ManagerContainer.LuaGameMgr:ShutDownBattle()
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.IdleState.stateId)
    ManagerContainer.DataMgr.WorldBossData:ExitWorldBossBattle()

    local data = require('ExecuteSequenceData'):new()
    data:AppendFunc(false, ManagerContainer.LuaUIMgr, ManagerContainer.LuaUIMgr.Open, Enum.UIPageName.UIMain)
    data:AppendUIListener(Enum.UIPageName.UIMain, UIEventNames.UI_FILLCONTENT_COMPELETED, 5)
    data:AppendUIViewFunc(false, Enum.UIPageName.UIMain, 'ChangePageMsg', Enum.MainViewPageType.Town)
    data:AppendUIListener(Enum.UIPageName.UIMainCity1, UIEventNames.UI_FILLCONTENT_COMPELETED, 5)
    data:AppendUIViewFunc(false, Enum.UIPageName.UIMainCity1, 'OpenWorldBoss')
    ManagerContainer.ExecuteSequenceMgr:Execute(data)
end

function LuaBossBattleMgr:OnWorldBossRollPointList()
    local worldBossData = ManagerContainer.DataMgr.WorldBossData
    if not worldBossData:HasWorldBossPointInfo() then
        self:ExitWorldBossBattle()
        return
    end
    if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIWorldBossReward) then
		return
    end
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIWorldBossReward)
    if self.waitRollTimer then
        self.waitRollTimer:Stop()
    end
end

function LuaBossBattleMgr:OnUICloseCompleted(owner)
    if owner.uiData.id ~= Enum.UIPageName.UIWorldBossReward then
        return
    end
    self:ExitWorldBossBattle()
end






--同步战斗内玩家信息
function LuaBossBattleMgr:OnFighterLifeChanged(isBoss,actorId,life,maxLife)
    if isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Life,life,maxLife)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Fighter_Life,actorId,life,maxLife)
    end
end

function LuaBossBattleMgr:OnFighterEnergyChanged(actorId,sp,maxSp)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Fighter_Sp,actorId,sp,maxSp)
end

function LuaBossBattleMgr:OnFighterCastSkill(skillParam)
    if skillParam.isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Skill,skillParam)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Cast_Skill,skillParam)
    end
end

function LuaBossBattleMgr:OnShowBossBuff(actorId,isBoss,buffIcon,num,isPlayeRecord)
    if isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Buff,buffIcon,num)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Player_Buff,actorId, buffIcon,num)
    end
end

function LuaBossBattleMgr:OnRemoveBossBuff(actorId,isBoss,buffIcon)
    if isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Remove_Buff,buffIcon)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Remove_Player_Buff, actorId, buffIcon)
    end
end

function LuaBossBattleMgr:OnShowFighter(actorId)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Show_Fighter,actorId)
end

function LuaBossBattleMgr:ShowSkipBattle()
    self.ShowSkip = true
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHOW_SKIP_BATTLE)
end

function LuaBossBattleMgr:SetUINodeVis(nodePath)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Set_UINode_Vis,nodePath)
end

function LuaBossBattleMgr:HeroChangeProfessionSuccess()
    ManagerContainer.DataMgr.UserData:RoleChangeJobAttrSuccess()
end

return LuaBossBattleMgr