---@class RankItem__Generate_fighterPower
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RankItem__Generate_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RankItem__Generate_vipIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RankItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RankItem__Generate_viewBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class RankItem__Generate_danName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RankItem__Generate_danIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RankItem__Generate_madel03
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RankItem__Generate_madel02
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RankItem__Generate_madel01
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RankItem__Generate_rank
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RankItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rank RankItem__Generate_rank
---@field private madel01 RankItem__Generate_madel01
---@field private madel02 RankItem__Generate_madel02
---@field private madel03 RankItem__Generate_madel03
---@field private danIcon RankItem__Generate_danIcon
---@field private danName RankItem__Generate_danName
---@field private viewBtn RankItem__Generate_viewBtn
---@field private headItem RankItem__Generate_headItem
---@field private vipIcon RankItem__Generate_vipIcon
---@field private playerName RankItem__Generate_playerName
---@field private fighterPower RankItem__Generate_fighterPower
local RankItemView = class("RankItemView")

function RankItemView:ctor()
end

---@private
function RankItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RankItemView:InitGenerate(Root, data)
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
function RankItemView:InitGenerate__1(Root, data)
--[[
	Rank
--]]
	local tmp = Root:Find("Rank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rank = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RankItemView:InitGenerate__2(Root, data)
--[[
	Madel01
--]]
	local tmp = Root:Find("Madel01").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.madel01 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RankItemView:InitGenerate__3(Root, data)
--[[
	Madel02
--]]
	local tmp = Root:Find("Madel02").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.madel02 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RankItemView:InitGenerate__4(Root, data)
--[[
	Madel03
--]]
	local tmp = Root:Find("Madel03").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.madel03 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RankItemView:InitGenerate__5(Root, data)
--[[
	danIcon
--]]
	local tmp = Root:Find("danIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.danIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RankItemView:InitGenerate__6(Root, data)
--[[
	danIcon/danNameText
--]]
	local tmp = Root:Find("danIcon/danNameText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.danName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RankItemView:InitGenerate__7(Root, data)
--[[
	ViewBtn
--]]
	local tmp = Root:Find("ViewBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.viewBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function RankItemView:InitGenerate__8(Root, data)
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
function RankItemView:InitGenerate__9(Root, data)
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
function RankItemView:InitGenerate__10(Root, data)
--[[
	PlayerNode/NameText
--]]
	local tmp = Root:Find("PlayerNode/NameText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RankItemView:InitGenerate__11(Root, data)
--[[
	PlayerNode/fighterPowerVal
--]]
	local tmp = Root:Find("PlayerNode/fighterPowerVal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fighterPower = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RankItemView:GenerateDestroy()
	if tolua.getpeer(self.rank) ~= nil then
		tolua.setpeer(self.rank, nil)
	end
	self.rank = nil
	if tolua.getpeer(self.madel01) ~= nil then
		tolua.setpeer(self.madel01, nil)
	end
	self.madel01 = nil
	if tolua.getpeer(self.madel02) ~= nil then
		tolua.setpeer(self.madel02, nil)
	end
	self.madel02 = nil
	if tolua.getpeer(self.madel03) ~= nil then
		tolua.setpeer(self.madel03, nil)
	end
	self.madel03 = nil
	if tolua.getpeer(self.danIcon) ~= nil then
		tolua.setpeer(self.danIcon, nil)
	end
	self.danIcon = nil
	if tolua.getpeer(self.danName) ~= nil then
		tolua.setpeer(self.danName, nil)
	end
	self.danName = nil
	if tolua.getpeer(self.viewBtn) ~= nil then
		tolua.setpeer(self.viewBtn, nil)
	end
	self.viewBtn = nil
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
	if tolua.getpeer(self.playerName) ~= nil then
		tolua.setpeer(self.playerName, nil)
	end
	self.playerName = nil
	if tolua.getpeer(self.fighterPower) ~= nil then
		tolua.setpeer(self.fighterPower, nil)
	end
	self.fighterPower = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RankItemView