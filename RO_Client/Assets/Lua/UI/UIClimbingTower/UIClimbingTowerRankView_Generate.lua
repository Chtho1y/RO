---@class UIClimbingTowerRank__Generate_selfRank_serverName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerRank__Generate_selfRank_blockNum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerRank__Generate_selfRank_blockNumTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIClimbingTowerRank__Generate_selfRank_passedTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerRank__Generate_selfRank_passedTimeTips
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerRank__Generate_selfRank_levelNum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerRank__Generate_selfRank_levelNumTips
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerRank__Generate_selfRank_playerNode_fighterPower
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerRank__Generate_selfRank_vipIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIClimbingTowerRank__Generate_selfRank_playerNode_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerRank__Generate_selfRank_playerNode_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIClimbingTowerRank__Generate_selfRank_playerNode
---@field public gameObject UnityEngine.GameObject
---@field public headItem UIClimbingTowerRank__Generate_selfRank_playerNode_headItem
---@field public playerName UIClimbingTowerRank__Generate_selfRank_playerNode_playerName
---@field public fighterPower UIClimbingTowerRank__Generate_selfRank_playerNode_fighterPower

---@class UIClimbingTowerRank__Generate_selfRank_rankImg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public switchSprite SwitchSprite

---@class UIClimbingTowerRank__Generate_selfRank_rank
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIClimbingTowerRank__Generate_selfRank
---@field public gameObject UnityEngine.GameObject
---@field public rank UIClimbingTowerRank__Generate_selfRank_rank
---@field public rankImg UIClimbingTowerRank__Generate_selfRank_rankImg
---@field public playerNode UIClimbingTowerRank__Generate_selfRank_playerNode
---@field public vipIcon UIClimbingTowerRank__Generate_selfRank_vipIcon
---@field public levelNumTips UIClimbingTowerRank__Generate_selfRank_levelNumTips
---@field public levelNum UIClimbingTowerRank__Generate_selfRank_levelNum
---@field public passedTimeTips UIClimbingTowerRank__Generate_selfRank_passedTimeTips
---@field public passedTime UIClimbingTowerRank__Generate_selfRank_passedTime
---@field public blockNumTitle UIClimbingTowerRank__Generate_selfRank_blockNumTitle
---@field public blockNum UIClimbingTowerRank__Generate_selfRank_blockNum
---@field public serverName UIClimbingTowerRank__Generate_selfRank_serverName

---@class UIClimbingTowerRank__Generate_rankContent
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIClimbingTowerRank__Generate_rankScroll
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIClimbingTowerRank__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTowerRank__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTowerRank__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIClimbingTowerRank__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIClimbingTowerRank__Generate_uIAnimator
---@field private AnyBtn UIClimbingTowerRank__Generate_AnyBtn
---@field private closeBtn UIClimbingTowerRank__Generate_closeBtn
---@field private rankScroll UIClimbingTowerRank__Generate_rankScroll
---@field private rankContent UIClimbingTowerRank__Generate_rankContent
---@field private emptyNode UnityEngine.GameObject
---@field private selfRank UIClimbingTowerRank__Generate_selfRank
local UIClimbingTowerRankView = class("UIClimbingTowerRankView", require("UIViewBase"))

function UIClimbingTowerRankView:ctor()
end

---@private
function UIClimbingTowerRankView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIClimbingTowerRankView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
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
	self:InitGenerate__14(Root,data)
	self:InitGenerate__15(Root,data)
	self:InitGenerate__16(Root,data)
	self:InitGenerate__17(Root,data)
	self:InitGenerate__18(Root,data)
	self:InitGenerate__19(Root,data)
	self:InitGenerate__20(Root,data)
	self:InitGenerate__21(Root,data)
	self:InitGenerate__22(Root,data)


end

---@private
function UIClimbingTowerRankView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIClimbingTowerRankView:InitGenerate__2(Root, data)
--[[
	UIAnimator
--]]
	local tmp = Root:Find("UIAnimator").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIAnimator = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIClimbingTowerRankView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerRankView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerRankView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/PlayerScroll
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/PlayerScroll").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankScroll = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIClimbingTowerRankView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/PlayerScroll/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/PlayerScroll/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankContent = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIClimbingTowerRankView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/Empty
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/Empty").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emptyNode = tmp
end

---@private
function UIClimbingTowerRankView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank = tmp
end

---@private
function UIClimbingTowerRankView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank/Rank
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank/Rank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank.rank = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerRankView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank/Madel01
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank/Madel01").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank.rankImg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.switchSprite = tmp:GetComponent(Enum.TypeInfo.SwitchSprite)
end

---@private
function UIClimbingTowerRankView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank.playerNode = tmp
end

---@private
function UIClimbingTowerRankView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/Head/HeadItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/Head/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank.playerNode.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.selfRank.playerNode.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIClimbingTowerRankView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/NameText
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/NameText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank.playerNode.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerRankView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/VipIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/VipIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank.vipIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIClimbingTowerRankView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/fighterPowerVal
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/fighterPowerVal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank.playerNode.fighterPower = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerRankView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/LevelNumTips
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/LevelNumTips").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank.levelNumTips = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerRankView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/LevelNum
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/LevelNum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank.levelNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerRankView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/passedTimeTips
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/passedTimeTips").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank.passedTimeTips = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerRankView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/passedTime
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/passedTime").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank.passedTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerRankView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/BlockNumTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/BlockNumTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank.blockNumTitle = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIClimbingTowerRankView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/BlockNum
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/BlockNum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank.blockNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerRankView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/ServerName
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRank/PlayerNode/ServerName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selfRank.serverName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerRankView:GenerateDestroy()
	if tolua.getpeer(self.selfRank.serverName) ~= nil then
		tolua.setpeer(self.selfRank.serverName, nil)
	end
	if tolua.getpeer(self.selfRank.blockNum) ~= nil then
		tolua.setpeer(self.selfRank.blockNum, nil)
	end
	if tolua.getpeer(self.selfRank.blockNumTitle) ~= nil then
		tolua.setpeer(self.selfRank.blockNumTitle, nil)
	end
	if tolua.getpeer(self.selfRank.passedTime) ~= nil then
		tolua.setpeer(self.selfRank.passedTime, nil)
	end
	if tolua.getpeer(self.selfRank.passedTimeTips) ~= nil then
		tolua.setpeer(self.selfRank.passedTimeTips, nil)
	end
	if tolua.getpeer(self.selfRank.levelNum) ~= nil then
		tolua.setpeer(self.selfRank.levelNum, nil)
	end
	if tolua.getpeer(self.selfRank.levelNumTips) ~= nil then
		tolua.setpeer(self.selfRank.levelNumTips, nil)
	end
	if tolua.getpeer(self.selfRank.playerNode.fighterPower) ~= nil then
		tolua.setpeer(self.selfRank.playerNode.fighterPower, nil)
	end
	if tolua.getpeer(self.selfRank.vipIcon) ~= nil then
		tolua.setpeer(self.selfRank.vipIcon, nil)
	end
	if tolua.getpeer(self.selfRank.playerNode.playerName) ~= nil then
		tolua.setpeer(self.selfRank.playerNode.playerName, nil)
	end
	if self.selfRank.playerNode.headItem.GenerateDestroy ~= nil then
		self.selfRank.playerNode.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.selfRank.playerNode.headItem) ~= nil then
		tolua.setpeer(self.selfRank.playerNode.headItem, nil)
	end
	if tolua.getpeer(self.selfRank.playerNode) ~= nil then
		tolua.setpeer(self.selfRank.playerNode, nil)
	end
	if tolua.getpeer(self.selfRank.rankImg) ~= nil then
		tolua.setpeer(self.selfRank.rankImg, nil)
	end
	if tolua.getpeer(self.selfRank.rank) ~= nil then
		tolua.setpeer(self.selfRank.rank, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.closeBtn) ~= nil then
		tolua.setpeer(self.closeBtn, nil)
	end
	self.closeBtn = nil
	if tolua.getpeer(self.rankScroll) ~= nil then
		tolua.setpeer(self.rankScroll, nil)
	end
	self.rankScroll = nil
	if tolua.getpeer(self.rankContent) ~= nil then
		tolua.setpeer(self.rankContent, nil)
	end
	self.rankContent = nil
	if tolua.getpeer(self.emptyNode) ~= nil then
		tolua.setpeer(self.emptyNode, nil)
	end
	self.emptyNode = nil
	if tolua.getpeer(self.selfRank) ~= nil then
		tolua.setpeer(self.selfRank, nil)
	end
	self.selfRank = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIClimbingTowerRankView