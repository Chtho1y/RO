local LuaBattleMgr = class("LuaBattleMgr")
local RoleViewSystem = require("RoleViewSystem")

local NextMapState =
{
    None = 0,       -- 不需要进入下一地图
    WaitServer = 1, -- 客户端表现走到需要表现进入下一地图，而服务器消息还未下发
    WaitShow = 2,   -- 服务端消息需要进入下一地图，而等待客户端表现
}

local firstLevelId = 10001
local battleStateTimer

local reconnected = false
local CompetitionRefreshLevelLimit

function LuaBattleMgr:ctor()
    self.rageLeftTime = 0;
    self.rageLeftTimeTimer = nil;
    self.lastInComeTime = 0;        --上次领取收益时间
    self.rewardNum = 0              --累计奖励次数
    self.curLevelId = 0;            --当前关卡id
    self.curMapId = 0;              --当前地图id
    self.lastLevelId = 0;           --当前关卡id
    self.lastMapId = 0;             --当前地图id
    self.lastMapRewardCount = 0;
    self.mapRewardCount = 0;        --当前未领取次数
    self.rewardItemList = nil;
    self.accumIncomeTime = 0;
    self.maxEvilExp = 0;            --魔魂值上限

    self.maxInComeTime = 0          --最大可累计的收益时间
    self.maxQuickBattleTimes = 0;
    self.usedQuickBattleTimes = 0;
    self.nextMapState = NextMapState.None
    self.needEnterNextMap = false       -- 客户端表现已到，等待服务器进入下一个地图的消息
    self.waitEnterNextMap = false       -- 服务器消息已到，等待进入下一个地图中 （有其它切换地图的表现，则真正切换地图需要等待）

    self.bKillBoss = false
    self.isBattling = false

    self.lastMapRankPercent = 0
    
    self.LastStartOnlineTime = 0--上次时间    
    self.LastTotalOnlineTime = 0--上次累计时间   
    self.CurTotalOnlineTime = 0 --本地累计时间    
    self.LastOnlineRewardId = 0--上一次领取的奖励ID
    self.IsOverTime = false

    self.isAutochallenge = false

    --初始化 资源效率 默认取第一个关卡的效率
    local levelData = ManagerContainer.CfgMgr:GetLevelDataById(firstLevelId)
    self.lastLevelZeny = levelData.ZenyOl;
    self.lastLevelExp = levelData.BaseExpOl;
    self.lastLevelPartnerExp = levelData.ParterOl;
    self.lastLevelCruise = levelData.CruiseOl;

    self.roleViewSystem = RoleViewSystem:new()
    self:RegisterNetEvents();
end

function LuaBattleMgr:GetLastMapRankPercent()
    return self.lastMapRankPercent
end

function LuaBattleMgr:SetLastMapRankPercent(val)
    self.lastMapRankPercent = val
end

function LuaBattleMgr:Destroy()
    if self.roleViewSystem then
        self.roleViewSystem:Dispose()
    end
    self.roleViewSystem = nil
    if tolua.getpeer(self) ~= nil then
		    tolua.setpeer(self, nil)
    end
end

function LuaBattleMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_INCOME_ACK,self.OnBattleIncomeAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_BOSS_REWARD_ACK,self.OnBossRewardAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_BATTLE_DATA_CHANGE_NTF,self.OnBattleDataChangeNtf,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_QUICK_BATTLE_INCOME_ACK,self.OnQuickBattleIncomeAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_BATTLE_BOSS_FIGHT_ACK,self.OnChallengeBossFightAck,self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_BATTLE_RECORD_DETAIL_SAVE_NTF,self.OnBattleRecordDetalSaveNtf,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_BATTLE_RECORD_ACK,self.OnBattleRecordAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PLAYER_BATTLE_RECORD_DETAIL_ACK,self.OnBattleRecordDetailAck,self)

    --在线奖励
    self:RegisterOnlineRecordNet()
end

------------------------------------------------------在线奖励
--GetState
function LuaBattleMgr:GetOnlineState()
    local IsFinished = self:IsFinishedOnlineTime()
	if IsFinished then      
        local IsOver = self:IsOverOnlineDay()--是否领完当天
        if IsOver then
            return Enum.EnumOnineState.ToDayFinished
        else
            return Enum.EnumOnineState.Receive
        end		
    else
        return Enum.EnumOnineState.RunTime	
	end	
end

--注册在线奖励
function LuaBattleMgr:RegisterOnlineRecordNet()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ONLINE_TIME_REWARD_ACK,self.OnOnLineTimeRecordAck,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ONLINE_TIME_REWARD_NTF,self.OnOnLineTimeRecordNtf,self)
end
--移除在线奖励
function LuaBattleMgr:UnRegisterOnlineRecordNet()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_ONLINE_TIME_REWARD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_ONLINE_TIME_REWARD_NTF)
end

--请求领取在线奖励
function LuaBattleMgr:SendOnlineTimeRecord()
    --金币是否足够
    if self:GetOnlineState() == Enum.EnumOnineState.ToDayFinished then
        return
    end
    if self:GetOnlineState() == Enum.EnumOnineState.Receive or self:IsCanUseGoldOnline() then
        --LogError("Send Record")
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ONLINE_TIME_REWARD_REQ, {})
    end
end
--在线奖励返回
function LuaBattleMgr:OnOnLineTimeRecordAck(data)
   --LogError(Inspect(data))
    -- int32 error                             = 1;   //错误码
    -- repeated KeyValueType reward_item_list  = 2;   //奖励物品
    --show item
end



--在线奖励变化
function LuaBattleMgr:OnOnLineTimeRecordNtf(data)
    --LogError(Inspect(data)) 
    self:SyncOnlineTime(data)
end

function LuaBattleMgr:SyncOnlineTime(role_base)
    if role_base then
        --local Onlinetime = ManagerContainer.LuaTimerMgr:ParseSeconds2Time(role_base.total_online_time)
        --LogError("OnlineTime"..Onlinetime)
        --LogError("RewardId"..tostring(role_base.online_reward_id))
        self.LastStartOnlineTime = role_base.online_stamp / 1000 
        self.LastStartOnlineTime = type(self.LastStartOnlineTime) == "number" and self.LastStartOnlineTime or #self.LastStartOnlineTime
        self.LastTotalOnlineTime = role_base.total_online_time
        self.LastOnlineRewardId = role_base.online_reward_id
    end
    if self.LastOnlineRewardId <= 0 then --当天未领取 计算领取上一期领取ID
        local OnlineDay = self:GetTotalDay() + 1 --注册当天就算1天
        local Pre_reward_id = self:GetPreDayIdx(OnlineDay)
        self.StartOnlineIdx = Pre_reward_id
    else
        self.StartOnlineIdx = self.LastOnlineRewardId
    end
    --LogError("Sync = "..tostring(self.StartOnlineIdx))
    self.CurTotalOnlineTime = 0
    self.IsOverTime = false
    self:UpdateOnlineTime()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_REFRESH_ONLINETIME_CHANGESTATE);
    if not self:IsFinishedOnlineTime() then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.OnlineRewards, false)
    end
end

function LuaBattleMgr:FinishedOnlineTime()
    self.IsOverTime = true
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.OnlineRewards, true)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_REFRESH_ONLINETIME_CHANGESTATE);
end

--是否可以领取当前
function LuaBattleMgr:IsFinishedOnlineTime()
    return self.IsOverTime
end

--获取online数据 根据天数
function LuaBattleMgr:GetDayOnlineData(Day)
    local CurDay = Day
    if CurDay == 0 then
        CurDay = 1
    end
    local cfgRwards = ManagerContainer.CfgMgr:GetOnlineRwards()
    local tbRwards = {}
    for i=1,#cfgRwards do
        if cfgRwards[i].Day == CurDay then 
            table.insert(tbRwards,cfgRwards[i])
        end
    end
    --未取到  取最后表最后一天
    if #tbRwards <= 0 then
        return self:GetLastOnlineRwards()
    end
   return tbRwards
end

--获取上一次领取ID根据天数
function LuaBattleMgr:GetPreDayIdx(CurDay)
    local tbRwards = self:GetDayOnlineData(CurDay)
    if tbRwards then
        if #tbRwards >= 1 then
            return tbRwards[1].Id - 1
        end
    end
    return 0
end

--是否领取完当天
function LuaBattleMgr:IsOverOnlineDay()    
    if self.LastOnlineRewardId <= 0 then
        return false
    end
    local cfgRwards = ManagerContainer.CfgMgr:GetOnlineRwards()
    local OverDay = cfgRwards[self.LastOnlineRewardId].Day
    local LastId = self.LastOnlineRewardId + 1
    if LastId > #cfgRwards then    --超出 结束
        return true
    end
    for i=LastId,#cfgRwards do
        if cfgRwards[i].Day == OverDay then       
            return false
        end
    end
    return true
end

function LuaBattleMgr:UpdateOnlineTime()
    if nil == self.IsOverTime or self.IsOverTime then
        return true,ManagerContainer.LuaTimerMgr:ParseSeconds2Time(0)
    end
    local LastStartTime = self.LastStartOnlineTime - self.LastTotalOnlineTime
    local CurTime = ManagerContainer.LuaTimerMgr:GetTimeSecond()
    local totaTime = self:GetNextTotalOnlineTime() - self.LastTotalOnlineTime --剩余秒数
    if totaTime <= 0 then
        totaTime = 0
    end
    local finishlTime = self.LastStartOnlineTime + totaTime --结束时间
    local DeltaTime =  finishlTime - CurTime
    if self:IsOverOnlineDay() then
        DeltaTime = 0
    end
    if DeltaTime <= 0 then
        DeltaTime = 0
        self:FinishedOnlineTime()
    end        
    local str = tostring(math.modf(DeltaTime/60))..I18N.T("MINS")..tostring(DeltaTime%60)..I18N.T("S")
    --local str = ManagerContainer.LuaTimerMgr:ParseSeconds2Time(DeltaTime)
    -- local strCur = ManagerContainer.LuaTimerMgr:ParseTimeStamp2Format(CurTime, "%H:%M")
    -- local strLast = ManagerContainer.LuaTimerMgr:ParseTimeStamp2Format(LastTime, "%H:%M")
    -- LogError(strCur)
    -- LogError(strLast)
    return false,str
end

--累计创角天数获取
function LuaBattleMgr:GetTotalDay()
    local CreateTime =  ManagerContainer.DataMgr.UserData:GetCreateTime()
    CreateTime = CreateTime / 1000 
    CreateTime = type(CreateTime) == "number" and CreateTime or #CreateTime

    local TotalTime = tonumber(self.LastStartOnlineTime) - tonumber(CreateTime)
    local DeltaD =  math.modf(TotalTime/3600/24)
    local DeltaS =  TotalTime - DeltaD*3600*24   
    --获取注册时间戳小时
    local CreateHour = tonumber(ManagerContainer.LuaTimerMgr:Getstamp2TimeH("%H",CreateTime))     
    --下一天时间戳计算
    local NextDayTime = tonumber(CreateTime)    --小于5点 求当天5点时间戳 
    if CreateHour > 5 then --大于5点 求下一天5点时间戳
        NextDayTime = tonumber(CreateTime) + 24 * 3600        
    end   
    local Y = tonumber(ManagerContainer.LuaTimerMgr:Getstamp2TimeH("%Y",NextDayTime))
    local M = tonumber(ManagerContainer.LuaTimerMgr:Getstamp2TimeH("%m",NextDayTime))
    local D = tonumber(ManagerContainer.LuaTimerMgr:Getstamp2TimeH("%d",NextDayTime))
    local Data = {year=Y, month=M, day=D, hour=5, minute=0, second=0}    
    local DayEndStamp = ManagerContainer.LuaTimerMgr:GetTime2StampS(Data)

    --注册当天距离第二天总秒
    local TotalEndTime = DayEndStamp - CreateTime
    ---剩余秒数 是否大于第二天总秒数 
    if DeltaS >  TotalEndTime then --剩余时间是否过了凌晨5点 过了+1天
        DeltaD = DeltaD + 1
    end
    -- LogError("DeltaD"..tostring(DeltaD))
    -- LogError("DeltaS"..tostring(DeltaS))
    -- LogError("CreateDay"..ManagerContainer.LuaTimerMgr:Getstamp2TimeH("%Y-%m-%d %H:%M:%S",CreateTime))
    -- LogError("CreateDay"..ManagerContainer.LuaTimerMgr:Getstamp2TimeH("%Y-%m-%d %H:%M:%S",DayEndStamp))
    -- LogError("LastStartOnlineTime"..ManagerContainer.LuaTimerMgr:Getstamp2TimeH("%Y-%m-%d %H:%M:%S",self.LastStartOnlineTime))
    -- LogError(tostring(DeltaD))   
    return DeltaD
 end

--最后一天数据
function LuaBattleMgr:GetLastOnlineRwards()
    local tbRwards = {}
    local cfgRwards = ManagerContainer.CfgMgr:GetOnlineRwards()
    local OverDay = cfgRwards[#cfgRwards].Day
    for i=1,#cfgRwards do
        if cfgRwards[i].Day == OverDay then            
            table.insert(tbRwards,cfgRwards[i])
        end
    end
    return tbRwards
end

--获取ID的天数数据
function LuaBattleMgr:GetOnlineRwardsById(Id)
    local tbRwards = {}
    local cfgRwards = ManagerContainer.CfgMgr:GetOnlineRwards()
    if Id > #cfgRwards then --ID超出 获取超出后一天数据
        return self:GetLastOnlineRwards()
    end
    -- LogError("GetOnlineRwardsById"..tostring(Id))
    -- LogError(Inspect(cfgRwards[Id]))
    local OverDay = cfgRwards[Id].Day
    for i=1,#cfgRwards do
        if cfgRwards[i].Day == OverDay then
            table.insert(tbRwards,cfgRwards[i])
        end
    end
    return tbRwards
end

--下一个数据时间 跟 奖励
function LuaBattleMgr:GetNextTotalOnlineTime()
    local cfgRwards = ManagerContainer.CfgMgr:GetOnlineRwards()
    local TotalTime = 0
    local Rewards = {}
    if cfgRwards then
        local NextId = self.StartOnlineIdx + 1  
        local Cfg = self:GetOnlineRwardsById(NextId)
        if Cfg then            
            for i = 1,#Cfg do                
                if NextId > #cfgRwards then --超出范围 取最后一天第1个开始
                    TotalTime = Cfg[1].Time
                    Rewards = Cfg[1].Rewards
                else--未超出范围 累计获取时间
                    if Cfg[i].Id == NextId then
                        --不累计
                        --TotalTime = TotalTime + Cfg[i].Time --* 60
                        TotalTime = Cfg[i].Time
                        Rewards = Cfg[i].Rewards
                    end
                end
            end
        end
    end
    return TotalTime + 3,Rewards   --3秒延迟 防止服务器时间差
end

--是否可以用金币加速当前
function LuaBattleMgr:IsCanUseGoldOnline()
    local Goldcount = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.Diamond)
    local NeedItem = self:GetOnlineTimeGlod()
    if NeedItem <= Goldcount then
        return true
    end
    return false
end

--获取领取当前金币数据
function LuaBattleMgr:GetOnlineTimeGlod()
    local cfgRwards = ManagerContainer.CfgMgr:GetOnlineRwards()
    local GoldNum = 0
    if cfgRwards then
        local NextId = self.StartOnlineIdx +1
        local Cfg = self:GetOnlineRwardsById(NextId)
        if Cfg then
            for i = 1,#Cfg do
                if Cfg[i].Id == NextId then
                    GoldNum = Cfg[i].SpeedUp
                end
            end
        end
    end
    return GoldNum
end
-------------------------------------------------------------------
function LuaBattleMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PLAYER_INCOME_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PLAYER_BOSS_REWARD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PLAYER_BATTLE_DATA_CHANGE_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_QUICK_BATTLE_INCOME_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_BATTLE_BOSS_FIGHT_ACK)
    self:UnRegisterOnlineRecordNet()
end

function LuaBattleMgr:SendChallengeBossReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_BATTLE_BOSS_FIGHT_REQ, {})
end

function LuaBattleMgr:OnChallengeBossFightAck(data)
    if data.error == Enum.NetErrorCode.ERROR_OK then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Challenge_Boss_Fight_ACK,data.factor_list)
    else
        if data.left_cd_time > 0 then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BATTLE_CHALLENGE_TIME_REFRESH, data.left_cd_time)
        end
    end
end

function LuaBattleMgr:SendQuickBattleReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_QUICK_BATTLE_INCOME_REQ, {})
end

function LuaBattleMgr:SendBattleIncomeReq()
    local _isOverFlow, _evilExp = self:JudgeEvilExpOverFlow();
    if _isOverFlow then
        ManagerContainer.LuaUIMgr:ShowMessageBox("EvilOverFlowTips",{_evilExp, self.maxEvilExp},nil,self,self.CSPlayerIncomeReq,nil)
    else
        self:CSPlayerIncomeReq();
    end
end

function LuaBattleMgr:OnBattleIncomeAck(playerIncomeAck)
    if playerIncomeAck.error == 0 then
        self.rewardItemList = playerIncomeAck.item_list
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_BATTLE_INCOME_ACK,0);
    end
end

function LuaBattleMgr:OnQuickBattleIncomeAck(playerIncomeAck)
    if playerIncomeAck.error == 0 then
        self.rewardItemList = playerIncomeAck.item_list
        local itemIcons = {};
        for i =1, #self.rewardItemList do
            local item = self.rewardItemList[i];
            if item.key >= 100 then
                local itemCfg = ManagerContainer.CfgMgr:GetItemById(item.key)
                if itemCfg~= nil then
                    itemIcons[#itemIcons+1] = itemCfg.Icon
                end
            end
        end
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleReward,1)
    end
end

function LuaBattleMgr:GetRewardCnt(type)
    if self.rewardItemList == nil then
        return 0
    end

    for i =1, #self.rewardItemList do
        local item = self.rewardItemList[i];
        if item.key == type then
            return item.value;
        end
    end

    return 0;
end

function LuaBattleMgr:SendBossRewardReq(killedBossTime,recordTimeStamp)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PLAYER_BOSS_REWARD_REQ, {challenge_time = killedBossTime,map_id =self.curMapId ,map_level=self.curLevelId,record_time_stamp=recordTimeStamp})
end

function LuaBattleMgr:OnBossRewardAck(playerBossRewardAck)
    if battleStateTimer then
        ManagerContainer.LuaTimerMgr:RemoveTimer(battleStateTimer)
        battleStateTimer = nil
    end

    if playerBossRewardAck.error == 0 then
        ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIChat)
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattle)

        self.rewardItemList = playerBossRewardAck.item_list
        if self:IsNewMap() then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleBossBox)
        else
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleWin)
        end
    else
        -- LogError("----------------OnBattleIncomeAck---- " .. playerBossRewardAck.error)
        self:ClearRageTimer()
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_BATTLE_FAILED);
    end
    
end

function LuaBattleMgr:OnBattleDataChangeNtf(data)
    self:SetBattleData(data,false)
    -- LogError("self.lastInComeTime -- " .. self.lastInComeTime)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_REFRESH_REWARD_TIME);
end

function LuaBattleMgr:GetRewardMapCount()
    return self.lastMapRewardCount
end

function LuaBattleMgr:SetBattleData(data,first)
    local preMapId = self.curMapId;

    self.lastLevelId = self.curLevelId
    self.lastMapId = self.curMapId

    self.lastInComeTime = data.last_income_time
    self.curMapId = data.map_id
    self.curLevelId = data.map_level

    if first then
        CompetitionRefreshLevelLimit = GlobalConfig.Instance:GetConfigIntValue(248)
        ManagerContainer.UIFuncUnlockMgr:SetLoggedinLevelId(self:GetCurLevelUniqueId())
    end

    self.lastMapRewardCount = self.mapRewardCount
    self.mapRewardCount = data.reward_map_count

    local rewardIntervalTime = GlobalConfig.Instance:GetConfigIntValue(47)
    local passedTime = ManagerContainer.LuaGameMgr:CalcPassedTime(self.lastInComeTime) / 1000
    if passedTime >=  self.maxInComeTime then
		passedTime = self.maxInComeTime
    end

    self.maxRewardNum = self.maxInComeTime / rewardIntervalTime

    self.rewardNum = CommonUtil.GetPreciseDecimal(math.floor(passedTime / rewardIntervalTime),0)
    self.leftRewardTime = rewardIntervalTime - (passedTime - self.rewardNum*rewardIntervalTime)
    if self.leftRewardTime <= 0 or  self.leftRewardTime > rewardIntervalTime then
        self.leftRewardTime = rewardIntervalTime
    end

    if data.quick_battle ~= nil then
        if data.quick_battle.max_times ~= nil then
            self.maxQuickBattleTimes  = data.quick_battle.max_times
        end

        if  data.quick_battle.day_times ~= nil then
            self.usedQuickBattleTimes = data.quick_battle.day_times
        end
    end

    ManagerContainer.LuaGameMgr:SetMapLevelId(self.curMapId,self.curLevelId);
    if preMapId > 0 and preMapId~= self.curMapId then
        if self.nextMapState == NextMapState.WaitServer then
            self:ShowEnterNextMap()
            return
        end
        self.nextMapState = NextMapState.WaitShow
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_LEVEL_CHANGED)
end

function LuaBattleMgr:IsNewMap()
    return self.curMapId > self.lastMapId
end

function LuaBattleMgr:StartSyncServerTimeTimer()
    if self.timerId ~= nil then
        return
    end

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GET_SERVER_TIME_ACK,self.OnUpdateServerTimeAck,self)
    self.timerId = ManagerContainer.LuaTimerMgr:AddTimer(60000, -1, self, self.SendGetServerTimeReq, nil)
end

function LuaBattleMgr:SendGetServerTimeReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_SERVER_TIME_REQ, {})
end

function LuaBattleMgr:SetReconnected(result)
    reconnected = result
end

function LuaBattleMgr:OnUpdateServerTimeAck(timeAck)
    ManagerContainer.LuaTimerMgr:SyncServerTime(timeAck.server_time)

    --每分钟判断
    ManagerContainer.DataMgr.RankActivitiesMgr:CheckRancActivityOpenTime()
    ManagerContainer.DataMgr.RuneShopDataMgr:CheckAirShipActivityOpenTime()
    ManagerContainer.DataMgr.CompetitionData:UpdateCompetitionTime()
    ManagerContainer.DataMgr.ActsDataMgr:UpdateActsEndTime()

    if reconnected then
        reconnected = false

        self:RefreshRewardNum()
    end
end

function LuaBattleMgr:StopSyncServerTimeTimer()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GET_SERVER_TIME_ACK)
    if self.timerId~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.timerId)
        self.timerId = nil
    end
end

--收益累积时长
function LuaBattleMgr:AccumIncomeTime()
    local passedTime = ManagerContainer.LuaGameMgr:CalcPassedTime(self.lastInComeTime);
    return passedTime;
end

function LuaBattleMgr:MaxInComeTime()
    return self.maxInComeTime
end

function LuaBattleMgr:GetIncomeInfo()
    return self.leftRewardTime, self.rewardNum
end

function LuaBattleMgr:RefreshRewardNum()
    local rewardIntervalTime = GlobalConfig.Instance:GetConfigIntValue(47)
    local passedTime = ManagerContainer.LuaGameMgr:CalcPassedTime(self.lastInComeTime) / 1000
    if passedTime >=  self.maxInComeTime then
        passedTime = self.maxInComeTime
    end

    self.rewardNum = CommonUtil.GetPreciseDecimal(math.floor(passedTime / rewardIntervalTime),0)
    self.leftRewardTime = rewardIntervalTime - (passedTime - self.rewardNum*rewardIntervalTime)
    if self.leftRewardTime <= 0 or  self.leftRewardTime > rewardIntervalTime then
        self.leftRewardTime = rewardIntervalTime
    end
end

function LuaBattleMgr:OnRefreshRewardTime()
    self:RefreshRewardNum()
    --self.leftRewardTime = self.leftRewardTime - 1
    if self.leftRewardTime <= 0  then
        self.leftRewardTime = GlobalConfig.Instance:GetConfigIntValue(47)
        self.rewardNum = self.rewardNum + 1
        if self.rewardNum > self.maxRewardNum then
            self.rewardNum = self.maxRewardNum
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_REFRESH_REWARD_TIME);
end
function LuaBattleMgr:StartAutoChallenge()
    if not self.isAutochallenge then
        return
    end

    local sec = GlobalConfig.Instance:GetConfigIntValue(311)
    if sec < 0 then
        sec = 0
    end

    if not self.autoChallengeTimer then
        self.autoChallengeTimer = Timer.New(function()
			self:AutoChallenge()
        end, sec, 1)
    else
        self.autoChallengeTimer:Reset(function()
			self:AutoChallenge()
        end, sec, 1)
    end
    if not self.autoChallengeTimer.running then
        self.autoChallengeTimer:Start()
    end
end

function LuaBattleMgr:AutoChallenge()
    if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIBattle) then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_CHALLENGE_AUTO)
    end
end

function LuaBattleMgr:StopAutoChallenge(force)
    if self.autoChallengeTimer then
        self.autoChallengeTimer:Stop()
        self.autoChallengeTimer = nil
    end
    if self.isAutochallenge then
        self.isAutochallenge = false
        if force then
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("stopautobattle")
        end
    end
    
end

function LuaBattleMgr:GetAutoChallengeState()
    return self.isAutochallenge
end

function LuaBattleMgr:SetAutoChallengeState(value)
    self.isAutochallenge = value
end
--boss出生
function LuaBattleMgr:OnBossSpawned(bossActor,bossName,life,maxLife,skillParam,isPlayRecord)
    self.bKillBoss = true
    --boos 展示等级设置为当前关卡Turn
    local curLevel = ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId()
    local levelData = ManagerContainer.CfgMgr:GetLevelDataById(curLevel)
    bossActor.ShowLevel = levelData.Turn
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_BOSS_SPAWNED,bossActor,bossName,life,maxLife,skillParam,isPlayRecord)
end

function LuaBattleMgr:OnCloneNewBoss(bossName,life,maxLife,skillParam)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_CLONE_NEW_BOSS,bossName,life,maxLife,skillParam)
end

-- 开始战斗
function LuaBattleMgr:OnFightingStart(killingBoss)
    self.isBattling = true
    if killingBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_FIGHTING_START)
    end
end

--清空战斗统计日志
function LuaBattleMgr:ClearBattleLog()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_CLEAR_New_BattleLog)
end


function LuaBattleMgr:GetFightState()
    return self.isBattling
end

function LuaBattleMgr:GetBossFightState()
    return self.bKillBoss
end

-- 战斗胜利
function LuaBattleMgr:OnBattleWin(killboss, killBossTime, mapId, levelId, isPlayRecord, recordTimeStamp)
    self:CloseBattleStatistics()
    self.isBattling = false
    if killboss then
        self.bKillBoss = false
        if not isPlayRecord then
            if self.curMapId == mapId and self.curLevelId == levelId then
                self:SendBossRewardReq(killBossTime,recordTimeStamp)
            else
                LogError('[wboy] curMapId : ' .. tostring(self.curMapId) .. ' curMapId : ' .. tostring(self.curLevelId) .. ' mapId : ' .. tostring(mapId) .. ' levelId : ' .. tostring(levelId))
            end
            battleStateTimer = ManagerContainer.LuaTimerMgr:AddTimer(5000, 1,self,self.BattleStateRefresh,nil);
        end

        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_BATTLE_NORMAL_NTF)

        local levelId = self:GetCurLevelUniqueId()
        if levelId >= CompetitionRefreshLevelLimit then
            ManagerContainer.DataMgr.CompetitionData:SetRefreshSeasonState(true)
            ManagerContainer.DataMgr.CompetitionData:QueryCurCompetitionReq(true)
        end

        ManagerContainer.DataMgr.RankActivitiesMgr:QueryCurRankActivityData(Enum.RankActivitiesType.MapProgress)
    end
    self:ClearRageTimer()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_BATTLE_WIN);
end

function LuaBattleMgr:BattleStateRefresh()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GOT_ANIM_TYPE_END_NOTIFY, Enum.ItemIEnterType.BattleWin)
end

--战斗失败
function LuaBattleMgr:OnBattleFailed(killboss,isPlayRecord)
    self:CloseBattleStatistics()
    self.isBattling = false
    self.bKillBoss = false
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_BATTLE_NORMAL_NTF)
    self:ClearRageTimer()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_BATTLE_FAILED,killboss,isPlayRecord);
    self:StopAutoChallenge(true)
end

--强制巡游战斗失败
function LuaBattleMgr:OnForceBattleFailed(killboss,isPlayRecord)
    self:CloseBattleStatistics()
    self.isBattling = false
    self.bKillBoss = false
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_BATTLE_NORMAL_NTF)
    self:ClearRageTimer()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_FORCEBATTLE_FAILED,killboss,isPlayRecord);
end

function LuaBattleMgr:CloseBattleStatistics()
    if self.bKillBoss then
        ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIBattleStatistics)
        ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIBattleBossTips)
    end
end

function LuaBattleMgr:ShowErrorQuitBattleMsgBox()
    ManagerContainer.LuaUIMgr:ShowOkMessageBox("ErrorQuitBattleTip",self.QuitBattleMsgOk)
end

function LuaBattleMgr:QuitBattleMsgOk()
    LuaBattleBridge.SkipReplay()
end

function LuaBattleMgr:CloseErrorQuitBattleMsgBox()
    ManagerContainer.LuaUIMgr:CloseOkMessageBox("ErrorQuitBattleTip")
end

function LuaBattleMgr:ShowAntiCheatMsgBox(nType)
    --上报使用外挂
	self:SendAntiCheat(nType)
    ManagerContainer.LuaUIMgr:ShowOkMessageBox("AntiCheatMsg",self.AntiCheatQuitGameMsgOk)
end

function LuaBattleMgr:SendAntiCheat(nType)
    --上报使用外挂
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ANTI_CHEAT_REQ, { cheat_type = nType})    
end

function LuaBattleMgr:AntiCheatQuitGameMsgOk()
    ManagerContainer.NetManager:ResetNetMgr()
	ManagerContainer.LuaGameMgr:QuitGame()
end

function LuaBattleMgr:CloseAntiCheatMsgBox()
    ManagerContainer.LuaUIMgr:CloseOkMessageBox("AntiCheatMsg")
end

function LuaBattleMgr:GetCurLevelUniqueId()
    return self.curMapId*10000 + self.curLevelId
end

function LuaBattleMgr:GetLastLevelUniqueId()
    return self.lastMapId*10000 + self.lastLevelId
end

--下一关卡
function LuaBattleMgr:OnBattleNewWave(levelName)
    self.nextMapState = NextMapState.None
    -- if ManagerContainer.UIFuncUnlockMgr:NeedOpenFuncCurLevelStart(self:GetCurLevelUniqueId()) then
    --     --功能解锁
    --     ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FUNCLOCK_OPEN_NTF)
    --     ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_BATTLE_FUNC_OPEN_NTF);
    -- else
        -- self.closeLevelNameTimer = ManagerContainer.LuaTimerMgr:AddTimer(GlobalConfig.Instance:GetConfigFloatValue(79)*1000, 1,self,self.OnCloseLevelName,nil);
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_NEXT_BATTLE,levelName);
    -- end
end

function LuaBattleMgr:OnCloseLevelName()
    self.closeLevelNameTimer = nil;
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_HIDE_LEVEL_NAME);
end

--继续同一关战斗
function LuaBattleMgr:OnContinueBattle()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_CONTINUE_BATTLE);

    ----如果还是处于第一关 且 强制引导战斗没成功 则继续强制引导战斗
    --local curLevelId = self:GetCurLevelUniqueId()
    --if curLevelId == 10001 then
    --    ManagerContainer.ForceGuideMgr:GuideBossBattle()
    --end
end

function LuaBattleMgr:OnShowBossRage(vis)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHOW_BOSS_RAGE)
end

--狂暴剩余时间
function LuaBattleMgr:OnShowBossRageLeftTime(leftTime)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHOW_BOSS_RAGE_LEFTTIME,leftTime);
end

--boss进入狂暴
function LuaBattleMgr:OnBossInRage()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_BOSS_IN_RAGE);
end

function LuaBattleMgr:OnBattleStartStory(levelId, storyId)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UISTORY_CONDITION_TRIGGER, Enum.UIStoryCondType.FirstSceneEnter, levelId, storyId)
end

--战斗结束
function LuaBattleMgr:OnBattleEnd(killBoss,killBossTime,win,isPlayRecord)
    self.lastLevelZeny = self:CurLevelZeny()
    self.lastLevelExp = self:CurLevelExp()
    self.lastLevelPartnerExp = self:CurLevelParnterExp()
    self.lastLevelCruise = self:CurLevelCruise()
    if killBoss then
        --self.bKillBoss = false
        if not isPlayRecord then
            --ManagerContainer.DataMgr.BigMapData:SendGetData()
        end
        
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_BOSS_Battle_End,isPlayRecord)
        self:OnBattleUIVis(true)
    end
end

------------------战斗录像相关----------------------------------------
function LuaBattleMgr:SendBattleDetailReq(battleRecordUid,battleTime,fightPower)
    self.curReqBattleRecordId = battleRecordUid
    self.cacheRecordBattleTime = battleTime
    self.cacheRecordFightPower = fightPower
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PLAYER_BATTLE_RECORD_DETAIL_REQ, {battle_record_uid = battleRecordUid})
end


function LuaBattleMgr:OnBattleRecordDetailAck(pkg)
    -- LogError(Inspect(pkg))
    if pkg.error == 0 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Fetch_BattleRecord_Success,pkg.battle_record_uid,pkg.battle_record)
        ManagerContainer.LuaGameMgr:SetGameSpeed(ManagerContainer.LuaGameMgr.GameSpeed)
        self:StopAutoChallenge(true)
    end
end

function LuaBattleMgr:GetCacheRecordInfo()
    return self.cacheRecordBattleTime, self.cacheRecordFightPower
end

function LuaBattleMgr:OnBattleRecordDetalSaveNtf(pkg)
    --LogError("OnBattleRecordDetalSaveNtf Save")
    local battleRecordUid = pkg.battle_record_uid
    local battleTimeStamp = pkg.record_time_stamp
    local battleRecordStr = LuaBattleBridge.GetBattleRecord(battleTimeStamp)
    if battleRecordStr ~= nil and battleRecordStr~="" then
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PLAYER_BATTLE_RECORD_DETAIL_SAVE_REQ, {battle_record_uid = battleRecordUid, battle_record = battleRecordStr})
    end
end

function LuaBattleMgr:OnBattleRecordAck(pkg)
    if pkg.error == 0 then
        if #pkg.record_list > 0 then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleReplay,pkg.record_list)
        else
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NullBattleReport")
        end
    end
end
-------------------------------------------------------------------------

function LuaBattleMgr:OnReplayEnd()
    self:CloseBattleStatistics()
    self.isBattling = false
    self.bKillBoss = false
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_BATTLE_NORMAL_NTF)
    self:ClearRageTimer()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_BATTLE_WIN);
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoExit,true)
end

function LuaBattleMgr:GetBossFightStatus()
    return self.bKillBoss
end

function LuaBattleMgr:ClearRageTimer()  
    if self.rageLeftTimeTimer ~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.rageLeftTimeTimer);
        self.rageLeftTimeTimer = nil;
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_BOSS_IN_RAGE);
    end
end

--bIsForce 强制结束战斗 设置属性
function LuaBattleMgr:SetTeamData(ignore,bIsForce)   
    local teamData = ManagerContainer.DataMgr.UserData:GetTeamData(ignore);
    if teamData == nil then return end
    ManagerContainer.LuaGameMgr:SetTeamData(teamData,{bIsForce})
    ManagerContainer.LuaActorAttributeMgr:SyncServerActorDataToLocal()
end

--更新技能数据
function LuaBattleMgr:UpdateTeamSkills()
    local usersSkills = {}
    local heroId = ManagerContainer.DataMgr.UserData:GetId()
    local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(heroId)
    local skills = skillData and skillData:GetUsedSkills() or {}
    local heroData = CommonUtil.GetHeroLogicDataByUid(1)
    CommonUtil.ReplaceBattleSkillBySkillEquip(heroData, skills)
    usersSkills[#usersSkills+1] = {
        uid = heroId,
        skills = skills,
    }

    local list = ManagerContainer.DataMgr.PartnerData:GetBattlePartnerDatas(true)
    if list ~= nil then
        for _,v in pairs(list) do
            skillData = ManagerContainer.DataMgr.UserData:GetSkillData(v.uid)
            local skills = skillData and skillData:GetUsedSkills() or {}
            CommonUtil.ReplaceBattleSkillBySkillEquip(v, skills)
            usersSkills[#usersSkills + 1] = {uid = v.uid, skills = skills }
        end
    end

    ManagerContainer.LuaGameMgr:UpdateTeamSkills(usersSkills);
end

function LuaBattleMgr:NotifyEnterNextMapStart()
    if self.nextMapState == NextMapState.WaitShow then
        self:ShowEnterNextMap()
        return
    end
    self.nextMapState = NextMapState.WaitServer
end

function LuaBattleMgr:NotifyEnterNextMapEnd()
    if ManagerContainer.FSMMgr:IsBattleState() then
        -- 在战斗场景中，才走大地图过图效果
        self:OnEnterNextMap()
    end
end

function LuaBattleMgr:NotifyVipLvChanged()
    self.maxInComeTime = GlobalConfig.Instance:GetConfigIntValue(48)
    self.maxQuickBattleTimes = GlobalConfig.Instance:GetConfigIntValue(240)
    local vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
    local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
    if vipCfg then
        self.maxInComeTime = self.maxInComeTime + tonumber(vipCfg.HangupDuration)
        self.maxQuickBattleTimes = self.maxQuickBattleTimes + tonumber(vipCfg.HangupTimes)
    end
end

function LuaBattleMgr:ShowEnterNextMap()
    if ManagerContainer.FSMMgr:IsBattleState() then
        -- 在战斗场景中，才走大地图过图效果
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIWorldMap, true)
    end
end

-- 创建主角形象
function LuaBattleMgr:CreateRoleView()
    if self.roleViewSystem then
        local userData = ManagerContainer.DataMgr.UserData
        local heroData = userData:GetMainRoleData()
        self.roleViewSystem:RefreshView(Enum.RoleInEnvType.Battle, userData:GetUserRoleId(), userData:GetViewData(), nil, self, self.CreateRoleViewComplete)
    end
end

-- 完成主角创建
function LuaBattleMgr:CreateRoleViewComplete(gameObject)
    ManagerContainer.LuaGameMgr:CreateRoleViewComplete(gameObject)
end

-- 通知战斗需要更新主角新形象
function LuaBattleMgr:NotifyRefreshRoleView()
    self.waitingRefreshRole = true
    ManagerContainer.LuaGameMgr:NotifyRefreshRoleView()
end

function LuaBattleMgr:GetWaitingRefreshRoleState()
    return self.waitingRefreshRole == true
end

-- 刷新主角形象
function LuaBattleMgr:RefreshRoleView()
    if self.roleViewSystem then
        local userData = ManagerContainer.DataMgr.UserData
        local heroData = userData:GetMainRoleData()
        self.roleViewSystem:RefreshView(Enum.RoleInEnvType.Battle, userData:GetUserRoleId(), userData:GetViewData(), nil, self, self.RefreshRoleViewComplete)
    end
end

-- 完成主角形象更新
function LuaBattleMgr:RefreshRoleViewComplete(gameObject, isNewModel)
    self.waitingRefreshRole = false
    ManagerContainer.LuaGameMgr:RefreshRoleViewComplete(gameObject, isNewModel)

    self:NotifyLoadingStatusEnd(Enum.BattleBtnState.RoleModel)
end

function LuaBattleMgr:RecycleRoleView()
    if self.roleViewSystem then
        self.roleViewSystem:Recycle()
    end
end

-- function LuaBattleMgr:NotifyRefreshUpRoleLvEffect()
--     self:NotifyRefreshUpLvEffect('Common/FX_Scene_LV_UP')
-- end

-- function LuaBattleMgr:NotifyRefreshUpJobLvEffect()
--     self:NotifyRefreshUpLvEffect('Common/FX_Scene_LV_UP')
-- end

-- function LuaBattleMgr:NotifyRefreshUpLvEffect(effectName)
--     if not self.roleViewSystem then return end
--     local roleGo = self.roleViewSystem:GetGameObject()
--     if tolua.isnull(roleGo) then return end
--     local timeStamp = Time.GetTimestamp()
--     if not self.upLvEffectCDs then
--         self.upLvEffectCDs = {}
--     end
--     local upLvEffectCD = self.upLvEffectCDs[effectName] or (timeStamp - 2)
--     -- 1秒内不出现两次升级特效
--     if timeStamp - upLvEffectCD <= 1 then
--         return
--     end
--     self.upLvEffectCDs[effectName] = timeStamp
--     ManagerContainer.ResMgr:GetGOFromPool(Constants.EffectPath, effectName, function(go)
--         if ManagerContainer.FSMMgr:IsBattleState() then
--             self:UpLvEffectShow(go, effectName)
--         end
--     end)
-- end

-- --- 显示升级特效
-- function LuaBattleMgr:UpLvEffectShow(go, effectName)
--     if not go then return end
--     if self.roleViewSystem then
--         local roleGo = self.roleViewSystem:GetGameObject()
--         if not tolua.isnull(roleGo) then
--             local link = roleGo.transform:Find('foot_point')
--             if not tolua.isnull(link) then
--                 go.transform.parent = link
--                 go.transform.localPosition = Vector3.zero
--                 go.transform.localRotation = Quaternion.identity
--                 go.transform.localScale = Vector3.one
--                 local upLvEffects = self.upLvEffects
--                 if not upLvEffects then
--                     upLvEffects = {}
--                     self.upLvEffects = upLvEffects
--                 end
--                 local info = {}
--                 info.effectName = effectName
--                 info.timerId = ManagerContainer.LuaTimerMgr:AddTimer(2000, 1, self, self.UpLvEffectHide, {go = go})
--                 upLvEffects[go] = info
--                 return
--             end
--             LogError('Link Point : foot_point is not Find')
--         end
--     end
--     -- 出现问题，直接回收掉效果，直接回收掉升级特效
--     ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath, effectCfg.Effect, go)
-- end

-- --- 升级特效播放完成，需要回收掉
-- function LuaBattleMgr:UpLvEffectHide(timerId, params)
--     local go = params.go
--     if not go then return end
--     local upLvEffects = self.upLvEffects
--     if not upLvEffects then return end
--     local info = upLvEffects[go]
--     local timeId = info.timerId
--     local effectName = info.effectName
--     if timeId ~= timerId then
--         LogError('timeId is error, cur : ' .. tostring(timeId) .. '  cbTimerId : ' .. tostring(timerId))
--     end
--     if timeId then
--         ManagerContainer.LuaTimerMgr:RemoveTimer(timeId)
--         timeId = nil
--     end
--     upLvEffects[go] = nil
--     ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath, effectName, go)
-- end

-- --- 回收所有显示的升级特效
-- function LuaBattleMgr:RecycleUpLvEffect()
--     local upLvEffects = self.upLvEffects
--     if not upLvEffects then return end
--     for go, info in pairs(upLvEffects) do
--         local timeId = info.timerId
--         local effectName = info.effectName
--         if timeId then
--             ManagerContainer.LuaTimerMgr:RemoveTimer(timeId)
--             timeId = nil
--         end
--         ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath, effectName, go)
--     end
--     self.upLvEffects = nil
--     self.upLvEffectCDs = nil
-- end


function LuaBattleMgr:OnShowBossWarning()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHOW_BOSS_WARNING,true);
    ManagerContainer.LuaTimerMgr:AddTimer(3000, 1,self,self.OnHideBossWarningTimer,nil);
end

function LuaBattleMgr:OnHideBossWarningTimer()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHOW_BOSS_WARNING,false);
end

function LuaBattleMgr:OnEnterNextMap()
    self.bKillBoss = false
    self.nextMapState = NextMapState.None
    ManagerContainer.LuaGameMgr:OpenLoading(Enum.UIPageName.UILoading)
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.NormalBattleScene)
end

function LuaBattleMgr:CurLevelExp()
    return LuaBattleBridge.GetCurLevelExp();
end

function LuaBattleMgr:CurLevelParnterExp()
    return LuaBattleBridge.GetCurLevelParnterExp();
end

function LuaBattleMgr:CurLevelGold()
    return LuaBattleBridge.GetCurLevelGold();
end

function LuaBattleMgr:CurLevelCruise()
    return LuaBattleBridge.GetCurLevelCruise();
end

function LuaBattleMgr:CurLevelEvil()
    return LuaBattleBridge.GetCurLevelEvil()
end

function LuaBattleMgr:CurLevelZeny()
    return LuaBattleBridge.GetCurLevelZeny()
end

function LuaBattleMgr:CurLevelName()
    return LuaBattleBridge.GetCurLevelName();
end

function LuaBattleMgr:SetRewardDropPos(dropPos)
    LuaBattleBridge.SetRewardDropPos(dropPos)
end

function LuaBattleMgr:Enter()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.ROLE_JOB_CHANGE_SUCCESS, self, self.NotifyRefreshRoleView)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.FASHION_WEAR_CHANGE, self, self.NotifyRefreshRoleView)
    -- ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.ROLE_LV_CHANGED, self, self.NotifyRefreshUpRoleLvEffect)
    -- ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.JOB_LV_CHANGED, self, self.NotifyRefreshUpJobLvEffect)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.BIGMAP_ENTER_NEXTMAP_START, self, self.NotifyEnterNextMapStart)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.BIGMAP_ENTER_NEXTMAP_END, self, self.NotifyEnterNextMapEnd)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.VIP_LV_CHANGED, self, self.NotifyVipLvChanged)
    self:NotifyVipLvChanged()

    self.bKillBoss = false
    --ManagerContainer.DataMgr.BigMapData:SendGetData()
    self:StartSyncServerTimeTimer()

    if self.rewardTimeTimerId == nil then
        self.rewardTimeTimerId = ManagerContainer.LuaTimerMgr:AddTimer(1000, -1, self, self.OnRefreshRewardTime, nil)
    end
    
    local mainActor = ManagerContainer.LuaActorDataMgr:GetHeroActorData(1)
    if mainActor ~= nil then
        mainActor.Name = ManagerContainer.DataMgr.UserData:GetUserNickname()
    end
    self.isAutochallenge = false
end

function LuaBattleMgr:Exit()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.ROLE_JOB_CHANGE_SUCCESS, self, self.NotifyRefreshRoleView)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.FASHION_WEAR_CHANGE, self, self.NotifyRefreshRoleView)
    -- ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.ROLE_LV_CHANGED, self, self.NotifyRefreshUpRoleLvEffect)
    -- ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.JOB_LV_CHANGED, self, self.NotifyRefreshUpJobLvEffect)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.BIGMAP_ENTER_NEXTMAP_START, self, self.NotifyEnterNextMapStart)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.BIGMAP_ENTER_NEXTMAP_END, self, self.NotifyEnterNextMapEnd)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.VIP_LV_CHANGED, self, self.NotifyVipLvChanged)
    -- ManagerContainer.LuaBattleMgr:RecycleUpLvEffect()
    ManagerContainer.LuaBattleMgr:RecycleRoleView()

    if self.rewardTimeTimerId~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.rewardTimeTimerId)
        self.rewardTimeTimerId = nil
    end
    self.isAutochallenge = false
end

function LuaBattleMgr:SendBattleRecordReq()
    ManagerContainer.LuaGameMgr:SendBattleRecordReq(100,{self.curMapId,self.curLevelId})
end

function LuaBattleMgr:GetFightersPos()
    return LuaBattleBridge.GetFightersPos();
end

function LuaBattleMgr:GetCurMapId()
    return self.curMapId
end

function LuaBattleMgr:GetCurMapAndLevel()
    return self.curMapId, self.curLevelId
end

function LuaBattleMgr:MaxQuickBattleTimes()
    return self.maxQuickBattleTimes
end

function LuaBattleMgr:UsedQuickBattleTimes()
    return self.usedQuickBattleTimes
end

function LuaBattleMgr:GetCurrentLevelData()
    return ManagerContainer.CfgMgr:GetLevelDataById(self:GetCurLevelUniqueId())
end

function LuaBattleMgr:OnLoadBegin()
    LogWarning("LuaBattleMgr:OnLoadBegin ")
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Begin);
    -- LogError("LuaBattleMgr:OnLoadBegin")
end

function LuaBattleMgr:OnLoadProgress(progress)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Progress,progress);
    -- LogError("LuaBattleMgr:OnLoadProgress:" .. progress)
end

function LuaBattleMgr:OnLoadComplete()
    LogWarning("LuaBattleMgr:OnLoadComplete ")
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Complete);
    -- LogError("LuaBattleMgr:OnLoadComplete")
end

function LuaBattleMgr:OnFighterCastSkill(skillParam)
    if skillParam.isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Skill,skillParam)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Cast_Skill,skillParam)
    end
end

function LuaBattleMgr:OnShowBossBuff(actorId,isBoss,buffIcon,num,isPlayeRecord)
    if isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Buff,buffIcon,num)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Player_Buff,actorId, buffIcon,num)
    end
end

function LuaBattleMgr:OnRemoveBossBuff(actorId,isBoss,buffIcon)
    if isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Remove_Buff,buffIcon)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Remove_Player_Buff, actorId, buffIcon)
    end
end

function LuaBattleMgr:OnFighterLifeChanged(isBoss,actorId,life,maxLife)
    if isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Life,life,maxLife)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Fighter_Life,actorId,life,maxLife)
    end
end

function LuaBattleMgr:OnFighterEnergyChanged(actorId,sp,maxSp)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Fighter_Sp,actorId,sp,maxSp)
end

function LuaBattleMgr:OnRefreshSkillCD(isBoss,actorId,leftTime,totalTime)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Skill_CD,isBoss,actorId,leftTime,totalTime)
    -- LogError("--------------------------------------------isBoss = " .. tostring(isBoss) .. " actorId = " .. actorId .. " leftTime = " .. leftTime .. " totalTime = " .. totalTime)
end

function LuaBattleMgr:OnBattleUIVis(vis)
    if vis then
        --ManagerContainer.LuaUIMgr:Show(Enum.UIPageName.UIBattle)
        --ManagerContainer.LuaUIMgr:Show(Enum.UIPageName.UIMain)
    else
        --ManagerContainer.LuaUIMgr:Hide(Enum.UIPageName.UIBattle)
        --ManagerContainer.LuaUIMgr:Hide(Enum.UIPageName.UIMain)
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Battle_UI_VISIBLE,vis)
end

function LuaBattleMgr:OnRefreshBattleOutput()
    -- if self.logList == nil or #self.logList == 0 then
    --     return
    -- end
    -- self.logList[#self.logList+1] = logStr
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Add_New_BattleLog)
end

-- function LuaBattleMgr:InitBattleOutputList()
--     self.logList = {}
--     local battleLogList = LuaBattleBridge.GetBattleLog()
--     if battleLogList ~= nil then
--         for i = 1, battleLogList.Count do
--             self.logList[#self.logList+1] = battleLogList[i-1]
--         end
--     end
--     return self.logList
-- end

-- function LuaBattleMgr:GetBattleLogList()
--     return self.logList
-- end

function LuaBattleMgr:NotifyLoadingStatus(status)
    self.battleLoadingState = status
end

function LuaBattleMgr:NotifyLoadingStatusEnd(status)
    self.battleLoadingState = nil

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BATTLE_LOADING_COMPELETED)
end

function LuaBattleMgr:GetBattleLoadingState()
    local statusIdx
    local state, text = self:GetWaitingRefreshRoleState()
    if not state then
        statusIdx = self.battleLoadingState
    else
        statusIdx = Enum.BattleBtnState.RoleModel
    end
    if statusIdx == Enum.BattleBtnState.Skill then
        text = "Challenging4"
    elseif statusIdx == Enum.BattleBtnState.Fellow then
        text = "Challenging3"
    elseif statusIdx == Enum.BattleBtnState.Pet then
        text = "Challenging3"
    elseif statusIdx == Enum.BattleBtnState.RoleModel then
        text = "Challenging2"
    end
    return statusIdx, text
end

--判断当前时间如果领取挂机奖励的话，魔魂值是否会溢出,返回值第一个是是否溢出，第二个是领取之前的值
function LuaBattleMgr:JudgeEvilExpOverFlow()
    local _leftTime, _num = ManagerContainer.LuaBattleMgr:GetIncomeInfo()
    local _curLvEvilExp = ManagerContainer.LuaBattleMgr:CurLevelEvil();                 --每分钟挂机获得的魔魂值
    local _evilExp = ManagerContainer.DataMgr.UserData:GetEvilExp();
    local _rewardIntervalTimeM = GlobalConfig.Instance:GetConfigIntValue(47) / 60;
    local _nexEvilExp = _evilExp + _curLvEvilExp * _rewardIntervalTimeM * _num;

    if self.maxEvilExp == 0 then
        self.maxEvilExp = GlobalConfig.Instance:GetConfigIntValue(158);
    end
    local _isOverFlow = _nexEvilExp > self.maxEvilExp;
    return _isOverFlow, _evilExp;
end

function LuaBattleMgr:CSPlayerIncomeReq()
    self.accumIncomeTime = ManagerContainer.LuaBattleMgr:AccumIncomeTime();
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PLAYER_INCOME_REQ, {})
    self:ReportIncomeRecord(true)
end

function LuaBattleMgr:ReportIncomeRecord(success)
    if not SDKMgr.Instance:IsReportAction() then
        return
    end
    local datas = System.Collections.Generic.Dictionary_object_object()
    datas:Add('event', 'mj_online_rewards')
    datas:Add('is_achieve', 1)
    SDKMgr.Instance:ReportAction(datas)
end

function LuaBattleMgr:RefreshStatistics()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_BattleStatistics)
end

function LuaBattleMgr:HeroChangeProfessionSuccess()
    ManagerContainer.DataMgr.UserData:RoleChangeJobAttrSuccess()
end


return LuaBattleMgr;