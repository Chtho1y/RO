---@class UIGuildWarRank__Generate_rankKill
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIGuildWarRank__Generate_rankScore
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIGuildWarRank__Generate_guildWarRankItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildWarRank__Generate_loadingItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIGuildWarRank__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UIGuildWarRank__Generate_areaNumTxt2
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildWarRank__Generate_areaNumTxt1
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildWarRank__Generate_guildNameTxt2
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildWarRank__Generate_guildNameTxt1
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildWarRank__Generate_flag2_result
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class UIGuildWarRank__Generate_flag2_badge
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildWarRank__Generate_flag2
---@field public gameObject UnityEngine.GameObject
---@field public badge UIGuildWarRank__Generate_flag2_badge
---@field public result UIGuildWarRank__Generate_flag2_result

---@class UIGuildWarRank__Generate_flag1_result
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class UIGuildWarRank__Generate_flag1_badge
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGuildWarRank__Generate_flag1
---@field public gameObject UnityEngine.GameObject
---@field public badge UIGuildWarRank__Generate_flag1_badge
---@field public result UIGuildWarRank__Generate_flag1_result

---@class UIGuildWarRank__Generate_scoreTxt2
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIGuildWarRank__Generate_scoreTxt1
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIGuildWarRank__Generate_scoreSlider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class UIGuildWarRank__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildWarRank__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildWarRank__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIGuildWarRank__Generate_AnyBtn
---@field private btnClose UIGuildWarRank__Generate_btnClose
---@field private scoreSlider UIGuildWarRank__Generate_scoreSlider
---@field private scoreTxt1 UIGuildWarRank__Generate_scoreTxt1
---@field private scoreTxt2 UIGuildWarRank__Generate_scoreTxt2
---@field private flag1 UIGuildWarRank__Generate_flag1
---@field private flag2 UIGuildWarRank__Generate_flag2
---@field private guildNameTxt1 UIGuildWarRank__Generate_guildNameTxt1
---@field private guildNameTxt2 UIGuildWarRank__Generate_guildNameTxt2
---@field private areaNumTxt1 UIGuildWarRank__Generate_areaNumTxt1
---@field private areaNumTxt2 UIGuildWarRank__Generate_areaNumTxt2
---@field private scrollView UIGuildWarRank__Generate_scrollView
---@field private loadingItem UIGuildWarRank__Generate_loadingItem
---@field private guildWarRankItem UIGuildWarRank__Generate_guildWarRankItem
---@field private noGuildItem UnityEngine.GameObject
---@field private rankScore UIGuildWarRank__Generate_rankScore
---@field private rankKill UIGuildWarRank__Generate_rankKill
local UIGuildWarRankView = class("UIGuildWarRankView", require("UIViewBase"))

function UIGuildWarRankView:ctor()
end

---@private
function UIGuildWarRankView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildWarRankView:InitGenerate(Root, data)
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


end

---@private
function UIGuildWarRankView:InitGenerate__1(Root, data)
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
function UIGuildWarRankView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildWarRankView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/Top/Battle/ScoreSlider
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/Top/Battle/ScoreSlider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scoreSlider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function UIGuildWarRankView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/Top/Battle/ScoreTxt1
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/Top/Battle/ScoreTxt1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scoreTxt1 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIGuildWarRankView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/Top/Battle/ScoreTxt2
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/Top/Battle/ScoreTxt2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scoreTxt2 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIGuildWarRankView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/Top/Flag1
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/Top/Flag1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.flag1 = tmp
end

---@private
function UIGuildWarRankView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/Top/Flag1/Badge
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/Top/Flag1/Badge").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.flag1.badge = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildWarRankView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/Top/Flag1/Result
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/Top/Flag1/Result").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.flag1.result = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function UIGuildWarRankView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/Top/Flag2
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/Top/Flag2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.flag2 = tmp
end

---@private
function UIGuildWarRankView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/Top/Flag2/Badge
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/Top/Flag2/Badge").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.flag2.badge = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGuildWarRankView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/Top/Flag2/Result
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/Top/Flag2/Result").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.flag2.result = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function UIGuildWarRankView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/Top/GuildNameTxt1
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/Top/GuildNameTxt1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildNameTxt1 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildWarRankView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/Top/GuildNameTxt2
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/Top/GuildNameTxt2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildNameTxt2 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildWarRankView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/Top/AreaNumTxt1
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/Top/AreaNumTxt1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.areaNumTxt1 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildWarRankView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/Top/AreaNumTxt2
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/Top/AreaNumTxt2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.areaNumTxt2 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildWarRankView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/RankList/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/RankList/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIGuildWarRankView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/RankList/ScrollView/Viewport/Content/LoadingItem
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/RankList/ScrollView/Viewport/Content/LoadingItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loadingItem = CommonUtil.BindGridViewItem2LuaStatic("LoadingItem", tmp)
	self.loadingItem.prefabName = "LoadingItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIGuildWarRankView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/RankList/ScrollView/Viewport/Content/GuildWarRankItem
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/RankList/ScrollView/Viewport/Content/GuildWarRankItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildWarRankItem = CommonUtil.BindGridViewItem2LuaStatic("GuildWarRankItem", tmp)
	self.guildWarRankItem.prefabName = "GuildWarRankItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildWarRankView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/RankList/ScrollView/Viewport/Content/NoGuildItem
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/RankList/ScrollView/Viewport/Content/NoGuildItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noGuildItem = tmp
end

---@private
function UIGuildWarRankView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/RankList/ToggleGroup/RankScore
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/RankList/ToggleGroup/RankScore").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankScore = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIGuildWarRankView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/UIWindowBG/RankList/ToggleGroup/RankKill
--]]
	local tmp = Root:Find("UIAnimator/Window/UIWindowBG/RankList/ToggleGroup/RankKill").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankKill = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIGuildWarRankView:GenerateDestroy()
	if tolua.getpeer(self.flag2.result) ~= nil then
		tolua.setpeer(self.flag2.result, nil)
	end
	if tolua.getpeer(self.flag2.badge) ~= nil then
		tolua.setpeer(self.flag2.badge, nil)
	end
	if tolua.getpeer(self.flag1.result) ~= nil then
		tolua.setpeer(self.flag1.result, nil)
	end
	if tolua.getpeer(self.flag1.badge) ~= nil then
		tolua.setpeer(self.flag1.badge, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.scoreSlider) ~= nil then
		tolua.setpeer(self.scoreSlider, nil)
	end
	self.scoreSlider = nil
	if tolua.getpeer(self.scoreTxt1) ~= nil then
		tolua.setpeer(self.scoreTxt1, nil)
	end
	self.scoreTxt1 = nil
	if tolua.getpeer(self.scoreTxt2) ~= nil then
		tolua.setpeer(self.scoreTxt2, nil)
	end
	self.scoreTxt2 = nil
	if tolua.getpeer(self.flag1) ~= nil then
		tolua.setpeer(self.flag1, nil)
	end
	self.flag1 = nil
	if tolua.getpeer(self.flag2) ~= nil then
		tolua.setpeer(self.flag2, nil)
	end
	self.flag2 = nil
	if tolua.getpeer(self.guildNameTxt1) ~= nil then
		tolua.setpeer(self.guildNameTxt1, nil)
	end
	self.guildNameTxt1 = nil
	if tolua.getpeer(self.guildNameTxt2) ~= nil then
		tolua.setpeer(self.guildNameTxt2, nil)
	end
	self.guildNameTxt2 = nil
	if tolua.getpeer(self.areaNumTxt1) ~= nil then
		tolua.setpeer(self.areaNumTxt1, nil)
	end
	self.areaNumTxt1 = nil
	if tolua.getpeer(self.areaNumTxt2) ~= nil then
		tolua.setpeer(self.areaNumTxt2, nil)
	end
	self.areaNumTxt2 = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if self.loadingItem.GenerateDestroy ~= nil then
		self.loadingItem:GenerateDestroy()
	end
	if tolua.getpeer(self.loadingItem) ~= nil then
		tolua.setpeer(self.loadingItem, nil)
	end
	self.loadingItem = nil
	if self.guildWarRankItem.GenerateDestroy ~= nil then
		self.guildWarRankItem:GenerateDestroy()
	end
	if tolua.getpeer(self.guildWarRankItem) ~= nil then
		tolua.setpeer(self.guildWarRankItem, nil)
	end
	self.guildWarRankItem = nil
	if tolua.getpeer(self.noGuildItem) ~= nil then
		tolua.setpeer(self.noGuildItem, nil)
	end
	self.noGuildItem = nil
	if tolua.getpeer(self.rankScore) ~= nil then
		tolua.setpeer(self.rankScore, nil)
	end
	self.rankScore = nil
	if tolua.getpeer(self.rankKill) ~= nil then
		tolua.setpeer(self.rankKill, nil)
	end
	self.rankKill = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildWarRankView