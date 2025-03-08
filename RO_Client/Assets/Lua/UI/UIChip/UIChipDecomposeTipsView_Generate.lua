---@class UIChipDecomposeTips__Generate_btnCancle
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChipDecomposeTips__Generate_btnDecompose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChipDecomposeTips__Generate_award3_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChipDecomposeTips__Generate_award3
---@field public gameObject UnityEngine.GameObject
---@field public text UIChipDecomposeTips__Generate_award3_text

---@class UIChipDecomposeTips__Generate_award2_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChipDecomposeTips__Generate_award2
---@field public gameObject UnityEngine.GameObject
---@field public text UIChipDecomposeTips__Generate_award2_text

---@class UIChipDecomposeTips__Generate_award1_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChipDecomposeTips__Generate_award1
---@field public gameObject UnityEngine.GameObject
---@field public text UIChipDecomposeTips__Generate_award1_text

---@class UIChipDecomposeTips__Generate_quality5_content
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChipDecomposeTips__Generate_quality5_checkBox
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public check UnityEngine.GameObject

---@class UIChipDecomposeTips__Generate_quality5
---@field public gameObject UnityEngine.GameObject
---@field public checkBox UIChipDecomposeTips__Generate_quality5_checkBox
---@field public content UIChipDecomposeTips__Generate_quality5_content

---@class UIChipDecomposeTips__Generate_quality4_content
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChipDecomposeTips__Generate_quality4_checkBox
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public check UnityEngine.GameObject

---@class UIChipDecomposeTips__Generate_quality4
---@field public gameObject UnityEngine.GameObject
---@field public checkBox UIChipDecomposeTips__Generate_quality4_checkBox
---@field public content UIChipDecomposeTips__Generate_quality4_content

---@class UIChipDecomposeTips__Generate_quality3_content
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChipDecomposeTips__Generate_quality3_checkBox
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public check UnityEngine.GameObject

---@class UIChipDecomposeTips__Generate_quality3
---@field public gameObject UnityEngine.GameObject
---@field public checkBox UIChipDecomposeTips__Generate_quality3_checkBox
---@field public content UIChipDecomposeTips__Generate_quality3_content

---@class UIChipDecomposeTips__Generate_quality2_content
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChipDecomposeTips__Generate_quality2_checkBox
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public check UnityEngine.GameObject

---@class UIChipDecomposeTips__Generate_quality2
---@field public gameObject UnityEngine.GameObject
---@field public checkBox UIChipDecomposeTips__Generate_quality2_checkBox
---@field public content UIChipDecomposeTips__Generate_quality2_content

---@class UIChipDecomposeTips__Generate_quality1_content
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChipDecomposeTips__Generate_quality1_checkBox
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public check UnityEngine.GameObject

---@class UIChipDecomposeTips__Generate_quality1
---@field public gameObject UnityEngine.GameObject
---@field public checkBox UIChipDecomposeTips__Generate_quality1_checkBox
---@field public content UIChipDecomposeTips__Generate_quality1_content

---@class UIChipDecomposeTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChipDecomposeTips__Generate_window
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIChipDecomposeTips__Generate_alpha
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChipDecomposeTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private alpha UIChipDecomposeTips__Generate_alpha
---@field private window UIChipDecomposeTips__Generate_window
---@field private btnClose UIChipDecomposeTips__Generate_btnClose
---@field private decompose UnityEngine.GameObject
---@field private quality1 UIChipDecomposeTips__Generate_quality1
---@field private quality2 UIChipDecomposeTips__Generate_quality2
---@field private quality3 UIChipDecomposeTips__Generate_quality3
---@field private quality4 UIChipDecomposeTips__Generate_quality4
---@field private quality5 UIChipDecomposeTips__Generate_quality5
---@field private award1 UIChipDecomposeTips__Generate_award1
---@field private awardItem1 UnityEngine.GameObject
---@field private award2 UIChipDecomposeTips__Generate_award2
---@field private awardItem2 UnityEngine.GameObject
---@field private award3 UIChipDecomposeTips__Generate_award3
---@field private awardItem3 UnityEngine.GameObject
---@field private btnBox UnityEngine.GameObject
---@field private btnDecompose UIChipDecomposeTips__Generate_btnDecompose
---@field private btnCancle UIChipDecomposeTips__Generate_btnCancle
local UIChipDecomposeTipsView = class("UIChipDecomposeTipsView", require("UIViewBase"))

function UIChipDecomposeTipsView:ctor()
end

---@private
function UIChipDecomposeTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIChipDecomposeTipsView:InitGenerate(Root, data)
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
	self:InitGenerate__32(Root,data)
	self:InitGenerate__33(Root,data)
	self:InitGenerate__34(Root,data)
	self:InitGenerate__35(Root,data)
	self:InitGenerate__36(Root,data)


end

---@private
function UIChipDecomposeTipsView:InitGenerate__1(Root, data)
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
function UIChipDecomposeTipsView:InitGenerate__2(Root, data)
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
function UIChipDecomposeTipsView:InitGenerate__3(Root, data)
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
function UIChipDecomposeTipsView:InitGenerate__4(Root, data)
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
function UIChipDecomposeTipsView:InitGenerate__5(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality1
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality1 = tmp
end

---@private
function UIChipDecomposeTipsView:InitGenerate__6(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality1/CheckBox
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality1/CheckBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality1.checkBox = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIChipDecomposeTipsView:InitGenerate__7(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality1/CheckBox/Check
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality1/CheckBox/Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality1.checkBox.check = tmp
end

---@private
function UIChipDecomposeTipsView:InitGenerate__8(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality1/Content
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality1/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality1.content = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIChipDecomposeTipsView:InitGenerate__9(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality2
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality2 = tmp
end

---@private
function UIChipDecomposeTipsView:InitGenerate__10(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality2/CheckBox
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality2/CheckBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality2.checkBox = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIChipDecomposeTipsView:InitGenerate__11(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality2/CheckBox/Check
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality2/CheckBox/Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality2.checkBox.check = tmp
end

---@private
function UIChipDecomposeTipsView:InitGenerate__12(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality2/Content
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality2/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality2.content = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIChipDecomposeTipsView:InitGenerate__13(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality3
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality3 = tmp
end

---@private
function UIChipDecomposeTipsView:InitGenerate__14(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality3/CheckBox
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality3/CheckBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality3.checkBox = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIChipDecomposeTipsView:InitGenerate__15(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality3/CheckBox/Check
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality3/CheckBox/Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality3.checkBox.check = tmp
end

---@private
function UIChipDecomposeTipsView:InitGenerate__16(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality3/Content
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality3/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality3.content = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIChipDecomposeTipsView:InitGenerate__17(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality4
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality4 = tmp
end

---@private
function UIChipDecomposeTipsView:InitGenerate__18(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality4/CheckBox
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality4/CheckBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality4.checkBox = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIChipDecomposeTipsView:InitGenerate__19(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality4/CheckBox/Check
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality4/CheckBox/Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality4.checkBox.check = tmp
end

---@private
function UIChipDecomposeTipsView:InitGenerate__20(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality4/Content
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality4/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality4.content = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIChipDecomposeTipsView:InitGenerate__21(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality5
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality5 = tmp
end

---@private
function UIChipDecomposeTipsView:InitGenerate__22(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality5/CheckBox
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality5/CheckBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality5.checkBox = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIChipDecomposeTipsView:InitGenerate__23(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality5/CheckBox/Check
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality5/CheckBox/Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality5.checkBox.check = tmp
end

---@private
function UIChipDecomposeTipsView:InitGenerate__24(Root, data)
--[[
	Window/Bg/Decompose/CardDecompose/Quality5/Content
--]]
	local tmp = Root:Find("Window/Bg/Decompose/CardDecompose/Quality5/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.quality5.content = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIChipDecomposeTipsView:InitGenerate__25(Root, data)
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
function UIChipDecomposeTipsView:InitGenerate__26(Root, data)
--[[
	Window/Bg/Return/ReturnBox/Award1/Item/IconItem
--]]
	local tmp = Root:Find("Window/Bg/Return/ReturnBox/Award1/Item/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.awardItem1 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.awardItem1.prefabName = "IconItem"
end

---@private
function UIChipDecomposeTipsView:InitGenerate__27(Root, data)
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
function UIChipDecomposeTipsView:InitGenerate__28(Root, data)
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
function UIChipDecomposeTipsView:InitGenerate__29(Root, data)
--[[
	Window/Bg/Return/ReturnBox/Award2/Item/IconItem
--]]
	local tmp = Root:Find("Window/Bg/Return/ReturnBox/Award2/Item/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.awardItem2 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.awardItem2.prefabName = "IconItem"
end

---@private
function UIChipDecomposeTipsView:InitGenerate__30(Root, data)
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
function UIChipDecomposeTipsView:InitGenerate__31(Root, data)
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
function UIChipDecomposeTipsView:InitGenerate__32(Root, data)
--[[
	Window/Bg/Return/ReturnBox/Award3/Item/IconItem
--]]
	local tmp = Root:Find("Window/Bg/Return/ReturnBox/Award3/Item/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.awardItem3 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.awardItem3.prefabName = "IconItem"
end

---@private
function UIChipDecomposeTipsView:InitGenerate__33(Root, data)
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
function UIChipDecomposeTipsView:InitGenerate__34(Root, data)
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
function UIChipDecomposeTipsView:InitGenerate__35(Root, data)
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
function UIChipDecomposeTipsView:InitGenerate__36(Root, data)
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
function UIChipDecomposeTipsView:GenerateDestroy()
	if tolua.getpeer(self.award3.text) ~= nil then
		tolua.setpeer(self.award3.text, nil)
	end
	if tolua.getpeer(self.award2.text) ~= nil then
		tolua.setpeer(self.award2.text, nil)
	end
	if tolua.getpeer(self.award1.text) ~= nil then
		tolua.setpeer(self.award1.text, nil)
	end
	if tolua.getpeer(self.quality5.content) ~= nil then
		tolua.setpeer(self.quality5.content, nil)
	end
	if tolua.getpeer(self.quality5.checkBox.check) ~= nil then
		tolua.setpeer(self.quality5.checkBox.check, nil)
	end
	if tolua.getpeer(self.quality5.checkBox) ~= nil then
		tolua.setpeer(self.quality5.checkBox, nil)
	end
	if tolua.getpeer(self.quality4.content) ~= nil then
		tolua.setpeer(self.quality4.content, nil)
	end
	if tolua.getpeer(self.quality4.checkBox.check) ~= nil then
		tolua.setpeer(self.quality4.checkBox.check, nil)
	end
	if tolua.getpeer(self.quality4.checkBox) ~= nil then
		tolua.setpeer(self.quality4.checkBox, nil)
	end
	if tolua.getpeer(self.quality3.content) ~= nil then
		tolua.setpeer(self.quality3.content, nil)
	end
	if tolua.getpeer(self.quality3.checkBox.check) ~= nil then
		tolua.setpeer(self.quality3.checkBox.check, nil)
	end
	if tolua.getpeer(self.quality3.checkBox) ~= nil then
		tolua.setpeer(self.quality3.checkBox, nil)
	end
	if tolua.getpeer(self.quality2.content) ~= nil then
		tolua.setpeer(self.quality2.content, nil)
	end
	if tolua.getpeer(self.quality2.checkBox.check) ~= nil then
		tolua.setpeer(self.quality2.checkBox.check, nil)
	end
	if tolua.getpeer(self.quality2.checkBox) ~= nil then
		tolua.setpeer(self.quality2.checkBox, nil)
	end
	if tolua.getpeer(self.quality1.content) ~= nil then
		tolua.setpeer(self.quality1.content, nil)
	end
	if tolua.getpeer(self.quality1.checkBox.check) ~= nil then
		tolua.setpeer(self.quality1.checkBox.check, nil)
	end
	if tolua.getpeer(self.quality1.checkBox) ~= nil then
		tolua.setpeer(self.quality1.checkBox, nil)
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
	if tolua.getpeer(self.quality1) ~= nil then
		tolua.setpeer(self.quality1, nil)
	end
	self.quality1 = nil
	if tolua.getpeer(self.quality2) ~= nil then
		tolua.setpeer(self.quality2, nil)
	end
	self.quality2 = nil
	if tolua.getpeer(self.quality3) ~= nil then
		tolua.setpeer(self.quality3, nil)
	end
	self.quality3 = nil
	if tolua.getpeer(self.quality4) ~= nil then
		tolua.setpeer(self.quality4, nil)
	end
	self.quality4 = nil
	if tolua.getpeer(self.quality5) ~= nil then
		tolua.setpeer(self.quality5, nil)
	end
	self.quality5 = nil
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
	if tolua.getpeer(self.btnCancle) ~= nil then
		tolua.setpeer(self.btnCancle, nil)
	end
	self.btnCancle = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIChipDecomposeTipsView