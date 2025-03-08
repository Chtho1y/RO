---@class RewardBox__Generate_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class RewardBox__Generate_box
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public animator UnityEngine.Animator

---@class RewardBox__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private box RewardBox__Generate_box
---@field private money UnityEngine.GameObject
---@field private fXParent UnityEngine.GameObject
---@field private tipPoint UnityEngine.GameObject
---@field private num RewardBox__Generate_num
local RewardBoxView = class("RewardBoxView")

function RewardBoxView:ctor()
end

---@private
function RewardBoxView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RewardBoxView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)
	self:InitGenerate__6(Root,data)


end

---@private
function RewardBoxView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function RewardBoxView:InitGenerate__2(Root, data)
--[[
	Box
--]]
	local tmp = Root:Find("Box").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.box = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function RewardBoxView:InitGenerate__3(Root, data)
--[[
	Money
--]]
	local tmp = Root:Find("Money").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.money = tmp
end

---@private
function RewardBoxView:InitGenerate__4(Root, data)
--[[
	FXParent
--]]
	local tmp = Root:Find("FXParent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fXParent = tmp
end

---@private
function RewardBoxView:InitGenerate__5(Root, data)
--[[
	TipPoint
--]]
	local tmp = Root:Find("TipPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tipPoint = tmp
end

---@private
function RewardBoxView:InitGenerate__6(Root, data)
--[[
	Num
--]]
	local tmp = Root:Find("Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function RewardBoxView:GenerateDestroy()
	if tolua.getpeer(self.num) ~= nil then
		tolua.setpeer(self.num, nil)
	end
	if tolua.getpeer(self.tipPoint) ~= nil then
		tolua.setpeer(self.tipPoint, nil)
	end
	if tolua.getpeer(self.fXParent) ~= nil then
		tolua.setpeer(self.fXParent, nil)
	end
	if tolua.getpeer(self.money) ~= nil then
		tolua.setpeer(self.money, nil)
	end
	if tolua.getpeer(self.box) ~= nil then
		tolua.setpeer(self.box, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RewardBoxView