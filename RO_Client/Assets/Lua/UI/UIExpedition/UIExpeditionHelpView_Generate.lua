---@class UIExpeditionHelp__Generate_friendScrollList_content
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UIExpeditionHelp__Generate_friendScrollList
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UIExpeditionHelp__Generate_friendScrollList_content

---@class UIExpeditionHelp__Generate_leftTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExpeditionHelp__Generate_guildCDTxt
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionHelp__Generate_btnSure
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIExpeditionHelp__Generate_guildHelpBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionHelp__Generate_leftRescuedNumTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExpeditionHelp__Generate_guildImg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIExpeditionHelp__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionHelp__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionHelp__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIExpeditionHelp__Generate_AnyBtn
---@field private bottomRoot UnityEngine.GameObject
---@field private closeBtn UIExpeditionHelp__Generate_closeBtn
---@field private guildImg UIExpeditionHelp__Generate_guildImg
---@field private leftRescuedNumTxt UIExpeditionHelp__Generate_leftRescuedNumTxt
---@field private guildHelpBtn UIExpeditionHelp__Generate_guildHelpBtn
---@field private btnSure UIExpeditionHelp__Generate_btnSure
---@field private guildCDTxt UIExpeditionHelp__Generate_guildCDTxt
---@field private leftTime UIExpeditionHelp__Generate_leftTime
---@field private friendScrollList UIExpeditionHelp__Generate_friendScrollList
---@field private emptyNode UnityEngine.GameObject
local UIExpeditionHelpView = class("UIExpeditionHelpView", require("UIViewBase"))

function UIExpeditionHelpView:ctor()
end

---@private
function UIExpeditionHelpView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIExpeditionHelpView:InitGenerate(Root, data)
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


end

---@private
function UIExpeditionHelpView:InitGenerate__1(Root, data)
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
function UIExpeditionHelpView:InitGenerate__2(Root, data)
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
function UIExpeditionHelpView:InitGenerate__3(Root, data)
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
function UIExpeditionHelpView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Content/Top/GuildIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Top/GuildIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildImg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIExpeditionHelpView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Content/Top/Times
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Top/Times").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftRescuedNumTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExpeditionHelpView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Content/Top/BtnHelp
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Top/BtnHelp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildHelpBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExpeditionHelpView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Content/Top/BtnHelp/Content/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Top/BtnHelp/Content/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSure = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIExpeditionHelpView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Content/Top/CD
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Top/CD").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildCDTxt = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExpeditionHelpView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Content/Top/CD/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Top/CD/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExpeditionHelpView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Content/Center/Scroll View
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Center/Scroll View").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.friendScrollList = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIExpeditionHelpView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Content/Center/Scroll View/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Content/Center/Scroll View/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.friendScrollList.content = tmp

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)
end

---@private
function UIExpeditionHelpView:InitGenerate__12(Root, data)
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
function UIExpeditionHelpView:GenerateDestroy()
	if tolua.getpeer(self.friendScrollList.content) ~= nil then
		tolua.setpeer(self.friendScrollList.content, nil)
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
	if tolua.getpeer(self.guildImg) ~= nil then
		tolua.setpeer(self.guildImg, nil)
	end
	self.guildImg = nil
	if tolua.getpeer(self.leftRescuedNumTxt) ~= nil then
		tolua.setpeer(self.leftRescuedNumTxt, nil)
	end
	self.leftRescuedNumTxt = nil
	if tolua.getpeer(self.guildHelpBtn) ~= nil then
		tolua.setpeer(self.guildHelpBtn, nil)
	end
	self.guildHelpBtn = nil
	if tolua.getpeer(self.btnSure) ~= nil then
		tolua.setpeer(self.btnSure, nil)
	end
	self.btnSure = nil
	if tolua.getpeer(self.guildCDTxt) ~= nil then
		tolua.setpeer(self.guildCDTxt, nil)
	end
	self.guildCDTxt = nil
	if tolua.getpeer(self.leftTime) ~= nil then
		tolua.setpeer(self.leftTime, nil)
	end
	self.leftTime = nil
	if tolua.getpeer(self.friendScrollList) ~= nil then
		tolua.setpeer(self.friendScrollList, nil)
	end
	self.friendScrollList = nil
	if tolua.getpeer(self.emptyNode) ~= nil then
		tolua.setpeer(self.emptyNode, nil)
	end
	self.emptyNode = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIExpeditionHelpView