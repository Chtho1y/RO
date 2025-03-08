---@class RuneShopGoodsItem__Generate_presentPrice_currency
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class RuneShopGoodsItem__Generate_presentPrice_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RuneShopGoodsItem__Generate_presentPrice_number
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class RuneShopGoodsItem__Generate_presentPrice_shadow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RuneShopGoodsItem__Generate_presentPrice
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public shadow RuneShopGoodsItem__Generate_presentPrice_shadow
---@field public number RuneShopGoodsItem__Generate_presentPrice_number
---@field public icon RuneShopGoodsItem__Generate_presentPrice_icon
---@field public currency RuneShopGoodsItem__Generate_presentPrice_currency

---@class RuneShopGoodsItem__Generate_discount_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI
---@field public uILocalizeScript UILocalizeScript

---@class RuneShopGoodsItem__Generate_discount
---@field public gameObject UnityEngine.GameObject
---@field public text RuneShopGoodsItem__Generate_discount_text

---@class RuneShopGoodsItem__Generate_purchaseLimit
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RuneShopGoodsItem__Generate_specialReward_num
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RuneShopGoodsItem__Generate_specialReward_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RuneShopGoodsItem__Generate_specialReward
---@field public gameObject UnityEngine.GameObject
---@field public bg RuneShopGoodsItem__Generate_specialReward_bg
---@field public num RuneShopGoodsItem__Generate_specialReward_num

---@class RuneShopGoodsItem__Generate_iconSmallItem3
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RuneShopGoodsItem__Generate_iconSmallItem2
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RuneShopGoodsItem__Generate_iconSmallItem1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RuneShopGoodsItem__Generate_itemName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RuneShopGoodsItem__Generate_itemIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RuneShopGoodsItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private itemIcon RuneShopGoodsItem__Generate_itemIcon
---@field private itemName RuneShopGoodsItem__Generate_itemName
---@field private goodsItems UnityEngine.GameObject
---@field private iconSmallItem1 RuneShopGoodsItem__Generate_iconSmallItem1
---@field private iconSmallItem2 RuneShopGoodsItem__Generate_iconSmallItem2
---@field private iconSmallItem3 RuneShopGoodsItem__Generate_iconSmallItem3
---@field private specialReward RuneShopGoodsItem__Generate_specialReward
---@field private purchaseLimit RuneShopGoodsItem__Generate_purchaseLimit
---@field private discount RuneShopGoodsItem__Generate_discount
---@field private label UnityEngine.GameObject
---@field private presentPrice RuneShopGoodsItem__Generate_presentPrice
---@field private soldout UnityEngine.GameObject
local RuneShopGoodsItemView = class("RuneShopGoodsItemView")

function RuneShopGoodsItemView:ctor()
end

---@private
function RuneShopGoodsItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RuneShopGoodsItemView:InitGenerate(Root, data)
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
	self:InitGenerate__19(Root,data)
	self:InitGenerate__20(Root,data)


end

---@private
function RuneShopGoodsItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function RuneShopGoodsItemView:InitGenerate__2(Root, data)
--[[
	ItemIcon
--]]
	local tmp = Root:Find("ItemIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RuneShopGoodsItemView:InitGenerate__3(Root, data)
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
function RuneShopGoodsItemView:InitGenerate__4(Root, data)
--[[
	MoreDsc/GoodsItems
--]]
	local tmp = Root:Find("MoreDsc/GoodsItems").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.goodsItems = tmp
end

---@private
function RuneShopGoodsItemView:InitGenerate__5(Root, data)
--[[
	MoreDsc/GoodsItems/LayoutScale/IconSmallItem1
--]]
	local tmp = Root:Find("MoreDsc/GoodsItems/LayoutScale/IconSmallItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconSmallItem1 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconSmallItem1.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RuneShopGoodsItemView:InitGenerate__6(Root, data)
--[[
	MoreDsc/GoodsItems/LayoutScale/IconSmallItem2
--]]
	local tmp = Root:Find("MoreDsc/GoodsItems/LayoutScale/IconSmallItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconSmallItem2 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconSmallItem2.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RuneShopGoodsItemView:InitGenerate__7(Root, data)
--[[
	MoreDsc/GoodsItems/LayoutScale/IconSmallItem3
--]]
	local tmp = Root:Find("MoreDsc/GoodsItems/LayoutScale/IconSmallItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconSmallItem3 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconSmallItem3.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RuneShopGoodsItemView:InitGenerate__8(Root, data)
--[[
	MoreDsc/SpecialReward
--]]
	local tmp = Root:Find("MoreDsc/SpecialReward").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.specialReward = tmp
end

---@private
function RuneShopGoodsItemView:InitGenerate__9(Root, data)
--[[
	MoreDsc/SpecialReward/Bg
--]]
	local tmp = Root:Find("MoreDsc/SpecialReward/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.specialReward.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RuneShopGoodsItemView:InitGenerate__10(Root, data)
--[[
	MoreDsc/SpecialReward/Num
--]]
	local tmp = Root:Find("MoreDsc/SpecialReward/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.specialReward.num = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RuneShopGoodsItemView:InitGenerate__11(Root, data)
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
function RuneShopGoodsItemView:InitGenerate__12(Root, data)
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
function RuneShopGoodsItemView:InitGenerate__13(Root, data)
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
function RuneShopGoodsItemView:InitGenerate__14(Root, data)
--[[
	Discount/Text
--]]
	local tmp = Root:Find("Discount/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.discount.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function RuneShopGoodsItemView:InitGenerate__15(Root, data)
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
function RuneShopGoodsItemView:InitGenerate__16(Root, data)
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
function RuneShopGoodsItemView:InitGenerate__17(Root, data)
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
function RuneShopGoodsItemView:InitGenerate__18(Root, data)
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
function RuneShopGoodsItemView:InitGenerate__19(Root, data)
--[[
	PresentPrice/Currency
--]]
	local tmp = Root:Find("PresentPrice/Currency").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice.currency = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function RuneShopGoodsItemView:InitGenerate__20(Root, data)
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
function RuneShopGoodsItemView:GenerateDestroy()
	if tolua.getpeer(self.soldout) ~= nil then
		tolua.setpeer(self.soldout, nil)
	end
	if tolua.getpeer(self.presentPrice.currency) ~= nil then
		tolua.setpeer(self.presentPrice.currency, nil)
	end
	if tolua.getpeer(self.presentPrice.icon) ~= nil then
		tolua.setpeer(self.presentPrice.icon, nil)
	end
	if tolua.getpeer(self.presentPrice.number) ~= nil then
		tolua.setpeer(self.presentPrice.number, nil)
	end
	if tolua.getpeer(self.presentPrice.shadow) ~= nil then
		tolua.setpeer(self.presentPrice.shadow, nil)
	end
	if tolua.getpeer(self.presentPrice) ~= nil then
		tolua.setpeer(self.presentPrice, nil)
	end
	if tolua.getpeer(self.discount.text) ~= nil then
		tolua.setpeer(self.discount.text, nil)
	end
	if tolua.getpeer(self.specialReward.num) ~= nil then
		tolua.setpeer(self.specialReward.num, nil)
	end
	if tolua.getpeer(self.specialReward.bg) ~= nil then
		tolua.setpeer(self.specialReward.bg, nil)
	end
	if tolua.getpeer(self.itemName) ~= nil then
		tolua.setpeer(self.itemName, nil)
	end
	if tolua.getpeer(self.itemIcon) ~= nil then
		tolua.setpeer(self.itemIcon, nil)
	end
	if tolua.getpeer(self.goodsItems) ~= nil then
		tolua.setpeer(self.goodsItems, nil)
	end
	self.goodsItems = nil
	if self.iconSmallItem1.GenerateDestroy ~= nil then
		self.iconSmallItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.iconSmallItem1) ~= nil then
		tolua.setpeer(self.iconSmallItem1, nil)
	end
	self.iconSmallItem1 = nil
	if self.iconSmallItem2.GenerateDestroy ~= nil then
		self.iconSmallItem2:GenerateDestroy()
	end
	if tolua.getpeer(self.iconSmallItem2) ~= nil then
		tolua.setpeer(self.iconSmallItem2, nil)
	end
	self.iconSmallItem2 = nil
	if self.iconSmallItem3.GenerateDestroy ~= nil then
		self.iconSmallItem3:GenerateDestroy()
	end
	if tolua.getpeer(self.iconSmallItem3) ~= nil then
		tolua.setpeer(self.iconSmallItem3, nil)
	end
	self.iconSmallItem3 = nil
	if tolua.getpeer(self.specialReward) ~= nil then
		tolua.setpeer(self.specialReward, nil)
	end
	self.specialReward = nil
	if tolua.getpeer(self.purchaseLimit) ~= nil then
		tolua.setpeer(self.purchaseLimit, nil)
	end
	self.purchaseLimit = nil
	if tolua.getpeer(self.discount) ~= nil then
		tolua.setpeer(self.discount, nil)
	end
	self.discount = nil
	if tolua.getpeer(self.label) ~= nil then
		tolua.setpeer(self.label, nil)
	end
	self.label = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RuneShopGoodsItemView