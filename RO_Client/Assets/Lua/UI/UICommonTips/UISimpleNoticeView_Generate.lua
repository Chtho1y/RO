---@class UISimpleNotice__Generate_contentLab
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISimpleNotice__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect

---@class UISimpleNotice__Generate_titleLab
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UISimpleNotice__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISimpleNotice__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISimpleNotice__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISimpleNotice__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UISimpleNotice__Generate_uIAnimator
---@field private AnyBtn UISimpleNotice__Generate_AnyBtn
---@field private btnClose UISimpleNotice__Generate_btnClose
---@field private titleLab UISimpleNotice__Generate_titleLab
---@field private scrollView UISimpleNotice__Generate_scrollView
---@field private contentLab UISimpleNotice__Generate_contentLab
local UISimpleNoticeView = class("UISimpleNoticeView", require("UIViewBase"))

function UISimpleNoticeView:ctor()
end

---@private
function UISimpleNoticeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISimpleNoticeView:InitGenerate(Root, data)
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
function UISimpleNoticeView:InitGenerate__1(Root, data)
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
function UISimpleNoticeView:InitGenerate__2(Root, data)
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
function UISimpleNoticeView:InitGenerate__3(Root, data)
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
function UISimpleNoticeView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/TitleLab
--]]
	local tmp = Root:Find("UIAnimator/Window/TitleLab").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.titleLab = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UISimpleNoticeView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)
end

---@private
function UISimpleNoticeView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ScrollView/Viewport/Content/ContentLab
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView/Viewport/Content/ContentLab").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contentLab = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISimpleNoticeView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.titleLab) ~= nil then
		tolua.setpeer(self.titleLab, nil)
	end
	self.titleLab = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.contentLab) ~= nil then
		tolua.setpeer(self.contentLab, nil)
	end
	self.contentLab = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISimpleNoticeView