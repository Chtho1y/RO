---@class UIRuneShopBuyTips__Generate_presentPrice_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIRuneShopBuyTips__Generate_presentPrice_currency
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIRuneShopBuyTips__Generate_presentPrice_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIRuneShopBuyTips__Generate_presentPrice
---@field public gameObject UnityEngine.GameObject
---@field public icon UIRuneShopBuyTips__Generate_presentPrice_icon
---@field public currency UIRuneShopBuyTips__Generate_presentPrice_currency
---@field public number UIRuneShopBuyTips__Generate_presentPrice_number

---@class UIRuneShopBuyTips__Generate_btnBuy
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRuneShopBuyTips__Generate_buyLimitTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIRuneShopBuyTips__Generate_goodsList
---@field public gameObject UnityEngine.GameObject
---@field public loopHorizontalScrollRect UnityEngine.UI.LoopHorizontalScrollRect

---@class UIRuneShopBuyTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRuneShopBuyTips__Generate_textTitle
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIRuneShopBuyTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRuneShopBuyTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIRuneShopBuyTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIRuneShopBuyTips__Generate_uIAnimator
---@field private AnyBtn UIRuneShopBuyTips__Generate_AnyBtn
---@field private textTitle UIRuneShopBuyTips__Generate_textTitle
---@field private btnClose UIRuneShopBuyTips__Generate_btnClose
---@field private goodsList UIRuneShopBuyTips__Generate_goodsList
---@field private buyLimitTxt UIRuneShopBuyTips__Generate_buyLimitTxt
---@field private btnBuy UIRuneShopBuyTips__Generate_btnBuy
---@field private presentPrice UIRuneShopBuyTips__Generate_presentPrice
local UIRuneShopBuyTipsView = class("UIRuneShopBuyTipsView", require("UIViewBase"))

function UIRuneShopBuyTipsView:ctor()
end

---@private
function UIRuneShopBuyTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIRuneShopBuyTipsView:InitGenerate(Root, data)
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


end

---@private
function UIRuneShopBuyTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIRuneShopBuyTipsView:InitGenerate__2(Root, data)
--[[
	UIAnimator
--]]
	local tmp = Root:Find("UIAnimator").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIAnimator = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIRuneShopBuyTipsView:InitGenerate__3(Root, data)
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
function UIRuneShopBuyTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/TextTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/TextTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textTitle = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIRuneShopBuyTipsView:InitGenerate__5(Root, data)
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
function UIRuneShopBuyTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/GoodsList
--]]
	local tmp = Root:Find("UIAnimator/Window/GoodsList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.goodsList = tmp

	tmp.loopHorizontalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopHorizontalScrollRect)
end

---@private
function UIRuneShopBuyTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bottom/Title/BuyLimitTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Title/BuyLimitTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buyLimitTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIRuneShopBuyTipsView:InitGenerate__8(Root, data)
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
function UIRuneShopBuyTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBuy/Content/PresentPrice
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBuy/Content/PresentPrice").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice = tmp
end

---@private
function UIRuneShopBuyTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBuy/Content/PresentPrice/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBuy/Content/PresentPrice/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIRuneShopBuyTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBuy/Content/PresentPrice/Currency
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBuy/Content/PresentPrice/Currency").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice.currency = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIRuneShopBuyTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBuy/Content/PresentPrice/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBuy/Content/PresentPrice/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presentPrice.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIRuneShopBuyTipsView:GenerateDestroy()
	if tolua.getpeer(self.presentPrice.number) ~= nil then
		tolua.setpeer(self.presentPrice.number, nil)
	end
	if tolua.getpeer(self.presentPrice.currency) ~= nil then
		tolua.setpeer(self.presentPrice.currency, nil)
	end
	if tolua.getpeer(self.presentPrice.icon) ~= nil then
		tolua.setpeer(self.presentPrice.icon, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.textTitle) ~= nil then
		tolua.setpeer(self.textTitle, nil)
	end
	self.textTitle = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.goodsList) ~= nil then
		tolua.setpeer(self.goodsList, nil)
	end
	self.goodsList = nil
	if tolua.getpeer(self.buyLimitTxt) ~= nil then
		tolua.setpeer(self.buyLimitTxt, nil)
	end
	self.buyLimitTxt = nil
	if tolua.getpeer(self.btnBuy) ~= nil then
		tolua.setpeer(self.btnBuy, nil)
	end
	self.btnBuy = nil
	if tolua.getpeer(self.presentPrice) ~= nil then
		tolua.setpeer(self.presentPrice, nil)
	end
	self.presentPrice = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIRuneShopBuyTipsView