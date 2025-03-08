---@class UIFashionPaperTips__Generate_decomposeBtn_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIFashionPaperTips__Generate_decomposeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIFashionPaperTips__Generate_decomposeBtn_text

---@class UIFashionPaperTips__Generate_composeBtn_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIFashionPaperTips__Generate_composeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIFashionPaperTips__Generate_composeBtn_text

---@class UIFashionPaperTips__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionPaperTips__Generate_materialItem_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionPaperTips__Generate_materialItem_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionPaperTips__Generate_materialItem
---@field public gameObject UnityEngine.GameObject
---@field public text UIFashionPaperTips__Generate_materialItem_text
---@field public number UIFashionPaperTips__Generate_materialItem_number

---@class UIFashionPaperTips__Generate_suitTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionPaperTips__Generate_equipBox_attrs_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIFashionPaperTips__Generate_equipBox_attrs
---@field public gameObject UnityEngine.GameObject
---@field public text UIFashionPaperTips__Generate_equipBox_attrs_text
---@field public grid UnityEngine.GameObject

---@class UIFashionPaperTips__Generate_equipBox
---@field public gameObject UnityEngine.GameObject
---@field public attrs UIFashionPaperTips__Generate_equipBox_attrs
---@field public needMaterials UnityEngine.GameObject

---@class UIFashionPaperTips__Generate_textType
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIFashionPaperTips__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionPaperTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionPaperTips__Generate_window
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIFashionPaperTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIEventHandler UIEventHandler
---@field private window UIFashionPaperTips__Generate_window
---@field private closeBox UnityEngine.GameObject
---@field private btnClose UIFashionPaperTips__Generate_btnClose
---@field private topItem UnityEngine.GameObject
---@field private contentItem UnityEngine.GameObject
---@field private textName UIFashionPaperTips__Generate_textName
---@field private textType UIFashionPaperTips__Generate_textType
---@field private composedTxt UnityEngine.GameObject
---@field private equipBox UIFashionPaperTips__Generate_equipBox
---@field private suitTxt UIFashionPaperTips__Generate_suitTxt
---@field private materialItem UIFashionPaperTips__Generate_materialItem
---@field private desTxt UIFashionPaperTips__Generate_desTxt
---@field private btnBox UnityEngine.GameObject
---@field private composeBtn UIFashionPaperTips__Generate_composeBtn
---@field private decomposeBtn UIFashionPaperTips__Generate_decomposeBtn
local UIFashionPaperTipsView = class("UIFashionPaperTipsView", require("UIViewBase"))

function UIFashionPaperTipsView:ctor()
end

---@private
function UIFashionPaperTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIFashionPaperTipsView:InitGenerate(Root, data)
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


end

---@private
function UIFashionPaperTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.uIEventHandler = Root:GetComponent(Enum.TypeInfo.UIEventHandler)
end

---@private
function UIFashionPaperTipsView:InitGenerate__2(Root, data)
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
function UIFashionPaperTipsView:InitGenerate__3(Root, data)
--[[
	Window/Bg/CloseBox
--]]
	local tmp = Root:Find("Window/Bg/CloseBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBox = tmp
end

---@private
function UIFashionPaperTipsView:InitGenerate__4(Root, data)
--[[
	Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFashionPaperTipsView:InitGenerate__5(Root, data)
--[[
	Window/Bg/TopItem
--]]
	local tmp = Root:Find("Window/Bg/TopItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.topItem = tmp
end

---@private
function UIFashionPaperTipsView:InitGenerate__6(Root, data)
--[[
	Window/Bg/TopItem/ContentItem
--]]
	local tmp = Root:Find("Window/Bg/TopItem/ContentItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contentItem = tmp
end

---@private
function UIFashionPaperTipsView:InitGenerate__7(Root, data)
--[[
	Window/Bg/TopItem/Texts/TextName
--]]
	local tmp = Root:Find("Window/Bg/TopItem/Texts/TextName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionPaperTipsView:InitGenerate__8(Root, data)
--[[
	Window/Bg/TopItem/Texts/TextType
--]]
	local tmp = Root:Find("Window/Bg/TopItem/Texts/TextType").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textType = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIFashionPaperTipsView:InitGenerate__9(Root, data)
--[[
	Window/Bg/TopItem/ComposedTxt
--]]
	local tmp = Root:Find("Window/Bg/TopItem/ComposedTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.composedTxt = tmp
end

---@private
function UIFashionPaperTipsView:InitGenerate__10(Root, data)
--[[
	Window/Bg/EquipBox
--]]
	local tmp = Root:Find("Window/Bg/EquipBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBox = tmp
end

---@private
function UIFashionPaperTipsView:InitGenerate__11(Root, data)
--[[
	Window/Bg/EquipBox/Attrs
--]]
	local tmp = Root:Find("Window/Bg/EquipBox/Attrs").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBox.attrs = tmp
end

---@private
function UIFashionPaperTipsView:InitGenerate__12(Root, data)
--[[
	Window/Bg/EquipBox/Attrs/TitleBase/Text
--]]
	local tmp = Root:Find("Window/Bg/EquipBox/Attrs/TitleBase/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBox.attrs.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIFashionPaperTipsView:InitGenerate__13(Root, data)
--[[
	Window/Bg/EquipBox/Attrs/Grid
--]]
	local tmp = Root:Find("Window/Bg/EquipBox/Attrs/Grid").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBox.attrs.grid = tmp
end

---@private
function UIFashionPaperTipsView:InitGenerate__14(Root, data)
--[[
	Window/Bg/EquipBox/NeedMaterials
--]]
	local tmp = Root:Find("Window/Bg/EquipBox/NeedMaterials").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBox.needMaterials = tmp
end

---@private
function UIFashionPaperTipsView:InitGenerate__15(Root, data)
--[[
	Window/Bg/EquipBox/NeedMaterials/TitleSuit/SuitTxt
--]]
	local tmp = Root:Find("Window/Bg/EquipBox/NeedMaterials/TitleSuit/SuitTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.suitTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionPaperTipsView:InitGenerate__16(Root, data)
--[[
	Window/Bg/EquipBox/NeedMaterials/MaterialItem
--]]
	local tmp = Root:Find("Window/Bg/EquipBox/NeedMaterials/MaterialItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.materialItem = tmp
end

---@private
function UIFashionPaperTipsView:InitGenerate__17(Root, data)
--[[
	Window/Bg/EquipBox/NeedMaterials/MaterialItem/Text
--]]
	local tmp = Root:Find("Window/Bg/EquipBox/NeedMaterials/MaterialItem/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.materialItem.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionPaperTipsView:InitGenerate__18(Root, data)
--[[
	Window/Bg/EquipBox/NeedMaterials/MaterialItem/Number
--]]
	local tmp = Root:Find("Window/Bg/EquipBox/NeedMaterials/MaterialItem/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.materialItem.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionPaperTipsView:InitGenerate__19(Root, data)
--[[
	Window/Bg/DscBox/DesTxt
--]]
	local tmp = Root:Find("Window/Bg/DscBox/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionPaperTipsView:InitGenerate__20(Root, data)
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
function UIFashionPaperTipsView:InitGenerate__21(Root, data)
--[[
	Window/Bg/BtnBox/ComposeBtn
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/ComposeBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.composeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFashionPaperTipsView:InitGenerate__22(Root, data)
--[[
	Window/Bg/BtnBox/ComposeBtn/Text
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/ComposeBtn/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.composeBtn.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIFashionPaperTipsView:InitGenerate__23(Root, data)
--[[
	Window/Bg/BtnBox/DecomposeBtn
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/DecomposeBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.decomposeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFashionPaperTipsView:InitGenerate__24(Root, data)
--[[
	Window/Bg/BtnBox/DecomposeBtn/Text
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/DecomposeBtn/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.decomposeBtn.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIFashionPaperTipsView:GenerateDestroy()
	if tolua.getpeer(self.decomposeBtn.text) ~= nil then
		tolua.setpeer(self.decomposeBtn.text, nil)
	end
	if tolua.getpeer(self.composeBtn.text) ~= nil then
		tolua.setpeer(self.composeBtn.text, nil)
	end
	if tolua.getpeer(self.materialItem.number) ~= nil then
		tolua.setpeer(self.materialItem.number, nil)
	end
	if tolua.getpeer(self.materialItem.text) ~= nil then
		tolua.setpeer(self.materialItem.text, nil)
	end
	if tolua.getpeer(self.equipBox.needMaterials) ~= nil then
		tolua.setpeer(self.equipBox.needMaterials, nil)
	end
	if tolua.getpeer(self.equipBox.attrs.grid) ~= nil then
		tolua.setpeer(self.equipBox.attrs.grid, nil)
	end
	if tolua.getpeer(self.equipBox.attrs.text) ~= nil then
		tolua.setpeer(self.equipBox.attrs.text, nil)
	end
	if tolua.getpeer(self.equipBox.attrs) ~= nil then
		tolua.setpeer(self.equipBox.attrs, nil)
	end
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if tolua.getpeer(self.closeBox) ~= nil then
		tolua.setpeer(self.closeBox, nil)
	end
	self.closeBox = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.topItem) ~= nil then
		tolua.setpeer(self.topItem, nil)
	end
	self.topItem = nil
	if tolua.getpeer(self.contentItem) ~= nil then
		tolua.setpeer(self.contentItem, nil)
	end
	self.contentItem = nil
	if tolua.getpeer(self.textName) ~= nil then
		tolua.setpeer(self.textName, nil)
	end
	self.textName = nil
	if tolua.getpeer(self.textType) ~= nil then
		tolua.setpeer(self.textType, nil)
	end
	self.textType = nil
	if tolua.getpeer(self.composedTxt) ~= nil then
		tolua.setpeer(self.composedTxt, nil)
	end
	self.composedTxt = nil
	if tolua.getpeer(self.equipBox) ~= nil then
		tolua.setpeer(self.equipBox, nil)
	end
	self.equipBox = nil
	if tolua.getpeer(self.suitTxt) ~= nil then
		tolua.setpeer(self.suitTxt, nil)
	end
	self.suitTxt = nil
	if tolua.getpeer(self.materialItem) ~= nil then
		tolua.setpeer(self.materialItem, nil)
	end
	self.materialItem = nil
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.composeBtn) ~= nil then
		tolua.setpeer(self.composeBtn, nil)
	end
	self.composeBtn = nil
	if tolua.getpeer(self.decomposeBtn) ~= nil then
		tolua.setpeer(self.decomposeBtn, nil)
	end
	self.decomposeBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIFashionPaperTipsView