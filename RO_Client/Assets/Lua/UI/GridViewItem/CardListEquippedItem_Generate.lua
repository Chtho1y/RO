---@class CardListEquippedItem__Generate_btnRemove
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class CardListEquippedItem__Generate_attribs
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class CardListEquippedItem__Generate_blessLv
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CardListEquippedItem__Generate_cardName
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class CardListEquippedItem__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class CardListEquippedItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private contentItem UnityEngine.GameObject
---@field private iconItem CardListEquippedItem__Generate_iconItem
---@field private cardName CardListEquippedItem__Generate_cardName
---@field private cardBless UnityEngine.GameObject
---@field private blessLv CardListEquippedItem__Generate_blessLv
---@field private cardListAttrItem UnityEngine.GameObject
---@field private attribs CardListEquippedItem__Generate_attribs
---@field private equiped UnityEngine.GameObject
---@field private btnRemove CardListEquippedItem__Generate_btnRemove
local CardListEquippedItemView = class("CardListEquippedItemView")

function CardListEquippedItemView:ctor()
end

---@private
function CardListEquippedItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CardListEquippedItemView:InitGenerate(Root, data)
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


end

---@private
function CardListEquippedItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function CardListEquippedItemView:InitGenerate__2(Root, data)
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
function CardListEquippedItemView:InitGenerate__3(Root, data)
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
function CardListEquippedItemView:InitGenerate__4(Root, data)
--[[
	TextsBox/CardName
--]]
	local tmp = Root:Find("TextsBox/CardName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardName = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function CardListEquippedItemView:InitGenerate__5(Root, data)
--[[
	TextsBox/CardBless
--]]
	local tmp = Root:Find("TextsBox/CardBless").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBless = tmp
end

---@private
function CardListEquippedItemView:InitGenerate__6(Root, data)
--[[
	TextsBox/CardBless/BlessLv
--]]
	local tmp = Root:Find("TextsBox/CardBless/BlessLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.blessLv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function CardListEquippedItemView:InitGenerate__7(Root, data)
--[[
	TextsBox/CardListAttrItem
--]]
	local tmp = Root:Find("TextsBox/CardListAttrItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardListAttrItem = CommonUtil.BindGridViewItem2LuaStatic("CardListAttrItem", tmp)
	self.cardListAttrItem.prefabName = "CardListAttrItem"
end

---@private
function CardListEquippedItemView:InitGenerate__8(Root, data)
--[[
	TextsBox/Attribs
--]]
	local tmp = Root:Find("TextsBox/Attribs").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attribs = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function CardListEquippedItemView:InitGenerate__9(Root, data)
--[[
	Equiped
--]]
	local tmp = Root:Find("Equiped").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equiped = tmp
end

---@private
function CardListEquippedItemView:InitGenerate__10(Root, data)
--[[
	BtnRemove
--]]
	local tmp = Root:Find("BtnRemove").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRemove = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function CardListEquippedItemView:GenerateDestroy()
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
	if tolua.getpeer(self.cardName) ~= nil then
		tolua.setpeer(self.cardName, nil)
	end
	self.cardName = nil
	if tolua.getpeer(self.cardBless) ~= nil then
		tolua.setpeer(self.cardBless, nil)
	end
	self.cardBless = nil
	if tolua.getpeer(self.blessLv) ~= nil then
		tolua.setpeer(self.blessLv, nil)
	end
	self.blessLv = nil
	if self.cardListAttrItem.GenerateDestroy ~= nil then
		self.cardListAttrItem:GenerateDestroy()
	end
	if tolua.getpeer(self.cardListAttrItem) ~= nil then
		tolua.setpeer(self.cardListAttrItem, nil)
	end
	self.cardListAttrItem = nil
	if tolua.getpeer(self.attribs) ~= nil then
		tolua.setpeer(self.attribs, nil)
	end
	self.attribs = nil
	if tolua.getpeer(self.equiped) ~= nil then
		tolua.setpeer(self.equiped, nil)
	end
	self.equiped = nil
	if tolua.getpeer(self.btnRemove) ~= nil then
		tolua.setpeer(self.btnRemove, nil)
	end
	self.btnRemove = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return CardListEquippedItemView