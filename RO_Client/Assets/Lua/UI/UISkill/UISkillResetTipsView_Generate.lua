---@class UISkillResetTips__Generate_btnResetAll_resText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISkillResetTips__Generate_btnResetAll_resIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISkillResetTips__Generate_btnResetAll_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UISkillResetTips__Generate_btnResetAll
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UISkillResetTips__Generate_btnResetAll_text
---@field public resIcon UISkillResetTips__Generate_btnResetAll_resIcon
---@field public resText UISkillResetTips__Generate_btnResetAll_resText

---@class UISkillResetTips__Generate_btnResetAdvance_resText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISkillResetTips__Generate_btnResetAdvance_resIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISkillResetTips__Generate_btnResetAdvance_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UISkillResetTips__Generate_btnResetAdvance
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UISkillResetTips__Generate_btnResetAdvance_text
---@field public resIcon UISkillResetTips__Generate_btnResetAdvance_resIcon
---@field public resText UISkillResetTips__Generate_btnResetAdvance_resText

---@class UISkillResetTips__Generate_btnReset_resText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISkillResetTips__Generate_btnReset_resIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISkillResetTips__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UISkillResetTips__Generate_btnReset
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public resIcon UISkillResetTips__Generate_btnReset_resIcon
---@field public resText UISkillResetTips__Generate_btnReset_resText

---@class UISkillResetTips__Generate_questionTxt
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UISkillResetTips__Generate_dscBox_dscTxt
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UISkillResetTips__Generate_dscBox
---@field public gameObject UnityEngine.GameObject
---@field public dscTxt UISkillResetTips__Generate_dscBox_dscTxt

---@class UISkillResetTips__Generate_noticeTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UISkillResetTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillResetTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISkillResetTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISkillResetTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UISkillResetTips__Generate_uIAnimator
---@field private AnyBtn UISkillResetTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UISkillResetTips__Generate_btnClose
---@field private noticeTitle UISkillResetTips__Generate_noticeTitle
---@field private dscBox UISkillResetTips__Generate_dscBox
---@field private questionTxt UISkillResetTips__Generate_questionTxt
---@field private btnBox UnityEngine.GameObject
---@field private btnReset UISkillResetTips__Generate_btnReset
---@field private text UISkillResetTips__Generate_text
---@field private btnResetAdvance UISkillResetTips__Generate_btnResetAdvance
---@field private btnResetAll UISkillResetTips__Generate_btnResetAll
local UISkillResetTipsView = class("UISkillResetTipsView", require("UIViewBase"))

function UISkillResetTipsView:ctor()
end

---@private
function UISkillResetTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISkillResetTipsView:InitGenerate(Root, data)
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


end

---@private
function UISkillResetTipsView:InitGenerate__1(Root, data)
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
function UISkillResetTipsView:InitGenerate__2(Root, data)
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
function UISkillResetTipsView:InitGenerate__3(Root, data)
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
function UISkillResetTipsView:InitGenerate__4(Root, data)
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
function UISkillResetTipsView:InitGenerate__5(Root, data)
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
function UISkillResetTipsView:InitGenerate__6(Root, data)
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
function UISkillResetTipsView:InitGenerate__7(Root, data)
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
function UISkillResetTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/QuestionTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/QuestionTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.questionTxt = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UISkillResetTipsView:InitGenerate__9(Root, data)
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
function UISkillResetTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnReset
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnReset").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnReset = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISkillResetTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnReset/Content/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnReset/Content/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UISkillResetTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnReset/Content/Res/ResIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnReset/Content/Res/ResIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnReset.resIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISkillResetTipsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnReset/Content/Res/ResText
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnReset/Content/Res/ResText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnReset.resText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISkillResetTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnResetAdvance
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnResetAdvance").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnResetAdvance = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISkillResetTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnResetAdvance/Content/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnResetAdvance/Content/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnResetAdvance.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UISkillResetTipsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnResetAdvance/Content/Res/ResIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnResetAdvance/Content/Res/ResIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnResetAdvance.resIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISkillResetTipsView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnResetAdvance/Content/Res/ResText
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnResetAdvance/Content/Res/ResText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnResetAdvance.resText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISkillResetTipsView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnResetAll
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnResetAll").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnResetAll = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISkillResetTipsView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnResetAll/Content/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnResetAll/Content/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnResetAll.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UISkillResetTipsView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnResetAll/Content/Res/ResIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnResetAll/Content/Res/ResIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnResetAll.resIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISkillResetTipsView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/BtnBox/BtnResetAll/Content/Res/ResText
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/BtnResetAll/Content/Res/ResText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnResetAll.resText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISkillResetTipsView:GenerateDestroy()
	if tolua.getpeer(self.btnResetAll.resText) ~= nil then
		tolua.setpeer(self.btnResetAll.resText, nil)
	end
	if tolua.getpeer(self.btnResetAll.resIcon) ~= nil then
		tolua.setpeer(self.btnResetAll.resIcon, nil)
	end
	if tolua.getpeer(self.btnResetAll.text) ~= nil then
		tolua.setpeer(self.btnResetAll.text, nil)
	end
	if tolua.getpeer(self.btnResetAdvance.resText) ~= nil then
		tolua.setpeer(self.btnResetAdvance.resText, nil)
	end
	if tolua.getpeer(self.btnResetAdvance.resIcon) ~= nil then
		tolua.setpeer(self.btnResetAdvance.resIcon, nil)
	end
	if tolua.getpeer(self.btnResetAdvance.text) ~= nil then
		tolua.setpeer(self.btnResetAdvance.text, nil)
	end
	if tolua.getpeer(self.btnReset.resText) ~= nil then
		tolua.setpeer(self.btnReset.resText, nil)
	end
	if tolua.getpeer(self.btnReset.resIcon) ~= nil then
		tolua.setpeer(self.btnReset.resIcon, nil)
	end
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
	if tolua.getpeer(self.questionTxt) ~= nil then
		tolua.setpeer(self.questionTxt, nil)
	end
	self.questionTxt = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.btnReset) ~= nil then
		tolua.setpeer(self.btnReset, nil)
	end
	self.btnReset = nil
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.btnResetAdvance) ~= nil then
		tolua.setpeer(self.btnResetAdvance, nil)
	end
	self.btnResetAdvance = nil
	if tolua.getpeer(self.btnResetAll) ~= nil then
		tolua.setpeer(self.btnResetAll, nil)
	end
	self.btnResetAll = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISkillResetTipsView