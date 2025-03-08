---@class Portrait__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private selectedNode UnityEngine.GameObject
---@field private role UnityEngine.GameObject
local PortraitView = class("PortraitView")

function PortraitView:ctor()
end

---@private
function PortraitView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function PortraitView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function PortraitView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function PortraitView:InitGenerate__2(Root, data)
--[[
	Selected
--]]
	local tmp = Root:Find("Selected").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectedNode = tmp
end

---@private
function PortraitView:InitGenerate__3(Root, data)
--[[
	RoleListItem
--]]
	local tmp = Root:Find("RoleListItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.role = CommonUtil.BindGridViewItem2LuaStatic("RoleListItem", tmp)
	self.role.prefabName = "RoleListItem"
end

---@private
function PortraitView:GenerateDestroy()
	if self.role.GenerateDestroy ~= nil then
		self.role:GenerateDestroy()
	end
	if tolua.getpeer(self.role) ~= nil then
		tolua.setpeer(self.role, nil)
	end
	if tolua.getpeer(self.selectedNode) ~= nil then
		tolua.setpeer(self.selectedNode, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return PortraitView