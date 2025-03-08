---@class JobCondItem__Generate_cond
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class JobCondItem__Generate_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class JobCondItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private num JobCondItem__Generate_num
---@field private completed UnityEngine.GameObject
---@field private cond JobCondItem__Generate_cond
local JobCondItemView = class("JobCondItemView")

function JobCondItemView:ctor()
end

---@private
function JobCondItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function JobCondItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function JobCondItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function JobCondItemView:InitGenerate__2(Root, data)
--[[
	num
--]]
	local tmp = Root:Find("num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function JobCondItemView:InitGenerate__3(Root, data)
--[[
	completed
--]]
	local tmp = Root:Find("completed").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.completed = tmp
end

---@private
function JobCondItemView:InitGenerate__4(Root, data)
--[[
	cond
--]]
	local tmp = Root:Find("cond").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cond = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function JobCondItemView:GenerateDestroy()
	if tolua.getpeer(self.num) ~= nil then
		tolua.setpeer(self.num, nil)
	end
	self.num = nil
	if tolua.getpeer(self.completed) ~= nil then
		tolua.setpeer(self.completed, nil)
	end
	self.completed = nil
	if tolua.getpeer(self.cond) ~= nil then
		tolua.setpeer(self.cond, nil)
	end
	self.cond = nil
	self.inited = false
end
return JobCondItemView