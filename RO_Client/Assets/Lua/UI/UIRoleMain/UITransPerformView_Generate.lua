---@class UITransPerform__Generate_title
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UITransPerform__Generate_skill_skillItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UITransPerform__Generate_skill
---@field public gameObject UnityEngine.GameObject
---@field public skillItem UITransPerform__Generate_skill_skillItem

---@class UITransPerform__Generate_skillBox_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UITransPerform__Generate_skillBox
---@field public gameObject UnityEngine.GameObject
---@field public scrollView UITransPerform__Generate_skillBox_scrollView

---@class UITransPerform__Generate_model
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public rawImage UnityEngine.UI.RawImage

---@class UITransPerform__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UITransPerform__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UITransPerform__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UITransPerform__Generate_uIAnimator
---@field private AnyBtn UITransPerform__Generate_AnyBtn
---@field private model UITransPerform__Generate_model
---@field private succeedAnim UnityEngine.GameObject
---@field private curedSucceedAnim UnityEngine.GameObject
---@field private skillBox UITransPerform__Generate_skillBox
---@field private skill UITransPerform__Generate_skill
---@field private title UITransPerform__Generate_title
local UITransPerformView = class("UITransPerformView", require("UIViewBase"))

function UITransPerformView:ctor()
end

---@private
function UITransPerformView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UITransPerformView:InitGenerate(Root, data)
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
	self:InitGenerate__11(Root,data)


end

---@private
function UITransPerformView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UITransPerformView:InitGenerate__2(Root, data)
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
function UITransPerformView:InitGenerate__3(Root, data)
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
function UITransPerformView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Model
--]]
	local tmp = Root:Find("UIAnimator/Window/Model").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.model = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.rawImage = tmp:GetComponent(Enum.TypeInfo.RawImage)
end

---@private
function UITransPerformView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/SucceedAnim
--]]
	local tmp = Root:Find("UIAnimator/Window/SucceedAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.succeedAnim = tmp
end

---@private
function UITransPerformView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/CuredSucceedAnim
--]]
	local tmp = Root:Find("UIAnimator/Window/CuredSucceedAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curedSucceedAnim = tmp
end

---@private
function UITransPerformView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/SkillBox
--]]
	local tmp = Root:Find("UIAnimator/Window/SkillBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillBox = tmp
end

---@private
function UITransPerformView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/SkillBox/Scroll View
--]]
	local tmp = Root:Find("UIAnimator/Window/SkillBox/Scroll View").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillBox.scrollView = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UITransPerformView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/SkillBox/Scroll View/Viewport/Skill
--]]
	local tmp = Root:Find("UIAnimator/Window/SkillBox/Scroll View/Viewport/Skill").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skill = tmp
end

---@private
function UITransPerformView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/SkillBox/Scroll View/Viewport/Skill/SkillItem
--]]
	local tmp = Root:Find("UIAnimator/Window/SkillBox/Scroll View/Viewport/Skill/SkillItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skill.skillItem = CommonUtil.BindGridViewItem2LuaStatic("SkillItem", tmp)
	self.skill.skillItem.prefabName = "SkillItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UITransPerformView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/SkillBox/Title/title
--]]
	local tmp = Root:Find("UIAnimator/Window/SkillBox/Title/title").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UITransPerformView:GenerateDestroy()
	if self.skill.skillItem.GenerateDestroy ~= nil then
		self.skill.skillItem:GenerateDestroy()
	end
	if tolua.getpeer(self.skill.skillItem) ~= nil then
		tolua.setpeer(self.skill.skillItem, nil)
	end
	if tolua.getpeer(self.skillBox.scrollView) ~= nil then
		tolua.setpeer(self.skillBox.scrollView, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.model) ~= nil then
		tolua.setpeer(self.model, nil)
	end
	self.model = nil
	if tolua.getpeer(self.succeedAnim) ~= nil then
		tolua.setpeer(self.succeedAnim, nil)
	end
	self.succeedAnim = nil
	if tolua.getpeer(self.curedSucceedAnim) ~= nil then
		tolua.setpeer(self.curedSucceedAnim, nil)
	end
	self.curedSucceedAnim = nil
	if tolua.getpeer(self.skillBox) ~= nil then
		tolua.setpeer(self.skillBox, nil)
	end
	self.skillBox = nil
	if tolua.getpeer(self.skill) ~= nil then
		tolua.setpeer(self.skill, nil)
	end
	self.skill = nil
	if tolua.getpeer(self.title) ~= nil then
		tolua.setpeer(self.title, nil)
	end
	self.title = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UITransPerformView