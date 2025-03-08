---@class UIFashionGot__Generate_property5_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionGot__Generate_property5_attrName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionGot__Generate_property5
---@field public gameObject UnityEngine.GameObject
---@field public attrName UIFashionGot__Generate_property5_attrName
---@field public number UIFashionGot__Generate_property5_number

---@class UIFashionGot__Generate_property4_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionGot__Generate_property4_attrName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionGot__Generate_property4
---@field public gameObject UnityEngine.GameObject
---@field public attrName UIFashionGot__Generate_property4_attrName
---@field public number UIFashionGot__Generate_property4_number

---@class UIFashionGot__Generate_property3_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionGot__Generate_property3_attrName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionGot__Generate_property3
---@field public gameObject UnityEngine.GameObject
---@field public attrName UIFashionGot__Generate_property3_attrName
---@field public number UIFashionGot__Generate_property3_number

---@class UIFashionGot__Generate_property2_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionGot__Generate_property2_attrName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionGot__Generate_property2
---@field public gameObject UnityEngine.GameObject
---@field public attrName UIFashionGot__Generate_property2_attrName
---@field public number UIFashionGot__Generate_property2_number

---@class UIFashionGot__Generate_property1_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionGot__Generate_property1_attrName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionGot__Generate_property1
---@field public gameObject UnityEngine.GameObject
---@field public attrName UIFashionGot__Generate_property1_attrName
---@field public number UIFashionGot__Generate_property1_number

---@class UIFashionGot__Generate_equipBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionGot__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionGot__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIFashionGot__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIFashionGot__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class UIFashionGot__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionGot__Generate_alpha
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionGot__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIFashionGot__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIFashionGot__Generate_uIAnimator
---@field private alpha UIFashionGot__Generate_alpha
---@field private nameTxt UIFashionGot__Generate_nameTxt
---@field private bg UIFashionGot__Generate_bg
---@field private icon UIFashionGot__Generate_icon
---@field private frame UIFashionGot__Generate_frame
---@field private closeBox UnityEngine.GameObject
---@field private btnClose UIFashionGot__Generate_btnClose
---@field private equipBtn UIFashionGot__Generate_equipBtn
---@field private property1 UIFashionGot__Generate_property1
---@field private property2 UIFashionGot__Generate_property2
---@field private property3 UIFashionGot__Generate_property3
---@field private property4 UIFashionGot__Generate_property4
---@field private property5 UIFashionGot__Generate_property5
local UIFashionGotView = class("UIFashionGotView", require("UIViewBase"))

function UIFashionGotView:ctor()
end

---@private
function UIFashionGotView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIFashionGotView:InitGenerate(Root, data)
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
function UIFashionGotView:InitGenerate__1(Root, data)
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
function UIFashionGotView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.alpha = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFashionGotView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Bg/Name/NameTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Name/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionGotView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/Item/Bg
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Item/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFashionGotView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/Item/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Item/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIFashionGotView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/Item/Frame
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Item/Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frame = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIFashionGotView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBox = tmp
end

---@private
function UIFashionGotView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFashionGotView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/EquipBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/EquipBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFashionGotView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/Property1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property1 = tmp
end

---@private
function UIFashionGotView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/Property1/AttrName
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property1/AttrName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property1.attrName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionGotView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/Property1/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property1/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property1.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionGotView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/Property2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property2 = tmp
end

---@private
function UIFashionGotView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/Property2/AttrName
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property2/AttrName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property2.attrName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionGotView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/Property2/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property2/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property2.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionGotView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/Property3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property3 = tmp
end

---@private
function UIFashionGotView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/Property3/AttrName
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property3/AttrName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property3.attrName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionGotView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/Property3/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property3/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property3.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionGotView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/Property4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property4 = tmp
end

---@private
function UIFashionGotView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bg/Property4/AttrName
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property4/AttrName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property4.attrName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionGotView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bg/Property4/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property4/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property4.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionGotView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bg/Property5
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property5 = tmp
end

---@private
function UIFashionGotView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/Bg/Property5/AttrName
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property5/AttrName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property5.attrName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionGotView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/Bg/Property5/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Property5/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property5.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionGotView:GenerateDestroy()
	if tolua.getpeer(self.property5.number) ~= nil then
		tolua.setpeer(self.property5.number, nil)
	end
	if tolua.getpeer(self.property5.attrName) ~= nil then
		tolua.setpeer(self.property5.attrName, nil)
	end
	if tolua.getpeer(self.property4.number) ~= nil then
		tolua.setpeer(self.property4.number, nil)
	end
	if tolua.getpeer(self.property4.attrName) ~= nil then
		tolua.setpeer(self.property4.attrName, nil)
	end
	if tolua.getpeer(self.property3.number) ~= nil then
		tolua.setpeer(self.property3.number, nil)
	end
	if tolua.getpeer(self.property3.attrName) ~= nil then
		tolua.setpeer(self.property3.attrName, nil)
	end
	if tolua.getpeer(self.property2.number) ~= nil then
		tolua.setpeer(self.property2.number, nil)
	end
	if tolua.getpeer(self.property2.attrName) ~= nil then
		tolua.setpeer(self.property2.attrName, nil)
	end
	if tolua.getpeer(self.property1.number) ~= nil then
		tolua.setpeer(self.property1.number, nil)
	end
	if tolua.getpeer(self.property1.attrName) ~= nil then
		tolua.setpeer(self.property1.attrName, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.alpha) ~= nil then
		tolua.setpeer(self.alpha, nil)
	end
	self.alpha = nil
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	self.frame = nil
	if tolua.getpeer(self.closeBox) ~= nil then
		tolua.setpeer(self.closeBox, nil)
	end
	self.closeBox = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.equipBtn) ~= nil then
		tolua.setpeer(self.equipBtn, nil)
	end
	self.equipBtn = nil
	if tolua.getpeer(self.property1) ~= nil then
		tolua.setpeer(self.property1, nil)
	end
	self.property1 = nil
	if tolua.getpeer(self.property2) ~= nil then
		tolua.setpeer(self.property2, nil)
	end
	self.property2 = nil
	if tolua.getpeer(self.property3) ~= nil then
		tolua.setpeer(self.property3, nil)
	end
	self.property3 = nil
	if tolua.getpeer(self.property4) ~= nil then
		tolua.setpeer(self.property4, nil)
	end
	self.property4 = nil
	if tolua.getpeer(self.property5) ~= nil then
		tolua.setpeer(self.property5, nil)
	end
	self.property5 = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIFashionGotView