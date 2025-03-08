---@class UIMail__Generate_content
---@field public gameObject UnityEngine.GameObject
---@field public horizontalLayoutGroup UnityEngine.UI.HorizontalLayoutGroup

---@class UIMail__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopHorizontalScrollRect UnityEngine.UI.LoopHorizontalScrollRect

---@class UIMail__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIMail__Generate_timer
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIMail__Generate_mailTtle
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIMail__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMail__Generate_btnDraw_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIMail__Generate_btnDraw
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIMail__Generate_btnDraw_text

---@class UIMail__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMail__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIMail__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIMail__Generate_uIAnimator
---@field private AnyBtn UIMail__Generate_AnyBtn
---@field private btnDraw UIMail__Generate_btnDraw
---@field private btnClose UIMail__Generate_btnClose
---@field private litter UnityEngine.GameObject
---@field private item UnityEngine.GameObject
---@field private litterOpen UnityEngine.GameObject
---@field private itemOpen UnityEngine.GameObject
---@field private mailTtle UIMail__Generate_mailTtle
---@field private timer UIMail__Generate_timer
---@field private text UIMail__Generate_text
---@field private award UnityEngine.GameObject
---@field private scrollView UIMail__Generate_scrollView
---@field private content UIMail__Generate_content
local UIMailView = class("UIMailView", require("UIViewBase"))

function UIMailView:ctor()
end

---@private
function UIMailView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIMailView:InitGenerate(Root, data)
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


end

---@private
function UIMailView:InitGenerate__1(Root, data)
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
function UIMailView:InitGenerate__2(Root, data)
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
function UIMailView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BtnDraw
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnDraw").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnDraw = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMailView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BtnDraw/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnDraw/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnDraw.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIMailView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMailView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/LitterContent/Mail/Icon/Litter
--]]
	local tmp = Root:Find("UIAnimator/Window/LitterContent/Mail/Icon/Litter").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.litter = tmp
end

---@private
function UIMailView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/LitterContent/Mail/Icon/Item
--]]
	local tmp = Root:Find("UIAnimator/Window/LitterContent/Mail/Icon/Item").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item = tmp
end

---@private
function UIMailView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/LitterContent/Mail/Icon/LitterOpen
--]]
	local tmp = Root:Find("UIAnimator/Window/LitterContent/Mail/Icon/LitterOpen").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.litterOpen = tmp
end

---@private
function UIMailView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/LitterContent/Mail/Icon/ItemOpen
--]]
	local tmp = Root:Find("UIAnimator/Window/LitterContent/Mail/Icon/ItemOpen").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemOpen = tmp
end

---@private
function UIMailView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/LitterContent/Mail/MailTtle
--]]
	local tmp = Root:Find("UIAnimator/Window/LitterContent/Mail/MailTtle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mailTtle = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIMailView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/LitterContent/Mail/Timer
--]]
	local tmp = Root:Find("UIAnimator/Window/LitterContent/Mail/Timer").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timer = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIMailView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/LitterContent/Scroll View/Viewport/Content/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/LitterContent/Scroll View/Viewport/Content/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIMailView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/LitterContent/award
--]]
	local tmp = Root:Find("UIAnimator/Window/LitterContent/award").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.award = tmp
end

---@private
function UIMailView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/LitterContent/award/Scroll View
--]]
	local tmp = Root:Find("UIAnimator/Window/LitterContent/award/Scroll View").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopHorizontalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopHorizontalScrollRect)
end

---@private
function UIMailView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/LitterContent/award/Scroll View/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/LitterContent/award/Scroll View/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp

	tmp.horizontalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.HorizontalLayoutGroup)
end

---@private
function UIMailView:GenerateDestroy()
	if tolua.getpeer(self.btnDraw.text) ~= nil then
		tolua.setpeer(self.btnDraw.text, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnDraw) ~= nil then
		tolua.setpeer(self.btnDraw, nil)
	end
	self.btnDraw = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.litter) ~= nil then
		tolua.setpeer(self.litter, nil)
	end
	self.litter = nil
	if tolua.getpeer(self.item) ~= nil then
		tolua.setpeer(self.item, nil)
	end
	self.item = nil
	if tolua.getpeer(self.litterOpen) ~= nil then
		tolua.setpeer(self.litterOpen, nil)
	end
	self.litterOpen = nil
	if tolua.getpeer(self.itemOpen) ~= nil then
		tolua.setpeer(self.itemOpen, nil)
	end
	self.itemOpen = nil
	if tolua.getpeer(self.mailTtle) ~= nil then
		tolua.setpeer(self.mailTtle, nil)
	end
	self.mailTtle = nil
	if tolua.getpeer(self.timer) ~= nil then
		tolua.setpeer(self.timer, nil)
	end
	self.timer = nil
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.award) ~= nil then
		tolua.setpeer(self.award, nil)
	end
	self.award = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIMailView