---@class UIPetStampBlessTips__Generate_nextLv_color
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPetStampBlessTips__Generate_nextLv_lv
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPetStampBlessTips__Generate_nextLv_activedState
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPetStampBlessTips__Generate_nextLv_unactivatedState
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPetStampBlessTips__Generate_nextLv
---@field public gameObject UnityEngine.GameObject
---@field public unactivatedState UIPetStampBlessTips__Generate_nextLv_unactivatedState
---@field public activedState UIPetStampBlessTips__Generate_nextLv_activedState
---@field public lv UIPetStampBlessTips__Generate_nextLv_lv
---@field public color UIPetStampBlessTips__Generate_nextLv_color
---@field public scrollView UnityEngine.GameObject
---@field public cardBlessAttrItem1 UnityEngine.GameObject
---@field public cardBlessAttrItem2 UnityEngine.GameObject
---@field public cardBlessAttrItem3 UnityEngine.GameObject
---@field public cardBlessAttrItem4 UnityEngine.GameObject
---@field public cardBlessAttrItem5 UnityEngine.GameObject

---@class UIPetStampBlessTips__Generate_currentLv_color
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPetStampBlessTips__Generate_currentLv_lv
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPetStampBlessTips__Generate_currentLv_activedState
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPetStampBlessTips__Generate_currentLv_unactivatedState
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPetStampBlessTips__Generate_currentLv
---@field public gameObject UnityEngine.GameObject
---@field public scrollView UnityEngine.GameObject
---@field public cardBlessAttrItem1 UnityEngine.GameObject
---@field public cardBlessAttrItem2 UnityEngine.GameObject
---@field public cardBlessAttrItem3 UnityEngine.GameObject
---@field public cardBlessAttrItem4 UnityEngine.GameObject
---@field public cardBlessAttrItem5 UnityEngine.GameObject
---@field public unactivatedState UIPetStampBlessTips__Generate_currentLv_unactivatedState
---@field public activedState UIPetStampBlessTips__Generate_currentLv_activedState
---@field public lv UIPetStampBlessTips__Generate_currentLv_lv
---@field public color UIPetStampBlessTips__Generate_currentLv_color

---@class UIPetStampBlessTips__Generate_cardBlessLv
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

---@class UIPetStampBlessTips__Generate_petBlessLv_slot6
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPetStampBlessTips__Generate_petBlessLv_slot5
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPetStampBlessTips__Generate_petBlessLv_slot4
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPetStampBlessTips__Generate_petBlessLv_slot3
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPetStampBlessTips__Generate_petBlessLv_slot2
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPetStampBlessTips__Generate_petBlessLv_slot1
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPetStampBlessTips__Generate_petBlessLv
---@field public gameObject UnityEngine.GameObject
---@field public lightPurple UnityEngine.GameObject
---@field public lightGreen UnityEngine.GameObject
---@field public lightBlue UnityEngine.GameObject
---@field public lightGold UnityEngine.GameObject
---@field public lightRed UnityEngine.GameObject
---@field public slot1 UIPetStampBlessTips__Generate_petBlessLv_slot1
---@field public slot2 UIPetStampBlessTips__Generate_petBlessLv_slot2
---@field public slot3 UIPetStampBlessTips__Generate_petBlessLv_slot3
---@field public slot4 UIPetStampBlessTips__Generate_petBlessLv_slot4
---@field public slot5 UIPetStampBlessTips__Generate_petBlessLv_slot5
---@field public slot6 UIPetStampBlessTips__Generate_petBlessLv_slot6

---@class UIPetStampBlessTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetStampBlessTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetStampBlessTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIPetStampBlessTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIPetStampBlessTips__Generate_uIAnimator
---@field private AnyBtn UIPetStampBlessTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UIPetStampBlessTips__Generate_btnClose
---@field private petBlessLv UIPetStampBlessTips__Generate_petBlessLv
---@field private cardBlessLv UIPetStampBlessTips__Generate_cardBlessLv
---@field private currentLv UIPetStampBlessTips__Generate_currentLv
---@field private nextLv UIPetStampBlessTips__Generate_nextLv
local UIPetStampBlessTipsView = class("UIPetStampBlessTipsView", require("UIViewBase"))

function UIPetStampBlessTipsView:ctor()
end

---@private
function UIPetStampBlessTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPetStampBlessTipsView:InitGenerate(Root, data)
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
	self:InitGenerate__45(Root,data)
	self:InitGenerate__46(Root,data)
	self:InitGenerate__47(Root,data)
	self:InitGenerate__48(Root,data)
	self:InitGenerate__49(Root,data)
	self:InitGenerate__50(Root,data)
	self:InitGenerate__51(Root,data)
	self:InitGenerate__52(Root,data)


end

---@private
function UIPetStampBlessTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIPetStampBlessTipsView:InitGenerate__2(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__3(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__4(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__5(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PetBlessLv
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PetBlessLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petBlessLv = tmp
end

---@private
function UIPetStampBlessTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PetBlessLv/LightPurple
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PetBlessLv/LightPurple").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petBlessLv.lightPurple = tmp
end

---@private
function UIPetStampBlessTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PetBlessLv/LightGreen
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PetBlessLv/LightGreen").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petBlessLv.lightGreen = tmp
end

---@private
function UIPetStampBlessTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PetBlessLv/LightBlue
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PetBlessLv/LightBlue").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petBlessLv.lightBlue = tmp
end

---@private
function UIPetStampBlessTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PetBlessLv/LightGold
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PetBlessLv/LightGold").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petBlessLv.lightGold = tmp
end

---@private
function UIPetStampBlessTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PetBlessLv/LightRed
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PetBlessLv/LightRed").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petBlessLv.lightRed = tmp
end

---@private
function UIPetStampBlessTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PetBlessLv/Slot1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PetBlessLv/Slot1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petBlessLv.slot1 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PetBlessLv/Slot2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PetBlessLv/Slot2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petBlessLv.slot2 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PetBlessLv/Slot3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PetBlessLv/Slot3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petBlessLv.slot3 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PetBlessLv/Slot4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PetBlessLv/Slot4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petBlessLv.slot4 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PetBlessLv/Slot5
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PetBlessLv/Slot5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petBlessLv.slot5 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/PetBlessLv/Slot6
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/PetBlessLv/Slot6").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petBlessLv.slot6 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv = tmp
end

---@private
function UIPetStampBlessTipsView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv0
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv0").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv0 = tmp
	self.cardBlessLv.lv0:SetActive(false)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv1 = tmp
	self.cardBlessLv.lv1:SetActive(false)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv2 = tmp
	self.cardBlessLv.lv2:SetActive(false)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv3 = tmp
	self.cardBlessLv.lv3:SetActive(false)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv4 = tmp
	self.cardBlessLv.lv4:SetActive(false)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv5
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv5 = tmp
	self.cardBlessLv.lv5:SetActive(false)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv6
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv6").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv6 = tmp
	self.cardBlessLv.lv6:SetActive(false)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv7
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv7").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv7 = tmp
	self.cardBlessLv.lv7:SetActive(false)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv8
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv8").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv8 = tmp
	self.cardBlessLv.lv8:SetActive(false)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv9
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv9").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv9 = tmp
	self.cardBlessLv.lv9:SetActive(false)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv10
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv10").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv10 = tmp
	self.cardBlessLv.lv10:SetActive(false)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__30(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv11
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv11").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv11 = tmp
	self.cardBlessLv.lv11:SetActive(false)
end

---@private
function UIPetStampBlessTipsView:InitGenerate__31(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__32(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__33(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__34(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__35(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__36(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__37(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__38(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__39(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__40(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__41(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__42(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__43(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__44(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__45(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__46(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__47(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__48(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__49(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__50(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__51(Root, data)
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
function UIPetStampBlessTipsView:InitGenerate__52(Root, data)
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
function UIPetStampBlessTipsView:GenerateDestroy()
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
	if tolua.getpeer(self.cardBlessLv.lv11) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv11, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv10) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv10, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv9) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv9, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv8) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv8, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv7) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv7, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv6) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv6, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv5) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv5, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv4) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv4, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv3) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv3, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv2) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv2, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv1) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv1, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv0) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv0, nil)
	end
	if tolua.getpeer(self.petBlessLv.slot6) ~= nil then
		tolua.setpeer(self.petBlessLv.slot6, nil)
	end
	if tolua.getpeer(self.petBlessLv.slot5) ~= nil then
		tolua.setpeer(self.petBlessLv.slot5, nil)
	end
	if tolua.getpeer(self.petBlessLv.slot4) ~= nil then
		tolua.setpeer(self.petBlessLv.slot4, nil)
	end
	if tolua.getpeer(self.petBlessLv.slot3) ~= nil then
		tolua.setpeer(self.petBlessLv.slot3, nil)
	end
	if tolua.getpeer(self.petBlessLv.slot2) ~= nil then
		tolua.setpeer(self.petBlessLv.slot2, nil)
	end
	if tolua.getpeer(self.petBlessLv.slot1) ~= nil then
		tolua.setpeer(self.petBlessLv.slot1, nil)
	end
	if tolua.getpeer(self.petBlessLv.lightRed) ~= nil then
		tolua.setpeer(self.petBlessLv.lightRed, nil)
	end
	if tolua.getpeer(self.petBlessLv.lightGold) ~= nil then
		tolua.setpeer(self.petBlessLv.lightGold, nil)
	end
	if tolua.getpeer(self.petBlessLv.lightBlue) ~= nil then
		tolua.setpeer(self.petBlessLv.lightBlue, nil)
	end
	if tolua.getpeer(self.petBlessLv.lightGreen) ~= nil then
		tolua.setpeer(self.petBlessLv.lightGreen, nil)
	end
	if tolua.getpeer(self.petBlessLv.lightPurple) ~= nil then
		tolua.setpeer(self.petBlessLv.lightPurple, nil)
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
	if tolua.getpeer(self.petBlessLv) ~= nil then
		tolua.setpeer(self.petBlessLv, nil)
	end
	self.petBlessLv = nil
	if tolua.getpeer(self.cardBlessLv) ~= nil then
		tolua.setpeer(self.cardBlessLv, nil)
	end
	self.cardBlessLv = nil
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
return UIPetStampBlessTipsView