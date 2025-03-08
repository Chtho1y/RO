---@class RankRewardsItem__Generate_labelRank_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class RankRewardsItem__Generate_imageLabel
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RankRewardsItem__Generate_labelRank
---@field public gameObject UnityEngine.GameObject
---@field public text RankRewardsItem__Generate_labelRank_text

---@class RankRewardsItem__Generate_pets_pet4_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RankRewardsItem__Generate_pets_pet4_iconPetItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RankRewardsItem__Generate_pets_pet4
---@field public gameObject UnityEngine.GameObject
---@field public iconPetItem RankRewardsItem__Generate_pets_pet4_iconPetItem
---@field public num RankRewardsItem__Generate_pets_pet4_num

---@class RankRewardsItem__Generate_pets_pet3_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RankRewardsItem__Generate_pets_pet3_iconPetItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RankRewardsItem__Generate_pets_pet3
---@field public gameObject UnityEngine.GameObject
---@field public iconPetItem RankRewardsItem__Generate_pets_pet3_iconPetItem
---@field public num RankRewardsItem__Generate_pets_pet3_num

---@class RankRewardsItem__Generate_pets_pet2_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RankRewardsItem__Generate_pets_pet2_iconPetItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RankRewardsItem__Generate_pets_pet2
---@field public gameObject UnityEngine.GameObject
---@field public iconPetItem RankRewardsItem__Generate_pets_pet2_iconPetItem
---@field public num RankRewardsItem__Generate_pets_pet2_num

---@class RankRewardsItem__Generate_pets_pet1_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RankRewardsItem__Generate_pets_pet1_iconPetItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RankRewardsItem__Generate_pets_pet1
---@field public gameObject UnityEngine.GameObject
---@field public iconPetItem RankRewardsItem__Generate_pets_pet1_iconPetItem
---@field public num RankRewardsItem__Generate_pets_pet1_num

---@class RankRewardsItem__Generate_pets_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class RankRewardsItem__Generate_pets
---@field public gameObject UnityEngine.GameObject
---@field public icon RankRewardsItem__Generate_pets_icon
---@field public pet1 RankRewardsItem__Generate_pets_pet1
---@field public pet2 RankRewardsItem__Generate_pets_pet2
---@field public pet3 RankRewardsItem__Generate_pets_pet3
---@field public pet4 RankRewardsItem__Generate_pets_pet4

---@class RankRewardsItem__Generate_RewardsNode
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class RankRewardsItem__Generate_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RankRewardsItem__Generate_textLowestTarget
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RankRewardsItem__Generate_textAdvTarget
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RankRewardsItem__Generate_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RankRewardsItem__Generate_textDsc
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class RankRewardsItem__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RankRewardsItem__Generate_nameBG
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RankRewardsItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private name UnityEngine.GameObject
---@field private nameBG RankRewardsItem__Generate_nameBG
---@field private textName RankRewardsItem__Generate_textName
---@field private textDsc RankRewardsItem__Generate_textDsc
---@field private num RankRewardsItem__Generate_num
---@field private textAdvTarget RankRewardsItem__Generate_textAdvTarget
---@field private textLowestTarget RankRewardsItem__Generate_textLowestTarget
---@field private iconSmallItem RankRewardsItem__Generate_iconSmallItem
---@field private RewardsNode RankRewardsItem__Generate_RewardsNode
---@field private pets RankRewardsItem__Generate_pets
---@field private labelEstimate UnityEngine.GameObject
---@field private labelReceived UnityEngine.GameObject
---@field private labelRank RankRewardsItem__Generate_labelRank
---@field private imageLabel RankRewardsItem__Generate_imageLabel
local RankRewardsItemView = class("RankRewardsItemView")

function RankRewardsItemView:ctor()
end

---@private
function RankRewardsItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RankRewardsItemView:InitGenerate(Root, data)
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


end

---@private
function RankRewardsItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function RankRewardsItemView:InitGenerate__2(Root, data)
--[[
	Name
--]]
	local tmp = Root:Find("Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.name = tmp
end

---@private
function RankRewardsItemView:InitGenerate__3(Root, data)
--[[
	Name/NameBG
--]]
	local tmp = Root:Find("Name/NameBG").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameBG = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RankRewardsItemView:InitGenerate__4(Root, data)
--[[
	Name/TextName
--]]
	local tmp = Root:Find("Name/TextName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RankRewardsItemView:InitGenerate__5(Root, data)
--[[
	Name/TextDsc
--]]
	local tmp = Root:Find("Name/TextDsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textDsc = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function RankRewardsItemView:InitGenerate__6(Root, data)
--[[
	Name/Num
--]]
	local tmp = Root:Find("Name/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RankRewardsItemView:InitGenerate__7(Root, data)
--[[
	Name/TextAdvTarget
--]]
	local tmp = Root:Find("Name/TextAdvTarget").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textAdvTarget = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RankRewardsItemView:InitGenerate__8(Root, data)
--[[
	Name/TextLowestTarget
--]]
	local tmp = Root:Find("Name/TextLowestTarget").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textLowestTarget = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RankRewardsItemView:InitGenerate__9(Root, data)
--[[
	IconSmallItem
--]]
	local tmp = Root:Find("IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RankRewardsItemView:InitGenerate__10(Root, data)
--[[
	Rewards
--]]
	local tmp = Root:Find("Rewards").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.RewardsNode = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function RankRewardsItemView:InitGenerate__11(Root, data)
--[[
	Pets
--]]
	local tmp = Root:Find("Pets").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pets = tmp
end

---@private
function RankRewardsItemView:InitGenerate__12(Root, data)
--[[
	Pets/icon
--]]
	local tmp = Root:Find("Pets/icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pets.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function RankRewardsItemView:InitGenerate__13(Root, data)
--[[
	Pets/Pet1
--]]
	local tmp = Root:Find("Pets/Pet1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pets.pet1 = tmp
end

---@private
function RankRewardsItemView:InitGenerate__14(Root, data)
--[[
	Pets/Pet1/IconPetItem
--]]
	local tmp = Root:Find("Pets/Pet1/IconPetItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pets.pet1.iconPetItem = CommonUtil.BindGridViewItem2LuaStatic("IconPetItem", tmp)
	self.pets.pet1.iconPetItem.prefabName = "IconPetItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RankRewardsItemView:InitGenerate__15(Root, data)
--[[
	Pets/Pet1/num
--]]
	local tmp = Root:Find("Pets/Pet1/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pets.pet1.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RankRewardsItemView:InitGenerate__16(Root, data)
--[[
	Pets/Pet2
--]]
	local tmp = Root:Find("Pets/Pet2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pets.pet2 = tmp
end

---@private
function RankRewardsItemView:InitGenerate__17(Root, data)
--[[
	Pets/Pet2/IconPetItem
--]]
	local tmp = Root:Find("Pets/Pet2/IconPetItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pets.pet2.iconPetItem = CommonUtil.BindGridViewItem2LuaStatic("IconPetItem", tmp)
	self.pets.pet2.iconPetItem.prefabName = "IconPetItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RankRewardsItemView:InitGenerate__18(Root, data)
--[[
	Pets/Pet2/num
--]]
	local tmp = Root:Find("Pets/Pet2/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pets.pet2.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RankRewardsItemView:InitGenerate__19(Root, data)
--[[
	Pets/Pet3
--]]
	local tmp = Root:Find("Pets/Pet3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pets.pet3 = tmp
end

---@private
function RankRewardsItemView:InitGenerate__20(Root, data)
--[[
	Pets/Pet3/IconPetItem
--]]
	local tmp = Root:Find("Pets/Pet3/IconPetItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pets.pet3.iconPetItem = CommonUtil.BindGridViewItem2LuaStatic("IconPetItem", tmp)
	self.pets.pet3.iconPetItem.prefabName = "IconPetItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RankRewardsItemView:InitGenerate__21(Root, data)
--[[
	Pets/Pet3/num
--]]
	local tmp = Root:Find("Pets/Pet3/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pets.pet3.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RankRewardsItemView:InitGenerate__22(Root, data)
--[[
	Pets/Pet4
--]]
	local tmp = Root:Find("Pets/Pet4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pets.pet4 = tmp
end

---@private
function RankRewardsItemView:InitGenerate__23(Root, data)
--[[
	Pets/Pet4/IconPetItem
--]]
	local tmp = Root:Find("Pets/Pet4/IconPetItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pets.pet4.iconPetItem = CommonUtil.BindGridViewItem2LuaStatic("IconPetItem", tmp)
	self.pets.pet4.iconPetItem.prefabName = "IconPetItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RankRewardsItemView:InitGenerate__24(Root, data)
--[[
	Pets/Pet4/num
--]]
	local tmp = Root:Find("Pets/Pet4/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pets.pet4.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RankRewardsItemView:InitGenerate__25(Root, data)
--[[
	LabelEstimate
--]]
	local tmp = Root:Find("LabelEstimate").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelEstimate = tmp
	self.labelEstimate:SetActive(false)
end

---@private
function RankRewardsItemView:InitGenerate__26(Root, data)
--[[
	LabelReceived
--]]
	local tmp = Root:Find("LabelReceived").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelReceived = tmp
	self.labelReceived:SetActive(false)
end

---@private
function RankRewardsItemView:InitGenerate__27(Root, data)
--[[
	LabelRank
--]]
	local tmp = Root:Find("LabelRank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelRank = tmp
end

---@private
function RankRewardsItemView:InitGenerate__28(Root, data)
--[[
	LabelRank/ImageLabel
--]]
	local tmp = Root:Find("LabelRank/ImageLabel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.imageLabel = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RankRewardsItemView:InitGenerate__29(Root, data)
--[[
	LabelRank/Text
--]]
	local tmp = Root:Find("LabelRank/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelRank.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function RankRewardsItemView:GenerateDestroy()
	if tolua.getpeer(self.labelRank.text) ~= nil then
		tolua.setpeer(self.labelRank.text, nil)
	end
	if tolua.getpeer(self.pets.pet4.num) ~= nil then
		tolua.setpeer(self.pets.pet4.num, nil)
	end
	if self.pets.pet4.iconPetItem.GenerateDestroy ~= nil then
		self.pets.pet4.iconPetItem:GenerateDestroy()
	end
	if tolua.getpeer(self.pets.pet4.iconPetItem) ~= nil then
		tolua.setpeer(self.pets.pet4.iconPetItem, nil)
	end
	if tolua.getpeer(self.pets.pet4) ~= nil then
		tolua.setpeer(self.pets.pet4, nil)
	end
	if tolua.getpeer(self.pets.pet3.num) ~= nil then
		tolua.setpeer(self.pets.pet3.num, nil)
	end
	if self.pets.pet3.iconPetItem.GenerateDestroy ~= nil then
		self.pets.pet3.iconPetItem:GenerateDestroy()
	end
	if tolua.getpeer(self.pets.pet3.iconPetItem) ~= nil then
		tolua.setpeer(self.pets.pet3.iconPetItem, nil)
	end
	if tolua.getpeer(self.pets.pet3) ~= nil then
		tolua.setpeer(self.pets.pet3, nil)
	end
	if tolua.getpeer(self.pets.pet2.num) ~= nil then
		tolua.setpeer(self.pets.pet2.num, nil)
	end
	if self.pets.pet2.iconPetItem.GenerateDestroy ~= nil then
		self.pets.pet2.iconPetItem:GenerateDestroy()
	end
	if tolua.getpeer(self.pets.pet2.iconPetItem) ~= nil then
		tolua.setpeer(self.pets.pet2.iconPetItem, nil)
	end
	if tolua.getpeer(self.pets.pet2) ~= nil then
		tolua.setpeer(self.pets.pet2, nil)
	end
	if tolua.getpeer(self.pets.pet1.num) ~= nil then
		tolua.setpeer(self.pets.pet1.num, nil)
	end
	if self.pets.pet1.iconPetItem.GenerateDestroy ~= nil then
		self.pets.pet1.iconPetItem:GenerateDestroy()
	end
	if tolua.getpeer(self.pets.pet1.iconPetItem) ~= nil then
		tolua.setpeer(self.pets.pet1.iconPetItem, nil)
	end
	if tolua.getpeer(self.pets.pet1) ~= nil then
		tolua.setpeer(self.pets.pet1, nil)
	end
	if tolua.getpeer(self.pets.icon) ~= nil then
		tolua.setpeer(self.pets.icon, nil)
	end
	if tolua.getpeer(self.textLowestTarget) ~= nil then
		tolua.setpeer(self.textLowestTarget, nil)
	end
	if tolua.getpeer(self.textAdvTarget) ~= nil then
		tolua.setpeer(self.textAdvTarget, nil)
	end
	if tolua.getpeer(self.num) ~= nil then
		tolua.setpeer(self.num, nil)
	end
	if tolua.getpeer(self.textDsc) ~= nil then
		tolua.setpeer(self.textDsc, nil)
	end
	if tolua.getpeer(self.textName) ~= nil then
		tolua.setpeer(self.textName, nil)
	end
	if tolua.getpeer(self.name) ~= nil then
		tolua.setpeer(self.name, nil)
	end
	self.name = nil
	if tolua.getpeer(self.nameBG) ~= nil then
		tolua.setpeer(self.nameBG, nil)
	end
	self.nameBG = nil
	if self.iconSmallItem.GenerateDestroy ~= nil then
		self.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconSmallItem) ~= nil then
		tolua.setpeer(self.iconSmallItem, nil)
	end
	self.iconSmallItem = nil
	if tolua.getpeer(self.RewardsNode) ~= nil then
		tolua.setpeer(self.RewardsNode, nil)
	end
	self.RewardsNode = nil
	if tolua.getpeer(self.pets) ~= nil then
		tolua.setpeer(self.pets, nil)
	end
	self.pets = nil
	if tolua.getpeer(self.labelEstimate) ~= nil then
		tolua.setpeer(self.labelEstimate, nil)
	end
	self.labelEstimate = nil
	if tolua.getpeer(self.labelReceived) ~= nil then
		tolua.setpeer(self.labelReceived, nil)
	end
	self.labelReceived = nil
	if tolua.getpeer(self.labelRank) ~= nil then
		tolua.setpeer(self.labelRank, nil)
	end
	self.labelRank = nil
	if tolua.getpeer(self.imageLabel) ~= nil then
		tolua.setpeer(self.imageLabel, nil)
	end
	self.imageLabel = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RankRewardsItemView