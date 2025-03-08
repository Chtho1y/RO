---@class FashionItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class FashionItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class FashionItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class FashionItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bg FashionItem__Generate_bg
---@field private icon FashionItem__Generate_icon
---@field private frame FashionItem__Generate_frame
---@field private select UnityEngine.GameObject
local FashionItemView = class("FashionItemView")

function FashionItemView:ctor()
end

---@private
function FashionItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function FashionItemView:InitGenerate(Root, data)
	self.transform = Root

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)


end

---@private
function FashionItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function FashionItemView:InitGenerate__2(Root, data)
--[[
	Bg
--]]
	local tmp = Root:Find("Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function FashionItemView:InitGenerate__3(Root, data)
--[[
	Icon
--]]
	local tmp = Root:Find("Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function FashionItemView:InitGenerate__4(Root, data)
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
function FashionItemView:InitGenerate__5(Root, data)
--[[
	Select
--]]
	local tmp = Root:Find("Select").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.select = tmp
end

---@private
function FashionItemView:GenerateDestroy()
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
	if tolua.getpeer(self.select) ~= nil then
		tolua.setpeer(self.select, nil)
	end
	self.select = nil
end
return FashionItemView