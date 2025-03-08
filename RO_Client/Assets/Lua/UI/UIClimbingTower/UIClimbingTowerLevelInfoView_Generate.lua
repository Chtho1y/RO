---@class UIClimbingTowerLevelInfo__Generate_ItemContent
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIClimbingTowerLevelInfo__Generate_ItemScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIClimbingTowerLevelInfo__Generate_replayBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTowerLevelInfo__Generate_passedDateTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerLevelInfo__Generate_costTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerLevelInfo__Generate_playerNode_fightPower
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerLevelInfo__Generate_playerNode_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerLevelInfo__Generate_playerNode
---@field public gameObject UnityEngine.GameObject
---@field public headItem UnityEngine.GameObject
---@field public playerName UIClimbingTowerLevelInfo__Generate_playerNode_playerName
---@field public fightPower UIClimbingTowerLevelInfo__Generate_playerNode_fightPower

---@class UIClimbingTowerLevelInfo__Generate_CloseBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTowerLevelInfo__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTowerLevelInfo__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIClimbingTowerLevelInfo__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIClimbingTowerLevelInfo__Generate_uIAnimator
---@field private AnyBtn UIClimbingTowerLevelInfo__Generate_AnyBtn
---@field private CloseBtn UIClimbingTowerLevelInfo__Generate_CloseBtn
---@field private nothingNode UnityEngine.GameObject
---@field private playerNode UIClimbingTowerLevelInfo__Generate_playerNode
---@field private infoNode UnityEngine.GameObject
---@field private costTime UIClimbingTowerLevelInfo__Generate_costTime
---@field private passedDateTime UIClimbingTowerLevelInfo__Generate_passedDateTime
---@field private replayBtn UIClimbingTowerLevelInfo__Generate_replayBtn
---@field private rewardNode UnityEngine.GameObject
---@field private ItemScrollView UIClimbingTowerLevelInfo__Generate_ItemScrollView
---@field private ItemContent UIClimbingTowerLevelInfo__Generate_ItemContent
local UIClimbingTowerLevelInfoView = class("UIClimbingTowerLevelInfoView", require("UIViewBase"))

function UIClimbingTowerLevelInfoView:ctor()
end

---@private
function UIClimbingTowerLevelInfoView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIClimbingTowerLevelInfoView:InitGenerate(Root, data)
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


end

---@private
function UIClimbingTowerLevelInfoView:InitGenerate__1(Root, data)
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
function UIClimbingTowerLevelInfoView:InitGenerate__2(Root, data)
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
function UIClimbingTowerLevelInfoView:InitGenerate__3(Root, data)
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
function UIClimbingTowerLevelInfoView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BG/LowestPlayerNode/Nothing
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/LowestPlayerNode/Nothing").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nothingNode = tmp
end

---@private
function UIClimbingTowerLevelInfoView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BG/LowestPlayerNode/PlayerNode
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/LowestPlayerNode/PlayerNode").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode = tmp
end

---@private
function UIClimbingTowerLevelInfoView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BG/LowestPlayerNode/PlayerNode/HeadItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/LowestPlayerNode/PlayerNode/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.playerNode.headItem.prefabName = "HeadItem"
end

---@private
function UIClimbingTowerLevelInfoView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BG/LowestPlayerNode/PlayerNode/PlayerName
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/LowestPlayerNode/PlayerNode/PlayerName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerLevelInfoView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BG/LowestPlayerNode/PlayerNode/FightPower
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/LowestPlayerNode/PlayerNode/FightPower").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode.fightPower = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerLevelInfoView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BG/LowestPlayerNode/PlayerNode/Info
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/LowestPlayerNode/PlayerNode/Info").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.infoNode = tmp
end

---@private
function UIClimbingTowerLevelInfoView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BG/LowestPlayerNode/PlayerNode/Info/TimeCost
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/LowestPlayerNode/PlayerNode/Info/TimeCost").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.costTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerLevelInfoView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BG/LowestPlayerNode/PlayerNode/Info/date
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/LowestPlayerNode/PlayerNode/Info/date").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.passedDateTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerLevelInfoView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BG/LowestPlayerNode/PlayerNode/BtnPlay
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/LowestPlayerNode/PlayerNode/BtnPlay").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.replayBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerLevelInfoView:InitGenerate__13(Root, data)
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
function UIClimbingTowerLevelInfoView:InitGenerate__14(Root, data)
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
function UIClimbingTowerLevelInfoView:InitGenerate__15(Root, data)
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
function UIClimbingTowerLevelInfoView:GenerateDestroy()
	if tolua.getpeer(self.playerNode.fightPower) ~= nil then
		tolua.setpeer(self.playerNode.fightPower, nil)
	end
	if tolua.getpeer(self.playerNode.playerName) ~= nil then
		tolua.setpeer(self.playerNode.playerName, nil)
	end
	if self.playerNode.headItem.GenerateDestroy ~= nil then
		self.playerNode.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.playerNode.headItem) ~= nil then
		tolua.setpeer(self.playerNode.headItem, nil)
	end
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
	if tolua.getpeer(self.nothingNode) ~= nil then
		tolua.setpeer(self.nothingNode, nil)
	end
	self.nothingNode = nil
	if tolua.getpeer(self.playerNode) ~= nil then
		tolua.setpeer(self.playerNode, nil)
	end
	self.playerNode = nil
	if tolua.getpeer(self.infoNode) ~= nil then
		tolua.setpeer(self.infoNode, nil)
	end
	self.infoNode = nil
	if tolua.getpeer(self.costTime) ~= nil then
		tolua.setpeer(self.costTime, nil)
	end
	self.costTime = nil
	if tolua.getpeer(self.passedDateTime) ~= nil then
		tolua.setpeer(self.passedDateTime, nil)
	end
	self.passedDateTime = nil
	if tolua.getpeer(self.replayBtn) ~= nil then
		tolua.setpeer(self.replayBtn, nil)
	end
	self.replayBtn = nil
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
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIClimbingTowerLevelInfoView