local BattleStatisticsPart = class("BattleStatisticsPart")

local DelayTime = 10
function BattleStatisticsPart:ctor()
end

function BattleStatisticsPart:InitGo(host,uiGo)
    self.host = host
    self.viewLua = CommonUtil.BindGridViewItem2Lua(self.host, "BattleStatistics", uiGo)
end


function BattleStatisticsPart:InitPanel()
    self.viewLua.btnQuit:SetActive(false)
    --延迟显示
    local bIsReplay = LuaBattleBridge.CurrentBattleIsPlayRecord()
    if not bIsReplay then
        local enBattleMode = LuaBattleBridge.CurrentBattleMode()
        local enSubMode = LuaBattleBridge.CurrentBattleSubMode()
        if enBattleMode == BattleMode.Normal then --巡游BOOS
            DelayTime = self:GetQuitShowDelay(Enum.TaskType.Level_Battle_Count)
        elseif enSubMode == BattleSubMode.ClimbingTower then --爬塔
            DelayTime = self:GetQuitShowDelay(Enum.TaskType.Climbing_Tower_Level)
        end
        if nil ~= DelayTime then
            self:StartTimer(function() self:ShowQuitBtn() end,{duration = DelayTime})
        end
    end
    self:OnVipLvChanged()
end

function BattleStatisticsPart:Show(mode,battleSubMode)
    self:InitPanel()
    self.hidePnl = false
    self.statisticsActorNodes = {}
	self.statisticsActorNodes[#self.statisticsActorNodes+1] = self.viewLua.playerNode1
	self.statisticsActorNodes[#self.statisticsActorNodes+1] = self.viewLua.playerNode2
	self.statisticsActorNodes[#self.statisticsActorNodes+1] = self.viewLua.playerNode3
    self.statisticsActorNodes[#self.statisticsActorNodes+1] = self.viewLua.playerNode4
    for i = 1, #self.statisticsActorNodes do 
		self.statisticsActorNodes[i]:SetActive(false)
    end
    
    self.data = LuaBattleBridge.GetBattleStatistics(mode,battleSubMode)
    self:OnRefreshStatistics()
    self.viewLua:SetActive(true)
    self:AddEventListener()
end

--退出按钮
function BattleStatisticsPart:ShowQuitBtn()
    local bIsShow = false
    local enBattleMode = LuaBattleBridge.CurrentBattleMode()
    local enSubMode = LuaBattleBridge.CurrentBattleSubMode()
    if enBattleMode == BattleMode.Normal then --巡游BOOS
        local ConditionValue = self:GetQuitShowCondition(Enum.TaskType.Level_Battle_Count)
        local curMapId,curLevelId = ManagerContainer.LuaBattleMgr:GetCurMapAndLevel() --当前关卡
        local curUniqueId  = curMapId * 10000 + curLevelId
        if ConditionValue ~= nil and curUniqueId >= ConditionValue then
            bIsShow = true
        end
    elseif enSubMode == BattleSubMode.ClimbingTower then --爬塔
        local TwerLevle = ManagerContainer.DataMgr.TowerDataMgr:GetCurChallengeLevel()
        local ConditionValue = self:GetQuitShowCondition(Enum.TaskType.Climbing_Tower_Level)
        if ConditionValue ~= nil and TwerLevle >= ConditionValue then
            bIsShow = true
        end
    end
    self.viewLua.btnQuit:SetActive(bIsShow)
end

--退出按钮延迟时间获取
function BattleStatisticsPart:GetQuitShowDelay(TaskType)
    local val = GlobalConfig.Instance:GetConfigStrValue(264)
    return self:ParseData(val,TaskType)
end

--退出按鈕條件
function BattleStatisticsPart:GetQuitShowCondition(TaskType)
    local val = GlobalConfig.Instance:GetConfigStrValue(263)
    return self:ParseData(val,TaskType)
end

--解析數據
function BattleStatisticsPart:ParseData(val,TaskType)
    if val == "" or val == nil then
        return nil
    end
    
    local ShowCondition = CommonUtil.DeserializeGlobalStrToTable(val)
    if ShowCondition[1][1] == "" or ShowCondition[1][1] == nil then
        return nil
    end
    if tonumber(ShowCondition[1][1]) == TaskType then
        return tonumber(ShowCondition[1][2])
    end

    if ShowCondition[2][1] == "" or ShowCondition[2][1] == nil then
        return nil
    end
    if tonumber(ShowCondition[2][1]) == TaskType then
        return tonumber(ShowCondition[2][2])
    end
    
    return nil
end


function BattleStatisticsPart:Hide()
    self:ResetData()
    self:RemoveEventListener()
    self:Clear()
    self.viewLua:SetActive(false)
    ManagerContainer.LuaUIMgr:CloseMessageBox("QuitBattleTip")
end

function BattleStatisticsPart:SetCanvasOrder(order)
    self.viewLua.canvas.sortingOrder = order
end

function BattleStatisticsPart:StartTimer(func, data)
    self:StopTimer()
    if data.isFrame then
        self.timer = FrameTimer.New(func, data.duration)
    else
        self.timer = Timer.New(func, data.duration)
    end
    self.timer:Start()
end

function BattleStatisticsPart:StopTimer()
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

function BattleStatisticsPart:AddEventListener()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Refresh_BattleStatistics,self,self.OnRefreshStatistics);
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Battle_UI_VISIBLE,self,self.OnUIPartVisible);
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.VIP_LV_CHANGED, self, self.OnVipLvChanged)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.RUNE_SHOP_DATA_CHANGED, self, self.OnRuneShopDataChanged)
end

function BattleStatisticsPart:RemoveEventListener()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Refresh_BattleStatistics,self,self.OnRefreshStatistics);
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Battle_UI_VISIBLE,self,self.OnUIPartVisible);
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.VIP_LV_CHANGED, self, self.OnVipLvChanged)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.RUNE_SHOP_DATA_CHANGED, self, self.OnRuneShopDataChanged)
end

function BattleStatisticsPart:AddUIEventListener()
    self.host.uiBase:AddButtonEventListener(self.viewLua.btnSpeed.button,self, self.OnClickBtnSpeed)
    self.host.uiBase:AddButtonEventListener(self.viewLua.viewDetailBtn.button,self, self.OnClickOpenStatisticPage)
    self.host.uiBase:AddButtonEventListener(self.viewLua.hideBtn.button,self, self.OnClickHide)
    self.host.uiBase:AddButtonEventListener(self.viewLua.btnQuit.button,self, self.OnClickQuit)
end

function BattleStatisticsPart:OnClickBtnSpeed()
    if not ManagerContainer.DataMgr.RuneShopDataMgr:CheckMonthData() and not self:CheckVipData() then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("SpeedUpLock")
        ManagerContainer.LuaGameMgr:LuaSaveGameSpeed(1)
        return
    end
    if ManagerContainer.LuaGameMgr:GetGameSpeed() == 2 then
		ManagerContainer.LuaGameMgr:LuaSaveGameSpeed(1)
        self.viewLua.btnSpeed.speed2:SetActive(false)
        self.viewLua.btnSpeed.speed1:SetActive(true)
	else
		ManagerContainer.LuaGameMgr:LuaSaveGameSpeed(ManagerContainer.LuaGameMgr:GetGameSpeed()+1)
        self.viewLua.btnSpeed.speed2:SetActive(true)
        self.viewLua.btnSpeed.speed1:SetActive(false)
	end
end

function BattleStatisticsPart:OnClickOpenStatisticPage()
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleStatistics,{LuaBattleBridge.CurrentBattleMode(),LuaBattleBridge.CurrentBattleSubMode()})
end

function BattleStatisticsPart:OnClickHide()
    if self.hidePnl == false then
        self.viewLua.battleCountAnim.animator:Play("UIBattleCountOut")
        self.hidePnl =  true
    else
        self.viewLua.battleCountAnim.animator:Play("UIBattleCountIn")
        self.hidePnl =  false
    end
end

--二次确认框退出战斗
function BattleStatisticsPart:OnClickQuit()
    ManagerContainer.LuaUIMgr:ShowMessageBox("QuitBattleTip",nil,nil,self,self.OnForceStopBattle,nil)
end

--强制退出战斗
function BattleStatisticsPart:OnForceStopBattle()
    ManagerContainer.LuaGameMgr:ForceStopBattle()
    ManagerContainer.LuaBattleMgr:StopAutoChallenge(true)
    --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_BATTLE_FAILED,true,false);
end

function BattleStatisticsPart:OnVipLvChanged()
    if not self.viewLua then return end
    if not Constant.OpenPay then
        self.viewLua.btnSpeed:SetActive(false)
        return
    end
    self.viewLua.btnSpeed:SetActive(true)
    self.viewLua.btnSpeed.speed1:SetActive(true)
    self.viewLua.btnSpeed.speed2:SetActive(false)
    local vipState = self:CheckVipData()
    if vipState  then
        if ManagerContainer.LuaGameMgr.GameSpeed ~= 1 then
            self.viewLua.btnSpeed.speed1:SetActive(false)
            self.viewLua.btnSpeed.speed2:SetActive(true)
        end
    end
    local monthState = ManagerContainer.DataMgr.RuneShopDataMgr:CheckMonthData()
    if monthState then
        if  ManagerContainer.LuaGameMgr.GameSpeed ~= 1 then
            self.viewLua.btnSpeed.speed1:SetActive(false)
            self.viewLua.btnSpeed.speed2:SetActive(true)
        end
    end
end

function  BattleStatisticsPart:OnRuneShopDataChanged(runeShopType, runeShopSubType)
    if runeShopType == Enum.RuneShopType.MonthCard then
        self:OnVipLvChanged()
    end
end

function BattleStatisticsPart:CheckVipData()
    local vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
    if not vipLv  then
        return false
    end
    local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
    if vipCfg  then
        if vipCfg.QuickBattle then
            if vipCfg.QuickBattle >= 1  then
                return true
            end
        end
    end
    return false
end

function BattleStatisticsPart:OnUIPartVisible(vis)
    self.viewLua:SetActive(vis)
end

function BattleStatisticsPart:GetSlotSortActor(tbFriend)
	--伙伴界面排序
	local sortedPartnerDatas =  ManagerContainer.DataMgr.PartnerData:SortPartnerData()
	--根据伙伴界面排序 排序
	local sortedData = {}	
	for j =1, tbFriend.Count do--主角第一
		local actor = tbFriend[j-1]	
		local UserId = 1		
		if tostring(UserId)==tostring(actor.fighterId) then	
			table.insert(sortedData,actor)
		end		
	end
	for i=1, #sortedPartnerDatas do	--伙伴排序
		local PartnerData = sortedPartnerDatas[i]		
		for j =1, tbFriend.Count do
			local actor = tbFriend[j-1]					 
			if tostring(PartnerData.id)==tostring(actor.fighterId) then
				table.insert(sortedData,actor)			
			end
		end
	end
	return sortedData
end

function BattleStatisticsPart:OnRefreshStatistics()
    if self.data == nil then
		return
	end
 
    if self.data.FriendStatistics == nil then
        return
    end

	local friendList = self:GetSlotSortActor(self.data.FriendStatistics)
	if friendList == nil then
		return
	end

	for i = 1, #friendList do
		self:ShowFighterStatistics(self.statisticsActorNodes[i],friendList[i])
	end
end

function BattleStatisticsPart:ShowFighterStatistics(node,data)
	CommonUtil.LoadIcon(self.host, data.jobIcon, function (sprite)
		node.jobIcon.image.sprite = sprite
        end)
    node.playerName.text.text = data.actorName
    node.totalProgress.image.fillAmount = data.damagePercent
	node.progress.image.fillAmount = data.heroDamagePercent
	node.percent.text.text = CommonUtil.GetPreciseDecimal(data.damagePercent*100,2) .. "%"
	node:SetActive(true)
end


function BattleStatisticsPart:ResetData()
    if self.statisticsActorNodes ~= nil then
        for i= 1, #self.statisticsActorNodes do 
            local node = self.statisticsActorNodes[i]
            node.jobIcon.image.sprite = nil
            node.playerName.text.text = ""
            node.totalProgress.image.fillAmount = 0
            node.progress.image.fillAmount = 0
            node.percent.text.text = ""
        end
    end
end

function BattleStatisticsPart:Dispose()
    self:StopTimer()
    self:Clear()
    self.host = nil
    self.viewLua = nil
end

function BattleStatisticsPart:Clear()
    self.statisticsActorNodes  = nil 
    self.data = nil
end

return BattleStatisticsPart