---@class SkillSlotOriginal__Generate_slotText
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class SkillSlotOriginal__Generate_textLV
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class SkillSlotOriginal__Generate_skillName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class SkillSlotOriginal__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class SkillSlotOriginal__Generate_skillItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class SkillSlotOriginal__Generate_skillListItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class SkillSlotOriginal__Generate_locked_textLocked
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class SkillSlotOriginal__Generate_locked
---@field public gameObject UnityEngine.GameObject
---@field public textLocked SkillSlotOriginal__Generate_locked_textLocked

---@class SkillSlotOriginal__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private locked SkillSlotOriginal__Generate_locked
---@field private noSkill UnityEngine.GameObject
---@field private skillListItem SkillSlotOriginal__Generate_skillListItem
---@field private contentItem UnityEngine.GameObject
---@field private skillItem SkillSlotOriginal__Generate_skillItem
---@field private desTxt SkillSlotOriginal__Generate_desTxt
---@field private skillName SkillSlotOriginal__Generate_skillName
---@field private textLV SkillSlotOriginal__Generate_textLV
---@field private slotText SkillSlotOriginal__Generate_slotText
local SkillSlotOriginalView = class("SkillSlotOriginalView")

function SkillSlotOriginalView:ctor()
end

---@private
function SkillSlotOriginalView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function SkillSlotOriginalView:InitGenerate(Root, data)
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


end

---@private
function SkillSlotOriginalView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function SkillSlotOriginalView:InitGenerate__2(Root, data)
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
function SkillSlotOriginalView:InitGenerate__3(Root, data)
--[[
	Locked/TextLocked
--]]
	local tmp = Root:Find("Locked/TextLocked").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.locked.textLocked = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function SkillSlotOriginalView:InitGenerate__4(Root, data)
--[[
	NoSkill
--]]
	local tmp = Root:Find("NoSkill").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noSkill = tmp
end

---@private
function SkillSlotOriginalView:InitGenerate__5(Root, data)
--[[
	SkillListItem
--]]
	local tmp = Root:Find("SkillListItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillListItem = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function SkillSlotOriginalView:InitGenerate__6(Root, data)
--[[
	SkillListItem/ContentItem
--]]
	local tmp = Root:Find("SkillListItem/ContentItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contentItem = tmp
end

---@private
function SkillSlotOriginalView:InitGenerate__7(Root, data)
--[[
	SkillListItem/ContentItem/SkillItem
--]]
	local tmp = Root:Find("SkillListItem/ContentItem/SkillItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillItem = CommonUtil.BindGridViewItem2LuaStatic("SkillItem", tmp)
	self.skillItem.prefabName = "SkillItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function SkillSlotOriginalView:InitGenerate__8(Root, data)
--[[
	SkillListItem/DscBox/Viewport/Content/DesTxt
--]]
	local tmp = Root:Find("SkillListItem/DscBox/Viewport/Content/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function SkillSlotOriginalView:InitGenerate__9(Root, data)
--[[
	SkillListItem/SkillName
--]]
	local tmp = Root:Find("SkillListItem/SkillName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function SkillSlotOriginalView:InitGenerate__10(Root, data)
--[[
	SkillListItem/TextLV
--]]
	local tmp = Root:Find("SkillListItem/TextLV").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textLV = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function SkillSlotOriginalView:InitGenerate__11(Root, data)
--[[
	SkillListItem/SlotText
--]]
	local tmp = Root:Find("SkillListItem/SlotText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slotText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function SkillSlotOriginalView:GenerateDestroy()
	if tolua.getpeer(self.textLV) ~= nil then
		tolua.setpeer(self.textLV, nil)
	end
	if tolua.getpeer(self.noSkill) ~= nil then
		tolua.setpeer(self.noSkill, nil)
	end
	if tolua.getpeer(self.locked.textLocked) ~= nil then
		tolua.setpeer(self.locked.textLocked, nil)
	end
	if tolua.getpeer(self.locked) ~= nil then
		tolua.setpeer(self.locked, nil)
	end
	if tolua.getpeer(self.skillListItem) ~= nil then
		tolua.setpeer(self.skillListItem, nil)
	end
	self.skillListItem = nil
	if tolua.getpeer(self.contentItem) ~= nil then
		tolua.setpeer(self.contentItem, nil)
	end
	self.contentItem = nil
	if self.skillItem.GenerateDestroy ~= nil then
		self.skillItem:GenerateDestroy()
	end
	if tolua.getpeer(self.skillItem) ~= nil then
		tolua.setpeer(self.skillItem, nil)
	end
	self.skillItem = nil
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	if tolua.getpeer(self.skillName) ~= nil then
		tolua.setpeer(self.skillName, nil)
	end
	self.skillName = nil
	if tolua.getpeer(self.slotText) ~= nil then
		tolua.setpeer(self.slotText, nil)
	end
	self.slotText = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return SkillSlotOriginalView