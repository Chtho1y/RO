---@class HundredDojoGuildRankItem__Generate_rankTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class HundredDojoGuildRankItem__Generate_guildCPTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class HundredDojoGuildRankItem__Generate_lvTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class HundredDojoGuildRankItem__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class HundredDojoGuildRankItem__Generate_badge
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class HundredDojoGuildRankItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private badge HundredDojoGuildRankItem__Generate_badge
---@field private nameTxt HundredDojoGuildRankItem__Generate_nameTxt
---@field private lvTxt HundredDojoGuildRankItem__Generate_lvTxt
---@field private guildCPTxt HundredDojoGuildRankItem__Generate_guildCPTxt
---@field private rankTxt HundredDojoGuildRankItem__Generate_rankTxt
---@field private rank1 UnityEngine.GameObject
---@field private rank2 UnityEngine.GameObject
---@field private rank3 UnityEngine.GameObject
---@field private rank4 UnityEngine.GameObject
local HundredDojoGuildRankItemView = class("HundredDojoGuildRankItemView")

function HundredDojoGuildRankItemView:ctor()
end

---@private
function HundredDojoGuildRankItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function HundredDojoGuildRankItemView:InitGenerate(Root, data)
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


end

---@private
function HundredDojoGuildRankItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function HundredDojoGuildRankItemView:InitGenerate__2(Root, data)
--[[
	Flag/Badge
--]]
	local tmp = Root:Find("Flag/Badge").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.badge = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function HundredDojoGuildRankItemView:InitGenerate__3(Root, data)
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
function HundredDojoGuildRankItemView:InitGenerate__4(Root, data)
--[[
	LvTxt
--]]
	local tmp = Root:Find("LvTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lvTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function HundredDojoGuildRankItemView:InitGenerate__5(Root, data)
--[[
	GuildCP/GuildCPTxt
--]]
	local tmp = Root:Find("GuildCP/GuildCPTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildCPTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function HundredDojoGuildRankItemView:InitGenerate__6(Root, data)
--[[
	RankTxt
--]]
	local tmp = Root:Find("RankTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function HundredDojoGuildRankItemView:InitGenerate__7(Root, data)
--[[
	Rank1
--]]
	local tmp = Root:Find("Rank1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rank1 = tmp
end

---@private
function HundredDojoGuildRankItemView:InitGenerate__8(Root, data)
--[[
	Rank2
--]]
	local tmp = Root:Find("Rank2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rank2 = tmp
end

---@private
function HundredDojoGuildRankItemView:InitGenerate__9(Root, data)
--[[
	Rank3
--]]
	local tmp = Root:Find("Rank3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rank3 = tmp
end

---@private
function HundredDojoGuildRankItemView:InitGenerate__10(Root, data)
--[[
	Rank4
--]]
	local tmp = Root:Find("Rank4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rank4 = tmp
end

---@private
function HundredDojoGuildRankItemView:GenerateDestroy()
	if tolua.getpeer(self.badge) ~= nil then
		tolua.setpeer(self.badge, nil)
	end
	self.badge = nil
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	if tolua.getpeer(self.lvTxt) ~= nil then
		tolua.setpeer(self.lvTxt, nil)
	end
	self.lvTxt = nil
	if tolua.getpeer(self.guildCPTxt) ~= nil then
		tolua.setpeer(self.guildCPTxt, nil)
	end
	self.guildCPTxt = nil
	if tolua.getpeer(self.rankTxt) ~= nil then
		tolua.setpeer(self.rankTxt, nil)
	end
	self.rankTxt = nil
	if tolua.getpeer(self.rank1) ~= nil then
		tolua.setpeer(self.rank1, nil)
	end
	self.rank1 = nil
	if tolua.getpeer(self.rank2) ~= nil then
		tolua.setpeer(self.rank2, nil)
	end
	self.rank2 = nil
	if tolua.getpeer(self.rank3) ~= nil then
		tolua.setpeer(self.rank3, nil)
	end
	self.rank3 = nil
	if tolua.getpeer(self.rank4) ~= nil then
		tolua.setpeer(self.rank4, nil)
	end
	self.rank4 = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return HundredDojoGuildRankItemView