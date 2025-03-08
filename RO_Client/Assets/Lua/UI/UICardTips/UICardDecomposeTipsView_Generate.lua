---@class UICardDecomposeTips__Generate_btnCancle
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICardDecomposeTips__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UICardDecomposeTips__Generate_btnDecompose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICardDecomposeTips__Generate_award3_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UICardDecomposeTips__Generate_awardItem3
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UICardDecomposeTips__Generate_award3
---@field public gameObject UnityEngine.GameObject
---@field public text UICardDecomposeTips__Generate_award3_text

---@class UICardDecomposeTips__Generate_award2_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UICardDecomposeTips__Generate_awardItem2
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UICardDecomposeTips__Generate_award2
---@field public gameObject UnityEngine.GameObject
---@field public text UICardDecomposeTips__Generate_award2_text

---@class UICardDecomposeTips__Generate_award1_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UICardDecomposeTips__Generate_awardItem1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UICardDecomposeTips__Generate_award1
---@field public gameObject UnityEngine.GameObject
---@field public text UICardDecomposeTips__Generate_award1_text

---@class UICardDecomposeTips__Generate_mVP_count
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UICardDecomposeTips__Generate_mVP_checkBox
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public check UnityEngine.GameObject

---@class UICardDecomposeTips__Generate_mVP
---@field public gameObject UnityEngine.GameObject
---@field public checkBox UICardDecomposeTips__Generate_mVP_checkBox
---@field public count UICardDecomposeTips__Generate_mVP_count

---@class UICardDecomposeTips__Generate_mini_count
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UICardDecomposeTips__Generate_mini_checkBox
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public check UnityEngine.GameObject

---@class UICardDecomposeTips__Generate_mini
---@field public gameObject UnityEngine.GameObject
---@field public checkBox UICardDecomposeTips__Generate_mini_checkBox
---@field public count UICardDecomposeTips__Generate_mini_count

---@class UICardDecomposeTips__Generate_normal_count
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UICardDecomposeTips__Generate_normal_checkBox
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public check UnityEngine.GameObject

---@class UICardDecomposeTips__Generate_normal
---@field public gameObject UnityEngine.GameObject
---@field public checkBox UICardDecomposeTips__Generate_normal_checkBox
---@field public count UICardDecomposeTips__Generate_normal_count

---@class UICardDecomposeTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICardDecomposeTips__Generate_window
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UICardDecomposeTips__Generate_alpha
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICardDecomposeTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private alpha UICardDecomposeTips__Generate_alpha
---@field private window UICardDecomposeTips__Generate_window
---@field private btnClose UICardDecomposeTips__Generate_btnClose
---@field private decompose UnityEngine.GameObject
---@field private normal UICardDecomposeTips__Generate_normal
---@field private mini UICardDecomposeTips__Generate_mini
---@field private mVP UICardDecomposeTips__Generate_mVP
---@field private award1 UICardDecomposeTips__Generate_award1
---@field private awardItem1 UICardDecomposeTips__Generate_awardItem1
---@field private award2 UICardDecomposeTips__Generate_award2
---@field private awardItem2 UICardDecomposeTips__Generate_awardItem2
---@field private award3 UICardDecomposeTips__Generate_award3
---@field private awardItem3 UICardDecomposeTips__Generate_awardItem3
---@field private btnBox UnityEngine.GameObject
---@field private btnDecompose UICardDecomposeTips__Generate_btnDecompose
---@field private text UICardDecomposeTips__Generate_text
---@field private btnCancle UICardDecomposeTips__Generate_btnCancle
local UICardDecomposeTipsView = class("UICardDecomposeTipsView", require("UIViewBase"))

function UICardDecomposeTipsView:ctor()
end

---@private
function UICardDecomposeTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UICardDecomposeTipsView:InitGenerate(Root, data)
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


end

---@private
function UICardDecomposeTipsView:InitGenerate__1(Root, data)
--[[
	Alpha
--]]
	local tmp = Root:Find("Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.alpha = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICardDecomposeTipsView:InitGenerate__2(Root, data)
--[[
	Window
--]]
	local tmp = Root:Find("Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UICardDecomposeTipsView:InitGenerate__3(Root, data)
--[[
	Window/Bg/BtnClose
--]]
	local tmp = Root:Find("Window/Bg/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICardDecomposeTipsView:InitGenerate__4(Root, data)
--[[
	Window/Bg/Decompose
--]]
	local tmp = Root:Find("Window/Bg/Decompose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.decompose = tmp
end

---@private
function UICardDecomposeTipsView:InitGenerate__5(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Normal
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Normal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.normal = tmp
end

---@private
function UICardDecomposeTipsView:InitGenerate__6(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Normal/CheckBox
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Normal/CheckBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.normal.checkBox = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICardDecomposeTipsView:InitGenerate__7(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Normal/CheckBox/Check
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Normal/CheckBox/Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.normal.checkBox.check = tmp
end

---@private
function UICardDecomposeTipsView:InitGenerate__8(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Normal/count
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Normal/count").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.normal.count = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UICardDecomposeTipsView:InitGenerate__9(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Mini
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Mini").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mini = tmp
end

---@private
function UICardDecomposeTipsView:InitGenerate__10(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Mini/CheckBox
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Mini/CheckBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mini.checkBox = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICardDecomposeTipsView:InitGenerate__11(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Mini/CheckBox/Check
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Mini/CheckBox/Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mini.checkBox.check = tmp
end

---@private
function UICardDecomposeTipsView:InitGenerate__12(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Mini/count
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Mini/count").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mini.count = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UICardDecomposeTipsView:InitGenerate__13(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/MVP
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/MVP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mVP = tmp
end

---@private
function UICardDecomposeTipsView:InitGenerate__14(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/MVP/CheckBox
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/MVP/CheckBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mVP.checkBox = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICardDecomposeTipsView:InitGenerate__15(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/MVP/CheckBox/Check
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/MVP/CheckBox/Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mVP.checkBox.check = tmp
end

---@private
function UICardDecomposeTipsView:InitGenerate__16(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/MVP/count
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/MVP/count").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mVP.count = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UICardDecomposeTipsView:InitGenerate__17(Root, data)
--[[
	Window/Bg/Return/ReturnBox/Award1
--]]
	local tmp = Root:Find("Window/Bg/Return/ReturnBox/Award1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.award1 = tmp
end

---@private
function UICardDecomposeTipsView:InitGenerate__18(Root, data)
--[[
	Window/Bg/Return/ReturnBox/Award1/Item/IconItem
--]]
	local tmp = Root:Find("Window/Bg/Return/ReturnBox/Award1/Item/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.awardItem1 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.awardItem1.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UICardDecomposeTipsView:InitGenerate__19(Root, data)
--[[
	Window/Bg/Return/ReturnBox/Award1/Number/Text
--]]
	local tmp = Root:Find("Window/Bg/Return/ReturnBox/Award1/Number/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.award1.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UICardDecomposeTipsView:InitGenerate__20(Root, data)
--[[
	Window/Bg/Return/ReturnBox/Award2
--]]
	local tmp = Root:Find("Window/Bg/Return/ReturnBox/Award2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.award2 = tmp
end

---@private
function UICardDecomposeTipsView:InitGenerate__21(Root, data)
--[[
	Window/Bg/Return/ReturnBox/Award2/Item/IconItem
--]]
	local tmp = Root:Find("Window/Bg/Return/ReturnBox/Award2/Item/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.awardItem2 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.awardItem2.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UICardDecomposeTipsView:InitGenerate__22(Root, data)
--[[
	Window/Bg/Return/ReturnBox/Award2/Number/Text
--]]
	local tmp = Root:Find("Window/Bg/Return/ReturnBox/Award2/Number/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.award2.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UICardDecomposeTipsView:InitGenerate__23(Root, data)
--[[
	Window/Bg/Return/ReturnBox/Award3
--]]
	local tmp = Root:Find("Window/Bg/Return/ReturnBox/Award3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.award3 = tmp
end

---@private
function UICardDecomposeTipsView:InitGenerate__24(Root, data)
--[[
	Window/Bg/Return/ReturnBox/Award3/Item/IconItem
--]]
	local tmp = Root:Find("Window/Bg/Return/ReturnBox/Award3/Item/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.awardItem3 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.awardItem3.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UICardDecomposeTipsView:InitGenerate__25(Root, data)
--[[
	Window/Bg/Return/ReturnBox/Award3/Number/Text
--]]
	local tmp = Root:Find("Window/Bg/Return/ReturnBox/Award3/Number/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.award3.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UICardDecomposeTipsView:InitGenerate__26(Root, data)
--[[
	Window/Bg/BtnBox
--]]
	local tmp = Root:Find("Window/Bg/BtnBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBox = tmp
end

---@private
function UICardDecomposeTipsView:InitGenerate__27(Root, data)
--[[
	Window/Bg/BtnBox/BtnDecompose
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/BtnDecompose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnDecompose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICardDecomposeTipsView:InitGenerate__28(Root, data)
--[[
	Window/Bg/BtnBox/BtnDecompose/Text
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/BtnDecompose/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UICardDecomposeTipsView:InitGenerate__29(Root, data)
--[[
	Window/Bg/BtnBox/BtnCancle
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/BtnCancle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCancle = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICardDecomposeTipsView:GenerateDestroy()
	if tolua.getpeer(self.award3.text) ~= nil then
		tolua.setpeer(self.award3.text, nil)
	end
	if tolua.getpeer(self.award2.text) ~= nil then
		tolua.setpeer(self.award2.text, nil)
	end
	if tolua.getpeer(self.award1.text) ~= nil then
		tolua.setpeer(self.award1.text, nil)
	end
	if tolua.getpeer(self.mVP.count) ~= nil then
		tolua.setpeer(self.mVP.count, nil)
	end
	if tolua.getpeer(self.mVP.checkBox.check) ~= nil then
		tolua.setpeer(self.mVP.checkBox.check, nil)
	end
	if tolua.getpeer(self.mVP.checkBox) ~= nil then
		tolua.setpeer(self.mVP.checkBox, nil)
	end
	if tolua.getpeer(self.mini.count) ~= nil then
		tolua.setpeer(self.mini.count, nil)
	end
	if tolua.getpeer(self.mini.checkBox.check) ~= nil then
		tolua.setpeer(self.mini.checkBox.check, nil)
	end
	if tolua.getpeer(self.mini.checkBox) ~= nil then
		tolua.setpeer(self.mini.checkBox, nil)
	end
	if tolua.getpeer(self.normal.count) ~= nil then
		tolua.setpeer(self.normal.count, nil)
	end
	if tolua.getpeer(self.normal.checkBox.check) ~= nil then
		tolua.setpeer(self.normal.checkBox.check, nil)
	end
	if tolua.getpeer(self.normal.checkBox) ~= nil then
		tolua.setpeer(self.normal.checkBox, nil)
	end
	if tolua.getpeer(self.alpha) ~= nil then
		tolua.setpeer(self.alpha, nil)
	end
	self.alpha = nil
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.decompose) ~= nil then
		tolua.setpeer(self.decompose, nil)
	end
	self.decompose = nil
	if tolua.getpeer(self.normal) ~= nil then
		tolua.setpeer(self.normal, nil)
	end
	self.normal = nil
	if tolua.getpeer(self.mini) ~= nil then
		tolua.setpeer(self.mini, nil)
	end
	self.mini = nil
	if tolua.getpeer(self.mVP) ~= nil then
		tolua.setpeer(self.mVP, nil)
	end
	self.mVP = nil
	if tolua.getpeer(self.award1) ~= nil then
		tolua.setpeer(self.award1, nil)
	end
	self.award1 = nil
	if self.awardItem1.GenerateDestroy ~= nil then
		self.awardItem1:GenerateDestroy()
	end
	if tolua.getpeer(self.awardItem1) ~= nil then
		tolua.setpeer(self.awardItem1, nil)
	end
	self.awardItem1 = nil
	if tolua.getpeer(self.award2) ~= nil then
		tolua.setpeer(self.award2, nil)
	end
	self.award2 = nil
	if self.awardItem2.GenerateDestroy ~= nil then
		self.awardItem2:GenerateDestroy()
	end
	if tolua.getpeer(self.awardItem2) ~= nil then
		tolua.setpeer(self.awardItem2, nil)
	end
	self.awardItem2 = nil
	if tolua.getpeer(self.award3) ~= nil then
		tolua.setpeer(self.award3, nil)
	end
	self.award3 = nil
	if self.awardItem3.GenerateDestroy ~= nil then
		self.awardItem3:GenerateDestroy()
	end
	if tolua.getpeer(self.awardItem3) ~= nil then
		tolua.setpeer(self.awardItem3, nil)
	end
	self.awardItem3 = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.btnDecompose) ~= nil then
		tolua.setpeer(self.btnDecompose, nil)
	end
	self.btnDecompose = nil
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.btnCancle) ~= nil then
		tolua.setpeer(self.btnCancle, nil)
	end
	self.btnCancle = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UICardDecomposeTipsView