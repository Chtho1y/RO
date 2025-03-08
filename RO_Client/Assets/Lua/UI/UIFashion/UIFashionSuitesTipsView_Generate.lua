---@class UIFashionSuitesTips__Generate_fashionSuitesItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIFashionSuitesTips__Generate_suitesScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UIFashionSuitesTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionSuitesTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionSuitesTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIFashionSuitesTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIFashionSuitesTips__Generate_uIAnimator
---@field private AnyBtn UIFashionSuitesTips__Generate_AnyBtn
---@field private btnClose UIFashionSuitesTips__Generate_btnClose
---@field private suitesScrollView UIFashionSuitesTips__Generate_suitesScrollView
---@field private fashionSuitesItem UIFashionSuitesTips__Generate_fashionSuitesItem
local UIFashionSuitesTipsView = class("UIFashionSuitesTipsView", require("UIViewBase"))

function UIFashionSuitesTipsView:ctor()
end

---@private
function UIFashionSuitesTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIFashionSuitesTipsView:InitGenerate(Root, data)
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
function UIFashionSuitesTipsView:InitGenerate__1(Root, data)
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
function UIFashionSuitesTipsView:InitGenerate__2(Root, data)
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
function UIFashionSuitesTipsView:InitGenerate__3(Root, data)
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
function UIFashionSuitesTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/SuitesScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/SuitesScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.suitesScrollView = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIFashionSuitesTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/SuitesScrollView/Viewport/Content/FashionSuitesItem
--]]
	local tmp = Root:Find("UIAnimator/Window/SuitesScrollView/Viewport/Content/FashionSuitesItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fashionSuitesItem = CommonUtil.BindGridViewItem2LuaStatic("FashionSuitesItem", tmp)
	self.fashionSuitesItem.prefabName = "FashionSuitesItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIFashionSuitesTipsView:GenerateDestroy()
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
	if tolua.getpeer(self.suitesScrollView) ~= nil then
		tolua.setpeer(self.suitesScrollView, nil)
	end
	self.suitesScrollView = nil
	if self.fashionSuitesItem.GenerateDestroy ~= nil then
		self.fashionSuitesItem:GenerateDestroy()
	end
	if tolua.getpeer(self.fashionSuitesItem) ~= nil then
		tolua.setpeer(self.fashionSuitesItem, nil)
	end
	self.fashionSuitesItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIFashionSuitesTipsView