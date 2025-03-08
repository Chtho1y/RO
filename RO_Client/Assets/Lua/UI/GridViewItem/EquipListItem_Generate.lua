---@class EquipListItem__Generate_btnDown
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class EquipListItem__Generate_btnChange
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class EquipListItem__Generate_itemDsc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class EquipListItem__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class EquipListItem__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class EquipListItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class EquipListItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private layoutElement UnityEngine.UI.LayoutElement
---@field private contentSizeFitter UnityEngine.UI.ContentSizeFitter
---@field private bg EquipListItem__Generate_bg
---@field private contentItem UnityEngine.GameObject
---@field private iconItem EquipListItem__Generate_iconItem
---@field private textName EquipListItem__Generate_textName
---@field private equipBaseAttrItem UnityEngine.GameObject
---@field private itemDsc EquipListItem__Generate_itemDsc
---@field private grid UnityEngine.GameObject
---@field private btnChange EquipListItem__Generate_btnChange
---@field private equiped UnityEngine.GameObject
---@field private btnDown EquipListItem__Generate_btnDown
local EquipListItemView = class("EquipListItemView")

function EquipListItemView:ctor()
end

---@private
function EquipListItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function EquipListItemView:InitGenerate(Root, data)
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


end

---@private
function EquipListItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)

	self.layoutElement = Root:GetComponent(Enum.TypeInfo.LayoutElement)

	self.contentSizeFitter = Root:GetComponent(Enum.TypeInfo.ContentSizeFitter)
end

---@private
function EquipListItemView:InitGenerate__2(Root, data)
--[[
	bg
--]]
	local tmp = Root:Find("bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function EquipListItemView:InitGenerate__3(Root, data)
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
function EquipListItemView:InitGenerate__4(Root, data)
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
function EquipListItemView:InitGenerate__5(Root, data)
--[[
	TextsBox/TextName
--]]
	local tmp = Root:Find("TextsBox/TextName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function EquipListItemView:InitGenerate__6(Root, data)
--[[
	TextsBox/EquipBaseAttrItem
--]]
	local tmp = Root:Find("TextsBox/EquipBaseAttrItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBaseAttrItem = CommonUtil.BindGridViewItem2LuaStatic("EquipBaseAttrItem", tmp)
	self.equipBaseAttrItem.prefabName = "EquipBaseAttrItem"
end

---@private
function EquipListItemView:InitGenerate__7(Root, data)
--[[
	TextsBox/ItemDsc
--]]
	local tmp = Root:Find("TextsBox/ItemDsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemDsc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function EquipListItemView:InitGenerate__8(Root, data)
--[[
	TextsBox/Grid
--]]
	local tmp = Root:Find("TextsBox/Grid").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.grid = tmp
end

---@private
function EquipListItemView:InitGenerate__9(Root, data)
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
function EquipListItemView:InitGenerate__10(Root, data)
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
function EquipListItemView:InitGenerate__11(Root, data)
--[[
	BtnDown
--]]
	local tmp = Root:Find("BtnDown").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnDown = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function EquipListItemView:GenerateDestroy()
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
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
	if self.equipBaseAttrItem.GenerateDestroy ~= nil then
		self.equipBaseAttrItem:GenerateDestroy()
	end
	if tolua.getpeer(self.equipBaseAttrItem) ~= nil then
		tolua.setpeer(self.equipBaseAttrItem, nil)
	end
	self.equipBaseAttrItem = nil
	if tolua.getpeer(self.itemDsc) ~= nil then
		tolua.setpeer(self.itemDsc, nil)
	end
	self.itemDsc = nil
	if tolua.getpeer(self.grid) ~= nil then
		tolua.setpeer(self.grid, nil)
	end
	self.grid = nil
	if tolua.getpeer(self.btnChange) ~= nil then
		tolua.setpeer(self.btnChange, nil)
	end
	self.btnChange = nil
	if tolua.getpeer(self.equiped) ~= nil then
		tolua.setpeer(self.equiped, nil)
	end
	self.equiped = nil
	if tolua.getpeer(self.btnDown) ~= nil then
		tolua.setpeer(self.btnDown, nil)
	end
	self.btnDown = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return EquipListItemView