---@class UIArtifactTips__Generate_fx_ui_refine_success
---@field public gameObject UnityEngine.GameObject
---@field public uIParticle UIExtensions.UIParticle

---@class UIArtifactTips__Generate_btnRefine
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactTips__Generate_cost2_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactTips__Generate_cost2_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIArtifactTips__Generate_cost2
---@field public gameObject UnityEngine.GameObject
---@field public icon UIArtifactTips__Generate_cost2_icon
---@field public text UIArtifactTips__Generate_cost2_text

---@class UIArtifactTips__Generate_cost1_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactTips__Generate_cost1_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIArtifactTips__Generate_cost1
---@field public gameObject UnityEngine.GameObject
---@field public icon UIArtifactTips__Generate_cost1_icon
---@field public text UIArtifactTips__Generate_cost1_text

---@class UIArtifactTips__Generate_rule
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactTips__Generate_slotNum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactTips__Generate_slotLv
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactTips__Generate_artifactPropertyItem5
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactTips__Generate_artifactPropertyItem4
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactTips__Generate_artifactPropertyItem3
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactTips__Generate_artifactPropertyItem2
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactTips__Generate_artifactPropertyItem1
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactTips__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactTips__Generate_heroName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactTips__Generate_jobIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIArtifactTips__Generate_btnChange
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactTips__Generate_type1_text2
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactTips__Generate_type1
---@field public gameObject UnityEngine.GameObject
---@field public text2 UIArtifactTips__Generate_type1_text2

---@class UIArtifactTips__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactTips__Generate_skillEquipSlot
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIArtifactTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIEventHandler UIEventHandler
---@field private uIAnimator UIArtifactTips__Generate_uIAnimator
---@field private AnyBtn UIArtifactTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private closeBox UnityEngine.GameObject
---@field private btnClose UIArtifactTips__Generate_btnClose
---@field private contentItem UnityEngine.GameObject
---@field private skillEquipSlot UIArtifactTips__Generate_skillEquipSlot
---@field private textName UIArtifactTips__Generate_textName
---@field private type1 UIArtifactTips__Generate_type1
---@field private btnChange UIArtifactTips__Generate_btnChange
---@field private labelBox UnityEngine.GameObject
---@field private jobIcon UIArtifactTips__Generate_jobIcon
---@field private heroName UIArtifactTips__Generate_heroName
---@field private desTxt UIArtifactTips__Generate_desTxt
---@field private property UnityEngine.GameObject
---@field private artifactPropertyItem1 UIArtifactTips__Generate_artifactPropertyItem1
---@field private artifactPropertyItem2 UIArtifactTips__Generate_artifactPropertyItem2
---@field private artifactPropertyItem3 UIArtifactTips__Generate_artifactPropertyItem3
---@field private artifactPropertyItem4 UIArtifactTips__Generate_artifactPropertyItem4
---@field private artifactPropertyItem5 UIArtifactTips__Generate_artifactPropertyItem5
---@field private bottomBox UnityEngine.GameObject
---@field private slotLvRoot UnityEngine.GameObject
---@field private slotLv UIArtifactTips__Generate_slotLv
---@field private slotNum UIArtifactTips__Generate_slotNum
---@field private rule UIArtifactTips__Generate_rule
---@field private cost UnityEngine.GameObject
---@field private cost1 UIArtifactTips__Generate_cost1
---@field private cost2 UIArtifactTips__Generate_cost2
---@field private btnBox UnityEngine.GameObject
---@field private btnRefine UIArtifactTips__Generate_btnRefine
---@field private redPointItem UnityEngine.GameObject
---@field private fx_ui_refine_success UIArtifactTips__Generate_fx_ui_refine_success
local UIArtifactTipsView = class("UIArtifactTipsView", require("UIViewBase"))

function UIArtifactTipsView:ctor()
end

---@private
function UIArtifactTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIArtifactTipsView:InitGenerate(Root, data)
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
function UIArtifactTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.uIEventHandler = Root:GetComponent(Enum.TypeInfo.UIEventHandler)
end

---@private
function UIArtifactTipsView:InitGenerate__2(Root, data)
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
function UIArtifactTipsView:InitGenerate__3(Root, data)
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
function UIArtifactTipsView:InitGenerate__4(Root, data)
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
function UIArtifactTipsView:InitGenerate__5(Root, data)
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
function UIArtifactTipsView:InitGenerate__6(Root, data)
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
function UIArtifactTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/ContentItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/ContentItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contentItem = tmp
end

---@private
function UIArtifactTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/ContentItem/EquipSlotItemNew
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/ContentItem/EquipSlotItemNew").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillEquipSlot = CommonUtil.BindGridViewItem2LuaStatic("EquipSlotItemNew", tmp)
	self.skillEquipSlot.prefabName = "EquipSlotItemNew"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIArtifactTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/Texts/TextName
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/Texts/TextName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIArtifactTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.type1 = tmp
end

---@private
function UIArtifactTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type1/Text2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type1/Text2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.type1.text2 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIArtifactTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/BtnChange
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/BtnChange").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChange = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIArtifactTipsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/LabelBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/LabelBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelBox = tmp
end

---@private
function UIArtifactTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/LabelBox/JobIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/LabelBox/JobIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.jobIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIArtifactTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/LabelBox/heroName
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/LabelBox/heroName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.heroName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIArtifactTipsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox/DesTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIArtifactTipsView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/Property
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property = tmp
end

---@private
function UIArtifactTipsView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/Property/Group/ArtifactPropertyItem1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property/Group/ArtifactPropertyItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactPropertyItem1 = CommonUtil.BindGridViewItem2LuaStatic("ArtifactPropertyItem", tmp)
	self.artifactPropertyItem1.prefabName = "ArtifactPropertyItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIArtifactTipsView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/Property/Group/ArtifactPropertyItem2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property/Group/ArtifactPropertyItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactPropertyItem2 = CommonUtil.BindGridViewItem2LuaStatic("ArtifactPropertyItem", tmp)
	self.artifactPropertyItem2.prefabName = "ArtifactPropertyItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIArtifactTipsView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bg/Property/Group/ArtifactPropertyItem3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property/Group/ArtifactPropertyItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactPropertyItem3 = CommonUtil.BindGridViewItem2LuaStatic("ArtifactPropertyItem", tmp)
	self.artifactPropertyItem3.prefabName = "ArtifactPropertyItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIArtifactTipsView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bg/Property/Group/ArtifactPropertyItem4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property/Group/ArtifactPropertyItem4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactPropertyItem4 = CommonUtil.BindGridViewItem2LuaStatic("ArtifactPropertyItem", tmp)
	self.artifactPropertyItem4.prefabName = "ArtifactPropertyItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIArtifactTipsView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bg/Property/Group/ArtifactPropertyItem5
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property/Group/ArtifactPropertyItem5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactPropertyItem5 = CommonUtil.BindGridViewItem2LuaStatic("ArtifactPropertyItem", tmp)
	self.artifactPropertyItem5.prefabName = "ArtifactPropertyItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIArtifactTipsView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottomBox = tmp
end

---@private
function UIArtifactTipsView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/Image
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slotLvRoot = tmp
end

---@private
function UIArtifactTipsView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/Image/Image/Text/slotLv
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/Image/Image/Text/slotLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slotLv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIArtifactTipsView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/Image/Image/Text/slotNum
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/Image/Image/Text/slotNum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slotNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIArtifactTipsView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/Image/Image/rule
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/Image/Image/rule").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rule = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIArtifactTipsView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/cost
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/cost").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cost = tmp
end

---@private
function UIArtifactTipsView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/cost/cost1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/cost/cost1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cost1 = tmp
end

---@private
function UIArtifactTipsView:InitGenerate__30(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/cost/cost1/icon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/cost/cost1/icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cost1.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIArtifactTipsView:InitGenerate__31(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/cost/cost1/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/cost/cost1/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cost1.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIArtifactTipsView:InitGenerate__32(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/cost/cost2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/cost/cost2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cost2 = tmp
end

---@private
function UIArtifactTipsView:InitGenerate__33(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/cost/cost2/icon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/cost/cost2/icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cost2.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIArtifactTipsView:InitGenerate__34(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/cost/cost2/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/cost/cost2/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cost2.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIArtifactTipsView:InitGenerate__35(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/BtnBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/BtnBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBox = tmp
end

---@private
function UIArtifactTipsView:InitGenerate__36(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/BtnBox/BtnRefine
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/BtnBox/BtnRefine").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRefine = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIArtifactTipsView:InitGenerate__37(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/BtnBox/BtnRefine/RedPointItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/BtnBox/BtnRefine/RedPointItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redPointItem = CommonUtil.BindGridViewItem2LuaStatic("RedPointItem", tmp)
	self.redPointItem.prefabName = "RedPointItem"
end

---@private
function UIArtifactTipsView:InitGenerate__38(Root, data)
--[[
	UIAnimator/FX_UI_REFINE_Success
--]]
	local tmp = Root:Find("UIAnimator/FX_UI_REFINE_Success").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fx_ui_refine_success = tmp

	tmp.uIParticle = tmp:GetComponent(Enum.TypeInfo.UIParticle)
end

---@private
function UIArtifactTipsView:GenerateDestroy()
	if tolua.getpeer(self.cost2.text) ~= nil then
		tolua.setpeer(self.cost2.text, nil)
	end
	if tolua.getpeer(self.cost2.icon) ~= nil then
		tolua.setpeer(self.cost2.icon, nil)
	end
	if tolua.getpeer(self.cost1.text) ~= nil then
		tolua.setpeer(self.cost1.text, nil)
	end
	if tolua.getpeer(self.cost1.icon) ~= nil then
		tolua.setpeer(self.cost1.icon, nil)
	end
	if tolua.getpeer(self.type1.text2) ~= nil then
		tolua.setpeer(self.type1.text2, nil)
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
	if self.skillEquipSlot.GenerateDestroy ~= nil then
		self.skillEquipSlot:GenerateDestroy()
	end
	if tolua.getpeer(self.skillEquipSlot) ~= nil then
		tolua.setpeer(self.skillEquipSlot, nil)
	end
	self.skillEquipSlot = nil
	if tolua.getpeer(self.textName) ~= nil then
		tolua.setpeer(self.textName, nil)
	end
	self.textName = nil
	if tolua.getpeer(self.type1) ~= nil then
		tolua.setpeer(self.type1, nil)
	end
	self.type1 = nil
	if tolua.getpeer(self.btnChange) ~= nil then
		tolua.setpeer(self.btnChange, nil)
	end
	self.btnChange = nil
	if tolua.getpeer(self.labelBox) ~= nil then
		tolua.setpeer(self.labelBox, nil)
	end
	self.labelBox = nil
	if tolua.getpeer(self.jobIcon) ~= nil then
		tolua.setpeer(self.jobIcon, nil)
	end
	self.jobIcon = nil
	if tolua.getpeer(self.heroName) ~= nil then
		tolua.setpeer(self.heroName, nil)
	end
	self.heroName = nil
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	if tolua.getpeer(self.property) ~= nil then
		tolua.setpeer(self.property, nil)
	end
	self.property = nil
	if self.artifactPropertyItem1.GenerateDestroy ~= nil then
		self.artifactPropertyItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.artifactPropertyItem1) ~= nil then
		tolua.setpeer(self.artifactPropertyItem1, nil)
	end
	self.artifactPropertyItem1 = nil
	if self.artifactPropertyItem2.GenerateDestroy ~= nil then
		self.artifactPropertyItem2:GenerateDestroy()
	end
	if tolua.getpeer(self.artifactPropertyItem2) ~= nil then
		tolua.setpeer(self.artifactPropertyItem2, nil)
	end
	self.artifactPropertyItem2 = nil
	if self.artifactPropertyItem3.GenerateDestroy ~= nil then
		self.artifactPropertyItem3:GenerateDestroy()
	end
	if tolua.getpeer(self.artifactPropertyItem3) ~= nil then
		tolua.setpeer(self.artifactPropertyItem3, nil)
	end
	self.artifactPropertyItem3 = nil
	if self.artifactPropertyItem4.GenerateDestroy ~= nil then
		self.artifactPropertyItem4:GenerateDestroy()
	end
	if tolua.getpeer(self.artifactPropertyItem4) ~= nil then
		tolua.setpeer(self.artifactPropertyItem4, nil)
	end
	self.artifactPropertyItem4 = nil
	if self.artifactPropertyItem5.GenerateDestroy ~= nil then
		self.artifactPropertyItem5:GenerateDestroy()
	end
	if tolua.getpeer(self.artifactPropertyItem5) ~= nil then
		tolua.setpeer(self.artifactPropertyItem5, nil)
	end
	self.artifactPropertyItem5 = nil
	if tolua.getpeer(self.bottomBox) ~= nil then
		tolua.setpeer(self.bottomBox, nil)
	end
	self.bottomBox = nil
	if tolua.getpeer(self.slotLvRoot) ~= nil then
		tolua.setpeer(self.slotLvRoot, nil)
	end
	self.slotLvRoot = nil
	if tolua.getpeer(self.slotLv) ~= nil then
		tolua.setpeer(self.slotLv, nil)
	end
	self.slotLv = nil
	if tolua.getpeer(self.slotNum) ~= nil then
		tolua.setpeer(self.slotNum, nil)
	end
	self.slotNum = nil
	if tolua.getpeer(self.rule) ~= nil then
		tolua.setpeer(self.rule, nil)
	end
	self.rule = nil
	if tolua.getpeer(self.cost) ~= nil then
		tolua.setpeer(self.cost, nil)
	end
	self.cost = nil
	if tolua.getpeer(self.cost1) ~= nil then
		tolua.setpeer(self.cost1, nil)
	end
	self.cost1 = nil
	if tolua.getpeer(self.cost2) ~= nil then
		tolua.setpeer(self.cost2, nil)
	end
	self.cost2 = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.btnRefine) ~= nil then
		tolua.setpeer(self.btnRefine, nil)
	end
	self.btnRefine = nil
	if self.redPointItem.GenerateDestroy ~= nil then
		self.redPointItem:GenerateDestroy()
	end
	if tolua.getpeer(self.redPointItem) ~= nil then
		tolua.setpeer(self.redPointItem, nil)
	end
	self.redPointItem = nil
	if tolua.getpeer(self.fx_ui_refine_success) ~= nil then
		tolua.setpeer(self.fx_ui_refine_success, nil)
	end
	self.fx_ui_refine_success = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIArtifactTipsView