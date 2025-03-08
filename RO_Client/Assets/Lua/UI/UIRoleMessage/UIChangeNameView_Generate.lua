---@class UIChangeName__Generate_changeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeName__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChangeName__Generate_inputField
---@field public gameObject UnityEngine.GameObject
---@field public inputField UnityEngine.UI.InputField

---@class UIChangeName__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeName__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeName__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIChangeName__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIChangeName__Generate_uIAnimator
---@field private AnyBtn UIChangeName__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UIChangeName__Generate_btnClose
---@field private inputField UIChangeName__Generate_inputField
---@field private desTxt UIChangeName__Generate_desTxt
---@field private change UnityEngine.GameObject
---@field private changeBtn UIChangeName__Generate_changeBtn
local UIChangeNameView = class("UIChangeNameView", require("UIViewBase"))

function UIChangeNameView:ctor()
end

---@private
function UIChangeNameView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIChangeNameView:InitGenerate(Root, data)
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


end

---@private
function UIChangeNameView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIChangeNameView:InitGenerate__2(Root, data)
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
function UIChangeNameView:InitGenerate__3(Root, data)
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
function UIChangeNameView:InitGenerate__4(Root, data)
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
function UIChangeNameView:InitGenerate__5(Root, data)
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
function UIChangeNameView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/ChangeList/InputField
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ChangeList/InputField").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.inputField = tmp

	tmp.inputField = tmp:GetComponent(Enum.TypeInfo.InputField)
end

---@private
function UIChangeNameView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/ChangeList/Consume/DesTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ChangeList/Consume/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIChangeNameView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/Change
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Change").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.change = tmp
end

---@private
function UIChangeNameView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/Change/ChangeBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Change/ChangeBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.changeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChangeNameView:GenerateDestroy()
	if tolua.getpeer(self.changeBtn) ~= nil then
		tolua.setpeer(self.changeBtn, nil)
	end
	if tolua.getpeer(self.change) ~= nil then
		tolua.setpeer(self.change, nil)
	end
	if tolua.getpeer(self.inputField) ~= nil then
		tolua.setpeer(self.inputField, nil)
	end
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIChangeNameView