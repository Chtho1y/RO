---@class UIPveBlessTips__Generate_nextLv_count
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPveBlessTips__Generate_nextLv_dscAttr
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPveBlessTips__Generate_nextLv_color
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPveBlessTips__Generate_nextLv_lv
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPveBlessTips__Generate_nextLv_activedState
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPveBlessTips__Generate_nextLv_unactivatedState
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPveBlessTips__Generate_nextLv
---@field public gameObject UnityEngine.GameObject
---@field public unactivatedState UIPveBlessTips__Generate_nextLv_unactivatedState
---@field public activedState UIPveBlessTips__Generate_nextLv_activedState
---@field public lv UIPveBlessTips__Generate_nextLv_lv
---@field public color UIPveBlessTips__Generate_nextLv_color
---@field public dscAttr UIPveBlessTips__Generate_nextLv_dscAttr
---@field public count UIPveBlessTips__Generate_nextLv_count
---@field public scrollView UnityEngine.GameObject
---@field public cardBlessAttrItem1 UnityEngine.GameObject
---@field public cardBlessAttrItem2 UnityEngine.GameObject
---@field public cardBlessAttrItem3 UnityEngine.GameObject
---@field public cardBlessAttrItem4 UnityEngine.GameObject
---@field public cardBlessAttrItem5 UnityEngine.GameObject

---@class UIPveBlessTips__Generate_currentLv_count
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPveBlessTips__Generate_currentLv_dscAttr
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPveBlessTips__Generate_currentLv_color
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPveBlessTips__Generate_currentLv_lv
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPveBlessTips__Generate_currentLv_activedState
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPveBlessTips__Generate_currentLv_unactivatedState
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPveBlessTips__Generate_currentLv
---@field public gameObject UnityEngine.GameObject
---@field public scrollView UnityEngine.GameObject
---@field public cardBlessAttrItem1 UnityEngine.GameObject
---@field public cardBlessAttrItem2 UnityEngine.GameObject
---@field public cardBlessAttrItem3 UnityEngine.GameObject
---@field public cardBlessAttrItem4 UnityEngine.GameObject
---@field public cardBlessAttrItem5 UnityEngine.GameObject
---@field public unactivatedState UIPveBlessTips__Generate_currentLv_unactivatedState
---@field public activedState UIPveBlessTips__Generate_currentLv_activedState
---@field public lv UIPveBlessTips__Generate_currentLv_lv
---@field public color UIPveBlessTips__Generate_currentLv_color
---@field public dscAttr UIPveBlessTips__Generate_currentLv_dscAttr
---@field public count UIPveBlessTips__Generate_currentLv_count

---@class UIPveBlessTips__Generate_pveBlessLv
---@field public gameObject UnityEngine.GameObject
---@field public lv0 UnityEngine.GameObject
---@field public lv1 UnityEngine.GameObject
---@field public lv2 UnityEngine.GameObject
---@field public lv3 UnityEngine.GameObject
---@field public lv4 UnityEngine.GameObject
---@field public lv5 UnityEngine.GameObject
---@field public lv6 UnityEngine.GameObject
---@field public lv7 UnityEngine.GameObject
---@field public lv8 UnityEngine.GameObject
---@field public lv9 UnityEngine.GameObject
---@field public lv10 UnityEngine.GameObject
---@field public lv11 UnityEngine.GameObject

---@class UIPveBlessTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPveBlessTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPveBlessTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIPveBlessTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIPveBlessTips__Generate_uIAnimator
---@field private AnyBtn UIPveBlessTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UIPveBlessTips__Generate_btnClose
---@field private pveBlessLv UIPveBlessTips__Generate_pveBlessLv
---@field private currentLv UIPveBlessTips__Generate_currentLv
---@field private nextLv UIPveBlessTips__Generate_nextLv
local UIPveBlessTipsView = class("UIPveBlessTipsView", require("UIViewBase"))

function UIPveBlessTipsView:ctor()
end

---@private
function UIPveBlessTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPveBlessTipsView:InitGenerate(Root, data)
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
	self:InitGenerate__32(Root,data)
	self:InitGenerate__33(Root,data)
	self:InitGenerate__34(Root,data)
	self:InitGenerate__35(Root,data)
	self:InitGenerate__36(Root,data)
	self:InitGenerate__37(Root,data)
	self:InitGenerate__38(Root,data)
	self:InitGenerate__39(Root,data)
	self:InitGenerate__40(Root,data)
	self:InitGenerate__41(Root,data)
	self:InitGenerate__42(Root,data)
	self:InitGenerate__43(Root,data)
	self:InitGenerate__44(Root,data)


end

---@private
function UIPveBlessTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIPveBlessTipsView:InitGenerate__2(Root, data)
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
function UIPveBlessTipsView:InitGenerate__3(Root, data)
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
function UIPveBlessTipsView:InitGenerate__4(Root, data)
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
function UIPveBlessTipsView:InitGenerate__5(Root, data)
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
function UIPveBlessTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PveBlessLv
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PveBlessLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pveBlessLv = tmp
end

---@private
function UIPveBlessTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv0
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv0").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pveBlessLv.lv0 = tmp
	self.pveBlessLv.lv0:SetActive(false)
end

---@private
function UIPveBlessTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pveBlessLv.lv1 = tmp
	self.pveBlessLv.lv1:SetActive(false)
end

---@private
function UIPveBlessTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pveBlessLv.lv2 = tmp
	self.pveBlessLv.lv2:SetActive(false)
end

---@private
function UIPveBlessTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pveBlessLv.lv3 = tmp
	self.pveBlessLv.lv3:SetActive(false)
end

---@private
function UIPveBlessTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pveBlessLv.lv4 = tmp
	self.pveBlessLv.lv4:SetActive(false)
end

---@private
function UIPveBlessTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv5
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pveBlessLv.lv5 = tmp
	self.pveBlessLv.lv5:SetActive(false)
end

---@private
function UIPveBlessTipsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv6
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv6").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pveBlessLv.lv6 = tmp
	self.pveBlessLv.lv6:SetActive(false)
end

---@private
function UIPveBlessTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv7
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv7").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pveBlessLv.lv7 = tmp
	self.pveBlessLv.lv7:SetActive(false)
end

---@private
function UIPveBlessTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv8
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv8").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pveBlessLv.lv8 = tmp
	self.pveBlessLv.lv8:SetActive(false)
end

---@private
function UIPveBlessTipsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv9
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv9").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pveBlessLv.lv9 = tmp
	self.pveBlessLv.lv9:SetActive(false)
end

---@private
function UIPveBlessTipsView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv10
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv10").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pveBlessLv.lv10 = tmp
	self.pveBlessLv.lv10:SetActive(false)
end

---@private
function UIPveBlessTipsView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv11
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PveBlessLv/Lv11").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pveBlessLv.lv11 = tmp
	self.pveBlessLv.lv11:SetActive(false)
end

---@private
function UIPveBlessTipsView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/CurrentLv
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CurrentLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currentLv = tmp
end

---@private
function UIPveBlessTipsView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bg/CurrentLv/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CurrentLv/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currentLv.scrollView = tmp
end

---@private
function UIPveBlessTipsView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bg/CurrentLv/ScrollView/Viewport/Content/CardBlessAttrItem1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CurrentLv/ScrollView/Viewport/Content/CardBlessAttrItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currentLv.cardBlessAttrItem1 = CommonUtil.BindGridViewItem2LuaStatic("CardBlessAttrItem", tmp)
	self.currentLv.cardBlessAttrItem1.prefabName = "CardBlessAttrItem"
end

---@private
function UIPveBlessTipsView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bg/CurrentLv/ScrollView/Viewport/Content/CardBlessAttrItem2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CurrentLv/ScrollView/Viewport/Content/CardBlessAttrItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currentLv.cardBlessAttrItem2 = CommonUtil.BindGridViewItem2LuaStatic("CardBlessAttrItem", tmp)
	self.currentLv.cardBlessAttrItem2.prefabName = "CardBlessAttrItem"
end

---@private
function UIPveBlessTipsView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/Bg/CurrentLv/ScrollView/Viewport/Content/CardBlessAttrItem3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CurrentLv/ScrollView/Viewport/Content/CardBlessAttrItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currentLv.cardBlessAttrItem3 = CommonUtil.BindGridViewItem2LuaStatic("CardBlessAttrItem", tmp)
	self.currentLv.cardBlessAttrItem3.prefabName = "CardBlessAttrItem"
end

---@private
function UIPveBlessTipsView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/Bg/CurrentLv/ScrollView/Viewport/Content/CardBlessAttrItem4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CurrentLv/ScrollView/Viewport/Content/CardBlessAttrItem4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currentLv.cardBlessAttrItem4 = CommonUtil.BindGridViewItem2LuaStatic("CardBlessAttrItem", tmp)
	self.currentLv.cardBlessAttrItem4.prefabName = "CardBlessAttrItem"
end

---@private
function UIPveBlessTipsView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/Bg/CurrentLv/ScrollView/Viewport/Content/CardBlessAttrItem5
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CurrentLv/ScrollView/Viewport/Content/CardBlessAttrItem5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currentLv.cardBlessAttrItem5 = CommonUtil.BindGridViewItem2LuaStatic("CardBlessAttrItem", tmp)
	self.currentLv.cardBlessAttrItem5.prefabName = "CardBlessAttrItem"
end

---@private
function UIPveBlessTipsView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/Bg/CurrentLv/LvBox/UnactivatedState 
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CurrentLv/LvBox/UnactivatedState ").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currentLv.unactivatedState = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPveBlessTipsView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/Bg/CurrentLv/LvBox/ActivedState
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CurrentLv/LvBox/ActivedState").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currentLv.activedState = tmp
	self.currentLv.activedState:SetActive(false)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPveBlessTipsView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/Bg/CurrentLv/LvBox/Lv
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CurrentLv/LvBox/Lv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currentLv.lv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIPveBlessTipsView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/Bg/CurrentLv/LvBox/Lv/color
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CurrentLv/LvBox/Lv/color").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currentLv.color = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPveBlessTipsView:InitGenerate__30(Root, data)
--[[
	UIAnimator/Window/Bg/CurrentLv/LvBox/DscAttr
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CurrentLv/LvBox/DscAttr").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currentLv.dscAttr = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIPveBlessTipsView:InitGenerate__31(Root, data)
--[[
	UIAnimator/Window/Bg/CurrentLv/LvBox/Count
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CurrentLv/LvBox/Count").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currentLv.count = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIPveBlessTipsView:InitGenerate__32(Root, data)
--[[
	UIAnimator/Window/Bg/NextLv
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/NextLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextLv = tmp
end

---@private
function UIPveBlessTipsView:InitGenerate__33(Root, data)
--[[
	UIAnimator/Window/Bg/NextLv/LvBox/UnactivatedState 
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/NextLv/LvBox/UnactivatedState ").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextLv.unactivatedState = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPveBlessTipsView:InitGenerate__34(Root, data)
--[[
	UIAnimator/Window/Bg/NextLv/LvBox/ActivedState
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/NextLv/LvBox/ActivedState").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextLv.activedState = tmp
	self.nextLv.activedState:SetActive(false)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPveBlessTipsView:InitGenerate__35(Root, data)
--[[
	UIAnimator/Window/Bg/NextLv/LvBox/Lv
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/NextLv/LvBox/Lv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextLv.lv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIPveBlessTipsView:InitGenerate__36(Root, data)
--[[
	UIAnimator/Window/Bg/NextLv/LvBox/Lv/color
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/NextLv/LvBox/Lv/color").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextLv.color = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPveBlessTipsView:InitGenerate__37(Root, data)
--[[
	UIAnimator/Window/Bg/NextLv/LvBox/DscAttr
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/NextLv/LvBox/DscAttr").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextLv.dscAttr = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIPveBlessTipsView:InitGenerate__38(Root, data)
--[[
	UIAnimator/Window/Bg/NextLv/LvBox/Count
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/NextLv/LvBox/Count").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextLv.count = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIPveBlessTipsView:InitGenerate__39(Root, data)
--[[
	UIAnimator/Window/Bg/NextLv/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/NextLv/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextLv.scrollView = tmp
end

---@private
function UIPveBlessTipsView:InitGenerate__40(Root, data)
--[[
	UIAnimator/Window/Bg/NextLv/ScrollView/Viewport/Content/CardBlessAttrItem1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/NextLv/ScrollView/Viewport/Content/CardBlessAttrItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextLv.cardBlessAttrItem1 = CommonUtil.BindGridViewItem2LuaStatic("CardBlessAttrItem", tmp)
	self.nextLv.cardBlessAttrItem1.prefabName = "CardBlessAttrItem"
end

---@private
function UIPveBlessTipsView:InitGenerate__41(Root, data)
--[[
	UIAnimator/Window/Bg/NextLv/ScrollView/Viewport/Content/CardBlessAttrItem2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/NextLv/ScrollView/Viewport/Content/CardBlessAttrItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextLv.cardBlessAttrItem2 = CommonUtil.BindGridViewItem2LuaStatic("CardBlessAttrItem", tmp)
	self.nextLv.cardBlessAttrItem2.prefabName = "CardBlessAttrItem"
end

---@private
function UIPveBlessTipsView:InitGenerate__42(Root, data)
--[[
	UIAnimator/Window/Bg/NextLv/ScrollView/Viewport/Content/CardBlessAttrItem3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/NextLv/ScrollView/Viewport/Content/CardBlessAttrItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextLv.cardBlessAttrItem3 = CommonUtil.BindGridViewItem2LuaStatic("CardBlessAttrItem", tmp)
	self.nextLv.cardBlessAttrItem3.prefabName = "CardBlessAttrItem"
end

---@private
function UIPveBlessTipsView:InitGenerate__43(Root, data)
--[[
	UIAnimator/Window/Bg/NextLv/ScrollView/Viewport/Content/CardBlessAttrItem4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/NextLv/ScrollView/Viewport/Content/CardBlessAttrItem4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextLv.cardBlessAttrItem4 = CommonUtil.BindGridViewItem2LuaStatic("CardBlessAttrItem", tmp)
	self.nextLv.cardBlessAttrItem4.prefabName = "CardBlessAttrItem"
end

---@private
function UIPveBlessTipsView:InitGenerate__44(Root, data)
--[[
	UIAnimator/Window/Bg/NextLv/ScrollView/Viewport/Content/CardBlessAttrItem5
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/NextLv/ScrollView/Viewport/Content/CardBlessAttrItem5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextLv.cardBlessAttrItem5 = CommonUtil.BindGridViewItem2LuaStatic("CardBlessAttrItem", tmp)
	self.nextLv.cardBlessAttrItem5.prefabName = "CardBlessAttrItem"
end

---@private
function UIPveBlessTipsView:GenerateDestroy()
	if self.nextLv.cardBlessAttrItem5.GenerateDestroy ~= nil then
		self.nextLv.cardBlessAttrItem5:GenerateDestroy()
	end
	if tolua.getpeer(self.nextLv.cardBlessAttrItem5) ~= nil then
		tolua.setpeer(self.nextLv.cardBlessAttrItem5, nil)
	end
	if self.nextLv.cardBlessAttrItem4.GenerateDestroy ~= nil then
		self.nextLv.cardBlessAttrItem4:GenerateDestroy()
	end
	if tolua.getpeer(self.nextLv.cardBlessAttrItem4) ~= nil then
		tolua.setpeer(self.nextLv.cardBlessAttrItem4, nil)
	end
	if self.nextLv.cardBlessAttrItem3.GenerateDestroy ~= nil then
		self.nextLv.cardBlessAttrItem3:GenerateDestroy()
	end
	if tolua.getpeer(self.nextLv.cardBlessAttrItem3) ~= nil then
		tolua.setpeer(self.nextLv.cardBlessAttrItem3, nil)
	end
	if self.nextLv.cardBlessAttrItem2.GenerateDestroy ~= nil then
		self.nextLv.cardBlessAttrItem2:GenerateDestroy()
	end
	if tolua.getpeer(self.nextLv.cardBlessAttrItem2) ~= nil then
		tolua.setpeer(self.nextLv.cardBlessAttrItem2, nil)
	end
	if self.nextLv.cardBlessAttrItem1.GenerateDestroy ~= nil then
		self.nextLv.cardBlessAttrItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.nextLv.cardBlessAttrItem1) ~= nil then
		tolua.setpeer(self.nextLv.cardBlessAttrItem1, nil)
	end
	if tolua.getpeer(self.nextLv.scrollView) ~= nil then
		tolua.setpeer(self.nextLv.scrollView, nil)
	end
	if tolua.getpeer(self.nextLv.count) ~= nil then
		tolua.setpeer(self.nextLv.count, nil)
	end
	if tolua.getpeer(self.nextLv.dscAttr) ~= nil then
		tolua.setpeer(self.nextLv.dscAttr, nil)
	end
	if tolua.getpeer(self.nextLv.color) ~= nil then
		tolua.setpeer(self.nextLv.color, nil)
	end
	if tolua.getpeer(self.nextLv.lv) ~= nil then
		tolua.setpeer(self.nextLv.lv, nil)
	end
	if tolua.getpeer(self.nextLv.activedState) ~= nil then
		tolua.setpeer(self.nextLv.activedState, nil)
	end
	if tolua.getpeer(self.nextLv.unactivatedState) ~= nil then
		tolua.setpeer(self.nextLv.unactivatedState, nil)
	end
	if tolua.getpeer(self.currentLv.count) ~= nil then
		tolua.setpeer(self.currentLv.count, nil)
	end
	if tolua.getpeer(self.currentLv.dscAttr) ~= nil then
		tolua.setpeer(self.currentLv.dscAttr, nil)
	end
	if tolua.getpeer(self.currentLv.color) ~= nil then
		tolua.setpeer(self.currentLv.color, nil)
	end
	if tolua.getpeer(self.currentLv.lv) ~= nil then
		tolua.setpeer(self.currentLv.lv, nil)
	end
	if tolua.getpeer(self.currentLv.activedState) ~= nil then
		tolua.setpeer(self.currentLv.activedState, nil)
	end
	if tolua.getpeer(self.currentLv.unactivatedState) ~= nil then
		tolua.setpeer(self.currentLv.unactivatedState, nil)
	end
	if self.currentLv.cardBlessAttrItem5.GenerateDestroy ~= nil then
		self.currentLv.cardBlessAttrItem5:GenerateDestroy()
	end
	if tolua.getpeer(self.currentLv.cardBlessAttrItem5) ~= nil then
		tolua.setpeer(self.currentLv.cardBlessAttrItem5, nil)
	end
	if self.currentLv.cardBlessAttrItem4.GenerateDestroy ~= nil then
		self.currentLv.cardBlessAttrItem4:GenerateDestroy()
	end
	if tolua.getpeer(self.currentLv.cardBlessAttrItem4) ~= nil then
		tolua.setpeer(self.currentLv.cardBlessAttrItem4, nil)
	end
	if self.currentLv.cardBlessAttrItem3.GenerateDestroy ~= nil then
		self.currentLv.cardBlessAttrItem3:GenerateDestroy()
	end
	if tolua.getpeer(self.currentLv.cardBlessAttrItem3) ~= nil then
		tolua.setpeer(self.currentLv.cardBlessAttrItem3, nil)
	end
	if self.currentLv.cardBlessAttrItem2.GenerateDestroy ~= nil then
		self.currentLv.cardBlessAttrItem2:GenerateDestroy()
	end
	if tolua.getpeer(self.currentLv.cardBlessAttrItem2) ~= nil then
		tolua.setpeer(self.currentLv.cardBlessAttrItem2, nil)
	end
	if self.currentLv.cardBlessAttrItem1.GenerateDestroy ~= nil then
		self.currentLv.cardBlessAttrItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.currentLv.cardBlessAttrItem1) ~= nil then
		tolua.setpeer(self.currentLv.cardBlessAttrItem1, nil)
	end
	if tolua.getpeer(self.currentLv.scrollView) ~= nil then
		tolua.setpeer(self.currentLv.scrollView, nil)
	end
	if tolua.getpeer(self.pveBlessLv.lv11) ~= nil then
		tolua.setpeer(self.pveBlessLv.lv11, nil)
	end
	if tolua.getpeer(self.pveBlessLv.lv10) ~= nil then
		tolua.setpeer(self.pveBlessLv.lv10, nil)
	end
	if tolua.getpeer(self.pveBlessLv.lv9) ~= nil then
		tolua.setpeer(self.pveBlessLv.lv9, nil)
	end
	if tolua.getpeer(self.pveBlessLv.lv8) ~= nil then
		tolua.setpeer(self.pveBlessLv.lv8, nil)
	end
	if tolua.getpeer(self.pveBlessLv.lv7) ~= nil then
		tolua.setpeer(self.pveBlessLv.lv7, nil)
	end
	if tolua.getpeer(self.pveBlessLv.lv6) ~= nil then
		tolua.setpeer(self.pveBlessLv.lv6, nil)
	end
	if tolua.getpeer(self.pveBlessLv.lv5) ~= nil then
		tolua.setpeer(self.pveBlessLv.lv5, nil)
	end
	if tolua.getpeer(self.pveBlessLv.lv4) ~= nil then
		tolua.setpeer(self.pveBlessLv.lv4, nil)
	end
	if tolua.getpeer(self.pveBlessLv.lv3) ~= nil then
		tolua.setpeer(self.pveBlessLv.lv3, nil)
	end
	if tolua.getpeer(self.pveBlessLv.lv2) ~= nil then
		tolua.setpeer(self.pveBlessLv.lv2, nil)
	end
	if tolua.getpeer(self.pveBlessLv.lv1) ~= nil then
		tolua.setpeer(self.pveBlessLv.lv1, nil)
	end
	if tolua.getpeer(self.pveBlessLv.lv0) ~= nil then
		tolua.setpeer(self.pveBlessLv.lv0, nil)
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
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.pveBlessLv) ~= nil then
		tolua.setpeer(self.pveBlessLv, nil)
	end
	self.pveBlessLv = nil
	if tolua.getpeer(self.currentLv) ~= nil then
		tolua.setpeer(self.currentLv, nil)
	end
	self.currentLv = nil
	if tolua.getpeer(self.nextLv) ~= nil then
		tolua.setpeer(self.nextLv, nil)
	end
	self.nextLv = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPveBlessTipsView