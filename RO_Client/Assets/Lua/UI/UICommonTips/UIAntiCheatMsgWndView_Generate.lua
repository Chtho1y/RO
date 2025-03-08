---@class UIAntiCheatMsgWnd__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIAntiCheatMsgWnd__Generate_btnQuit
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIAntiCheatMsgWnd__Generate_btnSure
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIAntiCheatMsgWnd__Generate_btnRight
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIAntiCheatMsgWnd__Generate_btnCancleText
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIAntiCheatMsgWnd__Generate_btnCancle
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIAntiCheatMsgWnd__Generate_questionTxt
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIAntiCheatMsgWnd__Generate_dscBox_dscTxt
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIAntiCheatMsgWnd__Generate_dscBox
---@field public gameObject UnityEngine.GameObject
---@field public dscTxt UIAntiCheatMsgWnd__Generate_dscBox_dscTxt

---@class UIAntiCheatMsgWnd__Generate_noticeTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIAntiCheatMsgWnd__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIAntiCheatMsgWnd__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIAntiCheatMsgWnd__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIAntiCheatMsgWnd__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIAntiCheatMsgWnd__Generate_uIAnimator
---@field private AnyBtn UIAntiCheatMsgWnd__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UIAntiCheatMsgWnd__Generate_btnClose
---@field private noticeTitle UIAntiCheatMsgWnd__Generate_noticeTitle
---@field private dscBox UIAntiCheatMsgWnd__Generate_dscBox
---@field private btnBox UnityEngine.GameObject
---@field private title UnityEngine.GameObject
---@field private questionTxt UIAntiCheatMsgWnd__Generate_questionTxt
---@field private box UnityEngine.GameObject
---@field private btnCancle UIAntiCheatMsgWnd__Generate_btnCancle
---@field private btnCancleText UIAntiCheatMsgWnd__Generate_btnCancleText
---@field private btnRight UIAntiCheatMsgWnd__Generate_btnRight
---@field private btnSure UIAntiCheatMsgWnd__Generate_btnSure
---@field private btnQuit UIAntiCheatMsgWnd__Generate_btnQuit
---@field private text UIAntiCheatMsgWnd__Generate_text
local UIAntiCheatMsgWndView = class("UIAntiCheatMsgWndView", require("UIViewBase"))

function UIAntiCheatMsgWndView:ctor()
end

---@private
function UIAntiCheatMsgWndView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIAntiCheatMsgWndView:InitGenerate(Root, data)
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


end

---@private
function UIAntiCheatMsgWndView:InitGenerate__1(Root, data)
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
function UIAntiCheatMsgWndView:InitGenerate__2(Root, data)
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
function UIAntiCheatMsgWndView:InitGenerate__3(Root, data)
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
function UIAntiCheatMsgWndView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIAntiCheatMsgWndView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/NoticeTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/NoticeTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noticeTitle = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIAntiCheatMsgWndView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/DscBox
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox = tmp
end

---@private
function UIAntiCheatMsgWndView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/DscBox/DscTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/DscTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox.dscTxt = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIAntiCheatMsgWndView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BtnBox
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBox = tmp
end

---@private
function UIAntiCheatMsgWndView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BtnBox/Title
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Title").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title = tmp
end

---@private
function UIAntiCheatMsgWndView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BtnBox/Title/QuestionTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Title/QuestionTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.questionTxt = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIAntiCheatMsgWndView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BtnBox/Box
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Box").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.box = tmp
end

---@private
function UIAntiCheatMsgWndView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BtnBox/Box/BtnCancle
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Box/BtnCancle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCancle = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIAntiCheatMsgWndView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BtnBox/Box/BtnCancle/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Box/BtnCancle/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCancleText = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIAntiCheatMsgWndView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/BtnBox/Box/BtnRight
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Box/BtnRight").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRight = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIAntiCheatMsgWndView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/BtnBox/Box/BtnRight/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Box/BtnRight/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSure = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIAntiCheatMsgWndView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/BtnBox/Box/BtnQuit
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Box/BtnQuit").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnQuit = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIAntiCheatMsgWndView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/BtnBox/Box/BtnQuit/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Box/BtnQuit/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIAntiCheatMsgWndView:GenerateDestroy()
	if tolua.getpeer(self.dscBox.dscTxt) ~= nil then
		tolua.setpeer(self.dscBox.dscTxt, nil)
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
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.noticeTitle) ~= nil then
		tolua.setpeer(self.noticeTitle, nil)
	end
	self.noticeTitle = nil
	if tolua.getpeer(self.dscBox) ~= nil then
		tolua.setpeer(self.dscBox, nil)
	end
	self.dscBox = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.title) ~= nil then
		tolua.setpeer(self.title, nil)
	end
	self.title = nil
	if tolua.getpeer(self.questionTxt) ~= nil then
		tolua.setpeer(self.questionTxt, nil)
	end
	self.questionTxt = nil
	if tolua.getpeer(self.box) ~= nil then
		tolua.setpeer(self.box, nil)
	end
	self.box = nil
	if tolua.getpeer(self.btnCancle) ~= nil then
		tolua.setpeer(self.btnCancle, nil)
	end
	self.btnCancle = nil
	if tolua.getpeer(self.btnCancleText) ~= nil then
		tolua.setpeer(self.btnCancleText, nil)
	end
	self.btnCancleText = nil
	if tolua.getpeer(self.btnRight) ~= nil then
		tolua.setpeer(self.btnRight, nil)
	end
	self.btnRight = nil
	if tolua.getpeer(self.btnSure) ~= nil then
		tolua.setpeer(self.btnSure, nil)
	end
	self.btnSure = nil
	if tolua.getpeer(self.btnQuit) ~= nil then
		tolua.setpeer(self.btnQuit, nil)
	end
	self.btnQuit = nil
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIAntiCheatMsgWndView