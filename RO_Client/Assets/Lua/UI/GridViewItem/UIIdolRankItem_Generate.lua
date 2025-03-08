---@class UIIdolRankItem__Generate_btnSupport
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIIdolRankItem__Generate_hotVal
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIIdolRankItem__Generate_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIIdolRankItem__Generate_vipIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIIdolRankItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIIdolRankItem__Generate_madel03
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIIdolRankItem__Generate_madel02
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIIdolRankItem__Generate_madel01
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIIdolRankItem__Generate_rank
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIIdolRankItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rank UIIdolRankItem__Generate_rank
---@field private madel01 UIIdolRankItem__Generate_madel01
---@field private madel02 UIIdolRankItem__Generate_madel02
---@field private madel03 UIIdolRankItem__Generate_madel03
---@field private headItem UIIdolRankItem__Generate_headItem
---@field private vipIcon UIIdolRankItem__Generate_vipIcon
---@field private playerName UIIdolRankItem__Generate_playerName
---@field private hotVal UIIdolRankItem__Generate_hotVal
---@field private btnSupport UIIdolRankItem__Generate_btnSupport
local UIIdolRankItemView = class("UIIdolRankItemView")

function UIIdolRankItemView:ctor()
end

---@private
function UIIdolRankItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIIdolRankItemView:InitGenerate(Root, data)
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
function UIIdolRankItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIIdolRankItemView:InitGenerate__2(Root, data)
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
function UIIdolRankItemView:InitGenerate__3(Root, data)
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
function UIIdolRankItemView:InitGenerate__4(Root, data)
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
function UIIdolRankItemView:InitGenerate__5(Root, data)
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
function UIIdolRankItemView:InitGenerate__6(Root, data)
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
function UIIdolRankItemView:InitGenerate__7(Root, data)
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
function UIIdolRankItemView:InitGenerate__8(Root, data)
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
function UIIdolRankItemView:InitGenerate__9(Root, data)
--[[
	PlayerNode/HotVal
--]]
	local tmp = Root:Find("PlayerNode/HotVal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hotVal = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIIdolRankItemView:InitGenerate__10(Root, data)
--[[
	BtnSupport
--]]
	local tmp = Root:Find("BtnSupport").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSupport = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIIdolRankItemView:GenerateDestroy()
	if tolua.getpeer(self.btnSupport) ~= nil then
		tolua.setpeer(self.btnSupport, nil)
	end
	if tolua.getpeer(self.hotVal) ~= nil then
		tolua.setpeer(self.hotVal, nil)
	end
	if tolua.getpeer(self.playerName) ~= nil then
		tolua.setpeer(self.playerName, nil)
	end
	if tolua.getpeer(self.vipIcon) ~= nil then
		tolua.setpeer(self.vipIcon, nil)
	end
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	if tolua.getpeer(self.madel03) ~= nil then
		tolua.setpeer(self.madel03, nil)
	end
	if tolua.getpeer(self.madel02) ~= nil then
		tolua.setpeer(self.madel02, nil)
	end
	if tolua.getpeer(self.madel01) ~= nil then
		tolua.setpeer(self.madel01, nil)
	end
	if tolua.getpeer(self.rank) ~= nil then
		tolua.setpeer(self.rank, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIIdolRankItemView