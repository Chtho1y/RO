---@class UIClimbingTower__Generate_cover
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIClimbingTower__Generate_iconGoto
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIClimbingTower__Generate_btnInOut
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTower__Generate_btnGoto
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTower__Generate_text2
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIClimbingTower__Generate_text1
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIClimbingTower__Generate_bgGoto
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIClimbingTower__Generate_playRuleBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTower__Generate_btnTower
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTower__Generate_btnTowerTop
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTower__Generate_rankBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTower__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTower__Generate_btnStatistics
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTower__Generate_boardTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript
---@field public text UnityEngine.UI.Text

---@class UIClimbingTower__Generate_scrollview_content
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIClimbingTower__Generate_scrollview
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView
---@field public content UIClimbingTower__Generate_scrollview_content

---@class UIClimbingTower__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIClimbingTower__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIClimbingTower__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIClimbingTower__Generate_uIAnimator
---@field private AnyBtn UIClimbingTower__Generate_AnyBtn
---@field private scrollview UIClimbingTower__Generate_scrollview
---@field private boardTitle UIClimbingTower__Generate_boardTitle
---@field private btnStatistics UIClimbingTower__Generate_btnStatistics
---@field private closeBtn UIClimbingTower__Generate_closeBtn
---@field private rankBtn UIClimbingTower__Generate_rankBtn
---@field private btnTowerTop UIClimbingTower__Generate_btnTowerTop
---@field private btnTower UIClimbingTower__Generate_btnTower
---@field private playRuleBtn UIClimbingTower__Generate_playRuleBtn
---@field private uIGoto UnityEngine.GameObject
---@field private bgGoto UIClimbingTower__Generate_bgGoto
---@field private light UnityEngine.GameObject
---@field private text1 UIClimbingTower__Generate_text1
---@field private text2 UIClimbingTower__Generate_text2
---@field private btnGoto UIClimbingTower__Generate_btnGoto
---@field private btnInOut UIClimbingTower__Generate_btnInOut
---@field private iconGoto UIClimbingTower__Generate_iconGoto
---@field private cover UIClimbingTower__Generate_cover
local UIClimbingTowerView = class("UIClimbingTowerView", require("UIViewBase"))

function UIClimbingTowerView:ctor()
end

---@private
function UIClimbingTowerView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIClimbingTowerView:InitGenerate(Root, data)
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


end

---@private
function UIClimbingTowerView:InitGenerate__1(Root, data)
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
function UIClimbingTowerView:InitGenerate__2(Root, data)
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
function UIClimbingTowerView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/scrollview
--]]
	local tmp = Root:Find("UIAnimator/Window/scrollview").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollview = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIClimbingTowerView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/scrollview/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/scrollview/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollview.content = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIClimbingTowerView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/UITitle/BoardTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/UITitle/BoardTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boardTitle = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIClimbingTowerView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/UITitle/BtnStatistics
--]]
	local tmp = Root:Find("UIAnimator/Window/UITitle/BtnStatistics").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnStatistics = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/RankBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/RankBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BtnTowerTop
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnTowerTop").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnTowerTop = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BtnTower
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnTower").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnTower = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BtnPlayRule
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnPlayRule").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playRuleBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/UIGoto
--]]
	local tmp = Root:Find("UIAnimator/Window/UIGoto").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIGoto = tmp
end

---@private
function UIClimbingTowerView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/UIGoto/BgGoto
--]]
	local tmp = Root:Find("UIAnimator/Window/UIGoto/BgGoto").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bgGoto = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIClimbingTowerView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/UIGoto/BgGoto/Light
--]]
	local tmp = Root:Find("UIAnimator/Window/UIGoto/BgGoto/Light").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.light = tmp
end

---@private
function UIClimbingTowerView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/UIGoto/BgGoto/Text1
--]]
	local tmp = Root:Find("UIAnimator/Window/UIGoto/BgGoto/Text1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text1 = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIClimbingTowerView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/UIGoto/BgGoto/Text2
--]]
	local tmp = Root:Find("UIAnimator/Window/UIGoto/BgGoto/Text2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text2 = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIClimbingTowerView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/UIGoto/BgGoto/BtnGoto
--]]
	local tmp = Root:Find("UIAnimator/Window/UIGoto/BgGoto/BtnGoto").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnGoto = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/UIGoto/BgGoto/BtnInOut
--]]
	local tmp = Root:Find("UIAnimator/Window/UIGoto/BgGoto/BtnInOut").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnInOut = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIClimbingTowerView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/UIGoto/BgGoto/BtnInOut/IconGoto
--]]
	local tmp = Root:Find("UIAnimator/Window/UIGoto/BgGoto/BtnInOut/IconGoto").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconGoto = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIClimbingTowerView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Cover
--]]
	local tmp = Root:Find("UIAnimator/Window/Cover").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cover = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIClimbingTowerView:GenerateDestroy()
	if tolua.getpeer(self.scrollview.content) ~= nil then
		tolua.setpeer(self.scrollview.content, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.scrollview) ~= nil then
		tolua.setpeer(self.scrollview, nil)
	end
	self.scrollview = nil
	if tolua.getpeer(self.boardTitle) ~= nil then
		tolua.setpeer(self.boardTitle, nil)
	end
	self.boardTitle = nil
	if tolua.getpeer(self.btnStatistics) ~= nil then
		tolua.setpeer(self.btnStatistics, nil)
	end
	self.btnStatistics = nil
	if tolua.getpeer(self.closeBtn) ~= nil then
		tolua.setpeer(self.closeBtn, nil)
	end
	self.closeBtn = nil
	if tolua.getpeer(self.rankBtn) ~= nil then
		tolua.setpeer(self.rankBtn, nil)
	end
	self.rankBtn = nil
	if tolua.getpeer(self.btnTowerTop) ~= nil then
		tolua.setpeer(self.btnTowerTop, nil)
	end
	self.btnTowerTop = nil
	if tolua.getpeer(self.btnTower) ~= nil then
		tolua.setpeer(self.btnTower, nil)
	end
	self.btnTower = nil
	if tolua.getpeer(self.playRuleBtn) ~= nil then
		tolua.setpeer(self.playRuleBtn, nil)
	end
	self.playRuleBtn = nil
	if tolua.getpeer(self.uIGoto) ~= nil then
		tolua.setpeer(self.uIGoto, nil)
	end
	self.uIGoto = nil
	if tolua.getpeer(self.bgGoto) ~= nil then
		tolua.setpeer(self.bgGoto, nil)
	end
	self.bgGoto = nil
	if tolua.getpeer(self.light) ~= nil then
		tolua.setpeer(self.light, nil)
	end
	self.light = nil
	if tolua.getpeer(self.text1) ~= nil then
		tolua.setpeer(self.text1, nil)
	end
	self.text1 = nil
	if tolua.getpeer(self.text2) ~= nil then
		tolua.setpeer(self.text2, nil)
	end
	self.text2 = nil
	if tolua.getpeer(self.btnGoto) ~= nil then
		tolua.setpeer(self.btnGoto, nil)
	end
	self.btnGoto = nil
	if tolua.getpeer(self.btnInOut) ~= nil then
		tolua.setpeer(self.btnInOut, nil)
	end
	self.btnInOut = nil
	if tolua.getpeer(self.iconGoto) ~= nil then
		tolua.setpeer(self.iconGoto, nil)
	end
	self.iconGoto = nil
	if tolua.getpeer(self.cover) ~= nil then
		tolua.setpeer(self.cover, nil)
	end
	self.cover = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIClimbingTowerView