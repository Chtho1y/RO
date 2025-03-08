---@class UIIdolMyFansTips__Generate_fansItem_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIIdolMyFansTips__Generate_fansItem
---@field public gameObject UnityEngine.GameObject
---@field public text UIIdolMyFansTips__Generate_fansItem_text

---@class UIIdolMyFansTips__Generate_rankScroll
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView
---@field public scrollRect UnityEngine.UI.ScrollRect

---@class UIIdolMyFansTips__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIIdolMyFansTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIIdolMyFansTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIIdolMyFansTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIIdolMyFansTips__Generate_uIAnimator
---@field private AnyBtn UIIdolMyFansTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private closeBtn UIIdolMyFansTips__Generate_closeBtn
---@field private rankScroll UIIdolMyFansTips__Generate_rankScroll
---@field private rankContent UnityEngine.GameObject
---@field private fansItem UIIdolMyFansTips__Generate_fansItem
---@field private emptyNode UnityEngine.GameObject
local UIIdolMyFansTipsView = class("UIIdolMyFansTipsView", require("UIViewBase"))

function UIIdolMyFansTipsView:ctor()
end

---@private
function UIIdolMyFansTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIIdolMyFansTipsView:InitGenerate(Root, data)
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
	self:InitGenerate__10(Root,data)


end

---@private
function UIIdolMyFansTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIIdolMyFansTipsView:InitGenerate__2(Root, data)
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
function UIIdolMyFansTipsView:InitGenerate__3(Root, data)
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
function UIIdolMyFansTipsView:InitGenerate__4(Root, data)
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
function UIIdolMyFansTipsView:InitGenerate__5(Root, data)
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
function UIIdolMyFansTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/ListScroll
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/ListScroll").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankScroll = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)
end

---@private
function UIIdolMyFansTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/ListScroll/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/ListScroll/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankContent = tmp
end

---@private
function UIIdolMyFansTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/ListScroll/Viewport/Content/FansItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/ListScroll/Viewport/Content/FansItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fansItem = tmp
end

---@private
function UIIdolMyFansTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/ListScroll/Viewport/Content/FansItem/text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/ListScroll/Viewport/Content/FansItem/text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fansItem.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIIdolMyFansTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/Empty
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/Empty").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emptyNode = tmp
end

---@private
function UIIdolMyFansTipsView:GenerateDestroy()
	if tolua.getpeer(self.fansItem.text) ~= nil then
		tolua.setpeer(self.fansItem.text, nil)
	end
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
	if tolua.getpeer(self.rankScroll) ~= nil then
		tolua.setpeer(self.rankScroll, nil)
	end
	self.rankScroll = nil
	if tolua.getpeer(self.rankContent) ~= nil then
		tolua.setpeer(self.rankContent, nil)
	end
	self.rankContent = nil
	if tolua.getpeer(self.fansItem) ~= nil then
		tolua.setpeer(self.fansItem, nil)
	end
	self.fansItem = nil
	if tolua.getpeer(self.emptyNode) ~= nil then
		tolua.setpeer(self.emptyNode, nil)
	end
	self.emptyNode = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIIdolMyFansTipsView