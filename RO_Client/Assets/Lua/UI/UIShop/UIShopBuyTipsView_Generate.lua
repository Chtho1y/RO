---@class UIShopBuyTips__Generate_btnBuy
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIShopBuyTips__Generate_presentPrice_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIShopBuyTips__Generate_presentPrice_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIShopBuyTips__Generate_presentPrice
---@field public gameObject UnityEngine.GameObject
---@field public icon UIShopBuyTips__Generate_presentPrice_icon
---@field public number UIShopBuyTips__Generate_presentPrice_number

---@class UIShopBuyTips__Generate_btnMax
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIShopBuyTips__Generate_buyNumTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIShopBuyTips__Generate_btnMinus
---@field public gameObject UnityEngine.GameObject
---@field public repeatButton UnityEngine.UI.RepeatButton

---@class UIShopBuyTips__Generate_btnAdd
---@field public gameObject UnityEngine.GameObject
---@field public repeatButton UnityEngine.UI.RepeatButton

---@class UIShopBuyTips__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIShopBuyTips__Generate_timeLimit
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIShopBuyTips__Generate_itemName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIShopBuyTips__Generate_itemnum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIShopBuyTips__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIShopBuyTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIShopBuyTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIShopBuyTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIShopBuyTips__Generate_AnyBtn
---@field private btnClose UIShopBuyTips__Generate_btnClose
---@field private iconItem UIShopBuyTips__Generate_iconItem
---@field private itemnum UIShopBuyTips__Generate_itemnum
---@field private itemName UIShopBuyTips__Generate_itemName
---@field private limitBox UnityEngine.GameObject
---@field private timeLimit UIShopBuyTips__Generate_timeLimit
---@field private desTxt UIShopBuyTips__Generate_desTxt
---@field private btnAdd UIShopBuyTips__Generate_btnAdd
---@field private btnMinus UIShopBuyTips__Generate_btnMinus
---@field private buyNumTxt UIShopBuyTips__Generate_buyNumTxt
---@field private btnMax UIShopBuyTips__Generate_btnMax
---@field private presentPrice UIShopBuyTips__Generate_presentPrice
---@field private btnBuy UIShopBuyTips__Generate_btnBuy
local UIShopBuyTipsView = class("UIShopBuyTipsView", require("UIViewBase"))

function UIShopBuyTipsView:ctor()
end

---@private
function UIShopBuyTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIShopBuyTipsView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
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
function UIShopBuyTipsView:InitGenerate__1(Root, data)
--[[
	UIAnimator/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIShopBuyTipsView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/BtnClose/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnClose/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIShopBuyTipsView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/ItemBox/Item/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemBox/Item/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIShopBuyTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/ItemBox/Item/Num/itemnum
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemBox/Item/Num/itemnum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemnum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIShopBuyTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ItemBox/ItemName
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemBox/ItemName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIShopBuyTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ItemBox/LimitBox
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemBox/LimitBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.limitBox = tmp
end

---@private
function UIShopBuyTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/ItemBox/LimitBox/TimeLimit
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemBox/LimitBox/TimeLimit").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timeLimit = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIShopBuyTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/ItemBox/Describe/DesTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemBox/Describe/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIShopBuyTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Number /Box/BtnAdd
--]]
	local tmp = Root:Find("UIAnimator/Window/Number /Box/BtnAdd").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnAdd = tmp

	tmp.repeatButton = tmp:GetComponent(Enum.TypeInfo.RepeatButton)
end

---@private
function UIShopBuyTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Number /Box/BtnMinus
--]]
	local tmp = Root:Find("UIAnimator/Window/Number /Box/BtnMinus").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnMinus = tmp

	tmp.repeatButton = tmp:GetComponent(Enum.TypeInfo.RepeatButton)
end

---@private
function UIShopBuyTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Number /Box/BuyNumTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Number /Box/BuyNumTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buyNumTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIShopBuyTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Number /Box/BtnMax
--]]
	local tmp = Root:Find("UIAnimator/Window/Number /Box/BtnMax").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnMax = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIShopBuyTipsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bottom/PresentPrice
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/PresentPrice").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice = tmp
end

---@private
function UIShopBuyTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bottom/PresentPrice/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/PresentPrice/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIShopBuyTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bottom/PresentPrice/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/PresentPrice/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIShopBuyTipsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBuy
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBuy").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBuy = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIShopBuyTipsView:GenerateDestroy()
	if tolua.getpeer(self.presentPrice.number) ~= nil then
		tolua.setpeer(self.presentPrice.number, nil)
	end
	if tolua.getpeer(self.presentPrice.icon) ~= nil then
		tolua.setpeer(self.presentPrice.icon, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if tolua.getpeer(self.itemnum) ~= nil then
		tolua.setpeer(self.itemnum, nil)
	end
	self.itemnum = nil
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
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	if tolua.getpeer(self.btnAdd) ~= nil then
		tolua.setpeer(self.btnAdd, nil)
	end
	self.btnAdd = nil
	if tolua.getpeer(self.btnMinus) ~= nil then
		tolua.setpeer(self.btnMinus, nil)
	end
	self.btnMinus = nil
	if tolua.getpeer(self.buyNumTxt) ~= nil then
		tolua.setpeer(self.buyNumTxt, nil)
	end
	self.buyNumTxt = nil
	if tolua.getpeer(self.btnMax) ~= nil then
		tolua.setpeer(self.btnMax, nil)
	end
	self.btnMax = nil
	if tolua.getpeer(self.presentPrice) ~= nil then
		tolua.setpeer(self.presentPrice, nil)
	end
	self.presentPrice = nil
	if tolua.getpeer(self.btnBuy) ~= nil then
		tolua.setpeer(self.btnBuy, nil)
	end
	self.btnBuy = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIShopBuyTipsView