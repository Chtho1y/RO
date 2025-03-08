---@class CardListItem__Generate_btnReplace
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class CardListItem__Generate_btnPluginCard
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class CardListItem__Generate_attribs
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class CardListItem__Generate_cardName
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class CardListItem__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class CardListItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private contentItem UnityEngine.GameObject
---@field private iconItem CardListItem__Generate_iconItem
---@field private cardName CardListItem__Generate_cardName
---@field private cardListAttrItem UnityEngine.GameObject
---@field private attribs CardListItem__Generate_attribs
---@field private btnPluginCard CardListItem__Generate_btnPluginCard
---@field private btnReplace CardListItem__Generate_btnReplace
---@field private recommend UnityEngine.GameObject
local CardListItemView = class("CardListItemView")

function CardListItemView:ctor()
end

---@private
function CardListItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CardListItemView:InitGenerate(Root, data)
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


end

---@private
function CardListItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function CardListItemView:InitGenerate__2(Root, data)
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
function CardListItemView:InitGenerate__3(Root, data)
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
function CardListItemView:InitGenerate__4(Root, data)
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
function CardListItemView:InitGenerate__5(Root, data)
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
function CardListItemView:InitGenerate__6(Root, data)
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
function CardListItemView:InitGenerate__7(Root, data)
--[[
	BtnPluginCard
--]]
	local tmp = Root:Find("BtnPluginCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPluginCard = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function CardListItemView:InitGenerate__8(Root, data)
--[[
	BtnReplace
--]]
	local tmp = Root:Find("BtnReplace").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnReplace = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function CardListItemView:InitGenerate__9(Root, data)
--[[
	Recommend
--]]
	local tmp = Root:Find("Recommend").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.recommend = tmp
end

---@private
function CardListItemView:GenerateDestroy()
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
	if tolua.getpeer(self.btnPluginCard) ~= nil then
		tolua.setpeer(self.btnPluginCard, nil)
	end
	self.btnPluginCard = nil
	if tolua.getpeer(self.btnReplace) ~= nil then
		tolua.setpeer(self.btnReplace, nil)
	end
	self.btnReplace = nil
	if tolua.getpeer(self.recommend) ~= nil then
		tolua.setpeer(self.recommend, nil)
	end
	self.recommend = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return CardListItemView