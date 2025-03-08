---@class UIFightPowerTips__Generate_addNum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIFightPowerTips__Generate_deltaNum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIFightPowerTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private deltaNum UIFightPowerTips__Generate_deltaNum
---@field private addNum UIFightPowerTips__Generate_addNum
local UIFightPowerTipsView = class("UIFightPowerTipsView", require("UIViewBase"))

function UIFightPowerTipsView:ctor()
end

---@private
function UIFightPowerTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIFightPowerTipsView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function UIFightPowerTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIFightPowerTipsView:InitGenerate__2(Root, data)
--[[
	FightPowerAnim/deltaNum
--]]
	local tmp = Root:Find("FightPowerAnim/deltaNum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.deltaNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIFightPowerTipsView:InitGenerate__3(Root, data)
--[[
	FightPowerAnim/AddBox/addNum
--]]
	local tmp = Root:Find("FightPowerAnim/AddBox/addNum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIFightPowerTipsView:GenerateDestroy()
	if tolua.getpeer(self.deltaNum) ~= nil then
		tolua.setpeer(self.deltaNum, nil)
	end
	self.deltaNum = nil
	if tolua.getpeer(self.addNum) ~= nil then
		tolua.setpeer(self.addNum, nil)
	end
	self.addNum = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIFightPowerTipsView