---@class UISummon__Generate_btnArrowL
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummon__Generate_btnArrowR
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummon__Generate_dot
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UISummon__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummon__Generate_lockTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISummon__Generate_btnFive
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummon__Generate_currencyFive_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISummon__Generate_currencyFive_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISummon__Generate_currencyFive
---@field public gameObject UnityEngine.GameObject
---@field public icon UISummon__Generate_currencyFive_icon
---@field public number UISummon__Generate_currencyFive_number

---@class UISummon__Generate_btnOne
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummon__Generate_currencyOne_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISummon__Generate_currencyOne_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISummon__Generate_currencyOne
---@field public gameObject UnityEngine.GameObject
---@field public icon UISummon__Generate_currencyOne_icon
---@field public number UISummon__Generate_currencyOne_number

---@class UISummon__Generate_timeBox_TimeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UISummon__Generate_timeBox
---@field public gameObject UnityEngine.GameObject
---@field public TimeTxt UISummon__Generate_timeBox_TimeTxt

---@class UISummon__Generate_currency_btnBuy
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummon__Generate_currency_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISummon__Generate_currency_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISummon__Generate_currency
---@field public gameObject UnityEngine.GameObject
---@field public icon UISummon__Generate_currency_icon
---@field public number UISummon__Generate_currency_number
---@field public btnBuy UISummon__Generate_currency_btnBuy

---@class UISummon__Generate_btnPlayRule
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummon__Generate_uISummonItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UISummon__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UISummon__Generate_window
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISummon__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummon__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISummon__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UISummon__Generate_uIAnimator
---@field private AnyBtn UISummon__Generate_AnyBtn
---@field private window UISummon__Generate_window
---@field private scrollView UISummon__Generate_scrollView
---@field private uISummonItem UISummon__Generate_uISummonItem
---@field private btnPlayRule UISummon__Generate_btnPlayRule
---@field private currency UISummon__Generate_currency
---@field private timeBox UISummon__Generate_timeBox
---@field private leftAnim UnityEngine.GameObject
---@field private currencyOne UISummon__Generate_currencyOne
---@field private btnOne UISummon__Generate_btnOne
---@field private rightAnim UnityEngine.GameObject
---@field private currencyFive UISummon__Generate_currencyFive
---@field private btnFive UISummon__Generate_btnFive
---@field private lockAnim UnityEngine.GameObject
---@field private lockTxt UISummon__Generate_lockTxt
---@field private btnClose UISummon__Generate_btnClose
---@field private dotToggleGroup UnityEngine.GameObject
---@field private dot UISummon__Generate_dot
---@field private btnArrowR UISummon__Generate_btnArrowR
---@field private btnArrowL UISummon__Generate_btnArrowL
local UISummonView = class("UISummonView", require("UIViewBase"))

function UISummonView:ctor()
end

---@private
function UISummonView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISummonView:InitGenerate(Root, data)
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


end

---@private
function UISummonView:InitGenerate__1(Root, data)
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
function UISummonView:InitGenerate__2(Root, data)
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
function UISummonView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window
--]]
	local tmp = Root:Find("UIAnimator/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UISummonView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UISummonView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ScrollView/Viewport/Content/UISummonItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView/Viewport/Content/UISummonItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uISummonItem = CommonUtil.BindGridViewItem2LuaStatic("UISummonItem", tmp)
	self.uISummonItem.prefabName = "UISummonItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UISummonView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/TopView/ResourceBoxAnim/BtnPlayRule
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/ResourceBoxAnim/BtnPlayRule").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPlayRule = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/TopView/ResourceBoxAnim/Currency
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/ResourceBoxAnim/Currency").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency = tmp
end

---@private
function UISummonView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/TopView/ResourceBoxAnim/Currency/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/ResourceBoxAnim/Currency/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISummonView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/TopView/ResourceBoxAnim/Currency/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/ResourceBoxAnim/Currency/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISummonView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/TopView/ResourceBoxAnim/Currency/BtnBuy
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/ResourceBoxAnim/Currency/BtnBuy").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency.btnBuy = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/TopView/ResourceBoxAnim/TimeBox
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/ResourceBoxAnim/TimeBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timeBox = tmp
end

---@private
function UISummonView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/TopView/ResourceBoxAnim/TimeBox/Time
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/ResourceBoxAnim/TimeBox/Time").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timeBox.TimeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UISummonView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnAnim/LeftAnim
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnAnim/LeftAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftAnim = tmp
end

---@private
function UISummonView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnAnim/LeftAnim/CurrencyOne
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnAnim/LeftAnim/CurrencyOne").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currencyOne = tmp
end

---@private
function UISummonView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnAnim/LeftAnim/CurrencyOne/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnAnim/LeftAnim/CurrencyOne/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currencyOne.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISummonView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnAnim/LeftAnim/CurrencyOne/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnAnim/LeftAnim/CurrencyOne/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currencyOne.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISummonView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnAnim/LeftAnim/BtnOne
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnAnim/LeftAnim/BtnOne").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnOne = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnAnim/RightAnim
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnAnim/RightAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rightAnim = tmp
end

---@private
function UISummonView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnAnim/RightAnim/CurrencyFive
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnAnim/RightAnim/CurrencyFive").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currencyFive = tmp
end

---@private
function UISummonView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnAnim/RightAnim/CurrencyFive/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnAnim/RightAnim/CurrencyFive/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currencyFive.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISummonView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnAnim/RightAnim/CurrencyFive/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnAnim/RightAnim/CurrencyFive/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currencyFive.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISummonView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnAnim/RightAnim/BtnFive
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnAnim/RightAnim/BtnFive").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnFive = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnAnim/LockAnim
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnAnim/LockAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lockAnim = tmp
	self.lockAnim:SetActive(false)
end

---@private
function UISummonView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnAnim/LockAnim/LockTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnAnim/LockAnim/LockTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lockTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISummonView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/Bottom/DotToggleGroup
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/DotToggleGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dotToggleGroup = tmp
end

---@private
function UISummonView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/Bottom/DotToggleGroup/Dot
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/DotToggleGroup/Dot").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dot = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UISummonView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/BtnArrowR
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnArrowR").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnArrowR = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/BtnArrowL
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnArrowL").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnArrowL = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonView:GenerateDestroy()
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
	if tolua.getpeer(self.timeBox.TimeTxt) ~= nil then
		tolua.setpeer(self.timeBox.TimeTxt, nil)
	end
	if tolua.getpeer(self.currency.btnBuy) ~= nil then
		tolua.setpeer(self.currency.btnBuy, nil)
	end
	if tolua.getpeer(self.currency.number) ~= nil then
		tolua.setpeer(self.currency.number, nil)
	end
	if tolua.getpeer(self.currency.icon) ~= nil then
		tolua.setpeer(self.currency.icon, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if self.uISummonItem.GenerateDestroy ~= nil then
		self.uISummonItem:GenerateDestroy()
	end
	if tolua.getpeer(self.uISummonItem) ~= nil then
		tolua.setpeer(self.uISummonItem, nil)
	end
	self.uISummonItem = nil
	if tolua.getpeer(self.btnPlayRule) ~= nil then
		tolua.setpeer(self.btnPlayRule, nil)
	end
	self.btnPlayRule = nil
	if tolua.getpeer(self.currency) ~= nil then
		tolua.setpeer(self.currency, nil)
	end
	self.currency = nil
	if tolua.getpeer(self.timeBox) ~= nil then
		tolua.setpeer(self.timeBox, nil)
	end
	self.timeBox = nil
	if tolua.getpeer(self.leftAnim) ~= nil then
		tolua.setpeer(self.leftAnim, nil)
	end
	self.leftAnim = nil
	if tolua.getpeer(self.currencyOne) ~= nil then
		tolua.setpeer(self.currencyOne, nil)
	end
	self.currencyOne = nil
	if tolua.getpeer(self.btnOne) ~= nil then
		tolua.setpeer(self.btnOne, nil)
	end
	self.btnOne = nil
	if tolua.getpeer(self.rightAnim) ~= nil then
		tolua.setpeer(self.rightAnim, nil)
	end
	self.rightAnim = nil
	if tolua.getpeer(self.currencyFive) ~= nil then
		tolua.setpeer(self.currencyFive, nil)
	end
	self.currencyFive = nil
	if tolua.getpeer(self.btnFive) ~= nil then
		tolua.setpeer(self.btnFive, nil)
	end
	self.btnFive = nil
	if tolua.getpeer(self.lockAnim) ~= nil then
		tolua.setpeer(self.lockAnim, nil)
	end
	self.lockAnim = nil
	if tolua.getpeer(self.lockTxt) ~= nil then
		tolua.setpeer(self.lockTxt, nil)
	end
	self.lockTxt = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.dotToggleGroup) ~= nil then
		tolua.setpeer(self.dotToggleGroup, nil)
	end
	self.dotToggleGroup = nil
	if tolua.getpeer(self.dot) ~= nil then
		tolua.setpeer(self.dot, nil)
	end
	self.dot = nil
	if tolua.getpeer(self.btnArrowR) ~= nil then
		tolua.setpeer(self.btnArrowR, nil)
	end
	self.btnArrowR = nil
	if tolua.getpeer(self.btnArrowL) ~= nil then
		tolua.setpeer(self.btnArrowL, nil)
	end
	self.btnArrowL = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISummonView