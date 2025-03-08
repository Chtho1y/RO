---@class NatureAttrItem__Generate_numberGreen
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class NatureAttrItem__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class NatureAttrItem__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class NatureAttrItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private text NatureAttrItem__Generate_text
---@field private number NatureAttrItem__Generate_number
---@field private numberGreen NatureAttrItem__Generate_numberGreen
local NatureAttrItemView = class("NatureAttrItemView")

function NatureAttrItemView:ctor()
end

---@private
function NatureAttrItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function NatureAttrItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function NatureAttrItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function NatureAttrItemView:InitGenerate__2(Root, data)
--[[
	Text
--]]
	local tmp = Root:Find("Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function NatureAttrItemView:InitGenerate__3(Root, data)
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
function NatureAttrItemView:InitGenerate__4(Root, data)
--[[
	NumberGreen
--]]
	local tmp = Root:Find("NumberGreen").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.numberGreen = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function NatureAttrItemView:GenerateDestroy()
	if tolua.getpeer(self.numberGreen) ~= nil then
		tolua.setpeer(self.numberGreen, nil)
	end
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	self.inited = false
end
return NatureAttrItemView