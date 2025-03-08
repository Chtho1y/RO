---@class CardIconItem__Generate_btnRemove
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public repeatButton UnityEngine.UI.RepeatButton

---@class CardIconItem__Generate_cardName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CardIconItem__Generate_lock_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class CardIconItem__Generate_lock
---@field public gameObject UnityEngine.GameObject
---@field public text CardIconItem__Generate_lock_text

---@class CardIconItem__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class CardIconItem__Generate_add
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class CardIconItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button
---@field public repeatButton UnityEngine.UI.RepeatButton

---@class CardIconItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bg CardIconItem__Generate_bg
---@field private add CardIconItem__Generate_add
---@field private mask UnityEngine.GameObject
---@field private iconItem CardIconItem__Generate_iconItem
---@field private selected UnityEngine.GameObject
---@field private lock CardIconItem__Generate_lock
---@field private lockLabel UnityEngine.GameObject
---@field private cardName CardIconItem__Generate_cardName
---@field private selected2 UnityEngine.GameObject
---@field private btnRemove CardIconItem__Generate_btnRemove
local CardIconItemView = class("CardIconItemView")

function CardIconItemView:ctor()
end

---@private
function CardIconItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CardIconItemView:InitGenerate(Root, data)
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


end

---@private
function CardIconItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function CardIconItemView:InitGenerate__2(Root, data)
--[[
	Bg
--]]
	local tmp = Root:Find("Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)

	tmp.repeatButton = tmp:GetComponent(Enum.TypeInfo.RepeatButton)
end

---@private
function CardIconItemView:InitGenerate__3(Root, data)
--[[
	Add
--]]
	local tmp = Root:Find("Add").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.add = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function CardIconItemView:InitGenerate__4(Root, data)
--[[
	Mask
--]]
	local tmp = Root:Find("Mask").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mask = tmp
end

---@private
function CardIconItemView:InitGenerate__5(Root, data)
--[[
	IconItem
--]]
	local tmp = Root:Find("IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function CardIconItemView:InitGenerate__6(Root, data)
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
function CardIconItemView:InitGenerate__7(Root, data)
--[[
	Lock
--]]
	local tmp = Root:Find("Lock").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lock = tmp
end

---@private
function CardIconItemView:InitGenerate__8(Root, data)
--[[
	Lock/LockLabel
--]]
	local tmp = Root:Find("Lock/LockLabel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lockLabel = tmp
end

---@private
function CardIconItemView:InitGenerate__9(Root, data)
--[[
	Lock/LockLabel/Text
--]]
	local tmp = Root:Find("Lock/LockLabel/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lock.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function CardIconItemView:InitGenerate__10(Root, data)
--[[
	Name
--]]
	local tmp = Root:Find("Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function CardIconItemView:InitGenerate__11(Root, data)
--[[
	Selected2
--]]
	local tmp = Root:Find("Selected2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selected2 = tmp
end

---@private
function CardIconItemView:InitGenerate__12(Root, data)
--[[
	BtnRemove
--]]
	local tmp = Root:Find("BtnRemove").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRemove = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)

	tmp.repeatButton = tmp:GetComponent(Enum.TypeInfo.RepeatButton)
end

---@private
function CardIconItemView:GenerateDestroy()
	if tolua.getpeer(self.lock.text) ~= nil then
		tolua.setpeer(self.lock.text, nil)
	end
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.add) ~= nil then
		tolua.setpeer(self.add, nil)
	end
	self.add = nil
	if tolua.getpeer(self.mask) ~= nil then
		tolua.setpeer(self.mask, nil)
	end
	self.mask = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if tolua.getpeer(self.selected) ~= nil then
		tolua.setpeer(self.selected, nil)
	end
	self.selected = nil
	if tolua.getpeer(self.lock) ~= nil then
		tolua.setpeer(self.lock, nil)
	end
	self.lock = nil
	if tolua.getpeer(self.lockLabel) ~= nil then
		tolua.setpeer(self.lockLabel, nil)
	end
	self.lockLabel = nil
	if tolua.getpeer(self.cardName) ~= nil then
		tolua.setpeer(self.cardName, nil)
	end
	self.cardName = nil
	if tolua.getpeer(self.selected2) ~= nil then
		tolua.setpeer(self.selected2, nil)
	end
	self.selected2 = nil
	if tolua.getpeer(self.btnRemove) ~= nil then
		tolua.setpeer(self.btnRemove, nil)
	end
	self.btnRemove = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return CardIconItemView