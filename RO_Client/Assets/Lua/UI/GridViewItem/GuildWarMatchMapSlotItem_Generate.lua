---@class GuildWarMatchMapSlotItem__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildWarMatchMapSlotItem__Generate_nameBg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class GuildWarMatchMapSlotItem__Generate_badge
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class GuildWarMatchMapSlotItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private guildFlag UnityEngine.GameObject
---@field private tagMy UnityEngine.GameObject
---@field private tagChamp UnityEngine.GameObject
---@field private badge GuildWarMatchMapSlotItem__Generate_badge
---@field private loseTag UnityEngine.GameObject
---@field private nameBg GuildWarMatchMapSlotItem__Generate_nameBg
---@field private nameTxt GuildWarMatchMapSlotItem__Generate_nameTxt
local GuildWarMatchMapSlotItemView = class("GuildWarMatchMapSlotItemView")

function GuildWarMatchMapSlotItemView:ctor()
end

---@private
function GuildWarMatchMapSlotItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function GuildWarMatchMapSlotItemView:InitGenerate(Root, data)
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
function GuildWarMatchMapSlotItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function GuildWarMatchMapSlotItemView:InitGenerate__2(Root, data)
--[[
	GuildFlag
--]]
	local tmp = Root:Find("GuildFlag").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildFlag = tmp
end

---@private
function GuildWarMatchMapSlotItemView:InitGenerate__3(Root, data)
--[[
	GuildFlag/TagMy
--]]
	local tmp = Root:Find("GuildFlag/TagMy").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tagMy = tmp
end

---@private
function GuildWarMatchMapSlotItemView:InitGenerate__4(Root, data)
--[[
	GuildFlag/TagChamp
--]]
	local tmp = Root:Find("GuildFlag/TagChamp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tagChamp = tmp
end

---@private
function GuildWarMatchMapSlotItemView:InitGenerate__5(Root, data)
--[[
	GuildFlag/Badge
--]]
	local tmp = Root:Find("GuildFlag/Badge").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.badge = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function GuildWarMatchMapSlotItemView:InitGenerate__6(Root, data)
--[[
	GuildFlag/LoseTag
--]]
	local tmp = Root:Find("GuildFlag/LoseTag").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loseTag = tmp
end

---@private
function GuildWarMatchMapSlotItemView:InitGenerate__7(Root, data)
--[[
	NameBg
--]]
	local tmp = Root:Find("NameBg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameBg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function GuildWarMatchMapSlotItemView:InitGenerate__8(Root, data)
--[[
	NameBg/NameTxt
--]]
	local tmp = Root:Find("NameBg/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function GuildWarMatchMapSlotItemView:GenerateDestroy()
	if tolua.getpeer(self.guildFlag) ~= nil then
		tolua.setpeer(self.guildFlag, nil)
	end
	self.guildFlag = nil
	if tolua.getpeer(self.tagMy) ~= nil then
		tolua.setpeer(self.tagMy, nil)
	end
	self.tagMy = nil
	if tolua.getpeer(self.tagChamp) ~= nil then
		tolua.setpeer(self.tagChamp, nil)
	end
	self.tagChamp = nil
	if tolua.getpeer(self.badge) ~= nil then
		tolua.setpeer(self.badge, nil)
	end
	self.badge = nil
	if tolua.getpeer(self.loseTag) ~= nil then
		tolua.setpeer(self.loseTag, nil)
	end
	self.loseTag = nil
	if tolua.getpeer(self.nameBg) ~= nil then
		tolua.setpeer(self.nameBg, nil)
	end
	self.nameBg = nil
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return GuildWarMatchMapSlotItemView