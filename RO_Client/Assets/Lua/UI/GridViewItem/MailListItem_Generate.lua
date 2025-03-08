---@class MailListItem__Generate_timer
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class MailListItem__Generate_mailTtle
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class MailListItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private litter UnityEngine.GameObject
---@field private item UnityEngine.GameObject
---@field private litterOpen UnityEngine.GameObject
---@field private itemOpen UnityEngine.GameObject
---@field private mailTtle MailListItem__Generate_mailTtle
---@field private timer MailListItem__Generate_timer
---@field private readMark UnityEngine.GameObject
---@field private redPointNewItem UnityEngine.GameObject
local MailListItemView = class("MailListItemView")

function MailListItemView:ctor()
end

---@private
function MailListItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function MailListItemView:InitGenerate(Root, data)
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
function MailListItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function MailListItemView:InitGenerate__2(Root, data)
--[[
	Icon/Litter
--]]
	local tmp = Root:Find("Icon/Litter").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.litter = tmp
end

---@private
function MailListItemView:InitGenerate__3(Root, data)
--[[
	Icon/Item
--]]
	local tmp = Root:Find("Icon/Item").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item = tmp
end

---@private
function MailListItemView:InitGenerate__4(Root, data)
--[[
	Icon/LitterOpen
--]]
	local tmp = Root:Find("Icon/LitterOpen").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.litterOpen = tmp
end

---@private
function MailListItemView:InitGenerate__5(Root, data)
--[[
	Icon/ItemOpen
--]]
	local tmp = Root:Find("Icon/ItemOpen").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemOpen = tmp
end

---@private
function MailListItemView:InitGenerate__6(Root, data)
--[[
	MailTtle
--]]
	local tmp = Root:Find("MailTtle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mailTtle = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function MailListItemView:InitGenerate__7(Root, data)
--[[
	Timer
--]]
	local tmp = Root:Find("Timer").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timer = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function MailListItemView:InitGenerate__8(Root, data)
--[[
	ReadMark
--]]
	local tmp = Root:Find("ReadMark").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.readMark = tmp
end

---@private
function MailListItemView:InitGenerate__9(Root, data)
--[[
	UINewRP
--]]
	local tmp = Root:Find("UINewRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redPointNewItem = tmp
end

---@private
function MailListItemView:GenerateDestroy()
	if tolua.getpeer(self.litter) ~= nil then
		tolua.setpeer(self.litter, nil)
	end
	self.litter = nil
	if tolua.getpeer(self.item) ~= nil then
		tolua.setpeer(self.item, nil)
	end
	self.item = nil
	if tolua.getpeer(self.litterOpen) ~= nil then
		tolua.setpeer(self.litterOpen, nil)
	end
	self.litterOpen = nil
	if tolua.getpeer(self.itemOpen) ~= nil then
		tolua.setpeer(self.itemOpen, nil)
	end
	self.itemOpen = nil
	if tolua.getpeer(self.mailTtle) ~= nil then
		tolua.setpeer(self.mailTtle, nil)
	end
	self.mailTtle = nil
	if tolua.getpeer(self.timer) ~= nil then
		tolua.setpeer(self.timer, nil)
	end
	self.timer = nil
	if tolua.getpeer(self.readMark) ~= nil then
		tolua.setpeer(self.readMark, nil)
	end
	self.readMark = nil
	if tolua.getpeer(self.redPointNewItem) ~= nil then
		tolua.setpeer(self.redPointNewItem, nil)
	end
	self.redPointNewItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return MailListItemView