---@class UINewCreateRole__Generate_backBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UINewCreateRole__Generate_confirmBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UINewCreateRole__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private btnBox UnityEngine.GameObject
---@field private shadow UnityEngine.GameObject
---@field private grass UnityEngine.GameObject
---@field private confirmBtn UINewCreateRole__Generate_confirmBtn
---@field private backBtn UINewCreateRole__Generate_backBtn
---@field private notice UnityEngine.GameObject
local UINewCreateRoleView = class("UINewCreateRoleView", require("UIViewBase"))

function UINewCreateRoleView:ctor()
end

---@private
function UINewCreateRoleView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UINewCreateRoleView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)
	self:InitGenerate__6(Root,data)


end

---@private
function UINewCreateRoleView:InitGenerate__1(Root, data)
--[[
	Window/BtnBox
--]]
	local tmp = Root:Find("Window/BtnBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBox = tmp
end

---@private
function UINewCreateRoleView:InitGenerate__2(Root, data)
--[[
	Window/BtnBox/shadow
--]]
	local tmp = Root:Find("Window/BtnBox/shadow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.shadow = tmp
end

---@private
function UINewCreateRoleView:InitGenerate__3(Root, data)
--[[
	Window/BtnBox/Grass
--]]
	local tmp = Root:Find("Window/BtnBox/Grass").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.grass = tmp
end

---@private
function UINewCreateRoleView:InitGenerate__4(Root, data)
--[[
	Window/BtnBox/BtnLetsGo
--]]
	local tmp = Root:Find("Window/BtnBox/BtnLetsGo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.confirmBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UINewCreateRoleView:InitGenerate__5(Root, data)
--[[
	Window/BtnBox/BtnBack
--]]
	local tmp = Root:Find("Window/BtnBox/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.backBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UINewCreateRoleView:InitGenerate__6(Root, data)
--[[
	Window/NoticeBox
--]]
	local tmp = Root:Find("Window/NoticeBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.notice = tmp
end

---@private
function UINewCreateRoleView:GenerateDestroy()
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.shadow) ~= nil then
		tolua.setpeer(self.shadow, nil)
	end
	self.shadow = nil
	if tolua.getpeer(self.grass) ~= nil then
		tolua.setpeer(self.grass, nil)
	end
	self.grass = nil
	if tolua.getpeer(self.confirmBtn) ~= nil then
		tolua.setpeer(self.confirmBtn, nil)
	end
	self.confirmBtn = nil
	if tolua.getpeer(self.backBtn) ~= nil then
		tolua.setpeer(self.backBtn, nil)
	end
	self.backBtn = nil
	if tolua.getpeer(self.notice) ~= nil then
		tolua.setpeer(self.notice, nil)
	end
	self.notice = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UINewCreateRoleView