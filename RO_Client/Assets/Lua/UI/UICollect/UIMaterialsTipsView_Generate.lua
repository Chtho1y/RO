---@class UIMaterialsTips__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIMaterialsTips__Generate_mats
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIMaterialsTips__Generate_textTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIMaterialsTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMaterialsTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMaterialsTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIMaterialsTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIMaterialsTips__Generate_uIAnimator
---@field private AnyBtn UIMaterialsTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UIMaterialsTips__Generate_btnClose
---@field private textTitle UIMaterialsTips__Generate_textTitle
---@field private mats UIMaterialsTips__Generate_mats
---@field private iconItem UIMaterialsTips__Generate_iconItem
---@field private noPets UnityEngine.GameObject
local UIMaterialsTipsView = class("UIMaterialsTipsView", require("UIViewBase"))

function UIMaterialsTipsView:ctor()
end

---@private
function UIMaterialsTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIMaterialsTipsView:InitGenerate(Root, data)
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
function UIMaterialsTipsView:InitGenerate__1(Root, data)
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
function UIMaterialsTipsView:InitGenerate__2(Root, data)
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
function UIMaterialsTipsView:InitGenerate__3(Root, data)
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
function UIMaterialsTipsView:InitGenerate__4(Root, data)
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
function UIMaterialsTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/TextTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TextTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textTitle = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIMaterialsTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/List/Mats
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Mats").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mats = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIMaterialsTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/List/Mats/View/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Mats/View/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIMaterialsTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/List/NoPets
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/NoPets").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noPets = tmp
end

---@private
function UIMaterialsTipsView:GenerateDestroy()
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
	if tolua.getpeer(self.textTitle) ~= nil then
		tolua.setpeer(self.textTitle, nil)
	end
	self.textTitle = nil
	if tolua.getpeer(self.mats) ~= nil then
		tolua.setpeer(self.mats, nil)
	end
	self.mats = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if tolua.getpeer(self.noPets) ~= nil then
		tolua.setpeer(self.noPets, nil)
	end
	self.noPets = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIMaterialsTipsView