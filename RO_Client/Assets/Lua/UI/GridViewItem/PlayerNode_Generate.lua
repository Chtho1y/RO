---@class PlayerNode__Generate_btnSupport
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class PlayerNode__Generate_nametext
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class PlayerNode__Generate_hotVal
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class PlayerNode__Generate_roleModel
---@field public gameObject UnityEngine.GameObject
---@field public rawImage UnityEngine.UI.RawImage
---@field public uIEventTriggerListener UIEventTriggerListener

---@class PlayerNode__Generate_pos
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image

---@class PlayerNode__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private pos PlayerNode__Generate_pos
---@field private roleModel PlayerNode__Generate_roleModel
---@field private hotVal PlayerNode__Generate_hotVal
---@field private nametext PlayerNode__Generate_nametext
---@field private btnSupport PlayerNode__Generate_btnSupport
local PlayerNodeView = class("PlayerNodeView")

function PlayerNodeView:ctor()
end

---@private
function PlayerNodeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function PlayerNodeView:InitGenerate(Root, data)
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
function PlayerNodeView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function PlayerNodeView:InitGenerate__2(Root, data)
--[[
	Pos
--]]
	local tmp = Root:Find("Pos").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pos = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function PlayerNodeView:InitGenerate__3(Root, data)
--[[
	RoleModel
--]]
	local tmp = Root:Find("RoleModel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.roleModel = tmp

	tmp.rawImage = tmp:GetComponent(Enum.TypeInfo.RawImage)

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
end

---@private
function PlayerNodeView:InitGenerate__4(Root, data)
--[[
	Info/hot/HotVal
--]]
	local tmp = Root:Find("Info/hot/HotVal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hotVal = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function PlayerNodeView:InitGenerate__5(Root, data)
--[[
	Info/nametext
--]]
	local tmp = Root:Find("Info/nametext").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nametext = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function PlayerNodeView:InitGenerate__6(Root, data)
--[[
	Info/BtnSupport
--]]
	local tmp = Root:Find("Info/BtnSupport").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSupport = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function PlayerNodeView:GenerateDestroy()
	if tolua.getpeer(self.btnSupport) ~= nil then
		tolua.setpeer(self.btnSupport, nil)
	end
	if tolua.getpeer(self.nametext) ~= nil then
		tolua.setpeer(self.nametext, nil)
	end
	if tolua.getpeer(self.hotVal) ~= nil then
		tolua.setpeer(self.hotVal, nil)
	end
	if tolua.getpeer(self.roleModel) ~= nil then
		tolua.setpeer(self.roleModel, nil)
	end
	if tolua.getpeer(self.pos) ~= nil then
		tolua.setpeer(self.pos, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return PlayerNodeView