---@class UIQuickBattle__Generate_StartBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIQuickBattle__Generate_StartBtnLbl
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIQuickBattle__Generate_LeftTimesLbl
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIQuickBattle__Generate_CloseBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIQuickBattle__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIQuickBattle__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIQuickBattle__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIQuickBattle__Generate_uIAnimator
---@field private AnyBtn UIQuickBattle__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private CloseBtn UIQuickBattle__Generate_CloseBtn
---@field private LeftTimesLbl UIQuickBattle__Generate_LeftTimesLbl
---@field private StartBtnLbl UIQuickBattle__Generate_StartBtnLbl
---@field private StartBtn UIQuickBattle__Generate_StartBtn
local UIQuickBattleView = class("UIQuickBattleView", require("UIViewBase"))

function UIQuickBattleView:ctor()
end

---@private
function UIQuickBattleView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIQuickBattleView:InitGenerate(Root, data)
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


end

---@private
function UIQuickBattleView:InitGenerate__1(Root, data)
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
function UIQuickBattleView:InitGenerate__2(Root, data)
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
function UIQuickBattleView:InitGenerate__3(Root, data)
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
function UIQuickBattleView:InitGenerate__4(Root, data)
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
function UIQuickBattleView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BG/TimingBox/TalkBox/Times/LeftTimesLbl
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TimingBox/TalkBox/Times/LeftTimesLbl").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LeftTimesLbl = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIQuickBattleView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BG/BottomBox/CostBox/CostNumber
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BottomBox/CostBox/CostNumber").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.StartBtnLbl = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIQuickBattleView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BG/BottomBox/StartBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BottomBox/StartBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.StartBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIQuickBattleView:GenerateDestroy()
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
	if tolua.getpeer(self.CloseBtn) ~= nil then
		tolua.setpeer(self.CloseBtn, nil)
	end
	self.CloseBtn = nil
	if tolua.getpeer(self.LeftTimesLbl) ~= nil then
		tolua.setpeer(self.LeftTimesLbl, nil)
	end
	self.LeftTimesLbl = nil
	if tolua.getpeer(self.StartBtnLbl) ~= nil then
		tolua.setpeer(self.StartBtnLbl, nil)
	end
	self.StartBtnLbl = nil
	if tolua.getpeer(self.StartBtn) ~= nil then
		tolua.setpeer(self.StartBtn, nil)
	end
	self.StartBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIQuickBattleView