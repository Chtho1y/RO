---@class EuipSlotItem__Generate_equipFx
---@field public gameObject UnityEngine.GameObject
---@field public uIParticle UIExtensions.UIParticle

---@class EuipSlotItem__Generate_card4
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EuipSlotItem__Generate_card3
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EuipSlotItem__Generate_card2
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EuipSlotItem__Generate_card1
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EuipSlotItem__Generate_bgPlus
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EuipSlotItem__Generate_textLv
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class EuipSlotItem__Generate_level
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EuipSlotItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EuipSlotItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EuipSlotItem__Generate_position
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EuipSlotItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private blank UnityEngine.GameObject
---@field private position EuipSlotItem__Generate_position
---@field private icon EuipSlotItem__Generate_icon
---@field private frame EuipSlotItem__Generate_frame
---@field private level EuipSlotItem__Generate_level
---@field private textLv EuipSlotItem__Generate_textLv
---@field private par UnityEngine.GameObject
---@field private cardPlus UnityEngine.GameObject
---@field private bgPlus EuipSlotItem__Generate_bgPlus
---@field private slot1 UnityEngine.GameObject
---@field private card1 EuipSlotItem__Generate_card1
---@field private slot2 UnityEngine.GameObject
---@field private card2 EuipSlotItem__Generate_card2
---@field private slot3 UnityEngine.GameObject
---@field private card3 EuipSlotItem__Generate_card3
---@field private slot4 UnityEngine.GameObject
---@field private card4 EuipSlotItem__Generate_card4
---@field private equipFx EuipSlotItem__Generate_equipFx
---@field private mask UnityEngine.GameObject
---@field private redPointItem UnityEngine.GameObject
local EuipSlotItemView = class("EuipSlotItemView")

function EuipSlotItemView:ctor()
end

---@private
function EuipSlotItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function EuipSlotItemView:InitGenerate(Root, data)
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
	self:InitGenerate__19(Root,data)
	self:InitGenerate__20(Root,data)
	self:InitGenerate__21(Root,data)


end

---@private
function EuipSlotItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function EuipSlotItemView:InitGenerate__2(Root, data)
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
function EuipSlotItemView:InitGenerate__3(Root, data)
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
function EuipSlotItemView:InitGenerate__4(Root, data)
--[[
	Icon
--]]
	local tmp = Root:Find("Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function EuipSlotItemView:InitGenerate__5(Root, data)
--[[
	Frame
--]]
	local tmp = Root:Find("Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frame = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function EuipSlotItemView:InitGenerate__6(Root, data)
--[[
	Level
--]]
	local tmp = Root:Find("Level").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.level = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function EuipSlotItemView:InitGenerate__7(Root, data)
--[[
	TextLv
--]]
	local tmp = Root:Find("TextLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textLv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function EuipSlotItemView:InitGenerate__8(Root, data)
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
function EuipSlotItemView:InitGenerate__9(Root, data)
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
function EuipSlotItemView:InitGenerate__10(Root, data)
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
function EuipSlotItemView:InitGenerate__11(Root, data)
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
function EuipSlotItemView:InitGenerate__12(Root, data)
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
function EuipSlotItemView:InitGenerate__13(Root, data)
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
function EuipSlotItemView:InitGenerate__14(Root, data)
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
function EuipSlotItemView:InitGenerate__15(Root, data)
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
function EuipSlotItemView:InitGenerate__16(Root, data)
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
function EuipSlotItemView:InitGenerate__17(Root, data)
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
function EuipSlotItemView:InitGenerate__18(Root, data)
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
function EuipSlotItemView:InitGenerate__19(Root, data)
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
function EuipSlotItemView:InitGenerate__20(Root, data)
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
function EuipSlotItemView:InitGenerate__21(Root, data)
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
function EuipSlotItemView:GenerateDestroy()
	if tolua.getpeer(self.blank) ~= nil then
		tolua.setpeer(self.blank, nil)
	end
	self.blank = nil
	if tolua.getpeer(self.position) ~= nil then
		tolua.setpeer(self.position, nil)
	end
	self.position = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	self.frame = nil
	if tolua.getpeer(self.level) ~= nil then
		tolua.setpeer(self.level, nil)
	end
	self.level = nil
	if tolua.getpeer(self.textLv) ~= nil then
		tolua.setpeer(self.textLv, nil)
	end
	self.textLv = nil
	if tolua.getpeer(self.par) ~= nil then
		tolua.setpeer(self.par, nil)
	end
	self.par = nil
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
return EuipSlotItemView