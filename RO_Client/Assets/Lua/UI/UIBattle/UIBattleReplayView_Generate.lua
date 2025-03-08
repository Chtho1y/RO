---@class UIBattleReplay__Generate_LowestNode_replayBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBattleReplay__Generate_LowestNode_fightPower
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleReplay__Generate_LowestNode_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleReplay__Generate_LowestNode_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIBattleReplay__Generate_LowestNode_passedDateTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleReplay__Generate_LowestNode_costTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleReplay__Generate_LowestNode
---@field public gameObject UnityEngine.GameObject
---@field public costTime UIBattleReplay__Generate_LowestNode_costTime
---@field public passedDateTime UIBattleReplay__Generate_LowestNode_passedDateTime
---@field public headItem UIBattleReplay__Generate_LowestNode_headItem
---@field public playerName UIBattleReplay__Generate_LowestNode_playerName
---@field public fightPower UIBattleReplay__Generate_LowestNode_fightPower
---@field public replayBtn UIBattleReplay__Generate_LowestNode_replayBtn

---@class UIBattleReplay__Generate_LatestNode_replayBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBattleReplay__Generate_LatestNode_fightPower
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleReplay__Generate_LatestNode_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleReplay__Generate_LatestNode_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIBattleReplay__Generate_LatestNode_passedDateTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleReplay__Generate_LatestNode_costTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleReplay__Generate_LatestNode
---@field public gameObject UnityEngine.GameObject
---@field public costTime UIBattleReplay__Generate_LatestNode_costTime
---@field public passedDateTime UIBattleReplay__Generate_LatestNode_passedDateTime
---@field public headItem UIBattleReplay__Generate_LatestNode_headItem
---@field public playerName UIBattleReplay__Generate_LatestNode_playerName
---@field public fightPower UIBattleReplay__Generate_LatestNode_fightPower
---@field public replayBtn UIBattleReplay__Generate_LatestNode_replayBtn

---@class UIBattleReplay__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBattleReplay__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBattleReplay__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIBattleReplay__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIBattleReplay__Generate_uIAnimator
---@field private AnyBtn UIBattleReplay__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UIBattleReplay__Generate_btnClose
---@field private LatestNode UIBattleReplay__Generate_LatestNode
---@field private LowestNode UIBattleReplay__Generate_LowestNode
local UIBattleReplayView = class("UIBattleReplayView", require("UIViewBase"))

function UIBattleReplayView:ctor()
end

---@private
function UIBattleReplayView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIBattleReplayView:InitGenerate(Root, data)
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


end

---@private
function UIBattleReplayView:InitGenerate__1(Root, data)
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
function UIBattleReplayView:InitGenerate__2(Root, data)
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
function UIBattleReplayView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window
--]]
	local tmp = Root:Find("UIAnimator/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp
end

---@private
function UIBattleReplayView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIBattleReplayView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Latest
--]]
	local tmp = Root:Find("UIAnimator/Window/Latest").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LatestNode = tmp
end

---@private
function UIBattleReplayView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Latest/Title/TimeCost
--]]
	local tmp = Root:Find("UIAnimator/Window/Latest/Title/TimeCost").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LatestNode.costTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleReplayView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Latest/Title/date
--]]
	local tmp = Root:Find("UIAnimator/Window/Latest/Title/date").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LatestNode.passedDateTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleReplayView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Latest/HeadItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Latest/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LatestNode.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.LatestNode.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIBattleReplayView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Latest/Name/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Latest/Name/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LatestNode.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleReplayView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Latest/Power/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Latest/Power/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LatestNode.fightPower = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleReplayView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Latest/BtnPlay
--]]
	local tmp = Root:Find("UIAnimator/Window/Latest/BtnPlay").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LatestNode.replayBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIBattleReplayView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Lowest
--]]
	local tmp = Root:Find("UIAnimator/Window/Lowest").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LowestNode = tmp
end

---@private
function UIBattleReplayView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Lowest/Title/TimeCost
--]]
	local tmp = Root:Find("UIAnimator/Window/Lowest/Title/TimeCost").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LowestNode.costTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleReplayView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Lowest/Title/date
--]]
	local tmp = Root:Find("UIAnimator/Window/Lowest/Title/date").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LowestNode.passedDateTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleReplayView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Lowest/HeadItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Lowest/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LowestNode.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.LowestNode.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIBattleReplayView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Lowest/Name/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Lowest/Name/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LowestNode.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleReplayView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Lowest/Power/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Lowest/Power/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LowestNode.fightPower = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleReplayView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Lowest/BtnPlay
--]]
	local tmp = Root:Find("UIAnimator/Window/Lowest/BtnPlay").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LowestNode.replayBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIBattleReplayView:GenerateDestroy()
	if tolua.getpeer(self.LowestNode.replayBtn) ~= nil then
		tolua.setpeer(self.LowestNode.replayBtn, nil)
	end
	if tolua.getpeer(self.LowestNode.fightPower) ~= nil then
		tolua.setpeer(self.LowestNode.fightPower, nil)
	end
	if tolua.getpeer(self.LowestNode.playerName) ~= nil then
		tolua.setpeer(self.LowestNode.playerName, nil)
	end
	if self.LowestNode.headItem.GenerateDestroy ~= nil then
		self.LowestNode.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.LowestNode.headItem) ~= nil then
		tolua.setpeer(self.LowestNode.headItem, nil)
	end
	if tolua.getpeer(self.LowestNode.passedDateTime) ~= nil then
		tolua.setpeer(self.LowestNode.passedDateTime, nil)
	end
	if tolua.getpeer(self.LowestNode.costTime) ~= nil then
		tolua.setpeer(self.LowestNode.costTime, nil)
	end
	if tolua.getpeer(self.LatestNode.replayBtn) ~= nil then
		tolua.setpeer(self.LatestNode.replayBtn, nil)
	end
	if tolua.getpeer(self.LatestNode.fightPower) ~= nil then
		tolua.setpeer(self.LatestNode.fightPower, nil)
	end
	if tolua.getpeer(self.LatestNode.playerName) ~= nil then
		tolua.setpeer(self.LatestNode.playerName, nil)
	end
	if self.LatestNode.headItem.GenerateDestroy ~= nil then
		self.LatestNode.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.LatestNode.headItem) ~= nil then
		tolua.setpeer(self.LatestNode.headItem, nil)
	end
	if tolua.getpeer(self.LatestNode.passedDateTime) ~= nil then
		tolua.setpeer(self.LatestNode.passedDateTime, nil)
	end
	if tolua.getpeer(self.LatestNode.costTime) ~= nil then
		tolua.setpeer(self.LatestNode.costTime, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.LatestNode) ~= nil then
		tolua.setpeer(self.LatestNode, nil)
	end
	self.LatestNode = nil
	if tolua.getpeer(self.LowestNode) ~= nil then
		tolua.setpeer(self.LowestNode, nil)
	end
	self.LowestNode = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIBattleReplayView