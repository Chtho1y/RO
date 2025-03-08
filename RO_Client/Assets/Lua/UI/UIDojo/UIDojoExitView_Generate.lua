---@class UIDojoExit__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private centerView UnityEngine.GameObject
local UIDojoExitView = class("UIDojoExitView", require("UIViewBase"))

function UIDojoExitView:ctor()
end

---@private
function UIDojoExitView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIDojoExitView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)


end

---@private
function UIDojoExitView:InitGenerate__1(Root, data)
--[[
	CenterView
--]]
	local tmp = Root:Find("CenterView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.centerView = tmp
end

---@private
function UIDojoExitView:GenerateDestroy()
	if tolua.getpeer(self.centerView) ~= nil then
		tolua.setpeer(self.centerView, nil)
	end
	self.centerView = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIDojoExitView