---@class EquipmentShowSlotItem__Generate_card4
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EquipmentShowSlotItem__Generate_card3
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EquipmentShowSlotItem__Generate_card2
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EquipmentShowSlotItem__Generate_card1
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EquipmentShowSlotItem__Generate_bgPlus
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EquipmentShowSlotItem__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class EquipmentShowSlotItem__Generate_position
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EquipmentShowSlotItem__Generate_tipButton
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class EquipmentShowSlotItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private tipButton EquipmentShowSlotItem__Generate_tipButton
---@field private blank UnityEngine.GameObject
---@field private position EquipmentShowSlotItem__Generate_position
---@field private iconItem EquipmentShowSlotItem__Generate_iconItem
---@field private cardPlus UnityEngine.GameObject
---@field private bgPlus EquipmentShowSlotItem__Generate_bgPlus
---@field private slot1 UnityEngine.GameObject
---@field private card1 EquipmentShowSlotItem__Generate_card1
---@field private slot2 UnityEngine.GameObject
---@field private card2 EquipmentShowSlotItem__Generate_card2
---@field private slot3 UnityEngine.GameObject
---@field private card3 EquipmentShowSlotItem__Generate_card3
---@field private slot4 UnityEngine.GameObject
---@field private card4 EquipmentShowSlotItem__Generate_card4
local EquipmentShowSlotItemView = class("EquipmentShowSlotItemView")

function EquipmentShowSlotItemView:ctor()
end

---@private
function EquipmentShowSlotItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function EquipmentShowSlotItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

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


end

---@private
function EquipmentShowSlotItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function EquipmentShowSlotItemView:InitGenerate__2(Root, data)
--[[
	bg
--]]
	local tmp = Root:Find("bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tipButton = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function EquipmentShowSlotItemView:InitGenerate__3(Root, data)
--[[
	Blank
--]]
	local tmp = Root:Find("Blank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.blank = tmp
end

---@private
function EquipmentShowSlotItemView:InitGenerate__4(Root, data)
--[[
	Blank/Position
--]]
	local tmp = Root:Find("Blank/Position").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.position = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function EquipmentShowSlotItemView:InitGenerate__5(Root, data)
--[[
	IconItem
--]]
	local tmp = Root:Find("IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function EquipmentShowSlotItemView:InitGenerate__6(Root, data)
--[[
	CardPlus
--]]
	local tmp = Root:Find("CardPlus").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardPlus = tmp
end

---@private
function EquipmentShowSlotItemView:InitGenerate__7(Root, data)
--[[
	CardPlus/BgPlus
--]]
	local tmp = Root:Find("CardPlus/BgPlus").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bgPlus = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function EquipmentShowSlotItemView:InitGenerate__8(Root, data)
--[[
	CardPlus/CardsGrid/Slot1
--]]
	local tmp = Root:Find("CardPlus/CardsGrid/Slot1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot1 = tmp
end

---@private
function EquipmentShowSlotItemView:InitGenerate__9(Root, data)
--[[
	CardPlus/CardsGrid/Slot1/Card1
--]]
	local tmp = Root:Find("CardPlus/CardsGrid/Slot1/Card1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.card1 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function EquipmentShowSlotItemView:InitGenerate__10(Root, data)
--[[
	CardPlus/CardsGrid/Slot2
--]]
	local tmp = Root:Find("CardPlus/CardsGrid/Slot2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot2 = tmp
end

---@private
function EquipmentShowSlotItemView:InitGenerate__11(Root, data)
--[[
	CardPlus/CardsGrid/Slot2/Card2
--]]
	local tmp = Root:Find("CardPlus/CardsGrid/Slot2/Card2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.card2 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function EquipmentShowSlotItemView:InitGenerate__12(Root, data)
--[[
	CardPlus/CardsGrid/Slot3
--]]
	local tmp = Root:Find("CardPlus/CardsGrid/Slot3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot3 = tmp
end

---@private
function EquipmentShowSlotItemView:InitGenerate__13(Root, data)
--[[
	CardPlus/CardsGrid/Slot3/Card3
--]]
	local tmp = Root:Find("CardPlus/CardsGrid/Slot3/Card3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.card3 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function EquipmentShowSlotItemView:InitGenerate__14(Root, data)
--[[
	CardPlus/CardsGrid/Slot4
--]]
	local tmp = Root:Find("CardPlus/CardsGrid/Slot4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot4 = tmp
end

---@private
function EquipmentShowSlotItemView:InitGenerate__15(Root, data)
--[[
	CardPlus/CardsGrid/Slot4/Card4
--]]
	local tmp = Root:Find("CardPlus/CardsGrid/Slot4/Card4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.card4 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function EquipmentShowSlotItemView:GenerateDestroy()
	if tolua.getpeer(self.tipButton) ~= nil then
		tolua.setpeer(self.tipButton, nil)
	end
	self.tipButton = nil
	if tolua.getpeer(self.blank) ~= nil then
		tolua.setpeer(self.blank, nil)
	end
	self.blank = nil
	if tolua.getpeer(self.position) ~= nil then
		tolua.setpeer(self.position, nil)
	end
	self.position = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if tolua.getpeer(self.cardPlus) ~= nil then
		tolua.setpeer(self.cardPlus, nil)
	end
	self.cardPlus = nil
	if tolua.getpeer(self.bgPlus) ~= nil then
		tolua.setpeer(self.bgPlus, nil)
	end
	self.bgPlus = nil
	if tolua.getpeer(self.slot1) ~= nil then
		tolua.setpeer(self.slot1, nil)
	end
	self.slot1 = nil
	if tolua.getpeer(self.card1) ~= nil then
		tolua.setpeer(self.card1, nil)
	end
	self.card1 = nil
	if tolua.getpeer(self.slot2) ~= nil then
		tolua.setpeer(self.slot2, nil)
	end
	self.slot2 = nil
	if tolua.getpeer(self.card2) ~= nil then
		tolua.setpeer(self.card2, nil)
	end
	self.card2 = nil
	if tolua.getpeer(self.slot3) ~= nil then
		tolua.setpeer(self.slot3, nil)
	end
	self.slot3 = nil
	if tolua.getpeer(self.card3) ~= nil then
		tolua.setpeer(self.card3, nil)
	end
	self.card3 = nil
	if tolua.getpeer(self.slot4) ~= nil then
		tolua.setpeer(self.slot4, nil)
	end
	self.slot4 = nil
	if tolua.getpeer(self.card4) ~= nil then
		tolua.setpeer(self.card4, nil)
	end
	self.card4 = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return EquipmentShowSlotItemView