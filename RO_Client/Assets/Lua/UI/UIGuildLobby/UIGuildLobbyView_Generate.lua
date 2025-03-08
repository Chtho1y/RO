---@class UIGuildLobby__Generate_btnExit
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildLobby__Generate_joystick
---@field public gameObject UnityEngine.GameObject
---@field public uIJoystick UIJoystick

---@class UIGuildLobby__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private joystick UIGuildLobby__Generate_joystick
---@field private btnExit UIGuildLobby__Generate_btnExit
local UIGuildLobbyView = class("UIGuildLobbyView", require("UIViewBase"))

function UIGuildLobbyView:ctor()
end

---@private
function UIGuildLobbyView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildLobbyView:InitGenerate(Root, data)
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
function UIGuildLobbyView:InitGenerate__1(Root, data)
--[[
	Joystick
--]]
	local tmp = Root:Find("Joystick").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.joystick = tmp

	tmp.uIJoystick = tmp:GetComponent(Enum.TypeInfo.UIJoystick)
end

---@private
function UIGuildLobbyView:InitGenerate__2(Root, data)
--[[
	BtnExit
--]]
	local tmp = Root:Find("BtnExit").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnExit = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildLobbyView:GenerateDestroy()
	if tolua.getpeer(self.joystick) ~= nil then
		tolua.setpeer(self.joystick, nil)
	end
	self.joystick = nil
	if tolua.getpeer(self.btnExit) ~= nil then
		tolua.setpeer(self.btnExit, nil)
	end
	self.btnExit = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildLobbyView