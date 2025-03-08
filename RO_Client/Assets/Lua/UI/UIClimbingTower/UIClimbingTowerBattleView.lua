local UIClimbingTowerBattleView = require("UIClimbingTower/UIClimbingTowerBattleView_Generate")

local BattleHeadsBoxPart = require("UIBattle/BattleHeadsBoxPart")
local BattleStatisticsPart = require("UIBattle/BattleStatisticsPart")
local BattleReplayControlPart = require("UIBattle/BattleReplayControlPart")
local NewBattleChatPart = require("UIBattle/NewBattleChatPart")

function UIClimbingTowerBattleView:OnAwake(data)
	self.controller = require("UIClimbingTower/UIClimbingTowerBattleCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIClimbingTowerBattleView:AddEventListener()
end

function UIClimbingTowerBattleView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIClimbingTowerBattleView:Init()

	if self.NewBattleChatPart == nil then
		self.NewBattleChatPart = NewBattleChatPart:new()
	end
	if self.HeadsBoxPart == nil then
		self.HeadsBoxPart = BattleHeadsBoxPart:new()
	end

	if self.StatisticsPart == nil then
		self.StatisticsPart = BattleStatisticsPart:new()
	end

	if self.battleReplayPart == nil then
		self.battleReplayPart = BattleReplayControlPart:new()
	end

	self.NewBattleChatPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/NewBattleChat"))
	self.HeadsBoxPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/BattleHeadsBox"))
	self.StatisticsPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/BattleStatistics"))
	self.battleReplayPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/BattleReplayControl"))

	self.HeadsBoxPart:Show()
	self.StatisticsPart:Show(BattleMode.Time,BattleSubMode.ClimbingTower)
	self.StatisticsPart:SetCanvasOrder(self.uiBase.SortingOrder-1)

	local isPlayRecord,recordLevel = self.controller:GetReplayRecord()
	if isPlayRecord then
		local levelName = "第" .. recordLevel .. "层"
		self.battleReplayPart:Show(levelName)
	else
		self.battleReplayPart:Hide()
	end

	self.leftFightingTime = self.controller:FightingTime()
	self.leftTime.text.text = FormatTimeMS(self.leftFightingTime)
	self.leftFightingTimeHandler = ManagerContainer.LuaTimerMgr:AddTimer(1000, -1, self, self.OnShowLeftFightingTime, nil)
end

function UIClimbingTowerBattleView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIClimbingTowerBattleView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	self.HeadsBoxPart:AddUIEventListener()
	self.StatisticsPart:AddUIEventListener()
	self.battleReplayPart:AddUIEventListener()
	self.NewBattleChatPart:AddUIEventListener()
end

function UIClimbingTowerBattleView:OnHide()

end

function UIClimbingTowerBattleView:OnShow(data)
	self.controller:SetData(data)

end

function UIClimbingTowerBattleView:OnClose()
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

	if self.battleReplayPart ~= nil then
		self.battleReplayPart:Dispose()
		self.battleReplayPart = nil
	end
	if self.NewBattleChatPart ~= nil then
		self.NewBattleChatPart:Dispose()
		self.NewBattleChatPart = nil
	end
end

function UIClimbingTowerBattleView:OnDispose()
	self.controller:OnDispose()
end

function UIClimbingTowerBattleView:OnShowLeftFightingTime()
	self.leftFightingTime = self.controller:FightingTime()
	if self.leftFightingTime <= 0 then
		self.leftFightingTime = 0
		self:ClearLeftFightingTimer()
	end
	self.leftTime.text.text = FormatTimeMS(self.leftFightingTime)
end

function UIClimbingTowerBattleView:ClearLeftFightingTimer()
	if self.leftFightingTimeHandler ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self.leftFightingTimeHandler)
        self.leftFightingTimeHandler = nil
	end
end


return UIClimbingTowerBattleView

