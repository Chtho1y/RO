---@class UITipsSkill__Generate_dscGai_txt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UITipsSkill__Generate_dscGai
---@field public gameObject UnityEngine.GameObject
---@field public txt UITipsSkill__Generate_dscGai_txt

---@class UITipsSkill__Generate_dscNext_txt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UITipsSkill__Generate_dscNext_level
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UITipsSkill__Generate_dscNext
---@field public gameObject UnityEngine.GameObject
---@field public level UITipsSkill__Generate_dscNext_level
---@field public txt UITipsSkill__Generate_dscNext_txt

---@class UITipsSkill__Generate_dscCurrent_txt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UITipsSkill__Generate_dscCurrent_level
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UITipsSkill__Generate_dscCurrent
---@field public gameObject UnityEngine.GameObject
---@field public level UITipsSkill__Generate_dscCurrent_level
---@field public txt UITipsSkill__Generate_dscCurrent_txt

---@class UITipsSkill__Generate_type2_text2
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UITipsSkill__Generate_type2_text1
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript
---@field public text UnityEngine.UI.Text

---@class UITipsSkill__Generate_type2
---@field public gameObject UnityEngine.GameObject
---@field public text1 UITipsSkill__Generate_type2_text1
---@field public text2 UITipsSkill__Generate_type2_text2

---@class UITipsSkill__Generate_type1_text2
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UITipsSkill__Generate_type1_text1
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript
---@field public text UnityEngine.UI.Text

---@class UITipsSkill__Generate_type1
---@field public gameObject UnityEngine.GameObject
---@field public text1 UITipsSkill__Generate_type1_text1
---@field public text2 UITipsSkill__Generate_type1_text2

---@class UITipsSkill__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UITipsSkill__Generate_skillItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UITipsSkill__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UITipsSkill__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UITipsSkill__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIEventHandler UIEventHandler
---@field private uIAnimator UITipsSkill__Generate_uIAnimator
---@field private AnyBtn UITipsSkill__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private mainInfo UnityEngine.GameObject
---@field private contentItem UnityEngine.GameObject
---@field private skillItem UITipsSkill__Generate_skillItem
---@field private textName UITipsSkill__Generate_textName
---@field private type1 UITipsSkill__Generate_type1
---@field private type2 UITipsSkill__Generate_type2
---@field private skillTag UnityEngine.GameObject
---@field private skillTagItem1 UnityEngine.GameObject
---@field private skillTagItem2 UnityEngine.GameObject
---@field private skillTagItem3 UnityEngine.GameObject
---@field private skillTagItem4 UnityEngine.GameObject
---@field private dscCurrent UITipsSkill__Generate_dscCurrent
---@field private dscNext UITipsSkill__Generate_dscNext
---@field private maxLevel UnityEngine.GameObject
---@field private max UnityEngine.GameObject
---@field private dscGai UITipsSkill__Generate_dscGai
---@field private bottomBox UnityEngine.GameObject
---@field private btnBox UnityEngine.GameObject
local UITipsSkillView = class("UITipsSkillView", require("UIViewBase"))

function UITipsSkillView:ctor()
end

---@private
function UITipsSkillView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UITipsSkillView:InitGenerate(Root, data)
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
	self:InitGenerate__22(Root,data)
	self:InitGenerate__23(Root,data)
	self:InitGenerate__24(Root,data)
	self:InitGenerate__25(Root,data)
	self:InitGenerate__26(Root,data)
	self:InitGenerate__27(Root,data)
	self:InitGenerate__28(Root,data)
	self:InitGenerate__29(Root,data)
	self:InitGenerate__30(Root,data)
	self:InitGenerate__31(Root,data)


end

---@private
function UITipsSkillView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.uIEventHandler = Root:GetComponent(Enum.TypeInfo.UIEventHandler)
end

---@private
function UITipsSkillView:InitGenerate__2(Root, data)
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
function UITipsSkillView:InitGenerate__3(Root, data)
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
function UITipsSkillView:InitGenerate__4(Root, data)
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
function UITipsSkillView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mainInfo = tmp
end

---@private
function UITipsSkillView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/ContentItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/ContentItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contentItem = tmp
end

---@private
function UITipsSkillView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/ContentItem/SkillItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/ContentItem/SkillItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillItem = CommonUtil.BindGridViewItem2LuaStatic("SkillItem", tmp)
	self.skillItem.prefabName = "SkillItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UITipsSkillView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/Texts/TextName
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/Texts/TextName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UITipsSkillView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.type1 = tmp
end

---@private
function UITipsSkillView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type1/Text1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type1/Text1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.type1.text1 = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UITipsSkillView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type1/Text2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type1/Text2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.type1.text2 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UITipsSkillView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.type2 = tmp
end

---@private
function UITipsSkillView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type2/Text1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type2/Text1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.type2.text1 = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UITipsSkillView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type2/Text2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/MainInfo/Texts/Type2/Text2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.type2.text2 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UITipsSkillView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/SkillTag
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/SkillTag").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillTag = tmp
end

---@private
function UITipsSkillView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/SkillTag/SkillTagItem1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/SkillTag/SkillTagItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillTagItem1 = CommonUtil.BindGridViewItem2LuaStatic("SkillTagItem", tmp)
	self.skillTagItem1.prefabName = "SkillTagItem"
end

---@private
function UITipsSkillView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/SkillTag/SkillTagItem2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/SkillTag/SkillTagItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillTagItem2 = CommonUtil.BindGridViewItem2LuaStatic("SkillTagItem", tmp)
	self.skillTagItem2.prefabName = "SkillTagItem"
end

---@private
function UITipsSkillView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/SkillTag/SkillTagItem3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/SkillTag/SkillTagItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillTagItem3 = CommonUtil.BindGridViewItem2LuaStatic("SkillTagItem", tmp)
	self.skillTagItem3.prefabName = "SkillTagItem"
end

---@private
function UITipsSkillView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/SkillTag/SkillTagItem4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/SkillTag/SkillTagItem4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillTagItem4 = CommonUtil.BindGridViewItem2LuaStatic("SkillTagItem", tmp)
	self.skillTagItem4.prefabName = "SkillTagItem"
end

---@private
function UITipsSkillView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox/DscCurrent
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox/DscCurrent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscCurrent = tmp
end

---@private
function UITipsSkillView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox/DscCurrent/Level/Level
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox/DscCurrent/Level/Level").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscCurrent.level = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UITipsSkillView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox/DscCurrent/Txt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox/DscCurrent/Txt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscCurrent.txt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UITipsSkillView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox/DscNext
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox/DscNext").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscNext = tmp
end

---@private
function UITipsSkillView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox/DscNext/Level/Level
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox/DscNext/Level/Level").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscNext.level = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UITipsSkillView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox/DscNext/Txt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox/DscNext/Txt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscNext.txt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UITipsSkillView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox/MaxLevel
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox/MaxLevel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.maxLevel = tmp
end

---@private
function UITipsSkillView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox/MaxLevel/Max
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox/MaxLevel/Max").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.max = tmp
end

---@private
function UITipsSkillView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox/DscGai
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox/DscGai").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscGai = tmp
end

---@private
function UITipsSkillView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox/DscGai/Txt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox/DscGai/Txt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscGai.txt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UITipsSkillView:InitGenerate__30(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottomBox = tmp
end

---@private
function UITipsSkillView:InitGenerate__31(Root, data)
--[[
	UIAnimator/Window/Bg/BottomBox/BtnBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BottomBox/BtnBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBox = tmp
end

---@private
function UITipsSkillView:GenerateDestroy()
	if tolua.getpeer(self.dscGai.txt) ~= nil then
		tolua.setpeer(self.dscGai.txt, nil)
	end
	if tolua.getpeer(self.dscNext.txt) ~= nil then
		tolua.setpeer(self.dscNext.txt, nil)
	end
	if tolua.getpeer(self.dscNext.level) ~= nil then
		tolua.setpeer(self.dscNext.level, nil)
	end
	if tolua.getpeer(self.dscCurrent.txt) ~= nil then
		tolua.setpeer(self.dscCurrent.txt, nil)
	end
	if tolua.getpeer(self.dscCurrent.level) ~= nil then
		tolua.setpeer(self.dscCurrent.level, nil)
	end
	if tolua.getpeer(self.type2.text2) ~= nil then
		tolua.setpeer(self.type2.text2, nil)
	end
	if tolua.getpeer(self.type2.text1) ~= nil then
		tolua.setpeer(self.type2.text1, nil)
	end
	if tolua.getpeer(self.type1.text2) ~= nil then
		tolua.setpeer(self.type1.text2, nil)
	end
	if tolua.getpeer(self.type1.text1) ~= nil then
		tolua.setpeer(self.type1.text1, nil)
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
	if tolua.getpeer(self.mainInfo) ~= nil then
		tolua.setpeer(self.mainInfo, nil)
	end
	self.mainInfo = nil
	if tolua.getpeer(self.contentItem) ~= nil then
		tolua.setpeer(self.contentItem, nil)
	end
	self.contentItem = nil
	if self.skillItem.GenerateDestroy ~= nil then
		self.skillItem:GenerateDestroy()
	end
	if tolua.getpeer(self.skillItem) ~= nil then
		tolua.setpeer(self.skillItem, nil)
	end
	self.skillItem = nil
	if tolua.getpeer(self.textName) ~= nil then
		tolua.setpeer(self.textName, nil)
	end
	self.textName = nil
	if tolua.getpeer(self.type1) ~= nil then
		tolua.setpeer(self.type1, nil)
	end
	self.type1 = nil
	if tolua.getpeer(self.type2) ~= nil then
		tolua.setpeer(self.type2, nil)
	end
	self.type2 = nil
	if tolua.getpeer(self.skillTag) ~= nil then
		tolua.setpeer(self.skillTag, nil)
	end
	self.skillTag = nil
	if self.skillTagItem1.GenerateDestroy ~= nil then
		self.skillTagItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.skillTagItem1) ~= nil then
		tolua.setpeer(self.skillTagItem1, nil)
	end
	self.skillTagItem1 = nil
	if self.skillTagItem2.GenerateDestroy ~= nil then
		self.skillTagItem2:GenerateDestroy()
	end
	if tolua.getpeer(self.skillTagItem2) ~= nil then
		tolua.setpeer(self.skillTagItem2, nil)
	end
	self.skillTagItem2 = nil
	if self.skillTagItem3.GenerateDestroy ~= nil then
		self.skillTagItem3:GenerateDestroy()
	end
	if tolua.getpeer(self.skillTagItem3) ~= nil then
		tolua.setpeer(self.skillTagItem3, nil)
	end
	self.skillTagItem3 = nil
	if self.skillTagItem4.GenerateDestroy ~= nil then
		self.skillTagItem4:GenerateDestroy()
	end
	if tolua.getpeer(self.skillTagItem4) ~= nil then
		tolua.setpeer(self.skillTagItem4, nil)
	end
	self.skillTagItem4 = nil
	if tolua.getpeer(self.dscCurrent) ~= nil then
		tolua.setpeer(self.dscCurrent, nil)
	end
	self.dscCurrent = nil
	if tolua.getpeer(self.dscNext) ~= nil then
		tolua.setpeer(self.dscNext, nil)
	end
	self.dscNext = nil
	if tolua.getpeer(self.maxLevel) ~= nil then
		tolua.setpeer(self.maxLevel, nil)
	end
	self.maxLevel = nil
	if tolua.getpeer(self.max) ~= nil then
		tolua.setpeer(self.max, nil)
	end
	self.max = nil
	if tolua.getpeer(self.dscGai) ~= nil then
		tolua.setpeer(self.dscGai, nil)
	end
	self.dscGai = nil
	if tolua.getpeer(self.bottomBox) ~= nil then
		tolua.setpeer(self.bottomBox, nil)
	end
	self.bottomBox = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UITipsSkillView