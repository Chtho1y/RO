---@class UIOptionalGift__Generate_btn_OK
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIOptionalGift__Generate_decomposeDsc
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIOptionalGift__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIOptionalGift__Generate_textTitle
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIOptionalGift__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIOptionalGift__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIOptionalGift__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIOptionalGift__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIEventHandler UIEventHandler
---@field private uIAnimator UIOptionalGift__Generate_uIAnimator
---@field private AnyBtn UIOptionalGift__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private btnClose UIOptionalGift__Generate_btnClose
---@field private textTitle UIOptionalGift__Generate_textTitle
---@field private scrollView UIOptionalGift__Generate_scrollView
---@field private giftListItem UnityEngine.GameObject
---@field private decomposeDsc UIOptionalGift__Generate_decomposeDsc
---@field private btn_OK UIOptionalGift__Generate_btn_OK
local UIOptionalGiftView = class("UIOptionalGiftView", require("UIViewBase"))

function UIOptionalGiftView:ctor()
end

---@private
function UIOptionalGiftView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIOptionalGiftView:InitGenerate(Root, data)
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


end

---@private
function UIOptionalGiftView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.uIEventHandler = Root:GetComponent(Enum.TypeInfo.UIEventHandler)
end

---@private
function UIOptionalGiftView:InitGenerate__2(Root, data)
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
function UIOptionalGiftView:InitGenerate__3(Root, data)
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
function UIOptionalGiftView:InitGenerate__4(Root, data)
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
function UIOptionalGiftView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIOptionalGiftView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/TextTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/TextTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textTitle = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIOptionalGiftView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox/ScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIOptionalGiftView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/DscBox/ScrollView/Viewport/Content/GiftListItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/DscBox/ScrollView/Viewport/Content/GiftListItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.giftListItem = CommonUtil.BindGridViewItem2LuaStatic("GiftListItem", tmp)
	self.giftListItem.prefabName = "GiftListItem"
end

---@private
function UIOptionalGiftView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/Boli/TalkBox/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Boli/TalkBox/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.decomposeDsc = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIOptionalGiftView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/BtnBox/Btn_OK
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/BtnBox/Btn_OK").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btn_OK = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIOptionalGiftView:GenerateDestroy()
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
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.textTitle) ~= nil then
		tolua.setpeer(self.textTitle, nil)
	end
	self.textTitle = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if self.giftListItem.GenerateDestroy ~= nil then
		self.giftListItem:GenerateDestroy()
	end
	if tolua.getpeer(self.giftListItem) ~= nil then
		tolua.setpeer(self.giftListItem, nil)
	end
	self.giftListItem = nil
	if tolua.getpeer(self.decomposeDsc) ~= nil then
		tolua.setpeer(self.decomposeDsc, nil)
	end
	self.decomposeDsc = nil
	if tolua.getpeer(self.btn_OK) ~= nil then
		tolua.setpeer(self.btn_OK, nil)
	end
	self.btn_OK = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIOptionalGiftView