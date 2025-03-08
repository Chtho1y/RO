---@class PetCollect__Generate_nature
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class PetCollect__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class PetCollect__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public uIEventTriggerListener UIEventTriggerListener

---@class PetCollect__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class PetCollect__Generate_shadow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class PetCollect__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private shadow PetCollect__Generate_shadow
---@field private bg PetCollect__Generate_bg
---@field private icon PetCollect__Generate_icon
---@field private frame PetCollect__Generate_frame
---@field private nature PetCollect__Generate_nature
---@field private uIRedPointRP UnityEngine.GameObject
---@field private mask UnityEngine.GameObject
local PetCollectView = class("PetCollectView")

function PetCollectView:ctor()
end

---@private
function PetCollectView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function PetCollectView:InitGenerate(Root, data)
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
function PetCollectView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function PetCollectView:InitGenerate__2(Root, data)
--[[
	shadow
--]]
	local tmp = Root:Find("shadow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.shadow = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function PetCollectView:InitGenerate__3(Root, data)
--[[
	bg
--]]
	local tmp = Root:Find("bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function PetCollectView:InitGenerate__4(Root, data)
--[[
	Icon
--]]
	local tmp = Root:Find("Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
end

---@private
function PetCollectView:InitGenerate__5(Root, data)
--[[
	Frame
--]]
	local tmp = Root:Find("Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frame = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function PetCollectView:InitGenerate__6(Root, data)
--[[
	Nature
--]]
	local tmp = Root:Find("Nature").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nature = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function PetCollectView:InitGenerate__7(Root, data)
--[[
	UIRedPointRP
--]]
	local tmp = Root:Find("UIRedPointRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIRedPointRP = tmp
end

---@private
function PetCollectView:InitGenerate__8(Root, data)
--[[
	Mask
--]]
	local tmp = Root:Find("Mask").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mask = tmp
end

---@private
function PetCollectView:GenerateDestroy()
	if tolua.getpeer(self.shadow) ~= nil then
		tolua.setpeer(self.shadow, nil)
	end
	self.shadow = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	self.frame = nil
	if tolua.getpeer(self.nature) ~= nil then
		tolua.setpeer(self.nature, nil)
	end
	self.nature = nil
	if tolua.getpeer(self.uIRedPointRP) ~= nil then
		tolua.setpeer(self.uIRedPointRP, nil)
	end
	self.uIRedPointRP = nil
	if tolua.getpeer(self.mask) ~= nil then
		tolua.setpeer(self.mask, nil)
	end
	self.mask = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return PetCollectView