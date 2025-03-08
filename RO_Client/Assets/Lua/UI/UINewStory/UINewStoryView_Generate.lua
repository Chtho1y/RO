---@class UINewStory__Generate_storyAnim
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UINewStory__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private storyAnim UINewStory__Generate_storyAnim
local UINewStoryView = class("UINewStoryView", require("UIViewBase"))

function UINewStoryView:ctor()
end

---@private
function UINewStoryView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UINewStoryView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)


end

---@private
function UINewStoryView:InitGenerate__1(Root, data)
--[[
	StoryAnim
--]]
	local tmp = Root:Find("StoryAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.storyAnim = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UINewStoryView:GenerateDestroy()
	if tolua.getpeer(self.storyAnim) ~= nil then
		tolua.setpeer(self.storyAnim, nil)
	end
	self.storyAnim = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UINewStoryView