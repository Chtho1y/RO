---@class GuildRecommendItem__Generate_activeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildRecommendItem__Generate_peopleTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildRecommendItem__Generate_lvTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildRecommendItem__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildRecommendItem__Generate_guildBadgeItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class GuildRecommendItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private guildBadgeItem GuildRecommendItem__Generate_guildBadgeItem
---@field private nameTxt GuildRecommendItem__Generate_nameTxt
---@field private lvTxt GuildRecommendItem__Generate_lvTxt
---@field private peopleTxt GuildRecommendItem__Generate_peopleTxt
---@field private appliedTag UnityEngine.GameObject
---@field private activeTxt GuildRecommendItem__Generate_activeTxt
local GuildRecommendItemView = class("GuildRecommendItemView")

function GuildRecommendItemView:ctor()
end

---@private
function GuildRecommendItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function GuildRecommendItemView:InitGenerate(Root, data)
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
function GuildRecommendItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function GuildRecommendItemView:InitGenerate__2(Root, data)
--[[
	GuildBadgeItem
--]]
	local tmp = Root:Find("GuildBadgeItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildBadgeItem = CommonUtil.BindGridViewItem2LuaStatic("GuildBadgeItem", tmp)
	self.guildBadgeItem.prefabName = "GuildBadgeItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function GuildRecommendItemView:InitGenerate__3(Root, data)
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
function GuildRecommendItemView:InitGenerate__4(Root, data)
--[[
	Lv/LvTxt
--]]
	local tmp = Root:Find("Lv/LvTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lvTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function GuildRecommendItemView:InitGenerate__5(Root, data)
--[[
	Member/PeopleTxt
--]]
	local tmp = Root:Find("Member/PeopleTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.peopleTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function GuildRecommendItemView:InitGenerate__6(Root, data)
--[[
	AppliedTag
--]]
	local tmp = Root:Find("AppliedTag").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.appliedTag = tmp
end

---@private
function GuildRecommendItemView:InitGenerate__7(Root, data)
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
function GuildRecommendItemView:GenerateDestroy()
	if self.guildBadgeItem.GenerateDestroy ~= nil then
		self.guildBadgeItem:GenerateDestroy()
	end
	if tolua.getpeer(self.guildBadgeItem) ~= nil then
		tolua.setpeer(self.guildBadgeItem, nil)
	end
	self.guildBadgeItem = nil
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	if tolua.getpeer(self.lvTxt) ~= nil then
		tolua.setpeer(self.lvTxt, nil)
	end
	self.lvTxt = nil
	if tolua.getpeer(self.peopleTxt) ~= nil then
		tolua.setpeer(self.peopleTxt, nil)
	end
	self.peopleTxt = nil
	if tolua.getpeer(self.appliedTag) ~= nil then
		tolua.setpeer(self.appliedTag, nil)
	end
	self.appliedTag = nil
	if tolua.getpeer(self.activeTxt) ~= nil then
		tolua.setpeer(self.activeTxt, nil)
	end
	self.activeTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return GuildRecommendItemView