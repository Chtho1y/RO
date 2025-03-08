---@class CardSlotItem__Generate_lvLocked
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CardSlotItem__Generate_nameTextMVP
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class CardSlotItem__Generate_nameTextMini
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class CardSlotItem__Generate_nameTextNormal
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class CardSlotItem__Generate_cardName
---@field public gameObject UnityEngine.GameObject
---@field public owned UnityEngine.GameObject
---@field public unowned UnityEngine.GameObject
---@field public locked UnityEngine.GameObject

---@class CardSlotItem__Generate_cardIcon_unowned_icon
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class CardSlotItem__Generate_cardIcon_unowned
---@field public gameObject UnityEngine.GameObject
---@field public icon CardSlotItem__Generate_cardIcon_unowned_icon

---@class CardSlotItem__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class CardSlotItem__Generate_cardIcon
---@field public gameObject UnityEngine.GameObject
---@field public owned UnityEngine.GameObject
---@field public unowned CardSlotItem__Generate_cardIcon_unowned
---@field public locked UnityEngine.GameObject

---@class CardSlotItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private cardIcon CardSlotItem__Generate_cardIcon
---@field private iconItem CardSlotItem__Generate_iconItem
---@field private cardName CardSlotItem__Generate_cardName
---@field private normal UnityEngine.GameObject
---@field private nameTextNormal CardSlotItem__Generate_nameTextNormal
---@field private mini UnityEngine.GameObject
---@field private nameTextMini CardSlotItem__Generate_nameTextMini
---@field private mVP UnityEngine.GameObject
---@field private nameTextMVP CardSlotItem__Generate_nameTextMVP
---@field private bg UnityEngine.GameObject
---@field private noCard UnityEngine.GameObject
---@field private lvLocked CardSlotItem__Generate_lvLocked
---@field private grid UnityEngine.GameObject
local CardSlotItemView = class("CardSlotItemView")

function CardSlotItemView:ctor()
end

---@private
function CardSlotItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CardSlotItemView:InitGenerate(Root, data)
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
function CardSlotItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function CardSlotItemView:InitGenerate__2(Root, data)
--[[
	CardIcon
--]]
	local tmp = Root:Find("CardIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardIcon = tmp
end

---@private
function CardSlotItemView:InitGenerate__3(Root, data)
--[[
	CardIcon/Owned
--]]
	local tmp = Root:Find("CardIcon/Owned").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardIcon.owned = tmp
end

---@private
function CardSlotItemView:InitGenerate__4(Root, data)
--[[
	CardIcon/Owned/IconItem
--]]
	local tmp = Root:Find("CardIcon/Owned/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function CardSlotItemView:InitGenerate__5(Root, data)
--[[
	CardIcon/Unowned
--]]
	local tmp = Root:Find("CardIcon/Unowned").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardIcon.unowned = tmp
end

---@private
function CardSlotItemView:InitGenerate__6(Root, data)
--[[
	CardIcon/Unowned/icon
--]]
	local tmp = Root:Find("CardIcon/Unowned/icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardIcon.unowned.icon = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function CardSlotItemView:InitGenerate__7(Root, data)
--[[
	CardIcon/Locked
--]]
	local tmp = Root:Find("CardIcon/Locked").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardIcon.locked = tmp
end

---@private
function CardSlotItemView:InitGenerate__8(Root, data)
--[[
	CardName
--]]
	local tmp = Root:Find("CardName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardName = tmp
end

---@private
function CardSlotItemView:InitGenerate__9(Root, data)
--[[
	CardName/Owned
--]]
	local tmp = Root:Find("CardName/Owned").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardName.owned = tmp
end

---@private
function CardSlotItemView:InitGenerate__10(Root, data)
--[[
	CardName/Owned/Normal
--]]
	local tmp = Root:Find("CardName/Owned/Normal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.normal = tmp
end

---@private
function CardSlotItemView:InitGenerate__11(Root, data)
--[[
	CardName/Owned/Normal/NameTextNormal
--]]
	local tmp = Root:Find("CardName/Owned/Normal/NameTextNormal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTextNormal = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function CardSlotItemView:InitGenerate__12(Root, data)
--[[
	CardName/Owned/Mini
--]]
	local tmp = Root:Find("CardName/Owned/Mini").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mini = tmp
end

---@private
function CardSlotItemView:InitGenerate__13(Root, data)
--[[
	CardName/Owned/Mini/NameTextMini
--]]
	local tmp = Root:Find("CardName/Owned/Mini/NameTextMini").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTextMini = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function CardSlotItemView:InitGenerate__14(Root, data)
--[[
	CardName/Owned/MVP
--]]
	local tmp = Root:Find("CardName/Owned/MVP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mVP = tmp
end

---@private
function CardSlotItemView:InitGenerate__15(Root, data)
--[[
	CardName/Owned/MVP/NameTextMVP
--]]
	local tmp = Root:Find("CardName/Owned/MVP/NameTextMVP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTextMVP = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function CardSlotItemView:InitGenerate__16(Root, data)
--[[
	CardName/Unowned
--]]
	local tmp = Root:Find("CardName/Unowned").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardName.unowned = tmp
end

---@private
function CardSlotItemView:InitGenerate__17(Root, data)
--[[
	CardName/Unowned/bg
--]]
	local tmp = Root:Find("CardName/Unowned/bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp
end

---@private
function CardSlotItemView:InitGenerate__18(Root, data)
--[[
	CardName/Unowned/NoCard
--]]
	local tmp = Root:Find("CardName/Unowned/NoCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noCard = tmp
end

---@private
function CardSlotItemView:InitGenerate__19(Root, data)
--[[
	CardName/Locked
--]]
	local tmp = Root:Find("CardName/Locked").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardName.locked = tmp
end

---@private
function CardSlotItemView:InitGenerate__20(Root, data)
--[[
	CardName/Locked/LvLocked
--]]
	local tmp = Root:Find("CardName/Locked/LvLocked").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lvLocked = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function CardSlotItemView:InitGenerate__21(Root, data)
--[[
	Grid
--]]
	local tmp = Root:Find("Grid").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.grid = tmp
end

---@private
function CardSlotItemView:GenerateDestroy()
	if tolua.getpeer(self.cardName.locked) ~= nil then
		tolua.setpeer(self.cardName.locked, nil)
	end
	if tolua.getpeer(self.cardName.unowned) ~= nil then
		tolua.setpeer(self.cardName.unowned, nil)
	end
	if tolua.getpeer(self.cardName.owned) ~= nil then
		tolua.setpeer(self.cardName.owned, nil)
	end
	if tolua.getpeer(self.cardIcon.locked) ~= nil then
		tolua.setpeer(self.cardIcon.locked, nil)
	end
	if tolua.getpeer(self.cardIcon.unowned.icon) ~= nil then
		tolua.setpeer(self.cardIcon.unowned.icon, nil)
	end
	if tolua.getpeer(self.cardIcon.unowned) ~= nil then
		tolua.setpeer(self.cardIcon.unowned, nil)
	end
	if tolua.getpeer(self.cardIcon.owned) ~= nil then
		tolua.setpeer(self.cardIcon.owned, nil)
	end
	if tolua.getpeer(self.cardIcon) ~= nil then
		tolua.setpeer(self.cardIcon, nil)
	end
	self.cardIcon = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if tolua.getpeer(self.cardName) ~= nil then
		tolua.setpeer(self.cardName, nil)
	end
	self.cardName = nil
	if tolua.getpeer(self.normal) ~= nil then
		tolua.setpeer(self.normal, nil)
	end
	self.normal = nil
	if tolua.getpeer(self.nameTextNormal) ~= nil then
		tolua.setpeer(self.nameTextNormal, nil)
	end
	self.nameTextNormal = nil
	if tolua.getpeer(self.mini) ~= nil then
		tolua.setpeer(self.mini, nil)
	end
	self.mini = nil
	if tolua.getpeer(self.nameTextMini) ~= nil then
		tolua.setpeer(self.nameTextMini, nil)
	end
	self.nameTextMini = nil
	if tolua.getpeer(self.mVP) ~= nil then
		tolua.setpeer(self.mVP, nil)
	end
	self.mVP = nil
	if tolua.getpeer(self.nameTextMVP) ~= nil then
		tolua.setpeer(self.nameTextMVP, nil)
	end
	self.nameTextMVP = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.noCard) ~= nil then
		tolua.setpeer(self.noCard, nil)
	end
	self.noCard = nil
	if tolua.getpeer(self.lvLocked) ~= nil then
		tolua.setpeer(self.lvLocked, nil)
	end
	self.lvLocked = nil
	if tolua.getpeer(self.grid) ~= nil then
		tolua.setpeer(self.grid, nil)
	end
	self.grid = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return CardSlotItemView