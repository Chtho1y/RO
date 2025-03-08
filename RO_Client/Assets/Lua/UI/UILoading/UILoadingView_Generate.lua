---@class UILoading__Generate_scrollbar
---@field public gameObject UnityEngine.GameObject
---@field public scrollbar UnityEngine.UI.Scrollbar

---@class UILoading__Generate_numberText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UILoading__Generate_tip
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UILoading__Generate_loadingBg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UILoading__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private loadingItem1 UnityEngine.GameObject
---@field private loadingBg UILoading__Generate_loadingBg
---@field private loadingRoot UnityEngine.GameObject
---@field private tip UILoading__Generate_tip
---@field private numberText UILoading__Generate_numberText
---@field private scrollbar UILoading__Generate_scrollbar
local UILoadingView = class("UILoadingView", require("UIViewBase"))

function UILoadingView:ctor()
end

---@private
function UILoadingView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UILoadingView:InitGenerate(Root, data)
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
function UILoadingView:InitGenerate__1(Root, data)
--[[
	Loading2Root/Content/ItemLoading1
--]]
	local tmp = Root:Find("Loading2Root/Content/ItemLoading1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loadingItem1 = tmp
end

---@private
function UILoadingView:InitGenerate__2(Root, data)
--[[
	Loading2Root/Content/ItemLoading1/Image
--]]
	local tmp = Root:Find("Loading2Root/Content/ItemLoading1/Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loadingBg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UILoadingView:InitGenerate__3(Root, data)
--[[
	Loading2Root/Loading
--]]
	local tmp = Root:Find("Loading2Root/Loading").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loadingRoot = tmp
end

---@private
function UILoadingView:InitGenerate__4(Root, data)
--[[
	Loading2Root/Loading/Text
--]]
	local tmp = Root:Find("Loading2Root/Loading/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.tip = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UILoadingView:InitGenerate__5(Root, data)
--[[
	Loading2Root/Loading/NumberText
--]]
	local tmp = Root:Find("Loading2Root/Loading/NumberText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.numberText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UILoadingView:InitGenerate__6(Root, data)
--[[
	Loading2Root/Loading/Scrollbar
--]]
	local tmp = Root:Find("Loading2Root/Loading/Scrollbar").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollbar = tmp

	tmp.scrollbar = tmp:GetComponent(Enum.TypeInfo.Scrollbar)
end

---@private
function UILoadingView:GenerateDestroy()
	if tolua.getpeer(self.loadingItem1) ~= nil then
		tolua.setpeer(self.loadingItem1, nil)
	end
	self.loadingItem1 = nil
	if tolua.getpeer(self.loadingBg) ~= nil then
		tolua.setpeer(self.loadingBg, nil)
	end
	self.loadingBg = nil
	if tolua.getpeer(self.loadingRoot) ~= nil then
		tolua.setpeer(self.loadingRoot, nil)
	end
	self.loadingRoot = nil
	if tolua.getpeer(self.tip) ~= nil then
		tolua.setpeer(self.tip, nil)
	end
	self.tip = nil
	if tolua.getpeer(self.numberText) ~= nil then
		tolua.setpeer(self.numberText, nil)
	end
	self.numberText = nil
	if tolua.getpeer(self.scrollbar) ~= nil then
		tolua.setpeer(self.scrollbar, nil)
	end
	self.scrollbar = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UILoadingView