---@class UIVoyageRobbery__Generate_robNum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIVoyageRobbery__Generate_btnChallenge
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVoyageRobbery__Generate_btnCancleText
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIVoyageRobbery__Generate_btnCancle
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVoyageRobbery__Generate_timerTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIVoyageRobbery__Generate_currency3_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIVoyageRobbery__Generate_currency3_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIVoyageRobbery__Generate_currency3
---@field public gameObject UnityEngine.GameObject
---@field public icon UIVoyageRobbery__Generate_currency3_icon
---@field public text UIVoyageRobbery__Generate_currency3_text

---@class UIVoyageRobbery__Generate_currency2_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIVoyageRobbery__Generate_currency2_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIVoyageRobbery__Generate_currency2
---@field public gameObject UnityEngine.GameObject
---@field public icon UIVoyageRobbery__Generate_currency2_icon
---@field public text UIVoyageRobbery__Generate_currency2_text

---@class UIVoyageRobbery__Generate_currency1_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIVoyageRobbery__Generate_currency1_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIVoyageRobbery__Generate_currency1
---@field public gameObject UnityEngine.GameObject
---@field public icon UIVoyageRobbery__Generate_currency1_icon
---@field public text UIVoyageRobbery__Generate_currency1_text

---@class UIVoyageRobbery__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIVoyageRobbery__Generate_beRobNum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIVoyageRobbery__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVoyageRobbery__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVoyageRobbery__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIVoyageRobbery__Generate_AnyBtn
---@field private btnClose UIVoyageRobbery__Generate_btnClose
---@field private beRobNum UIVoyageRobbery__Generate_beRobNum
---@field private nameSp UnityEngine.GameObject
---@field private nameTxt UIVoyageRobbery__Generate_nameTxt
---@field private currency1 UIVoyageRobbery__Generate_currency1
---@field private currency2 UIVoyageRobbery__Generate_currency2
---@field private currency3 UIVoyageRobbery__Generate_currency3
---@field private timer UnityEngine.GameObject
---@field private timerTxt UIVoyageRobbery__Generate_timerTxt
---@field private box UnityEngine.GameObject
---@field private btnCancle UIVoyageRobbery__Generate_btnCancle
---@field private btnCancleText UIVoyageRobbery__Generate_btnCancleText
---@field private btnChallenge UIVoyageRobbery__Generate_btnChallenge
---@field private robNum UIVoyageRobbery__Generate_robNum
local UIVoyageRobberyView = class("UIVoyageRobberyView", require("UIViewBase"))

function UIVoyageRobberyView:ctor()
end

---@private
function UIVoyageRobberyView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIVoyageRobberyView:InitGenerate(Root, data)
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
function UIVoyageRobberyView:InitGenerate__1(Root, data)
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
function UIVoyageRobberyView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/BG/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVoyageRobberyView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BG/Content/Tips/BeRobNum
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Content/Tips/BeRobNum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.beRobNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIVoyageRobberyView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BG/Content/ShipHolder/NameSp
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Content/ShipHolder/NameSp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameSp = tmp
end

---@private
function UIVoyageRobberyView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BG/Content/ShipHolder/NameSp/NameTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Content/ShipHolder/NameSp/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIVoyageRobberyView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BG/Content/Profit/Currency1
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Content/Profit/Currency1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency1 = tmp
end

---@private
function UIVoyageRobberyView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BG/Content/Profit/Currency1/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Content/Profit/Currency1/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency1.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIVoyageRobberyView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BG/Content/Profit/Currency1/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Content/Profit/Currency1/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency1.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIVoyageRobberyView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BG/Content/Profit/Currency2
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Content/Profit/Currency2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency2 = tmp
end

---@private
function UIVoyageRobberyView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BG/Content/Profit/Currency2/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Content/Profit/Currency2/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency2.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIVoyageRobberyView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BG/Content/Profit/Currency2/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Content/Profit/Currency2/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency2.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIVoyageRobberyView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BG/Content/Profit/Currency3
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Content/Profit/Currency3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency3 = tmp
end

---@private
function UIVoyageRobberyView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BG/Content/Profit/Currency3/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Content/Profit/Currency3/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency3.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIVoyageRobberyView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/BG/Content/Profit/Currency3/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Content/Profit/Currency3/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency3.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIVoyageRobberyView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/BG/Content/Timer
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Content/Timer").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timer = tmp
end

---@private
function UIVoyageRobberyView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/BG/Content/Timer/TimerTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Content/Timer/TimerTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timerTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIVoyageRobberyView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/BG/Box
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Box").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.box = tmp
end

---@private
function UIVoyageRobberyView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/BG/Box/BtnCancle
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Box/BtnCancle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCancle = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVoyageRobberyView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/BG/Box/BtnCancle/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Box/BtnCancle/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCancleText = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIVoyageRobberyView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/BG/Box/BtnChallenge
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Box/BtnChallenge").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChallenge = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVoyageRobberyView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/BG/Title/RobNum
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Title/RobNum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.robNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIVoyageRobberyView:GenerateDestroy()
	if tolua.getpeer(self.currency3.text) ~= nil then
		tolua.setpeer(self.currency3.text, nil)
	end
	if tolua.getpeer(self.currency3.icon) ~= nil then
		tolua.setpeer(self.currency3.icon, nil)
	end
	if tolua.getpeer(self.currency2.text) ~= nil then
		tolua.setpeer(self.currency2.text, nil)
	end
	if tolua.getpeer(self.currency2.icon) ~= nil then
		tolua.setpeer(self.currency2.icon, nil)
	end
	if tolua.getpeer(self.currency1.text) ~= nil then
		tolua.setpeer(self.currency1.text, nil)
	end
	if tolua.getpeer(self.currency1.icon) ~= nil then
		tolua.setpeer(self.currency1.icon, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.beRobNum) ~= nil then
		tolua.setpeer(self.beRobNum, nil)
	end
	self.beRobNum = nil
	if tolua.getpeer(self.nameSp) ~= nil then
		tolua.setpeer(self.nameSp, nil)
	end
	self.nameSp = nil
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	if tolua.getpeer(self.currency1) ~= nil then
		tolua.setpeer(self.currency1, nil)
	end
	self.currency1 = nil
	if tolua.getpeer(self.currency2) ~= nil then
		tolua.setpeer(self.currency2, nil)
	end
	self.currency2 = nil
	if tolua.getpeer(self.currency3) ~= nil then
		tolua.setpeer(self.currency3, nil)
	end
	self.currency3 = nil
	if tolua.getpeer(self.timer) ~= nil then
		tolua.setpeer(self.timer, nil)
	end
	self.timer = nil
	if tolua.getpeer(self.timerTxt) ~= nil then
		tolua.setpeer(self.timerTxt, nil)
	end
	self.timerTxt = nil
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
	if tolua.getpeer(self.btnChallenge) ~= nil then
		tolua.setpeer(self.btnChallenge, nil)
	end
	self.btnChallenge = nil
	if tolua.getpeer(self.robNum) ~= nil then
		tolua.setpeer(self.robNum, nil)
	end
	self.robNum = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIVoyageRobberyView