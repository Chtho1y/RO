---@class PropertyItem__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class PropertyItem__Generate_prName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class PropertyItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private prName PropertyItem__Generate_prName
---@field private number PropertyItem__Generate_number
local PropertyItemView = class("PropertyItemView")

function PropertyItemView:ctor()
end

---@private
function PropertyItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function PropertyItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function PropertyItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function PropertyItemView:InitGenerate__2(Root, data)
--[[
	PrName
--]]
	local tmp = Root:Find("PrName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.prName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function PropertyItemView:InitGenerate__3(Root, data)
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
function PropertyItemView:GenerateDestroy()
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	if tolua.getpeer(self.prName) ~= nil then
		tolua.setpeer(self.prName, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return PropertyItemView