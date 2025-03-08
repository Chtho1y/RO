---@class PetBook__Generate_btnBack
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class PetBook__Generate_qty_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class PetBook__Generate_qty
---@field public gameObject UnityEngine.GameObject
---@field public iconAll UnityEngine.GameObject
---@field public iconNormal UnityEngine.GameObject
---@field public iconMini UnityEngine.GameObject
---@field public iconMvp UnityEngine.GameObject
---@field public text PetBook__Generate_qty_text

---@class PetBook__Generate_toggleMVP
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class PetBook__Generate_toggleMini
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class PetBook__Generate_toggleNormal
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class PetBook__Generate_toggleAll
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class PetBook__Generate_toggleGroup
---@field public gameObject UnityEngine.GameObject
---@field public toggleGroup UnityEngine.UI.ToggleGroup

---@class PetBook__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class PetBook__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private scrollView PetBook__Generate_scrollView
---@field private petCollect UnityEngine.GameObject
---@field private toggleGroup PetBook__Generate_toggleGroup
---@field private toggleAll PetBook__Generate_toggleAll
---@field private toggleNormal PetBook__Generate_toggleNormal
---@field private toggleMini PetBook__Generate_toggleMini
---@field private toggleMVP PetBook__Generate_toggleMVP
---@field private qty PetBook__Generate_qty
---@field private btnBack PetBook__Generate_btnBack
local PetBookView = class("PetBookView")

function PetBookView:ctor()
end

---@private
function PetBookView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function PetBookView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

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


end

---@private
function PetBookView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function PetBookView:InitGenerate__2(Root, data)
--[[
	ScrollView
--]]
	local tmp = Root:Find("ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function PetBookView:InitGenerate__3(Root, data)
--[[
	ScrollView/Viewport/Content/PetCollect
--]]
	local tmp = Root:Find("ScrollView/Viewport/Content/PetCollect").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petCollect = CommonUtil.BindGridViewItem2LuaStatic("PetCollect", tmp)
	self.petCollect.prefabName = "PetCollect"
end

---@private
function PetBookView:InitGenerate__4(Root, data)
--[[
	ToggleGroup
--]]
	local tmp = Root:Find("ToggleGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleGroup = tmp

	tmp.toggleGroup = tmp:GetComponent(Enum.TypeInfo.ToggleGroup)
end

---@private
function PetBookView:InitGenerate__5(Root, data)
--[[
	ToggleGroup/ToggleAll
--]]
	local tmp = Root:Find("ToggleGroup/ToggleAll").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleAll = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function PetBookView:InitGenerate__6(Root, data)
--[[
	ToggleGroup/ToggleNormal
--]]
	local tmp = Root:Find("ToggleGroup/ToggleNormal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleNormal = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function PetBookView:InitGenerate__7(Root, data)
--[[
	ToggleGroup/ToggleMini
--]]
	local tmp = Root:Find("ToggleGroup/ToggleMini").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleMini = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function PetBookView:InitGenerate__8(Root, data)
--[[
	ToggleGroup/ToggleMVP
--]]
	local tmp = Root:Find("ToggleGroup/ToggleMVP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleMVP = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function PetBookView:InitGenerate__9(Root, data)
--[[
	Qty
--]]
	local tmp = Root:Find("Qty").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qty = tmp
end

---@private
function PetBookView:InitGenerate__10(Root, data)
--[[
	Qty/IconAll
--]]
	local tmp = Root:Find("Qty/IconAll").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qty.iconAll = tmp
end

---@private
function PetBookView:InitGenerate__11(Root, data)
--[[
	Qty/IconNormal
--]]
	local tmp = Root:Find("Qty/IconNormal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qty.iconNormal = tmp
end

---@private
function PetBookView:InitGenerate__12(Root, data)
--[[
	Qty/IconMini
--]]
	local tmp = Root:Find("Qty/IconMini").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qty.iconMini = tmp
end

---@private
function PetBookView:InitGenerate__13(Root, data)
--[[
	Qty/IconMvp
--]]
	local tmp = Root:Find("Qty/IconMvp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qty.iconMvp = tmp
end

---@private
function PetBookView:InitGenerate__14(Root, data)
--[[
	Qty/Text
--]]
	local tmp = Root:Find("Qty/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qty.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function PetBookView:InitGenerate__15(Root, data)
--[[
	BtnBack
--]]
	local tmp = Root:Find("BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBack = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function PetBookView:GenerateDestroy()
	if tolua.getpeer(self.qty.text) ~= nil then
		tolua.setpeer(self.qty.text, nil)
	end
	if tolua.getpeer(self.qty.iconMvp) ~= nil then
		tolua.setpeer(self.qty.iconMvp, nil)
	end
	if tolua.getpeer(self.qty.iconMini) ~= nil then
		tolua.setpeer(self.qty.iconMini, nil)
	end
	if tolua.getpeer(self.qty.iconNormal) ~= nil then
		tolua.setpeer(self.qty.iconNormal, nil)
	end
	if tolua.getpeer(self.qty.iconAll) ~= nil then
		tolua.setpeer(self.qty.iconAll, nil)
	end
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if self.petCollect.GenerateDestroy ~= nil then
		self.petCollect:GenerateDestroy()
	end
	if tolua.getpeer(self.petCollect) ~= nil then
		tolua.setpeer(self.petCollect, nil)
	end
	self.petCollect = nil
	if tolua.getpeer(self.toggleGroup) ~= nil then
		tolua.setpeer(self.toggleGroup, nil)
	end
	self.toggleGroup = nil
	if tolua.getpeer(self.toggleAll) ~= nil then
		tolua.setpeer(self.toggleAll, nil)
	end
	self.toggleAll = nil
	if tolua.getpeer(self.toggleNormal) ~= nil then
		tolua.setpeer(self.toggleNormal, nil)
	end
	self.toggleNormal = nil
	if tolua.getpeer(self.toggleMini) ~= nil then
		tolua.setpeer(self.toggleMini, nil)
	end
	self.toggleMini = nil
	if tolua.getpeer(self.toggleMVP) ~= nil then
		tolua.setpeer(self.toggleMVP, nil)
	end
	self.toggleMVP = nil
	if tolua.getpeer(self.qty) ~= nil then
		tolua.setpeer(self.qty, nil)
	end
	self.qty = nil
	if tolua.getpeer(self.btnBack) ~= nil then
		tolua.setpeer(self.btnBack, nil)
	end
	self.btnBack = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return PetBookView