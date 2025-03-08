---@class FashionPropertyItem__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class FashionPropertyItem__Generate_name
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class FashionPropertyItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private name FashionPropertyItem__Generate_name
---@field private number FashionPropertyItem__Generate_number
local FashionPropertyItemView = class("FashionPropertyItemView")

function FashionPropertyItemView:ctor()
end

---@private
function FashionPropertyItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function FashionPropertyItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function FashionPropertyItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function FashionPropertyItemView:InitGenerate__2(Root, data)
--[[
	Name
--]]
	local tmp = Root:Find("Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.name = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function FashionPropertyItemView:InitGenerate__3(Root, data)
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
function FashionPropertyItemView:GenerateDestroy()
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	if tolua.getpeer(self.name) ~= nil then
		tolua.setpeer(self.name, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return FashionPropertyItemView