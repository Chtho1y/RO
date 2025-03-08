---@class ShopGoodsItem__Generate_presentPrice_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ShopGoodsItem__Generate_presentPrice_number
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class ShopGoodsItem__Generate_presentPrice_shadow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ShopGoodsItem__Generate_presentPrice
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public shadow ShopGoodsItem__Generate_presentPrice_shadow
---@field public number ShopGoodsItem__Generate_presentPrice_number
---@field public icon ShopGoodsItem__Generate_presentPrice_icon

---@class ShopGoodsItem__Generate_discount_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class ShopGoodsItem__Generate_discount
---@field public gameObject UnityEngine.GameObject
---@field public text ShopGoodsItem__Generate_discount_text

---@class ShopGoodsItem__Generate_originalPrice_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ShopGoodsItem__Generate_originalPrice_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ShopGoodsItem__Generate_originalPrice
---@field public gameObject UnityEngine.GameObject
---@field public icon ShopGoodsItem__Generate_originalPrice_icon
---@field public number ShopGoodsItem__Generate_originalPrice_number

---@class ShopGoodsItem__Generate_purchaseLimit
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ShopGoodsItem__Generate_timeLimit
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ShopGoodsItem__Generate_itemName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ShopGoodsItem__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class ShopGoodsItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private iconItem ShopGoodsItem__Generate_iconItem
---@field private itemName ShopGoodsItem__Generate_itemName
---@field private limitBox UnityEngine.GameObject
---@field private timeLimit ShopGoodsItem__Generate_timeLimit
---@field private purchaseLimit ShopGoodsItem__Generate_purchaseLimit
---@field private originalPrice ShopGoodsItem__Generate_originalPrice
---@field private discount ShopGoodsItem__Generate_discount
---@field private label UnityEngine.GameObject
---@field private presentPrice ShopGoodsItem__Generate_presentPrice
---@field private soldout UnityEngine.GameObject
local ShopGoodsItemView = class("ShopGoodsItemView")

function ShopGoodsItemView:ctor()
end

---@private
function ShopGoodsItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ShopGoodsItemView:InitGenerate(Root, data)
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


end

---@private
function ShopGoodsItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ShopGoodsItemView:InitGenerate__2(Root, data)
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
function ShopGoodsItemView:InitGenerate__3(Root, data)
--[[
	GoodsName/ItemName
--]]
	local tmp = Root:Find("GoodsName/ItemName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ShopGoodsItemView:InitGenerate__4(Root, data)
--[[
	LimitBox
--]]
	local tmp = Root:Find("LimitBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.limitBox = tmp
end

---@private
function ShopGoodsItemView:InitGenerate__5(Root, data)
--[[
	LimitBox/TimeLimit
--]]
	local tmp = Root:Find("LimitBox/TimeLimit").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timeLimit = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ShopGoodsItemView:InitGenerate__6(Root, data)
--[[
	MoreDsc/PurchaseLimit
--]]
	local tmp = Root:Find("MoreDsc/PurchaseLimit").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.purchaseLimit = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ShopGoodsItemView:InitGenerate__7(Root, data)
--[[
	MoreDsc/OriginalPrice
--]]
	local tmp = Root:Find("MoreDsc/OriginalPrice").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.originalPrice = tmp
end

---@private
function ShopGoodsItemView:InitGenerate__8(Root, data)
--[[
	MoreDsc/OriginalPrice/Icon
--]]
	local tmp = Root:Find("MoreDsc/OriginalPrice/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.originalPrice.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ShopGoodsItemView:InitGenerate__9(Root, data)
--[[
	MoreDsc/OriginalPrice/Number
--]]
	local tmp = Root:Find("MoreDsc/OriginalPrice/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.originalPrice.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ShopGoodsItemView:InitGenerate__10(Root, data)
--[[
	Discount
--]]
	local tmp = Root:Find("Discount").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.discount = tmp
end

---@private
function ShopGoodsItemView:InitGenerate__11(Root, data)
--[[
	Discount/Label
--]]
	local tmp = Root:Find("Discount/Label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.label = tmp
end

---@private
function ShopGoodsItemView:InitGenerate__12(Root, data)
--[[
	Discount/Text
--]]
	local tmp = Root:Find("Discount/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.discount.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function ShopGoodsItemView:InitGenerate__13(Root, data)
--[[
	PresentPrice
--]]
	local tmp = Root:Find("PresentPrice").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ShopGoodsItemView:InitGenerate__14(Root, data)
--[[
	PresentPrice/shadow
--]]
	local tmp = Root:Find("PresentPrice/shadow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice.shadow = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ShopGoodsItemView:InitGenerate__15(Root, data)
--[[
	PresentPrice/Number
--]]
	local tmp = Root:Find("PresentPrice/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function ShopGoodsItemView:InitGenerate__16(Root, data)
--[[
	PresentPrice/Icon
--]]
	local tmp = Root:Find("PresentPrice/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ShopGoodsItemView:InitGenerate__17(Root, data)
--[[
	Soldout
--]]
	local tmp = Root:Find("Soldout").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.soldout = tmp
end

---@private
function ShopGoodsItemView:GenerateDestroy()
	if tolua.getpeer(self.presentPrice.icon) ~= nil then
		tolua.setpeer(self.presentPrice.icon, nil)
	end
	if tolua.getpeer(self.presentPrice.number) ~= nil then
		tolua.setpeer(self.presentPrice.number, nil)
	end
	if tolua.getpeer(self.presentPrice.shadow) ~= nil then
		tolua.setpeer(self.presentPrice.shadow, nil)
	end
	if tolua.getpeer(self.discount.text) ~= nil then
		tolua.setpeer(self.discount.text, nil)
	end
	if tolua.getpeer(self.originalPrice.number) ~= nil then
		tolua.setpeer(self.originalPrice.number, nil)
	end
	if tolua.getpeer(self.originalPrice.icon) ~= nil then
		tolua.setpeer(self.originalPrice.icon, nil)
	end
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if tolua.getpeer(self.itemName) ~= nil then
		tolua.setpeer(self.itemName, nil)
	end
	self.itemName = nil
	if tolua.getpeer(self.limitBox) ~= nil then
		tolua.setpeer(self.limitBox, nil)
	end
	self.limitBox = nil
	if tolua.getpeer(self.timeLimit) ~= nil then
		tolua.setpeer(self.timeLimit, nil)
	end
	self.timeLimit = nil
	if tolua.getpeer(self.purchaseLimit) ~= nil then
		tolua.setpeer(self.purchaseLimit, nil)
	end
	self.purchaseLimit = nil
	if tolua.getpeer(self.originalPrice) ~= nil then
		tolua.setpeer(self.originalPrice, nil)
	end
	self.originalPrice = nil
	if tolua.getpeer(self.discount) ~= nil then
		tolua.setpeer(self.discount, nil)
	end
	self.discount = nil
	if tolua.getpeer(self.label) ~= nil then
		tolua.setpeer(self.label, nil)
	end
	self.label = nil
	if tolua.getpeer(self.presentPrice) ~= nil then
		tolua.setpeer(self.presentPrice, nil)
	end
	self.presentPrice = nil
	if tolua.getpeer(self.soldout) ~= nil then
		tolua.setpeer(self.soldout, nil)
	end
	self.soldout = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return ShopGoodsItemView