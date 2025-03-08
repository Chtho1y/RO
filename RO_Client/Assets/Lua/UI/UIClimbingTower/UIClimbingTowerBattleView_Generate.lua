---@class UIClimbingTowerBattle__Generate_leftTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerBattle__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private leftTime UIClimbingTowerBattle__Generate_leftTime
---@field private infinite UnityEngine.GameObject
local UIClimbingTowerBattleView = class("UIClimbingTowerBattleView", require("UIViewBase"))

function UIClimbingTowerBattleView:ctor()
end

---@private
function UIClimbingTowerBattleView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIClimbingTowerBattleView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)


end

---@private
function UIClimbingTowerBattleView:InitGenerate__1(Root, data)
--[[
	TopView/BattleTime/LeftBattleTime
--]]
	local tmp = Root:Find("TopView/BattleTime/LeftBattleTime").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerBattleView:InitGenerate__2(Root, data)
--[[
	TopView/BattleTime/infinite
--]]
	local tmp = Root:Find("TopView/BattleTime/infinite").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.infinite = tmp
end

---@private
function UIClimbingTowerBattleView:GenerateDestroy()
	if tolua.getpeer(self.leftTime) ~= nil then
		tolua.setpeer(self.leftTime, nil)
	end
	self.leftTime = nil
	if tolua.getpeer(self.infinite) ~= nil then
		tolua.setpeer(self.infinite, nil)
	end
	self.infinite = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIClimbingTowerBattleView