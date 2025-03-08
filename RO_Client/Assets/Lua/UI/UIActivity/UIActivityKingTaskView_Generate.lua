---@class UIActivityKingTask__Generate_backBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityKingTask__Generate_title
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIActivityKingTask__Generate_TimeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIActivityKingTask__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIActivityKingTask__Generate_banner
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIActivityKingTask__Generate_dailyTaskToggle_label
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIActivityKingTask__Generate_dailyTaskToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public label UIActivityKingTask__Generate_dailyTaskToggle_label
---@field public redpoint UnityEngine.GameObject

---@class UIActivityKingTask__Generate_growthTaskToggle_label
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIActivityKingTask__Generate_growthTaskToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public label UIActivityKingTask__Generate_growthTaskToggle_label
---@field public redpoint UnityEngine.GameObject

---@class UIActivityKingTask__Generate_taskListScroll
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UIActivityKingTask__Generate_leftTimeNode_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIActivityKingTask__Generate_leftTimeNode_leftTimeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityKingTask__Generate_leftTimeNode
---@field public gameObject UnityEngine.GameObject
---@field public leftTimeTxt UIActivityKingTask__Generate_leftTimeNode_leftTimeTxt
---@field public icon UIActivityKingTask__Generate_leftTimeNode_icon

---@class UIActivityKingTask__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityKingTask__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIActivityKingTask__Generate_AnyBtn
---@field private leftTimeNode UIActivityKingTask__Generate_leftTimeNode
---@field private taskListScroll UIActivityKingTask__Generate_taskListScroll
---@field private taskItemActivity UnityEngine.GameObject
---@field private toggleGroup UnityEngine.GameObject
---@field private growthTaskToggle UIActivityKingTask__Generate_growthTaskToggle
---@field private dailyTaskToggle UIActivityKingTask__Generate_dailyTaskToggle
---@field private banner UIActivityKingTask__Generate_banner
---@field private bg UIActivityKingTask__Generate_bg
---@field private TimeTxt UIActivityKingTask__Generate_TimeTxt
---@field private title UIActivityKingTask__Generate_title
---@field private backBtn UIActivityKingTask__Generate_backBtn
local UIActivityKingTaskView = class("UIActivityKingTaskView", require("UIViewBase"))

function UIActivityKingTaskView:ctor()
end

---@private
function UIActivityKingTaskView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIActivityKingTaskView:InitGenerate(Root, data)
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


end

---@private
function UIActivityKingTaskView:InitGenerate__1(Root, data)
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
function UIActivityKingTaskView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/Bottom/Bg/TimeCountdown
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Bg/TimeCountdown").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftTimeNode = tmp
end

---@private
function UIActivityKingTaskView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Bottom/Bg/TimeCountdown/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Bg/TimeCountdown/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftTimeNode.leftTimeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityKingTaskView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bottom/Bg/TimeCountdown/Text/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Bg/TimeCountdown/Text/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftTimeNode.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIActivityKingTaskView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bottom/Bg/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Bg/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.taskListScroll = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIActivityKingTaskView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bottom/Bg/ScrollView/Viewport/Content/TaskItemActivity
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Bg/ScrollView/Viewport/Content/TaskItemActivity").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.taskItemActivity = CommonUtil.BindGridViewItem2LuaStatic("TaskItemActivity", tmp)
	self.taskItemActivity.prefabName = "TaskItemActivity"
end

---@private
function UIActivityKingTaskView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bottom/ToggleGroup
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/ToggleGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleGroup = tmp
end

---@private
function UIActivityKingTaskView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bottom/ToggleGroup/Toggle1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/ToggleGroup/Toggle1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.growthTaskToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIActivityKingTaskView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bottom/ToggleGroup/Toggle1/Label
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/ToggleGroup/Toggle1/Label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.growthTaskToggle.label = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIActivityKingTaskView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bottom/ToggleGroup/Toggle1/UIRedPointRP
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/ToggleGroup/Toggle1/UIRedPointRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.growthTaskToggle.redpoint = tmp
end

---@private
function UIActivityKingTaskView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bottom/ToggleGroup/Toggle2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/ToggleGroup/Toggle2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dailyTaskToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIActivityKingTaskView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bottom/ToggleGroup/Toggle2/Label
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/ToggleGroup/Toggle2/Label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dailyTaskToggle.label = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIActivityKingTaskView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bottom/ToggleGroup/Toggle2/UIRedPointRP
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/ToggleGroup/Toggle2/UIRedPointRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dailyTaskToggle.redpoint = tmp
end

---@private
function UIActivityKingTaskView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Banner
--]]
	local tmp = Root:Find("UIAnimator/Window/Banner").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.banner = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIActivityKingTaskView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Banner/Image
--]]
	local tmp = Root:Find("UIAnimator/Window/Banner/Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIActivityKingTaskView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Banner/Time/Time
--]]
	local tmp = Root:Find("UIAnimator/Window/Banner/Time/Time").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.TimeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIActivityKingTaskView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Banner/Label/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Banner/Label/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIActivityKingTaskView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.backBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityKingTaskView:GenerateDestroy()
	if tolua.getpeer(self.dailyTaskToggle.redpoint) ~= nil then
		tolua.setpeer(self.dailyTaskToggle.redpoint, nil)
	end
	if tolua.getpeer(self.dailyTaskToggle.label) ~= nil then
		tolua.setpeer(self.dailyTaskToggle.label, nil)
	end
	if tolua.getpeer(self.growthTaskToggle.redpoint) ~= nil then
		tolua.setpeer(self.growthTaskToggle.redpoint, nil)
	end
	if tolua.getpeer(self.growthTaskToggle.label) ~= nil then
		tolua.setpeer(self.growthTaskToggle.label, nil)
	end
	if tolua.getpeer(self.leftTimeNode.icon) ~= nil then
		tolua.setpeer(self.leftTimeNode.icon, nil)
	end
	if tolua.getpeer(self.leftTimeNode.leftTimeTxt) ~= nil then
		tolua.setpeer(self.leftTimeNode.leftTimeTxt, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.leftTimeNode) ~= nil then
		tolua.setpeer(self.leftTimeNode, nil)
	end
	self.leftTimeNode = nil
	if tolua.getpeer(self.taskListScroll) ~= nil then
		tolua.setpeer(self.taskListScroll, nil)
	end
	self.taskListScroll = nil
	if self.taskItemActivity.GenerateDestroy ~= nil then
		self.taskItemActivity:GenerateDestroy()
	end
	if tolua.getpeer(self.taskItemActivity) ~= nil then
		tolua.setpeer(self.taskItemActivity, nil)
	end
	self.taskItemActivity = nil
	if tolua.getpeer(self.toggleGroup) ~= nil then
		tolua.setpeer(self.toggleGroup, nil)
	end
	self.toggleGroup = nil
	if tolua.getpeer(self.growthTaskToggle) ~= nil then
		tolua.setpeer(self.growthTaskToggle, nil)
	end
	self.growthTaskToggle = nil
	if tolua.getpeer(self.dailyTaskToggle) ~= nil then
		tolua.setpeer(self.dailyTaskToggle, nil)
	end
	self.dailyTaskToggle = nil
	if tolua.getpeer(self.banner) ~= nil then
		tolua.setpeer(self.banner, nil)
	end
	self.banner = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.TimeTxt) ~= nil then
		tolua.setpeer(self.TimeTxt, nil)
	end
	self.TimeTxt = nil
	if tolua.getpeer(self.title) ~= nil then
		tolua.setpeer(self.title, nil)
	end
	self.title = nil
	if tolua.getpeer(self.backBtn) ~= nil then
		tolua.setpeer(self.backBtn, nil)
	end
	self.backBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIActivityKingTaskView