---@class BattleReplayControl__Generate_exitBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class BattleReplayControl__Generate_levelName
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class BattleReplayControl__Generate_passLevelTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BattleReplayControl__Generate_fightPower
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BattleReplayControl__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private canvas UnityEngine.Canvas
---@field private fightPower BattleReplayControl__Generate_fightPower
---@field private passLevelTime BattleReplayControl__Generate_passLevelTime
---@field private levelName BattleReplayControl__Generate_levelName
---@field private exitBtn BattleReplayControl__Generate_exitBtn
local BattleReplayControlView = class("BattleReplayControlView")

function BattleReplayControlView:ctor()
end

---@private
function BattleReplayControlView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function BattleReplayControlView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)


end

---@private
function BattleReplayControlView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.canvas = Root:GetComponent(Enum.TypeInfo.Canvas)
end

---@private
function BattleReplayControlView:InitGenerate__2(Root, data)
--[[
	BG/Power/Number
--]]
	local tmp = Root:Find("BG/Power/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fightPower = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BattleReplayControlView:InitGenerate__3(Root, data)
--[[
	BG/Time/Number
--]]
	local tmp = Root:Find("BG/Time/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.passLevelTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BattleReplayControlView:InitGenerate__4(Root, data)
--[[
	BG/Map/MapName
--]]
	local tmp = Root:Find("BG/Map/MapName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.levelName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function BattleReplayControlView:InitGenerate__5(Root, data)
--[[
	BG/Close
--]]
	local tmp = Root:Find("BG/Close").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.exitBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function BattleReplayControlView:GenerateDestroy()
	if tolua.getpeer(self.fightPower) ~= nil then
		tolua.setpeer(self.fightPower, nil)
	end
	self.fightPower = nil
	if tolua.getpeer(self.passLevelTime) ~= nil then
		tolua.setpeer(self.passLevelTime, nil)
	end
	self.passLevelTime = nil
	if tolua.getpeer(self.levelName) ~= nil then
		tolua.setpeer(self.levelName, nil)
	end
	self.levelName = nil
	if tolua.getpeer(self.exitBtn) ~= nil then
		tolua.setpeer(self.exitBtn, nil)
	end
	self.exitBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return BattleReplayControlView