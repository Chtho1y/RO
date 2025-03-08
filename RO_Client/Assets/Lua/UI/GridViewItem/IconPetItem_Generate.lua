---@class IconPetItem__Generate_petName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class IconPetItem__Generate_locked
---@field public gameObject UnityEngine.GameObject
---@field public locked UnityEngine.GameObject

---@class IconPetItem__Generate_star_advenceLv
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class IconPetItem__Generate_star
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public advenceLv IconPetItem__Generate_star_advenceLv

---@class IconPetItem__Generate_contract
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconPetItem__Generate_battle
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconPetItem__Generate_relation
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconPetItem__Generate_support
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconPetItem__Generate_advenceLv
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class IconPetItem__Generate_advence
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconPetItem__Generate_addMask
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class IconPetItem__Generate_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class IconPetItem__Generate_nature
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconPetItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconPetItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public uIEventTriggerListener UIEventTriggerListener

---@class IconPetItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class IconPetItem__Generate_shadow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class IconPetItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private layoutElement UnityEngine.UI.LayoutElement
---@field private shadow IconPetItem__Generate_shadow
---@field private bg IconPetItem__Generate_bg
---@field private icon IconPetItem__Generate_icon
---@field private frame IconPetItem__Generate_frame
---@field private nature IconPetItem__Generate_nature
---@field private num IconPetItem__Generate_num
---@field private qualityFX UnityEngine.GameObject
---@field private addMask IconPetItem__Generate_addMask
---@field private advence IconPetItem__Generate_advence
---@field private advenceLv IconPetItem__Generate_advenceLv
---@field private support IconPetItem__Generate_support
---@field private relation IconPetItem__Generate_relation
---@field private battle IconPetItem__Generate_battle
---@field private contract IconPetItem__Generate_contract
---@field private star IconPetItem__Generate_star
---@field private selected UnityEngine.GameObject
---@field private locked IconPetItem__Generate_locked
---@field private nameBg UnityEngine.GameObject
---@field private petName IconPetItem__Generate_petName
local IconPetItemView = class("IconPetItemView")

function IconPetItemView:ctor()
end

---@private
function IconPetItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function IconPetItemView:InitGenerate(Root, data)
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


end

---@private
function IconPetItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)

	self.layoutElement = Root:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function IconPetItemView:InitGenerate__2(Root, data)
--[[
	shadow
--]]
	local tmp = Root:Find("shadow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.shadow = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function IconPetItemView:InitGenerate__3(Root, data)
--[[
	bg
--]]
	local tmp = Root:Find("bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function IconPetItemView:InitGenerate__4(Root, data)
--[[
	Icon
--]]
	local tmp = Root:Find("Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
end

---@private
function IconPetItemView:InitGenerate__5(Root, data)
--[[
	Frame
--]]
	local tmp = Root:Find("Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frame = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconPetItemView:InitGenerate__6(Root, data)
--[[
	Nature
--]]
	local tmp = Root:Find("Nature").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nature = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconPetItemView:InitGenerate__7(Root, data)
--[[
	Num
--]]
	local tmp = Root:Find("Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function IconPetItemView:InitGenerate__8(Root, data)
--[[
	QualityFX
--]]
	local tmp = Root:Find("QualityFX").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qualityFX = tmp
end

---@private
function IconPetItemView:InitGenerate__9(Root, data)
--[[
	AddMask
--]]
	local tmp = Root:Find("AddMask").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addMask = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function IconPetItemView:InitGenerate__10(Root, data)
--[[
	Advence
--]]
	local tmp = Root:Find("Advence").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.advence = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconPetItemView:InitGenerate__11(Root, data)
--[[
	Advence/AdvenceLv
--]]
	local tmp = Root:Find("Advence/AdvenceLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.advenceLv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function IconPetItemView:InitGenerate__12(Root, data)
--[[
	Support
--]]
	local tmp = Root:Find("Support").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.support = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconPetItemView:InitGenerate__13(Root, data)
--[[
	Relation
--]]
	local tmp = Root:Find("Relation").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.relation = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconPetItemView:InitGenerate__14(Root, data)
--[[
	Battle
--]]
	local tmp = Root:Find("Battle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.battle = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconPetItemView:InitGenerate__15(Root, data)
--[[
	Contract
--]]
	local tmp = Root:Find("Contract").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contract = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconPetItemView:InitGenerate__16(Root, data)
--[[
	Star
--]]
	local tmp = Root:Find("Star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.star = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconPetItemView:InitGenerate__17(Root, data)
--[[
	Star/AdvenceLv
--]]
	local tmp = Root:Find("Star/AdvenceLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.star.advenceLv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function IconPetItemView:InitGenerate__18(Root, data)
--[[
	Selected
--]]
	local tmp = Root:Find("Selected").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selected = tmp
end

---@private
function IconPetItemView:InitGenerate__19(Root, data)
--[[
	Locked
--]]
	local tmp = Root:Find("Locked").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.locked = tmp
end

---@private
function IconPetItemView:InitGenerate__20(Root, data)
--[[
	Locked/Locked
--]]
	local tmp = Root:Find("Locked/Locked").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.locked.locked = tmp
end

---@private
function IconPetItemView:InitGenerate__21(Root, data)
--[[
	NameBg
--]]
	local tmp = Root:Find("NameBg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameBg = tmp
end

---@private
function IconPetItemView:InitGenerate__22(Root, data)
--[[
	NameBg/petName
--]]
	local tmp = Root:Find("NameBg/petName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function IconPetItemView:GenerateDestroy()
	if tolua.getpeer(self.locked.locked) ~= nil then
		tolua.setpeer(self.locked.locked, nil)
	end
	if tolua.getpeer(self.star.advenceLv) ~= nil then
		tolua.setpeer(self.star.advenceLv, nil)
	end
	if tolua.getpeer(self.shadow) ~= nil then
		tolua.setpeer(self.shadow, nil)
	end
	self.shadow = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	self.frame = nil
	if tolua.getpeer(self.nature) ~= nil then
		tolua.setpeer(self.nature, nil)
	end
	self.nature = nil
	if tolua.getpeer(self.num) ~= nil then
		tolua.setpeer(self.num, nil)
	end
	self.num = nil
	if tolua.getpeer(self.qualityFX) ~= nil then
		tolua.setpeer(self.qualityFX, nil)
	end
	self.qualityFX = nil
	if tolua.getpeer(self.addMask) ~= nil then
		tolua.setpeer(self.addMask, nil)
	end
	self.addMask = nil
	if tolua.getpeer(self.advence) ~= nil then
		tolua.setpeer(self.advence, nil)
	end
	self.advence = nil
	if tolua.getpeer(self.advenceLv) ~= nil then
		tolua.setpeer(self.advenceLv, nil)
	end
	self.advenceLv = nil
	if tolua.getpeer(self.support) ~= nil then
		tolua.setpeer(self.support, nil)
	end
	self.support = nil
	if tolua.getpeer(self.relation) ~= nil then
		tolua.setpeer(self.relation, nil)
	end
	self.relation = nil
	if tolua.getpeer(self.battle) ~= nil then
		tolua.setpeer(self.battle, nil)
	end
	self.battle = nil
	if tolua.getpeer(self.contract) ~= nil then
		tolua.setpeer(self.contract, nil)
	end
	self.contract = nil
	if tolua.getpeer(self.star) ~= nil then
		tolua.setpeer(self.star, nil)
	end
	self.star = nil
	if tolua.getpeer(self.selected) ~= nil then
		tolua.setpeer(self.selected, nil)
	end
	self.selected = nil
	if tolua.getpeer(self.locked) ~= nil then
		tolua.setpeer(self.locked, nil)
	end
	self.locked = nil
	if tolua.getpeer(self.nameBg) ~= nil then
		tolua.setpeer(self.nameBg, nil)
	end
	self.nameBg = nil
	if tolua.getpeer(self.petName) ~= nil then
		tolua.setpeer(self.petName, nil)
	end
	self.petName = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return IconPetItemView