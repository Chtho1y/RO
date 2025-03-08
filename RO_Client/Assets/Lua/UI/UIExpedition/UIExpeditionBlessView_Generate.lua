---@class UIExpeditionBless__Generate_buffScrollList_content
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIExpeditionBless__Generate_buffScrollList
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UIExpeditionBless__Generate_buffScrollList_content

---@class UIExpeditionBless__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionBless__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionBless__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIExpeditionBless__Generate_AnyBtn
---@field private bottomRoot UnityEngine.GameObject
---@field private closeBtn UIExpeditionBless__Generate_closeBtn
---@field private buffScrollList UIExpeditionBless__Generate_buffScrollList
---@field private emptyNode UnityEngine.GameObject
local UIExpeditionBlessView = class("UIExpeditionBlessView", require("UIViewBase"))

function UIExpeditionBlessView:ctor()
end

---@private
function UIExpeditionBlessView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIExpeditionBlessView:InitGenerate(Root, data)
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


end

---@private
function UIExpeditionBlessView:InitGenerate__1(Root, data)
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
function UIExpeditionBlessView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/Bg/BottomRoot
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomRoot").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottomRoot = tmp
end

---@private
function UIExpeditionBlessView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExpeditionBlessView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Content/Center/Scroll View
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Center/Scroll View").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buffScrollList = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIExpeditionBlessView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Content/Center/Scroll View/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Center/Scroll View/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.buffScrollList.content = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIExpeditionBlessView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Content/Center/Empty
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Center/Empty").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emptyNode = tmp
end

---@private
function UIExpeditionBlessView:GenerateDestroy()
	if tolua.getpeer(self.buffScrollList.content) ~= nil then
		tolua.setpeer(self.buffScrollList.content, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.bottomRoot) ~= nil then
		tolua.setpeer(self.bottomRoot, nil)
	end
	self.bottomRoot = nil
	if tolua.getpeer(self.closeBtn) ~= nil then
		tolua.setpeer(self.closeBtn, nil)
	end
	self.closeBtn = nil
	if tolua.getpeer(self.buffScrollList) ~= nil then
		tolua.setpeer(self.buffScrollList, nil)
	end
	self.buffScrollList = nil
	if tolua.getpeer(self.emptyNode) ~= nil then
		tolua.setpeer(self.emptyNode, nil)
	end
	self.emptyNode = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIExpeditionBlessView