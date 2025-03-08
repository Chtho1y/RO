---@class UITask__Generate_BtnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UITask__Generate_toggle3
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UITask__Generate_toggle2
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UITask__Generate_toggle1
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UITask__Generate_refreshTaskParent_fakeIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class UITask__Generate_time
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class UITask__Generate_refreshTaskParent_scrollViewRefresh_content
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UITask__Generate_refreshTaskParent_scrollViewRefresh
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UITask__Generate_refreshTaskParent_scrollViewRefresh_content

---@class UITask__Generate_refreshTaskParent_totalScore_box1_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UITask__Generate_refreshTaskParent_totalScore_box1_box
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UITask__Generate_refreshTaskParent_totalScore_box1
---@field public gameObject UnityEngine.GameObject
---@field public box UITask__Generate_refreshTaskParent_totalScore_box1_box
---@field public money UnityEngine.GameObject
---@field public fXParent UnityEngine.GameObject
---@field public tipPoint UnityEngine.GameObject
---@field public num UITask__Generate_refreshTaskParent_totalScore_box1_num

---@class UITask__Generate_refreshTaskParent_totalScore_scrollbar
---@field public gameObject UnityEngine.GameObject
---@field public scrollbar UnityEngine.UI.Scrollbar

---@class UITask__Generate_refreshTaskParent_totalScore_item_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UITask__Generate_refreshTaskParent_totalScore_item_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UITask__Generate_refreshTaskParent_totalScore_item
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public button UnityEngine.UI.Button
---@field public icon UITask__Generate_refreshTaskParent_totalScore_item_icon
---@field public num UITask__Generate_refreshTaskParent_totalScore_item_num

---@class UITask__Generate_refreshTaskParent_totalScore
---@field public gameObject UnityEngine.GameObject
---@field public item UITask__Generate_refreshTaskParent_totalScore_item
---@field public scrollbar UITask__Generate_refreshTaskParent_totalScore_scrollbar
---@field public box1 UITask__Generate_refreshTaskParent_totalScore_box1

---@class UITask__Generate_refreshTaskParent_tipsTxt_RefreshTips
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UITask__Generate_refreshTaskParent_tipsTxt
---@field public gameObject UnityEngine.GameObject
---@field public RefreshTips UITask__Generate_refreshTaskParent_tipsTxt_RefreshTips

---@class UITask__Generate_refreshTaskParent
---@field public gameObject UnityEngine.GameObject
---@field public dailyShow UnityEngine.GameObject
---@field public weeklyShow UnityEngine.GameObject
---@field public tipsTxt UITask__Generate_refreshTaskParent_tipsTxt
---@field public totalScore UITask__Generate_refreshTaskParent_totalScore
---@field public scrollViewRefresh UITask__Generate_refreshTaskParent_scrollViewRefresh
---@field public fakeIcon UITask__Generate_refreshTaskParent_fakeIcon

---@class UITask__Generate_mainTaskParent_scrollViewMain_content
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UITask__Generate_mainTaskParent_scrollViewMain
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UITask__Generate_mainTaskParent_scrollViewMain_content

---@class UITask__Generate_mainTaskParent
---@field public gameObject UnityEngine.GameObject
---@field public scrollViewMain UITask__Generate_mainTaskParent_scrollViewMain

---@class UITask__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UITask__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UITask__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UITask__Generate_uIAnimator
---@field private AnyBtn UITask__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private mainTaskParent UITask__Generate_mainTaskParent
---@field private refreshTaskParent UITask__Generate_refreshTaskParent
---@field private time UITask__Generate_time
---@field private toggle1 UITask__Generate_toggle1
---@field private toggle2 UITask__Generate_toggle2
---@field private toggle3 UITask__Generate_toggle3
---@field private BtnClose UITask__Generate_BtnClose
local UITaskView = class("UITaskView", require("UIViewBase"))

function UITaskView:ctor()
end

---@private
function UITaskView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UITaskView:InitGenerate(Root, data)
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


end

---@private
function UITaskView:InitGenerate__1(Root, data)
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
function UITaskView:InitGenerate__2(Root, data)
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
function UITaskView:InitGenerate__3(Root, data)
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
function UITaskView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/MainTaskParent
--]]
	local tmp = Root:Find("UIAnimator/Window/MainTaskParent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mainTaskParent = tmp
end

---@private
function UITaskView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/MainTaskParent/ScrollViewMain
--]]
	local tmp = Root:Find("UIAnimator/Window/MainTaskParent/ScrollViewMain").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mainTaskParent.scrollViewMain = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UITaskView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/MainTaskParent/ScrollViewMain/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/MainTaskParent/ScrollViewMain/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mainTaskParent.scrollViewMain.content = tmp

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)
end

---@private
function UITaskView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent = tmp
end

---@private
function UITaskView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/DailyShow
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/DailyShow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.dailyShow = tmp
end

---@private
function UITaskView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/WeeklyShow
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/WeeklyShow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.weeklyShow = tmp
end

---@private
function UITaskView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/TipsTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/TipsTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.tipsTxt = tmp
end

---@private
function UITaskView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/TipsTxt/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/TipsTxt/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.tipsTxt.RefreshTips = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UITaskView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/TotalScore
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/TotalScore").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.totalScore = tmp
end

---@private
function UITaskView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/TotalScore/Item
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/TotalScore/Item").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.totalScore.item = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UITaskView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/TotalScore/Item/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/TotalScore/Item/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.totalScore.item.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UITaskView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/TotalScore/Item/Num
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/TotalScore/Item/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.totalScore.item.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UITaskView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/TotalScore/Scrollbar
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/TotalScore/Scrollbar").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.totalScore.scrollbar = tmp

	tmp.scrollbar = tmp:GetComponent(Enum.TypeInfo.Scrollbar)
end

---@private
function UITaskView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/TotalScore/Box1
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/TotalScore/Box1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.totalScore.box1 = tmp
end

---@private
function UITaskView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/TotalScore/Box1/Box
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/TotalScore/Box1/Box").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.totalScore.box1.box = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UITaskView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/TotalScore/Box1/Money
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/TotalScore/Box1/Money").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.totalScore.box1.money = tmp
end

---@private
function UITaskView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/TotalScore/Box1/FXParent
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/TotalScore/Box1/FXParent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.totalScore.box1.fXParent = tmp
end

---@private
function UITaskView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/TotalScore/Box1/TipPoint
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/TotalScore/Box1/TipPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.totalScore.box1.tipPoint = tmp
end

---@private
function UITaskView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/TotalScore/Box1/Num
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/TotalScore/Box1/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.totalScore.box1.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UITaskView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/ScrollViewRefresh
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/ScrollViewRefresh").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.scrollViewRefresh = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UITaskView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/ScrollViewRefresh/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/ScrollViewRefresh/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.scrollViewRefresh.content = tmp

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)
end

---@private
function UITaskView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/Time
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/Time").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.time = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UITaskView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/RefreshTaskParent/FakeIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/RefreshTaskParent/FakeIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refreshTaskParent.fakeIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UITaskView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/Toggle1
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/Toggle1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle1 = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UITaskView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/Toggle2
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/Toggle2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle2 = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UITaskView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/ToggleGroup/Toggle3
--]]
	local tmp = Root:Find("UIAnimator/Window/ToggleGroup/Toggle3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggle3 = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UITaskView:InitGenerate__30(Root, data)
--[[
	UIAnimator/Window/ClostBox/BtnCloseFlat
--]]
	local tmp = Root:Find("UIAnimator/Window/ClostBox/BtnCloseFlat").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.BtnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UITaskView:GenerateDestroy()
	if tolua.getpeer(self.refreshTaskParent.fakeIcon) ~= nil then
		tolua.setpeer(self.refreshTaskParent.fakeIcon, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.scrollViewRefresh.content) ~= nil then
		tolua.setpeer(self.refreshTaskParent.scrollViewRefresh.content, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.scrollViewRefresh) ~= nil then
		tolua.setpeer(self.refreshTaskParent.scrollViewRefresh, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.totalScore.box1.num) ~= nil then
		tolua.setpeer(self.refreshTaskParent.totalScore.box1.num, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.totalScore.box1.tipPoint) ~= nil then
		tolua.setpeer(self.refreshTaskParent.totalScore.box1.tipPoint, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.totalScore.box1.fXParent) ~= nil then
		tolua.setpeer(self.refreshTaskParent.totalScore.box1.fXParent, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.totalScore.box1.money) ~= nil then
		tolua.setpeer(self.refreshTaskParent.totalScore.box1.money, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.totalScore.box1.box) ~= nil then
		tolua.setpeer(self.refreshTaskParent.totalScore.box1.box, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.totalScore.box1) ~= nil then
		tolua.setpeer(self.refreshTaskParent.totalScore.box1, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.totalScore.scrollbar) ~= nil then
		tolua.setpeer(self.refreshTaskParent.totalScore.scrollbar, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.totalScore.item.num) ~= nil then
		tolua.setpeer(self.refreshTaskParent.totalScore.item.num, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.totalScore.item.icon) ~= nil then
		tolua.setpeer(self.refreshTaskParent.totalScore.item.icon, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.totalScore.item) ~= nil then
		tolua.setpeer(self.refreshTaskParent.totalScore.item, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.totalScore) ~= nil then
		tolua.setpeer(self.refreshTaskParent.totalScore, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.tipsTxt.RefreshTips) ~= nil then
		tolua.setpeer(self.refreshTaskParent.tipsTxt.RefreshTips, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.tipsTxt) ~= nil then
		tolua.setpeer(self.refreshTaskParent.tipsTxt, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.weeklyShow) ~= nil then
		tolua.setpeer(self.refreshTaskParent.weeklyShow, nil)
	end
	if tolua.getpeer(self.refreshTaskParent.dailyShow) ~= nil then
		tolua.setpeer(self.refreshTaskParent.dailyShow, nil)
	end
	if tolua.getpeer(self.mainTaskParent.scrollViewMain.content) ~= nil then
		tolua.setpeer(self.mainTaskParent.scrollViewMain.content, nil)
	end
	if tolua.getpeer(self.mainTaskParent.scrollViewMain) ~= nil then
		tolua.setpeer(self.mainTaskParent.scrollViewMain, nil)
	end
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
	if tolua.getpeer(self.mainTaskParent) ~= nil then
		tolua.setpeer(self.mainTaskParent, nil)
	end
	self.mainTaskParent = nil
	if tolua.getpeer(self.refreshTaskParent) ~= nil then
		tolua.setpeer(self.refreshTaskParent, nil)
	end
	self.refreshTaskParent = nil
	if tolua.getpeer(self.time) ~= nil then
		tolua.setpeer(self.time, nil)
	end
	self.time = nil
	if tolua.getpeer(self.toggle1) ~= nil then
		tolua.setpeer(self.toggle1, nil)
	end
	self.toggle1 = nil
	if tolua.getpeer(self.toggle2) ~= nil then
		tolua.setpeer(self.toggle2, nil)
	end
	self.toggle2 = nil
	if tolua.getpeer(self.toggle3) ~= nil then
		tolua.setpeer(self.toggle3, nil)
	end
	self.toggle3 = nil
	if tolua.getpeer(self.BtnClose) ~= nil then
		tolua.setpeer(self.BtnClose, nil)
	end
	self.BtnClose = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UITaskView