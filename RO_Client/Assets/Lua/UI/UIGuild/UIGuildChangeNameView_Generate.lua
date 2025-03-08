---@class UIGuildChangeName__Generate_saveBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildChangeName__Generate_cancelBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildChangeName__Generate_costTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildChangeName__Generate_input
---@field public gameObject UnityEngine.GameObject
---@field public inputField UnityEngine.UI.InputField

---@class UIGuildChangeName__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildChangeName__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildChangeName__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIGuildChangeName__Generate_AnyBtn
---@field private btnClose UIGuildChangeName__Generate_btnClose
---@field private input UIGuildChangeName__Generate_input
---@field private costTxt UIGuildChangeName__Generate_costTxt
---@field private cancelBtn UIGuildChangeName__Generate_cancelBtn
---@field private saveBtn UIGuildChangeName__Generate_saveBtn
local UIGuildChangeNameView = class("UIGuildChangeNameView", require("UIViewBase"))

function UIGuildChangeNameView:ctor()
end

---@private
function UIGuildChangeNameView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildChangeNameView:InitGenerate(Root, data)
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


end

---@private
function UIGuildChangeNameView:InitGenerate__1(Root, data)
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
function UIGuildChangeNameView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildChangeNameView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/ChangeList/Input
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/Input").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.input = tmp

	tmp.inputField = tmp:GetComponent(Enum.TypeInfo.InputField)
end

---@private
function UIGuildChangeNameView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/ChangeList/CostTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/CostTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.costTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildChangeNameView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bottom/CancelBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/CancelBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cancelBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildChangeNameView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bottom/SaveBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/SaveBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.saveBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildChangeNameView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.input) ~= nil then
		tolua.setpeer(self.input, nil)
	end
	self.input = nil
	if tolua.getpeer(self.costTxt) ~= nil then
		tolua.setpeer(self.costTxt, nil)
	end
	self.costTxt = nil
	if tolua.getpeer(self.cancelBtn) ~= nil then
		tolua.setpeer(self.cancelBtn, nil)
	end
	self.cancelBtn = nil
	if tolua.getpeer(self.saveBtn) ~= nil then
		tolua.setpeer(self.saveBtn, nil)
	end
	self.saveBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildChangeNameView