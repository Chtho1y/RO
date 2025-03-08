---@class UIPetContractTips__Generate_btnOK
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetContractTips__Generate_btnCancel
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetContractTips__Generate_skillExtra_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPetContractTips__Generate_skillExtra
---@field public gameObject UnityEngine.GameObject
---@field public number UIPetContractTips__Generate_skillExtra_number

---@class UIPetContractTips__Generate_contractEffect_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPetContractTips__Generate_contractEffect
---@field public gameObject UnityEngine.GameObject
---@field public number UIPetContractTips__Generate_contractEffect_number

---@class UIPetContractTips__Generate_petExtra_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPetContractTips__Generate_petExtra_nature
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPetContractTips__Generate_petExtra
---@field public gameObject UnityEngine.GameObject
---@field public nature UIPetContractTips__Generate_petExtra_nature
---@field public number UIPetContractTips__Generate_petExtra_number

---@class UIPetContractTips__Generate_iconPetItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIPetContractTips__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIPetContractTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetContractTips__Generate_textTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPetContractTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetContractTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIPetContractTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIPetContractTips__Generate_uIAnimator
---@field private AnyBtn UIPetContractTips__Generate_AnyBtn
---@field private textTitle UIPetContractTips__Generate_textTitle
---@field private btnClose UIPetContractTips__Generate_btnClose
---@field private scrollView UIPetContractTips__Generate_scrollView
---@field private iconPetItem UIPetContractTips__Generate_iconPetItem
---@field private noPets UnityEngine.GameObject
---@field private petExtra UIPetContractTips__Generate_petExtra
---@field private bottom UnityEngine.GameObject
---@field private contractEffect UIPetContractTips__Generate_contractEffect
---@field private skillExtra UIPetContractTips__Generate_skillExtra
---@field private btnCancel UIPetContractTips__Generate_btnCancel
---@field private btnOK UIPetContractTips__Generate_btnOK
local UIPetContractTipsView = class("UIPetContractTipsView", require("UIViewBase"))

function UIPetContractTipsView:ctor()
end

---@private
function UIPetContractTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPetContractTipsView:InitGenerate(Root, data)
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


end

---@private
function UIPetContractTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIPetContractTipsView:InitGenerate__2(Root, data)
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
function UIPetContractTipsView:InitGenerate__3(Root, data)
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
function UIPetContractTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/TextTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TextTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textTitle = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPetContractTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetContractTipsView:InitGenerate__6(Root, data)
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
function UIPetContractTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/ScrollView/Viewport/Content/IconPetItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ScrollView/Viewport/Content/IconPetItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconPetItem = CommonUtil.BindGridViewItem2LuaStatic("IconPetItem", tmp)
	self.iconPetItem.prefabName = "IconPetItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIPetContractTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/NoPets
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/NoPets").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noPets = tmp
end

---@private
function UIPetContractTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/PetExtra
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/PetExtra").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petExtra = tmp
end

---@private
function UIPetContractTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/PetExtra/nature
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/PetExtra/nature").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petExtra.nature = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPetContractTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/PetExtra/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/PetExtra/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petExtra.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIPetContractTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottom = tmp
end

---@private
function UIPetContractTipsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/ExtraBox/ContractEffect
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/ExtraBox/ContractEffect").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contractEffect = tmp
end

---@private
function UIPetContractTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/ExtraBox/ContractEffect/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/ExtraBox/ContractEffect/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contractEffect.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIPetContractTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/ExtraBox/SkillExtra
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/ExtraBox/SkillExtra").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillExtra = tmp
end

---@private
function UIPetContractTipsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/ExtraBox/SkillExtra/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/ExtraBox/SkillExtra/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillExtra.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIPetContractTipsView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/BtnCancel
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/BtnCancel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCancel = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetContractTipsView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/BtnOK
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/BtnOK").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnOK = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetContractTipsView:GenerateDestroy()
	if tolua.getpeer(self.skillExtra.number) ~= nil then
		tolua.setpeer(self.skillExtra.number, nil)
	end
	if tolua.getpeer(self.contractEffect.number) ~= nil then
		tolua.setpeer(self.contractEffect.number, nil)
	end
	if tolua.getpeer(self.petExtra.number) ~= nil then
		tolua.setpeer(self.petExtra.number, nil)
	end
	if tolua.getpeer(self.petExtra.nature) ~= nil then
		tolua.setpeer(self.petExtra.nature, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.textTitle) ~= nil then
		tolua.setpeer(self.textTitle, nil)
	end
	self.textTitle = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if self.iconPetItem.GenerateDestroy ~= nil then
		self.iconPetItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconPetItem) ~= nil then
		tolua.setpeer(self.iconPetItem, nil)
	end
	self.iconPetItem = nil
	if tolua.getpeer(self.noPets) ~= nil then
		tolua.setpeer(self.noPets, nil)
	end
	self.noPets = nil
	if tolua.getpeer(self.petExtra) ~= nil then
		tolua.setpeer(self.petExtra, nil)
	end
	self.petExtra = nil
	if tolua.getpeer(self.bottom) ~= nil then
		tolua.setpeer(self.bottom, nil)
	end
	self.bottom = nil
	if tolua.getpeer(self.contractEffect) ~= nil then
		tolua.setpeer(self.contractEffect, nil)
	end
	self.contractEffect = nil
	if tolua.getpeer(self.skillExtra) ~= nil then
		tolua.setpeer(self.skillExtra, nil)
	end
	self.skillExtra = nil
	if tolua.getpeer(self.btnCancel) ~= nil then
		tolua.setpeer(self.btnCancel, nil)
	end
	self.btnCancel = nil
	if tolua.getpeer(self.btnOK) ~= nil then
		tolua.setpeer(self.btnOK, nil)
	end
	self.btnOK = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPetContractTipsView