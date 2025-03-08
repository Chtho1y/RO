---@class SupportItem__Generate_btnRemove
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class SupportItem__Generate_notice2_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class SupportItem__Generate_notice2
---@field public gameObject UnityEngine.GameObject
---@field public text SupportItem__Generate_notice2_text

---@class SupportItem__Generate_item_iconPetItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class SupportItem__Generate_item_unowned_icon
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class SupportItem__Generate_item_unowned
---@field public gameObject UnityEngine.GameObject
---@field public icon SupportItem__Generate_item_unowned_icon

---@class SupportItem__Generate_item
---@field public gameObject UnityEngine.GameObject
---@field public unowned SupportItem__Generate_item_unowned
---@field public owned UnityEngine.GameObject
---@field public iconPetItem SupportItem__Generate_item_iconPetItem

---@class SupportItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private item SupportItem__Generate_item
---@field private notice2 SupportItem__Generate_notice2
---@field private notice1 UnityEngine.GameObject
---@field private btnRemove SupportItem__Generate_btnRemove
local SupportItemView = class("SupportItemView")

function SupportItemView:ctor()
end

---@private
function SupportItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function SupportItemView:InitGenerate(Root, data)
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
function SupportItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function SupportItemView:InitGenerate__2(Root, data)
--[[
	Item
--]]
	local tmp = Root:Find("Item").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item = tmp
end

---@private
function SupportItemView:InitGenerate__3(Root, data)
--[[
	Item/Unowned
--]]
	local tmp = Root:Find("Item/Unowned").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item.unowned = tmp
end

---@private
function SupportItemView:InitGenerate__4(Root, data)
--[[
	Item/Unowned/icon
--]]
	local tmp = Root:Find("Item/Unowned/icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item.unowned.icon = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function SupportItemView:InitGenerate__5(Root, data)
--[[
	Item/Owned
--]]
	local tmp = Root:Find("Item/Owned").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item.owned = tmp
end

---@private
function SupportItemView:InitGenerate__6(Root, data)
--[[
	Item/Owned/IconPetItem
--]]
	local tmp = Root:Find("Item/Owned/IconPetItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item.iconPetItem = CommonUtil.BindGridViewItem2LuaStatic("IconPetItem", tmp)
	self.item.iconPetItem.prefabName = "IconPetItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function SupportItemView:InitGenerate__7(Root, data)
--[[
	Notice2
--]]
	local tmp = Root:Find("Notice2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.notice2 = tmp
end

---@private
function SupportItemView:InitGenerate__8(Root, data)
--[[
	Notice2/Text
--]]
	local tmp = Root:Find("Notice2/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.notice2.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function SupportItemView:InitGenerate__9(Root, data)
--[[
	Notice1
--]]
	local tmp = Root:Find("Notice1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.notice1 = tmp
end

---@private
function SupportItemView:InitGenerate__10(Root, data)
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
function SupportItemView:GenerateDestroy()
	if tolua.getpeer(self.notice2.text) ~= nil then
		tolua.setpeer(self.notice2.text, nil)
	end
	if self.item.iconPetItem.GenerateDestroy ~= nil then
		self.item.iconPetItem:GenerateDestroy()
	end
	if tolua.getpeer(self.item.iconPetItem) ~= nil then
		tolua.setpeer(self.item.iconPetItem, nil)
	end
	if tolua.getpeer(self.item.owned) ~= nil then
		tolua.setpeer(self.item.owned, nil)
	end
	if tolua.getpeer(self.item.unowned.icon) ~= nil then
		tolua.setpeer(self.item.unowned.icon, nil)
	end
	if tolua.getpeer(self.item.unowned) ~= nil then
		tolua.setpeer(self.item.unowned, nil)
	end
	if tolua.getpeer(self.item) ~= nil then
		tolua.setpeer(self.item, nil)
	end
	self.item = nil
	if tolua.getpeer(self.notice2) ~= nil then
		tolua.setpeer(self.notice2, nil)
	end
	self.notice2 = nil
	if tolua.getpeer(self.notice1) ~= nil then
		tolua.setpeer(self.notice1, nil)
	end
	self.notice1 = nil
	if tolua.getpeer(self.btnRemove) ~= nil then
		tolua.setpeer(self.btnRemove, nil)
	end
	self.btnRemove = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return SupportItemView