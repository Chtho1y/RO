---@class UISkillPreview__Generate_skillList
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UISkillPreview__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillPreview__Generate_alpha
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillPreview__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISkillPreview__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UISkillPreview__Generate_uIAnimator
---@field private alpha UISkillPreview__Generate_alpha
---@field private bg UnityEngine.GameObject
---@field private btnClose UISkillPreview__Generate_btnClose
---@field private skillList UISkillPreview__Generate_skillList
local UISkillPreviewView = class("UISkillPreviewView", require("UIViewBase"))

function UISkillPreviewView:ctor()
end

---@private
function UISkillPreviewView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISkillPreviewView:InitGenerate(Root, data)
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
function UISkillPreviewView:InitGenerate__1(Root, data)
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
function UISkillPreviewView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.alpha = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISkillPreviewView:InitGenerate__3(Root, data)
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
function UISkillPreviewView:InitGenerate__4(Root, data)
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
function UISkillPreviewView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/SkillList
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/SkillList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillList = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UISkillPreviewView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.alpha) ~= nil then
		tolua.setpeer(self.alpha, nil)
	end
	self.alpha = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.skillList) ~= nil then
		tolua.setpeer(self.skillList, nil)
	end
	self.skillList = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISkillPreviewView