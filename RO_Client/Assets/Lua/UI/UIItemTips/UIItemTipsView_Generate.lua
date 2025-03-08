---@class UIItemTips__Generate_btn_Compose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIItemTips__Generate_btn_Decompose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIItemTips__Generate_btn_Info
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIItemTips__Generate_btn_Equip
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIItemTips__Generate_btn_Sell
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIItemTips__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIItemTips__Generate_suitActiveTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIItemTips__Generate_suitTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIItemTips__Generate_equipBox_base
---@field public gameObject UnityEngine.GameObject
---@field public grid UnityEngine.GameObject

---@class UIItemTips__Generate_equipBox
---@field public gameObject UnityEngine.GameObject
---@field public base UIItemTips__Generate_equipBox_base
---@field public suit UnityEngine.GameObject

---@class UIItemTips__Generate_textNumber
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIItemTips__Generate_textType
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIItemTips__Generate_textName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIItemTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIItemTips__Generate_window
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIItemTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIEventHandler UIEventHandler
---@field private window UIItemTips__Generate_window
---@field private closeBox UnityEngine.GameObject
---@field private btnClose UIItemTips__Generate_btnClose
---@field private contentItem UnityEngine.GameObject
---@field private textName UIItemTips__Generate_textName
---@field private textType UIItemTips__Generate_textType
---@field private textNumber UIItemTips__Generate_textNumber
---@field private equipBox UIItemTips__Generate_equipBox
---@field private suitTxt UIItemTips__Generate_suitTxt
---@field private suitActiveTxt UIItemTips__Generate_suitActiveTxt
---@field private desTxt UIItemTips__Generate_desTxt
---@field private bottomBox UnityEngine.GameObject
---@field private btnBox UnityEngine.GameObject
---@field private btn_Sell UIItemTips__Generate_btn_Sell
---@field private btn_Equip UIItemTips__Generate_btn_Equip
---@field private btn_Info UIItemTips__Generate_btn_Info
---@field private btn_Decompose UIItemTips__Generate_btn_Decompose
---@field private btn_Compose UIItemTips__Generate_btn_Compose
local UIItemTipsView = class("UIItemTipsView", require("UIViewBase"))

function UIItemTipsView:ctor()
end

---@private
function UIItemTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIItemTipsView:InitGenerate(Root, data)
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


end

---@private
function UIItemTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.uIEventHandler = Root:GetComponent(Enum.TypeInfo.UIEventHandler)
end

---@private
function UIItemTipsView:InitGenerate__2(Root, data)
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
function UIItemTipsView:InitGenerate__3(Root, data)
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
function UIItemTipsView:InitGenerate__4(Root, data)
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
function UIItemTipsView:InitGenerate__5(Root, data)
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
function UIItemTipsView:InitGenerate__6(Root, data)
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
function UIItemTipsView:InitGenerate__7(Root, data)
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
function UIItemTipsView:InitGenerate__8(Root, data)
--[[
	Window/Bg/TopItem/Texts/TextNumber
--]]
	local tmp = Root:Find("Window/Bg/TopItem/Texts/TextNumber").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textNumber = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIItemTipsView:InitGenerate__9(Root, data)
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
function UIItemTipsView:InitGenerate__10(Root, data)
--[[
	Window/Bg/EquipBox/Base
--]]
	local tmp = Root:Find("Window/Bg/EquipBox/Base").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBox.base = tmp
end

---@private
function UIItemTipsView:InitGenerate__11(Root, data)
--[[
	Window/Bg/EquipBox/Base/Grid
--]]
	local tmp = Root:Find("Window/Bg/EquipBox/Base/Grid").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBox.base.grid = tmp
end

---@private
function UIItemTipsView:InitGenerate__12(Root, data)
--[[
	Window/Bg/EquipBox/Suit
--]]
	local tmp = Root:Find("Window/Bg/EquipBox/Suit").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBox.suit = tmp
end

---@private
function UIItemTipsView:InitGenerate__13(Root, data)
--[[
	Window/Bg/EquipBox/Suit/TitleSuit/SuitTxt
--]]
	local tmp = Root:Find("Window/Bg/EquipBox/Suit/TitleSuit/SuitTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.suitTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIItemTipsView:InitGenerate__14(Root, data)
--[[
	Window/Bg/EquipBox/Suit/TitleSuit/SuitActiveTxt
--]]
	local tmp = Root:Find("Window/Bg/EquipBox/Suit/TitleSuit/SuitActiveTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.suitActiveTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIItemTipsView:InitGenerate__15(Root, data)
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
function UIItemTipsView:InitGenerate__16(Root, data)
--[[
	Window/Bg/BottomBox
--]]
	local tmp = Root:Find("Window/Bg/BottomBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottomBox = tmp
end

---@private
function UIItemTipsView:InitGenerate__17(Root, data)
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
function UIItemTipsView:InitGenerate__18(Root, data)
--[[
	Window/Bg/BtnBox/Btn_Sell
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/Btn_Sell").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btn_Sell = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIItemTipsView:InitGenerate__19(Root, data)
--[[
	Window/Bg/BtnBox/Btn_Equip
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/Btn_Equip").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btn_Equip = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIItemTipsView:InitGenerate__20(Root, data)
--[[
	Window/Bg/BtnBox/Btn_Info
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/Btn_Info").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btn_Info = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIItemTipsView:InitGenerate__21(Root, data)
--[[
	Window/Bg/BtnBox/Btn_Decompose
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/Btn_Decompose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btn_Decompose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIItemTipsView:InitGenerate__22(Root, data)
--[[
	Window/Bg/BtnBox/Btn_Compose
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/Btn_Compose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btn_Compose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIItemTipsView:GenerateDestroy()
	if tolua.getpeer(self.equipBox.suit) ~= nil then
		tolua.setpeer(self.equipBox.suit, nil)
	end
	if tolua.getpeer(self.equipBox.base.grid) ~= nil then
		tolua.setpeer(self.equipBox.base.grid, nil)
	end
	if tolua.getpeer(self.equipBox.base) ~= nil then
		tolua.setpeer(self.equipBox.base, nil)
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
	if tolua.getpeer(self.textNumber) ~= nil then
		tolua.setpeer(self.textNumber, nil)
	end
	self.textNumber = nil
	if tolua.getpeer(self.equipBox) ~= nil then
		tolua.setpeer(self.equipBox, nil)
	end
	self.equipBox = nil
	if tolua.getpeer(self.suitTxt) ~= nil then
		tolua.setpeer(self.suitTxt, nil)
	end
	self.suitTxt = nil
	if tolua.getpeer(self.suitActiveTxt) ~= nil then
		tolua.setpeer(self.suitActiveTxt, nil)
	end
	self.suitActiveTxt = nil
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	if tolua.getpeer(self.bottomBox) ~= nil then
		tolua.setpeer(self.bottomBox, nil)
	end
	self.bottomBox = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.btn_Sell) ~= nil then
		tolua.setpeer(self.btn_Sell, nil)
	end
	self.btn_Sell = nil
	if tolua.getpeer(self.btn_Equip) ~= nil then
		tolua.setpeer(self.btn_Equip, nil)
	end
	self.btn_Equip = nil
	if tolua.getpeer(self.btn_Info) ~= nil then
		tolua.setpeer(self.btn_Info, nil)
	end
	self.btn_Info = nil
	if tolua.getpeer(self.btn_Decompose) ~= nil then
		tolua.setpeer(self.btn_Decompose, nil)
	end
	self.btn_Decompose = nil
	if tolua.getpeer(self.btn_Compose) ~= nil then
		tolua.setpeer(self.btn_Compose, nil)
	end
	self.btn_Compose = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIItemTipsView