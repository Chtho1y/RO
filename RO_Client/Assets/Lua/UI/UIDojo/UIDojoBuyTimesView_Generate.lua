---@class UIDojoBuyTimes__Generate_buyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojoBuyTimes__Generate_leftTimesText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoBuyTimes__Generate_costText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoBuyTimes__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojoBuyTimes__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojoBuyTimes__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIDojoBuyTimes__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIDojoBuyTimes__Generate_uIAnimator
---@field private AnyBtn UIDojoBuyTimes__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private closeBtn UIDojoBuyTimes__Generate_closeBtn
---@field private costText UIDojoBuyTimes__Generate_costText
---@field private title UnityEngine.GameObject
---@field private leftTimesText UIDojoBuyTimes__Generate_leftTimesText
---@field private buyBtn UIDojoBuyTimes__Generate_buyBtn
local UIDojoBuyTimesView = class("UIDojoBuyTimesView", require("UIViewBase"))

function UIDojoBuyTimesView:ctor()
end

---@private
function UIDojoBuyTimesView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIDojoBuyTimesView:InitGenerate(Root, data)
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
	self:InitGenerate__6(Root,data)
	self:InitGenerate__7(Root,data)
	self:InitGenerate__8(Root,data)
	self:InitGenerate__9(Root,data)


end

---@private
function UIDojoBuyTimesView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIDojoBuyTimesView:InitGenerate__2(Root, data)
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
function UIDojoBuyTimesView:InitGenerate__3(Root, data)
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
function UIDojoBuyTimesView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window
--]]
	local tmp = Root:Find("UIAnimator/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp
end

---@private
function UIDojoBuyTimesView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojoBuyTimesView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/Center/Bg/Text/Cost
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Center/Bg/Text/Cost").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.costText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoBuyTimesView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/Title
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/Title").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title = tmp
end

---@private
function UIDojoBuyTimesView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/Title/LeftTimes
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/Title/LeftTimes").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftTimesText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoBuyTimesView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/BuyBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/BuyBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojoBuyTimesView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if tolua.getpeer(self.closeBtn) ~= nil then
		tolua.setpeer(self.closeBtn, nil)
	end
	self.closeBtn = nil
	if tolua.getpeer(self.costText) ~= nil then
		tolua.setpeer(self.costText, nil)
	end
	self.costText = nil
	if tolua.getpeer(self.title) ~= nil then
		tolua.setpeer(self.title, nil)
	end
	self.title = nil
	if tolua.getpeer(self.leftTimesText) ~= nil then
		tolua.setpeer(self.leftTimesText, nil)
	end
	self.leftTimesText = nil
	if tolua.getpeer(self.buyBtn) ~= nil then
		tolua.setpeer(self.buyBtn, nil)
	end
	self.buyBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIDojoBuyTimesView