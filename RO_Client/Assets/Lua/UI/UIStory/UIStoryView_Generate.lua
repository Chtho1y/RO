---@class UIStory__Generate_skip
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIStory__Generate_selectionBg_selection3_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIStory__Generate_selectionBg_selection3
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIStory__Generate_selectionBg_selection3_text

---@class UIStory__Generate_selectionBg_selection2_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIStory__Generate_selectionBg_selection2
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIStory__Generate_selectionBg_selection2_text

---@class UIStory__Generate_selectionBg_selection1_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIStory__Generate_selectionBg_selection1
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIStory__Generate_selectionBg_selection1_text

---@class UIStory__Generate_selectionBg
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator
---@field public selection1 UIStory__Generate_selectionBg_selection1
---@field public selection2 UIStory__Generate_selectionBg_selection2
---@field public selection3 UIStory__Generate_selectionBg_selection3

---@class UIStory__Generate_storyTalkItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement
---@field public canvasGroup UnityEngine.CanvasGroup

---@class UIStory__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public uIEventTriggerListener UIEventTriggerListener
---@field public loopListView SuperScrollView.LoopListView

---@class UIStory__Generate_title06
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIStory__Generate_title05
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIStory__Generate_title04
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIStory__Generate_title03
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIStory__Generate_title02
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIStory__Generate_title01
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIStory__Generate_right_role
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIStory__Generate_right
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator
---@field public role UIStory__Generate_right_role

---@class UIStory__Generate_left_role
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIStory__Generate_left
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator
---@field public role UIStory__Generate_left_role

---@class UIStory__Generate_window
---@field public gameObject UnityEngine.GameObject
---@field public uIEventTriggerListener UIEventTriggerListener

---@class UIStory__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIStory__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIStory__Generate_uIAnimator
---@field private window UIStory__Generate_window
---@field private bgMove UnityEngine.GameObject
---@field private left UIStory__Generate_left
---@field private right UIStory__Generate_right
---@field private title01 UIStory__Generate_title01
---@field private title02 UIStory__Generate_title02
---@field private title03 UIStory__Generate_title03
---@field private title04 UIStory__Generate_title04
---@field private title05 UIStory__Generate_title05
---@field private title06 UIStory__Generate_title06
---@field private scrollView UIStory__Generate_scrollView
---@field private content UnityEngine.GameObject
---@field private storyTalkItem UIStory__Generate_storyTalkItem
---@field private arrowRgt UnityEngine.GameObject
---@field private arrowLft UnityEngine.GameObject
---@field private selectionBg UIStory__Generate_selectionBg
---@field private skip UIStory__Generate_skip
---@field private darkScreen UnityEngine.GameObject
local UIStoryView = class("UIStoryView", require("UIViewBase"))

function UIStoryView:ctor()
end

---@private
function UIStoryView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIStoryView:InitGenerate(Root, data)
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


end

---@private
function UIStoryView:InitGenerate__1(Root, data)
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
function UIStoryView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window
--]]
	local tmp = Root:Find("UIAnimator/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
end

---@private
function UIStoryView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BgMove
--]]
	local tmp = Root:Find("UIAnimator/Window/BgMove").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bgMove = tmp
end

---@private
function UIStoryView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/RoleImg/Left
--]]
	local tmp = Root:Find("UIAnimator/Window/RoleImg/Left").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.left = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIStoryView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/RoleImg/Left/Role
--]]
	local tmp = Root:Find("UIAnimator/Window/RoleImg/Left/Role").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.left.role = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIStoryView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/RoleImg/Right
--]]
	local tmp = Root:Find("UIAnimator/Window/RoleImg/Right").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.right = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIStoryView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/RoleImg/Right/Role
--]]
	local tmp = Root:Find("UIAnimator/Window/RoleImg/Right/Role").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.right.role = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIStoryView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bottom/bgs/Title01
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/bgs/Title01").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title01 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIStoryView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bottom/bgs/Title02
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/bgs/Title02").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title02 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIStoryView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bottom/bgs/Title03
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/bgs/Title03").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title03 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIStoryView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bottom/bgs/Title04
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/bgs/Title04").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title04 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIStoryView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bottom/bgs/Title05
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/bgs/Title05").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title05 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIStoryView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bottom/bgs/Title06
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/bgs/Title06").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title06 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIStoryView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bottom/Scroll View
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Scroll View").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIStoryView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bottom/Scroll View/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Scroll View/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp
end

---@private
function UIStoryView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bottom/Scroll View/Viewport/Content/StoryTalkItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Scroll View/Viewport/Content/StoryTalkItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.storyTalkItem = CommonUtil.BindGridViewItem2LuaStatic("StoryTalkItem", tmp)
	self.storyTalkItem.prefabName = "StoryTalkItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)

	tmp.canvasGroup = tmp:GetComponent(Enum.TypeInfo.CanvasGroup)
end

---@private
function UIStoryView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bottom/ArrowRgt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/ArrowRgt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.arrowRgt = tmp
end

---@private
function UIStoryView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bottom/ArrowLft
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/ArrowLft").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.arrowLft = tmp
end

---@private
function UIStoryView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/SelectionBg
--]]
	local tmp = Root:Find("UIAnimator/Window/SelectionBg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectionBg = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIStoryView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/SelectionBg/Selection1
--]]
	local tmp = Root:Find("UIAnimator/Window/SelectionBg/Selection1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectionBg.selection1 = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIStoryView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/SelectionBg/Selection1/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/SelectionBg/Selection1/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectionBg.selection1.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIStoryView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/SelectionBg/Selection2
--]]
	local tmp = Root:Find("UIAnimator/Window/SelectionBg/Selection2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectionBg.selection2 = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIStoryView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/SelectionBg/Selection2/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/SelectionBg/Selection2/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectionBg.selection2.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIStoryView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/SelectionBg/Selection3
--]]
	local tmp = Root:Find("UIAnimator/Window/SelectionBg/Selection3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectionBg.selection3 = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIStoryView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/SelectionBg/Selection3/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/SelectionBg/Selection3/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectionBg.selection3.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIStoryView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/Skip
--]]
	local tmp = Root:Find("UIAnimator/Window/Skip").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skip = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIStoryView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/DarkScreen
--]]
	local tmp = Root:Find("UIAnimator/Window/DarkScreen").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.darkScreen = tmp
end

---@private
function UIStoryView:GenerateDestroy()
	if tolua.getpeer(self.selectionBg.selection3.text) ~= nil then
		tolua.setpeer(self.selectionBg.selection3.text, nil)
	end
	if tolua.getpeer(self.selectionBg.selection3) ~= nil then
		tolua.setpeer(self.selectionBg.selection3, nil)
	end
	if tolua.getpeer(self.selectionBg.selection2.text) ~= nil then
		tolua.setpeer(self.selectionBg.selection2.text, nil)
	end
	if tolua.getpeer(self.selectionBg.selection2) ~= nil then
		tolua.setpeer(self.selectionBg.selection2, nil)
	end
	if tolua.getpeer(self.selectionBg.selection1.text) ~= nil then
		tolua.setpeer(self.selectionBg.selection1.text, nil)
	end
	if tolua.getpeer(self.selectionBg.selection1) ~= nil then
		tolua.setpeer(self.selectionBg.selection1, nil)
	end
	if tolua.getpeer(self.right.role) ~= nil then
		tolua.setpeer(self.right.role, nil)
	end
	if tolua.getpeer(self.left.role) ~= nil then
		tolua.setpeer(self.left.role, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if tolua.getpeer(self.bgMove) ~= nil then
		tolua.setpeer(self.bgMove, nil)
	end
	self.bgMove = nil
	if tolua.getpeer(self.left) ~= nil then
		tolua.setpeer(self.left, nil)
	end
	self.left = nil
	if tolua.getpeer(self.right) ~= nil then
		tolua.setpeer(self.right, nil)
	end
	self.right = nil
	if tolua.getpeer(self.title01) ~= nil then
		tolua.setpeer(self.title01, nil)
	end
	self.title01 = nil
	if tolua.getpeer(self.title02) ~= nil then
		tolua.setpeer(self.title02, nil)
	end
	self.title02 = nil
	if tolua.getpeer(self.title03) ~= nil then
		tolua.setpeer(self.title03, nil)
	end
	self.title03 = nil
	if tolua.getpeer(self.title04) ~= nil then
		tolua.setpeer(self.title04, nil)
	end
	self.title04 = nil
	if tolua.getpeer(self.title05) ~= nil then
		tolua.setpeer(self.title05, nil)
	end
	self.title05 = nil
	if tolua.getpeer(self.title06) ~= nil then
		tolua.setpeer(self.title06, nil)
	end
	self.title06 = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	if self.storyTalkItem.GenerateDestroy ~= nil then
		self.storyTalkItem:GenerateDestroy()
	end
	if tolua.getpeer(self.storyTalkItem) ~= nil then
		tolua.setpeer(self.storyTalkItem, nil)
	end
	self.storyTalkItem = nil
	if tolua.getpeer(self.arrowRgt) ~= nil then
		tolua.setpeer(self.arrowRgt, nil)
	end
	self.arrowRgt = nil
	if tolua.getpeer(self.arrowLft) ~= nil then
		tolua.setpeer(self.arrowLft, nil)
	end
	self.arrowLft = nil
	if tolua.getpeer(self.selectionBg) ~= nil then
		tolua.setpeer(self.selectionBg, nil)
	end
	self.selectionBg = nil
	if tolua.getpeer(self.skip) ~= nil then
		tolua.setpeer(self.skip, nil)
	end
	self.skip = nil
	if tolua.getpeer(self.darkScreen) ~= nil then
		tolua.setpeer(self.darkScreen, nil)
	end
	self.darkScreen = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIStoryView