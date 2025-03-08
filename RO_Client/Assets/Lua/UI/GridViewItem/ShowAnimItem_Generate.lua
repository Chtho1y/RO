---@class ShowAnimItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
local ShowAnimItemView = class("ShowAnimItemView")

function ShowAnimItemView:ctor()
end

---@private
function ShowAnimItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ShowAnimItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)


end

---@private
function ShowAnimItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ShowAnimItemView:GenerateDestroy()
	self.inited = false
end
return ShowAnimItemView