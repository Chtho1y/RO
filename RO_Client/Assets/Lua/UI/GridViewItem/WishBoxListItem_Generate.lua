---@class WishBoxListItem__Generate_desText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class WishBoxListItem__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class WishBoxListItem__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class WishBoxListItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private contentItem UnityEngine.GameObject
---@field private iconItem WishBoxListItem__Generate_iconItem
---@field private textName WishBoxListItem__Generate_textName
---@field private desBox UnityEngine.GameObject
---@field private desText WishBoxListItem__Generate_desText
---@field private selected UnityEngine.GameObject
local WishBoxListItemView = class("WishBoxListItemView")

function WishBoxListItemView:ctor()
end

---@private
function WishBoxListItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function WishBoxListItemView:InitGenerate(Root, data)
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


end

---@private
function WishBoxListItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function WishBoxListItemView:InitGenerate__2(Root, data)
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
function WishBoxListItemView:InitGenerate__3(Root, data)
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
function WishBoxListItemView:InitGenerate__4(Root, data)
--[[
	TextName
--]]
	local tmp = Root:Find("TextName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function WishBoxListItemView:InitGenerate__5(Root, data)
--[[
	DesBox
--]]
	local tmp = Root:Find("DesBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desBox = tmp
end

---@private
function WishBoxListItemView:InitGenerate__6(Root, data)
--[[
	DesBox/Viewport/Content/DesText
--]]
	local tmp = Root:Find("DesBox/Viewport/Content/DesText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function WishBoxListItemView:InitGenerate__7(Root, data)
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
function WishBoxListItemView:GenerateDestroy()
	if tolua.getpeer(self.desText) ~= nil then
		tolua.setpeer(self.desText, nil)
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
	if tolua.getpeer(self.desBox) ~= nil then
		tolua.setpeer(self.desBox, nil)
	end
	self.desBox = nil
	if tolua.getpeer(self.selected) ~= nil then
		tolua.setpeer(self.selected, nil)
	end
	self.selected = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return WishBoxListItemView