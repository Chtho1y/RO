---@class SlotItem__Generate_equipFx
---@field public gameObject UnityEngine.GameObject
---@field public uIParticle UIExtensions.UIParticle

---@class SlotItem__Generate_lv
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class SlotItem__Generate_card4
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class SlotItem__Generate_card3
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class SlotItem__Generate_card2
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class SlotItem__Generate_card1
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class SlotItem__Generate_bgPlus
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class SlotItem__Generate_button
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class SlotItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button SlotItem__Generate_button
---@field private par UnityEngine.GameObject
---@field private equipItem UnityEngine.GameObject
---@field private cardPlus UnityEngine.GameObject
---@field private bgPlus SlotItem__Generate_bgPlus
---@field private slot1 UnityEngine.GameObject
---@field private card1 SlotItem__Generate_card1
---@field private slot2 UnityEngine.GameObject
---@field private card2 SlotItem__Generate_card2
---@field private slot3 UnityEngine.GameObject
---@field private card3 SlotItem__Generate_card3
---@field private slot4 UnityEngine.GameObject
---@field private card4 SlotItem__Generate_card4
---@field private lv SlotItem__Generate_lv
---@field private equipFx SlotItem__Generate_equipFx
---@field private mask UnityEngine.GameObject
---@field private redPointItem UnityEngine.GameObject
local SlotItemView = class("SlotItemView")

function SlotItemView:ctor()
end

---@private
function SlotItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function SlotItemView:InitGenerate(Root, data)
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
	self:InitGenerate__16(Root,data)
	self:InitGenerate__17(Root,data)
	self:InitGenerate__18(Root,data)


end

---@private
function SlotItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function SlotItemView:InitGenerate__2(Root, data)
--[[
	Button
--]]
	local tmp = Root:Find("Button").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.button = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function SlotItemView:InitGenerate__3(Root, data)
--[[
	FX_UI_zhuangbei_dianji
--]]
	local tmp = Root:Find("FX_UI_zhuangbei_dianji").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.par = tmp
end

---@private
function SlotItemView:InitGenerate__4(Root, data)
--[[
	EquipItem
--]]
	local tmp = Root:Find("EquipItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipItem = CommonUtil.BindGridViewItem2LuaStatic("EquipItem", tmp)
	self.equipItem.prefabName = "EquipItem"
end

---@private
function SlotItemView:InitGenerate__5(Root, data)
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
function SlotItemView:InitGenerate__6(Root, data)
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
function SlotItemView:InitGenerate__7(Root, data)
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
function SlotItemView:InitGenerate__8(Root, data)
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
function SlotItemView:InitGenerate__9(Root, data)
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
function SlotItemView:InitGenerate__10(Root, data)
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
function SlotItemView:InitGenerate__11(Root, data)
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
function SlotItemView:InitGenerate__12(Root, data)
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
function SlotItemView:InitGenerate__13(Root, data)
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
function SlotItemView:InitGenerate__14(Root, data)
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
function SlotItemView:InitGenerate__15(Root, data)
--[[
	lv
--]]
	local tmp = Root:Find("lv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function SlotItemView:InitGenerate__16(Root, data)
--[[
	equipFx
--]]
	local tmp = Root:Find("equipFx").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipFx = tmp

	tmp.uIParticle = tmp:GetComponent(Enum.TypeInfo.UIParticle)
end

---@private
function SlotItemView:InitGenerate__17(Root, data)
--[[
	mask
--]]
	local tmp = Root:Find("mask").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mask = tmp
end

---@private
function SlotItemView:InitGenerate__18(Root, data)
--[[
	RedPointItem
--]]
	local tmp = Root:Find("RedPointItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redPointItem = CommonUtil.BindGridViewItem2LuaStatic("RedPointItem", tmp)
	self.redPointItem.prefabName = "RedPointItem"
end

---@private
function SlotItemView:GenerateDestroy()
	if tolua.getpeer(self.button) ~= nil then
		tolua.setpeer(self.button, nil)
	end
	self.button = nil
	if tolua.getpeer(self.par) ~= nil then
		tolua.setpeer(self.par, nil)
	end
	self.par = nil
	if self.equipItem.GenerateDestroy ~= nil then
		self.equipItem:GenerateDestroy()
	end
	if tolua.getpeer(self.equipItem) ~= nil then
		tolua.setpeer(self.equipItem, nil)
	end
	self.equipItem = nil
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
	if tolua.getpeer(self.lv) ~= nil then
		tolua.setpeer(self.lv, nil)
	end
	self.lv = nil
	if tolua.getpeer(self.equipFx) ~= nil then
		tolua.setpeer(self.equipFx, nil)
	end
	self.equipFx = nil
	if tolua.getpeer(self.mask) ~= nil then
		tolua.setpeer(self.mask, nil)
	end
	self.mask = nil
	if self.redPointItem.GenerateDestroy ~= nil then
		self.redPointItem:GenerateDestroy()
	end
	if tolua.getpeer(self.redPointItem) ~= nil then
		tolua.setpeer(self.redPointItem, nil)
	end
	self.redPointItem = nil
	self.inited = false
end
return SlotItemView