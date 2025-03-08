---@class UIErrorTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
local UIErrorTipsView = class("UIErrorTipsView", require("UIViewBase"))

function UIErrorTipsView:ctor()
end

---@private
function UIErrorTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIErrorTipsView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)


end

---@private
function UIErrorTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIErrorTipsView:GenerateDestroy()
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIErrorTipsView