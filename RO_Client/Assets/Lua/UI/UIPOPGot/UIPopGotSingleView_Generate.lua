---@class UIPopGotSingle__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIPopGotSingle__Generate_itemIcon
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIPopGotSingle__Generate_titleText
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPopGotSingle__Generate_nameText
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPopGotSingle__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPopGotSingle__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIPopGotSingle__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIPopGotSingle__Generate_uIAnimator
---@field private AnyBtn UIPopGotSingle__Generate_AnyBtn
---@field private nameText UIPopGotSingle__Generate_nameText
---@field private titleText UIPopGotSingle__Generate_titleText
---@field private itemIcon UIPopGotSingle__Generate_itemIcon
---@field private icon UIPopGotSingle__Generate_icon
local UIPopGotSingleView = class("UIPopGotSingleView", require("UIViewBase"))

function UIPopGotSingleView:ctor()
end

---@private
function UIPopGotSingleView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPopGotSingleView:InitGenerate(Root, data)
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
function UIPopGotSingleView:InitGenerate__1(Root, data)
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
function UIPopGotSingleView:InitGenerate__2(Root, data)
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
function UIPopGotSingleView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/NameText
--]]
	local tmp = Root:Find("UIAnimator/Window/NameText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameText = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPopGotSingleView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/TitleText
--]]
	local tmp = Root:Find("UIAnimator/Window/TitleText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.titleText = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPopGotSingleView:InitGenerate__5(Root, data)
--[[
	UIAnimator/ItemIcon
--]]
	local tmp = Root:Find("UIAnimator/ItemIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemIcon = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIPopGotSingleView:InitGenerate__6(Root, data)
--[[
	UIAnimator/ItemIcon/Icon
--]]
	local tmp = Root:Find("UIAnimator/ItemIcon/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIPopGotSingleView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.nameText) ~= nil then
		tolua.setpeer(self.nameText, nil)
	end
	self.nameText = nil
	if tolua.getpeer(self.titleText) ~= nil then
		tolua.setpeer(self.titleText, nil)
	end
	self.titleText = nil
	if tolua.getpeer(self.itemIcon) ~= nil then
		tolua.setpeer(self.itemIcon, nil)
	end
	self.itemIcon = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPopGotSingleView