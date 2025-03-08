---@class UIDojoMatch__Generate_progressTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoMatch__Generate_progress
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIDojoMatch__Generate_MatchingCountDownText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoMatch__Generate_rightContent
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIDojoMatch__Generate_rightMemberScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIDojoMatch__Generate_leftContent
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIDojoMatch__Generate_leftMemberScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIDojoMatch__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIDojoMatch__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIDojoMatch__Generate_uIAnimator
---@field private emptyNode UnityEngine.GameObject
---@field private leftMemberScrollView UIDojoMatch__Generate_leftMemberScrollView
---@field private leftContent UIDojoMatch__Generate_leftContent
---@field private rightMemberScrollView UIDojoMatch__Generate_rightMemberScrollView
---@field private rightContent UIDojoMatch__Generate_rightContent
---@field private MatchingNode UnityEngine.GameObject
---@field private MatchingCountDownText UIDojoMatch__Generate_MatchingCountDownText
---@field private VSNode UnityEngine.GameObject
---@field private progress UIDojoMatch__Generate_progress
---@field private progressTxt UIDojoMatch__Generate_progressTxt
local UIDojoMatchView = class("UIDojoMatchView", require("UIViewBase"))

function UIDojoMatchView:ctor()
end

---@private
function UIDojoMatchView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIDojoMatchView:InitGenerate(Root, data)
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
	self:InitGenerate__6(Root,data)
	self:InitGenerate__7(Root,data)
	self:InitGenerate__8(Root,data)
	self:InitGenerate__9(Root,data)
	self:InitGenerate__10(Root,data)
	self:InitGenerate__11(Root,data)


end

---@private
function UIDojoMatchView:InitGenerate__1(Root, data)
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
function UIDojoMatchView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/CenterView/LeftRoot/Empty
--]]
	local tmp = Root:Find("UIAnimator/Window/CenterView/LeftRoot/Empty").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emptyNode = tmp
end

---@private
function UIDojoMatchView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/CenterView/LeftRoot/MemberScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/CenterView/LeftRoot/MemberScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftMemberScrollView = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIDojoMatchView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/CenterView/LeftRoot/MemberScrollView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/CenterView/LeftRoot/MemberScrollView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftContent = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIDojoMatchView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/CenterView/RightRoot/MemberScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/CenterView/RightRoot/MemberScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rightMemberScrollView = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIDojoMatchView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/CenterView/RightRoot/MemberScrollView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/CenterView/RightRoot/MemberScrollView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rightContent = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIDojoMatchView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/CenterView/StatusRoot/Matching
--]]
	local tmp = Root:Find("UIAnimator/Window/CenterView/StatusRoot/Matching").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.MatchingNode = tmp
end

---@private
function UIDojoMatchView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/CenterView/StatusRoot/Matching/CountDown
--]]
	local tmp = Root:Find("UIAnimator/Window/CenterView/StatusRoot/Matching/CountDown").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.MatchingCountDownText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoMatchView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/CenterView/StatusRoot/VSNode
--]]
	local tmp = Root:Find("UIAnimator/Window/CenterView/StatusRoot/VSNode").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.VSNode = tmp
end

---@private
function UIDojoMatchView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/CenterView/StatusRoot/VSNode/Slider
--]]
	local tmp = Root:Find("UIAnimator/Window/CenterView/StatusRoot/VSNode/Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.progress = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIDojoMatchView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/CenterView/StatusRoot/VSNode/Progress/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/CenterView/StatusRoot/VSNode/Progress/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.progressTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoMatchView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.emptyNode) ~= nil then
		tolua.setpeer(self.emptyNode, nil)
	end
	self.emptyNode = nil
	if tolua.getpeer(self.leftMemberScrollView) ~= nil then
		tolua.setpeer(self.leftMemberScrollView, nil)
	end
	self.leftMemberScrollView = nil
	if tolua.getpeer(self.leftContent) ~= nil then
		tolua.setpeer(self.leftContent, nil)
	end
	self.leftContent = nil
	if tolua.getpeer(self.rightMemberScrollView) ~= nil then
		tolua.setpeer(self.rightMemberScrollView, nil)
	end
	self.rightMemberScrollView = nil
	if tolua.getpeer(self.rightContent) ~= nil then
		tolua.setpeer(self.rightContent, nil)
	end
	self.rightContent = nil
	if tolua.getpeer(self.MatchingNode) ~= nil then
		tolua.setpeer(self.MatchingNode, nil)
	end
	self.MatchingNode = nil
	if tolua.getpeer(self.MatchingCountDownText) ~= nil then
		tolua.setpeer(self.MatchingCountDownText, nil)
	end
	self.MatchingCountDownText = nil
	if tolua.getpeer(self.VSNode) ~= nil then
		tolua.setpeer(self.VSNode, nil)
	end
	self.VSNode = nil
	if tolua.getpeer(self.progress) ~= nil then
		tolua.setpeer(self.progress, nil)
	end
	self.progress = nil
	if tolua.getpeer(self.progressTxt) ~= nil then
		tolua.setpeer(self.progressTxt, nil)
	end
	self.progressTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIDojoMatchView