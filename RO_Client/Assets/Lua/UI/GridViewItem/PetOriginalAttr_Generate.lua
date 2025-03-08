---@class PetOriginalAttr__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class PetOriginalAttr__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class PetOriginalAttr__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private text PetOriginalAttr__Generate_text
---@field private number PetOriginalAttr__Generate_number
local PetOriginalAttrView = class("PetOriginalAttrView")

function PetOriginalAttrView:ctor()
end

---@private
function PetOriginalAttrView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function PetOriginalAttrView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function PetOriginalAttrView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function PetOriginalAttrView:InitGenerate__2(Root, data)
--[[
	Text
--]]
	local tmp = Root:Find("Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function PetOriginalAttrView:InitGenerate__3(Root, data)
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
function PetOriginalAttrView:GenerateDestroy()
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return PetOriginalAttrView