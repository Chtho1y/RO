---@class UICardListTips__Generate_cardScrollView_content
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UICardListTips__Generate_cardScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UICardListTips__Generate_cardScrollView_content

---@class UICardListTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICardListTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICardListTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UICardListTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UICardListTips__Generate_uIAnimator
---@field private AnyBtn UICardListTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UICardListTips__Generate_btnClose
---@field private cardListEquippedItem UnityEngine.GameObject
---@field private cardSlotBlank UnityEngine.GameObject
---@field private cardScrollView UICardListTips__Generate_cardScrollView
---@field private cardListItem UnityEngine.GameObject
---@field private dscBox UnityEngine.GameObject
local UICardListTipsView = class("UICardListTipsView", require("UIViewBase"))

function UICardListTipsView:ctor()
end

---@private
function UICardListTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UICardListTipsView:InitGenerate(Root, data)
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


end

---@private
function UICardListTipsView:InitGenerate__1(Root, data)
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
function UICardListTipsView:InitGenerate__2(Root, data)
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
function UICardListTipsView:InitGenerate__3(Root, data)
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
function UICardListTipsView:InitGenerate__4(Root, data)
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
function UICardListTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardListEquippedItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardListEquippedItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardListEquippedItem = CommonUtil.BindGridViewItem2LuaStatic("CardListEquippedItem", tmp)
	self.cardListEquippedItem.prefabName = "CardListEquippedItem"
end

---@private
function UICardListTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardSlotBlank
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardSlotBlank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardSlotBlank = tmp
end

---@private
function UICardListTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/CardScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardScrollView = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UICardListTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/CardScrollView/Viewport/CardListItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardScrollView/Viewport/CardListItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardListItem = CommonUtil.BindGridViewItem2LuaStatic("CardListItem", tmp)
	self.cardListItem.prefabName = "CardListItem"
end

---@private
function UICardListTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/CardScrollView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardScrollView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardScrollView.content = tmp

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)
end

---@private
function UICardListTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/CardScrollView/DscBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardScrollView/DscBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox = tmp
end

---@private
function UICardListTipsView:GenerateDestroy()
	if tolua.getpeer(self.cardScrollView.content) ~= nil then
		tolua.setpeer(self.cardScrollView.content, nil)
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
	if self.cardListEquippedItem.GenerateDestroy ~= nil then
		self.cardListEquippedItem:GenerateDestroy()
	end
	if tolua.getpeer(self.cardListEquippedItem) ~= nil then
		tolua.setpeer(self.cardListEquippedItem, nil)
	end
	self.cardListEquippedItem = nil
	if tolua.getpeer(self.cardSlotBlank) ~= nil then
		tolua.setpeer(self.cardSlotBlank, nil)
	end
	self.cardSlotBlank = nil
	if tolua.getpeer(self.cardScrollView) ~= nil then
		tolua.setpeer(self.cardScrollView, nil)
	end
	self.cardScrollView = nil
	if self.cardListItem.GenerateDestroy ~= nil then
		self.cardListItem:GenerateDestroy()
	end
	if tolua.getpeer(self.cardListItem) ~= nil then
		tolua.setpeer(self.cardListItem, nil)
	end
	self.cardListItem = nil
	if tolua.getpeer(self.dscBox) ~= nil then
		tolua.setpeer(self.dscBox, nil)
	end
	self.dscBox = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UICardListTipsView