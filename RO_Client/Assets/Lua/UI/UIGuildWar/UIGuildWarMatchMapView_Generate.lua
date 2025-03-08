---@class UIGuildWarMatchMap__Generate_btnMatchShop
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public icon UnityEngine.GameObject

---@class UIGuildWarMatchMap__Generate_btnBack
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildWarMatchMap__Generate_matchTime3_timeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildWarMatchMap__Generate_matchTime3_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildWarMatchMap__Generate_matchTime3_title
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class UIGuildWarMatchMap__Generate_matchTime3_bar
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class UIGuildWarMatchMap__Generate_matchTime3
---@field public gameObject UnityEngine.GameObject
---@field public bar UIGuildWarMatchMap__Generate_matchTime3_bar
---@field public title UIGuildWarMatchMap__Generate_matchTime3_title
---@field public nameTxt UIGuildWarMatchMap__Generate_matchTime3_nameTxt
---@field public timeTxt UIGuildWarMatchMap__Generate_matchTime3_timeTxt

---@class UIGuildWarMatchMap__Generate_matchTime2_timeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildWarMatchMap__Generate_matchTime2_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildWarMatchMap__Generate_matchTime2_title
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class UIGuildWarMatchMap__Generate_matchTime2_bar
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class UIGuildWarMatchMap__Generate_matchTime2
---@field public gameObject UnityEngine.GameObject
---@field public bar UIGuildWarMatchMap__Generate_matchTime2_bar
---@field public title UIGuildWarMatchMap__Generate_matchTime2_title
---@field public nameTxt UIGuildWarMatchMap__Generate_matchTime2_nameTxt
---@field public timeTxt UIGuildWarMatchMap__Generate_matchTime2_timeTxt

---@class UIGuildWarMatchMap__Generate_matchTime1_timeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildWarMatchMap__Generate_matchTime1_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildWarMatchMap__Generate_matchTime1_title
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class UIGuildWarMatchMap__Generate_matchTime1_bar
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class UIGuildWarMatchMap__Generate_matchTime1
---@field public gameObject UnityEngine.GameObject
---@field public bar UIGuildWarMatchMap__Generate_matchTime1_bar
---@field public title UIGuildWarMatchMap__Generate_matchTime1_title
---@field public nameTxt UIGuildWarMatchMap__Generate_matchTime1_nameTxt
---@field public timeTxt UIGuildWarMatchMap__Generate_matchTime1_timeTxt

---@class UIGuildWarMatchMap__Generate_btnHelp
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildWarMatchMap__Generate_championItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildWarMatchMap__Generate_guildWarMatchMapSlotItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildWarMatchMap__Generate_line1
---@field public gameObject UnityEngine.GameObject
---@field public lineL UnityEngine.GameObject
---@field public lineR UnityEngine.GameObject

---@class UIGuildWarMatchMap__Generate_line2
---@field public gameObject UnityEngine.GameObject
---@field public lineL UnityEngine.GameObject
---@field public lineR UnityEngine.GameObject

---@class UIGuildWarMatchMap__Generate_line3
---@field public gameObject UnityEngine.GameObject
---@field public lineL UnityEngine.GameObject
---@field public lineR UnityEngine.GameObject

---@class UIGuildWarMatchMap__Generate_line4
---@field public gameObject UnityEngine.GameObject
---@field public lineL UnityEngine.GameObject
---@field public lineR UnityEngine.GameObject

---@class UIGuildWarMatchMap__Generate_line5
---@field public gameObject UnityEngine.GameObject
---@field public lineL UnityEngine.GameObject
---@field public lineR UnityEngine.GameObject

---@class UIGuildWarMatchMap__Generate_line6
---@field public gameObject UnityEngine.GameObject
---@field public lineL UnityEngine.GameObject
---@field public lineR UnityEngine.GameObject

---@class UIGuildWarMatchMap__Generate_line7
---@field public gameObject UnityEngine.GameObject
---@field public lineL UnityEngine.GameObject
---@field public lineR UnityEngine.GameObject

---@class UIGuildWarMatchMap__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildWarMatchMap__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIGuildWarMatchMap__Generate_AnyBtn
---@field private matchMap UnityEngine.GameObject
---@field private line7 UIGuildWarMatchMap__Generate_line7
---@field private line6 UIGuildWarMatchMap__Generate_line6
---@field private line5 UIGuildWarMatchMap__Generate_line5
---@field private line4 UIGuildWarMatchMap__Generate_line4
---@field private line3 UIGuildWarMatchMap__Generate_line3
---@field private line2 UIGuildWarMatchMap__Generate_line2
---@field private line1 UIGuildWarMatchMap__Generate_line1
---@field private baseSlotParent UnityEngine.GameObject
---@field private guildSlotParent UnityEngine.GameObject
---@field private guildWarMatchMapSlotItem UIGuildWarMatchMap__Generate_guildWarMatchMapSlotItem
---@field private handleSlotParent UnityEngine.GameObject
---@field private championItem UIGuildWarMatchMap__Generate_championItem
---@field private btnHelp UIGuildWarMatchMap__Generate_btnHelp
---@field private bottom UnityEngine.GameObject
---@field private matchTime1 UIGuildWarMatchMap__Generate_matchTime1
---@field private matchTime2 UIGuildWarMatchMap__Generate_matchTime2
---@field private matchTime3 UIGuildWarMatchMap__Generate_matchTime3
---@field private btnBack UIGuildWarMatchMap__Generate_btnBack
---@field private btnMatchShop UIGuildWarMatchMap__Generate_btnMatchShop
local UIGuildWarMatchMapView = class("UIGuildWarMatchMapView", require("UIViewBase"))

function UIGuildWarMatchMapView:ctor()
end

---@private
function UIGuildWarMatchMapView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildWarMatchMapView:InitGenerate(Root, data)
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
	self:InitGenerate__37(Root,data)
	self:InitGenerate__38(Root,data)
	self:InitGenerate__39(Root,data)
	self:InitGenerate__40(Root,data)
	self:InitGenerate__41(Root,data)
	self:InitGenerate__42(Root,data)
	self:InitGenerate__43(Root,data)
	self:InitGenerate__44(Root,data)
	self:InitGenerate__45(Root,data)
	self:InitGenerate__46(Root,data)
	self:InitGenerate__47(Root,data)
	self:InitGenerate__48(Root,data)


end

---@private
function UIGuildWarMatchMapView:InitGenerate__1(Root, data)
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
function UIGuildWarMatchMapView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/MatchMap
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchMap = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line7
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line7").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line7 = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line7/LineL
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line7/LineL").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line7.lineL = tmp
	self.line7.lineL:SetActive(false)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line7/LineR
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line7/LineR").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line7.lineR = tmp
	self.line7.lineR:SetActive(false)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line6
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line6").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line6 = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line6/LineL
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line6/LineL").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line6.lineL = tmp
	self.line6.lineL:SetActive(false)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line6/LineR
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line6/LineR").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line6.lineR = tmp
	self.line6.lineR:SetActive(false)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line5
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line5 = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line5/LineL
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line5/LineL").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line5.lineL = tmp
	self.line5.lineL:SetActive(false)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line5/LineR
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line5/LineR").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line5.lineR = tmp
	self.line5.lineR:SetActive(false)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line4
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line4 = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line4/LineL
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line4/LineL").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line4.lineL = tmp
	self.line4.lineL:SetActive(false)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line4/LineR
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line4/LineR").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line4.lineR = tmp
	self.line4.lineR:SetActive(false)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line3
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line3 = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line3/LineL
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line3/LineL").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line3.lineL = tmp
	self.line3.lineL:SetActive(false)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line3/LineR
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line3/LineR").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line3.lineR = tmp
	self.line3.lineR:SetActive(false)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line2
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line2 = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line2/LineL
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line2/LineL").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line2.lineL = tmp
	self.line2.lineL:SetActive(false)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line2/LineR
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line2/LineR").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line2.lineR = tmp
	self.line2.lineR:SetActive(false)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line1
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line1 = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line1/LineL
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line1/LineL").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line1.lineL = tmp
	self.line1.lineL:SetActive(false)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/MatchMap/PassLine/Line1/LineR
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/PassLine/Line1/LineR").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.line1.lineR = tmp
	self.line1.lineR:SetActive(false)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/MatchMap/BaseSlotParent
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/BaseSlotParent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.baseSlotParent = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/MatchMap/GuildSlotParent
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/GuildSlotParent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildSlotParent = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/MatchMap/GuildSlotParent/GuildWarMatchMapSlotItem
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/GuildSlotParent/GuildWarMatchMapSlotItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildWarMatchMapSlotItem = CommonUtil.BindGridViewItem2LuaStatic("GuildWarMatchMapSlotItem", tmp)
	self.guildWarMatchMapSlotItem.prefabName = "GuildWarMatchMapSlotItem"
	self.guildWarMatchMapSlotItem:SetActive(false)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/MatchMap/HandleSlotParent
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/HandleSlotParent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.handleSlotParent = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/MatchMap/ChampionItem
--]]
	local tmp = Root:Find("UIAnimator/Window/MatchMap/ChampionItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.championItem = CommonUtil.BindGridViewItem2LuaStatic("GuildWarMatchMapSlotItem", tmp)
	self.championItem.prefabName = "GuildWarMatchMapSlotItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/UIBoardTitle/Image/BtnHelp
--]]
	local tmp = Root:Find("UIAnimator/Window/UIBoardTitle/Image/BtnHelp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnHelp = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__30(Root, data)
--[[
	UIAnimator/Window/Bottom
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottom = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__31(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime1 = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__32(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime1/Bar
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime1/Bar").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime1.bar = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__33(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime1/Title
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime1/Title").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime1.title = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__34(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime1/NameTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime1/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime1.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__35(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime1/TimeTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime1/TimeTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime1.timeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__36(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime2 = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__37(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime2/Bar
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime2/Bar").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime2.bar = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__38(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime2/Title
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime2/Title").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime2.title = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__39(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime2/NameTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime2/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime2.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__40(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime2/TimeTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime2/TimeTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime2.timeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__41(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime3 = tmp
end

---@private
function UIGuildWarMatchMapView:InitGenerate__42(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime3/Bar
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime3/Bar").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime3.bar = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__43(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime3/Title
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime3/Title").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime3.title = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__44(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime3/NameTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime3/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime3.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__45(Root, data)
--[[
	UIAnimator/Window/Bottom/Image/Timer/MatchTime3/TimeTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Image/Timer/MatchTime3/TimeTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.matchTime3.timeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__46(Root, data)
--[[
	UIAnimator/Window/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBack = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__47(Root, data)
--[[
	UIAnimator/Window/BtnMatchShop
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnMatchShop").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnMatchShop = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildWarMatchMapView:InitGenerate__48(Root, data)
--[[
	UIAnimator/Window/BtnMatchShop/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnMatchShop/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnMatchShop.icon = tmp
end

---@private
function UIGuildWarMatchMapView:GenerateDestroy()
	if tolua.getpeer(self.btnMatchShop.icon) ~= nil then
		tolua.setpeer(self.btnMatchShop.icon, nil)
	end
	if tolua.getpeer(self.matchTime3.timeTxt) ~= nil then
		tolua.setpeer(self.matchTime3.timeTxt, nil)
	end
	if tolua.getpeer(self.matchTime3.nameTxt) ~= nil then
		tolua.setpeer(self.matchTime3.nameTxt, nil)
	end
	if tolua.getpeer(self.matchTime3.title) ~= nil then
		tolua.setpeer(self.matchTime3.title, nil)
	end
	if tolua.getpeer(self.matchTime3.bar) ~= nil then
		tolua.setpeer(self.matchTime3.bar, nil)
	end
	if tolua.getpeer(self.matchTime2.timeTxt) ~= nil then
		tolua.setpeer(self.matchTime2.timeTxt, nil)
	end
	if tolua.getpeer(self.matchTime2.nameTxt) ~= nil then
		tolua.setpeer(self.matchTime2.nameTxt, nil)
	end
	if tolua.getpeer(self.matchTime2.title) ~= nil then
		tolua.setpeer(self.matchTime2.title, nil)
	end
	if tolua.getpeer(self.matchTime2.bar) ~= nil then
		tolua.setpeer(self.matchTime2.bar, nil)
	end
	if tolua.getpeer(self.matchTime1.timeTxt) ~= nil then
		tolua.setpeer(self.matchTime1.timeTxt, nil)
	end
	if tolua.getpeer(self.matchTime1.nameTxt) ~= nil then
		tolua.setpeer(self.matchTime1.nameTxt, nil)
	end
	if tolua.getpeer(self.matchTime1.title) ~= nil then
		tolua.setpeer(self.matchTime1.title, nil)
	end
	if tolua.getpeer(self.matchTime1.bar) ~= nil then
		tolua.setpeer(self.matchTime1.bar, nil)
	end
	if tolua.getpeer(self.line1.lineR) ~= nil then
		tolua.setpeer(self.line1.lineR, nil)
	end
	if tolua.getpeer(self.line1.lineL) ~= nil then
		tolua.setpeer(self.line1.lineL, nil)
	end
	if tolua.getpeer(self.line2.lineR) ~= nil then
		tolua.setpeer(self.line2.lineR, nil)
	end
	if tolua.getpeer(self.line2.lineL) ~= nil then
		tolua.setpeer(self.line2.lineL, nil)
	end
	if tolua.getpeer(self.line3.lineR) ~= nil then
		tolua.setpeer(self.line3.lineR, nil)
	end
	if tolua.getpeer(self.line3.lineL) ~= nil then
		tolua.setpeer(self.line3.lineL, nil)
	end
	if tolua.getpeer(self.line4.lineR) ~= nil then
		tolua.setpeer(self.line4.lineR, nil)
	end
	if tolua.getpeer(self.line4.lineL) ~= nil then
		tolua.setpeer(self.line4.lineL, nil)
	end
	if tolua.getpeer(self.line5.lineR) ~= nil then
		tolua.setpeer(self.line5.lineR, nil)
	end
	if tolua.getpeer(self.line5.lineL) ~= nil then
		tolua.setpeer(self.line5.lineL, nil)
	end
	if tolua.getpeer(self.line6.lineR) ~= nil then
		tolua.setpeer(self.line6.lineR, nil)
	end
	if tolua.getpeer(self.line6.lineL) ~= nil then
		tolua.setpeer(self.line6.lineL, nil)
	end
	if tolua.getpeer(self.line7.lineR) ~= nil then
		tolua.setpeer(self.line7.lineR, nil)
	end
	if tolua.getpeer(self.line7.lineL) ~= nil then
		tolua.setpeer(self.line7.lineL, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.matchMap) ~= nil then
		tolua.setpeer(self.matchMap, nil)
	end
	self.matchMap = nil
	if tolua.getpeer(self.line7) ~= nil then
		tolua.setpeer(self.line7, nil)
	end
	self.line7 = nil
	if tolua.getpeer(self.line6) ~= nil then
		tolua.setpeer(self.line6, nil)
	end
	self.line6 = nil
	if tolua.getpeer(self.line5) ~= nil then
		tolua.setpeer(self.line5, nil)
	end
	self.line5 = nil
	if tolua.getpeer(self.line4) ~= nil then
		tolua.setpeer(self.line4, nil)
	end
	self.line4 = nil
	if tolua.getpeer(self.line3) ~= nil then
		tolua.setpeer(self.line3, nil)
	end
	self.line3 = nil
	if tolua.getpeer(self.line2) ~= nil then
		tolua.setpeer(self.line2, nil)
	end
	self.line2 = nil
	if tolua.getpeer(self.line1) ~= nil then
		tolua.setpeer(self.line1, nil)
	end
	self.line1 = nil
	if tolua.getpeer(self.baseSlotParent) ~= nil then
		tolua.setpeer(self.baseSlotParent, nil)
	end
	self.baseSlotParent = nil
	if tolua.getpeer(self.guildSlotParent) ~= nil then
		tolua.setpeer(self.guildSlotParent, nil)
	end
	self.guildSlotParent = nil
	if self.guildWarMatchMapSlotItem.GenerateDestroy ~= nil then
		self.guildWarMatchMapSlotItem:GenerateDestroy()
	end
	if tolua.getpeer(self.guildWarMatchMapSlotItem) ~= nil then
		tolua.setpeer(self.guildWarMatchMapSlotItem, nil)
	end
	self.guildWarMatchMapSlotItem = nil
	if tolua.getpeer(self.handleSlotParent) ~= nil then
		tolua.setpeer(self.handleSlotParent, nil)
	end
	self.handleSlotParent = nil
	if self.championItem.GenerateDestroy ~= nil then
		self.championItem:GenerateDestroy()
	end
	if tolua.getpeer(self.championItem) ~= nil then
		tolua.setpeer(self.championItem, nil)
	end
	self.championItem = nil
	if tolua.getpeer(self.btnHelp) ~= nil then
		tolua.setpeer(self.btnHelp, nil)
	end
	self.btnHelp = nil
	if tolua.getpeer(self.bottom) ~= nil then
		tolua.setpeer(self.bottom, nil)
	end
	self.bottom = nil
	if tolua.getpeer(self.matchTime1) ~= nil then
		tolua.setpeer(self.matchTime1, nil)
	end
	self.matchTime1 = nil
	if tolua.getpeer(self.matchTime2) ~= nil then
		tolua.setpeer(self.matchTime2, nil)
	end
	self.matchTime2 = nil
	if tolua.getpeer(self.matchTime3) ~= nil then
		tolua.setpeer(self.matchTime3, nil)
	end
	self.matchTime3 = nil
	if tolua.getpeer(self.btnBack) ~= nil then
		tolua.setpeer(self.btnBack, nil)
	end
	self.btnBack = nil
	if tolua.getpeer(self.btnMatchShop) ~= nil then
		tolua.setpeer(self.btnMatchShop, nil)
	end
	self.btnMatchShop = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildWarMatchMapView