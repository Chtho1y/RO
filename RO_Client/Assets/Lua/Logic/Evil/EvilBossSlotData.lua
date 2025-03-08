local EvilBossSlotData = class("EvilBossSlotData")

function EvilBossSlotData:ctor(id)
    self.slotId = id
    self.bossId = 0
    self.bossIcon = nil
    self.bossName = nil
    self.bossQuality = 1
    self.expireTime = nil
    self.rewardEvilExp = 0      --胜利奖励的技能经验
    self.leftCDTime = 0
    self.leftCDTimeHandler = nil
    self.changeState = false
end

function EvilBossSlotData:GetChangeState()
    return self.changeState
end

function EvilBossSlotData:SetChangeState(state)
    self.changeState = state
end

function EvilBossSlotData:IsBossDead()
    return self.bossId > 0 and self.expireTime > 0
end

function EvilBossSlotData:GetLeftCDTime()
    return self.leftCDTime
end

function EvilBossSlotData:SetServerData(srvData,evilBossCfg,bossHead)
    self.bossId = srvData.boss_id
    self.bossIcon = bossHead
    local npcCfg = ManagerContainer.CfgMgr:GetNpcCfgById(self.bossId)
    if npcCfg ~= nil then
        self.bossName = npcCfg.Name
    end
    self.rewardEvilExp = srvData.reward_evil_exp
    if evilBossCfg ~= nil then
        -- LogError(Inspect(evilBossCfg))
        self.bossQuality = evilBossCfg[4]
    end

    self.expireTime = srvData.expire_time
    if  self.expireTime > 0 then
        self.leftCDTime = LuaBattleBridge.CaclLeftTimeWitTimeStamp(tostring(self.expireTime))
        if self.leftCDTime < 0 then
            self.leftCDTime = 0
        end
    else
        self.leftCDTime = 0
    end
    
    self:ClearTimer()
    if self.bossId > 0 and self.leftCDTime > 0 then
        self.leftCDTimeHandler = ManagerContainer.LuaTimerMgr:AddTimer(1000, self.leftCDTime,self,self.RefreshCDTime,nil);
    end
end

function EvilBossSlotData:RefreshCDTime()
    self.leftCDTime = self.leftCDTime - 1
    if self.leftCDTime <= 0 then
        self:ClearTimer()
        ManagerContainer.DataMgr.EvilData:SendEvilRefreshReq(false)
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Evil_Refresh_SlotCDTime,self.slotId,self.leftCDTime)
end

function EvilBossSlotData:ClearTimer()
    if self.leftCDTimeHandler ~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.leftCDTimeHandler);
        self.leftCDTimeHandler = nil;
    end
end

function EvilBossSlotData:CanRefresh()
    return self.expireTime > 0 and self.leftCDTime <= 0
end


return EvilBossSlotData