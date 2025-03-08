---@class CastingSkillItem__Generate_skillTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CastingSkillItem__Generate_skillIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class CastingSkillItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private frame UnityEngine.GameObject
---@field private skillIcon CastingSkillItem__Generate_skillIcon
---@field private skillTime CastingSkillItem__Generate_skillTime
local CastingSkillItemView = class("CastingSkillItemView")

function CastingSkillItemView:ctor()
end

---@private
function CastingSkillItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CastingSkillItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function CastingSkillItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function CastingSkillItemView:InitGenerate__2(Root, data)
--[[
	Frame
--]]
	local tmp = Root:Find("Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frame = tmp
end

---@private
function CastingSkillItemView:InitGenerate__3(Root, data)
--[[
	Icon
--]]
	local tmp = Root:Find("Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function CastingSkillItemView:InitGenerate__4(Root, data)
--[[
	SkillTime
--]]
	local tmp = Root:Find("SkillTime").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function CastingSkillItemView:GenerateDestroy()
	if tolua.getpeer(self.skillTime) ~= nil then
		tolua.setpeer(self.skillTime, nil)
	end
	if tolua.getpeer(self.skillIcon) ~= nil then
		tolua.setpeer(self.skillIcon, nil)
	end
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	self.frame = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return CastingSkillItemView