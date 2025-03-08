---@class UIPOPGotAnims__Generate_alpha
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPOPGotAnims__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private alpha UIPOPGotAnims__Generate_alpha
local UIPOPGotAnimsView = class("UIPOPGotAnimsView", require("UIViewBase"))

function UIPOPGotAnimsView:ctor()
end

---@private
function UIPOPGotAnimsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPOPGotAnimsView:InitGenerate(Root, data)
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
function UIPOPGotAnimsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIPOPGotAnimsView:InitGenerate__2(Root, data)
--[[
	Alpha
--]]
	local tmp = Root:Find("Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.alpha = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPOPGotAnimsView:GenerateDestroy()
	if tolua.getpeer(self.alpha) ~= nil then
		tolua.setpeer(self.alpha, nil)
	end
	self.alpha = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPOPGotAnimsView