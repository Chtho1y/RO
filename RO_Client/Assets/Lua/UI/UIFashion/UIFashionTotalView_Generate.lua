---@class UIFashionTotal__Generate_attr1Title
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIFashionTotal__Generate_property
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public noPro UnityEngine.GameObject

---@class UIFashionTotal__Generate_attrTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIFashionTotal__Generate_propertySuit
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public noPro UnityEngine.GameObject

---@class UIFashionTotal__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionTotal__Generate_title
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIFashionTotal__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionTotal__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIFashionTotal__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIFashionTotal__Generate_uIAnimator
---@field private AnyBtn UIFashionTotal__Generate_AnyBtn
---@field private title UIFashionTotal__Generate_title
---@field private btnClose UIFashionTotal__Generate_btnClose
---@field private fashionPropertyItem UnityEngine.GameObject
---@field private propertySuit UIFashionTotal__Generate_propertySuit
---@field private attrTitle UIFashionTotal__Generate_attrTitle
---@field private property UIFashionTotal__Generate_property
---@field private attr1Title UIFashionTotal__Generate_attr1Title
local UIFashionTotalView = class("UIFashionTotalView", require("UIViewBase"))

function UIFashionTotalView:ctor()
end

---@private
function UIFashionTotalView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIFashionTotalView:InitGenerate(Root, data)
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


end

---@private
function UIFashionTotalView:InitGenerate__1(Root, data)
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
function UIFashionTotalView:InitGenerate__2(Root, data)
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
function UIFashionTotalView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/TextTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/TextTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIFashionTotalView:InitGenerate__4(Root, data)
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
function UIFashionTotalView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/FashionPropertyItem
--]]
	local tmp = Root:Find("UIAnimator/Window/FashionPropertyItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fashionPropertyItem = CommonUtil.BindGridViewItem2LuaStatic("FashionPropertyItem", tmp)
	self.fashionPropertyItem.prefabName = "FashionPropertyItem"
end

---@private
function UIFashionTotalView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/PropertySuit
--]]
	local tmp = Root:Find("UIAnimator/Window/PropertySuit").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.propertySuit = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIFashionTotalView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/PropertySuit/NoPro
--]]
	local tmp = Root:Find("UIAnimator/Window/PropertySuit/NoPro").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.propertySuit.noPro = tmp
end

---@private
function UIFashionTotalView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/PropertySuit/PropertyTitle/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/PropertySuit/PropertyTitle/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrTitle = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIFashionTotalView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Property
--]]
	local tmp = Root:Find("UIAnimator/Window/Property").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIFashionTotalView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Property/NoPro
--]]
	local tmp = Root:Find("UIAnimator/Window/Property/NoPro").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property.noPro = tmp
end

---@private
function UIFashionTotalView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Property/PropertyTitle/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Property/PropertyTitle/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attr1Title = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIFashionTotalView:GenerateDestroy()
	if tolua.getpeer(self.property.noPro) ~= nil then
		tolua.setpeer(self.property.noPro, nil)
	end
	if tolua.getpeer(self.propertySuit.noPro) ~= nil then
		tolua.setpeer(self.propertySuit.noPro, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.title) ~= nil then
		tolua.setpeer(self.title, nil)
	end
	self.title = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if self.fashionPropertyItem.GenerateDestroy ~= nil then
		self.fashionPropertyItem:GenerateDestroy()
	end
	if tolua.getpeer(self.fashionPropertyItem) ~= nil then
		tolua.setpeer(self.fashionPropertyItem, nil)
	end
	self.fashionPropertyItem = nil
	if tolua.getpeer(self.propertySuit) ~= nil then
		tolua.setpeer(self.propertySuit, nil)
	end
	self.propertySuit = nil
	if tolua.getpeer(self.attrTitle) ~= nil then
		tolua.setpeer(self.attrTitle, nil)
	end
	self.attrTitle = nil
	if tolua.getpeer(self.property) ~= nil then
		tolua.setpeer(self.property, nil)
	end
	self.property = nil
	if tolua.getpeer(self.attr1Title) ~= nil then
		tolua.setpeer(self.attr1Title, nil)
	end
	self.attr1Title = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIFashionTotalView