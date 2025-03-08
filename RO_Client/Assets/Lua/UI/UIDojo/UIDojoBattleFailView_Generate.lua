---@class UIDojoBattleFail__Generate_deltaScoreText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoBattleFail__Generate_newScoreText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoBattleFail__Generate_oldScoreText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoBattleFail__Generate_CruiseVipTag_number
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIDojoBattleFail__Generate_CruiseVipTag_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIDojoBattleFail__Generate_CruiseVipTag
---@field public gameObject UnityEngine.GameObject
---@field public icon UIDojoBattleFail__Generate_CruiseVipTag_icon
---@field public number UIDojoBattleFail__Generate_CruiseVipTag_number

---@class UIDojoBattleFail__Generate_CruiseLbl
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoBattleFail__Generate_ZenyLbl
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIDojoBattleFail__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIDojoBattleFail__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private popWinAnim UnityEngine.GameObject
---@field private AnyBtn UIDojoBattleFail__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private ZenyLbl UIDojoBattleFail__Generate_ZenyLbl
---@field private CruiseLbl UIDojoBattleFail__Generate_CruiseLbl
---@field private CruiseVipTag UIDojoBattleFail__Generate_CruiseVipTag
---@field private oldScoreText UIDojoBattleFail__Generate_oldScoreText
---@field private newScoreText UIDojoBattleFail__Generate_newScoreText
---@field private deltaScoreText UIDojoBattleFail__Generate_deltaScoreText
local UIDojoBattleFailView = class("UIDojoBattleFailView", require("UIViewBase"))

function UIDojoBattleFailView:ctor()
end

---@private
function UIDojoBattleFailView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIDojoBattleFailView:InitGenerate(Root, data)
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
function UIDojoBattleFailView:InitGenerate__1(Root, data)
--[[
	PopWinAnim
--]]
	local tmp = Root:Find("PopWinAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.popWinAnim = tmp
end

---@private
function UIDojoBattleFailView:InitGenerate__2(Root, data)
--[[
	PopWinAnim/Alpha
--]]
	local tmp = Root:Find("PopWinAnim/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIDojoBattleFailView:InitGenerate__3(Root, data)
--[[
	PopWinAnim/Window
--]]
	local tmp = Root:Find("PopWinAnim/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp
end

---@private
function UIDojoBattleFailView:InitGenerate__4(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Zeny/Text
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Zeny/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.ZenyLbl = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoBattleFailView:InitGenerate__5(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Cruise/Text
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Cruise/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.CruiseLbl = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoBattleFailView:InitGenerate__6(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Cruise/VipTag
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Cruise/VipTag").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.CruiseVipTag = tmp
end

---@private
function UIDojoBattleFailView:InitGenerate__7(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Cruise/VipTag/Icon
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Cruise/VipTag/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.CruiseVipTag.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIDojoBattleFailView:InitGenerate__8(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Cruise/VipTag/Number
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Cruise/VipTag/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.CruiseVipTag.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIDojoBattleFailView:InitGenerate__9(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Score/Val
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Score/Val").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.oldScoreText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoBattleFailView:InitGenerate__10(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Score/NewVal
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Score/NewVal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.newScoreText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoBattleFailView:InitGenerate__11(Root, data)
--[[
	PopWinAnim/Window/BG/ReceiveRes/Score/AddVal
--]]
	local tmp = Root:Find("PopWinAnim/Window/BG/ReceiveRes/Score/AddVal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.deltaScoreText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIDojoBattleFailView:GenerateDestroy()
	if tolua.getpeer(self.CruiseVipTag.number) ~= nil then
		tolua.setpeer(self.CruiseVipTag.number, nil)
	end
	if tolua.getpeer(self.CruiseVipTag.icon) ~= nil then
		tolua.setpeer(self.CruiseVipTag.icon, nil)
	end
	if tolua.getpeer(self.popWinAnim) ~= nil then
		tolua.setpeer(self.popWinAnim, nil)
	end
	self.popWinAnim = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if tolua.getpeer(self.ZenyLbl) ~= nil then
		tolua.setpeer(self.ZenyLbl, nil)
	end
	self.ZenyLbl = nil
	if tolua.getpeer(self.CruiseLbl) ~= nil then
		tolua.setpeer(self.CruiseLbl, nil)
	end
	self.CruiseLbl = nil
	if tolua.getpeer(self.CruiseVipTag) ~= nil then
		tolua.setpeer(self.CruiseVipTag, nil)
	end
	self.CruiseVipTag = nil
	if tolua.getpeer(self.oldScoreText) ~= nil then
		tolua.setpeer(self.oldScoreText, nil)
	end
	self.oldScoreText = nil
	if tolua.getpeer(self.newScoreText) ~= nil then
		tolua.setpeer(self.newScoreText, nil)
	end
	self.newScoreText = nil
	if tolua.getpeer(self.deltaScoreText) ~= nil then
		tolua.setpeer(self.deltaScoreText, nil)
	end
	self.deltaScoreText = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIDojoBattleFailView