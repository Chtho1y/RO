---@class UIPetContractAttribute__Generate_toggle4_iconPetItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIPetContractAttribute__Generate_toggle4
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public petLock UnityEngine.GameObject
---@field public iconPetItem UIPetContractAttribute__Generate_toggle4_iconPetItem

---@class UIPetContractAttribute__Generate_toggle3_iconPetItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIPetContractAttribute__Generate_toggle3
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public petLock UnityEngine.GameObject
---@field public iconPetItem UIPetContractAttribute__Generate_toggle3_iconPetItem

---@class UIPetContractAttribute__Generate_toggle2_iconPetItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIPetContractAttribute__Generate_toggle2
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public petLock UnityEngine.GameObject
---@field public iconPetItem UIPetContractAttribute__Generate_toggle2_iconPetItem

---@class UIPetContractAttribute__Generate_toggle1_iconPetItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIPetContractAttribute__Generate_toggle1
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public petLock UnityEngine.GameObject
---@field public iconPetItem UIPetContractAttribute__Generate_toggle1_iconPetItem

---@class UIPetContractAttribute__Generate_toggleAll
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIPetContractAttribute__Generate_toggleGroup
---@field public gameObject UnityEngine.GameObject
---@field public toggleGroup UnityEngine.UI.ToggleGroup

---@class UIPetContractAttribute__Generate_addSView_content
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIPetContractAttribute__Generate_addSView
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UIPetContractAttribute__Generate_addSView_content

---@class UIPetContractAttribute__Generate_baseSView_content
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIPetContractAttribute__Generate_baseSView
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UIPetContractAttribute__Generate_baseSView_content

---@class UIPetContractAttribute__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetContractAttribute__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetContractAttribute__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIPetContractAttribute__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIPetContractAttribute__Generate_uIAnimator
---@field private AnyBtn UIPetContractAttribute__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UIPetContractAttribute__Generate_btnClose
---@field private scrollView UnityEngine.GameObject
---@field private baseAttrs UnityEngine.GameObject
---@field private baseSView UIPetContractAttribute__Generate_baseSView
---@field private addAttrs UnityEngine.GameObject
---@field private addSView UIPetContractAttribute__Generate_addSView
---@field private none UnityEngine.GameObject
---@field private natureAttrItem UnityEngine.GameObject
---@field private noContract UnityEngine.GameObject
---@field private toggleGroup UIPetContractAttribute__Generate_toggleGroup
---@field private toggleAll UIPetContractAttribute__Generate_toggleAll
---@field private toggle1 UIPetContractAttribute__Generate_toggle1
---@field private toggle2 UIPetContractAttribute__Generate_toggle2
---@field private toggle3 UIPetContractAttribute__Generate_toggle3
---@field private toggle4 UIPetContractAttribute__Generate_toggle4
local UIPetContractAttributeView = class("UIPetContractAttributeView", require("UIViewBase"))

function UIPetContractAttributeView:ctor()
end

---@private
function UIPetContractAttributeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPetContractAttributeView:InitGenerate(Root, data)
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


end

---@private
function UIPetContractAttributeView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIPetContractAttributeView:InitGenerate__2(Root, data)
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
function UIPetContractAttributeView:InitGenerate__3(Root, data)
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
function UIPetContractAttributeView:InitGenerate__4(Root, data)
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
function UIPetContractAttributeView:InitGenerate__5(Root, data)
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
function UIPetContractAttributeView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp
end

---@private
function UIPetContractAttributeView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/Content/BaseAttrs
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/Content/BaseAttrs").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.baseAttrs = tmp
end

---@private
function UIPetContractAttributeView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/Content/BaseSView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/Content/BaseSView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.baseSView = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIPetContractAttributeView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/Content/BaseSView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/Content/BaseSView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.baseSView.content = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIPetContractAttributeView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/Content/AddAttrs
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/Content/AddAttrs").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addAttrs = tmp
end

---@private
function UIPetContractAttributeView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/Content/AddSView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/Content/AddSView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addSView = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIPetContractAttributeView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/Content/AddSView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/Content/AddSView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addSView.content = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIPetContractAttributeView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/Content/None
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/Content/None").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.none = tmp
end

---@private
function UIPetContractAttributeView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/NatureAttrItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ScrollView/Viewport/NatureAttrItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.natureAttrItem = CommonUtil.BindGridViewItem2LuaStatic("NatureAttrItem", tmp)
	self.natureAttrItem.prefabName = "NatureAttrItem"
end

---@private
function UIPetContractAttributeView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/NoContract
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/NoContract").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noContract = tmp
end

---@private
function UIPetContractAttributeView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleGroup = tmp

	tmp.toggleGroup = tmp:GetComponent(Enum.TypeInfo.ToggleGroup)
end

---@private
function UIPetContractAttributeView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/ToggleAll
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/ToggleAll").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleAll = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIPetContractAttributeView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle1 = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIPetContractAttributeView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle1/PetIcon/PetLock
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle1/PetIcon/PetLock").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle1.petLock = tmp
end

---@private
function UIPetContractAttributeView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle1/PetIcon/IconPetItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle1/PetIcon/IconPetItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle1.iconPetItem = CommonUtil.BindGridViewItem2LuaStatic("IconPetItem", tmp)
	self.toggle1.iconPetItem.prefabName = "IconPetItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIPetContractAttributeView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle2 = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIPetContractAttributeView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle2/PetIcon/PetLock
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle2/PetIcon/PetLock").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle2.petLock = tmp
end

---@private
function UIPetContractAttributeView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle2/PetIcon/IconPetItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle2/PetIcon/IconPetItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle2.iconPetItem = CommonUtil.BindGridViewItem2LuaStatic("IconPetItem", tmp)
	self.toggle2.iconPetItem.prefabName = "IconPetItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIPetContractAttributeView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle3 = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIPetContractAttributeView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle3/PetIcon/PetLock
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle3/PetIcon/PetLock").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle3.petLock = tmp
end

---@private
function UIPetContractAttributeView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle3/PetIcon/IconPetItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle3/PetIcon/IconPetItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle3.iconPetItem = CommonUtil.BindGridViewItem2LuaStatic("IconPetItem", tmp)
	self.toggle3.iconPetItem.prefabName = "IconPetItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIPetContractAttributeView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle4 = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIPetContractAttributeView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle4/PetIcon/PetLock
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle4/PetIcon/PetLock").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle4.petLock = tmp
end

---@private
function UIPetContractAttributeView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle4/PetIcon/IconPetItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ContractAttrBox/ToggleGroup/Toggle4/PetIcon/IconPetItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle4.iconPetItem = CommonUtil.BindGridViewItem2LuaStatic("IconPetItem", tmp)
	self.toggle4.iconPetItem.prefabName = "IconPetItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIPetContractAttributeView:GenerateDestroy()
	if self.toggle4.iconPetItem.GenerateDestroy ~= nil then
		self.toggle4.iconPetItem:GenerateDestroy()
	end
	if tolua.getpeer(self.toggle4.iconPetItem) ~= nil then
		tolua.setpeer(self.toggle4.iconPetItem, nil)
	end
	if tolua.getpeer(self.toggle4.petLock) ~= nil then
		tolua.setpeer(self.toggle4.petLock, nil)
	end
	if self.toggle3.iconPetItem.GenerateDestroy ~= nil then
		self.toggle3.iconPetItem:GenerateDestroy()
	end
	if tolua.getpeer(self.toggle3.iconPetItem) ~= nil then
		tolua.setpeer(self.toggle3.iconPetItem, nil)
	end
	if tolua.getpeer(self.toggle3.petLock) ~= nil then
		tolua.setpeer(self.toggle3.petLock, nil)
	end
	if self.toggle2.iconPetItem.GenerateDestroy ~= nil then
		self.toggle2.iconPetItem:GenerateDestroy()
	end
	if tolua.getpeer(self.toggle2.iconPetItem) ~= nil then
		tolua.setpeer(self.toggle2.iconPetItem, nil)
	end
	if tolua.getpeer(self.toggle2.petLock) ~= nil then
		tolua.setpeer(self.toggle2.petLock, nil)
	end
	if self.toggle1.iconPetItem.GenerateDestroy ~= nil then
		self.toggle1.iconPetItem:GenerateDestroy()
	end
	if tolua.getpeer(self.toggle1.iconPetItem) ~= nil then
		tolua.setpeer(self.toggle1.iconPetItem, nil)
	end
	if tolua.getpeer(self.toggle1.petLock) ~= nil then
		tolua.setpeer(self.toggle1.petLock, nil)
	end
	if tolua.getpeer(self.addSView.content) ~= nil then
		tolua.setpeer(self.addSView.content, nil)
	end
	if tolua.getpeer(self.baseSView.content) ~= nil then
		tolua.setpeer(self.baseSView.content, nil)
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
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.baseAttrs) ~= nil then
		tolua.setpeer(self.baseAttrs, nil)
	end
	self.baseAttrs = nil
	if tolua.getpeer(self.baseSView) ~= nil then
		tolua.setpeer(self.baseSView, nil)
	end
	self.baseSView = nil
	if tolua.getpeer(self.addAttrs) ~= nil then
		tolua.setpeer(self.addAttrs, nil)
	end
	self.addAttrs = nil
	if tolua.getpeer(self.addSView) ~= nil then
		tolua.setpeer(self.addSView, nil)
	end
	self.addSView = nil
	if tolua.getpeer(self.none) ~= nil then
		tolua.setpeer(self.none, nil)
	end
	self.none = nil
	if self.natureAttrItem.GenerateDestroy ~= nil then
		self.natureAttrItem:GenerateDestroy()
	end
	if tolua.getpeer(self.natureAttrItem) ~= nil then
		tolua.setpeer(self.natureAttrItem, nil)
	end
	self.natureAttrItem = nil
	if tolua.getpeer(self.noContract) ~= nil then
		tolua.setpeer(self.noContract, nil)
	end
	self.noContract = nil
	if tolua.getpeer(self.toggleGroup) ~= nil then
		tolua.setpeer(self.toggleGroup, nil)
	end
	self.toggleGroup = nil
	if tolua.getpeer(self.toggleAll) ~= nil then
		tolua.setpeer(self.toggleAll, nil)
	end
	self.toggleAll = nil
	if tolua.getpeer(self.toggle1) ~= nil then
		tolua.setpeer(self.toggle1, nil)
	end
	self.toggle1 = nil
	if tolua.getpeer(self.toggle2) ~= nil then
		tolua.setpeer(self.toggle2, nil)
	end
	self.toggle2 = nil
	if tolua.getpeer(self.toggle3) ~= nil then
		tolua.setpeer(self.toggle3, nil)
	end
	self.toggle3 = nil
	if tolua.getpeer(self.toggle4) ~= nil then
		tolua.setpeer(self.toggle4, nil)
	end
	self.toggle4 = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPetContractAttributeView