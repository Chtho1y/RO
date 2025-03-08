---@class UIBigMap__Generate_awardTips_itemName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBigMap__Generate_awardTips_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIBigMap__Generate_awardTips_des
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBigMap__Generate_awardTips_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBigMap__Generate_awardTips
---@field public gameObject UnityEngine.GameObject
---@field public AnyBtn UIBigMap__Generate_awardTips_AnyBtn
---@field public window UnityEngine.GameObject
---@field public des UIBigMap__Generate_awardTips_des
---@field public iconItem UIBigMap__Generate_awardTips_iconItem
---@field public itemName UIBigMap__Generate_awardTips_itemName

---@class UIBigMap__Generate_btnBigMap
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBigMap__Generate_btnBack
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBigMap__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBigMap__Generate_bigMap_linePath
---@field public gameObject UnityEngine.GameObject
---@field public uIBigMapLine UIBigMapLine

---@class UIBigMap__Generate_bigMap_bottomImage
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image

---@class UIBigMap__Generate_bigMap_content
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIBigMap__Generate_bigMap
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect
---@field public content UIBigMap__Generate_bigMap_content
---@field public bottomImage UIBigMap__Generate_bigMap_bottomImage
---@field public linePath UIBigMap__Generate_bigMap_linePath
---@field public smallPoints UnityEngine.GameObject
---@field public bigPoints UnityEngine.GameObject
---@field public startPoint UnityEngine.GameObject
---@field public storyPoints UnityEngine.GameObject
---@field public oneRank UnityEngine.GameObject
---@field public selfContainer UnityEngine.GameObject

---@class UIBigMap__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBigMap__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIBigMap__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIBigMap__Generate_uIAnimator
---@field private AnyBtn UIBigMap__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private bigMap UIBigMap__Generate_bigMap
---@field private nameTxt UIBigMap__Generate_nameTxt
---@field private btnBack UIBigMap__Generate_btnBack
---@field private btnBigMap UIBigMap__Generate_btnBigMap
---@field private awardTips UIBigMap__Generate_awardTips
local UIBigMapView = class("UIBigMapView", require("UIViewBase"))

function UIBigMapView:ctor()
end

---@private
function UIBigMapView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIBigMapView:InitGenerate(Root, data)
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
	self:InitGenerate__21(Root,data)
	self:InitGenerate__22(Root,data)


end

---@private
function UIBigMapView:InitGenerate__1(Root, data)
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
function UIBigMapView:InitGenerate__2(Root, data)
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
function UIBigMapView:InitGenerate__3(Root, data)
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
function UIBigMapView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BigMap
--]]
	local tmp = Root:Find("UIAnimator/Window/BigMap").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)
end

---@private
function UIBigMapView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BigMap/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/BigMap/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.content = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIBigMapView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BigMap/Viewport/Content/BottomImage
--]]
	local tmp = Root:Find("UIAnimator/Window/BigMap/Viewport/Content/BottomImage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.bottomImage = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIBigMapView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BigMap/Viewport/Content/LinePath
--]]
	local tmp = Root:Find("UIAnimator/Window/BigMap/Viewport/Content/LinePath").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.linePath = tmp

	tmp.uIBigMapLine = tmp:GetComponent(Enum.TypeInfo.UIBigMapLine)
end

---@private
function UIBigMapView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BigMap/Viewport/Content/SmallPoints
--]]
	local tmp = Root:Find("UIAnimator/Window/BigMap/Viewport/Content/SmallPoints").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.smallPoints = tmp
end

---@private
function UIBigMapView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BigMap/Viewport/Content/BigPoints
--]]
	local tmp = Root:Find("UIAnimator/Window/BigMap/Viewport/Content/BigPoints").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.bigPoints = tmp
end

---@private
function UIBigMapView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BigMap/Viewport/Content/StartPoint
--]]
	local tmp = Root:Find("UIAnimator/Window/BigMap/Viewport/Content/StartPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.startPoint = tmp
end

---@private
function UIBigMapView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BigMap/Viewport/Content/StoryPoints
--]]
	local tmp = Root:Find("UIAnimator/Window/BigMap/Viewport/Content/StoryPoints").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.storyPoints = tmp
end

---@private
function UIBigMapView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BigMap/Viewport/Content/OneRank
--]]
	local tmp = Root:Find("UIAnimator/Window/BigMap/Viewport/Content/OneRank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.oneRank = tmp
end

---@private
function UIBigMapView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BigMap/Viewport/Content/SelfContainer
--]]
	local tmp = Root:Find("UIAnimator/Window/BigMap/Viewport/Content/SelfContainer").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.selfContainer = tmp
end

---@private
function UIBigMapView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/TopView/Title/Title/NameTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/TopView/Title/Title/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBigMapView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/BottomView/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBack = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIBigMapView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/BottomView/BtnBigMap
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/BtnBigMap").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBigMap = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIBigMapView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/AwardTips
--]]
	local tmp = Root:Find("UIAnimator/Window/AwardTips").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.awardTips = tmp
end

---@private
function UIBigMapView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/AwardTips/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Window/AwardTips/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.awardTips.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIBigMapView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/AwardTips/Window
--]]
	local tmp = Root:Find("UIAnimator/Window/AwardTips/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.awardTips.window = tmp
end

---@private
function UIBigMapView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/AwardTips/Window/Des
--]]
	local tmp = Root:Find("UIAnimator/Window/AwardTips/Window/Des").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.awardTips.des = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBigMapView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/AwardTips/Window/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/AwardTips/Window/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.awardTips.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.awardTips.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIBigMapView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/AwardTips/Window/ItemName
--]]
	local tmp = Root:Find("UIAnimator/Window/AwardTips/Window/ItemName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.awardTips.itemName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBigMapView:GenerateDestroy()
	if tolua.getpeer(self.awardTips.itemName) ~= nil then
		tolua.setpeer(self.awardTips.itemName, nil)
	end
	if self.awardTips.iconItem.GenerateDestroy ~= nil then
		self.awardTips.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.awardTips.iconItem) ~= nil then
		tolua.setpeer(self.awardTips.iconItem, nil)
	end
	if tolua.getpeer(self.awardTips.des) ~= nil then
		tolua.setpeer(self.awardTips.des, nil)
	end
	if tolua.getpeer(self.awardTips.window) ~= nil then
		tolua.setpeer(self.awardTips.window, nil)
	end
	if tolua.getpeer(self.awardTips.AnyBtn) ~= nil then
		tolua.setpeer(self.awardTips.AnyBtn, nil)
	end
	if tolua.getpeer(self.bigMap.selfContainer) ~= nil then
		tolua.setpeer(self.bigMap.selfContainer, nil)
	end
	if tolua.getpeer(self.bigMap.oneRank) ~= nil then
		tolua.setpeer(self.bigMap.oneRank, nil)
	end
	if tolua.getpeer(self.bigMap.storyPoints) ~= nil then
		tolua.setpeer(self.bigMap.storyPoints, nil)
	end
	if tolua.getpeer(self.bigMap.startPoint) ~= nil then
		tolua.setpeer(self.bigMap.startPoint, nil)
	end
	if tolua.getpeer(self.bigMap.bigPoints) ~= nil then
		tolua.setpeer(self.bigMap.bigPoints, nil)
	end
	if tolua.getpeer(self.bigMap.smallPoints) ~= nil then
		tolua.setpeer(self.bigMap.smallPoints, nil)
	end
	if tolua.getpeer(self.bigMap.linePath) ~= nil then
		tolua.setpeer(self.bigMap.linePath, nil)
	end
	if tolua.getpeer(self.bigMap.bottomImage) ~= nil then
		tolua.setpeer(self.bigMap.bottomImage, nil)
	end
	if tolua.getpeer(self.bigMap.content) ~= nil then
		tolua.setpeer(self.bigMap.content, nil)
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
	if tolua.getpeer(self.bigMap) ~= nil then
		tolua.setpeer(self.bigMap, nil)
	end
	self.bigMap = nil
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	if tolua.getpeer(self.btnBack) ~= nil then
		tolua.setpeer(self.btnBack, nil)
	end
	self.btnBack = nil
	if tolua.getpeer(self.btnBigMap) ~= nil then
		tolua.setpeer(self.btnBigMap, nil)
	end
	self.btnBigMap = nil
	if tolua.getpeer(self.awardTips) ~= nil then
		tolua.setpeer(self.awardTips, nil)
	end
	self.awardTips = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIBigMapView