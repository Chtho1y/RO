---@class UIStorySkip__Generate_skip
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIStorySkip__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private skip UIStorySkip__Generate_skip
local UIStorySkipView = class("UIStorySkipView", require("UIViewBase"))

function UIStorySkipView:ctor()
end

---@private
function UIStorySkipView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIStorySkipView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)


end

---@private
function UIStorySkipView:InitGenerate__1(Root, data)
--[[
	Skip
--]]
	local tmp = Root:Find("Skip").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skip = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIStorySkipView:GenerateDestroy()
	if tolua.getpeer(self.skip) ~= nil then
		tolua.setpeer(self.skip, nil)
	end
	self.skip = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIStorySkipView