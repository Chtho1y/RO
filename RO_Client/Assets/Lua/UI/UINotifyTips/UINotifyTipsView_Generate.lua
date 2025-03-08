---@class UINotifyTips__Generate_BtnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UINotifyTips__Generate_scrollViewNotify_content
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UINotifyTips__Generate_scrollViewNotify
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UINotifyTips__Generate_scrollViewNotify_content

---@class UINotifyTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UINotifyTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UINotifyTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UINotifyTips__Generate_uIAnimator
---@field private AnyBtn UINotifyTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private scrollViewNotify UINotifyTips__Generate_scrollViewNotify
---@field private BtnClose UINotifyTips__Generate_BtnClose
local UINotifyTipsView = class("UINotifyTipsView", require("UIViewBase"))

function UINotifyTipsView:ctor()
end

---@private
function UINotifyTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UINotifyTipsView:InitGenerate(Root, data)
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


end

---@private
function UINotifyTipsView:InitGenerate__1(Root, data)
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
function UINotifyTipsView:InitGenerate__2(Root, data)
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
function UINotifyTipsView:InitGenerate__3(Root, data)
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
function UINotifyTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/ScrollViewNotify
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollViewNotify").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollViewNotify = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UINotifyTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ScrollViewNotify/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollViewNotify/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollViewNotify.content = tmp

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)
end

---@private
function UINotifyTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ClostBox/BtnCloseFlat
--]]
	local tmp = Root:Find("UIAnimator/Window/ClostBox/BtnCloseFlat").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.BtnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UINotifyTipsView:GenerateDestroy()
	if tolua.getpeer(self.scrollViewNotify.content) ~= nil then
		tolua.setpeer(self.scrollViewNotify.content, nil)
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
	if tolua.getpeer(self.scrollViewNotify) ~= nil then
		tolua.setpeer(self.scrollViewNotify, nil)
	end
	self.scrollViewNotify = nil
	if tolua.getpeer(self.BtnClose) ~= nil then
		tolua.setpeer(self.BtnClose, nil)
	end
	self.BtnClose = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UINotifyTipsView