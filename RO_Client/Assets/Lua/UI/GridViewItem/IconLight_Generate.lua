---@class IconLight__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private lightCircle UnityEngine.GameObject
---@field private lightIcon UnityEngine.GameObject
local IconLightView = class("IconLightView")

function IconLightView:ctor()
end

---@private
function IconLightView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function IconLightView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function IconLightView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function IconLightView:InitGenerate__2(Root, data)
--[[
	LightCircle
--]]
	local tmp = Root:Find("LightCircle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lightCircle = tmp
end

---@private
function IconLightView:InitGenerate__3(Root, data)
--[[
	LightIcon
--]]
	local tmp = Root:Find("LightIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lightIcon = tmp
end

---@private
function IconLightView:GenerateDestroy()
	if tolua.getpeer(self.lightIcon) ~= nil then
		tolua.setpeer(self.lightIcon, nil)
	end
	if tolua.getpeer(self.lightCircle) ~= nil then
		tolua.setpeer(self.lightCircle, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return IconLightView