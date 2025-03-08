---@class UIVipExpTips__Generate_addNum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIVipExpTips__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIVipExpTips__Generate_slider2
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class UIVipExpTips__Generate_slider1
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class UIVipExpTips__Generate_vipIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIVipExpTips__Generate_vipNameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIVipExpTips__Generate_vipExpAnim
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIVipExpTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private vipExpAnim UIVipExpTips__Generate_vipExpAnim
---@field private vipNameTxt UIVipExpTips__Generate_vipNameTxt
---@field private vipIcon UIVipExpTips__Generate_vipIcon
---@field private slider1 UIVipExpTips__Generate_slider1
---@field private slider2 UIVipExpTips__Generate_slider2
---@field private number UIVipExpTips__Generate_number
---@field private addNum UIVipExpTips__Generate_addNum
local UIVipExpTipsView = class("UIVipExpTipsView", require("UIViewBase"))

function UIVipExpTipsView:ctor()
end

---@private
function UIVipExpTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIVipExpTipsView:InitGenerate(Root, data)
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


end

---@private
function UIVipExpTipsView:InitGenerate__1(Root, data)
--[[
	VipExpAnim
--]]
	local tmp = Root:Find("VipExpAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipExpAnim = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIVipExpTipsView:InitGenerate__2(Root, data)
--[[
	VipExpAnim/desc/VipNameTxt
--]]
	local tmp = Root:Find("VipExpAnim/desc/VipNameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipNameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIVipExpTipsView:InitGenerate__3(Root, data)
--[[
	VipExpAnim/desc/VipIcon
--]]
	local tmp = Root:Find("VipExpAnim/desc/VipIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIVipExpTipsView:InitGenerate__4(Root, data)
--[[
	VipExpAnim/ExpBar/Slider1
--]]
	local tmp = Root:Find("VipExpAnim/ExpBar/Slider1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slider1 = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function UIVipExpTipsView:InitGenerate__5(Root, data)
--[[
	VipExpAnim/ExpBar/Slider2
--]]
	local tmp = Root:Find("VipExpAnim/ExpBar/Slider2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slider2 = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function UIVipExpTipsView:InitGenerate__6(Root, data)
--[[
	VipExpAnim/ExpBar/Number
--]]
	local tmp = Root:Find("VipExpAnim/ExpBar/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIVipExpTipsView:InitGenerate__7(Root, data)
--[[
	VipExpAnim/AddBox/AddNum
--]]
	local tmp = Root:Find("VipExpAnim/AddBox/AddNum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIVipExpTipsView:GenerateDestroy()
	if tolua.getpeer(self.vipExpAnim) ~= nil then
		tolua.setpeer(self.vipExpAnim, nil)
	end
	self.vipExpAnim = nil
	if tolua.getpeer(self.vipNameTxt) ~= nil then
		tolua.setpeer(self.vipNameTxt, nil)
	end
	self.vipNameTxt = nil
	if tolua.getpeer(self.vipIcon) ~= nil then
		tolua.setpeer(self.vipIcon, nil)
	end
	self.vipIcon = nil
	if tolua.getpeer(self.slider1) ~= nil then
		tolua.setpeer(self.slider1, nil)
	end
	self.slider1 = nil
	if tolua.getpeer(self.slider2) ~= nil then
		tolua.setpeer(self.slider2, nil)
	end
	self.slider2 = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
	if tolua.getpeer(self.addNum) ~= nil then
		tolua.setpeer(self.addNum, nil)
	end
	self.addNum = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIVipExpTipsView