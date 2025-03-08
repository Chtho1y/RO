---@class ClimbingTowerRankItem__Generate_serverName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ClimbingTowerRankItem__Generate_blockNum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ClimbingTowerRankItem__Generate_blockNumTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class ClimbingTowerRankItem__Generate_passedTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ClimbingTowerRankItem__Generate_passedTimeTips
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ClimbingTowerRankItem__Generate_levelNum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ClimbingTowerRankItem__Generate_levelNumTips
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ClimbingTowerRankItem__Generate_vipIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ClimbingTowerRankItem__Generate_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ClimbingTowerRankItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class ClimbingTowerRankItem__Generate_rankImg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public switchSprite SwitchSprite

---@class ClimbingTowerRankItem__Generate_rank
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ClimbingTowerRankItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rank ClimbingTowerRankItem__Generate_rank
---@field private rankImg ClimbingTowerRankItem__Generate_rankImg
---@field private headItem ClimbingTowerRankItem__Generate_headItem
---@field private playerName ClimbingTowerRankItem__Generate_playerName
---@field private vipIcon ClimbingTowerRankItem__Generate_vipIcon
---@field private levelNumTips ClimbingTowerRankItem__Generate_levelNumTips
---@field private levelNum ClimbingTowerRankItem__Generate_levelNum
---@field private passedTimeTips ClimbingTowerRankItem__Generate_passedTimeTips
---@field private passedTime ClimbingTowerRankItem__Generate_passedTime
---@field private blockNumTitle ClimbingTowerRankItem__Generate_blockNumTitle
---@field private blockNum ClimbingTowerRankItem__Generate_blockNum
---@field private serverName ClimbingTowerRankItem__Generate_serverName
local ClimbingTowerRankItemView = class("ClimbingTowerRankItemView")

function ClimbingTowerRankItemView:ctor()
end

---@private
function ClimbingTowerRankItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ClimbingTowerRankItemView:InitGenerate(Root, data)
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
	self:InitGenerate__12(Root,data)
	self:InitGenerate__13(Root,data)


end

---@private
function ClimbingTowerRankItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function ClimbingTowerRankItemView:InitGenerate__2(Root, data)
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
function ClimbingTowerRankItemView:InitGenerate__3(Root, data)
--[[
	Madel01
--]]
	local tmp = Root:Find("Madel01").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankImg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.switchSprite = tmp:GetComponent(Enum.TypeInfo.SwitchSprite)
end

---@private
function ClimbingTowerRankItemView:InitGenerate__4(Root, data)
--[[
	Head/HeadItem
--]]
	local tmp = Root:Find("Head/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function ClimbingTowerRankItemView:InitGenerate__5(Root, data)
--[[
	NameText
--]]
	local tmp = Root:Find("NameText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ClimbingTowerRankItemView:InitGenerate__6(Root, data)
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
function ClimbingTowerRankItemView:InitGenerate__7(Root, data)
--[[
	LevelNumTips
--]]
	local tmp = Root:Find("LevelNumTips").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.levelNumTips = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ClimbingTowerRankItemView:InitGenerate__8(Root, data)
--[[
	LevelNum
--]]
	local tmp = Root:Find("LevelNum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.levelNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ClimbingTowerRankItemView:InitGenerate__9(Root, data)
--[[
	passedTimeTips
--]]
	local tmp = Root:Find("passedTimeTips").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.passedTimeTips = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ClimbingTowerRankItemView:InitGenerate__10(Root, data)
--[[
	passedTime
--]]
	local tmp = Root:Find("passedTime").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.passedTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ClimbingTowerRankItemView:InitGenerate__11(Root, data)
--[[
	BlockNumTitle
--]]
	local tmp = Root:Find("BlockNumTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.blockNumTitle = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function ClimbingTowerRankItemView:InitGenerate__12(Root, data)
--[[
	BlockNum
--]]
	local tmp = Root:Find("BlockNum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.blockNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ClimbingTowerRankItemView:InitGenerate__13(Root, data)
--[[
	ServerName
--]]
	local tmp = Root:Find("ServerName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.serverName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ClimbingTowerRankItemView:GenerateDestroy()
	if tolua.getpeer(self.serverName) ~= nil then
		tolua.setpeer(self.serverName, nil)
	end
	if tolua.getpeer(self.blockNum) ~= nil then
		tolua.setpeer(self.blockNum, nil)
	end
	if tolua.getpeer(self.passedTime) ~= nil then
		tolua.setpeer(self.passedTime, nil)
	end
	if tolua.getpeer(self.levelNum) ~= nil then
		tolua.setpeer(self.levelNum, nil)
	end
	if tolua.getpeer(self.rankImg) ~= nil then
		tolua.setpeer(self.rankImg, nil)
	end
	if tolua.getpeer(self.rank) ~= nil then
		tolua.setpeer(self.rank, nil)
	end
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	self.headItem = nil
	if tolua.getpeer(self.playerName) ~= nil then
		tolua.setpeer(self.playerName, nil)
	end
	self.playerName = nil
	if tolua.getpeer(self.vipIcon) ~= nil then
		tolua.setpeer(self.vipIcon, nil)
	end
	self.vipIcon = nil
	if tolua.getpeer(self.levelNumTips) ~= nil then
		tolua.setpeer(self.levelNumTips, nil)
	end
	self.levelNumTips = nil
	if tolua.getpeer(self.passedTimeTips) ~= nil then
		tolua.setpeer(self.passedTimeTips, nil)
	end
	self.passedTimeTips = nil
	if tolua.getpeer(self.blockNumTitle) ~= nil then
		tolua.setpeer(self.blockNumTitle, nil)
	end
	self.blockNumTitle = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return ClimbingTowerRankItemView