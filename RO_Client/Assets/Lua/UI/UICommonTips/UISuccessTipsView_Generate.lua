---@class UISuccessTips__Generate_particle
---@field public gameObject UnityEngine.GameObject
---@field public uIParticle UIExtensions.UIParticle

---@class UISuccessTips__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISuccessTips__Generate_skillItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UISuccessTips__Generate_title
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UISuccessTips__Generate_alpha
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISuccessTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private alpha UISuccessTips__Generate_alpha
---@field private title UISuccessTips__Generate_title
---@field private skillItem UISuccessTips__Generate_skillItem
---@field private nameTxt UISuccessTips__Generate_nameTxt
---@field private particle UISuccessTips__Generate_particle
local UISuccessTipsView = class("UISuccessTipsView", require("UIViewBase"))

function UISuccessTipsView:ctor()
end

---@private
function UISuccessTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISuccessTipsView:InitGenerate(Root, data)
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
function UISuccessTipsView:InitGenerate__1(Root, data)
--[[
	Alpha
--]]
	local tmp = Root:Find("Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.alpha = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISuccessTipsView:InitGenerate__2(Root, data)
--[[
	Window/BG/Title/title
--]]
	local tmp = Root:Find("Window/BG/Title/title").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UISuccessTipsView:InitGenerate__3(Root, data)
--[[
	Window/BG/Content/Icon/SkillItem
--]]
	local tmp = Root:Find("Window/BG/Content/Icon/SkillItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillItem = CommonUtil.BindGridViewItem2LuaStatic("SkillItem", tmp)
	self.skillItem.prefabName = "SkillItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UISuccessTipsView:InitGenerate__4(Root, data)
--[[
	Window/BG/Content/Icon/NameTxt
--]]
	local tmp = Root:Find("Window/BG/Content/Icon/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISuccessTipsView:InitGenerate__5(Root, data)
--[[
	Window/BG/Content/particle
--]]
	local tmp = Root:Find("Window/BG/Content/particle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.particle = tmp

	tmp.uIParticle = tmp:GetComponent(Enum.TypeInfo.UIParticle)
end

---@private
function UISuccessTipsView:GenerateDestroy()
	if tolua.getpeer(self.alpha) ~= nil then
		tolua.setpeer(self.alpha, nil)
	end
	self.alpha = nil
	if tolua.getpeer(self.title) ~= nil then
		tolua.setpeer(self.title, nil)
	end
	self.title = nil
	if self.skillItem.GenerateDestroy ~= nil then
		self.skillItem:GenerateDestroy()
	end
	if tolua.getpeer(self.skillItem) ~= nil then
		tolua.setpeer(self.skillItem, nil)
	end
	self.skillItem = nil
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	if tolua.getpeer(self.particle) ~= nil then
		tolua.setpeer(self.particle, nil)
	end
	self.particle = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISuccessTipsView