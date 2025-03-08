---@class UIDojoRank__Generate_fighterPower
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoRank__Generate_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoRank__Generate_vipIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIDojoRank__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIDojoRank__Generate_viewBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojoRank__Generate_danName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoRank__Generate_danIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIDojoRank__Generate_rank
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoRank__Generate_lastSeasonToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIDojoRank__Generate_curSeasonToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIDojoRank__Generate_toggleGroup
---@field public gameObject UnityEngine.GameObject
---@field public toggleGroup UnityEngine.UI.ToggleGroup

---@class UIDojoRank__Generate_rankContent
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIDojoRank__Generate_rankScroll
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIDojoRank__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojoRank__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojoRank__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIDojoRank__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIDojoRank__Generate_uIAnimator
---@field private AnyBtn UIDojoRank__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private closeBtn UIDojoRank__Generate_closeBtn
---@field private rankScroll UIDojoRank__Generate_rankScroll
---@field private rankContent UIDojoRank__Generate_rankContent
---@field private toggleGroup UIDojoRank__Generate_toggleGroup
---@field private curSeasonToggle UIDojoRank__Generate_curSeasonToggle
---@field private lastSeasonToggle UIDojoRank__Generate_lastSeasonToggle
---@field private emptyNode UnityEngine.GameObject
---@field private rank UIDojoRank__Generate_rank
---@field private danIcon UIDojoRank__Generate_danIcon
---@field private danName UIDojoRank__Generate_danName
---@field private viewBtn UIDojoRank__Generate_viewBtn
---@field private headItem UIDojoRank__Generate_headItem
---@field private vipIcon UIDojoRank__Generate_vipIcon
---@field private playerName UIDojoRank__Generate_playerName
---@field private fighterPower UIDojoRank__Generate_fighterPower
local UIDojoRankView = class("UIDojoRankView", require("UIViewBase"))

function UIDojoRankView:ctor()
end

---@private
function UIDojoRankView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIDojoRankView:InitGenerate(Root, data)
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


end

---@private
function UIDojoRankView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIDojoRankView:InitGenerate__2(Root, data)
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
function UIDojoRankView:InitGenerate__3(Root, data)
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
function UIDojoRankView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window
--]]
	local tmp = Root:Find("UIAnimator/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp
end

---@private
function UIDojoRankView:InitGenerate__5(Root, data)
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
function UIDojoRankView:InitGenerate__6(Root, data)
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
function UIDojoRankView:InitGenerate__7(Root, data)
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
function UIDojoRankView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/ToggleGroup
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/ToggleGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleGroup = tmp

	tmp.toggleGroup = tmp:GetComponent(Enum.TypeInfo.ToggleGroup)
end

---@private
function UIDojoRankView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/ToggleGroup/CurrentSeason
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/ToggleGroup/CurrentSeason").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curSeasonToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIDojoRankView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/CenterView/ToggleGroup/LastSeason
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CenterView/ToggleGroup/LastSeason").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lastSeasonToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIDojoRankView:InitGenerate__11(Root, data)
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
function UIDojoRankView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRankItem/Rank
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRankItem/Rank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rank = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoRankView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRankItem/danIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRankItem/danIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.danIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIDojoRankView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRankItem/danIcon/danNameText
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRankItem/danIcon/danNameText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.danName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoRankView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRankItem/ViewBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRankItem/ViewBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.viewBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojoRankView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRankItem/PlayerNode/HeadBox/HeadItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRankItem/PlayerNode/HeadBox/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIDojoRankView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRankItem/PlayerNode/VipIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRankItem/PlayerNode/VipIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vipIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIDojoRankView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRankItem/PlayerNode/NameText
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRankItem/PlayerNode/NameText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoRankView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/BottomView/SelfRankItem/PlayerNode/fighterPowerVal
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomView/SelfRankItem/PlayerNode/fighterPowerVal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fighterPower = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoRankView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
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
	if tolua.getpeer(self.toggleGroup) ~= nil then
		tolua.setpeer(self.toggleGroup, nil)
	end
	self.toggleGroup = nil
	if tolua.getpeer(self.curSeasonToggle) ~= nil then
		tolua.setpeer(self.curSeasonToggle, nil)
	end
	self.curSeasonToggle = nil
	if tolua.getpeer(self.lastSeasonToggle) ~= nil then
		tolua.setpeer(self.lastSeasonToggle, nil)
	end
	self.lastSeasonToggle = nil
	if tolua.getpeer(self.emptyNode) ~= nil then
		tolua.setpeer(self.emptyNode, nil)
	end
	self.emptyNode = nil
	if tolua.getpeer(self.rank) ~= nil then
		tolua.setpeer(self.rank, nil)
	end
	self.rank = nil
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
return UIDojoRankView