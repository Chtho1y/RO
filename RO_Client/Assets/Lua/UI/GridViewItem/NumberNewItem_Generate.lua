---@class NumberNewItem__Generate_number2
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class NumberNewItem__Generate_number1
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class NumberNewItem__Generate_type
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class NumberNewItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private type NumberNewItem__Generate_type
---@field private number1 NumberNewItem__Generate_number1
---@field private number2 NumberNewItem__Generate_number2
local NumberNewItemView = class("NumberNewItemView")

function NumberNewItemView:ctor()
end

---@private
function NumberNewItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function NumberNewItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function NumberNewItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function NumberNewItemView:InitGenerate__2(Root, data)
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
function NumberNewItemView:InitGenerate__3(Root, data)
--[[
	Number1
--]]
	local tmp = Root:Find("Number1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number1 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function NumberNewItemView:InitGenerate__4(Root, data)
--[[
	Number2
--]]
	local tmp = Root:Find("Number2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number2 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function NumberNewItemView:GenerateDestroy()
	if tolua.getpeer(self.type) ~= nil then
		tolua.setpeer(self.type, nil)
	end
	self.type = nil
	if tolua.getpeer(self.number1) ~= nil then
		tolua.setpeer(self.number1, nil)
	end
	self.number1 = nil
	if tolua.getpeer(self.number2) ~= nil then
		tolua.setpeer(self.number2, nil)
	end
	self.number2 = nil
	self.inited = false
end
return NumberNewItemView