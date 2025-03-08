---@class IdolSuccessTips__Generate_particle
---@field public gameObject UnityEngine.GameObject
---@field public uIParticle UIExtensions.UIParticle

---@class IdolSuccessTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class IdolSuccessTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field private canvasGroup UnityEngine.CanvasGroup
---@field private AnyBtn IdolSuccessTips__Generate_AnyBtn
---@field private particle IdolSuccessTips__Generate_particle
local IdolSuccessTipsView = class("IdolSuccessTipsView", require("UIViewBase"))

function IdolSuccessTipsView:ctor()
end

---@private
function IdolSuccessTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function IdolSuccessTipsView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function IdolSuccessTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)

	self.loopVerticalScrollRect = Root:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)

	self.canvasGroup = Root:GetComponent(Enum.TypeInfo.CanvasGroup)
end

---@private
function IdolSuccessTipsView:InitGenerate__2(Root, data)
--[[
	Alpha
--]]
	local tmp = Root:Find("Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function IdolSuccessTipsView:InitGenerate__3(Root, data)
--[[
	particle
--]]
	local tmp = Root:Find("particle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.particle = tmp

	tmp.uIParticle = tmp:GetComponent(Enum.TypeInfo.UIParticle)
end

---@private
function IdolSuccessTipsView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.particle) ~= nil then
		tolua.setpeer(self.particle, nil)
	end
	self.particle = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return IdolSuccessTipsView