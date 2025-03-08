---@class DemonGuildRankItem__Generate_rankTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class DemonGuildRankItem__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class DemonGuildRankItem__Generate_iconScore
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class DemonGuildRankItem__Generate_lvTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class DemonGuildRankItem__Generate_guildName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class DemonGuildRankItem__Generate_flag
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class DemonGuildRankItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private flag DemonGuildRankItem__Generate_flag
---@field private guildName DemonGuildRankItem__Generate_guildName
---@field private lvTxt DemonGuildRankItem__Generate_lvTxt
---@field private iconScore DemonGuildRankItem__Generate_iconScore
---@field private number DemonGuildRankItem__Generate_number
---@field private rankTxt DemonGuildRankItem__Generate_rankTxt
---@field private rank1 UnityEngine.GameObject
---@field private rank2 UnityEngine.GameObject
---@field private rank3 UnityEngine.GameObject
local DemonGuildRankItemView = class("DemonGuildRankItemView")

function DemonGuildRankItemView:ctor()
end

---@private
function DemonGuildRankItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function DemonGuildRankItemView:InitGenerate(Root, data)
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
function DemonGuildRankItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function DemonGuildRankItemView:InitGenerate__2(Root, data)
--[[
	Flag
--]]
	local tmp = Root:Find("Flag").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.flag = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function DemonGuildRankItemView:InitGenerate__3(Root, data)
--[[
	GuildName
--]]
	local tmp = Root:Find("GuildName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function DemonGuildRankItemView:InitGenerate__4(Root, data)
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
function DemonGuildRankItemView:InitGenerate__5(Root, data)
--[[
	IconScore
--]]
	local tmp = Root:Find("IconScore").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconScore = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function DemonGuildRankItemView:InitGenerate__6(Root, data)
--[[
	Dmg/Number
--]]
	local tmp = Root:Find("Dmg/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function DemonGuildRankItemView:InitGenerate__7(Root, data)
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
function DemonGuildRankItemView:InitGenerate__8(Root, data)
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
function DemonGuildRankItemView:InitGenerate__9(Root, data)
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
function DemonGuildRankItemView:InitGenerate__10(Root, data)
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
function DemonGuildRankItemView:GenerateDestroy()
	if tolua.getpeer(self.flag) ~= nil then
		tolua.setpeer(self.flag, nil)
	end
	self.flag = nil
	if tolua.getpeer(self.guildName) ~= nil then
		tolua.setpeer(self.guildName, nil)
	end
	self.guildName = nil
	if tolua.getpeer(self.lvTxt) ~= nil then
		tolua.setpeer(self.lvTxt, nil)
	end
	self.lvTxt = nil
	if tolua.getpeer(self.iconScore) ~= nil then
		tolua.setpeer(self.iconScore, nil)
	end
	self.iconScore = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
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
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return DemonGuildRankItemView