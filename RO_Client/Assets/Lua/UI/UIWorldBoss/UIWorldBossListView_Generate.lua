---@class UIWorldBossList__Generate_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIWorldBossList__Generate_btnRefresh
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIWorldBossList__Generate_btnBack
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIWorldBossList__Generate_btnPlayRule
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIWorldBossList__Generate_list
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIWorldBossList__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIWorldBossList__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIWorldBossList__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIWorldBossList__Generate_uIAnimator
---@field private AnyBtn UIWorldBossList__Generate_AnyBtn
---@field private list UIWorldBossList__Generate_list
---@field private worldBossItem UnityEngine.GameObject
---@field private noBoss UnityEngine.GameObject
---@field private btnPlayRule UIWorldBossList__Generate_btnPlayRule
---@field private btnBack UIWorldBossList__Generate_btnBack
---@field private btnRefresh UIWorldBossList__Generate_btnRefresh
---@field private num UIWorldBossList__Generate_num
local UIWorldBossListView = class("UIWorldBossListView", require("UIViewBase"))

function UIWorldBossListView:ctor()
end

---@private
function UIWorldBossListView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIWorldBossListView:InitGenerate(Root, data)
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


end

---@private
function UIWorldBossListView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIWorldBossListView:InitGenerate__2(Root, data)
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
function UIWorldBossListView:InitGenerate__3(Root, data)
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
function UIWorldBossListView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/ListRect/List
--]]
	local tmp = Root:Find("UIAnimator/Window/ListRect/List").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.list = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIWorldBossListView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/ListRect/List/Viewport/Content/WorldBossItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ListRect/List/Viewport/Content/WorldBossItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.worldBossItem = CommonUtil.BindGridViewItem2LuaStatic("WorldBossItem", tmp)
	self.worldBossItem.prefabName = "WorldBossItem"
end

---@private
function UIWorldBossListView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ListRect/NoBoss
--]]
	local tmp = Root:Find("UIAnimator/Window/ListRect/NoBoss").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noBoss = tmp
end

---@private
function UIWorldBossListView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BtnPlayRule
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnPlayRule").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPlayRule = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIWorldBossListView:InitGenerate__8(Root, data)
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
function UIWorldBossListView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BtnRefresh
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnRefresh").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRefresh = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIWorldBossListView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/TodayTimes/Num
--]]
	local tmp = Root:Find("UIAnimator/Window/TodayTimes/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIWorldBossListView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.list) ~= nil then
		tolua.setpeer(self.list, nil)
	end
	self.list = nil
	if self.worldBossItem.GenerateDestroy ~= nil then
		self.worldBossItem:GenerateDestroy()
	end
	if tolua.getpeer(self.worldBossItem) ~= nil then
		tolua.setpeer(self.worldBossItem, nil)
	end
	self.worldBossItem = nil
	if tolua.getpeer(self.noBoss) ~= nil then
		tolua.setpeer(self.noBoss, nil)
	end
	self.noBoss = nil
	if tolua.getpeer(self.btnPlayRule) ~= nil then
		tolua.setpeer(self.btnPlayRule, nil)
	end
	self.btnPlayRule = nil
	if tolua.getpeer(self.btnBack) ~= nil then
		tolua.setpeer(self.btnBack, nil)
	end
	self.btnBack = nil
	if tolua.getpeer(self.btnRefresh) ~= nil then
		tolua.setpeer(self.btnRefresh, nil)
	end
	self.btnRefresh = nil
	if tolua.getpeer(self.num) ~= nil then
		tolua.setpeer(self.num, nil)
	end
	self.num = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIWorldBossListView