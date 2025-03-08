---@class BookItem__Generate_btnBack
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class BookItem__Generate_btnMaterials
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public icon UnityEngine.GameObject

---@class BookItem__Generate_qtyCollection_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BookItem__Generate_qtyCollection
---@field public gameObject UnityEngine.GameObject
---@field public iconAll UnityEngine.GameObject
---@field public iconNormal UnityEngine.GameObject
---@field public iconMini UnityEngine.GameObject
---@field public iconMvp UnityEngine.GameObject
---@field public text BookItem__Generate_qtyCollection_text

---@class BookItem__Generate_qtyPet_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BookItem__Generate_qtyPet
---@field public gameObject UnityEngine.GameObject
---@field public iconAll UnityEngine.GameObject
---@field public iconNormal UnityEngine.GameObject
---@field public iconMini UnityEngine.GameObject
---@field public iconMvp UnityEngine.GameObject
---@field public text BookItem__Generate_qtyPet_text

---@class BookItem__Generate_qtyCard_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BookItem__Generate_qtyCard
---@field public gameObject UnityEngine.GameObject
---@field public iconAll UnityEngine.GameObject
---@field public iconNormal UnityEngine.GameObject
---@field public iconMini UnityEngine.GameObject
---@field public iconMvp UnityEngine.GameObject
---@field public text BookItem__Generate_qtyCard_text

---@class BookItem__Generate_toggleMVP
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class BookItem__Generate_toggleMini
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class BookItem__Generate_toggleNormal
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class BookItem__Generate_toggleAll
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class BookItem__Generate_toggleGroup
---@field public gameObject UnityEngine.GameObject
---@field public toggleGroup UnityEngine.UI.ToggleGroup

---@class BookItem__Generate_dscBox_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class BookItem__Generate_dscBox
---@field public gameObject UnityEngine.GameObject
---@field public text BookItem__Generate_dscBox_text

---@class BookItem__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class BookItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private scrollView BookItem__Generate_scrollView
---@field private dscBox BookItem__Generate_dscBox
---@field private toggleGroup BookItem__Generate_toggleGroup
---@field private toggleAll BookItem__Generate_toggleAll
---@field private toggleNormal BookItem__Generate_toggleNormal
---@field private toggleMini BookItem__Generate_toggleMini
---@field private toggleMVP BookItem__Generate_toggleMVP
---@field private qtyCard BookItem__Generate_qtyCard
---@field private qtyPet BookItem__Generate_qtyPet
---@field private qtyCollection BookItem__Generate_qtyCollection
---@field private btnMaterials BookItem__Generate_btnMaterials
---@field private btnBack BookItem__Generate_btnBack
local BookItemView = class("BookItemView")

function BookItemView:ctor()
end

---@private
function BookItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function BookItemView:InitGenerate(Root, data)
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


end

---@private
function BookItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function BookItemView:InitGenerate__2(Root, data)
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
function BookItemView:InitGenerate__3(Root, data)
--[[
	ScrollView/DscBox
--]]
	local tmp = Root:Find("ScrollView/DscBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox = tmp
end

---@private
function BookItemView:InitGenerate__4(Root, data)
--[[
	ScrollView/DscBox/bg/Text
--]]
	local tmp = Root:Find("ScrollView/DscBox/bg/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BookItemView:InitGenerate__5(Root, data)
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
function BookItemView:InitGenerate__6(Root, data)
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
function BookItemView:InitGenerate__7(Root, data)
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
function BookItemView:InitGenerate__8(Root, data)
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
function BookItemView:InitGenerate__9(Root, data)
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
function BookItemView:InitGenerate__10(Root, data)
--[[
	QtyCard
--]]
	local tmp = Root:Find("QtyCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyCard = tmp
end

---@private
function BookItemView:InitGenerate__11(Root, data)
--[[
	QtyCard/IconAll
--]]
	local tmp = Root:Find("QtyCard/IconAll").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyCard.iconAll = tmp
end

---@private
function BookItemView:InitGenerate__12(Root, data)
--[[
	QtyCard/IconNormal
--]]
	local tmp = Root:Find("QtyCard/IconNormal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyCard.iconNormal = tmp
end

---@private
function BookItemView:InitGenerate__13(Root, data)
--[[
	QtyCard/IconMini
--]]
	local tmp = Root:Find("QtyCard/IconMini").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyCard.iconMini = tmp
end

---@private
function BookItemView:InitGenerate__14(Root, data)
--[[
	QtyCard/IconMvp
--]]
	local tmp = Root:Find("QtyCard/IconMvp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyCard.iconMvp = tmp
end

---@private
function BookItemView:InitGenerate__15(Root, data)
--[[
	QtyCard/Text
--]]
	local tmp = Root:Find("QtyCard/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyCard.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BookItemView:InitGenerate__16(Root, data)
--[[
	QtyPet
--]]
	local tmp = Root:Find("QtyPet").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyPet = tmp
end

---@private
function BookItemView:InitGenerate__17(Root, data)
--[[
	QtyPet/IconAll
--]]
	local tmp = Root:Find("QtyPet/IconAll").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyPet.iconAll = tmp
end

---@private
function BookItemView:InitGenerate__18(Root, data)
--[[
	QtyPet/IconNormal
--]]
	local tmp = Root:Find("QtyPet/IconNormal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyPet.iconNormal = tmp
end

---@private
function BookItemView:InitGenerate__19(Root, data)
--[[
	QtyPet/IconMini
--]]
	local tmp = Root:Find("QtyPet/IconMini").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyPet.iconMini = tmp
end

---@private
function BookItemView:InitGenerate__20(Root, data)
--[[
	QtyPet/IconMvp
--]]
	local tmp = Root:Find("QtyPet/IconMvp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyPet.iconMvp = tmp
end

---@private
function BookItemView:InitGenerate__21(Root, data)
--[[
	QtyPet/Text
--]]
	local tmp = Root:Find("QtyPet/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyPet.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BookItemView:InitGenerate__22(Root, data)
--[[
	QtyCollection
--]]
	local tmp = Root:Find("QtyCollection").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyCollection = tmp
end

---@private
function BookItemView:InitGenerate__23(Root, data)
--[[
	QtyCollection/IconAll
--]]
	local tmp = Root:Find("QtyCollection/IconAll").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyCollection.iconAll = tmp
end

---@private
function BookItemView:InitGenerate__24(Root, data)
--[[
	QtyCollection/IconNormal
--]]
	local tmp = Root:Find("QtyCollection/IconNormal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyCollection.iconNormal = tmp
end

---@private
function BookItemView:InitGenerate__25(Root, data)
--[[
	QtyCollection/IconMini
--]]
	local tmp = Root:Find("QtyCollection/IconMini").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyCollection.iconMini = tmp
end

---@private
function BookItemView:InitGenerate__26(Root, data)
--[[
	QtyCollection/IconMvp
--]]
	local tmp = Root:Find("QtyCollection/IconMvp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyCollection.iconMvp = tmp
end

---@private
function BookItemView:InitGenerate__27(Root, data)
--[[
	QtyCollection/Text
--]]
	local tmp = Root:Find("QtyCollection/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qtyCollection.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BookItemView:InitGenerate__28(Root, data)
--[[
	BtnMaterials
--]]
	local tmp = Root:Find("BtnMaterials").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnMaterials = tmp
	self.btnMaterials:SetActive(false)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function BookItemView:InitGenerate__29(Root, data)
--[[
	BtnMaterials/Icon
--]]
	local tmp = Root:Find("BtnMaterials/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnMaterials.icon = tmp
end

---@private
function BookItemView:InitGenerate__30(Root, data)
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
function BookItemView:GenerateDestroy()
	if tolua.getpeer(self.btnMaterials.icon) ~= nil then
		tolua.setpeer(self.btnMaterials.icon, nil)
	end
	if tolua.getpeer(self.qtyCollection.text) ~= nil then
		tolua.setpeer(self.qtyCollection.text, nil)
	end
	if tolua.getpeer(self.qtyCollection.iconMvp) ~= nil then
		tolua.setpeer(self.qtyCollection.iconMvp, nil)
	end
	if tolua.getpeer(self.qtyCollection.iconMini) ~= nil then
		tolua.setpeer(self.qtyCollection.iconMini, nil)
	end
	if tolua.getpeer(self.qtyCollection.iconNormal) ~= nil then
		tolua.setpeer(self.qtyCollection.iconNormal, nil)
	end
	if tolua.getpeer(self.qtyCollection.iconAll) ~= nil then
		tolua.setpeer(self.qtyCollection.iconAll, nil)
	end
	if tolua.getpeer(self.qtyPet.text) ~= nil then
		tolua.setpeer(self.qtyPet.text, nil)
	end
	if tolua.getpeer(self.qtyPet.iconMvp) ~= nil then
		tolua.setpeer(self.qtyPet.iconMvp, nil)
	end
	if tolua.getpeer(self.qtyPet.iconMini) ~= nil then
		tolua.setpeer(self.qtyPet.iconMini, nil)
	end
	if tolua.getpeer(self.qtyPet.iconNormal) ~= nil then
		tolua.setpeer(self.qtyPet.iconNormal, nil)
	end
	if tolua.getpeer(self.qtyPet.iconAll) ~= nil then
		tolua.setpeer(self.qtyPet.iconAll, nil)
	end
	if tolua.getpeer(self.qtyCard.text) ~= nil then
		tolua.setpeer(self.qtyCard.text, nil)
	end
	if tolua.getpeer(self.qtyCard.iconMvp) ~= nil then
		tolua.setpeer(self.qtyCard.iconMvp, nil)
	end
	if tolua.getpeer(self.qtyCard.iconMini) ~= nil then
		tolua.setpeer(self.qtyCard.iconMini, nil)
	end
	if tolua.getpeer(self.qtyCard.iconNormal) ~= nil then
		tolua.setpeer(self.qtyCard.iconNormal, nil)
	end
	if tolua.getpeer(self.qtyCard.iconAll) ~= nil then
		tolua.setpeer(self.qtyCard.iconAll, nil)
	end
	if tolua.getpeer(self.dscBox.text) ~= nil then
		tolua.setpeer(self.dscBox.text, nil)
	end
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.dscBox) ~= nil then
		tolua.setpeer(self.dscBox, nil)
	end
	self.dscBox = nil
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
	if tolua.getpeer(self.qtyCard) ~= nil then
		tolua.setpeer(self.qtyCard, nil)
	end
	self.qtyCard = nil
	if tolua.getpeer(self.qtyPet) ~= nil then
		tolua.setpeer(self.qtyPet, nil)
	end
	self.qtyPet = nil
	if tolua.getpeer(self.qtyCollection) ~= nil then
		tolua.setpeer(self.qtyCollection, nil)
	end
	self.qtyCollection = nil
	if tolua.getpeer(self.btnMaterials) ~= nil then
		tolua.setpeer(self.btnMaterials, nil)
	end
	self.btnMaterials = nil
	if tolua.getpeer(self.btnBack) ~= nil then
		tolua.setpeer(self.btnBack, nil)
	end
	self.btnBack = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return BookItemView