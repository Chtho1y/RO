---@class UIPayWaiting__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
local UIPayWaitingView = class("UIPayWaitingView", require("UIViewBase"))

function UIPayWaitingView:ctor()
end

---@private
function UIPayWaitingView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPayWaitingView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp



end

---@private
function UIPayWaitingView:GenerateDestroy()
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPayWaitingView