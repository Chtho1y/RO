---@class GuildPeopleItem__Generate_activeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildPeopleItem__Generate_active
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public button UnityEngine.UI.Button

---@class GuildPeopleItem__Generate_onlineTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildPeopleItem__Generate_atkTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildPeopleItem__Generate_vipIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class GuildPeopleItem__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildPeopleItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class GuildPeopleItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private button UnityEngine.UI.Button
---@field private headItem GuildPeopleItem__Generate_headItem
---@field private select UnityEngine.GameObject
---@field private nameTxt GuildPeopleItem__Generate_nameTxt
---@field private vipIcon GuildPeopleItem__Generate_vipIcon
---@field private atkTxt GuildPeopleItem__Generate_atkTxt
---@field private onlineTxt GuildPeopleItem__Generate_onlineTxt
---@field private presidentTag UnityEngine.GameObject
---@field private vicePresidentTag UnityEngine.GameObject
---@field private active GuildPeopleItem__Generate_active
---@field private activeTxt GuildPeopleItem__Generate_activeTxt
local GuildPeopleItemView = class("GuildPeopleItemView")

function GuildPeopleItemView:ctor()
end

---@private
function GuildPeopleItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function GuildPeopleItemView:InitGenerate(Root, data)
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
	self:InitGenerate__10(Root,data)
	self:InitGenerate__11(Root,data)


end

---@private
function GuildPeopleItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function GuildPeopleItemView:InitGenerate__2(Root, data)
--[[
	HeadItem
--]]
	local tmp = Root:Find("HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function GuildPeopleItemView:InitGenerate__3(Root, data)
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
function GuildPeopleItemView:InitGenerate__4(Root, data)
--[[
	NameTxt
--]]
	local tmp = Root:Find("NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function GuildPeopleItemView:InitGenerate__5(Root, data)
--[[
	VipIcon
--]]
	local tmp = Root:Find("VipIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function GuildPeopleItemView:InitGenerate__6(Root, data)
--[[
	Atk/AtkTxt
--]]
	local tmp = Root:Find("Atk/AtkTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.atkTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function GuildPeopleItemView:InitGenerate__7(Root, data)
--[[
	Image/OnlineTxt
--]]
	local tmp = Root:Find("Image/OnlineTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.onlineTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function GuildPeopleItemView:InitGenerate__8(Root, data)
--[[
	PresidentTag
--]]
	local tmp = Root:Find("PresidentTag").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.presidentTag = tmp
end

---@private
function GuildPeopleItemView:InitGenerate__9(Root, data)
--[[
	VicePresidentTag
--]]
	local tmp = Root:Find("VicePresidentTag").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vicePresidentTag = tmp
end

---@private
function GuildPeopleItemView:InitGenerate__10(Root, data)
--[[
	Active
--]]
	local tmp = Root:Find("Active").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.active = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function GuildPeopleItemView:InitGenerate__11(Root, data)
--[[
	Active/ActiveTxt
--]]
	local tmp = Root:Find("Active/ActiveTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.activeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function GuildPeopleItemView:GenerateDestroy()
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	self.headItem = nil
	if tolua.getpeer(self.select) ~= nil then
		tolua.setpeer(self.select, nil)
	end
	self.select = nil
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	if tolua.getpeer(self.vipIcon) ~= nil then
		tolua.setpeer(self.vipIcon, nil)
	end
	self.vipIcon = nil
	if tolua.getpeer(self.atkTxt) ~= nil then
		tolua.setpeer(self.atkTxt, nil)
	end
	self.atkTxt = nil
	if tolua.getpeer(self.onlineTxt) ~= nil then
		tolua.setpeer(self.onlineTxt, nil)
	end
	self.onlineTxt = nil
	if tolua.getpeer(self.presidentTag) ~= nil then
		tolua.setpeer(self.presidentTag, nil)
	end
	self.presidentTag = nil
	if tolua.getpeer(self.vicePresidentTag) ~= nil then
		tolua.setpeer(self.vicePresidentTag, nil)
	end
	self.vicePresidentTag = nil
	if tolua.getpeer(self.active) ~= nil then
		tolua.setpeer(self.active, nil)
	end
	self.active = nil
	if tolua.getpeer(self.activeTxt) ~= nil then
		tolua.setpeer(self.activeTxt, nil)
	end
	self.activeTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return GuildPeopleItemView