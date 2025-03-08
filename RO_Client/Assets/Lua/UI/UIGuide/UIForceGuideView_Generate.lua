---@class UIForceGuide__Generate_targetPoint
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIForceGuide__Generate_maskPoint
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class UIForceGuide__Generate_boliPoint_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIForceGuide__Generate_boliPoint
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public text UIForceGuide__Generate_boliPoint_text

---@class UIForceGuide__Generate_mask
---@field public gameObject UnityEngine.GameObject
---@field public guideMask GuideMask
---@field public image UnityEngine.UI.Image
---@field public uIEventTriggerListener UIEventTriggerListener

---@class UIForceGuide__Generate_bG
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIForceGuide__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIEventHandler UIEventHandler
---@field private bG UIForceGuide__Generate_bG
---@field private mask UIForceGuide__Generate_mask
---@field private boliPoint UIForceGuide__Generate_boliPoint
---@field private guidePoint UnityEngine.GameObject
---@field private maskPoint UIForceGuide__Generate_maskPoint
---@field private targetPoint UIForceGuide__Generate_targetPoint
local UIForceGuideView = class("UIForceGuideView", require("UIViewBase"))

function UIForceGuideView:ctor()
end

---@private
function UIForceGuideView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIForceGuideView:InitGenerate(Root, data)
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
function UIForceGuideView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.uIEventHandler = Root:GetComponent(Enum.TypeInfo.UIEventHandler)
end

---@private
function UIForceGuideView:InitGenerate__2(Root, data)
--[[
	Alpha/BG
--]]
	local tmp = Root:Find("Alpha/BG").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bG = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIForceGuideView:InitGenerate__3(Root, data)
--[[
	GuideBox/Mask
--]]
	local tmp = Root:Find("GuideBox/Mask").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mask = tmp

	tmp.guideMask = tmp:GetComponent(Enum.TypeInfo.GuideMask)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
end

---@private
function UIForceGuideView:InitGenerate__4(Root, data)
--[[
	GuideBox/BoliPoint
--]]
	local tmp = Root:Find("GuideBox/BoliPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boliPoint = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIForceGuideView:InitGenerate__5(Root, data)
--[[
	GuideBox/BoliPoint/Talk/bg/Text
--]]
	local tmp = Root:Find("GuideBox/BoliPoint/Talk/bg/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boliPoint.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIForceGuideView:InitGenerate__6(Root, data)
--[[
	GuideBox/GuidePoint
--]]
	local tmp = Root:Find("GuideBox/GuidePoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guidePoint = tmp
end

---@private
function UIForceGuideView:InitGenerate__7(Root, data)
--[[
	GuideBox/MaskPoint
--]]
	local tmp = Root:Find("GuideBox/MaskPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.maskPoint = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIForceGuideView:InitGenerate__8(Root, data)
--[[
	GuideBox/TargetPoint
--]]
	local tmp = Root:Find("GuideBox/TargetPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.targetPoint = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIForceGuideView:GenerateDestroy()
	if tolua.getpeer(self.boliPoint.text) ~= nil then
		tolua.setpeer(self.boliPoint.text, nil)
	end
	if tolua.getpeer(self.bG) ~= nil then
		tolua.setpeer(self.bG, nil)
	end
	self.bG = nil
	if tolua.getpeer(self.mask) ~= nil then
		tolua.setpeer(self.mask, nil)
	end
	self.mask = nil
	if tolua.getpeer(self.boliPoint) ~= nil then
		tolua.setpeer(self.boliPoint, nil)
	end
	self.boliPoint = nil
	if tolua.getpeer(self.guidePoint) ~= nil then
		tolua.setpeer(self.guidePoint, nil)
	end
	self.guidePoint = nil
	if tolua.getpeer(self.maskPoint) ~= nil then
		tolua.setpeer(self.maskPoint, nil)
	end
	self.maskPoint = nil
	if tolua.getpeer(self.targetPoint) ~= nil then
		tolua.setpeer(self.targetPoint, nil)
	end
	self.targetPoint = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIForceGuideView