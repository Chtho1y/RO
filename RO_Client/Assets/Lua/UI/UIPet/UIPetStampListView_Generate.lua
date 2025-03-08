---@class UIPetStampList__Generate_equipListItem
---@field public gameObject UnityEngine.GameObject
---@field public contentSizeFitter UnityEngine.UI.ContentSizeFitter

---@class UIPetStampList__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UIPetStampList__Generate_btnDown
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetStampList__Generate_btnChange
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetStampList__Generate_topItem_textName
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPetStampList__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIPetStampList__Generate_topItem
---@field public gameObject UnityEngine.GameObject
---@field public textName UIPetStampList__Generate_topItem_textName
---@field public grid UnityEngine.GameObject

---@class UIPetStampList__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetStampList__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetStampList__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIPetStampList__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIPetStampList__Generate_uIAnimator
---@field private AnyBtn UIPetStampList__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UIPetStampList__Generate_btnClose
---@field private topItem UIPetStampList__Generate_topItem
---@field private equipListEquippedItem UnityEngine.GameObject
---@field private contentItem UnityEngine.GameObject
---@field private iconItem UIPetStampList__Generate_iconItem
---@field private equipBaseAttrItem UnityEngine.GameObject
---@field private equiped UnityEngine.GameObject
---@field private btnChange UIPetStampList__Generate_btnChange
---@field private btnDown UIPetStampList__Generate_btnDown
---@field private equipBlank UnityEngine.GameObject
---@field private scrollView UIPetStampList__Generate_scrollView
---@field private equipListItem UIPetStampList__Generate_equipListItem
local UIPetStampListView = class("UIPetStampListView", require("UIViewBase"))

function UIPetStampListView:ctor()
end

---@private
function UIPetStampListView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPetStampListView:InitGenerate(Root, data)
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
	self:InitGenerate__14(Root,data)
	self:InitGenerate__15(Root,data)
	self:InitGenerate__16(Root,data)
	self:InitGenerate__17(Root,data)
	self:InitGenerate__18(Root,data)


end

---@private
function UIPetStampListView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIPetStampListView:InitGenerate__2(Root, data)
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
function UIPetStampListView:InitGenerate__3(Root, data)
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
function UIPetStampListView:InitGenerate__4(Root, data)
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
function UIPetStampListView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetStampListView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.topItem = tmp
end

---@private
function UIPetStampListView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/EquipListEquippedItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/EquipListEquippedItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipListEquippedItem = tmp
end

---@private
function UIPetStampListView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/ContentItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/ContentItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contentItem = tmp
end

---@private
function UIPetStampListView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/ContentItem/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/ContentItem/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIPetStampListView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/TextsBox/TextName
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/TextsBox/TextName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.topItem.textName = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPetStampListView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/TextsBox/EquipBaseAttrItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/TextsBox/EquipBaseAttrItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBaseAttrItem = CommonUtil.BindGridViewItem2LuaStatic("EquipBaseAttrItem", tmp)
	self.equipBaseAttrItem.prefabName = "EquipBaseAttrItem"
end

---@private
function UIPetStampListView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/TextsBox/Grid
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/TextsBox/Grid").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.topItem.grid = tmp
end

---@private
function UIPetStampListView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/Equiped
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/Equiped").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equiped = tmp
end

---@private
function UIPetStampListView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/BtnChange
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/BtnChange").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChange = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetStampListView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/BtnDown
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/EquipListEquippedItem/BtnDown").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnDown = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetStampListView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/EquipBlank
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/EquipBlank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBlank = tmp
end

---@private
function UIPetStampListView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIPetStampListView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/ScrollView/Viewport/Content/EquipListItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ScrollView/Viewport/Content/EquipListItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipListItem = CommonUtil.BindGridViewItem2LuaStatic("EquipListItem", tmp)
	self.equipListItem.prefabName = "EquipListItem"

	tmp.contentSizeFitter = tmp:GetComponent(Enum.TypeInfo.ContentSizeFitter)
end

---@private
function UIPetStampListView:GenerateDestroy()
	if tolua.getpeer(self.topItem.grid) ~= nil then
		tolua.setpeer(self.topItem.grid, nil)
	end
	if tolua.getpeer(self.topItem.textName) ~= nil then
		tolua.setpeer(self.topItem.textName, nil)
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
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.topItem) ~= nil then
		tolua.setpeer(self.topItem, nil)
	end
	self.topItem = nil
	if tolua.getpeer(self.equipListEquippedItem) ~= nil then
		tolua.setpeer(self.equipListEquippedItem, nil)
	end
	self.equipListEquippedItem = nil
	if tolua.getpeer(self.contentItem) ~= nil then
		tolua.setpeer(self.contentItem, nil)
	end
	self.contentItem = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if self.equipBaseAttrItem.GenerateDestroy ~= nil then
		self.equipBaseAttrItem:GenerateDestroy()
	end
	if tolua.getpeer(self.equipBaseAttrItem) ~= nil then
		tolua.setpeer(self.equipBaseAttrItem, nil)
	end
	self.equipBaseAttrItem = nil
	if tolua.getpeer(self.equiped) ~= nil then
		tolua.setpeer(self.equiped, nil)
	end
	self.equiped = nil
	if tolua.getpeer(self.btnChange) ~= nil then
		tolua.setpeer(self.btnChange, nil)
	end
	self.btnChange = nil
	if tolua.getpeer(self.btnDown) ~= nil then
		tolua.setpeer(self.btnDown, nil)
	end
	self.btnDown = nil
	if tolua.getpeer(self.equipBlank) ~= nil then
		tolua.setpeer(self.equipBlank, nil)
	end
	self.equipBlank = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if self.equipListItem.GenerateDestroy ~= nil then
		self.equipListItem:GenerateDestroy()
	end
	if tolua.getpeer(self.equipListItem) ~= nil then
		tolua.setpeer(self.equipListItem, nil)
	end
	self.equipListItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPetStampListView