---@class RoleListItem__Generate_plusFrame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RoleListItem__Generate_numLv
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class RoleListItem__Generate_job
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RoleListItem__Generate_head
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class RoleListItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image

---@class RoleListItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private frame RoleListItem__Generate_frame
---@field private head RoleListItem__Generate_head
---@field private job RoleListItem__Generate_job
---@field private numLv RoleListItem__Generate_numLv
---@field private labelUp UnityEngine.GameObject
---@field private labelLead UnityEngine.GameObject
---@field private plus UnityEngine.GameObject
---@field private plusFrame RoleListItem__Generate_plusFrame
local RoleListItemView = class("RoleListItemView")

function RoleListItemView:ctor()
end

---@private
function RoleListItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RoleListItemView:InitGenerate(Root, data)
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


end

---@private
function RoleListItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function RoleListItemView:InitGenerate__2(Root, data)
--[[
	Frame
--]]
	local tmp = Root:Find("Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frame = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RoleListItemView:InitGenerate__3(Root, data)
--[[
	Head
--]]
	local tmp = Root:Find("Head").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.head = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function RoleListItemView:InitGenerate__4(Root, data)
--[[
	Job
--]]
	local tmp = Root:Find("Job").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.job = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RoleListItemView:InitGenerate__5(Root, data)
--[[
	NumLv
--]]
	local tmp = Root:Find("NumLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.numLv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function RoleListItemView:InitGenerate__6(Root, data)
--[[
	LabelUp
--]]
	local tmp = Root:Find("LabelUp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelUp = tmp
end

---@private
function RoleListItemView:InitGenerate__7(Root, data)
--[[
	LabelLead
--]]
	local tmp = Root:Find("LabelLead").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelLead = tmp
end

---@private
function RoleListItemView:InitGenerate__8(Root, data)
--[[
	Plus
--]]
	local tmp = Root:Find("Plus").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.plus = tmp
end

---@private
function RoleListItemView:InitGenerate__9(Root, data)
--[[
	Plus/PlusFrame
--]]
	local tmp = Root:Find("Plus/PlusFrame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.plusFrame = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RoleListItemView:GenerateDestroy()
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	self.frame = nil
	if tolua.getpeer(self.head) ~= nil then
		tolua.setpeer(self.head, nil)
	end
	self.head = nil
	if tolua.getpeer(self.job) ~= nil then
		tolua.setpeer(self.job, nil)
	end
	self.job = nil
	if tolua.getpeer(self.numLv) ~= nil then
		tolua.setpeer(self.numLv, nil)
	end
	self.numLv = nil
	if tolua.getpeer(self.labelUp) ~= nil then
		tolua.setpeer(self.labelUp, nil)
	end
	self.labelUp = nil
	if tolua.getpeer(self.labelLead) ~= nil then
		tolua.setpeer(self.labelLead, nil)
	end
	self.labelLead = nil
	if tolua.getpeer(self.plus) ~= nil then
		tolua.setpeer(self.plus, nil)
	end
	self.plus = nil
	if tolua.getpeer(self.plusFrame) ~= nil then
		tolua.setpeer(self.plusFrame, nil)
	end
	self.plusFrame = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RoleListItemView