---@class UIActivitySignDaily__Generate_dscTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivitySignDaily__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivitySignDaily__Generate_signRewardItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image

---@class UIActivitySignDaily__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIActivitySignDaily__Generate_titleTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivitySignDaily__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivitySignDaily__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIActivitySignDaily__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIActivitySignDaily__Generate_uIAnimator
---@field private AnyBtn UIActivitySignDaily__Generate_AnyBtn
---@field private titleTxt UIActivitySignDaily__Generate_titleTxt
---@field private scrollView UIActivitySignDaily__Generate_scrollView
---@field private content UnityEngine.GameObject
---@field private signRewardItem UIActivitySignDaily__Generate_signRewardItem
---@field private btnClose UIActivitySignDaily__Generate_btnClose
---@field private dscBox UnityEngine.GameObject
---@field private dscTxt UIActivitySignDaily__Generate_dscTxt
local UIActivitySignDailyView = class("UIActivitySignDailyView", require("UIViewBase"))

function UIActivitySignDailyView:ctor()
end

---@private
function UIActivitySignDailyView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIActivitySignDailyView:InitGenerate(Root, data)
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
function UIActivitySignDailyView:InitGenerate__1(Root, data)
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
function UIActivitySignDailyView:InitGenerate__2(Root, data)
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
function UIActivitySignDailyView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BG/Title/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Title/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.titleTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivitySignDailyView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIActivitySignDailyView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ScrollView/View/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView/View/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp
end

---@private
function UIActivitySignDailyView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ScrollView/View/Content/SignRewardItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ScrollView/View/Content/SignRewardItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.signRewardItem = CommonUtil.BindGridViewItem2LuaStatic("SignRewardItem", tmp)
	self.signRewardItem.prefabName = "SignRewardItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIActivitySignDailyView:InitGenerate__7(Root, data)
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
function UIActivitySignDailyView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/DscBox
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox = tmp
end

---@private
function UIActivitySignDailyView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/DscBox/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivitySignDailyView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.titleTxt) ~= nil then
		tolua.setpeer(self.titleTxt, nil)
	end
	self.titleTxt = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	if self.signRewardItem.GenerateDestroy ~= nil then
		self.signRewardItem:GenerateDestroy()
	end
	if tolua.getpeer(self.signRewardItem) ~= nil then
		tolua.setpeer(self.signRewardItem, nil)
	end
	self.signRewardItem = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.dscBox) ~= nil then
		tolua.setpeer(self.dscBox, nil)
	end
	self.dscBox = nil
	if tolua.getpeer(self.dscTxt) ~= nil then
		tolua.setpeer(self.dscTxt, nil)
	end
	self.dscTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIActivitySignDailyView