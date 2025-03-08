---@class UIDojo2D__Generate_fighterPowerText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojo2D__Generate_nextSeasonTimeText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojo2D__Generate_matchBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojo2D__Generate_buyTimesBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojo2D__Generate_leftTimesText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojo2D__Generate_backBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojo2D__Generate_hero6
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIDojo2D__Generate_hero5
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIDojo2D__Generate_hero4
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIDojo2D__Generate_hero3
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIDojo2D__Generate_hero2
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIDojo2D__Generate_hero1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIDojo2D__Generate_playRuleBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojo2D__Generate_leftRewardTimesText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojo2D__Generate_seasonEndTimeText_lbl
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojo2D__Generate_seasonEndTimeText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public lbl UIDojo2D__Generate_seasonEndTimeText_lbl

---@class UIDojo2D__Generate_scoreSlider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class UIDojo2D__Generate_curRankScoreText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojo2D__Generate_rewardItemName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojo2D__Generate_rewardItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIDojo2D__Generate_rewardIcon
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojo2D__Generate_winRateText
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIDojo2D__Generate_rankIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIDojo2D__Generate_rankName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojo2D__Generate_skillBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojo2D__Generate_shopBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojo2D__Generate_rankBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojo2D__Generate_battleReportBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojo2D__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private selectedHero1 UnityEngine.GameObject
---@field private selectedHero2 UnityEngine.GameObject
---@field private selectedHero3 UnityEngine.GameObject
---@field private selectedHero4 UnityEngine.GameObject
---@field private battleReportBtn UIDojo2D__Generate_battleReportBtn
---@field private rankBtn UIDojo2D__Generate_rankBtn
---@field private shopBtn UIDojo2D__Generate_shopBtn
---@field private skillBtn UIDojo2D__Generate_skillBtn
---@field private rankName UIDojo2D__Generate_rankName
---@field private rankIcon UIDojo2D__Generate_rankIcon
---@field private winRateText UIDojo2D__Generate_winRateText
---@field private rewardIcon UIDojo2D__Generate_rewardIcon
---@field private rewardItem UIDojo2D__Generate_rewardItem
---@field private rewardItemName UIDojo2D__Generate_rewardItemName
---@field private curRankScoreText UIDojo2D__Generate_curRankScoreText
---@field private scoreSlider UIDojo2D__Generate_scoreSlider
---@field private seasonEndTimeText UIDojo2D__Generate_seasonEndTimeText
---@field private leftRewardTimesText UIDojo2D__Generate_leftRewardTimesText
---@field private playRuleBtn UIDojo2D__Generate_playRuleBtn
---@field private roleList UnityEngine.GameObject
---@field private roleListAnim UnityEngine.GameObject
---@field private hero1 UIDojo2D__Generate_hero1
---@field private hero2 UIDojo2D__Generate_hero2
---@field private hero3 UIDojo2D__Generate_hero3
---@field private hero4 UIDojo2D__Generate_hero4
---@field private hero5 UIDojo2D__Generate_hero5
---@field private hero6 UIDojo2D__Generate_hero6
---@field private backBtn UIDojo2D__Generate_backBtn
---@field private curSeasonNode UnityEngine.GameObject
---@field private leftTimesText UIDojo2D__Generate_leftTimesText
---@field private buyTimesBtn UIDojo2D__Generate_buyTimesBtn
---@field private matchBtn UIDojo2D__Generate_matchBtn
---@field private nextSeasonNode UnityEngine.GameObject
---@field private nextSeasonTimeText UIDojo2D__Generate_nextSeasonTimeText
---@field private fighterPowerText UIDojo2D__Generate_fighterPowerText
local UIDojo2DView = class("UIDojo2DView", require("UIViewBase"))

function UIDojo2DView:ctor()
end

---@private
function UIDojo2DView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIDojo2DView:InitGenerate(Root, data)
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
	self:InitGenerate__23(Root,data)
	self:InitGenerate__24(Root,data)
	self:InitGenerate__25(Root,data)
	self:InitGenerate__26(Root,data)
	self:InitGenerate__27(Root,data)
	self:InitGenerate__28(Root,data)
	self:InitGenerate__29(Root,data)
	self:InitGenerate__30(Root,data)
	self:InitGenerate__31(Root,data)
	self:InitGenerate__32(Root,data)
	self:InitGenerate__33(Root,data)
	self:InitGenerate__34(Root,data)
	self:InitGenerate__35(Root,data)
	self:InitGenerate__36(Root,data)


end

---@private
function UIDojo2DView:InitGenerate__1(Root, data)
--[[
	CenterView/Character1
--]]
	local tmp = Root:Find("CenterView/Character1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectedHero1 = tmp
end

---@private
function UIDojo2DView:InitGenerate__2(Root, data)
--[[
	CenterView/Character2
--]]
	local tmp = Root:Find("CenterView/Character2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectedHero2 = tmp
end

---@private
function UIDojo2DView:InitGenerate__3(Root, data)
--[[
	CenterView/Character3
--]]
	local tmp = Root:Find("CenterView/Character3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectedHero3 = tmp
end

---@private
function UIDojo2DView:InitGenerate__4(Root, data)
--[[
	CenterView/Character4
--]]
	local tmp = Root:Find("CenterView/Character4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectedHero4 = tmp
end

---@private
function UIDojo2DView:InitGenerate__5(Root, data)
--[[
	TopView/BtnGroup/BattleReportBtn
--]]
	local tmp = Root:Find("TopView/BtnGroup/BattleReportBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.battleReportBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojo2DView:InitGenerate__6(Root, data)
--[[
	TopView/BtnGroup/RankBtn
--]]
	local tmp = Root:Find("TopView/BtnGroup/RankBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojo2DView:InitGenerate__7(Root, data)
--[[
	TopView/BtnGroup/ShopBtn
--]]
	local tmp = Root:Find("TopView/BtnGroup/ShopBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.shopBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojo2DView:InitGenerate__8(Root, data)
--[[
	TopView/BtnGroup/SkillBtn
--]]
	local tmp = Root:Find("TopView/BtnGroup/SkillBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojo2DView:InitGenerate__9(Root, data)
--[[
	TopView/BattleInfo/RankInfo/RankName
--]]
	local tmp = Root:Find("TopView/BattleInfo/RankInfo/RankName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojo2DView:InitGenerate__10(Root, data)
--[[
	TopView/BattleInfo/RankInfo/RankIcon
--]]
	local tmp = Root:Find("TopView/BattleInfo/RankInfo/RankIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIDojo2DView:InitGenerate__11(Root, data)
--[[
	TopView/BattleInfo/RankInfo/WinRate/Val
--]]
	local tmp = Root:Find("TopView/BattleInfo/RankInfo/WinRate/Val").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.winRateText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIDojo2DView:InitGenerate__12(Root, data)
--[[
	TopView/BattleInfo/Left/RewardIcon
--]]
	local tmp = Root:Find("TopView/BattleInfo/Left/RewardIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardIcon = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojo2DView:InitGenerate__13(Root, data)
--[[
	TopView/BattleInfo/Left/IconSmallItem
--]]
	local tmp = Root:Find("TopView/BattleInfo/Left/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.rewardItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIDojo2DView:InitGenerate__14(Root, data)
--[[
	TopView/BattleInfo/Left/ItemName
--]]
	local tmp = Root:Find("TopView/BattleInfo/Left/ItemName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardItemName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojo2DView:InitGenerate__15(Root, data)
--[[
	TopView/BattleInfo/Right/RankScore/Val
--]]
	local tmp = Root:Find("TopView/BattleInfo/Right/RankScore/Val").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curRankScoreText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojo2DView:InitGenerate__16(Root, data)
--[[
	TopView/BattleInfo/Right/RankScore/Slider
--]]
	local tmp = Root:Find("TopView/BattleInfo/Right/RankScore/Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scoreSlider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function UIDojo2DView:InitGenerate__17(Root, data)
--[[
	TopView/BattleInfo/Right/RankTime/Val
--]]
	local tmp = Root:Find("TopView/BattleInfo/Right/RankTime/Val").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.seasonEndTimeText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojo2DView:InitGenerate__18(Root, data)
--[[
	TopView/BattleInfo/Right/RankTime/Val/Lbl
--]]
	local tmp = Root:Find("TopView/BattleInfo/Right/RankTime/Val/Lbl").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.seasonEndTimeText.lbl = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojo2DView:InitGenerate__19(Root, data)
--[[
	TopView/LeftRewardTimes
--]]
	local tmp = Root:Find("TopView/LeftRewardTimes").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftRewardTimesText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojo2DView:InitGenerate__20(Root, data)
--[[
	TopView/BtnPlayRule
--]]
	local tmp = Root:Find("TopView/BtnPlayRule").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playRuleBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojo2DView:InitGenerate__21(Root, data)
--[[
	BottomView/RoleList
--]]
	local tmp = Root:Find("BottomView/RoleList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.roleList = tmp
end

---@private
function UIDojo2DView:InitGenerate__22(Root, data)
--[[
	BottomView/RoleList/RoleListAnim
--]]
	local tmp = Root:Find("BottomView/RoleList/RoleListAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.roleListAnim = tmp
end

---@private
function UIDojo2DView:InitGenerate__23(Root, data)
--[[
	BottomView/RoleList/RoleListAnim/Role1
--]]
	local tmp = Root:Find("BottomView/RoleList/RoleListAnim/Role1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero1 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIDojo2DView:InitGenerate__24(Root, data)
--[[
	BottomView/RoleList/RoleListAnim/Role2
--]]
	local tmp = Root:Find("BottomView/RoleList/RoleListAnim/Role2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero2 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIDojo2DView:InitGenerate__25(Root, data)
--[[
	BottomView/RoleList/RoleListAnim/Role3
--]]
	local tmp = Root:Find("BottomView/RoleList/RoleListAnim/Role3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero3 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIDojo2DView:InitGenerate__26(Root, data)
--[[
	BottomView/RoleList/RoleListAnim/Role4
--]]
	local tmp = Root:Find("BottomView/RoleList/RoleListAnim/Role4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero4 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIDojo2DView:InitGenerate__27(Root, data)
--[[
	BottomView/RoleList/RoleListAnim/Role5
--]]
	local tmp = Root:Find("BottomView/RoleList/RoleListAnim/Role5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero5 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIDojo2DView:InitGenerate__28(Root, data)
--[[
	BottomView/RoleList/RoleListAnim/Role6
--]]
	local tmp = Root:Find("BottomView/RoleList/RoleListAnim/Role6").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero6 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIDojo2DView:InitGenerate__29(Root, data)
--[[
	BottomView/BtnBack
--]]
	local tmp = Root:Find("BottomView/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.backBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojo2DView:InitGenerate__30(Root, data)
--[[
	BottomView/SeasonInfo
--]]
	local tmp = Root:Find("BottomView/SeasonInfo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curSeasonNode = tmp
end

---@private
function UIDojo2DView:InitGenerate__31(Root, data)
--[[
	BottomView/SeasonInfo/LeftTimes/Val
--]]
	local tmp = Root:Find("BottomView/SeasonInfo/LeftTimes/Val").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftTimesText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojo2DView:InitGenerate__32(Root, data)
--[[
	BottomView/SeasonInfo/LeftTimes/AddBtn
--]]
	local tmp = Root:Find("BottomView/SeasonInfo/LeftTimes/AddBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buyTimesBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojo2DView:InitGenerate__33(Root, data)
--[[
	BottomView/SeasonInfo/MatchBtn
--]]
	local tmp = Root:Find("BottomView/SeasonInfo/MatchBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojo2DView:InitGenerate__34(Root, data)
--[[
	BottomView/NextSeasonInfo
--]]
	local tmp = Root:Find("BottomView/NextSeasonInfo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextSeasonNode = tmp
end

---@private
function UIDojo2DView:InitGenerate__35(Root, data)
--[[
	BottomView/NextSeasonInfo/Time
--]]
	local tmp = Root:Find("BottomView/NextSeasonInfo/Time").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nextSeasonTimeText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojo2DView:InitGenerate__36(Root, data)
--[[
	BottomView/FightPowerInfo/Val
--]]
	local tmp = Root:Find("BottomView/FightPowerInfo/Val").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fighterPowerText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojo2DView:GenerateDestroy()
	if tolua.getpeer(self.seasonEndTimeText.lbl) ~= nil then
		tolua.setpeer(self.seasonEndTimeText.lbl, nil)
	end
	if tolua.getpeer(self.selectedHero1) ~= nil then
		tolua.setpeer(self.selectedHero1, nil)
	end
	self.selectedHero1 = nil
	if tolua.getpeer(self.selectedHero2) ~= nil then
		tolua.setpeer(self.selectedHero2, nil)
	end
	self.selectedHero2 = nil
	if tolua.getpeer(self.selectedHero3) ~= nil then
		tolua.setpeer(self.selectedHero3, nil)
	end
	self.selectedHero3 = nil
	if tolua.getpeer(self.selectedHero4) ~= nil then
		tolua.setpeer(self.selectedHero4, nil)
	end
	self.selectedHero4 = nil
	if tolua.getpeer(self.battleReportBtn) ~= nil then
		tolua.setpeer(self.battleReportBtn, nil)
	end
	self.battleReportBtn = nil
	if tolua.getpeer(self.rankBtn) ~= nil then
		tolua.setpeer(self.rankBtn, nil)
	end
	self.rankBtn = nil
	if tolua.getpeer(self.shopBtn) ~= nil then
		tolua.setpeer(self.shopBtn, nil)
	end
	self.shopBtn = nil
	if tolua.getpeer(self.skillBtn) ~= nil then
		tolua.setpeer(self.skillBtn, nil)
	end
	self.skillBtn = nil
	if tolua.getpeer(self.rankName) ~= nil then
		tolua.setpeer(self.rankName, nil)
	end
	self.rankName = nil
	if tolua.getpeer(self.rankIcon) ~= nil then
		tolua.setpeer(self.rankIcon, nil)
	end
	self.rankIcon = nil
	if tolua.getpeer(self.winRateText) ~= nil then
		tolua.setpeer(self.winRateText, nil)
	end
	self.winRateText = nil
	if tolua.getpeer(self.rewardIcon) ~= nil then
		tolua.setpeer(self.rewardIcon, nil)
	end
	self.rewardIcon = nil
	if self.rewardItem.GenerateDestroy ~= nil then
		self.rewardItem:GenerateDestroy()
	end
	if tolua.getpeer(self.rewardItem) ~= nil then
		tolua.setpeer(self.rewardItem, nil)
	end
	self.rewardItem = nil
	if tolua.getpeer(self.rewardItemName) ~= nil then
		tolua.setpeer(self.rewardItemName, nil)
	end
	self.rewardItemName = nil
	if tolua.getpeer(self.curRankScoreText) ~= nil then
		tolua.setpeer(self.curRankScoreText, nil)
	end
	self.curRankScoreText = nil
	if tolua.getpeer(self.scoreSlider) ~= nil then
		tolua.setpeer(self.scoreSlider, nil)
	end
	self.scoreSlider = nil
	if tolua.getpeer(self.seasonEndTimeText) ~= nil then
		tolua.setpeer(self.seasonEndTimeText, nil)
	end
	self.seasonEndTimeText = nil
	if tolua.getpeer(self.leftRewardTimesText) ~= nil then
		tolua.setpeer(self.leftRewardTimesText, nil)
	end
	self.leftRewardTimesText = nil
	if tolua.getpeer(self.playRuleBtn) ~= nil then
		tolua.setpeer(self.playRuleBtn, nil)
	end
	self.playRuleBtn = nil
	if tolua.getpeer(self.roleList) ~= nil then
		tolua.setpeer(self.roleList, nil)
	end
	self.roleList = nil
	if tolua.getpeer(self.roleListAnim) ~= nil then
		tolua.setpeer(self.roleListAnim, nil)
	end
	self.roleListAnim = nil
	if tolua.getpeer(self.hero1) ~= nil then
		tolua.setpeer(self.hero1, nil)
	end
	self.hero1 = nil
	if tolua.getpeer(self.hero2) ~= nil then
		tolua.setpeer(self.hero2, nil)
	end
	self.hero2 = nil
	if tolua.getpeer(self.hero3) ~= nil then
		tolua.setpeer(self.hero3, nil)
	end
	self.hero3 = nil
	if tolua.getpeer(self.hero4) ~= nil then
		tolua.setpeer(self.hero4, nil)
	end
	self.hero4 = nil
	if tolua.getpeer(self.hero5) ~= nil then
		tolua.setpeer(self.hero5, nil)
	end
	self.hero5 = nil
	if tolua.getpeer(self.hero6) ~= nil then
		tolua.setpeer(self.hero6, nil)
	end
	self.hero6 = nil
	if tolua.getpeer(self.backBtn) ~= nil then
		tolua.setpeer(self.backBtn, nil)
	end
	self.backBtn = nil
	if tolua.getpeer(self.curSeasonNode) ~= nil then
		tolua.setpeer(self.curSeasonNode, nil)
	end
	self.curSeasonNode = nil
	if tolua.getpeer(self.leftTimesText) ~= nil then
		tolua.setpeer(self.leftTimesText, nil)
	end
	self.leftTimesText = nil
	if tolua.getpeer(self.buyTimesBtn) ~= nil then
		tolua.setpeer(self.buyTimesBtn, nil)
	end
	self.buyTimesBtn = nil
	if tolua.getpeer(self.matchBtn) ~= nil then
		tolua.setpeer(self.matchBtn, nil)
	end
	self.matchBtn = nil
	if tolua.getpeer(self.nextSeasonNode) ~= nil then
		tolua.setpeer(self.nextSeasonNode, nil)
	end
	self.nextSeasonNode = nil
	if tolua.getpeer(self.nextSeasonTimeText) ~= nil then
		tolua.setpeer(self.nextSeasonTimeText, nil)
	end
	self.nextSeasonTimeText = nil
	if tolua.getpeer(self.fighterPowerText) ~= nil then
		tolua.setpeer(self.fighterPowerText, nil)
	end
	self.fighterPowerText = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIDojo2DView