---@class GuildWarRankItem__Generate_rankTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildWarRankItem__Generate_currency_numTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildWarRankItem__Generate_currency_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class GuildWarRankItem__Generate_currency
---@field public gameObject UnityEngine.GameObject
---@field public icon GuildWarRankItem__Generate_currency_icon
---@field public numTxt GuildWarRankItem__Generate_currency_numTxt

---@class GuildWarRankItem__Generate_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildWarRankItem__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildWarRankItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class GuildWarRankItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private headItem GuildWarRankItem__Generate_headItem
---@field private nameTxt GuildWarRankItem__Generate_nameTxt
---@field private playerName GuildWarRankItem__Generate_playerName
---@field private currency GuildWarRankItem__Generate_currency
---@field private rankTxt GuildWarRankItem__Generate_rankTxt
---@field private tagMvp UnityEngine.GameObject
local GuildWarRankItemView = class("GuildWarRankItemView")

function GuildWarRankItemView:ctor()
end

---@private
function GuildWarRankItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function GuildWarRankItemView:InitGenerate(Root, data)
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
function GuildWarRankItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function GuildWarRankItemView:InitGenerate__2(Root, data)
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
function GuildWarRankItemView:InitGenerate__3(Root, data)
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
function GuildWarRankItemView:InitGenerate__4(Root, data)
--[[
	PlayerName
--]]
	local tmp = Root:Find("PlayerName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function GuildWarRankItemView:InitGenerate__5(Root, data)
--[[
	Currency
--]]
	local tmp = Root:Find("Currency").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency = tmp
end

---@private
function GuildWarRankItemView:InitGenerate__6(Root, data)
--[[
	Currency/Icon
--]]
	local tmp = Root:Find("Currency/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function GuildWarRankItemView:InitGenerate__7(Root, data)
--[[
	Currency/NumTxt
--]]
	local tmp = Root:Find("Currency/NumTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency.numTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function GuildWarRankItemView:InitGenerate__8(Root, data)
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
function GuildWarRankItemView:InitGenerate__9(Root, data)
--[[
	TagMvp
--]]
	local tmp = Root:Find("TagMvp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tagMvp = tmp
end

---@private
function GuildWarRankItemView:GenerateDestroy()
	if tolua.getpeer(self.currency.numTxt) ~= nil then
		tolua.setpeer(self.currency.numTxt, nil)
	end
	if tolua.getpeer(self.currency.icon) ~= nil then
		tolua.setpeer(self.currency.icon, nil)
	end
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	self.headItem = nil
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	if tolua.getpeer(self.playerName) ~= nil then
		tolua.setpeer(self.playerName, nil)
	end
	self.playerName = nil
	if tolua.getpeer(self.currency) ~= nil then
		tolua.setpeer(self.currency, nil)
	end
	self.currency = nil
	if tolua.getpeer(self.rankTxt) ~= nil then
		tolua.setpeer(self.rankTxt, nil)
	end
	self.rankTxt = nil
	if tolua.getpeer(self.tagMvp) ~= nil then
		tolua.setpeer(self.tagMvp, nil)
	end
	self.tagMvp = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return GuildWarRankItemView