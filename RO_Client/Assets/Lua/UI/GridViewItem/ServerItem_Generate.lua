---@class ServerItem__Generate_name
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ServerItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class ServerItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bg ServerItem__Generate_bg
---@field private name ServerItem__Generate_name
local ServerItemView = class("ServerItemView")

function ServerItemView:ctor()
end

---@private
function ServerItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ServerItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function ServerItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function ServerItemView:InitGenerate__2(Root, data)
--[[
	bg
--]]
	local tmp = Root:Find("bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ServerItemView:InitGenerate__3(Root, data)
--[[
	name
--]]
	local tmp = Root:Find("name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.name = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ServerItemView:GenerateDestroy()
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.name) ~= nil then
		tolua.setpeer(self.name, nil)
	end
	self.name = nil
	self.inited = false
end
return ServerItemView