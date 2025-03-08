---@class UIActivationCode__Generate_okBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivationCode__Generate_codeInput
---@field public gameObject UnityEngine.GameObject
---@field public inputField UnityEngine.UI.InputField

---@class UIActivationCode__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivationCode__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIActivationCode__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIActivationCode__Generate_uIAnimator
---@field private AnyBtn UIActivationCode__Generate_AnyBtn
---@field private codeInput UIActivationCode__Generate_codeInput
---@field private okBtn UIActivationCode__Generate_okBtn
local UIActivationCodeView = class("UIActivationCodeView", require("UIViewBase"))

function UIActivationCodeView:ctor()
end

---@private
function UIActivationCodeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIActivationCodeView:InitGenerate(Root, data)
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


end

---@private
function UIActivationCodeView:InitGenerate__1(Root, data)
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
function UIActivationCodeView:InitGenerate__2(Root, data)
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
function UIActivationCodeView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Center/CodeBox/CodeInput
--]]
	local tmp = Root:Find("UIAnimator/Window/Center/CodeBox/CodeInput").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.codeInput = tmp

	tmp.inputField = tmp:GetComponent(Enum.TypeInfo.InputField)
end

---@private
function UIActivationCodeView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Center/OkBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Center/OkBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.okBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivationCodeView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.codeInput) ~= nil then
		tolua.setpeer(self.codeInput, nil)
	end
	self.codeInput = nil
	if tolua.getpeer(self.okBtn) ~= nil then
		tolua.setpeer(self.okBtn, nil)
	end
	self.okBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIActivationCodeView