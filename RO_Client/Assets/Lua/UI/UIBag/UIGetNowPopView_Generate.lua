---@class UIGetNowPop__Generate_btnGetNow
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGetNowPop__Generate_numcost
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGetNowPop__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIGetNowPop__Generate_LeftTimesLbl
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGetNowPop__Generate_dscTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGetNowPop__Generate_CloseBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGetNowPop__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGetNowPop__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIGetNowPop__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIGetNowPop__Generate_uIAnimator
---@field private AnyBtn UIGetNowPop__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private CloseBtn UIGetNowPop__Generate_CloseBtn
---@field private dscTxt UIGetNowPop__Generate_dscTxt
---@field private LeftTimesLbl UIGetNowPop__Generate_LeftTimesLbl
---@field private icon UIGetNowPop__Generate_icon
---@field private numcost UIGetNowPop__Generate_numcost
---@field private btnGetNow UIGetNowPop__Generate_btnGetNow
local UIGetNowPopView = class("UIGetNowPopView", require("UIViewBase"))

function UIGetNowPopView:ctor()
end

---@private
function UIGetNowPopView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGetNowPopView:InitGenerate(Root, data)
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


end

---@private
function UIGetNowPopView:InitGenerate__1(Root, data)
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
function UIGetNowPopView:InitGenerate__2(Root, data)
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
function UIGetNowPopView:InitGenerate__3(Root, data)
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
function UIGetNowPopView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BG/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.CloseBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGetNowPopView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BG/TalkBox/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TalkBox/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGetNowPopView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BG/TalkBox/Times/LeftTimesLbl
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TalkBox/Times/LeftTimesLbl").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.LeftTimesLbl = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGetNowPopView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BG/BottomBox/CostBox/icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BottomBox/CostBox/icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIGetNowPopView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BG/BottomBox/CostBox/numcost
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BottomBox/CostBox/numcost").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.numcost = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGetNowPopView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BG/BottomBox/BtnGetNow
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BottomBox/BtnGetNow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnGetNow = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGetNowPopView:GenerateDestroy()
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
	if tolua.getpeer(self.CloseBtn) ~= nil then
		tolua.setpeer(self.CloseBtn, nil)
	end
	self.CloseBtn = nil
	if tolua.getpeer(self.dscTxt) ~= nil then
		tolua.setpeer(self.dscTxt, nil)
	end
	self.dscTxt = nil
	if tolua.getpeer(self.LeftTimesLbl) ~= nil then
		tolua.setpeer(self.LeftTimesLbl, nil)
	end
	self.LeftTimesLbl = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.numcost) ~= nil then
		tolua.setpeer(self.numcost, nil)
	end
	self.numcost = nil
	if tolua.getpeer(self.btnGetNow) ~= nil then
		tolua.setpeer(self.btnGetNow, nil)
	end
	self.btnGetNow = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGetNowPopView