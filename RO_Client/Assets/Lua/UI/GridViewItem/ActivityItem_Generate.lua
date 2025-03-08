---@class ActivityItem__Generate_redPoint
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ActivityItem__Generate_leftMins
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ActivityItem__Generate_leftHours
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ActivityItem__Generate_leftDay
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ActivityItem__Generate_bannerImg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class ActivityItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bannerImg ActivityItem__Generate_bannerImg
---@field private limitedLblNode UnityEngine.GameObject
---@field private limitedNode UnityEngine.GameObject
---@field private leftDay ActivityItem__Generate_leftDay
---@field private leftHours ActivityItem__Generate_leftHours
---@field private leftMins ActivityItem__Generate_leftMins
---@field private redPoint ActivityItem__Generate_redPoint
local ActivityItemView = class("ActivityItemView")

function ActivityItemView:ctor()
end

---@private
function ActivityItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ActivityItemView:InitGenerate(Root, data)
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


end

---@private
function ActivityItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function ActivityItemView:InitGenerate__2(Root, data)
--[[
	Image
--]]
	local tmp = Root:Find("Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bannerImg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ActivityItemView:InitGenerate__3(Root, data)
--[[
	LabelLimited
--]]
	local tmp = Root:Find("LabelLimited").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.limitedLblNode = tmp
end

---@private
function ActivityItemView:InitGenerate__4(Root, data)
--[[
	LabelTimes
--]]
	local tmp = Root:Find("LabelTimes").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.limitedNode = tmp
end

---@private
function ActivityItemView:InitGenerate__5(Root, data)
--[[
	LabelTimes/NumDAYS
--]]
	local tmp = Root:Find("LabelTimes/NumDAYS").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftDay = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ActivityItemView:InitGenerate__6(Root, data)
--[[
	LabelTimes/NumHRS
--]]
	local tmp = Root:Find("LabelTimes/NumHRS").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftHours = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ActivityItemView:InitGenerate__7(Root, data)
--[[
	LabelTimes/NumMINS
--]]
	local tmp = Root:Find("LabelTimes/NumMINS").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftMins = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ActivityItemView:InitGenerate__8(Root, data)
--[[
	RedPoint
--]]
	local tmp = Root:Find("RedPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redPoint = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ActivityItemView:GenerateDestroy()
	if tolua.getpeer(self.bannerImg) ~= nil then
		tolua.setpeer(self.bannerImg, nil)
	end
	self.bannerImg = nil
	if tolua.getpeer(self.limitedLblNode) ~= nil then
		tolua.setpeer(self.limitedLblNode, nil)
	end
	self.limitedLblNode = nil
	if tolua.getpeer(self.limitedNode) ~= nil then
		tolua.setpeer(self.limitedNode, nil)
	end
	self.limitedNode = nil
	if tolua.getpeer(self.leftDay) ~= nil then
		tolua.setpeer(self.leftDay, nil)
	end
	self.leftDay = nil
	if tolua.getpeer(self.leftHours) ~= nil then
		tolua.setpeer(self.leftHours, nil)
	end
	self.leftHours = nil
	if tolua.getpeer(self.leftMins) ~= nil then
		tolua.setpeer(self.leftMins, nil)
	end
	self.leftMins = nil
	if tolua.getpeer(self.redPoint) ~= nil then
		tolua.setpeer(self.redPoint, nil)
	end
	self.redPoint = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return ActivityItemView