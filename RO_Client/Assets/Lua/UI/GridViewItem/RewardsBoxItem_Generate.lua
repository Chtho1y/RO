---@class RewardsBoxItem__Generate_btnBuyMore_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RewardsBoxItem__Generate_btnBuyMore
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public num RewardsBoxItem__Generate_btnBuyMore_num

---@class RewardsBoxItem__Generate_btnPlayRule
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class RewardsBoxItem__Generate_btnGotoDown_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RewardsBoxItem__Generate_btnGotoDown
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public iconSmallItem RewardsBoxItem__Generate_btnGotoDown_iconSmallItem

---@class RewardsBoxItem__Generate_btnGotoUp_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RewardsBoxItem__Generate_btnGotoUp
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public iconSmallItem RewardsBoxItem__Generate_btnGotoUp_iconSmallItem

---@class RewardsBoxItem__Generate_timeBox_textTime
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RewardsBoxItem__Generate_timeBox
---@field public gameObject UnityEngine.GameObject
---@field public textTime RewardsBoxItem__Generate_timeBox_textTime

---@class RewardsBoxItem__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView
---@field public content UnityEngine.GameObject

---@class RewardsBoxItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private scrollView RewardsBoxItem__Generate_scrollView
---@field private timeBox RewardsBoxItem__Generate_timeBox
---@field private btnGotoUp RewardsBoxItem__Generate_btnGotoUp
---@field private btnGotoDown RewardsBoxItem__Generate_btnGotoDown
---@field private btnPlayRule RewardsBoxItem__Generate_btnPlayRule
---@field private btnBuyMore RewardsBoxItem__Generate_btnBuyMore
---@field private expUpRed UnityEngine.GameObject
---@field private labelUnLocked UnityEngine.GameObject
local RewardsBoxItemView = class("RewardsBoxItemView")

function RewardsBoxItemView:ctor()
end

---@private
function RewardsBoxItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RewardsBoxItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

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


end

---@private
function RewardsBoxItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function RewardsBoxItemView:InitGenerate__2(Root, data)
--[[
	ScrollView
--]]
	local tmp = Root:Find("ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function RewardsBoxItemView:InitGenerate__3(Root, data)
--[[
	ScrollView/Viewport/Content
--]]
	local tmp = Root:Find("ScrollView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView.content = tmp
end

---@private
function RewardsBoxItemView:InitGenerate__4(Root, data)
--[[
	TimeBox
--]]
	local tmp = Root:Find("TimeBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timeBox = tmp
end

---@private
function RewardsBoxItemView:InitGenerate__5(Root, data)
--[[
	TimeBox/TextTime
--]]
	local tmp = Root:Find("TimeBox/TextTime").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timeBox.textTime = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RewardsBoxItemView:InitGenerate__6(Root, data)
--[[
	BtnGotoUp
--]]
	local tmp = Root:Find("BtnGotoUp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnGotoUp = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function RewardsBoxItemView:InitGenerate__7(Root, data)
--[[
	BtnGotoUp/BgAnim/IconSmallItem
--]]
	local tmp = Root:Find("BtnGotoUp/BgAnim/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnGotoUp.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.btnGotoUp.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RewardsBoxItemView:InitGenerate__8(Root, data)
--[[
	BtnGotoDown
--]]
	local tmp = Root:Find("BtnGotoDown").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnGotoDown = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function RewardsBoxItemView:InitGenerate__9(Root, data)
--[[
	BtnGotoDown/BgAnim/IconSmallItem
--]]
	local tmp = Root:Find("BtnGotoDown/BgAnim/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnGotoDown.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.btnGotoDown.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RewardsBoxItemView:InitGenerate__10(Root, data)
--[[
	CloudBottm/CloudAnim/BtnPlayRule
--]]
	local tmp = Root:Find("CloudBottm/CloudAnim/BtnPlayRule").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPlayRule = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function RewardsBoxItemView:InitGenerate__11(Root, data)
--[[
	CloudBottm/CloudAnim/BtnBuyMore
--]]
	local tmp = Root:Find("CloudBottm/CloudAnim/BtnBuyMore").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBuyMore = tmp
	self.btnBuyMore:SetActive(false)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function RewardsBoxItemView:InitGenerate__12(Root, data)
--[[
	CloudBottm/CloudAnim/BtnBuyMore/ExpUpRed
--]]
	local tmp = Root:Find("CloudBottm/CloudAnim/BtnBuyMore/ExpUpRed").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.expUpRed = tmp
end

---@private
function RewardsBoxItemView:InitGenerate__13(Root, data)
--[[
	CloudBottm/CloudAnim/BtnBuyMore/ExpUpRed/RedPoint/LvUp/num
--]]
	local tmp = Root:Find("CloudBottm/CloudAnim/BtnBuyMore/ExpUpRed/RedPoint/LvUp/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBuyMore.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RewardsBoxItemView:InitGenerate__14(Root, data)
--[[
	CloudBottm/CloudAnim/LabelUnLocked
--]]
	local tmp = Root:Find("CloudBottm/CloudAnim/LabelUnLocked").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelUnLocked = tmp
	self.labelUnLocked:SetActive(false)
end

---@private
function RewardsBoxItemView:GenerateDestroy()
	if tolua.getpeer(self.btnBuyMore.num) ~= nil then
		tolua.setpeer(self.btnBuyMore.num, nil)
	end
	if self.btnGotoDown.iconSmallItem.GenerateDestroy ~= nil then
		self.btnGotoDown.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.btnGotoDown.iconSmallItem) ~= nil then
		tolua.setpeer(self.btnGotoDown.iconSmallItem, nil)
	end
	if self.btnGotoUp.iconSmallItem.GenerateDestroy ~= nil then
		self.btnGotoUp.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.btnGotoUp.iconSmallItem) ~= nil then
		tolua.setpeer(self.btnGotoUp.iconSmallItem, nil)
	end
	if tolua.getpeer(self.timeBox.textTime) ~= nil then
		tolua.setpeer(self.timeBox.textTime, nil)
	end
	if tolua.getpeer(self.timeBox) ~= nil then
		tolua.setpeer(self.timeBox, nil)
	end
	if tolua.getpeer(self.scrollView.content) ~= nil then
		tolua.setpeer(self.scrollView.content, nil)
	end
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	if tolua.getpeer(self.btnGotoUp) ~= nil then
		tolua.setpeer(self.btnGotoUp, nil)
	end
	self.btnGotoUp = nil
	if tolua.getpeer(self.btnGotoDown) ~= nil then
		tolua.setpeer(self.btnGotoDown, nil)
	end
	self.btnGotoDown = nil
	if tolua.getpeer(self.btnPlayRule) ~= nil then
		tolua.setpeer(self.btnPlayRule, nil)
	end
	self.btnPlayRule = nil
	if tolua.getpeer(self.btnBuyMore) ~= nil then
		tolua.setpeer(self.btnBuyMore, nil)
	end
	self.btnBuyMore = nil
	if tolua.getpeer(self.expUpRed) ~= nil then
		tolua.setpeer(self.expUpRed, nil)
	end
	self.expUpRed = nil
	if tolua.getpeer(self.labelUnLocked) ~= nil then
		tolua.setpeer(self.labelUnLocked, nil)
	end
	self.labelUnLocked = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RewardsBoxItemView