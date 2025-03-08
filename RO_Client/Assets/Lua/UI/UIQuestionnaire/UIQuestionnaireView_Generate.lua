---@class UIQuestionnaire__Generate_btnGotoQuestion
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIQuestionnaire__Generate_BtnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIQuestionnaire__Generate_item3_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIQuestionnaire__Generate_item3
---@field public gameObject UnityEngine.GameObject
---@field public iconItem UIQuestionnaire__Generate_item3_iconItem

---@class UIQuestionnaire__Generate_item2_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIQuestionnaire__Generate_item2
---@field public gameObject UnityEngine.GameObject
---@field public iconItem UIQuestionnaire__Generate_item2_iconItem

---@class UIQuestionnaire__Generate_item1_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIQuestionnaire__Generate_item1
---@field public gameObject UnityEngine.GameObject
---@field public iconItem UIQuestionnaire__Generate_item1_iconItem

---@class UIQuestionnaire__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIQuestionnaire__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIQuestionnaire__Generate_AnyBtn
---@field private item1 UIQuestionnaire__Generate_item1
---@field private item2 UIQuestionnaire__Generate_item2
---@field private item3 UIQuestionnaire__Generate_item3
---@field private BtnClose UIQuestionnaire__Generate_BtnClose
---@field private btnGotoQuestion UIQuestionnaire__Generate_btnGotoQuestion
local UIQuestionnaireView = class("UIQuestionnaireView", require("UIViewBase"))

function UIQuestionnaireView:ctor()
end

---@private
function UIQuestionnaireView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIQuestionnaireView:InitGenerate(Root, data)
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
function UIQuestionnaireView:InitGenerate__1(Root, data)
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
function UIQuestionnaireView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/BG/Rewards/Item1
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Rewards/Item1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item1 = tmp
end

---@private
function UIQuestionnaireView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BG/Rewards/Item1/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Rewards/Item1/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item1.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.item1.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIQuestionnaireView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BG/Rewards/Item2
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Rewards/Item2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item2 = tmp
end

---@private
function UIQuestionnaireView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BG/Rewards/Item2/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Rewards/Item2/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item2.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.item2.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIQuestionnaireView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BG/Rewards/Item3
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Rewards/Item3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item3 = tmp
end

---@private
function UIQuestionnaireView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BG/Rewards/Item3/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Rewards/Item3/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item3.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.item3.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIQuestionnaireView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BG/BtnCloseFlat
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BtnCloseFlat").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.BtnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIQuestionnaireView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BG/BtnGotoQuestion
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BtnGotoQuestion").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnGotoQuestion = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIQuestionnaireView:GenerateDestroy()
	if self.item3.iconItem.GenerateDestroy ~= nil then
		self.item3.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.item3.iconItem) ~= nil then
		tolua.setpeer(self.item3.iconItem, nil)
	end
	if self.item2.iconItem.GenerateDestroy ~= nil then
		self.item2.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.item2.iconItem) ~= nil then
		tolua.setpeer(self.item2.iconItem, nil)
	end
	if self.item1.iconItem.GenerateDestroy ~= nil then
		self.item1.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.item1.iconItem) ~= nil then
		tolua.setpeer(self.item1.iconItem, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.item1) ~= nil then
		tolua.setpeer(self.item1, nil)
	end
	self.item1 = nil
	if tolua.getpeer(self.item2) ~= nil then
		tolua.setpeer(self.item2, nil)
	end
	self.item2 = nil
	if tolua.getpeer(self.item3) ~= nil then
		tolua.setpeer(self.item3, nil)
	end
	self.item3 = nil
	if tolua.getpeer(self.BtnClose) ~= nil then
		tolua.setpeer(self.BtnClose, nil)
	end
	self.BtnClose = nil
	if tolua.getpeer(self.btnGotoQuestion) ~= nil then
		tolua.setpeer(self.btnGotoQuestion, nil)
	end
	self.btnGotoQuestion = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIQuestionnaireView