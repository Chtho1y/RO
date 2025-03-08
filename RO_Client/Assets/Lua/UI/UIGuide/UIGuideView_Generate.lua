---@class UIGuide__Generate_arrow
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIGuide__Generate_arrow_bg
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIGuide__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuide__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIEventHandler UIEventHandler
---@field private bg UIGuide__Generate_bg
---@field private arrow_bg UIGuide__Generate_arrow_bg
---@field private arrow UIGuide__Generate_arrow
local UIGuideView = class("UIGuideView", require("UIViewBase"))

function UIGuideView:ctor()
end

---@private
function UIGuideView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuideView:InitGenerate(Root, data)
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
function UIGuideView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.uIEventHandler = Root:GetComponent(Enum.TypeInfo.UIEventHandler)
end

---@private
function UIGuideView:InitGenerate__2(Root, data)
--[[
	bg
--]]
	local tmp = Root:Find("bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuideView:InitGenerate__3(Root, data)
--[[
	arrow_bg
--]]
	local tmp = Root:Find("arrow_bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.arrow_bg = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIGuideView:InitGenerate__4(Root, data)
--[[
	arrow_bg/arrow
--]]
	local tmp = Root:Find("arrow_bg/arrow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.arrow = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIGuideView:GenerateDestroy()
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.arrow_bg) ~= nil then
		tolua.setpeer(self.arrow_bg, nil)
	end
	self.arrow_bg = nil
	if tolua.getpeer(self.arrow) ~= nil then
		tolua.setpeer(self.arrow, nil)
	end
	self.arrow = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuideView