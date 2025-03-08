---@class UIExchangeCode__Generate_inputField
---@field public gameObject UnityEngine.GameObject
---@field public inputField UnityEngine.UI.InputField

---@class UIExchangeCode__Generate_exchangeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExchangeCode__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExchangeCode__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExchangeCode__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIExchangeCode__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIExchangeCode__Generate_uIAnimator
---@field private AnyBtn UIExchangeCode__Generate_AnyBtn
---@field private btnClose UIExchangeCode__Generate_btnClose
---@field private bottom UnityEngine.GameObject
---@field private exchangeBtn UIExchangeCode__Generate_exchangeBtn
---@field private npcAnim UnityEngine.GameObject
---@field private inputField UIExchangeCode__Generate_inputField
local UIExchangeCodeView = class("UIExchangeCodeView", require("UIViewBase"))

function UIExchangeCodeView:ctor()
end

---@private
function UIExchangeCodeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIExchangeCodeView:InitGenerate(Root, data)
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


end

---@private
function UIExchangeCodeView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIExchangeCodeView:InitGenerate__2(Root, data)
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
function UIExchangeCodeView:InitGenerate__3(Root, data)
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
function UIExchangeCodeView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExchangeCodeView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottom = tmp
end

---@private
function UIExchangeCodeView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/Bottom/ExchangeBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Bottom/ExchangeBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.exchangeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExchangeCodeView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/NpcAnim
--]]
	local tmp = Root:Find("UIAnimator/Window/NpcAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.npcAnim = tmp
end

---@private
function UIExchangeCodeView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Talk/InputField
--]]
	local tmp = Root:Find("UIAnimator/Window/Talk/InputField").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.inputField = tmp

	tmp.inputField = tmp:GetComponent(Enum.TypeInfo.InputField)
end

---@private
function UIExchangeCodeView:GenerateDestroy()
	if tolua.getpeer(self.inputField) ~= nil then
		tolua.setpeer(self.inputField, nil)
	end
	if tolua.getpeer(self.exchangeBtn) ~= nil then
		tolua.setpeer(self.exchangeBtn, nil)
	end
	if tolua.getpeer(self.bottom) ~= nil then
		tolua.setpeer(self.bottom, nil)
	end
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.npcAnim) ~= nil then
		tolua.setpeer(self.npcAnim, nil)
	end
	self.npcAnim = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIExchangeCodeView