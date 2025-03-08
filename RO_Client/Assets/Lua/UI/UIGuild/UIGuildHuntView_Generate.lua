---@class UIGuildHunt__Generate_btnBack
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildHunt__Generate_condBox_condTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildHunt__Generate_condBox
---@field public gameObject UnityEngine.GameObject
---@field public condTxt UIGuildHunt__Generate_condBox_condTxt

---@class UIGuildHunt__Generate_costBox_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildHunt__Generate_costBox
---@field public gameObject UnityEngine.GameObject
---@field public number UIGuildHunt__Generate_costBox_number

---@class UIGuildHunt__Generate_btnSummon
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildHunt__Generate_btnChallenge
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildHunt__Generate_awardScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopHorizontalScrollRect UnityEngine.UI.LoopHorizontalScrollRect

---@class UIGuildHunt__Generate_btnPlayRule
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildHunt__Generate_btnAward
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildHunt__Generate_btnLog
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildHunt__Generate_btnLeft
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildHunt__Generate_btnRight
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildHunt__Generate_skillItem4
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIGuildHunt__Generate_skillItem3
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIGuildHunt__Generate_skillItem2
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIGuildHunt__Generate_skillItem1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIGuildHunt__Generate_timeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildHunt__Generate_bossName
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIGuildHunt__Generate_bossImg
---@field public gameObject UnityEngine.GameObject
---@field public rawImage UnityEngine.UI.RawImage

---@class UIGuildHunt__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildHunt__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIGuildHunt__Generate_AnyBtn
---@field private bossImg UIGuildHunt__Generate_bossImg
---@field private bossName UIGuildHunt__Generate_bossName
---@field private timer UnityEngine.GameObject
---@field private timeTxt UIGuildHunt__Generate_timeTxt
---@field private skillList UnityEngine.GameObject
---@field private skillItem1 UIGuildHunt__Generate_skillItem1
---@field private skillItem2 UIGuildHunt__Generate_skillItem2
---@field private skillItem3 UIGuildHunt__Generate_skillItem3
---@field private skillItem4 UIGuildHunt__Generate_skillItem4
---@field private btnRight UIGuildHunt__Generate_btnRight
---@field private btnLeft UIGuildHunt__Generate_btnLeft
---@field private btnLog UIGuildHunt__Generate_btnLog
---@field private btnAward UIGuildHunt__Generate_btnAward
---@field private btnPlayRule UIGuildHunt__Generate_btnPlayRule
---@field private awardScrollView UIGuildHunt__Generate_awardScrollView
---@field private btnChallenge UIGuildHunt__Generate_btnChallenge
---@field private btnSummon UIGuildHunt__Generate_btnSummon
---@field private costBox UIGuildHunt__Generate_costBox
---@field private condBox UIGuildHunt__Generate_condBox
---@field private btnBack UIGuildHunt__Generate_btnBack
local UIGuildHuntView = class("UIGuildHuntView", require("UIViewBase"))

function UIGuildHuntView:ctor()
end

---@private
function UIGuildHuntView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildHuntView:InitGenerate(Root, data)
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


end

---@private
function UIGuildHuntView:InitGenerate__1(Root, data)
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
function UIGuildHuntView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/Top/BossImg
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/BossImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossImg = tmp

	tmp.rawImage = tmp:GetComponent(Enum.TypeInfo.RawImage)
end

---@private
function UIGuildHuntView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Top/BossName
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/BossName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIGuildHuntView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Top/Timer
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/Timer").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timer = tmp
end

---@private
function UIGuildHuntView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Top/Timer/TimeTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/Timer/TimeTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildHuntView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Top/SkillList
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/SkillList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillList = tmp
end

---@private
function UIGuildHuntView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Top/SkillList/SkillItem1
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/SkillList/SkillItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillItem1 = CommonUtil.BindGridViewItem2LuaStatic("SkillItem", tmp)
	self.skillItem1.prefabName = "SkillItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIGuildHuntView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Top/SkillList/SkillItem2
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/SkillList/SkillItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillItem2 = CommonUtil.BindGridViewItem2LuaStatic("SkillItem", tmp)
	self.skillItem2.prefabName = "SkillItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIGuildHuntView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Top/SkillList/SkillItem3
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/SkillList/SkillItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillItem3 = CommonUtil.BindGridViewItem2LuaStatic("SkillItem", tmp)
	self.skillItem3.prefabName = "SkillItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIGuildHuntView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Top/SkillList/SkillItem4
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/SkillList/SkillItem4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillItem4 = CommonUtil.BindGridViewItem2LuaStatic("SkillItem", tmp)
	self.skillItem4.prefabName = "SkillItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIGuildHuntView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Top/BtnRight
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/BtnRight").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRight = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildHuntView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Top/BtnLeft
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/BtnLeft").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnLeft = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildHuntView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Top/BtnLog
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/BtnLog").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnLog = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildHuntView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Top/BtnAward
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/BtnAward").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnAward = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildHuntView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Top/BtnPlayRule
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/BtnPlayRule").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPlayRule = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildHuntView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bottom/ChallengeReward/AwardScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/ChallengeReward/AwardScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.awardScrollView = tmp

	tmp.loopHorizontalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopHorizontalScrollRect)
end

---@private
function UIGuildHuntView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnChallenge
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnChallenge").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChallenge = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildHuntView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnSummon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnSummon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSummon = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildHuntView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bottom/CostBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/CostBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.costBox = tmp
end

---@private
function UIGuildHuntView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bottom/CostBox/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/CostBox/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.costBox.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildHuntView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bottom/CondBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/CondBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condBox = tmp
end

---@private
function UIGuildHuntView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bottom/CondBox/CondTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/CondBox/CondTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condBox.condTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildHuntView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBack = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildHuntView:GenerateDestroy()
	if tolua.getpeer(self.condBox.condTxt) ~= nil then
		tolua.setpeer(self.condBox.condTxt, nil)
	end
	if tolua.getpeer(self.costBox.number) ~= nil then
		tolua.setpeer(self.costBox.number, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.bossImg) ~= nil then
		tolua.setpeer(self.bossImg, nil)
	end
	self.bossImg = nil
	if tolua.getpeer(self.bossName) ~= nil then
		tolua.setpeer(self.bossName, nil)
	end
	self.bossName = nil
	if tolua.getpeer(self.timer) ~= nil then
		tolua.setpeer(self.timer, nil)
	end
	self.timer = nil
	if tolua.getpeer(self.timeTxt) ~= nil then
		tolua.setpeer(self.timeTxt, nil)
	end
	self.timeTxt = nil
	if tolua.getpeer(self.skillList) ~= nil then
		tolua.setpeer(self.skillList, nil)
	end
	self.skillList = nil
	if self.skillItem1.GenerateDestroy ~= nil then
		self.skillItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.skillItem1) ~= nil then
		tolua.setpeer(self.skillItem1, nil)
	end
	self.skillItem1 = nil
	if self.skillItem2.GenerateDestroy ~= nil then
		self.skillItem2:GenerateDestroy()
	end
	if tolua.getpeer(self.skillItem2) ~= nil then
		tolua.setpeer(self.skillItem2, nil)
	end
	self.skillItem2 = nil
	if self.skillItem3.GenerateDestroy ~= nil then
		self.skillItem3:GenerateDestroy()
	end
	if tolua.getpeer(self.skillItem3) ~= nil then
		tolua.setpeer(self.skillItem3, nil)
	end
	self.skillItem3 = nil
	if self.skillItem4.GenerateDestroy ~= nil then
		self.skillItem4:GenerateDestroy()
	end
	if tolua.getpeer(self.skillItem4) ~= nil then
		tolua.setpeer(self.skillItem4, nil)
	end
	self.skillItem4 = nil
	if tolua.getpeer(self.btnRight) ~= nil then
		tolua.setpeer(self.btnRight, nil)
	end
	self.btnRight = nil
	if tolua.getpeer(self.btnLeft) ~= nil then
		tolua.setpeer(self.btnLeft, nil)
	end
	self.btnLeft = nil
	if tolua.getpeer(self.btnLog) ~= nil then
		tolua.setpeer(self.btnLog, nil)
	end
	self.btnLog = nil
	if tolua.getpeer(self.btnAward) ~= nil then
		tolua.setpeer(self.btnAward, nil)
	end
	self.btnAward = nil
	if tolua.getpeer(self.btnPlayRule) ~= nil then
		tolua.setpeer(self.btnPlayRule, nil)
	end
	self.btnPlayRule = nil
	if tolua.getpeer(self.awardScrollView) ~= nil then
		tolua.setpeer(self.awardScrollView, nil)
	end
	self.awardScrollView = nil
	if tolua.getpeer(self.btnChallenge) ~= nil then
		tolua.setpeer(self.btnChallenge, nil)
	end
	self.btnChallenge = nil
	if tolua.getpeer(self.btnSummon) ~= nil then
		tolua.setpeer(self.btnSummon, nil)
	end
	self.btnSummon = nil
	if tolua.getpeer(self.costBox) ~= nil then
		tolua.setpeer(self.costBox, nil)
	end
	self.costBox = nil
	if tolua.getpeer(self.condBox) ~= nil then
		tolua.setpeer(self.condBox, nil)
	end
	self.condBox = nil
	if tolua.getpeer(self.btnBack) ~= nil then
		tolua.setpeer(self.btnBack, nil)
	end
	self.btnBack = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildHuntView