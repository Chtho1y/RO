---@class UIPvpSuppressTips__Generate_dsc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPvpSuppressTips__Generate_cardBlessLv
---@field public gameObject UnityEngine.GameObject
---@field public lv0 UnityEngine.GameObject
---@field public lv1 UnityEngine.GameObject
---@field public lv2 UnityEngine.GameObject
---@field public lv3 UnityEngine.GameObject
---@field public lv4 UnityEngine.GameObject
---@field public lv5 UnityEngine.GameObject
---@field public lv6 UnityEngine.GameObject
---@field public lv7 UnityEngine.GameObject
---@field public lv8 UnityEngine.GameObject
---@field public lv9 UnityEngine.GameObject
---@field public lv10 UnityEngine.GameObject
---@field public lv11 UnityEngine.GameObject

---@class UIPvpSuppressTips__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPvpSuppressTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPvpSuppressTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIPvpSuppressTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIPvpSuppressTips__Generate_uIAnimator
---@field private AnyBtn UIPvpSuppressTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private text UIPvpSuppressTips__Generate_text
---@field private cardBlessLv UIPvpSuppressTips__Generate_cardBlessLv
---@field private dsc UIPvpSuppressTips__Generate_dsc
local UIPvpSuppressTipsView = class("UIPvpSuppressTipsView", require("UIViewBase"))

function UIPvpSuppressTipsView:ctor()
end

---@private
function UIPvpSuppressTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPvpSuppressTipsView:InitGenerate(Root, data)
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


end

---@private
function UIPvpSuppressTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIPvpSuppressTipsView:InitGenerate__2(Root, data)
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
function UIPvpSuppressTipsView:InitGenerate__3(Root, data)
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
function UIPvpSuppressTipsView:InitGenerate__4(Root, data)
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
function UIPvpSuppressTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIPvpSuppressTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv = tmp
end

---@private
function UIPvpSuppressTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv0
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv0").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv0 = tmp
	self.cardBlessLv.lv0:SetActive(false)
end

---@private
function UIPvpSuppressTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv1 = tmp
	self.cardBlessLv.lv1:SetActive(false)
end

---@private
function UIPvpSuppressTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv2 = tmp
	self.cardBlessLv.lv2:SetActive(false)
end

---@private
function UIPvpSuppressTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv3 = tmp
	self.cardBlessLv.lv3:SetActive(false)
end

---@private
function UIPvpSuppressTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv4
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv4 = tmp
	self.cardBlessLv.lv4:SetActive(false)
end

---@private
function UIPvpSuppressTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv5
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv5 = tmp
	self.cardBlessLv.lv5:SetActive(false)
end

---@private
function UIPvpSuppressTipsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv6
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv6").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv6 = tmp
	self.cardBlessLv.lv6:SetActive(false)
end

---@private
function UIPvpSuppressTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv7
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv7").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv7 = tmp
	self.cardBlessLv.lv7:SetActive(false)
end

---@private
function UIPvpSuppressTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv8
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv8").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv8 = tmp
	self.cardBlessLv.lv8:SetActive(false)
end

---@private
function UIPvpSuppressTipsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv9
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv9").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv9 = tmp
	self.cardBlessLv.lv9:SetActive(false)
end

---@private
function UIPvpSuppressTipsView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv10
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv10").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv10 = tmp
	self.cardBlessLv.lv10:SetActive(false)
end

---@private
function UIPvpSuppressTipsView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv11
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TopItem/CardBlessLv/Lv11").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardBlessLv.lv11 = tmp
	self.cardBlessLv.lv11:SetActive(false)
end

---@private
function UIPvpSuppressTipsView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/Dsc
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Dsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dsc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIPvpSuppressTipsView:GenerateDestroy()
	if tolua.getpeer(self.cardBlessLv.lv11) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv11, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv10) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv10, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv9) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv9, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv8) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv8, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv7) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv7, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv6) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv6, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv5) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv5, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv4) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv4, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv3) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv3, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv2) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv2, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv1) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv1, nil)
	end
	if tolua.getpeer(self.cardBlessLv.lv0) ~= nil then
		tolua.setpeer(self.cardBlessLv.lv0, nil)
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
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.cardBlessLv) ~= nil then
		tolua.setpeer(self.cardBlessLv, nil)
	end
	self.cardBlessLv = nil
	if tolua.getpeer(self.dsc) ~= nil then
		tolua.setpeer(self.dsc, nil)
	end
	self.dsc = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPvpSuppressTipsView