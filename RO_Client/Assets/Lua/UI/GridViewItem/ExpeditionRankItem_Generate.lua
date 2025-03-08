---@class ExpeditionRankItem__Generate_rankTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ExpeditionRankItem__Generate_guildCPTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ExpeditionRankItem__Generate_lvTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ExpeditionRankItem__Generate_vipIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ExpeditionRankItem__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ExpeditionRankItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class ExpeditionRankItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private headItem ExpeditionRankItem__Generate_headItem
---@field private nameTxt ExpeditionRankItem__Generate_nameTxt
---@field private vipIcon ExpeditionRankItem__Generate_vipIcon
---@field private lvTxt ExpeditionRankItem__Generate_lvTxt
---@field private guildCPTxt ExpeditionRankItem__Generate_guildCPTxt
---@field private rankTxt ExpeditionRankItem__Generate_rankTxt
---@field private rank1 UnityEngine.GameObject
---@field private rank2 UnityEngine.GameObject
---@field private rank3 UnityEngine.GameObject
local ExpeditionRankItemView = class("ExpeditionRankItemView")

function ExpeditionRankItemView:ctor()
end

---@private
function ExpeditionRankItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ExpeditionRankItemView:InitGenerate(Root, data)
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
function ExpeditionRankItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ExpeditionRankItemView:InitGenerate__2(Root, data)
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
function ExpeditionRankItemView:InitGenerate__3(Root, data)
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
function ExpeditionRankItemView:InitGenerate__4(Root, data)
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
function ExpeditionRankItemView:InitGenerate__5(Root, data)
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
function ExpeditionRankItemView:InitGenerate__6(Root, data)
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
function ExpeditionRankItemView:InitGenerate__7(Root, data)
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
function ExpeditionRankItemView:InitGenerate__8(Root, data)
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
function ExpeditionRankItemView:InitGenerate__9(Root, data)
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
function ExpeditionRankItemView:InitGenerate__10(Root, data)
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
function ExpeditionRankItemView:GenerateDestroy()
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
	if tolua.getpeer(self.vipIcon) ~= nil then
		tolua.setpeer(self.vipIcon, nil)
	end
	self.vipIcon = nil
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
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return ExpeditionRankItemView