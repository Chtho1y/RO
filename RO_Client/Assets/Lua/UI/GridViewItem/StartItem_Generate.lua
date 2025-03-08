---@class StartItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private levelBox1 UnityEngine.GameObject
---@field private airShip UnityEngine.GameObject
---@field private activity UnityEngine.GameObject
local StartItemView = class("StartItemView")

function StartItemView:ctor()
end

---@private
function StartItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function StartItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function StartItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function StartItemView:InitGenerate__2(Root, data)
--[[
	LevelBox1
--]]
	local tmp = Root:Find("LevelBox1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.levelBox1 = tmp
end

---@private
function StartItemView:InitGenerate__3(Root, data)
--[[
	LevelBox1/Bar/AirShip
--]]
	local tmp = Root:Find("LevelBox1/Bar/AirShip").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.airShip = CommonUtil.BindGridViewItem2LuaStatic("AirShip", tmp)
	self.airShip.prefabName = "AirShip"
end

---@private
function StartItemView:InitGenerate__4(Root, data)
--[[
	LevelBox1/activity
--]]
	local tmp = Root:Find("LevelBox1/activity").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.activity = tmp
end

---@private
function StartItemView:GenerateDestroy()
	if tolua.getpeer(self.activity) ~= nil then
		tolua.setpeer(self.activity, nil)
	end
	if self.airShip.GenerateDestroy ~= nil then
		self.airShip:GenerateDestroy()
	end
	if tolua.getpeer(self.airShip) ~= nil then
		tolua.setpeer(self.airShip, nil)
	end
	if tolua.getpeer(self.levelBox1) ~= nil then
		tolua.setpeer(self.levelBox1, nil)
	end
	self.levelBox1 = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return StartItemView