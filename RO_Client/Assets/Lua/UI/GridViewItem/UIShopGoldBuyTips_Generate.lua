---@class UIShopGoldBuyTips__Generate_presentPrice_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIShopGoldBuyTips__Generate_presentPrice_currency
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIShopGoldBuyTips__Generate_presentPrice_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIShopGoldBuyTips__Generate_presentPrice
---@field public gameObject UnityEngine.GameObject
---@field public icon UIShopGoldBuyTips__Generate_presentPrice_icon
---@field public currency UIShopGoldBuyTips__Generate_presentPrice_currency
---@field public number UIShopGoldBuyTips__Generate_presentPrice_number

---@class UIShopGoldBuyTips__Generate_btnBuy
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIShopGoldBuyTips__Generate_buyLimitTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIShopGoldBuyTips__Generate_goldText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIShopGoldBuyTips__Generate_image
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIShopGoldBuyTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIShopGoldBuyTips__Generate_textTitle
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIShopGoldBuyTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIShopGoldBuyTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIShopGoldBuyTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIShopGoldBuyTips__Generate_uIAnimator
---@field private AnyBtn UIShopGoldBuyTips__Generate_AnyBtn
---@field private textTitle UIShopGoldBuyTips__Generate_textTitle
---@field private btnClose UIShopGoldBuyTips__Generate_btnClose
---@field private image UIShopGoldBuyTips__Generate_image
---@field private goldText UIShopGoldBuyTips__Generate_goldText
---@field private buyLimitTxt UIShopGoldBuyTips__Generate_buyLimitTxt
---@field private btnBuy UIShopGoldBuyTips__Generate_btnBuy
---@field private presentPrice UIShopGoldBuyTips__Generate_presentPrice
local UIShopGoldBuyTipsView = class("UIShopGoldBuyTipsView")

function UIShopGoldBuyTipsView:ctor()
end

---@private
function UIShopGoldBuyTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIShopGoldBuyTipsView:InitGenerate(Root, data)
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
function UIShopGoldBuyTipsView:InitGenerate__1(Root, data)
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
function UIShopGoldBuyTipsView:InitGenerate__2(Root, data)
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
function UIShopGoldBuyTipsView:InitGenerate__3(Root, data)
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
function UIShopGoldBuyTipsView:InitGenerate__4(Root, data)
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
function UIShopGoldBuyTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/GoodsList/Image
--]]
	local tmp = Root:Find("UIAnimator/Window/GoodsList/Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.image = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIShopGoldBuyTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/GoodsList/GoldText
--]]
	local tmp = Root:Find("UIAnimator/Window/GoodsList/GoldText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.goldText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIShopGoldBuyTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/DscText/BuyLimitTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/DscText/BuyLimitTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buyLimitTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIShopGoldBuyTipsView:InitGenerate__8(Root, data)
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
function UIShopGoldBuyTipsView:InitGenerate__9(Root, data)
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
function UIShopGoldBuyTipsView:InitGenerate__10(Root, data)
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
function UIShopGoldBuyTipsView:InitGenerate__11(Root, data)
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
function UIShopGoldBuyTipsView:InitGenerate__12(Root, data)
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
function UIShopGoldBuyTipsView:GenerateDestroy()
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
	if tolua.getpeer(self.image) ~= nil then
		tolua.setpeer(self.image, nil)
	end
	self.image = nil
	if tolua.getpeer(self.goldText) ~= nil then
		tolua.setpeer(self.goldText, nil)
	end
	self.goldText = nil
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
return UIShopGoldBuyTipsView