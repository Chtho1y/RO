---@class UIArtifactStarUp__Generate_fx_ui_refine_success
---@field public gameObject UnityEngine.GameObject
---@field public uIParticle UIExtensions.UIParticle

---@class UIArtifactStarUp__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactStarUp__Generate_btnRefine
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactStarUp__Generate_costDsc
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIArtifactStarUp__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIArtifactStarUp__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIArtifactStarUp__Generate_upDsc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactStarUp__Generate_starGrp2_star5
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class UIArtifactStarUp__Generate_starGrp2_star4
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class UIArtifactStarUp__Generate_starGrp2_star3
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class UIArtifactStarUp__Generate_starGrp2_star2
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class UIArtifactStarUp__Generate_starGrp2_star1
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class UIArtifactStarUp__Generate_starGrp2
---@field public gameObject UnityEngine.GameObject
---@field public star1 UIArtifactStarUp__Generate_starGrp2_star1
---@field public star2 UIArtifactStarUp__Generate_starGrp2_star2
---@field public star3 UIArtifactStarUp__Generate_starGrp2_star3
---@field public star4 UIArtifactStarUp__Generate_starGrp2_star4
---@field public star5 UIArtifactStarUp__Generate_starGrp2_star5

---@class UIArtifactStarUp__Generate_starGrp1_star5
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class UIArtifactStarUp__Generate_starGrp1_star4
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class UIArtifactStarUp__Generate_starGrp1_star3
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class UIArtifactStarUp__Generate_starGrp1_star2
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class UIArtifactStarUp__Generate_starGrp1_star1
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class UIArtifactStarUp__Generate_starGrp1
---@field public gameObject UnityEngine.GameObject
---@field public star1 UIArtifactStarUp__Generate_starGrp1_star1
---@field public star2 UIArtifactStarUp__Generate_starGrp1_star2
---@field public star3 UIArtifactStarUp__Generate_starGrp1_star3
---@field public star4 UIArtifactStarUp__Generate_starGrp1_star4
---@field public star5 UIArtifactStarUp__Generate_starGrp1_star5

---@class UIArtifactStarUp__Generate_heroName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactStarUp__Generate_jobIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIArtifactStarUp__Generate_type1_text2
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactStarUp__Generate_type1
---@field public gameObject UnityEngine.GameObject
---@field public text2 UIArtifactStarUp__Generate_type1_text2

---@class UIArtifactStarUp__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactStarUp__Generate_skillEquipSlot
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactStarUp__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactStarUp__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactStarUp__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIArtifactStarUp__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIArtifactStarUp__Generate_uIAnimator
---@field private AnyBtn UIArtifactStarUp__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private closeBox UnityEngine.GameObject
---@field private btnClose UIArtifactStarUp__Generate_btnClose
---@field private contentItem UnityEngine.GameObject
---@field private skillEquipSlot UIArtifactStarUp__Generate_skillEquipSlot
---@field private textName UIArtifactStarUp__Generate_textName
---@field private type1 UIArtifactStarUp__Generate_type1
---@field private jobIcon UIArtifactStarUp__Generate_jobIcon
---@field private heroName UIArtifactStarUp__Generate_heroName
---@field private starGrp1 UIArtifactStarUp__Generate_starGrp1
---@field private starGrp2 UIArtifactStarUp__Generate_starGrp2
---@field private upDsc UIArtifactStarUp__Generate_upDsc
---@field private scrollView UIArtifactStarUp__Generate_scrollView
---@field private iconItem UIArtifactStarUp__Generate_iconItem
---@field private costDsc UIArtifactStarUp__Generate_costDsc
---@field private bottomBox UnityEngine.GameObject
---@field private btnBox UnityEngine.GameObject
---@field private btnRefine UIArtifactStarUp__Generate_btnRefine
---@field private number UIArtifactStarUp__Generate_number
---@field private redPointItem UnityEngine.GameObject
---@field private fx_ui_refine_success UIArtifactStarUp__Generate_fx_ui_refine_success
local UIArtifactStarUpView = class("UIArtifactStarUpView", require("UIViewBase"))

function UIArtifactStarUpView:ctor()
end

---@private
function UIArtifactStarUpView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIArtifactStarUpView:InitGenerate(Root, data)
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
function UIArtifactStarUpView:InitGenerate__1(Root, data)
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
function UIArtifactStarUpView:InitGenerate__2(Root, data)
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
function UIArtifactStarUpView:InitGenerate__3(Root, data)
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
function UIArtifactStarUpView:InitGenerate__4(Root, data)
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
function UIArtifactStarUpView:InitGenerate__5(Root, data)
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
function UIArtifactStarUpView:InitGenerate__6(Root, data)
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
function UIArtifactStarUpView:InitGenerate__7(Root, data)
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
function UIArtifactStarUpView:InitGenerate__8(Root, data)
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
function UIArtifactStarUpView:InitGenerate__9(Root, data)
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
function UIArtifactStarUpView:InitGenerate__10(Root, data)
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
function UIArtifactStarUpView:InitGenerate__11(Root, data)
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
function UIArtifactStarUpView:InitGenerate__12(Root, data)
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
function UIArtifactStarUpView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp1 = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp1.star1 = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star1/star
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star1/star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp1.star1.star = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp1.star2 = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star2/star
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star2/star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp1.star2.star = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp1.star3 = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star3/star
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star3/star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp1.star3.star = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp1.star4 = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star4/star
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star4/star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp1.star4.star = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star5
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp1.star5 = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star5/star
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp1/Star5/star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp1.star5.star = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp2 = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp2.star1 = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star1/star
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star1/star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp2.star1.star = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp2.star2 = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star2/star
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star2/star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp2.star2.star = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp2.star3 = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__30(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star3/star
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star3/star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp2.star3.star = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__31(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp2.star4 = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__32(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star4/star
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star4/star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp2.star4.star = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__33(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star5
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp2.star5 = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__34(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star5/star
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarGrp2/Star5/star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starGrp2.star5.star = tmp
end

---@private
function UIArtifactStarUpView:InitGenerate__35(Root, data)
--[[
	UIAnimator/Window/Bg/StarPreview/Bg/StarUpPreview/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/StarPreview/Bg/StarUpPreview/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.upDsc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIArtifactStarUpView:InitGenerate__36(Root, data)
--[[
	UIAnimator/Window/Bg/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIArtifactStarUpView:InitGenerate__37(Root, data)
--[[
	UIAnimator/Window/Bg/ScrollView/Viewport/Content/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ScrollView/Viewport/Content/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIArtifactStarUpView:InitGenerate__38(Root, data)
--[[
	UIAnimator/Window/Bg/ScrollView/Image/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ScrollView/Image/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.costDsc = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIArtifactStarUpView:InitGenerate__39(Root, data)
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
function UIArtifactStarUpView:InitGenerate__40(Root, data)
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
function UIArtifactStarUpView:InitGenerate__41(Root, data)
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
function UIArtifactStarUpView:InitGenerate__42(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/BtnBox/BtnRefine/Content/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/BtnBox/BtnRefine/Content/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIArtifactStarUpView:InitGenerate__43(Root, data)
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
function UIArtifactStarUpView:InitGenerate__44(Root, data)
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
function UIArtifactStarUpView:GenerateDestroy()
	if tolua.getpeer(self.starGrp2.star5.star) ~= nil then
		tolua.setpeer(self.starGrp2.star5.star, nil)
	end
	if tolua.getpeer(self.starGrp2.star5) ~= nil then
		tolua.setpeer(self.starGrp2.star5, nil)
	end
	if tolua.getpeer(self.starGrp2.star4.star) ~= nil then
		tolua.setpeer(self.starGrp2.star4.star, nil)
	end
	if tolua.getpeer(self.starGrp2.star4) ~= nil then
		tolua.setpeer(self.starGrp2.star4, nil)
	end
	if tolua.getpeer(self.starGrp2.star3.star) ~= nil then
		tolua.setpeer(self.starGrp2.star3.star, nil)
	end
	if tolua.getpeer(self.starGrp2.star3) ~= nil then
		tolua.setpeer(self.starGrp2.star3, nil)
	end
	if tolua.getpeer(self.starGrp2.star2.star) ~= nil then
		tolua.setpeer(self.starGrp2.star2.star, nil)
	end
	if tolua.getpeer(self.starGrp2.star2) ~= nil then
		tolua.setpeer(self.starGrp2.star2, nil)
	end
	if tolua.getpeer(self.starGrp2.star1.star) ~= nil then
		tolua.setpeer(self.starGrp2.star1.star, nil)
	end
	if tolua.getpeer(self.starGrp2.star1) ~= nil then
		tolua.setpeer(self.starGrp2.star1, nil)
	end
	if tolua.getpeer(self.starGrp1.star5.star) ~= nil then
		tolua.setpeer(self.starGrp1.star5.star, nil)
	end
	if tolua.getpeer(self.starGrp1.star5) ~= nil then
		tolua.setpeer(self.starGrp1.star5, nil)
	end
	if tolua.getpeer(self.starGrp1.star4.star) ~= nil then
		tolua.setpeer(self.starGrp1.star4.star, nil)
	end
	if tolua.getpeer(self.starGrp1.star4) ~= nil then
		tolua.setpeer(self.starGrp1.star4, nil)
	end
	if tolua.getpeer(self.starGrp1.star3.star) ~= nil then
		tolua.setpeer(self.starGrp1.star3.star, nil)
	end
	if tolua.getpeer(self.starGrp1.star3) ~= nil then
		tolua.setpeer(self.starGrp1.star3, nil)
	end
	if tolua.getpeer(self.starGrp1.star2.star) ~= nil then
		tolua.setpeer(self.starGrp1.star2.star, nil)
	end
	if tolua.getpeer(self.starGrp1.star2) ~= nil then
		tolua.setpeer(self.starGrp1.star2, nil)
	end
	if tolua.getpeer(self.starGrp1.star1.star) ~= nil then
		tolua.setpeer(self.starGrp1.star1.star, nil)
	end
	if tolua.getpeer(self.starGrp1.star1) ~= nil then
		tolua.setpeer(self.starGrp1.star1, nil)
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
	if tolua.getpeer(self.jobIcon) ~= nil then
		tolua.setpeer(self.jobIcon, nil)
	end
	self.jobIcon = nil
	if tolua.getpeer(self.heroName) ~= nil then
		tolua.setpeer(self.heroName, nil)
	end
	self.heroName = nil
	if tolua.getpeer(self.starGrp1) ~= nil then
		tolua.setpeer(self.starGrp1, nil)
	end
	self.starGrp1 = nil
	if tolua.getpeer(self.starGrp2) ~= nil then
		tolua.setpeer(self.starGrp2, nil)
	end
	self.starGrp2 = nil
	if tolua.getpeer(self.upDsc) ~= nil then
		tolua.setpeer(self.upDsc, nil)
	end
	self.upDsc = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if tolua.getpeer(self.costDsc) ~= nil then
		tolua.setpeer(self.costDsc, nil)
	end
	self.costDsc = nil
	if tolua.getpeer(self.bottomBox) ~= nil then
		tolua.setpeer(self.bottomBox, nil)
	end
	self.bottomBox = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.btnRefine) ~= nil then
		tolua.setpeer(self.btnRefine, nil)
	end
	self.btnRefine = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
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
return UIArtifactStarUpView