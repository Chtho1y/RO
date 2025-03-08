---@class UIFashionWash__Generate_btnKeep
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionWash__Generate_btnWashAgain
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionWash__Generate_btnWash
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionWash__Generate_washAttrItem5
---@field public gameObject UnityEngine.GameObject
---@field public uIEffectCfg UIEffectCfg

---@class UIFashionWash__Generate_washAttrItem4
---@field public gameObject UnityEngine.GameObject
---@field public uIEffectCfg UIEffectCfg

---@class UIFashionWash__Generate_washAttrItem3
---@field public gameObject UnityEngine.GameObject
---@field public uIEffectCfg UIEffectCfg

---@class UIFashionWash__Generate_washAttrItem2
---@field public gameObject UnityEngine.GameObject
---@field public uIEffectCfg UIEffectCfg

---@class UIFashionWash__Generate_washAttrItem1
---@field public gameObject UnityEngine.GameObject
---@field public uIEffectCfg UIEffectCfg

---@class UIFashionWash__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionWash__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UIFashionWash__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionWash__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIFashionWash__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIFashionWash__Generate_uIAnimator
---@field private AnyBtn UIFashionWash__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private bg UIFashionWash__Generate_bg
---@field private closeBox UnityEngine.GameObject
---@field private btnClose UIFashionWash__Generate_btnClose
---@field private washAttrItem1 UIFashionWash__Generate_washAttrItem1
---@field private washAttrItem2 UIFashionWash__Generate_washAttrItem2
---@field private washAttrItem3 UIFashionWash__Generate_washAttrItem3
---@field private washAttrItem4 UIFashionWash__Generate_washAttrItem4
---@field private washAttrItem5 UIFashionWash__Generate_washAttrItem5
---@field private btnBox UnityEngine.GameObject
---@field private boxCost UnityEngine.GameObject
---@field private cost1 UnityEngine.GameObject
---@field private cost2 UnityEngine.GameObject
---@field private cost3 UnityEngine.GameObject
---@field private btnWash UIFashionWash__Generate_btnWash
---@field private btnWashAgain UIFashionWash__Generate_btnWashAgain
---@field private btnKeep UIFashionWash__Generate_btnKeep
local UIFashionWashView = class("UIFashionWashView", require("UIViewBase"))

function UIFashionWashView:ctor()
end

---@private
function UIFashionWashView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIFashionWashView:InitGenerate(Root, data)
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


end

---@private
function UIFashionWashView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIFashionWashView:InitGenerate__2(Root, data)
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
function UIFashionWashView:InitGenerate__3(Root, data)
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
function UIFashionWashView:InitGenerate__4(Root, data)
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
function UIFashionWashView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)
end

---@private
function UIFashionWashView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBox = tmp
end

---@private
function UIFashionWashView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFashionWashView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/WashBox/WashAttrItem1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/WashBox/WashAttrItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.washAttrItem1 = CommonUtil.BindGridViewItem2LuaStatic("WashAttrItem", tmp)
	self.washAttrItem1.prefabName = "WashAttrItem"

	tmp.uIEffectCfg = tmp:GetComponent(Enum.TypeInfo.UIEffectCfg)
end

---@private
function UIFashionWashView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/WashBox/WashAttrItem2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/WashBox/WashAttrItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.washAttrItem2 = CommonUtil.BindGridViewItem2LuaStatic("WashAttrItem", tmp)
	self.washAttrItem2.prefabName = "WashAttrItem"

	tmp.uIEffectCfg = tmp:GetComponent(Enum.TypeInfo.UIEffectCfg)
end

---@private
function UIFashionWashView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/WashBox/WashAttrItem3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/WashBox/WashAttrItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.washAttrItem3 = CommonUtil.BindGridViewItem2LuaStatic("WashAttrItem", tmp)
	self.washAttrItem3.prefabName = "WashAttrItem"

	tmp.uIEffectCfg = tmp:GetComponent(Enum.TypeInfo.UIEffectCfg)
end

---@private
function UIFashionWashView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/WashBox/WashAttrItem4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/WashBox/WashAttrItem4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.washAttrItem4 = CommonUtil.BindGridViewItem2LuaStatic("WashAttrItem", tmp)
	self.washAttrItem4.prefabName = "WashAttrItem"

	tmp.uIEffectCfg = tmp:GetComponent(Enum.TypeInfo.UIEffectCfg)
end

---@private
function UIFashionWashView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/WashBox/WashAttrItem5
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/WashBox/WashAttrItem5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.washAttrItem5 = CommonUtil.BindGridViewItem2LuaStatic("WashAttrItem", tmp)
	self.washAttrItem5.prefabName = "WashAttrItem"

	tmp.uIEffectCfg = tmp:GetComponent(Enum.TypeInfo.UIEffectCfg)
end

---@private
function UIFashionWashView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBox = tmp
end

---@private
function UIFashionWashView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/BoxCost
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/BoxCost").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxCost = tmp
end

---@private
function UIFashionWashView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/BoxCost/Cost/CostItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/BoxCost/Cost/CostItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cost1 = CommonUtil.BindGridViewItem2LuaStatic("CostItem", tmp)
	self.cost1.prefabName = "CostItem"
end

---@private
function UIFashionWashView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/BoxCost/Cost/CostItem1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/BoxCost/Cost/CostItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cost2 = CommonUtil.BindGridViewItem2LuaStatic("CostItem", tmp)
	self.cost2.prefabName = "CostItem"
end

---@private
function UIFashionWashView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/BoxCost/Cost/CostItem2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/BoxCost/Cost/CostItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cost3 = CommonUtil.BindGridViewItem2LuaStatic("CostItem", tmp)
	self.cost3.prefabName = "CostItem"
end

---@private
function UIFashionWashView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/BtnWash
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/BtnWash").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnWash = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFashionWashView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/BtnWashAgain
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/BtnWashAgain").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnWashAgain = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFashionWashView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/BtnKeep
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/BtnKeep").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnKeep = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFashionWashView:GenerateDestroy()
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
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.closeBox) ~= nil then
		tolua.setpeer(self.closeBox, nil)
	end
	self.closeBox = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if self.washAttrItem1.GenerateDestroy ~= nil then
		self.washAttrItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.washAttrItem1) ~= nil then
		tolua.setpeer(self.washAttrItem1, nil)
	end
	self.washAttrItem1 = nil
	if self.washAttrItem2.GenerateDestroy ~= nil then
		self.washAttrItem2:GenerateDestroy()
	end
	if tolua.getpeer(self.washAttrItem2) ~= nil then
		tolua.setpeer(self.washAttrItem2, nil)
	end
	self.washAttrItem2 = nil
	if self.washAttrItem3.GenerateDestroy ~= nil then
		self.washAttrItem3:GenerateDestroy()
	end
	if tolua.getpeer(self.washAttrItem3) ~= nil then
		tolua.setpeer(self.washAttrItem3, nil)
	end
	self.washAttrItem3 = nil
	if self.washAttrItem4.GenerateDestroy ~= nil then
		self.washAttrItem4:GenerateDestroy()
	end
	if tolua.getpeer(self.washAttrItem4) ~= nil then
		tolua.setpeer(self.washAttrItem4, nil)
	end
	self.washAttrItem4 = nil
	if self.washAttrItem5.GenerateDestroy ~= nil then
		self.washAttrItem5:GenerateDestroy()
	end
	if tolua.getpeer(self.washAttrItem5) ~= nil then
		tolua.setpeer(self.washAttrItem5, nil)
	end
	self.washAttrItem5 = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.boxCost) ~= nil then
		tolua.setpeer(self.boxCost, nil)
	end
	self.boxCost = nil
	if self.cost1.GenerateDestroy ~= nil then
		self.cost1:GenerateDestroy()
	end
	if tolua.getpeer(self.cost1) ~= nil then
		tolua.setpeer(self.cost1, nil)
	end
	self.cost1 = nil
	if self.cost2.GenerateDestroy ~= nil then
		self.cost2:GenerateDestroy()
	end
	if tolua.getpeer(self.cost2) ~= nil then
		tolua.setpeer(self.cost2, nil)
	end
	self.cost2 = nil
	if self.cost3.GenerateDestroy ~= nil then
		self.cost3:GenerateDestroy()
	end
	if tolua.getpeer(self.cost3) ~= nil then
		tolua.setpeer(self.cost3, nil)
	end
	self.cost3 = nil
	if tolua.getpeer(self.btnWash) ~= nil then
		tolua.setpeer(self.btnWash, nil)
	end
	self.btnWash = nil
	if tolua.getpeer(self.btnWashAgain) ~= nil then
		tolua.setpeer(self.btnWashAgain, nil)
	end
	self.btnWashAgain = nil
	if tolua.getpeer(self.btnKeep) ~= nil then
		tolua.setpeer(self.btnKeep, nil)
	end
	self.btnKeep = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIFashionWashView