---@class CardItem__Generate_nameTextMVP
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class CardItem__Generate_nameTextMini
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class CardItem__Generate_nameTextNormal
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class CardItem__Generate_lvLocked
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CardItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private attrBg UnityEngine.GameObject
---@field private owned UnityEngine.GameObject
---@field private iconNormal UnityEngine.GameObject
---@field private iconMini UnityEngine.GameObject
---@field private iconMVP UnityEngine.GameObject
---@field private unowned UnityEngine.GameObject
---@field private locked UnityEngine.GameObject
---@field private noCard UnityEngine.GameObject
---@field private notice UnityEngine.GameObject
---@field private lvLocked CardItem__Generate_lvLocked
---@field private nameTextNormal CardItem__Generate_nameTextNormal
---@field private nameTextMini CardItem__Generate_nameTextMini
---@field private nameTextMVP CardItem__Generate_nameTextMVP
---@field private grid UnityEngine.GameObject
---@field private cardAttrItem UnityEngine.GameObject
local CardItemView = class("CardItemView")

function CardItemView:ctor()
end

---@private
function CardItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CardItemView:InitGenerate(Root, data)
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


end

---@private
function CardItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function CardItemView:InitGenerate__2(Root, data)
--[[
	AttrBg
--]]
	local tmp = Root:Find("AttrBg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrBg = tmp
end

---@private
function CardItemView:InitGenerate__3(Root, data)
--[[
	Info/Icon/Owned
--]]
	local tmp = Root:Find("Info/Icon/Owned").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.owned = tmp
end

---@private
function CardItemView:InitGenerate__4(Root, data)
--[[
	Info/Icon/Owned/IconNormal
--]]
	local tmp = Root:Find("Info/Icon/Owned/IconNormal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconNormal = tmp
end

---@private
function CardItemView:InitGenerate__5(Root, data)
--[[
	Info/Icon/Owned/IconMini
--]]
	local tmp = Root:Find("Info/Icon/Owned/IconMini").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconMini = tmp
end

---@private
function CardItemView:InitGenerate__6(Root, data)
--[[
	Info/Icon/Owned/IconMVP
--]]
	local tmp = Root:Find("Info/Icon/Owned/IconMVP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconMVP = tmp
end

---@private
function CardItemView:InitGenerate__7(Root, data)
--[[
	Info/Icon/Unowned
--]]
	local tmp = Root:Find("Info/Icon/Unowned").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.unowned = tmp
end

---@private
function CardItemView:InitGenerate__8(Root, data)
--[[
	Info/Icon/Locked
--]]
	local tmp = Root:Find("Info/Icon/Locked").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.locked = tmp
end

---@private
function CardItemView:InitGenerate__9(Root, data)
--[[
	Info/Name/NoCard
--]]
	local tmp = Root:Find("Info/Name/NoCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noCard = tmp
end

---@private
function CardItemView:InitGenerate__10(Root, data)
--[[
	Info/Name/NoCard/notice
--]]
	local tmp = Root:Find("Info/Name/NoCard/notice").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.notice = tmp
end

---@private
function CardItemView:InitGenerate__11(Root, data)
--[[
	Info/Name/LvLocked
--]]
	local tmp = Root:Find("Info/Name/LvLocked").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lvLocked = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function CardItemView:InitGenerate__12(Root, data)
--[[
	Info/Name/NameTextNormal
--]]
	local tmp = Root:Find("Info/Name/NameTextNormal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTextNormal = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function CardItemView:InitGenerate__13(Root, data)
--[[
	Info/Name/NameTextMini
--]]
	local tmp = Root:Find("Info/Name/NameTextMini").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTextMini = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function CardItemView:InitGenerate__14(Root, data)
--[[
	Info/Name/NameTextMVP
--]]
	local tmp = Root:Find("Info/Name/NameTextMVP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTextMVP = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function CardItemView:InitGenerate__15(Root, data)
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
function CardItemView:InitGenerate__16(Root, data)
--[[
	Grid/CardAttrItem
--]]
	local tmp = Root:Find("Grid/CardAttrItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardAttrItem = CommonUtil.BindGridViewItem2LuaStatic("CardAttrItem", tmp)
	self.cardAttrItem.prefabName = "CardAttrItem"
end

---@private
function CardItemView:GenerateDestroy()
	if tolua.getpeer(self.attrBg) ~= nil then
		tolua.setpeer(self.attrBg, nil)
	end
	self.attrBg = nil
	if tolua.getpeer(self.owned) ~= nil then
		tolua.setpeer(self.owned, nil)
	end
	self.owned = nil
	if tolua.getpeer(self.iconNormal) ~= nil then
		tolua.setpeer(self.iconNormal, nil)
	end
	self.iconNormal = nil
	if tolua.getpeer(self.iconMini) ~= nil then
		tolua.setpeer(self.iconMini, nil)
	end
	self.iconMini = nil
	if tolua.getpeer(self.iconMVP) ~= nil then
		tolua.setpeer(self.iconMVP, nil)
	end
	self.iconMVP = nil
	if tolua.getpeer(self.unowned) ~= nil then
		tolua.setpeer(self.unowned, nil)
	end
	self.unowned = nil
	if tolua.getpeer(self.locked) ~= nil then
		tolua.setpeer(self.locked, nil)
	end
	self.locked = nil
	if tolua.getpeer(self.noCard) ~= nil then
		tolua.setpeer(self.noCard, nil)
	end
	self.noCard = nil
	if tolua.getpeer(self.notice) ~= nil then
		tolua.setpeer(self.notice, nil)
	end
	self.notice = nil
	if tolua.getpeer(self.lvLocked) ~= nil then
		tolua.setpeer(self.lvLocked, nil)
	end
	self.lvLocked = nil
	if tolua.getpeer(self.nameTextNormal) ~= nil then
		tolua.setpeer(self.nameTextNormal, nil)
	end
	self.nameTextNormal = nil
	if tolua.getpeer(self.nameTextMini) ~= nil then
		tolua.setpeer(self.nameTextMini, nil)
	end
	self.nameTextMini = nil
	if tolua.getpeer(self.nameTextMVP) ~= nil then
		tolua.setpeer(self.nameTextMVP, nil)
	end
	self.nameTextMVP = nil
	if tolua.getpeer(self.grid) ~= nil then
		tolua.setpeer(self.grid, nil)
	end
	self.grid = nil
	if self.cardAttrItem.GenerateDestroy ~= nil then
		self.cardAttrItem:GenerateDestroy()
	end
	if tolua.getpeer(self.cardAttrItem) ~= nil then
		tolua.setpeer(self.cardAttrItem, nil)
	end
	self.cardAttrItem = nil
	self.inited = false
end
return CardItemView