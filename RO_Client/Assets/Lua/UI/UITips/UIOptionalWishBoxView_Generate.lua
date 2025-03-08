---@class UIOptionalWishBox__Generate_btnOK
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIOptionalWishBox__Generate_wishBoxListItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIOptionalWishBox__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIOptionalWishBox__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIOptionalWishBox__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIOptionalWishBox__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIOptionalWishBox__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIEventHandler UIEventHandler
---@field private uIAnimator UIOptionalWishBox__Generate_uIAnimator
---@field private AnyBtn UIOptionalWishBox__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UIOptionalWishBox__Generate_btnClose
---@field private scrollView UIOptionalWishBox__Generate_scrollView
---@field private wishBoxListItem UIOptionalWishBox__Generate_wishBoxListItem
---@field private btnOK UIOptionalWishBox__Generate_btnOK
---@field private title UnityEngine.GameObject
local UIOptionalWishBoxView = class("UIOptionalWishBoxView", require("UIViewBase"))

function UIOptionalWishBoxView:ctor()
end

---@private
function UIOptionalWishBoxView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIOptionalWishBoxView:InitGenerate(Root, data)
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
function UIOptionalWishBoxView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.uIEventHandler = Root:GetComponent(Enum.TypeInfo.UIEventHandler)
end

---@private
function UIOptionalWishBoxView:InitGenerate__2(Root, data)
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
function UIOptionalWishBoxView:InitGenerate__3(Root, data)
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
function UIOptionalWishBoxView:InitGenerate__4(Root, data)
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
function UIOptionalWishBoxView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIOptionalWishBoxView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIOptionalWishBoxView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/ScrollView/Viewport/Content/WishBoxListItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ScrollView/Viewport/Content/WishBoxListItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.wishBoxListItem = CommonUtil.BindGridViewItem2LuaStatic("WishBoxListItem", tmp)
	self.wishBoxListItem.prefabName = "WishBoxListItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIOptionalWishBoxView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/BtnOK
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/BtnOK").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnOK = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIOptionalWishBoxView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/Title
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/Title").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title = tmp
end

---@private
function UIOptionalWishBoxView:GenerateDestroy()
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
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if self.wishBoxListItem.GenerateDestroy ~= nil then
		self.wishBoxListItem:GenerateDestroy()
	end
	if tolua.getpeer(self.wishBoxListItem) ~= nil then
		tolua.setpeer(self.wishBoxListItem, nil)
	end
	self.wishBoxListItem = nil
	if tolua.getpeer(self.btnOK) ~= nil then
		tolua.setpeer(self.btnOK, nil)
	end
	self.btnOK = nil
	if tolua.getpeer(self.title) ~= nil then
		tolua.setpeer(self.title, nil)
	end
	self.title = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIOptionalWishBoxView