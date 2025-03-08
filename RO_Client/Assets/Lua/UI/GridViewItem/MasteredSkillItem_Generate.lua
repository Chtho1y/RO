---@class MasteredSkillItem__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class MasteredSkillItem__Generate_skillItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class MasteredSkillItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private skillItem MasteredSkillItem__Generate_skillItem
---@field private text MasteredSkillItem__Generate_text
local MasteredSkillItemView = class("MasteredSkillItemView")

function MasteredSkillItemView:ctor()
end

---@private
function MasteredSkillItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function MasteredSkillItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function MasteredSkillItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function MasteredSkillItemView:InitGenerate__2(Root, data)
--[[
	SkillItem
--]]
	local tmp = Root:Find("SkillItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillItem = CommonUtil.BindGridViewItem2LuaStatic("SkillItem", tmp)
	self.skillItem.prefabName = "SkillItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function MasteredSkillItemView:InitGenerate__3(Root, data)
--[[
	Name/Text
--]]
	local tmp = Root:Find("Name/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function MasteredSkillItemView:GenerateDestroy()
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	if self.skillItem.GenerateDestroy ~= nil then
		self.skillItem:GenerateDestroy()
	end
	if tolua.getpeer(self.skillItem) ~= nil then
		tolua.setpeer(self.skillItem, nil)
	end
	self.skillItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return MasteredSkillItemView