---@class UIGuildChangeBadge__Generate_usedBtn_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIGuildChangeBadge__Generate_usedBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIGuildChangeBadge__Generate_usedBtn_text

---@class UIGuildChangeBadge__Generate_changeList
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIGuildChangeBadge__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildChangeBadge__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildChangeBadge__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIGuildChangeBadge__Generate_AnyBtn
---@field private btnClose UIGuildChangeBadge__Generate_btnClose
---@field private changeList UIGuildChangeBadge__Generate_changeList
---@field private usedBtn UIGuildChangeBadge__Generate_usedBtn
local UIGuildChangeBadgeView = class("UIGuildChangeBadgeView", require("UIViewBase"))

function UIGuildChangeBadgeView:ctor()
end

---@private
function UIGuildChangeBadgeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildChangeBadgeView:InitGenerate(Root, data)
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


end

---@private
function UIGuildChangeBadgeView:InitGenerate__1(Root, data)
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
function UIGuildChangeBadgeView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildChangeBadgeView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/ChangeList
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.changeList = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIGuildChangeBadgeView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bottom/UsedBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/UsedBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.usedBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildChangeBadgeView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bottom/UsedBtn/Content/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/UsedBtn/Content/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.usedBtn.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIGuildChangeBadgeView:GenerateDestroy()
	if tolua.getpeer(self.usedBtn.text) ~= nil then
		tolua.setpeer(self.usedBtn.text, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.changeList) ~= nil then
		tolua.setpeer(self.changeList, nil)
	end
	self.changeList = nil
	if tolua.getpeer(self.usedBtn) ~= nil then
		tolua.setpeer(self.usedBtn, nil)
	end
	self.usedBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildChangeBadgeView