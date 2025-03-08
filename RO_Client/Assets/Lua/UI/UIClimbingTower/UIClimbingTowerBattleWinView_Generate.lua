---@class UIClimbingTowerBattleWin__Generate_btnNextTower
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTowerBattleWin__Generate_ItemContent
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIClimbingTowerBattleWin__Generate_ItemScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIClimbingTowerBattleWin__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTowerBattleWin__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIClimbingTowerBattleWin__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIClimbingTowerBattleWin__Generate_uIAnimator
---@field private AnyBtn UIClimbingTowerBattleWin__Generate_AnyBtn
---@field private rewardNode UnityEngine.GameObject
---@field private ItemScrollView UIClimbingTowerBattleWin__Generate_ItemScrollView
---@field private ItemContent UIClimbingTowerBattleWin__Generate_ItemContent
---@field private btnNextTower UIClimbingTowerBattleWin__Generate_btnNextTower
local UIClimbingTowerBattleWinView = class("UIClimbingTowerBattleWinView", require("UIViewBase"))

function UIClimbingTowerBattleWinView:ctor()
end

---@private
function UIClimbingTowerBattleWinView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIClimbingTowerBattleWinView:InitGenerate(Root, data)
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


end

---@private
function UIClimbingTowerBattleWinView:InitGenerate__1(Root, data)
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
function UIClimbingTowerBattleWinView:InitGenerate__2(Root, data)
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
function UIClimbingTowerBattleWinView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BG/RewardsIcons
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/RewardsIcons").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardNode = tmp
end

---@private
function UIClimbingTowerBattleWinView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BG/RewardsIcons/ItemScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/RewardsIcons/ItemScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.ItemScrollView = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIClimbingTowerBattleWinView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BG/RewardsIcons/ItemScrollView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/RewardsIcons/ItemScrollView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.ItemContent = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIClimbingTowerBattleWinView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BG/BtnNextTower
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BtnNextTower").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnNextTower = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerBattleWinView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.rewardNode) ~= nil then
		tolua.setpeer(self.rewardNode, nil)
	end
	self.rewardNode = nil
	if tolua.getpeer(self.ItemScrollView) ~= nil then
		tolua.setpeer(self.ItemScrollView, nil)
	end
	self.ItemScrollView = nil
	if tolua.getpeer(self.ItemContent) ~= nil then
		tolua.setpeer(self.ItemContent, nil)
	end
	self.ItemContent = nil
	if tolua.getpeer(self.btnNextTower) ~= nil then
		tolua.setpeer(self.btnNextTower, nil)
	end
	self.btnNextTower = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIClimbingTowerBattleWinView