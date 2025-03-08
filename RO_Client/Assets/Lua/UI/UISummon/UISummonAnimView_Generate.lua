---@class UISummonAnim__Generate_white
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISummonAnim__Generate_drawRect
---@field public gameObject UnityEngine.GameObject
---@field public uIEventTriggerListener UIEventTriggerListener

---@class UISummonAnim__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummonAnim__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISummonAnim__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UISummonAnim__Generate_uIAnimator
---@field private AnyBtn UISummonAnim__Generate_AnyBtn
---@field private drawRect UISummonAnim__Generate_drawRect
---@field private guide UnityEngine.GameObject
---@field private white UISummonAnim__Generate_white
local UISummonAnimView = class("UISummonAnimView", require("UIViewBase"))

function UISummonAnimView:ctor()
end

---@private
function UISummonAnimView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISummonAnimView:InitGenerate(Root, data)
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
	self:InitGenerate__5(Root,data)


end

---@private
function UISummonAnimView:InitGenerate__1(Root, data)
--[[
	UIAnimator
--]]
	local tmp = Root:Find("UIAnimator").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIAnimator = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UISummonAnimView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonAnimView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/DrawRect
--]]
	local tmp = Root:Find("UIAnimator/Window/DrawRect").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.drawRect = tmp

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
end

---@private
function UISummonAnimView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Guide
--]]
	local tmp = Root:Find("UIAnimator/Window/Guide").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guide = tmp
end

---@private
function UISummonAnimView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/White
--]]
	local tmp = Root:Find("UIAnimator/Window/White").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.white = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISummonAnimView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.drawRect) ~= nil then
		tolua.setpeer(self.drawRect, nil)
	end
	self.drawRect = nil
	if tolua.getpeer(self.guide) ~= nil then
		tolua.setpeer(self.guide, nil)
	end
	self.guide = nil
	if tolua.getpeer(self.white) ~= nil then
		tolua.setpeer(self.white, nil)
	end
	self.white = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISummonAnimView