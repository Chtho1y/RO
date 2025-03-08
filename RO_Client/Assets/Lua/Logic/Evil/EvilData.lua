local EvilData = class("EvilData",require("DataBase"))

local EvilBossSlotData = require("Evil/EvilBossSlotData")

function EvilData:ctor()
    self.maxEvilExp = 0
    self.maxFreeRefreshTimes = 8
    self.leftFreeCnt = 8        --剩下的刷新次数
    self.isFreeLimit = false
    self.challengedCount = 0    --挑战的次数
    self.curEvilLevel = 0
    self.nextEvilLevelCnt = 0
    self.maxEvilLevel = 7

    self.costEvilExp = 0
    self.refreshCostGold = 50

    self.slots = {}   

    self.bInited = false  
end

function EvilData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EVIL_REFRESH_ACK,self.OnEvilRefreshAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EVIL_CHANGE_NTF,self.OnEvilChangeNtf,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EVIL_CHALLENGE_ACK,self.OnEvilChallengeAck,self)

    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_ROLE_EVIL_EXP_CHANGED,self,self.OnCheckRPState)
end

function EvilData:Clear()
    self.bInited = false
    self.slots = {}   
end

function EvilData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function EvilData:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EVIL_REFRESH_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EVIL_CHANGE_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_EVIL_CHALLENGE_ACK)

    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_ROLE_EVIL_EXP_CHANGED,self,self.OnCheckRPState);
end

function EvilData:InitData()
    if self.bInited then
        return
    end

    self.maxFreeRefreshTimes = GlobalConfig.Instance:GetConfigIntValue(155)
    self.maxEvilExp = GlobalConfig.Instance:GetConfigIntValue(158)
    self.costEvilExp = GlobalConfig.Instance:GetConfigIntValue(157)
    self.refreshCostGold = GlobalConfig.Instance:GetConfigIntValue(188)
    

    for i=1, 4 do
        self.slots[#self.slots+1] = EvilBossSlotData:new(i)
    end

    self.bInited = true
end


function EvilData:FindSlotData(slotId)
    if self.slots == nil then
        return nil
    end

    for i=1, #self.slots do
        if self.slots[i].slotId == slotId then
            return self.slots[i]
        end
    end

    return nil
end

function EvilData:HasCanFightBoss()
    if self.slots == nil then
        return false
    end

    for i = 1, #self.slots do
        if self.slots[i]:IsBossDead() == false then
            return true
        end
    end
    return false
end

function EvilData:SendEvilRefreshReq(force)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EVIL_REFRESH_REQ, {b_force=force})
end

function EvilData:OnEvilRefreshAck(data)
    if data.pos_idx_list and #data.pos_idx_list > 0 then
        for _, posIdx in pairs(data.pos_idx_list) do
            local slotData = self:FindSlotData(posIdx)
            if slotData then
                slotData:SetChangeState(true)
            end
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_SkillExpBattle_SlotData)
    end
end

function EvilData:OnEvilChangeNtf(data) 
    self:SetEvilData(data.evil_info)
    if data.add_item_list and #data.add_item_list > 0 then
        local levelUPRewards = {};
        for i = 1, #data.add_item_list do
            local itemData = data.add_item_list[i];
            levelUPRewards[#levelUPRewards+1] = {cfgId = itemData.key, num = itemData.value}
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_ROLE_EVIL_Level_CHANGED,levelUPRewards)
    end
end

function EvilData:SetEvilData(evilInfo)
    self:InitData()

    self.leftFreeCnt = evilInfo.free_count
    self.isFreeLimit = evilInfo.free_limit
    self.challengedCount = evilInfo.challenge_count
    self.curEvilLevel = evilInfo.evil_level
    local evilCfg = ManagerContainer.CfgMgr:GetEvilCfgByLevel(self.curEvilLevel)
    local nextEvilCfg = ManagerContainer.CfgMgr:GetEvilCfgByLevel(self.curEvilLevel+1)
    if nextEvilCfg ~= nil then
        self.maxEvilLevel = self.curEvilLevel + 1
    else
        self.maxEvilLevel = self.curEvilLevel
    end

    self.nextEvilLevelCnt = evilCfg.LevelTimes

    if evilInfo.boss_list ~= nil then
        for i=1, #evilInfo.boss_list do
            local bossData = evilInfo.boss_list[i]
            local slotData = self:FindSlotData(bossData.pos_idx)
            if slotData~= nil  then
                local bossHead = self:FindEvilBossHead(evilCfg,bossData.boss_id)
                slotData:SetServerData(bossData,self:FindEvilBossCfg(evilCfg,bossData.boss_id),bossHead)
            end
        end
    end
    self:OnCheckRPState()
end

function EvilData:OnCheckRPState()
    if ManagerContainer.DataMgr.UserData:GetEvilExp() >= self.costEvilExp and (self:HasCanFightBoss()  or self.leftFreeCnt > 0) then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.EvilBattle, true)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.EvilBattle, false)
    end
end

function EvilData:FindEvilBossCfg(evilCfg,bossId)
    if evilCfg == nil or evilCfg.MonsterList == nil then
        return nil
    end

    for i = 1, #evilCfg.MonsterList do
        if evilCfg.MonsterList[i][1] == bossId then
            return evilCfg.MonsterList[i]
        end
    end

    return nil
end

function EvilData:FindEvilBossHead(evilCfg,bossId)
    if evilCfg == nil or evilCfg.BossHeadList == nil then
        return nil
    end

    for i = 1, #evilCfg.BossHeadList do
        if evilCfg.BossHeadList[i][1] == bossId then
            return evilCfg.BossHeadList[i][2]
        end
    end

    return nil
end

function EvilData:SendEvilChallengeReq(slotIdx)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EVIL_CHALLENGE_REQ, {pos_idx = slotIdx})
end

function EvilData:OnEvilChallengeAck(data)
    if data.error == 0  then
        local _rewards = {};
        _rewards[#_rewards+1] = { cfgId = Enum.ItemType.SkillExp,num = data.add_count}
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Challenge_Evil_Ok,_rewards)
        local slotData = self:FindSlotData(data.pos_idx)
        if slotData then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_SkillExpBattle_SlotData)
        end
    end
end

return EvilData