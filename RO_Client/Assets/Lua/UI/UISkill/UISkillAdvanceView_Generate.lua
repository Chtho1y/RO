---@class UISkillAdvance__Generate_btnSkillAdvance
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillAdvance__Generate_btnCancel
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillAdvance__Generate_skillPreviewItem2
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillAdvance__Generate_skillPreviewItem1
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillAdvance__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillAdvance__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillAdvance__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISkillAdvance__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UISkillAdvance__Generate_uIAnimator
---@field private AnyBtn UISkillAdvance__Generate_AnyBtn
---@field private bg UnityEngine.GameObject
---@field private btnClose UISkillAdvance__Generate_btnClose
---@field private skillPreviewItem1 UISkillAdvance__Generate_skillPreviewItem1
---@field private skillPreviewItem2 UISkillAdvance__Generate_skillPreviewItem2
---@field private btnCancel UISkillAdvance__Generate_btnCancel
---@field private btnSkillAdvance UISkillAdvance__Generate_btnSkillAdvance
local UISkillAdvanceView = class("UISkillAdvanceView", require("UIViewBase"))

function UISkillAdvanceView:ctor()
end

---@private
function UISkillAdvanceView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISkillAdvanceView:InitGenerate(Root, data)
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
function UISkillAdvanceView:InitGenerate__1(Root, data)
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
function UISkillAdvanceView:InitGenerate__2(Root, data)
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
function UISkillAdvanceView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Bg
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp
end

---@private
function UISkillAdvanceView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISkillAdvanceView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/SkillList/SkillPreviewItem1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/SkillList/SkillPreviewItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillPreviewItem1 = CommonUtil.BindGridViewItem2LuaStatic("SkillPreviewItem", tmp)
	self.skillPreviewItem1.prefabName = "SkillPreviewItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISkillAdvanceView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/SkillList/SkillPreviewItem2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/SkillList/SkillPreviewItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillPreviewItem2 = CommonUtil.BindGridViewItem2LuaStatic("SkillPreviewItem", tmp)
	self.skillPreviewItem2.prefabName = "SkillPreviewItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISkillAdvanceView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/BtnCancel
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/BtnCancel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCancel = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISkillAdvanceView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/BtnSkillAdvance
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/BtnSkillAdvance").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSkillAdvance = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISkillAdvanceView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if self.skillPreviewItem1.GenerateDestroy ~= nil then
		self.skillPreviewItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.skillPreviewItem1) ~= nil then
		tolua.setpeer(self.skillPreviewItem1, nil)
	end
	self.skillPreviewItem1 = nil
	if self.skillPreviewItem2.GenerateDestroy ~= nil then
		self.skillPreviewItem2:GenerateDestroy()
	end
	if tolua.getpeer(self.skillPreviewItem2) ~= nil then
		tolua.setpeer(self.skillPreviewItem2, nil)
	end
	self.skillPreviewItem2 = nil
	if tolua.getpeer(self.btnCancel) ~= nil then
		tolua.setpeer(self.btnCancel, nil)
	end
	self.btnCancel = nil
	if tolua.getpeer(self.btnSkillAdvance) ~= nil then
		tolua.setpeer(self.btnSkillAdvance, nil)
	end
	self.btnSkillAdvance = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISkillAdvanceView