---@class UIChangeServer__Generate_allToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIChangeServer__Generate_recommendToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIChangeServer__Generate_allServerGroupItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeServer__Generate_allServerGroupLoop
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIChangeServer__Generate_allServerLoop_allServerItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeServer__Generate_allServerLoop
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView
---@field public allServerItem UIChangeServer__Generate_allServerLoop_allServerItem

---@class UIChangeServer__Generate_recommendServerLoop_allServerItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeServer__Generate_recommendServerLoop
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView
---@field public allServerItem UIChangeServer__Generate_recommendServerLoop_allServerItem

---@class UIChangeServer__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeServer__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChangeServer__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIChangeServer__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIChangeServer__Generate_uIAnimator
---@field private AnyBtn UIChangeServer__Generate_AnyBtn
---@field private btnClose UIChangeServer__Generate_btnClose
---@field private recommendRoot UnityEngine.GameObject
---@field private recommendServerLoop UIChangeServer__Generate_recommendServerLoop
---@field private allRoot UnityEngine.GameObject
---@field private allServerLoop UIChangeServer__Generate_allServerLoop
---@field private allServerGroupLoop UIChangeServer__Generate_allServerGroupLoop
---@field private allServerGroupItem UIChangeServer__Generate_allServerGroupItem
---@field private recommendToggle UIChangeServer__Generate_recommendToggle
---@field private allToggle UIChangeServer__Generate_allToggle
local UIChangeServerView = class("UIChangeServerView", require("UIViewBase"))

function UIChangeServerView:ctor()
end

---@private
function UIChangeServerView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIChangeServerView:InitGenerate(Root, data)
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


end

---@private
function UIChangeServerView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIChangeServerView:InitGenerate__2(Root, data)
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
function UIChangeServerView:InitGenerate__3(Root, data)
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
function UIChangeServerView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChangeServerView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BodyRoot/RecommendRoot
--]]
	local tmp = Root:Find("UIAnimator/Window/BodyRoot/RecommendRoot").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.recommendRoot = tmp
end

---@private
function UIChangeServerView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BodyRoot/RecommendRoot/RecommendServerLoop
--]]
	local tmp = Root:Find("UIAnimator/Window/BodyRoot/RecommendRoot/RecommendServerLoop").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.recommendServerLoop = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIChangeServerView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BodyRoot/RecommendRoot/RecommendServerLoop/Viewport/Content/AllServerItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BodyRoot/RecommendRoot/RecommendServerLoop/Viewport/Content/AllServerItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.recommendServerLoop.allServerItem = CommonUtil.BindGridViewItem2LuaStatic("AllServerItem", tmp)
	self.recommendServerLoop.allServerItem.prefabName = "AllServerItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChangeServerView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BodyRoot/AllRoot
--]]
	local tmp = Root:Find("UIAnimator/Window/BodyRoot/AllRoot").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.allRoot = tmp
end

---@private
function UIChangeServerView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BodyRoot/AllRoot/AllServerLoop
--]]
	local tmp = Root:Find("UIAnimator/Window/BodyRoot/AllRoot/AllServerLoop").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.allServerLoop = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIChangeServerView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BodyRoot/AllRoot/AllServerLoop/Viewport/Content/AllServerItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BodyRoot/AllRoot/AllServerLoop/Viewport/Content/AllServerItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.allServerLoop.allServerItem = CommonUtil.BindGridViewItem2LuaStatic("AllServerItem", tmp)
	self.allServerLoop.allServerItem.prefabName = "AllServerItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChangeServerView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BodyRoot/AllRoot/AllServerGroupLoop
--]]
	local tmp = Root:Find("UIAnimator/Window/BodyRoot/AllRoot/AllServerGroupLoop").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.allServerGroupLoop = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIChangeServerView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BodyRoot/AllRoot/AllServerGroupLoop/Viewport/Content/AllServerGroupItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BodyRoot/AllRoot/AllServerGroupLoop/Viewport/Content/AllServerGroupItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.allServerGroupItem = CommonUtil.BindGridViewItem2LuaStatic("AllServerGroupItem", tmp)
	self.allServerGroupItem.prefabName = "AllServerGroupItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChangeServerView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BodyRoot/TgooleGroup/RecommendToggle
--]]
	local tmp = Root:Find("UIAnimator/Window/BodyRoot/TgooleGroup/RecommendToggle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.recommendToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIChangeServerView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/BodyRoot/TgooleGroup/AllToggle
--]]
	local tmp = Root:Find("UIAnimator/Window/BodyRoot/TgooleGroup/AllToggle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.allToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIChangeServerView:GenerateDestroy()
	if self.allServerLoop.allServerItem.GenerateDestroy ~= nil then
		self.allServerLoop.allServerItem:GenerateDestroy()
	end
	if tolua.getpeer(self.allServerLoop.allServerItem) ~= nil then
		tolua.setpeer(self.allServerLoop.allServerItem, nil)
	end
	if self.recommendServerLoop.allServerItem.GenerateDestroy ~= nil then
		self.recommendServerLoop.allServerItem:GenerateDestroy()
	end
	if tolua.getpeer(self.recommendServerLoop.allServerItem) ~= nil then
		tolua.setpeer(self.recommendServerLoop.allServerItem, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.recommendRoot) ~= nil then
		tolua.setpeer(self.recommendRoot, nil)
	end
	self.recommendRoot = nil
	if tolua.getpeer(self.recommendServerLoop) ~= nil then
		tolua.setpeer(self.recommendServerLoop, nil)
	end
	self.recommendServerLoop = nil
	if tolua.getpeer(self.allRoot) ~= nil then
		tolua.setpeer(self.allRoot, nil)
	end
	self.allRoot = nil
	if tolua.getpeer(self.allServerLoop) ~= nil then
		tolua.setpeer(self.allServerLoop, nil)
	end
	self.allServerLoop = nil
	if tolua.getpeer(self.allServerGroupLoop) ~= nil then
		tolua.setpeer(self.allServerGroupLoop, nil)
	end
	self.allServerGroupLoop = nil
	if self.allServerGroupItem.GenerateDestroy ~= nil then
		self.allServerGroupItem:GenerateDestroy()
	end
	if tolua.getpeer(self.allServerGroupItem) ~= nil then
		tolua.setpeer(self.allServerGroupItem, nil)
	end
	self.allServerGroupItem = nil
	if tolua.getpeer(self.recommendToggle) ~= nil then
		tolua.setpeer(self.recommendToggle, nil)
	end
	self.recommendToggle = nil
	if tolua.getpeer(self.allToggle) ~= nil then
		tolua.setpeer(self.allToggle, nil)
	end
	self.allToggle = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIChangeServerView