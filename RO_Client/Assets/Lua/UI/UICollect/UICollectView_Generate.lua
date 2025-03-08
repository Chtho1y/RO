---@class UICollect__Generate_numexchage
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UICollect__Generate_btnPlayRule
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICollect__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICollect__Generate_lockCollection_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UICollect__Generate_lockCollection
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UICollect__Generate_lockCollection_text

---@class UICollect__Generate_btnCollectionBook
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICollect__Generate_lockPet_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UICollect__Generate_lockPet
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UICollect__Generate_lockPet_text

---@class UICollect__Generate_btnPetBook
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICollect__Generate_lockCard_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UICollect__Generate_lockCard
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UICollect__Generate_lockCard_text

---@class UICollect__Generate_btnCardBook
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICollect__Generate_bookAnim
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UICollect__Generate_bookItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UICollect__Generate_window
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UICollect__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UICollect__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UICollect__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UICollect__Generate_uIAnimator
---@field private AnyBtn UICollect__Generate_AnyBtn
---@field private window UICollect__Generate_window
---@field private bookItem UICollect__Generate_bookItem
---@field private bookAnim UICollect__Generate_bookAnim
---@field private enterAnim UnityEngine.GameObject
---@field private btnCardBook UICollect__Generate_btnCardBook
---@field private lockCard UICollect__Generate_lockCard
---@field private btnPetBook UICollect__Generate_btnPetBook
---@field private lockPet UICollect__Generate_lockPet
---@field private btnCollectionBook UICollect__Generate_btnCollectionBook
---@field private lockCollection UICollect__Generate_lockCollection
---@field private btnClose UICollect__Generate_btnClose
---@field private btnPlayRule UICollect__Generate_btnPlayRule
---@field private myExchangeCards UnityEngine.GameObject
---@field private numexchage UICollect__Generate_numexchage
---@field private talkBox UnityEngine.GameObject
local UICollectView = class("UICollectView", require("UIViewBase"))

function UICollectView:ctor()
end

---@private
function UICollectView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UICollectView:InitGenerate(Root, data)
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


end

---@private
function UICollectView:InitGenerate__1(Root, data)
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
function UICollectView:InitGenerate__2(Root, data)
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
function UICollectView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window
--]]
	local tmp = Root:Find("UIAnimator/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UICollectView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BookItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BookItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bookItem = CommonUtil.BindGridViewItem2LuaStatic("BookItem", tmp)
	self.bookItem.prefabName = "BookItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UICollectView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BookAnim
--]]
	local tmp = Root:Find("UIAnimator/Window/BookAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bookAnim = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UICollectView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/EnterAnim
--]]
	local tmp = Root:Find("UIAnimator/Window/EnterAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.enterAnim = tmp
end

---@private
function UICollectView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/EnterAnim/Viewport/Content/BtnCardBook
--]]
	local tmp = Root:Find("UIAnimator/Window/EnterAnim/Viewport/Content/BtnCardBook").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCardBook = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICollectView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/EnterAnim/Viewport/Content/BtnCardBook/LockCard
--]]
	local tmp = Root:Find("UIAnimator/Window/EnterAnim/Viewport/Content/BtnCardBook/LockCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lockCard = tmp
	self.lockCard:SetActive(false)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICollectView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/EnterAnim/Viewport/Content/BtnCardBook/LockCard/Label/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/EnterAnim/Viewport/Content/BtnCardBook/LockCard/Label/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lockCard.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UICollectView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/EnterAnim/Viewport/Content/BtnPetBook
--]]
	local tmp = Root:Find("UIAnimator/Window/EnterAnim/Viewport/Content/BtnPetBook").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPetBook = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICollectView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/EnterAnim/Viewport/Content/BtnPetBook/LockPet
--]]
	local tmp = Root:Find("UIAnimator/Window/EnterAnim/Viewport/Content/BtnPetBook/LockPet").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lockPet = tmp
	self.lockPet:SetActive(false)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICollectView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/EnterAnim/Viewport/Content/BtnPetBook/LockPet/Label/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/EnterAnim/Viewport/Content/BtnPetBook/LockPet/Label/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lockPet.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UICollectView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/EnterAnim/Viewport/Content/BtnCollectionBook
--]]
	local tmp = Root:Find("UIAnimator/Window/EnterAnim/Viewport/Content/BtnCollectionBook").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCollectionBook = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICollectView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/EnterAnim/Viewport/Content/BtnCollectionBook/LockCollection
--]]
	local tmp = Root:Find("UIAnimator/Window/EnterAnim/Viewport/Content/BtnCollectionBook/LockCollection").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lockCollection = tmp
	self.lockCollection:SetActive(false)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICollectView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/EnterAnim/Viewport/Content/BtnCollectionBook/LockCollection/Label/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/EnterAnim/Viewport/Content/BtnCollectionBook/LockCollection/Label/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lockCollection.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UICollectView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/BottomAnim/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomAnim/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICollectView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/TopView/BtnPlayRule
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/BtnPlayRule").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPlayRule = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UICollectView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/TopView/MyExchangeCards
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/MyExchangeCards").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.myExchangeCards = tmp
	self.myExchangeCards:SetActive(false)
end

---@private
function UICollectView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/TopView/MyExchangeCards/numexchage
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/MyExchangeCards/numexchage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.numexchage = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UICollectView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/TopView/TalkBox
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/TalkBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.talkBox = tmp
end

---@private
function UICollectView:GenerateDestroy()
	if tolua.getpeer(self.lockCollection.text) ~= nil then
		tolua.setpeer(self.lockCollection.text, nil)
	end
	if tolua.getpeer(self.lockPet.text) ~= nil then
		tolua.setpeer(self.lockPet.text, nil)
	end
	if tolua.getpeer(self.lockCard.text) ~= nil then
		tolua.setpeer(self.lockCard.text, nil)
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
	if self.bookItem.GenerateDestroy ~= nil then
		self.bookItem:GenerateDestroy()
	end
	if tolua.getpeer(self.bookItem) ~= nil then
		tolua.setpeer(self.bookItem, nil)
	end
	self.bookItem = nil
	if tolua.getpeer(self.bookAnim) ~= nil then
		tolua.setpeer(self.bookAnim, nil)
	end
	self.bookAnim = nil
	if tolua.getpeer(self.enterAnim) ~= nil then
		tolua.setpeer(self.enterAnim, nil)
	end
	self.enterAnim = nil
	if tolua.getpeer(self.btnCardBook) ~= nil then
		tolua.setpeer(self.btnCardBook, nil)
	end
	self.btnCardBook = nil
	if tolua.getpeer(self.lockCard) ~= nil then
		tolua.setpeer(self.lockCard, nil)
	end
	self.lockCard = nil
	if tolua.getpeer(self.btnPetBook) ~= nil then
		tolua.setpeer(self.btnPetBook, nil)
	end
	self.btnPetBook = nil
	if tolua.getpeer(self.lockPet) ~= nil then
		tolua.setpeer(self.lockPet, nil)
	end
	self.lockPet = nil
	if tolua.getpeer(self.btnCollectionBook) ~= nil then
		tolua.setpeer(self.btnCollectionBook, nil)
	end
	self.btnCollectionBook = nil
	if tolua.getpeer(self.lockCollection) ~= nil then
		tolua.setpeer(self.lockCollection, nil)
	end
	self.lockCollection = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.btnPlayRule) ~= nil then
		tolua.setpeer(self.btnPlayRule, nil)
	end
	self.btnPlayRule = nil
	if tolua.getpeer(self.myExchangeCards) ~= nil then
		tolua.setpeer(self.myExchangeCards, nil)
	end
	self.myExchangeCards = nil
	if tolua.getpeer(self.numexchage) ~= nil then
		tolua.setpeer(self.numexchage, nil)
	end
	self.numexchage = nil
	if tolua.getpeer(self.talkBox) ~= nil then
		tolua.setpeer(self.talkBox, nil)
	end
	self.talkBox = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UICollectView