---@class UISkillAdvanceTotal__Generate_attr1Title
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UISkillAdvanceTotal__Generate_property
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public loopGridView SuperScrollView.LoopGridView
---@field public noPro UnityEngine.GameObject

---@class UISkillAdvanceTotal__Generate_attrTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UISkillAdvanceTotal__Generate_masteredSkill
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView
---@field public noPro UnityEngine.GameObject

---@class UISkillAdvanceTotal__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillAdvanceTotal__Generate_title
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UISkillAdvanceTotal__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillAdvanceTotal__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISkillAdvanceTotal__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UISkillAdvanceTotal__Generate_uIAnimator
---@field private AnyBtn UISkillAdvanceTotal__Generate_AnyBtn
---@field private title UISkillAdvanceTotal__Generate_title
---@field private btnClose UISkillAdvanceTotal__Generate_btnClose
---@field private masteredSkill UISkillAdvanceTotal__Generate_masteredSkill
---@field private masteredSkillItem UnityEngine.GameObject
---@field private attrTitle UISkillAdvanceTotal__Generate_attrTitle
---@field private property UISkillAdvanceTotal__Generate_property
---@field private fashionPropertyItem UnityEngine.GameObject
---@field private attr1Title UISkillAdvanceTotal__Generate_attr1Title
local UISkillAdvanceTotalView = class("UISkillAdvanceTotalView", require("UIViewBase"))

function UISkillAdvanceTotalView:ctor()
end

---@private
function UISkillAdvanceTotalView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISkillAdvanceTotalView:InitGenerate(Root, data)
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


end

---@private
function UISkillAdvanceTotalView:InitGenerate__1(Root, data)
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
function UISkillAdvanceTotalView:InitGenerate__2(Root, data)
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
function UISkillAdvanceTotalView:InitGenerate__3(Root, data)
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
function UISkillAdvanceTotalView:InitGenerate__4(Root, data)
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
function UISkillAdvanceTotalView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/MasteredSkill
--]]
	local tmp = Root:Find("UIAnimator/Window/MasteredSkill").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.masteredSkill = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UISkillAdvanceTotalView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/MasteredSkill/Viewport/Content/MasteredSkillItem
--]]
	local tmp = Root:Find("UIAnimator/Window/MasteredSkill/Viewport/Content/MasteredSkillItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.masteredSkillItem = CommonUtil.BindGridViewItem2LuaStatic("MasteredSkillItem", tmp)
	self.masteredSkillItem.prefabName = "MasteredSkillItem"
end

---@private
function UISkillAdvanceTotalView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/MasteredSkill/NoPro
--]]
	local tmp = Root:Find("UIAnimator/Window/MasteredSkill/NoPro").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.masteredSkill.noPro = tmp
end

---@private
function UISkillAdvanceTotalView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/MasteredSkill/PropertyTitle/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/MasteredSkill/PropertyTitle/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrTitle = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UISkillAdvanceTotalView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Property
--]]
	local tmp = Root:Find("UIAnimator/Window/Property").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UISkillAdvanceTotalView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Property/Viewport/Content/FashionPropertyItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Property/Viewport/Content/FashionPropertyItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fashionPropertyItem = CommonUtil.BindGridViewItem2LuaStatic("FashionPropertyItem", tmp)
	self.fashionPropertyItem.prefabName = "FashionPropertyItem"
end

---@private
function UISkillAdvanceTotalView:InitGenerate__11(Root, data)
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
function UISkillAdvanceTotalView:InitGenerate__12(Root, data)
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
function UISkillAdvanceTotalView:GenerateDestroy()
	if tolua.getpeer(self.property.noPro) ~= nil then
		tolua.setpeer(self.property.noPro, nil)
	end
	if tolua.getpeer(self.masteredSkill.noPro) ~= nil then
		tolua.setpeer(self.masteredSkill.noPro, nil)
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
	if tolua.getpeer(self.masteredSkill) ~= nil then
		tolua.setpeer(self.masteredSkill, nil)
	end
	self.masteredSkill = nil
	if self.masteredSkillItem.GenerateDestroy ~= nil then
		self.masteredSkillItem:GenerateDestroy()
	end
	if tolua.getpeer(self.masteredSkillItem) ~= nil then
		tolua.setpeer(self.masteredSkillItem, nil)
	end
	self.masteredSkillItem = nil
	if tolua.getpeer(self.attrTitle) ~= nil then
		tolua.setpeer(self.attrTitle, nil)
	end
	self.attrTitle = nil
	if tolua.getpeer(self.property) ~= nil then
		tolua.setpeer(self.property, nil)
	end
	self.property = nil
	if self.fashionPropertyItem.GenerateDestroy ~= nil then
		self.fashionPropertyItem:GenerateDestroy()
	end
	if tolua.getpeer(self.fashionPropertyItem) ~= nil then
		tolua.setpeer(self.fashionPropertyItem, nil)
	end
	self.fashionPropertyItem = nil
	if tolua.getpeer(self.attr1Title) ~= nil then
		tolua.setpeer(self.attr1Title, nil)
	end
	self.attr1Title = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISkillAdvanceTotalView