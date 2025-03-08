---@class UICardTips__Generate_cardScrollView_content
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UICardTips__Generate_cardScrollView
---@field public gameObject UnityEngine.GameObject
---@field public content UICardTips__Generate_cardScrollView_content

---@class UICardTips__Generate_btnOneKeyRemove
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICardTips__Generate_slot4
---@field public gameObject UnityEngine.GameObject
---@field public slotPurpleCard UnityEngine.GameObject
---@field public slotBlueCard UnityEngine.GameObject
---@field public slotGoldCard UnityEngine.GameObject

---@class UICardTips__Generate_slot3
---@field public gameObject UnityEngine.GameObject
---@field public slotPurpleCard UnityEngine.GameObject
---@field public slotBlueCard UnityEngine.GameObject
---@field public slotGoldCard UnityEngine.GameObject

---@class UICardTips__Generate_slot2
---@field public gameObject UnityEngine.GameObject
---@field public slotPurpleCard UnityEngine.GameObject
---@field public slotBlueCard UnityEngine.GameObject
---@field public slotGoldCard UnityEngine.GameObject

---@class UICardTips__Generate_slot1
---@field public gameObject UnityEngine.GameObject
---@field public slotPurpleCard UnityEngine.GameObject
---@field public slotBlueCard UnityEngine.GameObject
---@field public slotGoldCard UnityEngine.GameObject

---@class UICardTips__Generate_textType
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UICardTips__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UICardTips__Generate_topItem_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UICardTips__Generate_topItem
---@field public gameObject UnityEngine.GameObject
---@field public iconItem UICardTips__Generate_topItem_iconItem

---@class UICardTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICardTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICardTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UICardTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UICardTips__Generate_uIAnimator
---@field private AnyBtn UICardTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private closeBox UnityEngine.GameObject
---@field private btnClose UICardTips__Generate_btnClose
---@field private topItem UICardTips__Generate_topItem
---@field private contentItem UnityEngine.GameObject
---@field private textName UICardTips__Generate_textName
---@field private textType UICardTips__Generate_textType
---@field private cardsBox UnityEngine.GameObject
---@field private cardSlots UnityEngine.GameObject
---@field private slot1 UICardTips__Generate_slot1
---@field private slot2 UICardTips__Generate_slot2
---@field private slot3 UICardTips__Generate_slot3
---@field private slot4 UICardTips__Generate_slot4
---@field private btnOneKeyRemove UICardTips__Generate_btnOneKeyRemove
---@field private cardScrollView UICardTips__Generate_cardScrollView
---@field private cardslotItem1 UnityEngine.GameObject
---@field private cardslotItem2 UnityEngine.GameObject
---@field private cardslotItem3 UnityEngine.GameObject
---@field private cardslotItem4 UnityEngine.GameObject
local UICardTipsView = class("UICardTipsView", require("UIViewBase"))

function UICardTipsView:ctor()
end

---@private
function UICardTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UICardTipsView:InitGenerate(Root, data)
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
	self:InitGenerate__19(Root,data)
	self:InitGenerate__20(Root,data)
	self:InitGenerate__21(Root,data)
	self:InitGenerate__22(Root,data)
	self:InitGenerate__23(Root,data)
	self:InitGenerate__24(Root,data)
	self:InitGenerate__25(Root,data)
	self:InitGenerate__26(Root,data)
	self:InitGenerate__27(Root,data)
	self:InitGenerate__28(Root,data)
	self:InitGenerate__29(Root,data)
	self:InitGenerate__30(Root,data)
	self:InitGenerate__31(Root,data)
	self:InitGenerate__32(Root,data)
	self:InitGenerate__33(Root,data)
	self:InitGenerate__34(Root,data)
	self:InitGenerate__35(Root,data)


end

---@private
function UICardTipsView:InitGenerate__1(Root, data)
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
function UICardTipsView:InitGenerate__2(Root, data)
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
function UICardTipsView:InitGenerate__3(Root, data)
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
function UICardTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBox = tmp
end

---@private
function UICardTipsView:InitGenerate__5(Root, data)
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
function UICardTipsView:InitGenerate__6(Root, data)
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
function UICardTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/ContentItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/ContentItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contentItem = tmp
end

---@private
function UICardTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/ContentItem/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/ContentItem/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.topItem.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.topItem.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UICardTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/TextName
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/TextName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UICardTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/TypeBox/TextType
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/TypeBox/TextType").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textType = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UICardTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardsBox = tmp
end

---@private
function UICardTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardSlots = tmp
end

---@private
function UICardTipsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot1 = tmp
end

---@private
function UICardTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot1/SlotPurpleCard
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot1/SlotPurpleCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot1.slotPurpleCard = tmp
end

---@private
function UICardTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot1/SlotBlueCard
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot1/SlotBlueCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot1.slotBlueCard = tmp
end

---@private
function UICardTipsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot1/SlotGoldCard
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot1/SlotGoldCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot1.slotGoldCard = tmp
end

---@private
function UICardTipsView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot2 = tmp
end

---@private
function UICardTipsView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot2/SlotPurpleCard
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot2/SlotPurpleCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot2.slotPurpleCard = tmp
end

---@private
function UICardTipsView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot2/SlotBlueCard
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot2/SlotBlueCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot2.slotBlueCard = tmp
end

---@private
function UICardTipsView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot2/SlotGoldCard
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot2/SlotGoldCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot2.slotGoldCard = tmp
end

---@private
function UICardTipsView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot3 = tmp
end

---@private
function UICardTipsView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot3/SlotPurpleCard
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot3/SlotPurpleCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot3.slotPurpleCard = tmp
end

---@private
function UICardTipsView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot3/SlotBlueCard
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot3/SlotBlueCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot3.slotBlueCard = tmp
end

---@private
function UICardTipsView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot3/SlotGoldCard
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot3/SlotGoldCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot3.slotGoldCard = tmp
end

---@private
function UICardTipsView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot4 = tmp
end

---@private
function UICardTipsView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot4/SlotPurpleCard
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot4/SlotPurpleCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot4.slotPurpleCard = tmp
end

---@private
function UICardTipsView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot4/SlotBlueCard
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot4/SlotBlueCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot4.slotBlueCard = tmp
end

---@private
function UICardTipsView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot4/SlotGoldCard
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/CardsBox/CardSlots/Slot4/SlotGoldCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot4.slotGoldCard = tmp
end

---@private
function UICardTipsView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/BtnOneKeyRemove
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/BtnOneKeyRemove").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnOneKeyRemove = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICardTipsView:InitGenerate__30(Root, data)
--[[
	UIAnimator/Window/Bg/CardScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardScrollView = tmp
end

---@private
function UICardTipsView:InitGenerate__31(Root, data)
--[[
	UIAnimator/Window/Bg/CardScrollView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardScrollView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardScrollView.content = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)
end

---@private
function UICardTipsView:InitGenerate__32(Root, data)
--[[
	UIAnimator/Window/Bg/CardScrollView/Viewport/Content/CardSlotItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardScrollView/Viewport/Content/CardSlotItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardslotItem1 = CommonUtil.BindGridViewItem2LuaStatic("CardSlotItem", tmp)
	self.cardslotItem1.prefabName = "CardSlotItem"
end

---@private
function UICardTipsView:InitGenerate__33(Root, data)
--[[
	UIAnimator/Window/Bg/CardScrollView/Viewport/Content/CardSlotItem1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardScrollView/Viewport/Content/CardSlotItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardslotItem2 = CommonUtil.BindGridViewItem2LuaStatic("CardSlotItem", tmp)
	self.cardslotItem2.prefabName = "CardSlotItem"
end

---@private
function UICardTipsView:InitGenerate__34(Root, data)
--[[
	UIAnimator/Window/Bg/CardScrollView/Viewport/Content/CardSlotItem2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardScrollView/Viewport/Content/CardSlotItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardslotItem3 = CommonUtil.BindGridViewItem2LuaStatic("CardSlotItem", tmp)
	self.cardslotItem3.prefabName = "CardSlotItem"
end

---@private
function UICardTipsView:InitGenerate__35(Root, data)
--[[
	UIAnimator/Window/Bg/CardScrollView/Viewport/Content/CardSlotItem3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CardScrollView/Viewport/Content/CardSlotItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardslotItem4 = CommonUtil.BindGridViewItem2LuaStatic("CardSlotItem", tmp)
	self.cardslotItem4.prefabName = "CardSlotItem"
end

---@private
function UICardTipsView:GenerateDestroy()
	if tolua.getpeer(self.cardScrollView.content) ~= nil then
		tolua.setpeer(self.cardScrollView.content, nil)
	end
	if tolua.getpeer(self.slot4.slotGoldCard) ~= nil then
		tolua.setpeer(self.slot4.slotGoldCard, nil)
	end
	if tolua.getpeer(self.slot4.slotBlueCard) ~= nil then
		tolua.setpeer(self.slot4.slotBlueCard, nil)
	end
	if tolua.getpeer(self.slot4.slotPurpleCard) ~= nil then
		tolua.setpeer(self.slot4.slotPurpleCard, nil)
	end
	if tolua.getpeer(self.slot3.slotGoldCard) ~= nil then
		tolua.setpeer(self.slot3.slotGoldCard, nil)
	end
	if tolua.getpeer(self.slot3.slotBlueCard) ~= nil then
		tolua.setpeer(self.slot3.slotBlueCard, nil)
	end
	if tolua.getpeer(self.slot3.slotPurpleCard) ~= nil then
		tolua.setpeer(self.slot3.slotPurpleCard, nil)
	end
	if tolua.getpeer(self.slot2.slotGoldCard) ~= nil then
		tolua.setpeer(self.slot2.slotGoldCard, nil)
	end
	if tolua.getpeer(self.slot2.slotBlueCard) ~= nil then
		tolua.setpeer(self.slot2.slotBlueCard, nil)
	end
	if tolua.getpeer(self.slot2.slotPurpleCard) ~= nil then
		tolua.setpeer(self.slot2.slotPurpleCard, nil)
	end
	if tolua.getpeer(self.slot1.slotGoldCard) ~= nil then
		tolua.setpeer(self.slot1.slotGoldCard, nil)
	end
	if tolua.getpeer(self.slot1.slotBlueCard) ~= nil then
		tolua.setpeer(self.slot1.slotBlueCard, nil)
	end
	if tolua.getpeer(self.slot1.slotPurpleCard) ~= nil then
		tolua.setpeer(self.slot1.slotPurpleCard, nil)
	end
	if self.topItem.iconItem.GenerateDestroy ~= nil then
		self.topItem.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.topItem.iconItem) ~= nil then
		tolua.setpeer(self.topItem.iconItem, nil)
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
	if tolua.getpeer(self.closeBox) ~= nil then
		tolua.setpeer(self.closeBox, nil)
	end
	self.closeBox = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.topItem) ~= nil then
		tolua.setpeer(self.topItem, nil)
	end
	self.topItem = nil
	if tolua.getpeer(self.contentItem) ~= nil then
		tolua.setpeer(self.contentItem, nil)
	end
	self.contentItem = nil
	if tolua.getpeer(self.textName) ~= nil then
		tolua.setpeer(self.textName, nil)
	end
	self.textName = nil
	if tolua.getpeer(self.textType) ~= nil then
		tolua.setpeer(self.textType, nil)
	end
	self.textType = nil
	if tolua.getpeer(self.cardsBox) ~= nil then
		tolua.setpeer(self.cardsBox, nil)
	end
	self.cardsBox = nil
	if tolua.getpeer(self.cardSlots) ~= nil then
		tolua.setpeer(self.cardSlots, nil)
	end
	self.cardSlots = nil
	if tolua.getpeer(self.slot1) ~= nil then
		tolua.setpeer(self.slot1, nil)
	end
	self.slot1 = nil
	if tolua.getpeer(self.slot2) ~= nil then
		tolua.setpeer(self.slot2, nil)
	end
	self.slot2 = nil
	if tolua.getpeer(self.slot3) ~= nil then
		tolua.setpeer(self.slot3, nil)
	end
	self.slot3 = nil
	if tolua.getpeer(self.slot4) ~= nil then
		tolua.setpeer(self.slot4, nil)
	end
	self.slot4 = nil
	if tolua.getpeer(self.btnOneKeyRemove) ~= nil then
		tolua.setpeer(self.btnOneKeyRemove, nil)
	end
	self.btnOneKeyRemove = nil
	if tolua.getpeer(self.cardScrollView) ~= nil then
		tolua.setpeer(self.cardScrollView, nil)
	end
	self.cardScrollView = nil
	if self.cardslotItem1.GenerateDestroy ~= nil then
		self.cardslotItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.cardslotItem1) ~= nil then
		tolua.setpeer(self.cardslotItem1, nil)
	end
	self.cardslotItem1 = nil
	if self.cardslotItem2.GenerateDestroy ~= nil then
		self.cardslotItem2:GenerateDestroy()
	end
	if tolua.getpeer(self.cardslotItem2) ~= nil then
		tolua.setpeer(self.cardslotItem2, nil)
	end
	self.cardslotItem2 = nil
	if self.cardslotItem3.GenerateDestroy ~= nil then
		self.cardslotItem3:GenerateDestroy()
	end
	if tolua.getpeer(self.cardslotItem3) ~= nil then
		tolua.setpeer(self.cardslotItem3, nil)
	end
	self.cardslotItem3 = nil
	if self.cardslotItem4.GenerateDestroy ~= nil then
		self.cardslotItem4:GenerateDestroy()
	end
	if tolua.getpeer(self.cardslotItem4) ~= nil then
		tolua.setpeer(self.cardslotItem4, nil)
	end
	self.cardslotItem4 = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UICardTipsView