---@class UICustomerServiceTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICustomerServiceTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UICustomerServiceTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIEventHandler UIEventHandler
---@field private uIAnimator UICustomerServiceTips__Generate_uIAnimator
---@field private AnyBtn UICustomerServiceTips__Generate_AnyBtn
---@field private texts UnityEngine.GameObject
local UICustomerServiceTipsView = class("UICustomerServiceTipsView", require("UIViewBase"))

function UICustomerServiceTipsView:ctor()
end

---@private
function UICustomerServiceTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UICustomerServiceTipsView:InitGenerate(Root, data)
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
function UICustomerServiceTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.uIEventHandler = Root:GetComponent(Enum.TypeInfo.UIEventHandler)
end

---@private
function UICustomerServiceTipsView:InitGenerate__2(Root, data)
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
function UICustomerServiceTipsView:InitGenerate__3(Root, data)
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
function UICustomerServiceTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/Texts
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/Texts").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.texts = tmp
end

---@private
function UICustomerServiceTipsView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.texts) ~= nil then
		tolua.setpeer(self.texts, nil)
	end
	self.texts = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UICustomerServiceTipsView