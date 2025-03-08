---@class EquipComposeItem__Generate_txtItemName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class EquipComposeItem__Generate_compositeNumber_txt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class EquipComposeItem__Generate_compositeNumber
---@field public gameObject UnityEngine.GameObject
---@field public txt EquipComposeItem__Generate_compositeNumber_txt

---@class EquipComposeItem__Generate_btnPlus
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class EquipComposeItem__Generate_btnMinus
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class EquipComposeItem__Generate_slider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class EquipComposeItem__Generate_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class EquipComposeItem__Generate_itemName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class EquipComposeItem__Generate_cost_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class EquipComposeItem__Generate_cost
---@field public gameObject UnityEngine.GameObject
---@field public text EquipComposeItem__Generate_cost_text

---@class EquipComposeItem__Generate_btnCompose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class EquipComposeItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private source UnityEngine.GameObject
---@field private iconItem UnityEngine.GameObject
---@field private btnCompose EquipComposeItem__Generate_btnCompose
---@field private cost EquipComposeItem__Generate_cost
---@field private itemName EquipComposeItem__Generate_itemName
---@field private equipBaseAttrItem UnityEngine.GameObject
---@field private propertyGroup UnityEngine.GameObject
---@field private maxLv UnityEngine.GameObject
---@field private bottomBox UnityEngine.GameObject
---@field private num EquipComposeItem__Generate_num
---@field private slider EquipComposeItem__Generate_slider
---@field private btnMinus EquipComposeItem__Generate_btnMinus
---@field private btnPlus EquipComposeItem__Generate_btnPlus
---@field private compositeNumber EquipComposeItem__Generate_compositeNumber
---@field private txtItemName EquipComposeItem__Generate_txtItemName
local EquipComposeItemView = class("EquipComposeItemView")

function EquipComposeItemView:ctor()
end

---@private
function EquipComposeItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function EquipComposeItemView:InitGenerate(Root, data)
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


end

---@private
function EquipComposeItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function EquipComposeItemView:InitGenerate__2(Root, data)
--[[
	TopBox/Source
--]]
	local tmp = Root:Find("TopBox/Source").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.source = tmp
end

---@private
function EquipComposeItemView:InitGenerate__3(Root, data)
--[[
	TopBox/Source/IconItem
--]]
	local tmp = Root:Find("TopBox/Source/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"
end

---@private
function EquipComposeItemView:InitGenerate__4(Root, data)
--[[
	TopBox/BtnCompose
--]]
	local tmp = Root:Find("TopBox/BtnCompose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCompose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function EquipComposeItemView:InitGenerate__5(Root, data)
--[[
	TopBox/BtnCompose/Content/Cost
--]]
	local tmp = Root:Find("TopBox/BtnCompose/Content/Cost").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cost = tmp
end

---@private
function EquipComposeItemView:InitGenerate__6(Root, data)
--[[
	TopBox/BtnCompose/Content/Cost/Text
--]]
	local tmp = Root:Find("TopBox/BtnCompose/Content/Cost/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cost.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function EquipComposeItemView:InitGenerate__7(Root, data)
--[[
	TopBox/ItemName
--]]
	local tmp = Root:Find("TopBox/ItemName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function EquipComposeItemView:InitGenerate__8(Root, data)
--[[
	EquipBaseAttrItem
--]]
	local tmp = Root:Find("EquipBaseAttrItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBaseAttrItem = CommonUtil.BindGridViewItem2LuaStatic("EquipBaseAttrItem", tmp)
	self.equipBaseAttrItem.prefabName = "EquipBaseAttrItem"
end

---@private
function EquipComposeItemView:InitGenerate__9(Root, data)
--[[
	PropertyGroup
--]]
	local tmp = Root:Find("PropertyGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.propertyGroup = tmp
end

---@private
function EquipComposeItemView:InitGenerate__10(Root, data)
--[[
	MaxLv
--]]
	local tmp = Root:Find("MaxLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.maxLv = tmp
end

---@private
function EquipComposeItemView:InitGenerate__11(Root, data)
--[[
	BottomBox
--]]
	local tmp = Root:Find("BottomBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottomBox = tmp
end

---@private
function EquipComposeItemView:InitGenerate__12(Root, data)
--[[
	BottomBox/QtyBox/num
--]]
	local tmp = Root:Find("BottomBox/QtyBox/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function EquipComposeItemView:InitGenerate__13(Root, data)
--[[
	BottomBox/QtyBox/Slider
--]]
	local tmp = Root:Find("BottomBox/QtyBox/Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function EquipComposeItemView:InitGenerate__14(Root, data)
--[[
	BottomBox/QtyBox/BtnMinus
--]]
	local tmp = Root:Find("BottomBox/QtyBox/BtnMinus").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnMinus = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function EquipComposeItemView:InitGenerate__15(Root, data)
--[[
	BottomBox/QtyBox/BtnPlus
--]]
	local tmp = Root:Find("BottomBox/QtyBox/BtnPlus").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPlus = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function EquipComposeItemView:InitGenerate__16(Root, data)
--[[
	BottomBox/CompositeNumber
--]]
	local tmp = Root:Find("BottomBox/CompositeNumber").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.compositeNumber = tmp
end

---@private
function EquipComposeItemView:InitGenerate__17(Root, data)
--[[
	BottomBox/CompositeNumber/Txt
--]]
	local tmp = Root:Find("BottomBox/CompositeNumber/Txt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.compositeNumber.txt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function EquipComposeItemView:InitGenerate__18(Root, data)
--[[
	BottomBox/CompositeTarget/TxtItemName
--]]
	local tmp = Root:Find("BottomBox/CompositeTarget/TxtItemName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.txtItemName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function EquipComposeItemView:GenerateDestroy()
	if tolua.getpeer(self.compositeNumber.txt) ~= nil then
		tolua.setpeer(self.compositeNumber.txt, nil)
	end
	if tolua.getpeer(self.cost.text) ~= nil then
		tolua.setpeer(self.cost.text, nil)
	end
	if tolua.getpeer(self.source) ~= nil then
		tolua.setpeer(self.source, nil)
	end
	self.source = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if tolua.getpeer(self.btnCompose) ~= nil then
		tolua.setpeer(self.btnCompose, nil)
	end
	self.btnCompose = nil
	if tolua.getpeer(self.cost) ~= nil then
		tolua.setpeer(self.cost, nil)
	end
	self.cost = nil
	if tolua.getpeer(self.itemName) ~= nil then
		tolua.setpeer(self.itemName, nil)
	end
	self.itemName = nil
	if self.equipBaseAttrItem.GenerateDestroy ~= nil then
		self.equipBaseAttrItem:GenerateDestroy()
	end
	if tolua.getpeer(self.equipBaseAttrItem) ~= nil then
		tolua.setpeer(self.equipBaseAttrItem, nil)
	end
	self.equipBaseAttrItem = nil
	if tolua.getpeer(self.propertyGroup) ~= nil then
		tolua.setpeer(self.propertyGroup, nil)
	end
	self.propertyGroup = nil
	if tolua.getpeer(self.maxLv) ~= nil then
		tolua.setpeer(self.maxLv, nil)
	end
	self.maxLv = nil
	if tolua.getpeer(self.bottomBox) ~= nil then
		tolua.setpeer(self.bottomBox, nil)
	end
	self.bottomBox = nil
	if tolua.getpeer(self.num) ~= nil then
		tolua.setpeer(self.num, nil)
	end
	self.num = nil
	if tolua.getpeer(self.slider) ~= nil then
		tolua.setpeer(self.slider, nil)
	end
	self.slider = nil
	if tolua.getpeer(self.btnMinus) ~= nil then
		tolua.setpeer(self.btnMinus, nil)
	end
	self.btnMinus = nil
	if tolua.getpeer(self.btnPlus) ~= nil then
		tolua.setpeer(self.btnPlus, nil)
	end
	self.btnPlus = nil
	if tolua.getpeer(self.compositeNumber) ~= nil then
		tolua.setpeer(self.compositeNumber, nil)
	end
	self.compositeNumber = nil
	if tolua.getpeer(self.txtItemName) ~= nil then
		tolua.setpeer(self.txtItemName, nil)
	end
	self.txtItemName = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return EquipComposeItemView