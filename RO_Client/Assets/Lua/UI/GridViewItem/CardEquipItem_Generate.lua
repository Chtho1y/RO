---@class CardEquipItem__Generate_btnChange
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class CardEquipItem__Generate_btnEquip
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class CardEquipItem__Generate_slot4_check
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardEquipItem__Generate_slot4_shadow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardEquipItem__Generate_slot4
---@field public gameObject UnityEngine.GameObject
---@field public shadow CardEquipItem__Generate_slot4_shadow
---@field public check CardEquipItem__Generate_slot4_check

---@class CardEquipItem__Generate_slot3_check
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardEquipItem__Generate_slot3_shadow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardEquipItem__Generate_slot3
---@field public gameObject UnityEngine.GameObject
---@field public shadow CardEquipItem__Generate_slot3_shadow
---@field public check CardEquipItem__Generate_slot3_check

---@class CardEquipItem__Generate_slot2_check
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardEquipItem__Generate_slot2_shadow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardEquipItem__Generate_slot2
---@field public gameObject UnityEngine.GameObject
---@field public shadow CardEquipItem__Generate_slot2_shadow
---@field public check CardEquipItem__Generate_slot2_check

---@class CardEquipItem__Generate_slot1_check
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardEquipItem__Generate_slot1_shadow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardEquipItem__Generate_slot1
---@field public gameObject UnityEngine.GameObject
---@field public shadow CardEquipItem__Generate_slot1_shadow
---@field public check CardEquipItem__Generate_slot1_check

---@class CardEquipItem__Generate_equipCards
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class CardEquipItem__Generate_belong
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CardEquipItem__Generate_jobIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardEquipItem__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CardEquipItem__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class CardEquipItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private contentItem UnityEngine.GameObject
---@field private iconItem CardEquipItem__Generate_iconItem
---@field private textName CardEquipItem__Generate_textName
---@field private jobIcon CardEquipItem__Generate_jobIcon
---@field private belong CardEquipItem__Generate_belong
---@field private equipCards CardEquipItem__Generate_equipCards
---@field private slot1 CardEquipItem__Generate_slot1
---@field private slot2 CardEquipItem__Generate_slot2
---@field private slot3 CardEquipItem__Generate_slot3
---@field private slot4 CardEquipItem__Generate_slot4
---@field private btnEquip CardEquipItem__Generate_btnEquip
---@field private btnChange CardEquipItem__Generate_btnChange
---@field private labelRecommend UnityEngine.GameObject
local CardEquipItemView = class("CardEquipItemView")

function CardEquipItemView:ctor()
end

---@private
function CardEquipItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CardEquipItemView:InitGenerate(Root, data)
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
	self:InitGenerate__22(Root,data)


end

---@private
function CardEquipItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function CardEquipItemView:InitGenerate__2(Root, data)
--[[
	ContentItem
--]]
	local tmp = Root:Find("ContentItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contentItem = tmp
end

---@private
function CardEquipItemView:InitGenerate__3(Root, data)
--[[
	ContentItem/IconItem
--]]
	local tmp = Root:Find("ContentItem/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function CardEquipItemView:InitGenerate__4(Root, data)
--[[
	Texts/TextName
--]]
	local tmp = Root:Find("Texts/TextName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function CardEquipItemView:InitGenerate__5(Root, data)
--[[
	Texts/Type1/JobIcon
--]]
	local tmp = Root:Find("Texts/Type1/JobIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.jobIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function CardEquipItemView:InitGenerate__6(Root, data)
--[[
	Texts/Type1/Belong
--]]
	local tmp = Root:Find("Texts/Type1/Belong").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.belong = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function CardEquipItemView:InitGenerate__7(Root, data)
--[[
	Texts/Type2/EquipCards
--]]
	local tmp = Root:Find("Texts/Type2/EquipCards").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipCards = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function CardEquipItemView:InitGenerate__8(Root, data)
--[[
	Texts/Type2/Cards/Slot1
--]]
	local tmp = Root:Find("Texts/Type2/Cards/Slot1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot1 = tmp
end

---@private
function CardEquipItemView:InitGenerate__9(Root, data)
--[[
	Texts/Type2/Cards/Slot1/shadow
--]]
	local tmp = Root:Find("Texts/Type2/Cards/Slot1/shadow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot1.shadow = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function CardEquipItemView:InitGenerate__10(Root, data)
--[[
	Texts/Type2/Cards/Slot1/Check
--]]
	local tmp = Root:Find("Texts/Type2/Cards/Slot1/Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot1.check = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function CardEquipItemView:InitGenerate__11(Root, data)
--[[
	Texts/Type2/Cards/Slot2
--]]
	local tmp = Root:Find("Texts/Type2/Cards/Slot2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot2 = tmp
end

---@private
function CardEquipItemView:InitGenerate__12(Root, data)
--[[
	Texts/Type2/Cards/Slot2/shadow
--]]
	local tmp = Root:Find("Texts/Type2/Cards/Slot2/shadow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot2.shadow = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function CardEquipItemView:InitGenerate__13(Root, data)
--[[
	Texts/Type2/Cards/Slot2/Check
--]]
	local tmp = Root:Find("Texts/Type2/Cards/Slot2/Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot2.check = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function CardEquipItemView:InitGenerate__14(Root, data)
--[[
	Texts/Type2/Cards/Slot3
--]]
	local tmp = Root:Find("Texts/Type2/Cards/Slot3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot3 = tmp
end

---@private
function CardEquipItemView:InitGenerate__15(Root, data)
--[[
	Texts/Type2/Cards/Slot3/shadow
--]]
	local tmp = Root:Find("Texts/Type2/Cards/Slot3/shadow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot3.shadow = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function CardEquipItemView:InitGenerate__16(Root, data)
--[[
	Texts/Type2/Cards/Slot3/Check
--]]
	local tmp = Root:Find("Texts/Type2/Cards/Slot3/Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot3.check = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function CardEquipItemView:InitGenerate__17(Root, data)
--[[
	Texts/Type2/Cards/Slot4
--]]
	local tmp = Root:Find("Texts/Type2/Cards/Slot4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot4 = tmp
end

---@private
function CardEquipItemView:InitGenerate__18(Root, data)
--[[
	Texts/Type2/Cards/Slot4/shadow
--]]
	local tmp = Root:Find("Texts/Type2/Cards/Slot4/shadow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot4.shadow = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function CardEquipItemView:InitGenerate__19(Root, data)
--[[
	Texts/Type2/Cards/Slot4/Check
--]]
	local tmp = Root:Find("Texts/Type2/Cards/Slot4/Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slot4.check = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function CardEquipItemView:InitGenerate__20(Root, data)
--[[
	BtnEquip
--]]
	local tmp = Root:Find("BtnEquip").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnEquip = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function CardEquipItemView:InitGenerate__21(Root, data)
--[[
	BtnChange
--]]
	local tmp = Root:Find("BtnChange").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChange = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function CardEquipItemView:InitGenerate__22(Root, data)
--[[
	LabelRecommend
--]]
	local tmp = Root:Find("LabelRecommend").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelRecommend = tmp
end

---@private
function CardEquipItemView:GenerateDestroy()
	if tolua.getpeer(self.slot4.check) ~= nil then
		tolua.setpeer(self.slot4.check, nil)
	end
	if tolua.getpeer(self.slot4.shadow) ~= nil then
		tolua.setpeer(self.slot4.shadow, nil)
	end
	if tolua.getpeer(self.slot3.check) ~= nil then
		tolua.setpeer(self.slot3.check, nil)
	end
	if tolua.getpeer(self.slot3.shadow) ~= nil then
		tolua.setpeer(self.slot3.shadow, nil)
	end
	if tolua.getpeer(self.slot2.check) ~= nil then
		tolua.setpeer(self.slot2.check, nil)
	end
	if tolua.getpeer(self.slot2.shadow) ~= nil then
		tolua.setpeer(self.slot2.shadow, nil)
	end
	if tolua.getpeer(self.slot1.check) ~= nil then
		tolua.setpeer(self.slot1.check, nil)
	end
	if tolua.getpeer(self.slot1.shadow) ~= nil then
		tolua.setpeer(self.slot1.shadow, nil)
	end
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
	if tolua.getpeer(self.textName) ~= nil then
		tolua.setpeer(self.textName, nil)
	end
	self.textName = nil
	if tolua.getpeer(self.jobIcon) ~= nil then
		tolua.setpeer(self.jobIcon, nil)
	end
	self.jobIcon = nil
	if tolua.getpeer(self.belong) ~= nil then
		tolua.setpeer(self.belong, nil)
	end
	self.belong = nil
	if tolua.getpeer(self.equipCards) ~= nil then
		tolua.setpeer(self.equipCards, nil)
	end
	self.equipCards = nil
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
	if tolua.getpeer(self.btnEquip) ~= nil then
		tolua.setpeer(self.btnEquip, nil)
	end
	self.btnEquip = nil
	if tolua.getpeer(self.btnChange) ~= nil then
		tolua.setpeer(self.btnChange, nil)
	end
	self.btnChange = nil
	if tolua.getpeer(self.labelRecommend) ~= nil then
		tolua.setpeer(self.labelRecommend, nil)
	end
	self.labelRecommend = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return CardEquipItemView