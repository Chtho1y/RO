---@class UIHundredDojoSlogan__Generate_btnConfirm
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIHundredDojoSlogan__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIHundredDojoSlogan__Generate_inputField
---@field public gameObject UnityEngine.GameObject
---@field public inputField UnityEngine.UI.InputField

---@class UIHundredDojoSlogan__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIHundredDojoSlogan__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIHundredDojoSlogan__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIHundredDojoSlogan__Generate_AnyBtn
---@field private btnClose UIHundredDojoSlogan__Generate_btnClose
---@field private inputField UIHundredDojoSlogan__Generate_inputField
---@field private text UIHundredDojoSlogan__Generate_text
---@field private btnConfirm UIHundredDojoSlogan__Generate_btnConfirm
local UIHundredDojoSloganView = class("UIHundredDojoSloganView", require("UIViewBase"))

function UIHundredDojoSloganView:ctor()
end

---@private
function UIHundredDojoSloganView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIHundredDojoSloganView:InitGenerate(Root, data)
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


end

---@private
function UIHundredDojoSloganView:InitGenerate__1(Root, data)
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
function UIHundredDojoSloganView:InitGenerate__2(Root, data)
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
function UIHundredDojoSloganView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/DscBox/InputField
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/InputField").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.inputField = tmp

	tmp.inputField = tmp:GetComponent(Enum.TypeInfo.InputField)
end

---@private
function UIHundredDojoSloganView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/DscBox/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIHundredDojoSloganView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnConfirm
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnConfirm").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnConfirm = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIHundredDojoSloganView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.inputField) ~= nil then
		tolua.setpeer(self.inputField, nil)
	end
	self.inputField = nil
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.btnConfirm) ~= nil then
		tolua.setpeer(self.btnConfirm, nil)
	end
	self.btnConfirm = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIHundredDojoSloganView