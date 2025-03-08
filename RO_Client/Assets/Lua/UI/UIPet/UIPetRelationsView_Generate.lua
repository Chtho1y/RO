---@class UIPetRelations__Generate_btnBack
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetRelations__Generate_btnRelation
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetRelations__Generate_btnPlayRule
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetRelations__Generate_btnRelations
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetRelations__Generate_petRelationItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIPetRelations__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UIPetRelations__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetRelations__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIPetRelations__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIPetRelations__Generate_uIAnimator
---@field private AnyBtn UIPetRelations__Generate_AnyBtn
---@field private scrollView UIPetRelations__Generate_scrollView
---@field private petRelationItem UIPetRelations__Generate_petRelationItem
---@field private btnRelations UIPetRelations__Generate_btnRelations
---@field private btnPlayRule UIPetRelations__Generate_btnPlayRule
---@field private btnRelation UIPetRelations__Generate_btnRelation
---@field private btnBack UIPetRelations__Generate_btnBack
local UIPetRelationsView = class("UIPetRelationsView", require("UIViewBase"))

function UIPetRelationsView:ctor()
end

---@private
function UIPetRelationsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPetRelationsView:InitGenerate(Root, data)
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
function UIPetRelationsView:InitGenerate__1(Root, data)
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
function UIPetRelationsView:InitGenerate__2(Root, data)
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
function UIPetRelationsView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Scroll View
--]]
	local tmp = Root:Find("UIAnimator/Window/Scroll View").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIPetRelationsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Scroll View/Viewport/Content/PetRelationItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Scroll View/Viewport/Content/PetRelationItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petRelationItem = CommonUtil.BindGridViewItem2LuaStatic("PetRelationItem", tmp)
	self.petRelationItem.prefabName = "PetRelationItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIPetRelationsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Title/BtnRelations
--]]
	local tmp = Root:Find("UIAnimator/Window/Title/BtnRelations").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRelations = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetRelationsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BGRule/BtnPlayRule
--]]
	local tmp = Root:Find("UIAnimator/Window/BGRule/BtnPlayRule").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPlayRule = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetRelationsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BtnRelation
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnRelation").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRelation = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetRelationsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBack = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetRelationsView:GenerateDestroy()
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
	if self.petRelationItem.GenerateDestroy ~= nil then
		self.petRelationItem:GenerateDestroy()
	end
	if tolua.getpeer(self.petRelationItem) ~= nil then
		tolua.setpeer(self.petRelationItem, nil)
	end
	self.petRelationItem = nil
	if tolua.getpeer(self.btnRelations) ~= nil then
		tolua.setpeer(self.btnRelations, nil)
	end
	self.btnRelations = nil
	if tolua.getpeer(self.btnPlayRule) ~= nil then
		tolua.setpeer(self.btnPlayRule, nil)
	end
	self.btnPlayRule = nil
	if tolua.getpeer(self.btnRelation) ~= nil then
		tolua.setpeer(self.btnRelation, nil)
	end
	self.btnRelation = nil
	if tolua.getpeer(self.btnBack) ~= nil then
		tolua.setpeer(self.btnBack, nil)
	end
	self.btnBack = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPetRelationsView