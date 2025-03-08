---@class VoyageRankItem__Generate_scoreTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class VoyageRankItem__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class VoyageRankItem__Generate_vipIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class VoyageRankItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class VoyageRankItem__Generate_rankSp
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class VoyageRankItem__Generate_rankTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class VoyageRankItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rankTxt VoyageRankItem__Generate_rankTxt
---@field private rankSp VoyageRankItem__Generate_rankSp
---@field private headItem VoyageRankItem__Generate_headItem
---@field private vipIcon VoyageRankItem__Generate_vipIcon
---@field private nameTxt VoyageRankItem__Generate_nameTxt
---@field private scoreTxt VoyageRankItem__Generate_scoreTxt
local VoyageRankItemView = class("VoyageRankItemView")

function VoyageRankItemView:ctor()
end

---@private
function VoyageRankItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function VoyageRankItemView:InitGenerate(Root, data)
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
function VoyageRankItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function VoyageRankItemView:InitGenerate__2(Root, data)
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
function VoyageRankItemView:InitGenerate__3(Root, data)
--[[
	RankSp
--]]
	local tmp = Root:Find("RankSp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankSp = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function VoyageRankItemView:InitGenerate__4(Root, data)
--[[
	PlayerNode/HeadBox/HeadItem
--]]
	local tmp = Root:Find("PlayerNode/HeadBox/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function VoyageRankItemView:InitGenerate__5(Root, data)
--[[
	PlayerNode/VipIcon
--]]
	local tmp = Root:Find("PlayerNode/VipIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function VoyageRankItemView:InitGenerate__6(Root, data)
--[[
	PlayerNode/NameTxt
--]]
	local tmp = Root:Find("PlayerNode/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function VoyageRankItemView:InitGenerate__7(Root, data)
--[[
	PlayerNode/ScoreTxt
--]]
	local tmp = Root:Find("PlayerNode/ScoreTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scoreTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function VoyageRankItemView:GenerateDestroy()
	if tolua.getpeer(self.rankTxt) ~= nil then
		tolua.setpeer(self.rankTxt, nil)
	end
	self.rankTxt = nil
	if tolua.getpeer(self.rankSp) ~= nil then
		tolua.setpeer(self.rankSp, nil)
	end
	self.rankSp = nil
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
	if tolua.getpeer(self.scoreTxt) ~= nil then
		tolua.setpeer(self.scoreTxt, nil)
	end
	self.scoreTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return VoyageRankItemView