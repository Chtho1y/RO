---@class UIExpeditionBattle__Generate_curLevel
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExpeditionBattle__Generate_leftTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExpeditionBattle__Generate_mapName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExpeditionBattle__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private mapName UIExpeditionBattle__Generate_mapName
---@field private leftTime UIExpeditionBattle__Generate_leftTime
---@field private infinite UnityEngine.GameObject
---@field private curLevel UIExpeditionBattle__Generate_curLevel
local UIExpeditionBattleView = class("UIExpeditionBattleView", require("UIViewBase"))

function UIExpeditionBattleView:ctor()
end

---@private
function UIExpeditionBattleView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIExpeditionBattleView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function UIExpeditionBattleView:InitGenerate__1(Root, data)
--[[
	TopView/UITitle/BoardTitle
--]]
	local tmp = Root:Find("TopView/UITitle/BoardTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mapName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExpeditionBattleView:InitGenerate__2(Root, data)
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
function UIExpeditionBattleView:InitGenerate__3(Root, data)
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
function UIExpeditionBattleView:InitGenerate__4(Root, data)
--[[
	TopView/StageNumber/Stage
--]]
	local tmp = Root:Find("TopView/StageNumber/Stage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curLevel = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExpeditionBattleView:GenerateDestroy()
	if tolua.getpeer(self.mapName) ~= nil then
		tolua.setpeer(self.mapName, nil)
	end
	self.mapName = nil
	if tolua.getpeer(self.leftTime) ~= nil then
		tolua.setpeer(self.leftTime, nil)
	end
	self.leftTime = nil
	if tolua.getpeer(self.infinite) ~= nil then
		tolua.setpeer(self.infinite, nil)
	end
	self.infinite = nil
	if tolua.getpeer(self.curLevel) ~= nil then
		tolua.setpeer(self.curLevel, nil)
	end
	self.curLevel = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIExpeditionBattleView