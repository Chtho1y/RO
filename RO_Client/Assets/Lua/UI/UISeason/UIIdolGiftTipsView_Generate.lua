---@class UIIdolGiftTips__Generate_loadingItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIIdolGiftTips__Generate_rankScroll
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView
---@field public scrollRect UnityEngine.UI.ScrollRect

---@class UIIdolGiftTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIIdolGiftTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIIdolGiftTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIIdolGiftTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIIdolGiftTips__Generate_uIAnimator
---@field private AnyBtn UIIdolGiftTips__Generate_AnyBtn
---@field private btnClose UIIdolGiftTips__Generate_btnClose
---@field private rankScroll UIIdolGiftTips__Generate_rankScroll
---@field private content UnityEngine.GameObject
---@field private uIIdolGiftItem UnityEngine.GameObject
---@field private loadingItem UIIdolGiftTips__Generate_loadingItem
local UIIdolGiftTipsView = class("UIIdolGiftTipsView", require("UIViewBase"))

function UIIdolGiftTipsView:ctor()
end

---@private
function UIIdolGiftTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIIdolGiftTipsView:InitGenerate(Root, data)
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


end

---@private
function UIIdolGiftTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIIdolGiftTipsView:InitGenerate__2(Root, data)
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
function UIIdolGiftTipsView:InitGenerate__3(Root, data)
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
function UIIdolGiftTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIIdolGiftTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankScroll = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)
end

---@private
function UIIdolGiftTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ScrollView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp
end

---@private
function UIIdolGiftTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/ScrollView/Viewport/Content/UIIdolGiftItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView/Viewport/Content/UIIdolGiftItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIIdolGiftItem = CommonUtil.BindGridViewItem2LuaStatic("UIIdolGiftItem", tmp)
	self.uIIdolGiftItem.prefabName = "UIIdolGiftItem"
end

---@private
function UIIdolGiftTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/ScrollView/Viewport/Content/LoadingItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView/Viewport/Content/LoadingItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loadingItem = CommonUtil.BindGridViewItem2LuaStatic("LoadingItem", tmp)
	self.loadingItem.prefabName = "LoadingItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIIdolGiftTipsView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.rankScroll) ~= nil then
		tolua.setpeer(self.rankScroll, nil)
	end
	self.rankScroll = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	if self.uIIdolGiftItem.GenerateDestroy ~= nil then
		self.uIIdolGiftItem:GenerateDestroy()
	end
	if tolua.getpeer(self.uIIdolGiftItem) ~= nil then
		tolua.setpeer(self.uIIdolGiftItem, nil)
	end
	self.uIIdolGiftItem = nil
	if self.loadingItem.GenerateDestroy ~= nil then
		self.loadingItem:GenerateDestroy()
	end
	if tolua.getpeer(self.loadingItem) ~= nil then
		tolua.setpeer(self.loadingItem, nil)
	end
	self.loadingItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIIdolGiftTipsView