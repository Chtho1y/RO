---@class UIRecruitTips__Generate_btnUnbind
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRecruitTips__Generate_btnBind
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRecruitTips__Generate_btnCancleText
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIRecruitTips__Generate_btnCancle
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRecruitTips__Generate_questionTxt
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIRecruitTips__Generate_dscBox_timeBox_time
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIRecruitTips__Generate_statusImg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIRecruitTips__Generate_dscBox_timeBox
---@field public gameObject UnityEngine.GameObject
---@field public time UIRecruitTips__Generate_dscBox_timeBox_time

---@class UIRecruitTips__Generate_dscBox_recruitValueBg_recruitValueNum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIRecruitTips__Generate_dscBox_recruitValueBg
---@field public gameObject UnityEngine.GameObject
---@field public recruitValueNum UIRecruitTips__Generate_dscBox_recruitValueBg_recruitValueNum

---@class UIRecruitTips__Generate_dscBox_fightPBox_fighterPower
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIRecruitTips__Generate_dscBox_fightPBox
---@field public gameObject UnityEngine.GameObject
---@field public fighterPower UIRecruitTips__Generate_dscBox_fightPBox_fighterPower

---@class UIRecruitTips__Generate_dscBox_nickname
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIRecruitTips__Generate_dscBox_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIRecruitTips__Generate_dscBox
---@field public gameObject UnityEngine.GameObject
---@field public head UnityEngine.GameObject
---@field public headItem UIRecruitTips__Generate_dscBox_headItem
---@field public info UnityEngine.GameObject
---@field public nickname UIRecruitTips__Generate_dscBox_nickname
---@field public fightPBox UIRecruitTips__Generate_dscBox_fightPBox
---@field public recruitValueBg UIRecruitTips__Generate_dscBox_recruitValueBg
---@field public timeBox UIRecruitTips__Generate_dscBox_timeBox

---@class UIRecruitTips__Generate_noticeTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIRecruitTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRecruitTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRecruitTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIRecruitTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private uIAnimator UIRecruitTips__Generate_uIAnimator
---@field private AnyBtn UIRecruitTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UIRecruitTips__Generate_btnClose
---@field private noticeTitle UIRecruitTips__Generate_noticeTitle
---@field private dscBox UIRecruitTips__Generate_dscBox
---@field private statusImg UIRecruitTips__Generate_statusImg
---@field private btnBox UnityEngine.GameObject
---@field private title UnityEngine.GameObject
---@field private questionTxt UIRecruitTips__Generate_questionTxt
---@field private box UnityEngine.GameObject
---@field private btnCancle UIRecruitTips__Generate_btnCancle
---@field private btnCancleText UIRecruitTips__Generate_btnCancleText
---@field private btnBind UIRecruitTips__Generate_btnBind
---@field private btnUnbind UIRecruitTips__Generate_btnUnbind
local UIRecruitTipsView = class("UIRecruitTipsView")

function UIRecruitTipsView:ctor()
end

---@private
function UIRecruitTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIRecruitTipsView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

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


end

---@private
function UIRecruitTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIRecruitTipsView:InitGenerate__2(Root, data)
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
function UIRecruitTipsView:InitGenerate__3(Root, data)
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
function UIRecruitTipsView:InitGenerate__4(Root, data)
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
function UIRecruitTipsView:InitGenerate__5(Root, data)
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
function UIRecruitTipsView:InitGenerate__6(Root, data)
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
function UIRecruitTipsView:InitGenerate__7(Root, data)
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
function UIRecruitTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/DscBox/Head
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Head").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox.head = tmp
end

---@private
function UIRecruitTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/DscBox/Head/HeadItem
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Head/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.dscBox.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIRecruitTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/DscBox/Info
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Info").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox.info = tmp
end

---@private
function UIRecruitTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/DscBox/Info/Nickname
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Info/Nickname").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox.nickname = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIRecruitTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/DscBox/Info/FightPBox
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Info/FightPBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox.fightPBox = tmp
end

---@private
function UIRecruitTipsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/DscBox/Info/FightPBox/FighterPower
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Info/FightPBox/FighterPower").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox.fightPBox.fighterPower = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIRecruitTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/DscBox/Info/RecruitValueBg
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Info/RecruitValueBg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox.recruitValueBg = tmp
end

---@private
function UIRecruitTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/DscBox/Info/RecruitValueBg/RecruitValueNum
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Info/RecruitValueBg/RecruitValueNum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox.recruitValueBg.recruitValueNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIRecruitTipsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/DscBox/Info/TimeBox
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Info/TimeBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox.timeBox = tmp
end

---@private
function UIRecruitTipsView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/DscBox/Info/TimeBox/StatusImg
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Info/TimeBox/StatusImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.statusImg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIRecruitTipsView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/DscBox/Info/TimeBox/Time
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Info/TimeBox/Time").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox.timeBox.time = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIRecruitTipsView:InitGenerate__19(Root, data)
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
function UIRecruitTipsView:InitGenerate__20(Root, data)
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
function UIRecruitTipsView:InitGenerate__21(Root, data)
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
function UIRecruitTipsView:InitGenerate__22(Root, data)
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
function UIRecruitTipsView:InitGenerate__23(Root, data)
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
function UIRecruitTipsView:InitGenerate__24(Root, data)
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
function UIRecruitTipsView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/BtnBox/Box/BtnBind
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Box/BtnBind").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBind = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIRecruitTipsView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/BtnBox/Box/BtnUnbind
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBox/Box/BtnUnbind").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnUnbind = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIRecruitTipsView:GenerateDestroy()
	if tolua.getpeer(self.dscBox.timeBox.time) ~= nil then
		tolua.setpeer(self.dscBox.timeBox.time, nil)
	end
	if tolua.getpeer(self.dscBox.timeBox) ~= nil then
		tolua.setpeer(self.dscBox.timeBox, nil)
	end
	if tolua.getpeer(self.dscBox.recruitValueBg.recruitValueNum) ~= nil then
		tolua.setpeer(self.dscBox.recruitValueBg.recruitValueNum, nil)
	end
	if tolua.getpeer(self.dscBox.recruitValueBg) ~= nil then
		tolua.setpeer(self.dscBox.recruitValueBg, nil)
	end
	if tolua.getpeer(self.dscBox.fightPBox.fighterPower) ~= nil then
		tolua.setpeer(self.dscBox.fightPBox.fighterPower, nil)
	end
	if tolua.getpeer(self.dscBox.fightPBox) ~= nil then
		tolua.setpeer(self.dscBox.fightPBox, nil)
	end
	if tolua.getpeer(self.dscBox.nickname) ~= nil then
		tolua.setpeer(self.dscBox.nickname, nil)
	end
	if tolua.getpeer(self.dscBox.info) ~= nil then
		tolua.setpeer(self.dscBox.info, nil)
	end
	if self.dscBox.headItem.GenerateDestroy ~= nil then
		self.dscBox.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.dscBox.headItem) ~= nil then
		tolua.setpeer(self.dscBox.headItem, nil)
	end
	if tolua.getpeer(self.dscBox.head) ~= nil then
		tolua.setpeer(self.dscBox.head, nil)
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
	if tolua.getpeer(self.statusImg) ~= nil then
		tolua.setpeer(self.statusImg, nil)
	end
	self.statusImg = nil
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
	if tolua.getpeer(self.btnBind) ~= nil then
		tolua.setpeer(self.btnBind, nil)
	end
	self.btnBind = nil
	if tolua.getpeer(self.btnUnbind) ~= nil then
		tolua.setpeer(self.btnUnbind, nil)
	end
	self.btnUnbind = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIRecruitTipsView