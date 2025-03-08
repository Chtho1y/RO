---@class GiftListItem__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GiftListItem__Generate_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class GiftListItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private iconSmallItem GiftListItem__Generate_iconSmallItem
---@field private textName GiftListItem__Generate_textName
---@field private selected UnityEngine.GameObject
local GiftListItemView = class("GiftListItemView")

function GiftListItemView:ctor()
end

---@private
function GiftListItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function GiftListItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function GiftListItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function GiftListItemView:InitGenerate__2(Root, data)
--[[
	ContentItem/IconSmallItem
--]]
	local tmp = Root:Find("ContentItem/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function GiftListItemView:InitGenerate__3(Root, data)
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
function GiftListItemView:InitGenerate__4(Root, data)
--[[
	Selected
--]]
	local tmp = Root:Find("Selected").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selected = tmp
end

---@private
function GiftListItemView:GenerateDestroy()
	if self.iconSmallItem.GenerateDestroy ~= nil then
		self.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconSmallItem) ~= nil then
		tolua.setpeer(self.iconSmallItem, nil)
	end
	self.iconSmallItem = nil
	if tolua.getpeer(self.textName) ~= nil then
		tolua.setpeer(self.textName, nil)
	end
	self.textName = nil
	if tolua.getpeer(self.selected) ~= nil then
		tolua.setpeer(self.selected, nil)
	end
	self.selected = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return GiftListItemView