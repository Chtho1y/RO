---@class UIPetStampTips__Generate_btnAdvance
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public uIRedPointRP UnityEngine.GameObject

---@class UIPetStampTips__Generate_btnPetStampLvUp
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public uIRedPointRP UnityEngine.GameObject

---@class UIPetStampTips__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPetStampTips__Generate_baseAttr
---@field public gameObject UnityEngine.GameObject
---@field public grid UnityEngine.GameObject

---@class UIPetStampTips__Generate_btnChange
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetStampTips__Generate_type1_image
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPetStampTips__Generate_type1_text2
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPetStampTips__Generate_type1
---@field public gameObject UnityEngine.GameObject
---@field public text2 UIPetStampTips__Generate_type1_text2
---@field public image UIPetStampTips__Generate_type1_image

---@class UIPetStampTips__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPetStampTips__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIPetStampTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetStampTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetStampTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIPetStampTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIEventHandler UIEventHandler
---@field private uIAnimator UIPetStampTips__Generate_uIAnimator
---@field private AnyBtn UIPetStampTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private closeBox UnityEngine.GameObject
---@field private btnClose UIPetStampTips__Generate_btnClose
---@field private contentItem UnityEngine.GameObject
---@field private iconItem UIPetStampTips__Generate_iconItem
---@field private textName UIPetStampTips__Generate_textName
---@field private type1 UIPetStampTips__Generate_type1
---@field private btnChange UIPetStampTips__Generate_btnChange
---@field private baseAttr UIPetStampTips__Generate_baseAttr
---@field private attrItem UnityEngine.GameObject
---@field private desTxt UIPetStampTips__Generate_desTxt
---@field private bottomBox UnityEngine.GameObject
---@field private btnBox UnityEngine.GameObject
---@field private btnPetStampLvUp UIPetStampTips__Generate_btnPetStampLvUp
---@field private btnAdvance UIPetStampTips__Generate_btnAdvance
local UIPetStampTipsView = class("UIPetStampTipsView", require("UIViewBase"))

function UIPetStampTipsView:ctor()
end

---@private
function UIPetStampTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPetStampTipsView:InitGenerate(Root, data)
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


end

---@private
function UIPetStampTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.uIEventHandler = Root:GetComponent(Enum.TypeInfo.UIEventHandler)
end

---@private
function UIPetStampTipsView:InitGenerate__2(Root, data)
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
function UIPetStampTipsView:InitGenerate__3(Root, data)
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
function UIPetStampTipsView:InitGenerate__4(Root, data)
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
function UIPetStampTipsView:InitGenerate__5(Root, data)
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
function UIPetStampTipsView:InitGenerate__6(Root, data)
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
function UIPetStampTipsView:InitGenerate__7(Root, data)
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
function UIPetStampTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/ContentItem/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/ContentItem/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIPetStampTipsView:InitGenerate__9(Root, data)
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
function UIPetStampTipsView:InitGenerate__10(Root, data)
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
function UIPetStampTipsView:InitGenerate__11(Root, data)
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
function UIPetStampTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type1/Text2/Image
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type1/Text2/Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.type1.image = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPetStampTipsView:InitGenerate__13(Root, data)
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
function UIPetStampTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/BaseAttr
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BaseAttr").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.baseAttr = tmp
end

---@private
function UIPetStampTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/BaseAttr/AttrItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BaseAttr/AttrItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrItem = CommonUtil.BindGridViewItem2LuaStatic("AttrItem", tmp)
	self.attrItem.prefabName = "AttrItem"
end

---@private
function UIPetStampTipsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/BaseAttr/Grid
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BaseAttr/Grid").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.baseAttr.grid = tmp
end

---@private
function UIPetStampTipsView:InitGenerate__17(Root, data)
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
function UIPetStampTipsView:InitGenerate__18(Root, data)
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
function UIPetStampTipsView:InitGenerate__19(Root, data)
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
function UIPetStampTipsView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/BtnBox/BtnPetStampLvUp
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/BtnBox/BtnPetStampLvUp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPetStampLvUp = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetStampTipsView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/BtnBox/BtnPetStampLvUp/UIRedPointRP
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/BtnBox/BtnPetStampLvUp/UIRedPointRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPetStampLvUp.uIRedPointRP = tmp
end

---@private
function UIPetStampTipsView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/BtnBox/BtnAdvance
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/BtnBox/BtnAdvance").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnAdvance = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetStampTipsView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/BtnBox/BtnAdvance/UIRedPointRP
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/BtnBox/BtnAdvance/UIRedPointRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnAdvance.uIRedPointRP = tmp
end

---@private
function UIPetStampTipsView:GenerateDestroy()
	if tolua.getpeer(self.btnAdvance.uIRedPointRP) ~= nil then
		tolua.setpeer(self.btnAdvance.uIRedPointRP, nil)
	end
	if tolua.getpeer(self.btnPetStampLvUp.uIRedPointRP) ~= nil then
		tolua.setpeer(self.btnPetStampLvUp.uIRedPointRP, nil)
	end
	if tolua.getpeer(self.baseAttr.grid) ~= nil then
		tolua.setpeer(self.baseAttr.grid, nil)
	end
	if tolua.getpeer(self.type1.image) ~= nil then
		tolua.setpeer(self.type1.image, nil)
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
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
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
	if tolua.getpeer(self.baseAttr) ~= nil then
		tolua.setpeer(self.baseAttr, nil)
	end
	self.baseAttr = nil
	if self.attrItem.GenerateDestroy ~= nil then
		self.attrItem:GenerateDestroy()
	end
	if tolua.getpeer(self.attrItem) ~= nil then
		tolua.setpeer(self.attrItem, nil)
	end
	self.attrItem = nil
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	if tolua.getpeer(self.bottomBox) ~= nil then
		tolua.setpeer(self.bottomBox, nil)
	end
	self.bottomBox = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.btnPetStampLvUp) ~= nil then
		tolua.setpeer(self.btnPetStampLvUp, nil)
	end
	self.btnPetStampLvUp = nil
	if tolua.getpeer(self.btnAdvance) ~= nil then
		tolua.setpeer(self.btnAdvance, nil)
	end
	self.btnAdvance = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPetStampTipsView