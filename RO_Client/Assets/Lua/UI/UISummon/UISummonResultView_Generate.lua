---@class UISummonResult__Generate_currency_btnBuy
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummonResult__Generate_currency_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISummonResult__Generate_currency_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISummonResult__Generate_currency
---@field public gameObject UnityEngine.GameObject
---@field public icon UISummonResult__Generate_currency_icon
---@field public number UISummonResult__Generate_currency_number
---@field public btnBuy UISummonResult__Generate_currency_btnBuy

---@class UISummonResult__Generate_btnFive
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummonResult__Generate_currencyFive_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISummonResult__Generate_currencyFive_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISummonResult__Generate_currencyFive
---@field public gameObject UnityEngine.GameObject
---@field public icon UISummonResult__Generate_currencyFive_icon
---@field public number UISummonResult__Generate_currencyFive_number

---@class UISummonResult__Generate_btnOne
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummonResult__Generate_currencyOne_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISummonResult__Generate_currencyOne_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISummonResult__Generate_currencyOne
---@field public gameObject UnityEngine.GameObject
---@field public icon UISummonResult__Generate_currencyOne_icon
---@field public number UISummonResult__Generate_currencyOne_number

---@class UISummonResult__Generate_btnConfirm
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummonResult__Generate_extraRewardItem_percentTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UISummonResult__Generate_extraRewardItem_rewardSlider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class UISummonResult__Generate_extraRewardItem
---@field public gameObject UnityEngine.GameObject
---@field public rewardSlider UISummonResult__Generate_extraRewardItem_rewardSlider
---@field public percentTxt UISummonResult__Generate_extraRewardItem_percentTxt

---@class UISummonResult__Generate_particle
---@field public gameObject UnityEngine.GameObject
---@field public uIParticle UIExtensions.UIParticle

---@class UISummonResult__Generate_extraAnim
---@field public gameObject UnityEngine.GameObject
---@field public iconLightParent UnityEngine.GameObject
---@field public iconParent UnityEngine.GameObject
---@field public iconIsNewParent UnityEngine.GameObject

---@class UISummonResult__Generate_bG
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISummonResult__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummonResult__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISummonResult__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UISummonResult__Generate_uIAnimator
---@field private AnyBtn UISummonResult__Generate_AnyBtn
---@field private bG UISummonResult__Generate_bG
---@field private iconLightParent UnityEngine.GameObject
---@field private iconParent UnityEngine.GameObject
---@field private iconIsNewParent UnityEngine.GameObject
---@field private extraBox UnityEngine.GameObject
---@field private extraAnim UISummonResult__Generate_extraAnim
---@field private particle UISummonResult__Generate_particle
---@field private extraRewardItem UISummonResult__Generate_extraRewardItem
---@field private confirm UnityEngine.GameObject
---@field private btnConfirm UISummonResult__Generate_btnConfirm
---@field private one UnityEngine.GameObject
---@field private currencyOne UISummonResult__Generate_currencyOne
---@field private btnOne UISummonResult__Generate_btnOne
---@field private five UnityEngine.GameObject
---@field private currencyFive UISummonResult__Generate_currencyFive
---@field private btnFive UISummonResult__Generate_btnFive
---@field private currency UISummonResult__Generate_currency
local UISummonResultView = class("UISummonResultView", require("UIViewBase"))

function UISummonResultView:ctor()
end

---@private
function UISummonResultView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISummonResultView:InitGenerate(Root, data)
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
	self:InitGenerate__17(Root,data)
	self:InitGenerate__18(Root,data)
	self:InitGenerate__19(Root,data)
	self:InitGenerate__20(Root,data)
	self:InitGenerate__21(Root,data)
	self:InitGenerate__22(Root,data)
	self:InitGenerate__23(Root,data)
	self:InitGenerate__24(Root,data)
	self:InitGenerate__25(Root,data)
	self:InitGenerate__26(Root,data)
	self:InitGenerate__27(Root,data)
	self:InitGenerate__28(Root,data)
	self:InitGenerate__29(Root,data)
	self:InitGenerate__30(Root,data)
	self:InitGenerate__31(Root,data)


end

---@private
function UISummonResultView:InitGenerate__1(Root, data)
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
function UISummonResultView:InitGenerate__2(Root, data)
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
function UISummonResultView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BG
--]]
	local tmp = Root:Find("UIAnimator/Window/BG").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bG = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UISummonResultView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BG/ContentBox/IconLightParent
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ContentBox/IconLightParent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconLightParent = tmp
end

---@private
function UISummonResultView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BG/ContentBox/IconParent
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ContentBox/IconParent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconParent = tmp
end

---@private
function UISummonResultView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BG/ContentBox/IconIsNewParent
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ContentBox/IconIsNewParent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconIsNewParent = tmp
end

---@private
function UISummonResultView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BG/ExtraBox
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExtraBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.extraBox = tmp
end

---@private
function UISummonResultView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BG/ExtraBox/ExtraAnim
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExtraBox/ExtraAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.extraAnim = tmp
end

---@private
function UISummonResultView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BG/ExtraBox/ExtraAnim/IconLightParent
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExtraBox/ExtraAnim/IconLightParent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.extraAnim.iconLightParent = tmp
end

---@private
function UISummonResultView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BG/ExtraBox/ExtraAnim/IconParent
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExtraBox/ExtraAnim/IconParent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.extraAnim.iconParent = tmp
end

---@private
function UISummonResultView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BG/ExtraBox/ExtraAnim/IconIsNewParent
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExtraBox/ExtraAnim/IconIsNewParent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.extraAnim.iconIsNewParent = tmp
end

---@private
function UISummonResultView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BG/ExtraBox/ExtraAnim/particle
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExtraBox/ExtraAnim/particle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.particle = tmp

	tmp.uIParticle = tmp:GetComponent(Enum.TypeInfo.UIParticle)
end

---@private
function UISummonResultView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BG/ExtraBox/ExtraRewardItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExtraBox/ExtraRewardItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.extraRewardItem = tmp
end

---@private
function UISummonResultView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/BG/ExtraBox/ExtraRewardItem/RewardSlider
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExtraBox/ExtraRewardItem/RewardSlider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.extraRewardItem.rewardSlider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function UISummonResultView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/BG/ExtraBox/ExtraRewardItem/PercentTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ExtraBox/ExtraRewardItem/PercentTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.extraRewardItem.percentTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UISummonResultView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/BtnBox/Confirm
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Confirm").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.confirm = tmp
end

---@private
function UISummonResultView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/BtnBox/Confirm/BtnConfirm
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Confirm/BtnConfirm").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnConfirm = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonResultView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/BtnBox/One
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/One").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.one = tmp
end

---@private
function UISummonResultView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/BtnBox/One/CurrencyOne
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/One/CurrencyOne").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currencyOne = tmp
end

---@private
function UISummonResultView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/BtnBox/One/CurrencyOne/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/One/CurrencyOne/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currencyOne.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISummonResultView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/BtnBox/One/CurrencyOne/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/One/CurrencyOne/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currencyOne.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISummonResultView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/BtnBox/One/BtnOne
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/One/BtnOne").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnOne = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonResultView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/BtnBox/Five
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Five").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.five = tmp
end

---@private
function UISummonResultView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/BtnBox/Five/CurrencyFive
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Five/CurrencyFive").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currencyFive = tmp
end

---@private
function UISummonResultView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/BtnBox/Five/CurrencyFive/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Five/CurrencyFive/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currencyFive.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISummonResultView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/BtnBox/Five/CurrencyFive/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Five/CurrencyFive/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currencyFive.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISummonResultView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/BtnBox/Five/BtnFive
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Five/BtnFive").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnFive = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonResultView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/TopView/ResourceBox/Currency
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/ResourceBox/Currency").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency = tmp
end

---@private
function UISummonResultView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/TopView/ResourceBox/Currency/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/ResourceBox/Currency/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISummonResultView:InitGenerate__30(Root, data)
--[[
	UIAnimator/Window/TopView/ResourceBox/Currency/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/ResourceBox/Currency/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISummonResultView:InitGenerate__31(Root, data)
--[[
	UIAnimator/Window/TopView/ResourceBox/Currency/BtnBuy
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/ResourceBox/Currency/BtnBuy").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency.btnBuy = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonResultView:GenerateDestroy()
	if tolua.getpeer(self.currency.btnBuy) ~= nil then
		tolua.setpeer(self.currency.btnBuy, nil)
	end
	if tolua.getpeer(self.currency.number) ~= nil then
		tolua.setpeer(self.currency.number, nil)
	end
	if tolua.getpeer(self.currency.icon) ~= nil then
		tolua.setpeer(self.currency.icon, nil)
	end
	if tolua.getpeer(self.currencyFive.number) ~= nil then
		tolua.setpeer(self.currencyFive.number, nil)
	end
	if tolua.getpeer(self.currencyFive.icon) ~= nil then
		tolua.setpeer(self.currencyFive.icon, nil)
	end
	if tolua.getpeer(self.currencyOne.number) ~= nil then
		tolua.setpeer(self.currencyOne.number, nil)
	end
	if tolua.getpeer(self.currencyOne.icon) ~= nil then
		tolua.setpeer(self.currencyOne.icon, nil)
	end
	if tolua.getpeer(self.extraRewardItem.percentTxt) ~= nil then
		tolua.setpeer(self.extraRewardItem.percentTxt, nil)
	end
	if tolua.getpeer(self.extraRewardItem.rewardSlider) ~= nil then
		tolua.setpeer(self.extraRewardItem.rewardSlider, nil)
	end
	if tolua.getpeer(self.extraAnim.iconIsNewParent) ~= nil then
		tolua.setpeer(self.extraAnim.iconIsNewParent, nil)
	end
	if tolua.getpeer(self.extraAnim.iconParent) ~= nil then
		tolua.setpeer(self.extraAnim.iconParent, nil)
	end
	if tolua.getpeer(self.extraAnim.iconLightParent) ~= nil then
		tolua.setpeer(self.extraAnim.iconLightParent, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.bG) ~= nil then
		tolua.setpeer(self.bG, nil)
	end
	self.bG = nil
	if tolua.getpeer(self.iconLightParent) ~= nil then
		tolua.setpeer(self.iconLightParent, nil)
	end
	self.iconLightParent = nil
	if tolua.getpeer(self.iconParent) ~= nil then
		tolua.setpeer(self.iconParent, nil)
	end
	self.iconParent = nil
	if tolua.getpeer(self.iconIsNewParent) ~= nil then
		tolua.setpeer(self.iconIsNewParent, nil)
	end
	self.iconIsNewParent = nil
	if tolua.getpeer(self.extraBox) ~= nil then
		tolua.setpeer(self.extraBox, nil)
	end
	self.extraBox = nil
	if tolua.getpeer(self.extraAnim) ~= nil then
		tolua.setpeer(self.extraAnim, nil)
	end
	self.extraAnim = nil
	if tolua.getpeer(self.particle) ~= nil then
		tolua.setpeer(self.particle, nil)
	end
	self.particle = nil
	if tolua.getpeer(self.extraRewardItem) ~= nil then
		tolua.setpeer(self.extraRewardItem, nil)
	end
	self.extraRewardItem = nil
	if tolua.getpeer(self.confirm) ~= nil then
		tolua.setpeer(self.confirm, nil)
	end
	self.confirm = nil
	if tolua.getpeer(self.btnConfirm) ~= nil then
		tolua.setpeer(self.btnConfirm, nil)
	end
	self.btnConfirm = nil
	if tolua.getpeer(self.one) ~= nil then
		tolua.setpeer(self.one, nil)
	end
	self.one = nil
	if tolua.getpeer(self.currencyOne) ~= nil then
		tolua.setpeer(self.currencyOne, nil)
	end
	self.currencyOne = nil
	if tolua.getpeer(self.btnOne) ~= nil then
		tolua.setpeer(self.btnOne, nil)
	end
	self.btnOne = nil
	if tolua.getpeer(self.five) ~= nil then
		tolua.setpeer(self.five, nil)
	end
	self.five = nil
	if tolua.getpeer(self.currencyFive) ~= nil then
		tolua.setpeer(self.currencyFive, nil)
	end
	self.currencyFive = nil
	if tolua.getpeer(self.btnFive) ~= nil then
		tolua.setpeer(self.btnFive, nil)
	end
	self.btnFive = nil
	if tolua.getpeer(self.currency) ~= nil then
		tolua.setpeer(self.currency, nil)
	end
	self.currency = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISummonResultView