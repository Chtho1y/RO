---@class EquipBaseAttrItem__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class EquipBaseAttrItem__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class EquipBaseAttrItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private text EquipBaseAttrItem__Generate_text
---@field private number EquipBaseAttrItem__Generate_number
---@field private arrow UnityEngine.GameObject
local EquipBaseAttrItemView = class("EquipBaseAttrItemView")

function EquipBaseAttrItemView:ctor()
end

---@private
function EquipBaseAttrItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function EquipBaseAttrItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function EquipBaseAttrItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function EquipBaseAttrItemView:InitGenerate__2(Root, data)
--[[
	Text
--]]
	local tmp = Root:Find("Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function EquipBaseAttrItemView:InitGenerate__3(Root, data)
--[[
	Number
--]]
	local tmp = Root:Find("Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function EquipBaseAttrItemView:InitGenerate__4(Root, data)
--[[
	Arrow
--]]
	local tmp = Root:Find("Arrow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.arrow = tmp
end

---@private
function EquipBaseAttrItemView:GenerateDestroy()
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
	if tolua.getpeer(self.arrow) ~= nil then
		tolua.setpeer(self.arrow, nil)
	end
	self.arrow = nil
	self.inited = false
end
return EquipBaseAttrItemView