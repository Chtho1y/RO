---@class CostItem__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CostItem__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class CostItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private item UnityEngine.GameObject
---@field private iconItem CostItem__Generate_iconItem
---@field private text CostItem__Generate_text
local CostItemView = class("CostItemView")

function CostItemView:ctor()
end

---@private
function CostItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CostItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function CostItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function CostItemView:InitGenerate__2(Root, data)
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
function CostItemView:InitGenerate__3(Root, data)
--[[
	Item/IconItem
--]]
	local tmp = Root:Find("Item/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function CostItemView:InitGenerate__4(Root, data)
--[[
	Number/Text
--]]
	local tmp = Root:Find("Number/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function CostItemView:GenerateDestroy()
	if tolua.getpeer(self.item) ~= nil then
		tolua.setpeer(self.item, nil)
	end
	self.item = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return CostItemView