---@class UIExpeditionWin__Generate_scoreNumber
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIExpeditionWin__Generate_buff3_selectNode
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionWin__Generate_buff3
---@field public gameObject UnityEngine.GameObject
---@field public buffCard UnityEngine.GameObject
---@field public selectNode UIExpeditionWin__Generate_buff3_selectNode

---@class UIExpeditionWin__Generate_buff2_selectNode
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionWin__Generate_buff2
---@field public gameObject UnityEngine.GameObject
---@field public buffCard UnityEngine.GameObject
---@field public selectNode UIExpeditionWin__Generate_buff2_selectNode

---@class UIExpeditionWin__Generate_buff1_selectNode
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionWin__Generate_buff1
---@field public gameObject UnityEngine.GameObject
---@field public buffCard UnityEngine.GameObject
---@field public selectNode UIExpeditionWin__Generate_buff1_selectNode

---@class UIExpeditionWin__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionWin__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIExpeditionWin__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIExpeditionWin__Generate_uIAnimator
---@field private AnyBtn UIExpeditionWin__Generate_AnyBtn
---@field private winTipsNode UnityEngine.GameObject
---@field private rewardNode UnityEngine.GameObject
---@field private buffList UnityEngine.GameObject
---@field private buff1 UIExpeditionWin__Generate_buff1
---@field private buff2 UIExpeditionWin__Generate_buff2
---@field private buff3 UIExpeditionWin__Generate_buff3
---@field private scoreReward UnityEngine.GameObject
---@field private scoreNumber UIExpeditionWin__Generate_scoreNumber
---@field private newRecord UnityEngine.GameObject
local UIExpeditionWinView = class("UIExpeditionWinView", require("UIViewBase"))

function UIExpeditionWinView:ctor()
end

---@private
function UIExpeditionWinView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIExpeditionWinView:InitGenerate(Root, data)
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


end

---@private
function UIExpeditionWinView:InitGenerate__1(Root, data)
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
function UIExpeditionWinView:InitGenerate__2(Root, data)
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
function UIExpeditionWinView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BG/Bg/WinText
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/WinText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.winTipsNode = tmp
end

---@private
function UIExpeditionWinView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BG/Bg/RewardsIcons
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/RewardsIcons").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardNode = tmp
end

---@private
function UIExpeditionWinView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buffList = tmp
end

---@private
function UIExpeditionWinView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect1
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buff1 = tmp
end

---@private
function UIExpeditionWinView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect1/BlessCardItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect1/BlessCardItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buff1.buffCard = CommonUtil.BindGridViewItem2LuaStatic("BlessCardItem", tmp)
	self.buff1.buffCard.prefabName = "BlessCardItem"
end

---@private
function UIExpeditionWinView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect1/Button
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect1/Button").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buff1.selectNode = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExpeditionWinView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect2
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buff2 = tmp
end

---@private
function UIExpeditionWinView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect2/BlessCardItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect2/BlessCardItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buff2.buffCard = CommonUtil.BindGridViewItem2LuaStatic("BlessCardItem", tmp)
	self.buff2.buffCard.prefabName = "BlessCardItem"
end

---@private
function UIExpeditionWinView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect2/Button
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect2/Button").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buff2.selectNode = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExpeditionWinView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect3
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buff3 = tmp
end

---@private
function UIExpeditionWinView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect3/BlessCardItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect3/BlessCardItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buff3.buffCard = CommonUtil.BindGridViewItem2LuaStatic("BlessCardItem", tmp)
	self.buff3.buffCard.prefabName = "BlessCardItem"
end

---@private
function UIExpeditionWinView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect3/Button
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/RewardsIcons/BlessGrp/CardSelect3/Button").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buff3.selectNode = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExpeditionWinView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/BG/Bg/ScoreReward
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/ScoreReward").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scoreReward = tmp
end

---@private
function UIExpeditionWinView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/BG/Bg/ScoreReward/ScoreNumber
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/ScoreReward/ScoreNumber").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scoreNumber = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIExpeditionWinView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/BG/Bg/ScoreReward/NewRecord
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Bg/ScoreReward/NewRecord").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.newRecord = tmp
end

---@private
function UIExpeditionWinView:GenerateDestroy()
	if tolua.getpeer(self.buff3.selectNode) ~= nil then
		tolua.setpeer(self.buff3.selectNode, nil)
	end
	if self.buff3.buffCard.GenerateDestroy ~= nil then
		self.buff3.buffCard:GenerateDestroy()
	end
	if tolua.getpeer(self.buff3.buffCard) ~= nil then
		tolua.setpeer(self.buff3.buffCard, nil)
	end
	if tolua.getpeer(self.buff2.selectNode) ~= nil then
		tolua.setpeer(self.buff2.selectNode, nil)
	end
	if self.buff2.buffCard.GenerateDestroy ~= nil then
		self.buff2.buffCard:GenerateDestroy()
	end
	if tolua.getpeer(self.buff2.buffCard) ~= nil then
		tolua.setpeer(self.buff2.buffCard, nil)
	end
	if tolua.getpeer(self.buff1.selectNode) ~= nil then
		tolua.setpeer(self.buff1.selectNode, nil)
	end
	if self.buff1.buffCard.GenerateDestroy ~= nil then
		self.buff1.buffCard:GenerateDestroy()
	end
	if tolua.getpeer(self.buff1.buffCard) ~= nil then
		tolua.setpeer(self.buff1.buffCard, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.winTipsNode) ~= nil then
		tolua.setpeer(self.winTipsNode, nil)
	end
	self.winTipsNode = nil
	if tolua.getpeer(self.rewardNode) ~= nil then
		tolua.setpeer(self.rewardNode, nil)
	end
	self.rewardNode = nil
	if tolua.getpeer(self.buffList) ~= nil then
		tolua.setpeer(self.buffList, nil)
	end
	self.buffList = nil
	if tolua.getpeer(self.buff1) ~= nil then
		tolua.setpeer(self.buff1, nil)
	end
	self.buff1 = nil
	if tolua.getpeer(self.buff2) ~= nil then
		tolua.setpeer(self.buff2, nil)
	end
	self.buff2 = nil
	if tolua.getpeer(self.buff3) ~= nil then
		tolua.setpeer(self.buff3, nil)
	end
	self.buff3 = nil
	if tolua.getpeer(self.scoreReward) ~= nil then
		tolua.setpeer(self.scoreReward, nil)
	end
	self.scoreReward = nil
	if tolua.getpeer(self.scoreNumber) ~= nil then
		tolua.setpeer(self.scoreNumber, nil)
	end
	self.scoreNumber = nil
	if tolua.getpeer(self.newRecord) ~= nil then
		tolua.setpeer(self.newRecord, nil)
	end
	self.newRecord = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIExpeditionWinView