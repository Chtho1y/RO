---@class UIFuncMenu__Generate_btn_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIFuncMenu__Generate_btn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIFuncMenu__Generate_btn_text

---@class UIFuncMenu__Generate_btnContainer
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup
---@field public contentSizeFitter UnityEngine.UI.ContentSizeFitter

---@class UIFuncMenu__Generate_mask
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFuncMenu__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private mask UIFuncMenu__Generate_mask
---@field private btnContainer UIFuncMenu__Generate_btnContainer
---@field private btn UIFuncMenu__Generate_btn
local UIFuncMenuView = class("UIFuncMenuView", require("UIViewBase"))

function UIFuncMenuView:ctor()
end

---@private
function UIFuncMenuView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIFuncMenuView:InitGenerate(Root, data)
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
function UIFuncMenuView:InitGenerate__1(Root, data)
--[[
	Mask
--]]
	local tmp = Root:Find("Mask").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mask = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFuncMenuView:InitGenerate__2(Root, data)
--[[
	BtnContainer
--]]
	local tmp = Root:Find("BtnContainer").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnContainer = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)

	tmp.contentSizeFitter = tmp:GetComponent(Enum.TypeInfo.ContentSizeFitter)
end

---@private
function UIFuncMenuView:InitGenerate__3(Root, data)
--[[
	BtnContainer/Btn
--]]
	local tmp = Root:Find("BtnContainer/Btn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFuncMenuView:InitGenerate__4(Root, data)
--[[
	BtnContainer/Btn/Text
--]]
	local tmp = Root:Find("BtnContainer/Btn/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btn.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIFuncMenuView:GenerateDestroy()
	if tolua.getpeer(self.btn.text) ~= nil then
		tolua.setpeer(self.btn.text, nil)
	end
	if tolua.getpeer(self.mask) ~= nil then
		tolua.setpeer(self.mask, nil)
	end
	self.mask = nil
	if tolua.getpeer(self.btnContainer) ~= nil then
		tolua.setpeer(self.btnContainer, nil)
	end
	self.btnContainer = nil
	if tolua.getpeer(self.btn) ~= nil then
		tolua.setpeer(self.btn, nil)
	end
	self.btn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIFuncMenuView