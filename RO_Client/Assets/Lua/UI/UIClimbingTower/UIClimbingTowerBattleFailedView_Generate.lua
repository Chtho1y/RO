---@class UIClimbingTowerBattleFailed__Generate_reopenBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTowerBattleFailed__Generate_tips3_btnGo
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTowerBattleFailed__Generate_tips3_tipsContent
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerBattleFailed__Generate_tips3_tipsIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIClimbingTowerBattleFailed__Generate_tips3
---@field public gameObject UnityEngine.GameObject
---@field public tipsIcon UIClimbingTowerBattleFailed__Generate_tips3_tipsIcon
---@field public tipsContent UIClimbingTowerBattleFailed__Generate_tips3_tipsContent
---@field public btnGo UIClimbingTowerBattleFailed__Generate_tips3_btnGo

---@class UIClimbingTowerBattleFailed__Generate_tips2_btnGo
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTowerBattleFailed__Generate_tips2_tipsContent
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerBattleFailed__Generate_tips2_tipsIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIClimbingTowerBattleFailed__Generate_tips2
---@field public gameObject UnityEngine.GameObject
---@field public tipsIcon UIClimbingTowerBattleFailed__Generate_tips2_tipsIcon
---@field public tipsContent UIClimbingTowerBattleFailed__Generate_tips2_tipsContent
---@field public btnGo UIClimbingTowerBattleFailed__Generate_tips2_btnGo

---@class UIClimbingTowerBattleFailed__Generate_tips1_btnGo
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTowerBattleFailed__Generate_tips1_tipsContent
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerBattleFailed__Generate_tips1_tipsIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIClimbingTowerBattleFailed__Generate_tips1
---@field public gameObject UnityEngine.GameObject
---@field public tipsIcon UIClimbingTowerBattleFailed__Generate_tips1_tipsIcon
---@field public tipsContent UIClimbingTowerBattleFailed__Generate_tips1_tipsContent
---@field public btnGo UIClimbingTowerBattleFailed__Generate_tips1_btnGo

---@class UIClimbingTowerBattleFailed__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTowerBattleFailed__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIClimbingTowerBattleFailed__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIClimbingTowerBattleFailed__Generate_uIAnimator
---@field private AnyBtn UIClimbingTowerBattleFailed__Generate_AnyBtn
---@field private tips1 UIClimbingTowerBattleFailed__Generate_tips1
---@field private tips2 UIClimbingTowerBattleFailed__Generate_tips2
---@field private tips3 UIClimbingTowerBattleFailed__Generate_tips3
---@field private reopenBtn UIClimbingTowerBattleFailed__Generate_reopenBtn
local UIClimbingTowerBattleFailedView = class("UIClimbingTowerBattleFailedView", require("UIViewBase"))

function UIClimbingTowerBattleFailedView:ctor()
end

---@private
function UIClimbingTowerBattleFailedView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIClimbingTowerBattleFailedView:InitGenerate(Root, data)
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
function UIClimbingTowerBattleFailedView:InitGenerate__1(Root, data)
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
function UIClimbingTowerBattleFailedView:InitGenerate__2(Root, data)
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
function UIClimbingTowerBattleFailedView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem1
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tips1 = tmp
end

---@private
function UIClimbingTowerBattleFailedView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem1/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem1/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tips1.tipsIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIClimbingTowerBattleFailedView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem1/ItemTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem1/ItemTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tips1.tipsContent = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerBattleFailedView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem1/BtnGoto
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem1/BtnGoto").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tips1.btnGo = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerBattleFailedView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem2
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tips2 = tmp
end

---@private
function UIClimbingTowerBattleFailedView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem2/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem2/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tips2.tipsIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIClimbingTowerBattleFailedView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem2/ItemTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem2/ItemTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tips2.tipsContent = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerBattleFailedView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem2/BtnGoto
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem2/BtnGoto").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tips2.btnGo = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerBattleFailedView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem3
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tips3 = tmp
end

---@private
function UIClimbingTowerBattleFailedView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem3/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem3/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tips3.tipsIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIClimbingTowerBattleFailedView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem3/ItemTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem3/ItemTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tips3.tipsContent = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerBattleFailedView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem3/BtnGoto
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Goto/ItemScrollView/Viewport/Content/GotoIncreaseItem3/BtnGoto").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tips3.btnGo = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerBattleFailedView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/BG/ReopenBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ReopenBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.reopenBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerBattleFailedView:GenerateDestroy()
	if tolua.getpeer(self.tips3.btnGo) ~= nil then
		tolua.setpeer(self.tips3.btnGo, nil)
	end
	if tolua.getpeer(self.tips3.tipsContent) ~= nil then
		tolua.setpeer(self.tips3.tipsContent, nil)
	end
	if tolua.getpeer(self.tips3.tipsIcon) ~= nil then
		tolua.setpeer(self.tips3.tipsIcon, nil)
	end
	if tolua.getpeer(self.tips2.btnGo) ~= nil then
		tolua.setpeer(self.tips2.btnGo, nil)
	end
	if tolua.getpeer(self.tips2.tipsContent) ~= nil then
		tolua.setpeer(self.tips2.tipsContent, nil)
	end
	if tolua.getpeer(self.tips2.tipsIcon) ~= nil then
		tolua.setpeer(self.tips2.tipsIcon, nil)
	end
	if tolua.getpeer(self.tips1.btnGo) ~= nil then
		tolua.setpeer(self.tips1.btnGo, nil)
	end
	if tolua.getpeer(self.tips1.tipsContent) ~= nil then
		tolua.setpeer(self.tips1.tipsContent, nil)
	end
	if tolua.getpeer(self.tips1.tipsIcon) ~= nil then
		tolua.setpeer(self.tips1.tipsIcon, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.tips1) ~= nil then
		tolua.setpeer(self.tips1, nil)
	end
	self.tips1 = nil
	if tolua.getpeer(self.tips2) ~= nil then
		tolua.setpeer(self.tips2, nil)
	end
	self.tips2 = nil
	if tolua.getpeer(self.tips3) ~= nil then
		tolua.setpeer(self.tips3, nil)
	end
	self.tips3 = nil
	if tolua.getpeer(self.reopenBtn) ~= nil then
		tolua.setpeer(self.reopenBtn, nil)
	end
	self.reopenBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIClimbingTowerBattleFailedView