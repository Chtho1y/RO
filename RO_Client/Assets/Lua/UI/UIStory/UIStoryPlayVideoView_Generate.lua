---@class UIStoryPlayVideo__Generate_videoPlayer
---@field public gameObject UnityEngine.GameObject
---@field public uIPlayVideo UIPlayVideo

---@class UIStoryPlayVideo__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private videoPlayer UIStoryPlayVideo__Generate_videoPlayer
local UIStoryPlayVideoView = class("UIStoryPlayVideoView", require("UIViewBase"))

function UIStoryPlayVideoView:ctor()
end

---@private
function UIStoryPlayVideoView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIStoryPlayVideoView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)


end

---@private
function UIStoryPlayVideoView:InitGenerate__1(Root, data)
--[[
	SafeRect/VideoPlayer
--]]
	local tmp = Root:Find("SafeRect/VideoPlayer").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.videoPlayer = tmp

	tmp.uIPlayVideo = tmp:GetComponent(Enum.TypeInfo.UIPlayVideo)
end

---@private
function UIStoryPlayVideoView:GenerateDestroy()
	if tolua.getpeer(self.videoPlayer) ~= nil then
		tolua.setpeer(self.videoPlayer, nil)
	end
	self.videoPlayer = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIStoryPlayVideoView