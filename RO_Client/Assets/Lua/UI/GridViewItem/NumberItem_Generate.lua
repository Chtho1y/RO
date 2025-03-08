---@class NumberItem__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class NumberItem__Generate_type
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class NumberItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private type NumberItem__Generate_type
---@field private number NumberItem__Generate_number
local NumberItemView = class("NumberItemView")

function NumberItemView:ctor()
end

---@private
function NumberItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function NumberItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function NumberItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function NumberItemView:InitGenerate__2(Root, data)
--[[
	Type
--]]
	local tmp = Root:Find("Type").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.type = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function NumberItemView:InitGenerate__3(Root, data)
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
function NumberItemView:GenerateDestroy()
	if tolua.getpeer(self.type) ~= nil then
		tolua.setpeer(self.type, nil)
	end
	self.type = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
	self.inited = false
end
return NumberItemView