---@class UIWaiting__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
local UIWaitingView = class("UIWaitingView", require("UIViewBase"))

function UIWaitingView:ctor()
end

---@private
function UIWaitingView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIWaitingView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp



end

---@private
function UIWaitingView:GenerateDestroy()
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIWaitingView