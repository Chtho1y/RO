---@class HundredDojoRawItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
local HundredDojoRawItemView = class("HundredDojoRawItemView")

function HundredDojoRawItemView:ctor()
end

---@private
function HundredDojoRawItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function HundredDojoRawItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)


end

---@private
function HundredDojoRawItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function HundredDojoRawItemView:GenerateDestroy()
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return HundredDojoRawItemView