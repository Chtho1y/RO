---@class GuildPeopleApplyItem__Generate_allowBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class GuildPeopleApplyItem__Generate_refuseBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class GuildPeopleApplyItem__Generate_onlineTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildPeopleApplyItem__Generate_atkTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildPeopleApplyItem__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildPeopleApplyItem__Generate_vipIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class GuildPeopleApplyItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class GuildPeopleApplyItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private headItem GuildPeopleApplyItem__Generate_headItem
---@field private vipIcon GuildPeopleApplyItem__Generate_vipIcon
---@field private nameTxt GuildPeopleApplyItem__Generate_nameTxt
---@field private atkTxt GuildPeopleApplyItem__Generate_atkTxt
---@field private onlineTxt GuildPeopleApplyItem__Generate_onlineTxt
---@field private refuseBtn GuildPeopleApplyItem__Generate_refuseBtn
---@field private allowBtn GuildPeopleApplyItem__Generate_allowBtn
local GuildPeopleApplyItemView = class("GuildPeopleApplyItemView")

function GuildPeopleApplyItemView:ctor()
end

---@private
function GuildPeopleApplyItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function GuildPeopleApplyItemView:InitGenerate(Root, data)
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
function GuildPeopleApplyItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function GuildPeopleApplyItemView:InitGenerate__2(Root, data)
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
function GuildPeopleApplyItemView:InitGenerate__3(Root, data)
--[[
	Name/VipIcon
--]]
	local tmp = Root:Find("Name/VipIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function GuildPeopleApplyItemView:InitGenerate__4(Root, data)
--[[
	Name/NameTxt
--]]
	local tmp = Root:Find("Name/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function GuildPeopleApplyItemView:InitGenerate__5(Root, data)
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
function GuildPeopleApplyItemView:InitGenerate__6(Root, data)
--[[
	Online/OnlineTxt
--]]
	local tmp = Root:Find("Online/OnlineTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.onlineTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function GuildPeopleApplyItemView:InitGenerate__7(Root, data)
--[[
	Btns/RefuseBtn
--]]
	local tmp = Root:Find("Btns/RefuseBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refuseBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function GuildPeopleApplyItemView:InitGenerate__8(Root, data)
--[[
	Btns/AllowBtn
--]]
	local tmp = Root:Find("Btns/AllowBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.allowBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function GuildPeopleApplyItemView:GenerateDestroy()
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	self.headItem = nil
	if tolua.getpeer(self.vipIcon) ~= nil then
		tolua.setpeer(self.vipIcon, nil)
	end
	self.vipIcon = nil
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	if tolua.getpeer(self.atkTxt) ~= nil then
		tolua.setpeer(self.atkTxt, nil)
	end
	self.atkTxt = nil
	if tolua.getpeer(self.onlineTxt) ~= nil then
		tolua.setpeer(self.onlineTxt, nil)
	end
	self.onlineTxt = nil
	if tolua.getpeer(self.refuseBtn) ~= nil then
		tolua.setpeer(self.refuseBtn, nil)
	end
	self.refuseBtn = nil
	if tolua.getpeer(self.allowBtn) ~= nil then
		tolua.setpeer(self.allowBtn, nil)
	end
	self.allowBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return GuildPeopleApplyItemView