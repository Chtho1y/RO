---@class SkillTagItem__Generate_textSkillID
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class SkillTagItem__Generate_bgColorID
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class SkillTagItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bgColorID SkillTagItem__Generate_bgColorID
---@field private textSkillID SkillTagItem__Generate_textSkillID
local SkillTagItemView = class("SkillTagItemView")

function SkillTagItemView:ctor()
end

---@private
function SkillTagItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function SkillTagItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function SkillTagItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function SkillTagItemView:InitGenerate__2(Root, data)
--[[
	BgColorID
--]]
	local tmp = Root:Find("BgColorID").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bgColorID = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function SkillTagItemView:InitGenerate__3(Root, data)
--[[
	TextSkillID
--]]
	local tmp = Root:Find("TextSkillID").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textSkillID = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function SkillTagItemView:GenerateDestroy()
	if tolua.getpeer(self.bgColorID) ~= nil then
		tolua.setpeer(self.bgColorID, nil)
	end
	self.bgColorID = nil
	if tolua.getpeer(self.textSkillID) ~= nil then
		tolua.setpeer(self.textSkillID, nil)
	end
	self.textSkillID = nil
	self.inited = false
end
return SkillTagItemView