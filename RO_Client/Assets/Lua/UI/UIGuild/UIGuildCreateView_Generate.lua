---@class UIGuildCreate__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildCreate__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildCreate__Generate_createBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildCreate__Generate_input
---@field public gameObject UnityEngine.GameObject
---@field public inputField UnityEngine.UI.InputField

---@class UIGuildCreate__Generate_changeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildCreate__Generate_guildBadgeItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIGuildCreate__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildCreate__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildCreate__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIGuildCreate__Generate_AnyBtn
---@field private btnClose UIGuildCreate__Generate_btnClose
---@field private guildBadgeItem UIGuildCreate__Generate_guildBadgeItem
---@field private changeBtn UIGuildCreate__Generate_changeBtn
---@field private input UIGuildCreate__Generate_input
---@field private createBtn UIGuildCreate__Generate_createBtn
---@field private icon UIGuildCreate__Generate_icon
---@field private desTxt UIGuildCreate__Generate_desTxt
local UIGuildCreateView = class("UIGuildCreateView", require("UIViewBase"))

function UIGuildCreateView:ctor()
end

---@private
function UIGuildCreateView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildCreateView:InitGenerate(Root, data)
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
	self:InitGenerate__7(Root,data)
	self:InitGenerate__8(Root,data)


end

---@private
function UIGuildCreateView:InitGenerate__1(Root, data)
--[[
	UIAnimator/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildCreateView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildCreateView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/ChangeList/GuildBadgeItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/GuildBadgeItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildBadgeItem = CommonUtil.BindGridViewItem2LuaStatic("GuildBadgeItem", tmp)
	self.guildBadgeItem.prefabName = "GuildBadgeItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIGuildCreateView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/ChangeList/ChangeBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/ChangeBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.changeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildCreateView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ChangeList/Input
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList/Input").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.input = tmp

	tmp.inputField = tmp:GetComponent(Enum.TypeInfo.InputField)
end

---@private
function UIGuildCreateView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bottom/CreateBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/CreateBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.createBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildCreateView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bottom/CreateBtn/Content/Consume/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/CreateBtn/Content/Consume/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildCreateView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bottom/CreateBtn/Content/Consume/DesTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/CreateBtn/Content/Consume/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildCreateView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if self.guildBadgeItem.GenerateDestroy ~= nil then
		self.guildBadgeItem:GenerateDestroy()
	end
	if tolua.getpeer(self.guildBadgeItem) ~= nil then
		tolua.setpeer(self.guildBadgeItem, nil)
	end
	self.guildBadgeItem = nil
	if tolua.getpeer(self.changeBtn) ~= nil then
		tolua.setpeer(self.changeBtn, nil)
	end
	self.changeBtn = nil
	if tolua.getpeer(self.input) ~= nil then
		tolua.setpeer(self.input, nil)
	end
	self.input = nil
	if tolua.getpeer(self.createBtn) ~= nil then
		tolua.setpeer(self.createBtn, nil)
	end
	self.createBtn = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildCreateView