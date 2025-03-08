---@class WashAttrItem__Generate_propertyItem2_random
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class WashAttrItem__Generate_propertyItem2_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class WashAttrItem__Generate_propertyItem2_prName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class WashAttrItem__Generate_propertyItem2
---@field public gameObject UnityEngine.GameObject
---@field public prName WashAttrItem__Generate_propertyItem2_prName
---@field public number WashAttrItem__Generate_propertyItem2_number
---@field public random WashAttrItem__Generate_propertyItem2_random

---@class WashAttrItem__Generate_propertyItem1_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class WashAttrItem__Generate_propertyItem1_prName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class WashAttrItem__Generate_propertyItem1
---@field public gameObject UnityEngine.GameObject
---@field public prName WashAttrItem__Generate_propertyItem1_prName
---@field public number WashAttrItem__Generate_propertyItem1_number

---@class WashAttrItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIEffectCfg UIEffectCfg
---@field private propertyItem1 WashAttrItem__Generate_propertyItem1
---@field private propertyItem2 WashAttrItem__Generate_propertyItem2
---@field private arrow UnityEngine.GameObject
---@field private fx UnityEngine.GameObject
local WashAttrItemView = class("WashAttrItemView")

function WashAttrItemView:ctor()
end

---@private
function WashAttrItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function WashAttrItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

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


end

---@private
function WashAttrItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.uIEffectCfg = Root:GetComponent(Enum.TypeInfo.UIEffectCfg)
end

---@private
function WashAttrItemView:InitGenerate__2(Root, data)
--[[
	PropertyItem1
--]]
	local tmp = Root:Find("PropertyItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.propertyItem1 = tmp
end

---@private
function WashAttrItemView:InitGenerate__3(Root, data)
--[[
	PropertyItem1/PrName
--]]
	local tmp = Root:Find("PropertyItem1/PrName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.propertyItem1.prName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function WashAttrItemView:InitGenerate__4(Root, data)
--[[
	PropertyItem1/Number
--]]
	local tmp = Root:Find("PropertyItem1/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.propertyItem1.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function WashAttrItemView:InitGenerate__5(Root, data)
--[[
	PropertyItem2
--]]
	local tmp = Root:Find("PropertyItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.propertyItem2 = tmp
end

---@private
function WashAttrItemView:InitGenerate__6(Root, data)
--[[
	PropertyItem2/PrName
--]]
	local tmp = Root:Find("PropertyItem2/PrName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.propertyItem2.prName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function WashAttrItemView:InitGenerate__7(Root, data)
--[[
	PropertyItem2/Number
--]]
	local tmp = Root:Find("PropertyItem2/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.propertyItem2.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function WashAttrItemView:InitGenerate__8(Root, data)
--[[
	PropertyItem2/Random
--]]
	local tmp = Root:Find("PropertyItem2/Random").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.propertyItem2.random = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function WashAttrItemView:InitGenerate__9(Root, data)
--[[
	arrow
--]]
	local tmp = Root:Find("arrow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.arrow = tmp
end

---@private
function WashAttrItemView:InitGenerate__10(Root, data)
--[[
	fx
--]]
	local tmp = Root:Find("fx").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fx = tmp
end

---@private
function WashAttrItemView:GenerateDestroy()
	if tolua.getpeer(self.fx) ~= nil then
		tolua.setpeer(self.fx, nil)
	end
	if tolua.getpeer(self.arrow) ~= nil then
		tolua.setpeer(self.arrow, nil)
	end
	if tolua.getpeer(self.propertyItem2.random) ~= nil then
		tolua.setpeer(self.propertyItem2.random, nil)
	end
	if tolua.getpeer(self.propertyItem2.number) ~= nil then
		tolua.setpeer(self.propertyItem2.number, nil)
	end
	if tolua.getpeer(self.propertyItem2.prName) ~= nil then
		tolua.setpeer(self.propertyItem2.prName, nil)
	end
	if tolua.getpeer(self.propertyItem2) ~= nil then
		tolua.setpeer(self.propertyItem2, nil)
	end
	if tolua.getpeer(self.propertyItem1.number) ~= nil then
		tolua.setpeer(self.propertyItem1.number, nil)
	end
	if tolua.getpeer(self.propertyItem1.prName) ~= nil then
		tolua.setpeer(self.propertyItem1.prName, nil)
	end
	if tolua.getpeer(self.propertyItem1) ~= nil then
		tolua.setpeer(self.propertyItem1, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return WashAttrItemView