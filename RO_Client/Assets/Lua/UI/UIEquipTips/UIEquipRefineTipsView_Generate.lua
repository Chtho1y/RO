---@class UIEquipRefineTips__Generate_fx_ui_refine_success
---@field public gameObject UnityEngine.GameObject
---@field public uIParticle UIExtensions.UIParticle

---@class UIEquipRefineTips__Generate_fx_ui_refine_failure
---@field public gameObject UnityEngine.GameObject
---@field public uIParticle UIExtensions.UIParticle

---@class UIEquipRefineTips__Generate_btn_Refine
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIEquipRefineTips__Generate_chanceVal
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIEquipRefineTips__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIEquipRefineTips__Generate_boxNext_level_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class UIEquipRefineTips__Generate_boxNext_level_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class UIEquipRefineTips__Generate_boxNext_level
---@field public gameObject UnityEngine.GameObject
---@field public text UIEquipRefineTips__Generate_boxNext_level_text
---@field public number UIEquipRefineTips__Generate_boxNext_level_number

---@class UIEquipRefineTips__Generate_boxNext
---@field public gameObject UnityEngine.GameObject
---@field public level UIEquipRefineTips__Generate_boxNext_level
---@field public grid UnityEngine.GameObject

---@class UIEquipRefineTips__Generate_boxCurrent_level_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class UIEquipRefineTips__Generate_boxCurrent_level
---@field public gameObject UnityEngine.GameObject
---@field public number UIEquipRefineTips__Generate_boxCurrent_level_number

---@class UIEquipRefineTips__Generate_boxCurrent
---@field public gameObject UnityEngine.GameObject
---@field public level UIEquipRefineTips__Generate_boxCurrent_level
---@field public grid UnityEngine.GameObject

---@class UIEquipRefineTips__Generate_btn_Change
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIEquipRefineTips__Generate_textRefineLv
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIEquipRefineTips__Generate_textType
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIEquipRefineTips__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIEquipRefineTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIEquipRefineTips__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UIEquipRefineTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIEquipRefineTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIEquipRefineTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIEquipRefineTips__Generate_uIAnimator
---@field private AnyBtn UIEquipRefineTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private bg UIEquipRefineTips__Generate_bg
---@field private closeBox UnityEngine.GameObject
---@field private btnClose UIEquipRefineTips__Generate_btnClose
---@field private contentItem UnityEngine.GameObject
---@field private textName UIEquipRefineTips__Generate_textName
---@field private textType UIEquipRefineTips__Generate_textType
---@field private refineLvBox UnityEngine.GameObject
---@field private textRefineLv UIEquipRefineTips__Generate_textRefineLv
---@field private btn_Change UIEquipRefineTips__Generate_btn_Change
---@field private refineBox UnityEngine.GameObject
---@field private refine UnityEngine.GameObject
---@field private equipBaseAttrItem UnityEngine.GameObject
---@field private boxCurrent UIEquipRefineTips__Generate_boxCurrent
---@field private boxNext UIEquipRefineTips__Generate_boxNext
---@field private boxMAX UnityEngine.GameObject
---@field private level UnityEngine.GameObject
---@field private text UIEquipRefineTips__Generate_text
---@field private dscMax UnityEngine.GameObject
---@field private boxCost UnityEngine.GameObject
---@field private cost1 UnityEngine.GameObject
---@field private cost2 UnityEngine.GameObject
---@field private btnBox UnityEngine.GameObject
---@field private chance UnityEngine.GameObject
---@field private chanceVal UIEquipRefineTips__Generate_chanceVal
---@field private btn_Refine UIEquipRefineTips__Generate_btn_Refine
---@field private fx_ui_refine_failure UIEquipRefineTips__Generate_fx_ui_refine_failure
---@field private fx_ui_refine_success UIEquipRefineTips__Generate_fx_ui_refine_success
local UIEquipRefineTipsView = class("UIEquipRefineTipsView", require("UIViewBase"))

function UIEquipRefineTipsView:ctor()
end

---@private
function UIEquipRefineTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIEquipRefineTipsView:InitGenerate(Root, data)
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


end

---@private
function UIEquipRefineTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIEquipRefineTipsView:InitGenerate__2(Root, data)
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
function UIEquipRefineTipsView:InitGenerate__3(Root, data)
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
function UIEquipRefineTipsView:InitGenerate__4(Root, data)
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
function UIEquipRefineTipsView:InitGenerate__5(Root, data)
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
function UIEquipRefineTipsView:InitGenerate__6(Root, data)
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
function UIEquipRefineTipsView:InitGenerate__7(Root, data)
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
function UIEquipRefineTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/ContentItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/ContentItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contentItem = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/TextName
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/TextName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIEquipRefineTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/TypeBox/TextType
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/TypeBox/TextType").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textType = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIEquipRefineTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/RefineLvBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/RefineLvBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refineLvBox = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/TextsBox/RefineLvBox/TextRefineLv
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/TextsBox/RefineLvBox/TextRefineLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textRefineLv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIEquipRefineTipsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/Btn_Change
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/Btn_Change").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btn_Change = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIEquipRefineTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refineBox = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/Refine
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/Refine").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refine = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/Refine/EquipBaseAttrItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/Refine/EquipBaseAttrItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBaseAttrItem = CommonUtil.BindGridViewItem2LuaStatic("EquipBaseAttrItem", tmp)
	self.equipBaseAttrItem.prefabName = "EquipBaseAttrItem"
end

---@private
function UIEquipRefineTipsView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/Refine/BoxCurrent
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/Refine/BoxCurrent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxCurrent = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/Refine/BoxCurrent/Level
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/Refine/BoxCurrent/Level").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxCurrent.level = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/Refine/BoxCurrent/Level/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/Refine/BoxCurrent/Level/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxCurrent.level.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIEquipRefineTipsView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/Refine/BoxCurrent/Grid
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/Refine/BoxCurrent/Grid").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxCurrent.grid = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/Refine/BoxNext
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/Refine/BoxNext").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxNext = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/Refine/BoxNext/Level
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/Refine/BoxNext/Level").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxNext.level = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/Refine/BoxNext/Level/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/Refine/BoxNext/Level/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxNext.level.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIEquipRefineTipsView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/Refine/BoxNext/Level/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/Refine/BoxNext/Level/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxNext.level.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIEquipRefineTipsView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/Refine/BoxNext/Grid
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/Refine/BoxNext/Grid").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxNext.grid = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/Refine/BoxMAX
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/Refine/BoxMAX").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxMAX = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/Refine/BoxMAX/Level
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/Refine/BoxMAX/Level").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.level = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/Refine/BoxMAX/Level/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/Refine/BoxMAX/Level/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIEquipRefineTipsView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/DscMax
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/DscMax").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscMax = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__30(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/BoxCost
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/BoxCost").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxCost = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__31(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/BoxCost/Cost/CostItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/BoxCost/Cost/CostItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cost1 = CommonUtil.BindGridViewItem2LuaStatic("CostItem", tmp)
	self.cost1.prefabName = "CostItem"
end

---@private
function UIEquipRefineTipsView:InitGenerate__32(Root, data)
--[[
	UIAnimator/Window/Bg/RefineBox/BoxCost/Cost/CostItem1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/RefineBox/BoxCost/Cost/CostItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cost2 = CommonUtil.BindGridViewItem2LuaStatic("CostItem", tmp)
	self.cost2.prefabName = "CostItem"
end

---@private
function UIEquipRefineTipsView:InitGenerate__33(Root, data)
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
function UIEquipRefineTipsView:InitGenerate__34(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/Chance
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/Chance").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chance = tmp
end

---@private
function UIEquipRefineTipsView:InitGenerate__35(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/Chance/ChanceVal
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/Chance/ChanceVal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chanceVal = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIEquipRefineTipsView:InitGenerate__36(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/Btn_Refine
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/Btn_Refine").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btn_Refine = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIEquipRefineTipsView:InitGenerate__37(Root, data)
--[[
	FX_UI_REFINE_Failure
--]]
	local tmp = Root:Find("FX_UI_REFINE_Failure").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fx_ui_refine_failure = tmp

	tmp.uIParticle = tmp:GetComponent(Enum.TypeInfo.UIParticle)
end

---@private
function UIEquipRefineTipsView:InitGenerate__38(Root, data)
--[[
	FX_UI_REFINE_Success
--]]
	local tmp = Root:Find("FX_UI_REFINE_Success").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fx_ui_refine_success = tmp

	tmp.uIParticle = tmp:GetComponent(Enum.TypeInfo.UIParticle)
end

---@private
function UIEquipRefineTipsView:GenerateDestroy()
	if tolua.getpeer(self.boxNext.grid) ~= nil then
		tolua.setpeer(self.boxNext.grid, nil)
	end
	if tolua.getpeer(self.boxNext.level.number) ~= nil then
		tolua.setpeer(self.boxNext.level.number, nil)
	end
	if tolua.getpeer(self.boxNext.level.text) ~= nil then
		tolua.setpeer(self.boxNext.level.text, nil)
	end
	if tolua.getpeer(self.boxNext.level) ~= nil then
		tolua.setpeer(self.boxNext.level, nil)
	end
	if tolua.getpeer(self.boxCurrent.grid) ~= nil then
		tolua.setpeer(self.boxCurrent.grid, nil)
	end
	if tolua.getpeer(self.boxCurrent.level.number) ~= nil then
		tolua.setpeer(self.boxCurrent.level.number, nil)
	end
	if tolua.getpeer(self.boxCurrent.level) ~= nil then
		tolua.setpeer(self.boxCurrent.level, nil)
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
	if tolua.getpeer(self.contentItem) ~= nil then
		tolua.setpeer(self.contentItem, nil)
	end
	self.contentItem = nil
	if tolua.getpeer(self.textName) ~= nil then
		tolua.setpeer(self.textName, nil)
	end
	self.textName = nil
	if tolua.getpeer(self.textType) ~= nil then
		tolua.setpeer(self.textType, nil)
	end
	self.textType = nil
	if tolua.getpeer(self.refineLvBox) ~= nil then
		tolua.setpeer(self.refineLvBox, nil)
	end
	self.refineLvBox = nil
	if tolua.getpeer(self.textRefineLv) ~= nil then
		tolua.setpeer(self.textRefineLv, nil)
	end
	self.textRefineLv = nil
	if tolua.getpeer(self.btn_Change) ~= nil then
		tolua.setpeer(self.btn_Change, nil)
	end
	self.btn_Change = nil
	if tolua.getpeer(self.refineBox) ~= nil then
		tolua.setpeer(self.refineBox, nil)
	end
	self.refineBox = nil
	if tolua.getpeer(self.refine) ~= nil then
		tolua.setpeer(self.refine, nil)
	end
	self.refine = nil
	if self.equipBaseAttrItem.GenerateDestroy ~= nil then
		self.equipBaseAttrItem:GenerateDestroy()
	end
	if tolua.getpeer(self.equipBaseAttrItem) ~= nil then
		tolua.setpeer(self.equipBaseAttrItem, nil)
	end
	self.equipBaseAttrItem = nil
	if tolua.getpeer(self.boxCurrent) ~= nil then
		tolua.setpeer(self.boxCurrent, nil)
	end
	self.boxCurrent = nil
	if tolua.getpeer(self.boxNext) ~= nil then
		tolua.setpeer(self.boxNext, nil)
	end
	self.boxNext = nil
	if tolua.getpeer(self.boxMAX) ~= nil then
		tolua.setpeer(self.boxMAX, nil)
	end
	self.boxMAX = nil
	if tolua.getpeer(self.level) ~= nil then
		tolua.setpeer(self.level, nil)
	end
	self.level = nil
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.dscMax) ~= nil then
		tolua.setpeer(self.dscMax, nil)
	end
	self.dscMax = nil
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
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.chance) ~= nil then
		tolua.setpeer(self.chance, nil)
	end
	self.chance = nil
	if tolua.getpeer(self.chanceVal) ~= nil then
		tolua.setpeer(self.chanceVal, nil)
	end
	self.chanceVal = nil
	if tolua.getpeer(self.btn_Refine) ~= nil then
		tolua.setpeer(self.btn_Refine, nil)
	end
	self.btn_Refine = nil
	if tolua.getpeer(self.fx_ui_refine_failure) ~= nil then
		tolua.setpeer(self.fx_ui_refine_failure, nil)
	end
	self.fx_ui_refine_failure = nil
	if tolua.getpeer(self.fx_ui_refine_success) ~= nil then
		tolua.setpeer(self.fx_ui_refine_success, nil)
	end
	self.fx_ui_refine_success = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIEquipRefineTipsView