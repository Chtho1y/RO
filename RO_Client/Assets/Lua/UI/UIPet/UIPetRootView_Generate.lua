---@class UIPetRoot__Generate_toggleContract_lock_bubble
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetRoot__Generate_toggleContract_lock_btn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetRoot__Generate_toggleContract_lock
---@field public gameObject UnityEngine.GameObject
---@field public btn UIPetRoot__Generate_toggleContract_lock_btn
---@field public bubble UIPetRoot__Generate_toggleContract_lock_bubble

---@class UIPetRoot__Generate_toggleContract
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIPetRoot__Generate_toggleRune
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIPetRoot__Generate_togglePets
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIPetRoot__Generate_toggleGroup
---@field public gameObject UnityEngine.GameObject
---@field public toggleGroup UnityEngine.UI.ToggleGroup

---@class UIPetRoot__Generate_btnContractAttr
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetRoot__Generate_btnStamp
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetRoot__Generate_btnBattle
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetRoot__Generate_btnDecompose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetRoot__Generate_btnFilter
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public check UnityEngine.GameObject

---@class UIPetRoot__Generate_contractScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UIPetRoot__Generate_iconPetItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIPetRoot__Generate_petScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIPetRoot__Generate_btnInfo
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetRoot__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetRoot__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIPetRoot__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIPetRoot__Generate_uIAnimator
---@field private AnyBtn UIPetRoot__Generate_AnyBtn
---@field private btnInfo UIPetRoot__Generate_btnInfo
---@field private petScrollView UIPetRoot__Generate_petScrollView
---@field private iconPetItem UIPetRoot__Generate_iconPetItem
---@field private noPets UnityEngine.GameObject
---@field private contract UnityEngine.GameObject
---@field private contractScrollView UIPetRoot__Generate_contractScrollView
---@field private petContractItem UnityEngine.GameObject
---@field private btnFilter UIPetRoot__Generate_btnFilter
---@field private btnBox UnityEngine.GameObject
---@field private btnDecompose UIPetRoot__Generate_btnDecompose
---@field private btnBattle UIPetRoot__Generate_btnBattle
---@field private btnStamp UIPetRoot__Generate_btnStamp
---@field private contractInfo UnityEngine.GameObject
---@field private btnContractAttr UIPetRoot__Generate_btnContractAttr
---@field private toggleGroup UIPetRoot__Generate_toggleGroup
---@field private togglePets UIPetRoot__Generate_togglePets
---@field private toggleRune UIPetRoot__Generate_toggleRune
---@field private toggleContract UIPetRoot__Generate_toggleContract
---@field private toggleContract_lock UIPetRoot__Generate_toggleContract_lock
local UIPetRootView = class("UIPetRootView", require("UIViewBase"))

function UIPetRootView:ctor()
end

---@private
function UIPetRootView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPetRootView:InitGenerate(Root, data)
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


end

---@private
function UIPetRootView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIPetRootView:InitGenerate__2(Root, data)
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
function UIPetRootView:InitGenerate__3(Root, data)
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
function UIPetRootView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Info/BtnInfo
--]]
	local tmp = Root:Find("UIAnimator/Window/Info/BtnInfo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnInfo = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetRootView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/PetScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/PetScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petScrollView = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIPetRootView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/PetScrollView/Viewport/Content/IconPetItem
--]]
	local tmp = Root:Find("UIAnimator/Window/PetScrollView/Viewport/Content/IconPetItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconPetItem = CommonUtil.BindGridViewItem2LuaStatic("IconPetItem", tmp)
	self.iconPetItem.prefabName = "IconPetItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIPetRootView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/PetScrollView/NoPets
--]]
	local tmp = Root:Find("UIAnimator/Window/PetScrollView/NoPets").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noPets = tmp
end

---@private
function UIPetRootView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Contract
--]]
	local tmp = Root:Find("UIAnimator/Window/Contract").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contract = tmp
end

---@private
function UIPetRootView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Contract/ContractScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Contract/ContractScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contractScrollView = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIPetRootView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Contract/ContractScrollView/Viewport/Content/PetContractItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Contract/ContractScrollView/Viewport/Content/PetContractItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petContractItem = CommonUtil.BindGridViewItem2LuaStatic("PetContractItem", tmp)
	self.petContractItem.prefabName = "PetContractItem"
end

---@private
function UIPetRootView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BtnFilter
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnFilter").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnFilter = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetRootView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BtnFilter/Check
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnFilter/Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnFilter.check = tmp
end

---@private
function UIPetRootView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BtnBox
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBox = tmp
end

---@private
function UIPetRootView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnDecompose
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnDecompose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnDecompose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetRootView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnBattle
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnBattle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBattle = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetRootView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnStamp
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnStamp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnStamp = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetRootView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/BtnBox/ContractInfo
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/ContractInfo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contractInfo = tmp
end

---@private
function UIPetRootView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/BtnBox/ContractInfo/BtnContractAttr
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/ContractInfo/BtnContractAttr").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnContractAttr = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetRootView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/ToggleGroup
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleGroup = tmp

	tmp.toggleGroup = tmp:GetComponent(Enum.TypeInfo.ToggleGroup)
end

---@private
function UIPetRootView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/TogglePets
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/TogglePets").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.togglePets = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIPetRootView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/ToggleRune
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/ToggleRune").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleRune = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIPetRootView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/ToggleContract
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/ToggleContract").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleContract = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIPetRootView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/ToggleContract_lock
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/ToggleContract_lock").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleContract_lock = tmp
end

---@private
function UIPetRootView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/ToggleContract_lock/btn
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/ToggleContract_lock/btn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleContract_lock.btn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetRootView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/ToggleContract_lock/bubble
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/ToggleContract_lock/bubble").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleContract_lock.bubble = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetRootView:GenerateDestroy()
	if tolua.getpeer(self.toggleContract_lock.bubble) ~= nil then
		tolua.setpeer(self.toggleContract_lock.bubble, nil)
	end
	if tolua.getpeer(self.toggleContract_lock.btn) ~= nil then
		tolua.setpeer(self.toggleContract_lock.btn, nil)
	end
	if tolua.getpeer(self.btnFilter.check) ~= nil then
		tolua.setpeer(self.btnFilter.check, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnInfo) ~= nil then
		tolua.setpeer(self.btnInfo, nil)
	end
	self.btnInfo = nil
	if tolua.getpeer(self.petScrollView) ~= nil then
		tolua.setpeer(self.petScrollView, nil)
	end
	self.petScrollView = nil
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
	if tolua.getpeer(self.contract) ~= nil then
		tolua.setpeer(self.contract, nil)
	end
	self.contract = nil
	if tolua.getpeer(self.contractScrollView) ~= nil then
		tolua.setpeer(self.contractScrollView, nil)
	end
	self.contractScrollView = nil
	if self.petContractItem.GenerateDestroy ~= nil then
		self.petContractItem:GenerateDestroy()
	end
	if tolua.getpeer(self.petContractItem) ~= nil then
		tolua.setpeer(self.petContractItem, nil)
	end
	self.petContractItem = nil
	if tolua.getpeer(self.btnFilter) ~= nil then
		tolua.setpeer(self.btnFilter, nil)
	end
	self.btnFilter = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.btnDecompose) ~= nil then
		tolua.setpeer(self.btnDecompose, nil)
	end
	self.btnDecompose = nil
	if tolua.getpeer(self.btnBattle) ~= nil then
		tolua.setpeer(self.btnBattle, nil)
	end
	self.btnBattle = nil
	if tolua.getpeer(self.btnStamp) ~= nil then
		tolua.setpeer(self.btnStamp, nil)
	end
	self.btnStamp = nil
	if tolua.getpeer(self.contractInfo) ~= nil then
		tolua.setpeer(self.contractInfo, nil)
	end
	self.contractInfo = nil
	if tolua.getpeer(self.btnContractAttr) ~= nil then
		tolua.setpeer(self.btnContractAttr, nil)
	end
	self.btnContractAttr = nil
	if tolua.getpeer(self.toggleGroup) ~= nil then
		tolua.setpeer(self.toggleGroup, nil)
	end
	self.toggleGroup = nil
	if tolua.getpeer(self.togglePets) ~= nil then
		tolua.setpeer(self.togglePets, nil)
	end
	self.togglePets = nil
	if tolua.getpeer(self.toggleRune) ~= nil then
		tolua.setpeer(self.toggleRune, nil)
	end
	self.toggleRune = nil
	if tolua.getpeer(self.toggleContract) ~= nil then
		tolua.setpeer(self.toggleContract, nil)
	end
	self.toggleContract = nil
	if tolua.getpeer(self.toggleContract_lock) ~= nil then
		tolua.setpeer(self.toggleContract_lock, nil)
	end
	self.toggleContract_lock = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPetRootView