---@class UIBuyTimes__Generate_buyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBuyTimes__Generate_costText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBuyTimes__Generate_btnPlus
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBuyTimes__Generate_btnMinus
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBuyTimes__Generate_slider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class UIBuyTimes__Generate_leftTimesText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBuyTimes__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBuyTimes__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBuyTimes__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBuyTimes__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIBuyTimes__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIBuyTimes__Generate_uIAnimator
---@field private AnyBtn UIBuyTimes__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private closeBtn UIBuyTimes__Generate_closeBtn
---@field private number UIBuyTimes__Generate_number
---@field private leftTimesText UIBuyTimes__Generate_leftTimesText
---@field private slider UIBuyTimes__Generate_slider
---@field private btnMinus UIBuyTimes__Generate_btnMinus
---@field private btnPlus UIBuyTimes__Generate_btnPlus
---@field private costText UIBuyTimes__Generate_costText
---@field private buyBtn UIBuyTimes__Generate_buyBtn
local UIBuyTimesView = class("UIBuyTimesView", require("UIViewBase"))

function UIBuyTimesView:ctor()
end

---@private
function UIBuyTimesView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIBuyTimesView:InitGenerate(Root, data)
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
function UIBuyTimesView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIBuyTimesView:InitGenerate__2(Root, data)
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
function UIBuyTimesView:InitGenerate__3(Root, data)
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
function UIBuyTimesView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window
--]]
	local tmp = Root:Find("UIAnimator/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp
end

---@private
function UIBuyTimesView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIBuyTimesView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/Center/Bg/Text/Times/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Center/Bg/Text/Times/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBuyTimesView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/Center/Bg/Text/Times/LeftTimes
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Center/Bg/Text/Times/LeftTimes").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftTimesText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBuyTimesView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/Center/Bg/Text/QtyBox/Slider
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Center/Bg/Text/QtyBox/Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function UIBuyTimesView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/Center/Bg/Text/QtyBox/BtnMinus
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Center/Bg/Text/QtyBox/BtnMinus").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnMinus = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIBuyTimesView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/Center/Bg/Text/QtyBox/BtnPlus
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Center/Bg/Text/QtyBox/BtnPlus").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPlus = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIBuyTimesView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/Cost/Cost
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/Cost/Cost").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.costText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBuyTimesView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/BuyBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/BuyBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIBuyTimesView:GenerateDestroy()
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
	if tolua.getpeer(self.closeBtn) ~= nil then
		tolua.setpeer(self.closeBtn, nil)
	end
	self.closeBtn = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
	if tolua.getpeer(self.leftTimesText) ~= nil then
		tolua.setpeer(self.leftTimesText, nil)
	end
	self.leftTimesText = nil
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
	if tolua.getpeer(self.costText) ~= nil then
		tolua.setpeer(self.costText, nil)
	end
	self.costText = nil
	if tolua.getpeer(self.buyBtn) ~= nil then
		tolua.setpeer(self.buyBtn, nil)
	end
	self.buyBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIBuyTimesView