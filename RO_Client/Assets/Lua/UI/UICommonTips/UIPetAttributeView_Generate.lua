---@class UIPetAttribute__Generate_addSView_content
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIPetAttribute__Generate_addSView
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UIPetAttribute__Generate_addSView_content

---@class UIPetAttribute__Generate_baseSView_content
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIPetAttribute__Generate_baseSView
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UIPetAttribute__Generate_baseSView_content

---@class UIPetAttribute__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UIPetAttribute__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetAttribute__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIPetAttribute__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIPetAttribute__Generate_uIAnimator
---@field private AnyBtn UIPetAttribute__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private bg UIPetAttribute__Generate_bg
---@field private baseAttrs UnityEngine.GameObject
---@field private baseSView UIPetAttribute__Generate_baseSView
---@field private addAttrs UnityEngine.GameObject
---@field private addSView UIPetAttribute__Generate_addSView
---@field private none UnityEngine.GameObject
---@field private natureAttrItem UnityEngine.GameObject
local UIPetAttributeView = class("UIPetAttributeView", require("UIViewBase"))

function UIPetAttributeView:ctor()
end

---@private
function UIPetAttributeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPetAttributeView:InitGenerate(Root, data)
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
	self:InitGenerate__11(Root,data)
	self:InitGenerate__12(Root,data)
	self:InitGenerate__13(Root,data)


end

---@private
function UIPetAttributeView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIPetAttributeView:InitGenerate__2(Root, data)
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
function UIPetAttributeView:InitGenerate__3(Root, data)
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
function UIPetAttributeView:InitGenerate__4(Root, data)
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
function UIPetAttributeView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)
end

---@private
function UIPetAttributeView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/Nature/Scroll View/Viewport/Content/BaseAttrs
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Nature/Scroll View/Viewport/Content/BaseAttrs").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.baseAttrs = tmp
end

---@private
function UIPetAttributeView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/Nature/Scroll View/Viewport/Content/BaseSView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Nature/Scroll View/Viewport/Content/BaseSView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.baseSView = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIPetAttributeView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/Nature/Scroll View/Viewport/Content/BaseSView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Nature/Scroll View/Viewport/Content/BaseSView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.baseSView.content = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIPetAttributeView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/Nature/Scroll View/Viewport/Content/AddAttrs
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Nature/Scroll View/Viewport/Content/AddAttrs").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addAttrs = tmp
end

---@private
function UIPetAttributeView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/Nature/Scroll View/Viewport/Content/AddSView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Nature/Scroll View/Viewport/Content/AddSView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addSView = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIPetAttributeView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/Nature/Scroll View/Viewport/Content/AddSView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Nature/Scroll View/Viewport/Content/AddSView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addSView.content = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIPetAttributeView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/Nature/Scroll View/Viewport/Content/None
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Nature/Scroll View/Viewport/Content/None").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.none = tmp
end

---@private
function UIPetAttributeView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/Nature/Scroll View/Viewport/NatureAttrItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Nature/Scroll View/Viewport/NatureAttrItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.natureAttrItem = CommonUtil.BindGridViewItem2LuaStatic("NatureAttrItem", tmp)
	self.natureAttrItem.prefabName = "NatureAttrItem"
end

---@private
function UIPetAttributeView:GenerateDestroy()
	if tolua.getpeer(self.addSView.content) ~= nil then
		tolua.setpeer(self.addSView.content, nil)
	end
	if tolua.getpeer(self.baseSView.content) ~= nil then
		tolua.setpeer(self.baseSView.content, nil)
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
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.baseAttrs) ~= nil then
		tolua.setpeer(self.baseAttrs, nil)
	end
	self.baseAttrs = nil
	if tolua.getpeer(self.baseSView) ~= nil then
		tolua.setpeer(self.baseSView, nil)
	end
	self.baseSView = nil
	if tolua.getpeer(self.addAttrs) ~= nil then
		tolua.setpeer(self.addAttrs, nil)
	end
	self.addAttrs = nil
	if tolua.getpeer(self.addSView) ~= nil then
		tolua.setpeer(self.addSView, nil)
	end
	self.addSView = nil
	if tolua.getpeer(self.none) ~= nil then
		tolua.setpeer(self.none, nil)
	end
	self.none = nil
	if self.natureAttrItem.GenerateDestroy ~= nil then
		self.natureAttrItem:GenerateDestroy()
	end
	if tolua.getpeer(self.natureAttrItem) ~= nil then
		tolua.setpeer(self.natureAttrItem, nil)
	end
	self.natureAttrItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPetAttributeView