---@class UIWishPOPGot__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIWishPOPGot__Generate_wishLuckyItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIWishPOPGot__Generate_titleNode
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI
---@field public uILocalizeScript UILocalizeScript

---@class UIWishPOPGot__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView
---@field public scrollRect UnityEngine.UI.ScrollRect

---@class UIWishPOPGot__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIWishPOPGot__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIWishPOPGot__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIWishPOPGot__Generate_uIAnimator
---@field private AnyBtn UIWishPOPGot__Generate_AnyBtn
---@field private scrollView UIWishPOPGot__Generate_scrollView
---@field private titleNode UIWishPOPGot__Generate_titleNode
---@field private wishLuckyItem UIWishPOPGot__Generate_wishLuckyItem
---@field private iconItem UIWishPOPGot__Generate_iconItem
local UIWishPOPGotView = class("UIWishPOPGotView", require("UIViewBase"))

function UIWishPOPGotView:ctor()
end

---@private
function UIWishPOPGotView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIWishPOPGotView:InitGenerate(Root, data)
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
function UIWishPOPGotView:InitGenerate__1(Root, data)
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
function UIWishPOPGotView:InitGenerate__2(Root, data)
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
function UIWishPOPGotView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)
end

---@private
function UIWishPOPGotView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/ScrollView/Bg/Title/Image/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView/Bg/Title/Image/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.titleNode = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIWishPOPGotView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ScrollView/Viewport/WishLuckyItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView/Viewport/WishLuckyItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.wishLuckyItem = CommonUtil.BindGridViewItem2LuaStatic("WishLuckyItem", tmp)
	self.wishLuckyItem.prefabName = "WishLuckyItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIWishPOPGotView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ScrollView/Viewport/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView/Viewport/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIWishPOPGotView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.titleNode) ~= nil then
		tolua.setpeer(self.titleNode, nil)
	end
	self.titleNode = nil
	if self.wishLuckyItem.GenerateDestroy ~= nil then
		self.wishLuckyItem:GenerateDestroy()
	end
	if tolua.getpeer(self.wishLuckyItem) ~= nil then
		tolua.setpeer(self.wishLuckyItem, nil)
	end
	self.wishLuckyItem = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIWishPOPGotView