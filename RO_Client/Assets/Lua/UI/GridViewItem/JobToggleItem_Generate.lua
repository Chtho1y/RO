---@class JobToggleItem__Generate_label
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class JobToggleItem__Generate_jobIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class JobToggleItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private toggle UnityEngine.UI.Toggle
---@field private jobIcon JobToggleItem__Generate_jobIcon
---@field private label JobToggleItem__Generate_label
local JobToggleItemView = class("JobToggleItemView")

function JobToggleItemView:ctor()
end

---@private
function JobToggleItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function JobToggleItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function JobToggleItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.toggle = Root:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function JobToggleItemView:InitGenerate__2(Root, data)
--[[
	Background/JobIcon
--]]
	local tmp = Root:Find("Background/JobIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.jobIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function JobToggleItemView:InitGenerate__3(Root, data)
--[[
	Background/Label
--]]
	local tmp = Root:Find("Background/Label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.label = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function JobToggleItemView:GenerateDestroy()
	if tolua.getpeer(self.jobIcon) ~= nil then
		tolua.setpeer(self.jobIcon, nil)
	end
	self.jobIcon = nil
	if tolua.getpeer(self.label) ~= nil then
		tolua.setpeer(self.label, nil)
	end
	self.label = nil
	self.inited = false
end
return JobToggleItemView