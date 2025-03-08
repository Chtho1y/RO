---@class UIPetMats__Generate_btnSure
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetMats__Generate_btnCancel
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetMats__Generate_mats_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPetMats__Generate_iconPetItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIPetMats__Generate_mats
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView
---@field public text UIPetMats__Generate_mats_text

---@class UIPetMats__Generate_textTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPetMats__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UIPetMats__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetMats__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIPetMats__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIPetMats__Generate_uIAnimator
---@field private AnyBtn UIPetMats__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private bg UIPetMats__Generate_bg
---@field private textTitle UIPetMats__Generate_textTitle
---@field private mats UIPetMats__Generate_mats
---@field private iconPetItem UIPetMats__Generate_iconPetItem
---@field private noPets UnityEngine.GameObject
---@field private btnBox UnityEngine.GameObject
---@field private btnCancel UIPetMats__Generate_btnCancel
---@field private btnSure UIPetMats__Generate_btnSure
local UIPetMatsView = class("UIPetMatsView", require("UIViewBase"))

function UIPetMatsView:ctor()
end

---@private
function UIPetMatsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPetMatsView:InitGenerate(Root, data)
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


end

---@private
function UIPetMatsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIPetMatsView:InitGenerate__2(Root, data)
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
function UIPetMatsView:InitGenerate__3(Root, data)
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
function UIPetMatsView:InitGenerate__4(Root, data)
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
function UIPetMatsView:InitGenerate__5(Root, data)
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
function UIPetMatsView:InitGenerate__6(Root, data)
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
function UIPetMatsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/List/Mats
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Mats").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mats = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIPetMatsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/List/Mats/View/IconPetItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Mats/View/IconPetItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconPetItem = CommonUtil.BindGridViewItem2LuaStatic("IconPetItem", tmp)
	self.iconPetItem.prefabName = "IconPetItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIPetMatsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/List/Mats/Dsc/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Mats/Dsc/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mats.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPetMatsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/List/NoPets
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/NoPets").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noPets = tmp
end

---@private
function UIPetMatsView:InitGenerate__11(Root, data)
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
function UIPetMatsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/BtnCancel
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/BtnCancel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCancel = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetMatsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/BtnSure
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/BtnSure").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSure = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetMatsView:GenerateDestroy()
	if tolua.getpeer(self.mats.text) ~= nil then
		tolua.setpeer(self.mats.text, nil)
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
	if tolua.getpeer(self.textTitle) ~= nil then
		tolua.setpeer(self.textTitle, nil)
	end
	self.textTitle = nil
	if tolua.getpeer(self.mats) ~= nil then
		tolua.setpeer(self.mats, nil)
	end
	self.mats = nil
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
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.btnCancel) ~= nil then
		tolua.setpeer(self.btnCancel, nil)
	end
	self.btnCancel = nil
	if tolua.getpeer(self.btnSure) ~= nil then
		tolua.setpeer(self.btnSure, nil)
	end
	self.btnSure = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPetMatsView