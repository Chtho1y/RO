---@class UIChipProduceNotice__Generate_btnCancle
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChipProduceNotice__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIChipProduceNotice__Generate_btnProduce
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChipProduceNotice__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIChipProduceNotice__Generate_dscBox_notice
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIChipProduceNotice__Generate_dscBox
---@field public gameObject UnityEngine.GameObject
---@field public notice UIChipProduceNotice__Generate_dscBox_notice

---@class UIChipProduceNotice__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChipProduceNotice__Generate_window
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIChipProduceNotice__Generate_alpha
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChipProduceNotice__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private alpha UIChipProduceNotice__Generate_alpha
---@field private window UIChipProduceNotice__Generate_window
---@field private btnClose UIChipProduceNotice__Generate_btnClose
---@field private dscBox UIChipProduceNotice__Generate_dscBox
---@field private dscTxt UnityEngine.GameObject
---@field private desTxt UIChipProduceNotice__Generate_desTxt
---@field private btnBox UnityEngine.GameObject
---@field private btnProduce UIChipProduceNotice__Generate_btnProduce
---@field private text UIChipProduceNotice__Generate_text
---@field private btnCancle UIChipProduceNotice__Generate_btnCancle
local UIChipProduceNoticeView = class("UIChipProduceNoticeView", require("UIViewBase"))

function UIChipProduceNoticeView:ctor()
end

---@private
function UIChipProduceNoticeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIChipProduceNoticeView:InitGenerate(Root, data)
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


end

---@private
function UIChipProduceNoticeView:InitGenerate__1(Root, data)
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
function UIChipProduceNoticeView:InitGenerate__2(Root, data)
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
function UIChipProduceNoticeView:InitGenerate__3(Root, data)
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
function UIChipProduceNoticeView:InitGenerate__4(Root, data)
--[[
	Window/Bg/DscBox
--]]
	local tmp = Root:Find("Window/Bg/DscBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox = tmp
end

---@private
function UIChipProduceNoticeView:InitGenerate__5(Root, data)
--[[
	Window/Bg/DscBox/DesTxt
--]]
	local tmp = Root:Find("Window/Bg/DscBox/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox.notice = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIChipProduceNoticeView:InitGenerate__6(Root, data)
--[[
	Window/Bg/DscTxt
--]]
	local tmp = Root:Find("Window/Bg/DscTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscTxt = tmp
end

---@private
function UIChipProduceNoticeView:InitGenerate__7(Root, data)
--[[
	Window/Bg/DscTxt/DesTxt
--]]
	local tmp = Root:Find("Window/Bg/DscTxt/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desTxt = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIChipProduceNoticeView:InitGenerate__8(Root, data)
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
function UIChipProduceNoticeView:InitGenerate__9(Root, data)
--[[
	Window/Bg/BtnBox/BtnProduce
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/BtnProduce").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnProduce = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChipProduceNoticeView:InitGenerate__10(Root, data)
--[[
	Window/Bg/BtnBox/BtnProduce/Text
--]]
	local tmp = Root:Find("Window/Bg/BtnBox/BtnProduce/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIChipProduceNoticeView:InitGenerate__11(Root, data)
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
function UIChipProduceNoticeView:GenerateDestroy()
	if tolua.getpeer(self.dscBox.notice) ~= nil then
		tolua.setpeer(self.dscBox.notice, nil)
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
	if tolua.getpeer(self.dscBox) ~= nil then
		tolua.setpeer(self.dscBox, nil)
	end
	self.dscBox = nil
	if tolua.getpeer(self.dscTxt) ~= nil then
		tolua.setpeer(self.dscTxt, nil)
	end
	self.dscTxt = nil
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.btnProduce) ~= nil then
		tolua.setpeer(self.btnProduce, nil)
	end
	self.btnProduce = nil
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
return UIChipProduceNoticeView