---@class UIExpiditionHelpLog__Generate_logScrollList_content
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UIExpiditionHelpLog__Generate_logScrollList
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UIExpiditionHelpLog__Generate_logScrollList_content

---@class UIExpiditionHelpLog__Generate_leftAssistNumTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExpiditionHelpLog__Generate_leftRescuedNumTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExpiditionHelpLog__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpiditionHelpLog__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpiditionHelpLog__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIExpiditionHelpLog__Generate_AnyBtn
---@field private bottomRoot UnityEngine.GameObject
---@field private closeBtn UIExpiditionHelpLog__Generate_closeBtn
---@field private leftRescuedNumTxt UIExpiditionHelpLog__Generate_leftRescuedNumTxt
---@field private leftAssistNumTxt UIExpiditionHelpLog__Generate_leftAssistNumTxt
---@field private logScrollList UIExpiditionHelpLog__Generate_logScrollList
---@field private emptyNode UnityEngine.GameObject
local UIExpiditionHelpLogView = class("UIExpiditionHelpLogView", require("UIViewBase"))

function UIExpiditionHelpLogView:ctor()
end

---@private
function UIExpiditionHelpLogView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIExpiditionHelpLogView:InitGenerate(Root, data)
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


end

---@private
function UIExpiditionHelpLogView:InitGenerate__1(Root, data)
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
function UIExpiditionHelpLogView:InitGenerate__2(Root, data)
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
function UIExpiditionHelpLogView:InitGenerate__3(Root, data)
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
function UIExpiditionHelpLogView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Content/Top/Text1/Times
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Top/Text1/Times").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftRescuedNumTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExpiditionHelpLogView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Content/Top/Text2/Times
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Top/Text2/Times").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftAssistNumTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExpiditionHelpLogView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Content/Center/Scroll View
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Center/Scroll View").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.logScrollList = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIExpiditionHelpLogView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Content/Center/Scroll View/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Center/Scroll View/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.logScrollList.content = tmp

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)
end

---@private
function UIExpiditionHelpLogView:InitGenerate__8(Root, data)
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
function UIExpiditionHelpLogView:GenerateDestroy()
	if tolua.getpeer(self.logScrollList.content) ~= nil then
		tolua.setpeer(self.logScrollList.content, nil)
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
	if tolua.getpeer(self.leftRescuedNumTxt) ~= nil then
		tolua.setpeer(self.leftRescuedNumTxt, nil)
	end
	self.leftRescuedNumTxt = nil
	if tolua.getpeer(self.leftAssistNumTxt) ~= nil then
		tolua.setpeer(self.leftAssistNumTxt, nil)
	end
	self.leftAssistNumTxt = nil
	if tolua.getpeer(self.logScrollList) ~= nil then
		tolua.setpeer(self.logScrollList, nil)
	end
	self.logScrollList = nil
	if tolua.getpeer(self.emptyNode) ~= nil then
		tolua.setpeer(self.emptyNode, nil)
	end
	self.emptyNode = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIExpiditionHelpLogView