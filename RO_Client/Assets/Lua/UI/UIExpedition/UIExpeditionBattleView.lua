local UIExpeditionBattleView = require("UIExpedition/UIExpeditionBattleView_Generate")
local BattleHeadsBoxPart = require("UIBattle/BattleHeadsBoxPart")
local BattleStatisticsPart = require("UIBattle/BattleStatisticsPart")
local BattleReplayControlPart = require("UIBattle/BattleReplayControlPart")
local NewBattleChatPart = require("UIBattle/NewBattleChatPart")

function UIExpeditionBattleView:OnAwake(data)
	self.controller = require("UIExpedition/UIExpeditionBattleCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIExpeditionBattleView:AddEventListener()
end

function UIExpeditionBattleView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIExpeditionBattleView:Init()
	if self.HeadsBoxPart == nil then
		self.HeadsBoxPart = BattleHeadsBoxPart:new()
	end

	if self.StatisticsPart == nil then
		self.StatisticsPart = BattleStatisticsPart:new()
	end
	if self.NewBattleChatPart == nil then
		self.NewBattleChatPart = NewBattleChatPart:new()
	end

	self.NewBattleChatPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/NewBattleChat"))
	self.HeadsBoxPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/BattleHeadsBox"))
	self.StatisticsPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/BattleStatistics"))
	self.HeadsBoxPart:Show()
	--远征之门延迟打开导致同步事件没有触发 这里打开时同步HP SP (之后缓存消息队列)    
	self:RefreshHeadsBoxPartHpSp()
	self.StatisticsPart:Show(BattleMode.Time,BattleSubMode.Expedition)
	self.StatisticsPart:SetCanvasOrder(self.uiBase.SortingOrder-1)

	self.leftFightingTime = ManagerContainer.LuaTimeBattleMgr:GetLeftFightingTime()
	self.leftTime.text.text = FormatTimeMS(self.leftFightingTime)
	self.leftFightingTimeHandler = ManagerContainer.LuaTimerMgr:AddTimer(1000, -1, self, self.OnShowLeftFightingTime, nil)

	local mapData = ManagerContainer.DataMgr.ExpeditionDataMgr:CurChallengingMap()
	if mapData ~= nil then
		self.mapName.text.text = mapData.name
		self.curLevel.text.text = tostring(ManagerContainer.DataMgr.ExpeditionDataMgr:GetCurLevelId()) .. "/" .. mapData.maxLevelNum
	end
end

function UIExpeditionBattleView:RefreshHeadsBoxPartHpSp()
    local ourMembers = LuaBattleBridge.GetBattleTeamPlayerActors()
    for i =1, ourMembers.Count do
        local actor = ourMembers[i-1]            
        local hpPercent,spPercent = ManagerContainer.DataMgr.ExpeditionDataMgr:GetHeroHPAndSP(actor.ID)    
        local curhp = hpPercent * 0.01 * SDataUtil.InvConvert(actor.Life)
        local cursp = spPercent * 0.01 * SDataUtil.InvConvert(actor.Sp)                
        self.HeadsBoxPart:RefreshFighterLife(actor.ID,curhp,actor.Life)
        self.HeadsBoxPart:RefreshFighterSp(actor.ID,cursp,actor.Sp)            
    end
end    

function UIExpeditionBattleView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIExpeditionBattleView:AddUIEventListener()
	self.HeadsBoxPart:AddUIEventListener()
	self.StatisticsPart:AddUIEventListener()
	self.NewBattleChatPart:AddUIEventListener()
end

function UIExpeditionBattleView:OnHide()

end

function UIExpeditionBattleView:OnShow(data)
	self.controller:SetData(data)
end

function UIExpeditionBattleView:OnClose()
	self:ClearLeftFightingTimer()
	if self.HeadsBoxPart ~= nil then
		self.HeadsBoxPart:Hide()
		self.HeadsBoxPart:Dispose()
		self.HeadsBoxPart = nil
	end

	if self.StatisticsPart ~= nil then
		self.StatisticsPart:Hide()
		self.StatisticsPart:Dispose()
		self.StatisticsPart = nil
	end
	if self.NewBattleChatPart ~= nil then
		self.NewBattleChatPart:Dispose()
		self.NewBattleChatPart = nil
	end
end

function UIExpeditionBattleView:OnDispose()
	self.controller:OnDispose()
end

function UIExpeditionBattleView:OnShowLeftFightingTime()
	self.leftFightingTime = ManagerContainer.LuaTimeBattleMgr:GetLeftFightingTime()
	if self.leftFightingTime <= 0 then
		self:ClearLeftFightingTimer()
	end
	self.leftTime.text.text = FormatTimeMS(self.leftFightingTime)
end

function UIExpeditionBattleView:ClearLeftFightingTimer()
	if self.leftFightingTimeHandler ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self.leftFightingTimeHandler)
        self.leftFightingTimeHandler = nil
	end
end

return UIExpeditionBattleView

