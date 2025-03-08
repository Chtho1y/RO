---@class PortraitExp__Generate_sp
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class PortraitExp__Generate_hp
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class PortraitExp__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private selectedNode UnityEngine.GameObject
---@field private role UnityEngine.GameObject
---@field private statusNode UnityEngine.GameObject
---@field private hp PortraitExp__Generate_hp
---@field private sp PortraitExp__Generate_sp
local PortraitExpView = class("PortraitExpView")

function PortraitExpView:ctor()
end

---@private
function PortraitExpView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function PortraitExpView:InitGenerate(Root, data)
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
function PortraitExpView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function PortraitExpView:InitGenerate__2(Root, data)
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
function PortraitExpView:InitGenerate__3(Root, data)
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
function PortraitExpView:InitGenerate__4(Root, data)
--[[
	Status
--]]
	local tmp = Root:Find("Status").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.statusNode = tmp
end

---@private
function PortraitExpView:InitGenerate__5(Root, data)
--[[
	Status/Hp/Bar
--]]
	local tmp = Root:Find("Status/Hp/Bar").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hp = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function PortraitExpView:InitGenerate__6(Root, data)
--[[
	Status/Sp/Bar
--]]
	local tmp = Root:Find("Status/Sp/Bar").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.sp = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function PortraitExpView:GenerateDestroy()
	if tolua.getpeer(self.sp) ~= nil then
		tolua.setpeer(self.sp, nil)
	end
	if tolua.getpeer(self.hp) ~= nil then
		tolua.setpeer(self.hp, nil)
	end
	if tolua.getpeer(self.statusNode) ~= nil then
		tolua.setpeer(self.statusNode, nil)
	end
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
return PortraitExpView