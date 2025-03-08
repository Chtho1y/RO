---@class NotifyItem__Generate_btnDown
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class NotifyItem__Generate_btnRight
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class NotifyItem__Generate_textMain
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class NotifyItem__Generate_textDate
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class NotifyItem__Generate_textNotifyTitle
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public button UnityEngine.UI.Button

---@class NotifyItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private textNotifyTitle NotifyItem__Generate_textNotifyTitle
---@field private textDate NotifyItem__Generate_textDate
---@field private content UnityEngine.GameObject
---@field private textMain NotifyItem__Generate_textMain
---@field private btnRight NotifyItem__Generate_btnRight
---@field private btnDown NotifyItem__Generate_btnDown
local NotifyItemView = class("NotifyItemView")

function NotifyItemView:ctor()
end

---@private
function NotifyItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function NotifyItemView:InitGenerate(Root, data)
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


end

---@private
function NotifyItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function NotifyItemView:InitGenerate__2(Root, data)
--[[
	TextNotifyTitle
--]]
	local tmp = Root:Find("TextNotifyTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textNotifyTitle = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function NotifyItemView:InitGenerate__3(Root, data)
--[[
	TextDate
--]]
	local tmp = Root:Find("TextDate").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textDate = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function NotifyItemView:InitGenerate__4(Root, data)
--[[
	Content
--]]
	local tmp = Root:Find("Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp
end

---@private
function NotifyItemView:InitGenerate__5(Root, data)
--[[
	Content/TextMain
--]]
	local tmp = Root:Find("Content/TextMain").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textMain = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function NotifyItemView:InitGenerate__6(Root, data)
--[[
	BtnRight
--]]
	local tmp = Root:Find("BtnRight").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRight = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function NotifyItemView:InitGenerate__7(Root, data)
--[[
	BtnDown
--]]
	local tmp = Root:Find("BtnDown").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnDown = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function NotifyItemView:GenerateDestroy()
	if tolua.getpeer(self.textNotifyTitle) ~= nil then
		tolua.setpeer(self.textNotifyTitle, nil)
	end
	self.textNotifyTitle = nil
	if tolua.getpeer(self.textDate) ~= nil then
		tolua.setpeer(self.textDate, nil)
	end
	self.textDate = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	if tolua.getpeer(self.textMain) ~= nil then
		tolua.setpeer(self.textMain, nil)
	end
	self.textMain = nil
	if tolua.getpeer(self.btnRight) ~= nil then
		tolua.setpeer(self.btnRight, nil)
	end
	self.btnRight = nil
	if tolua.getpeer(self.btnDown) ~= nil then
		tolua.setpeer(self.btnDown, nil)
	end
	self.btnDown = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return NotifyItemView