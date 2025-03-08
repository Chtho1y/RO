---@class SkillItem__Generate_extTagTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class SkillItem__Generate_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class SkillItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class SkillItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class SkillItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private icon SkillItem__Generate_icon
---@field private frame SkillItem__Generate_frame
---@field private num SkillItem__Generate_num
---@field private extTag UnityEngine.GameObject
---@field private extTagTxt SkillItem__Generate_extTagTxt
local SkillItemView = class("SkillItemView")

function SkillItemView:ctor()
end

---@private
function SkillItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function SkillItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)
	self:InitGenerate__6(Root,data)


end

---@private
function SkillItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function SkillItemView:InitGenerate__2(Root, data)
--[[
	Icon
--]]
	local tmp = Root:Find("Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function SkillItemView:InitGenerate__3(Root, data)
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
function SkillItemView:InitGenerate__4(Root, data)
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
function SkillItemView:InitGenerate__5(Root, data)
--[[
	ExtTag
--]]
	local tmp = Root:Find("ExtTag").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.extTag = tmp
	self.extTag:SetActive(false)
end

---@private
function SkillItemView:InitGenerate__6(Root, data)
--[[
	ExtTag/ExtTagTxt
--]]
	local tmp = Root:Find("ExtTag/ExtTagTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.extTagTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function SkillItemView:GenerateDestroy()
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	self.frame = nil
	if tolua.getpeer(self.num) ~= nil then
		tolua.setpeer(self.num, nil)
	end
	self.num = nil
	if tolua.getpeer(self.extTag) ~= nil then
		tolua.setpeer(self.extTag, nil)
	end
	self.extTag = nil
	if tolua.getpeer(self.extTagTxt) ~= nil then
		tolua.setpeer(self.extTagTxt, nil)
	end
	self.extTagTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return SkillItemView