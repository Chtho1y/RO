---@class UIDojoReward__Generate_nextDanItemContent
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIDojoReward__Generate_nextDanItemScroll
---@field public gameObject UnityEngine.GameObject
---@field public loopHorizontalScrollRect UnityEngine.UI.LoopHorizontalScrollRect

---@class UIDojoReward__Generate_nextDanName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoReward__Generate_nextDanIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIDojoReward__Generate_curDanItemContent
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIDojoReward__Generate_curDanItemScroll
---@field public gameObject UnityEngine.GameObject
---@field public loopHorizontalScrollRect UnityEngine.UI.LoopHorizontalScrollRect

---@class UIDojoReward__Generate_curDanName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoReward__Generate_curDanIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIDojoReward__Generate_rewardContent
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIDojoReward__Generate_rewardItemScroll
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIDojoReward__Generate_rankRewardLbl
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIDojoReward__Generate_rankRewardToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIDojoReward__Generate_danRewardLbl
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIDojoReward__Generate_danRewardToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIDojoReward__Generate_toggleGroup
---@field public gameObject UnityEngine.GameObject
---@field public toggleGroup UnityEngine.UI.ToggleGroup

---@class UIDojoReward__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojoReward__Generate_alpha
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojoReward__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIDojoReward__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIDojoReward__Generate_uIAnimator
---@field private alpha UIDojoReward__Generate_alpha
---@field private closeBtn UIDojoReward__Generate_closeBtn
---@field private toggleGroup UIDojoReward__Generate_toggleGroup
---@field private danRewardToggle UIDojoReward__Generate_danRewardToggle
---@field private danRewardLbl UIDojoReward__Generate_danRewardLbl
---@field private rankRewardToggle UIDojoReward__Generate_rankRewardToggle
---@field private rankRewardLbl UIDojoReward__Generate_rankRewardLbl
---@field private rewardItemScroll UIDojoReward__Generate_rewardItemScroll
---@field private rewardContent UIDojoReward__Generate_rewardContent
---@field private danRewardNode UnityEngine.GameObject
---@field private curNode UnityEngine.GameObject
---@field private curDanIcon UIDojoReward__Generate_curDanIcon
---@field private curDanName UIDojoReward__Generate_curDanName
---@field private curDanItemScroll UIDojoReward__Generate_curDanItemScroll
---@field private curDanItemContent UIDojoReward__Generate_curDanItemContent
---@field private nextNode UnityEngine.GameObject
---@field private nextDanIcon UIDojoReward__Generate_nextDanIcon
---@field private nextDanName UIDojoReward__Generate_nextDanName
---@field private nextDanItemScroll UIDojoReward__Generate_nextDanItemScroll
---@field private nextDanItemContent UIDojoReward__Generate_nextDanItemContent
local UIDojoRewardView = class("UIDojoRewardView", require("UIViewBase"))

function UIDojoRewardView:ctor()
end

---@private
function UIDojoRewardView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIDojoRewardView:InitGenerate(Root, data)
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
	self:InitGenerate__12(Root,data)
	self:InitGenerate__13(Root,data)
	self:InitGenerate__14(Root,data)
	self:InitGenerate__15(Root,data)
	self:InitGenerate__16(Root,data)
	self:InitGenerate__17(Root,data)
	self:InitGenerate__18(Root,data)
	self:InitGenerate__19(Root,data)
	self:InitGenerate__20(Root,data)
	self:InitGenerate__21(Root,data)
	self:InitGenerate__22(Root,data)


end

---@private
function UIDojoRewardView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIDojoRewardView:InitGenerate__2(Root, data)
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
function UIDojoRewardView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.alpha = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojoRewardView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojoRewardView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/ToggleGroup
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/ToggleGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleGroup = tmp

	tmp.toggleGroup = tmp:GetComponent(Enum.TypeInfo.ToggleGroup)
end

---@private
function UIDojoRewardView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/ToggleGroup/DanReward
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/ToggleGroup/DanReward").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.danRewardToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIDojoRewardView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/ToggleGroup/DanReward/Background/Label
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/ToggleGroup/DanReward/Background/Label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.danRewardLbl = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIDojoRewardView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/ToggleGroup/RankReward
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/ToggleGroup/RankReward").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankRewardToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIDojoRewardView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/ToggleGroup/RankReward/Background/Label
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/ToggleGroup/RankReward/Background/Label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankRewardLbl = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIDojoRewardView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/PlayerScroll
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/PlayerScroll").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardItemScroll = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIDojoRewardView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/PlayerScroll/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/PlayerScroll/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardContent = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIDojoRewardView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/DanRewardNode
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/DanRewardNode").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.danRewardNode = tmp
end

---@private
function UIDojoRewardView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/DanRewardNode/CurrentReward
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/DanRewardNode/CurrentReward").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curNode = tmp
end

---@private
function UIDojoRewardView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/DanRewardNode/CurrentReward/icon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/DanRewardNode/CurrentReward/icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curDanIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIDojoRewardView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/DanRewardNode/CurrentReward/name
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/DanRewardNode/CurrentReward/name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curDanName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoRewardView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/DanRewardNode/CurrentReward/items
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/DanRewardNode/CurrentReward/items").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curDanItemScroll = tmp

	tmp.loopHorizontalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopHorizontalScrollRect)
end

---@private
function UIDojoRewardView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/DanRewardNode/CurrentReward/items/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/DanRewardNode/CurrentReward/items/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curDanItemContent = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIDojoRewardView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/DanRewardNode/NextReward
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/DanRewardNode/NextReward").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextNode = tmp
end

---@private
function UIDojoRewardView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/DanRewardNode/NextReward/icon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/DanRewardNode/NextReward/icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextDanIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIDojoRewardView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/DanRewardNode/NextReward/name
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/DanRewardNode/NextReward/name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextDanName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoRewardView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/DanRewardNode/NextReward/items
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/DanRewardNode/NextReward/items").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextDanItemScroll = tmp

	tmp.loopHorizontalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopHorizontalScrollRect)
end

---@private
function UIDojoRewardView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/DanRewardNode/NextReward/items/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/DanRewardNode/NextReward/items/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextDanItemContent = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIDojoRewardView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.alpha) ~= nil then
		tolua.setpeer(self.alpha, nil)
	end
	self.alpha = nil
	if tolua.getpeer(self.closeBtn) ~= nil then
		tolua.setpeer(self.closeBtn, nil)
	end
	self.closeBtn = nil
	if tolua.getpeer(self.toggleGroup) ~= nil then
		tolua.setpeer(self.toggleGroup, nil)
	end
	self.toggleGroup = nil
	if tolua.getpeer(self.danRewardToggle) ~= nil then
		tolua.setpeer(self.danRewardToggle, nil)
	end
	self.danRewardToggle = nil
	if tolua.getpeer(self.danRewardLbl) ~= nil then
		tolua.setpeer(self.danRewardLbl, nil)
	end
	self.danRewardLbl = nil
	if tolua.getpeer(self.rankRewardToggle) ~= nil then
		tolua.setpeer(self.rankRewardToggle, nil)
	end
	self.rankRewardToggle = nil
	if tolua.getpeer(self.rankRewardLbl) ~= nil then
		tolua.setpeer(self.rankRewardLbl, nil)
	end
	self.rankRewardLbl = nil
	if tolua.getpeer(self.rewardItemScroll) ~= nil then
		tolua.setpeer(self.rewardItemScroll, nil)
	end
	self.rewardItemScroll = nil
	if tolua.getpeer(self.rewardContent) ~= nil then
		tolua.setpeer(self.rewardContent, nil)
	end
	self.rewardContent = nil
	if tolua.getpeer(self.danRewardNode) ~= nil then
		tolua.setpeer(self.danRewardNode, nil)
	end
	self.danRewardNode = nil
	if tolua.getpeer(self.curNode) ~= nil then
		tolua.setpeer(self.curNode, nil)
	end
	self.curNode = nil
	if tolua.getpeer(self.curDanIcon) ~= nil then
		tolua.setpeer(self.curDanIcon, nil)
	end
	self.curDanIcon = nil
	if tolua.getpeer(self.curDanName) ~= nil then
		tolua.setpeer(self.curDanName, nil)
	end
	self.curDanName = nil
	if tolua.getpeer(self.curDanItemScroll) ~= nil then
		tolua.setpeer(self.curDanItemScroll, nil)
	end
	self.curDanItemScroll = nil
	if tolua.getpeer(self.curDanItemContent) ~= nil then
		tolua.setpeer(self.curDanItemContent, nil)
	end
	self.curDanItemContent = nil
	if tolua.getpeer(self.nextNode) ~= nil then
		tolua.setpeer(self.nextNode, nil)
	end
	self.nextNode = nil
	if tolua.getpeer(self.nextDanIcon) ~= nil then
		tolua.setpeer(self.nextDanIcon, nil)
	end
	self.nextDanIcon = nil
	if tolua.getpeer(self.nextDanName) ~= nil then
		tolua.setpeer(self.nextDanName, nil)
	end
	self.nextDanName = nil
	if tolua.getpeer(self.nextDanItemScroll) ~= nil then
		tolua.setpeer(self.nextDanItemScroll, nil)
	end
	self.nextDanItemScroll = nil
	if tolua.getpeer(self.nextDanItemContent) ~= nil then
		tolua.setpeer(self.nextDanItemContent, nil)
	end
	self.nextDanItemContent = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIDojoRewardView