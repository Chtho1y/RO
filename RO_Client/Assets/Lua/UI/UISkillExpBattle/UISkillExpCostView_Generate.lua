---@class UISkillExpCost__Generate_challengeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillExpCost__Generate_cancelBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillExpCost__Generate_evilExpText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISkillExpCost__Generate_incomeText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISkillExpCost__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillExpCost__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillExpCost__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISkillExpCost__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UISkillExpCost__Generate_uIAnimator
---@field private AnyBtn UISkillExpCost__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private closeBtn UISkillExpCost__Generate_closeBtn
---@field private incomeText UISkillExpCost__Generate_incomeText
---@field private evilExpText UISkillExpCost__Generate_evilExpText
---@field private btnBox UnityEngine.GameObject
---@field private cancelBtn UISkillExpCost__Generate_cancelBtn
---@field private challengeBtn UISkillExpCost__Generate_challengeBtn
local UISkillExpCostView = class("UISkillExpCostView", require("UIViewBase"))

function UISkillExpCostView:ctor()
end

---@private
function UISkillExpCostView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISkillExpCostView:InitGenerate(Root, data)
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


end

---@private
function UISkillExpCostView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UISkillExpCostView:InitGenerate__2(Root, data)
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
function UISkillExpCostView:InitGenerate__3(Root, data)
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
function UISkillExpCostView:InitGenerate__4(Root, data)
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
function UISkillExpCostView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISkillExpCostView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Center/Icon/Income
--]]
	local tmp = Root:Find("UIAnimator/Window/Center/Icon/Income").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.incomeText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISkillExpCostView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/QuestionTxt/EvilExpVal
--]]
	local tmp = Root:Find("UIAnimator/Window/QuestionTxt/EvilExpVal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.evilExpText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISkillExpCostView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BtnBox
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBox = tmp
end

---@private
function UISkillExpCostView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BtnBox/cancelBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/cancelBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cancelBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISkillExpCostView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BtnBox/challengeBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/challengeBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.challengeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISkillExpCostView:GenerateDestroy()
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
	if tolua.getpeer(self.closeBtn) ~= nil then
		tolua.setpeer(self.closeBtn, nil)
	end
	self.closeBtn = nil
	if tolua.getpeer(self.incomeText) ~= nil then
		tolua.setpeer(self.incomeText, nil)
	end
	self.incomeText = nil
	if tolua.getpeer(self.evilExpText) ~= nil then
		tolua.setpeer(self.evilExpText, nil)
	end
	self.evilExpText = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.cancelBtn) ~= nil then
		tolua.setpeer(self.cancelBtn, nil)
	end
	self.cancelBtn = nil
	if tolua.getpeer(self.challengeBtn) ~= nil then
		tolua.setpeer(self.challengeBtn, nil)
	end
	self.challengeBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISkillExpCostView