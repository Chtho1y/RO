---@class UIClimbingTowerFriendInfo__Generate_content
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIClimbingTowerFriendInfo__Generate_friendScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIClimbingTowerFriendInfo__Generate_CloseBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTowerFriendInfo__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTowerFriendInfo__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIClimbingTowerFriendInfo__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIClimbingTowerFriendInfo__Generate_uIAnimator
---@field private AnyBtn UIClimbingTowerFriendInfo__Generate_AnyBtn
---@field private CloseBtn UIClimbingTowerFriendInfo__Generate_CloseBtn
---@field private friendScrollView UIClimbingTowerFriendInfo__Generate_friendScrollView
---@field private content UIClimbingTowerFriendInfo__Generate_content
local UIClimbingTowerFriendInfoView = class("UIClimbingTowerFriendInfoView", require("UIViewBase"))

function UIClimbingTowerFriendInfoView:ctor()
end

---@private
function UIClimbingTowerFriendInfoView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIClimbingTowerFriendInfoView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)


end

---@private
function UIClimbingTowerFriendInfoView:InitGenerate__1(Root, data)
--[[
	UIAnimator
--]]
	local tmp = Root:Find("UIAnimator").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIAnimator = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIClimbingTowerFriendInfoView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerFriendInfoView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BG/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.CloseBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerFriendInfoView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BG/FriendList/FriendScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/FriendList/FriendScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.friendScrollView = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIClimbingTowerFriendInfoView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BG/FriendList/FriendScrollView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/FriendList/FriendScrollView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIClimbingTowerFriendInfoView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.CloseBtn) ~= nil then
		tolua.setpeer(self.CloseBtn, nil)
	end
	self.CloseBtn = nil
	if tolua.getpeer(self.friendScrollView) ~= nil then
		tolua.setpeer(self.friendScrollView, nil)
	end
	self.friendScrollView = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIClimbingTowerFriendInfoView