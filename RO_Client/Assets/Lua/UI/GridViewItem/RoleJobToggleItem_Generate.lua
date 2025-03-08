---@class RoleJobToggleItem__Generate_jobName
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class RoleJobToggleItem__Generate_jobIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RoleJobToggleItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private toggle UnityEngine.UI.Toggle
---@field private jobIcon RoleJobToggleItem__Generate_jobIcon
---@field private jobName RoleJobToggleItem__Generate_jobName
local RoleJobToggleItemView = class("RoleJobToggleItemView")

function RoleJobToggleItemView:ctor()
end

---@private
function RoleJobToggleItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RoleJobToggleItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function RoleJobToggleItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.toggle = Root:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function RoleJobToggleItemView:InitGenerate__2(Root, data)
--[[
	JobIcon
--]]
	local tmp = Root:Find("JobIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.jobIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RoleJobToggleItemView:InitGenerate__3(Root, data)
--[[
	JobName
--]]
	local tmp = Root:Find("JobName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.jobName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function RoleJobToggleItemView:GenerateDestroy()
	if tolua.getpeer(self.jobName) ~= nil then
		tolua.setpeer(self.jobName, nil)
	end
	if tolua.getpeer(self.jobIcon) ~= nil then
		tolua.setpeer(self.jobIcon, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RoleJobToggleItemView