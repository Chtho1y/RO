local UIDojoBattleView = require("UIDojo/UIDojoBattleView_Generate")
local HeadItemCtr = require("Common/HeadItemCtr")

local BattleHeadsBoxPart = require("UIBattle/BattleHeadsBoxPart")
local BattleEnemyPart = require("UIBattle/BattleEnemyPart")
local BattleStatisticsPart = require("UIBattle/BattleStatisticsPart")

function UIDojoBattleView:OnAwake(data)
	self.controller = require("UIDojo/UIDojoBattleCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIDojoBattleView:AddEventListener()
end

function UIDojoBattleView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIDojoBattleView:Init()
	if self.HeadsBoxPart == nil then
		self.HeadsBoxPart = BattleHeadsBoxPart:new()
	end

	if self.EnemyPart == nil then
		self.EnemyPart = BattleEnemyPart:new()
	end

	if self.StatisticsPart == nil then
		self.StatisticsPart = BattleStatisticsPart:new()
	end

	self.HeadsBoxPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/BattleHeadsBox"))
	self.EnemyPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/BattleEnemy"))
	self.StatisticsPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/BattleStatistics"))
	self.HeadsBoxPart:Show(self.controller:GetOurMembers())
	self.EnemyPart:Show(self.controller:GetMatchFighterName(),self.controller:GetEnemyMembers(), self.controller:GetIsLeftTime(), self.controller:GetTotalTime())
	self.StatisticsPart:Show(self.controller:GetBattleMode(),self.controller:GetBattleSubMode())
	self.StatisticsPart:SetCanvasOrder(self.uiBase.SortingOrder-1)
end

function UIDojoBattleView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIDojoBattleView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_SHOW_PVP_PRESSPOINT,self,self.OnShowPvePressPoint);	
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	self.HeadsBoxPart:AddUIEventListener()
	self.EnemyPart:AddUIEventListener()
	self.StatisticsPart:AddUIEventListener()
end

function UIDojoBattleView:OnShowPvePressPoint(vis)
	self.rageBoxGo:SetActive(vis)
end

function UIDojoBattleView:OnHide()
end

function UIDojoBattleView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIDojoBattleView:OnClose()
	if self.HeadsBoxPart ~= nil then
		self.HeadsBoxPart:Dispose()
		self.HeadsBoxPart = nil
	end

	if self.EnemyPart ~= nil then
		self.EnemyPart:Dispose()
		self.EnemyPart = nil
	end

	if self.StatisticsPart ~= nil then
		self.StatisticsPart:Hide()
		self.StatisticsPart:Dispose()
		self.StatisticsPart = nil
	end
end

function UIDojoBattleView:OnDispose()
end

return UIDojoBattleView

