---@class SkillLvAttrItem__Generate_attrText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class SkillLvAttrItem__Generate_lvText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class SkillLvAttrItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private lvText SkillLvAttrItem__Generate_lvText
---@field private attrText SkillLvAttrItem__Generate_attrText
local SkillLvAttrItemView = class("SkillLvAttrItemView")

function SkillLvAttrItemView:ctor()
end

---@private
function SkillLvAttrItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function SkillLvAttrItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function SkillLvAttrItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function SkillLvAttrItemView:InitGenerate__2(Root, data)
--[[
	LvText
--]]
	local tmp = Root:Find("LvText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lvText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function SkillLvAttrItemView:InitGenerate__3(Root, data)
--[[
	AttrText
--]]
	local tmp = Root:Find("AttrText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function SkillLvAttrItemView:GenerateDestroy()
	if tolua.getpeer(self.lvText) ~= nil then
		tolua.setpeer(self.lvText, nil)
	end
	self.lvText = nil
	if tolua.getpeer(self.attrText) ~= nil then
		tolua.setpeer(self.attrText, nil)
	end
	self.attrText = nil
	self.inited = false
end
return SkillLvAttrItemView