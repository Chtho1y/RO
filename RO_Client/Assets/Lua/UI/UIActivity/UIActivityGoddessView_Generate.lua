---@class UIActivityGoddess__Generate_giveTips_item_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIActivityGoddess__Generate_giveTips_item_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityGoddess__Generate_giveTips_item
---@field public gameObject UnityEngine.GameObject
---@field public num UIActivityGoddess__Generate_giveTips_item_num
---@field public iconSmallItem UIActivityGoddess__Generate_giveTips_item_iconSmallItem

---@class UIActivityGoddess__Generate_giveTips
---@field public gameObject UnityEngine.GameObject
---@field public arrow UnityEngine.GameObject
---@field public item UIActivityGoddess__Generate_giveTips_item

---@class UIActivityGoddess__Generate_giveTipsClickRect
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityGoddess__Generate_btnInfo
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityGoddess__Generate_timeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityGoddess__Generate_favoring_lv
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIActivityGoddess__Generate_favoring_item_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIActivityGoddess__Generate_favoring_item_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityGoddess__Generate_favoring_item
---@field public gameObject UnityEngine.GameObject
---@field public num UIActivityGoddess__Generate_favoring_item_num
---@field public iconSmallItem UIActivityGoddess__Generate_favoring_item_iconSmallItem

---@class UIActivityGoddess__Generate_favoring_slider_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityGoddess__Generate_favoring_slider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider
---@field public num UIActivityGoddess__Generate_favoring_slider_num

---@class UIActivityGoddess__Generate_favoring
---@field public gameObject UnityEngine.GameObject
---@field public slider UIActivityGoddess__Generate_favoring_slider
---@field public item UIActivityGoddess__Generate_favoring_item
---@field public lv UIActivityGoddess__Generate_favoring_lv

---@class UIActivityGoddess__Generate_banner
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIActivityGoddess__Generate_owenGift_item_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityGoddess__Generate_owenGift_item_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIActivityGoddess__Generate_owenGift_item
---@field public gameObject UnityEngine.GameObject
---@field public iconItem UIActivityGoddess__Generate_owenGift_item_iconItem
---@field public num UIActivityGoddess__Generate_owenGift_item_num

---@class UIActivityGoddess__Generate_owenGift
---@field public gameObject UnityEngine.GameObject
---@field public item UIActivityGoddess__Generate_owenGift_item

---@class UIActivityGoddess__Generate_backBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityGoddess__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityGoddess__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIActivityGoddess__Generate_AnyBtn
---@field private backBtn UIActivityGoddess__Generate_backBtn
---@field private owenGift UIActivityGoddess__Generate_owenGift
---@field private banner UIActivityGoddess__Generate_banner
---@field private favoring UIActivityGoddess__Generate_favoring
---@field private box UnityEngine.GameObject
---@field private timeTxt UIActivityGoddess__Generate_timeTxt
---@field private btnInfo UIActivityGoddess__Generate_btnInfo
---@field private giveTipsClickRect UIActivityGoddess__Generate_giveTipsClickRect
---@field private giveTipsOffsetRect UnityEngine.GameObject
---@field private giveTips UIActivityGoddess__Generate_giveTips
local UIActivityGoddessView = class("UIActivityGoddessView", require("UIViewBase"))

function UIActivityGoddessView:ctor()
end

---@private
function UIActivityGoddessView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIActivityGoddessView:InitGenerate(Root, data)
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
	self:InitGenerate__23(Root,data)
	self:InitGenerate__24(Root,data)


end

---@private
function UIActivityGoddessView:InitGenerate__1(Root, data)
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
function UIActivityGoddessView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.backBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityGoddessView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Bottom/OwenGift
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/OwenGift").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.owenGift = tmp
end

---@private
function UIActivityGoddessView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bottom/OwenGift/Item
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/OwenGift/Item").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.owenGift.item = tmp
	self.owenGift.item:SetActive(false)
end

---@private
function UIActivityGoddessView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bottom/OwenGift/Item/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/OwenGift/Item/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.owenGift.item.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.owenGift.item.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIActivityGoddessView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bottom/OwenGift/Item/Num/num
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/OwenGift/Item/Num/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.owenGift.item.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityGoddessView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Banner
--]]
	local tmp = Root:Find("UIAnimator/Window/Banner").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.banner = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIActivityGoddessView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Favoring
--]]
	local tmp = Root:Find("UIAnimator/Window/Favoring").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.favoring = tmp
end

---@private
function UIActivityGoddessView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Favoring/Slider
--]]
	local tmp = Root:Find("UIAnimator/Window/Favoring/Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.favoring.slider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function UIActivityGoddessView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Favoring/Slider/Handle/box/text/num
--]]
	local tmp = Root:Find("UIAnimator/Window/Favoring/Slider/Handle/box/text/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.favoring.slider.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityGoddessView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Favoring/Slider/Handle/Item
--]]
	local tmp = Root:Find("UIAnimator/Window/Favoring/Slider/Handle/Item").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.favoring.item = tmp
	self.favoring.item:SetActive(false)
end

---@private
function UIActivityGoddessView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Favoring/Slider/Handle/Item/text/num
--]]
	local tmp = Root:Find("UIAnimator/Window/Favoring/Slider/Handle/Item/text/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.favoring.item.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityGoddessView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Favoring/Slider/Handle/Item/IconSmallItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Favoring/Slider/Handle/Item/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.favoring.item.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.favoring.item.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIActivityGoddessView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Favoring/hart/lv
--]]
	local tmp = Root:Find("UIAnimator/Window/Favoring/hart/lv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.favoring.lv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIActivityGoddessView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/TimeBox/Box
--]]
	local tmp = Root:Find("UIAnimator/Window/TimeBox/Box").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.box = tmp
end

---@private
function UIActivityGoddessView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/TimeBox/Box/TimeTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/TimeBox/Box/TimeTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityGoddessView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/TimeBox/BtnInfo
--]]
	local tmp = Root:Find("UIAnimator/Window/TimeBox/BtnInfo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnInfo = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityGoddessView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/GiveTipsClickRect
--]]
	local tmp = Root:Find("UIAnimator/Window/GiveTipsClickRect").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.giveTipsClickRect = tmp
	self.giveTipsClickRect:SetActive(false)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityGoddessView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/GiveTipsOffsetRect
--]]
	local tmp = Root:Find("UIAnimator/Window/GiveTipsOffsetRect").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.giveTipsOffsetRect = tmp
	self.giveTipsOffsetRect:SetActive(false)
end

---@private
function UIActivityGoddessView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/GiveTips
--]]
	local tmp = Root:Find("UIAnimator/Window/GiveTips").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.giveTips = tmp
	self.giveTips:SetActive(false)
end

---@private
function UIActivityGoddessView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/GiveTips/bg/Arrow
--]]
	local tmp = Root:Find("UIAnimator/Window/GiveTips/bg/Arrow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.giveTips.arrow = tmp
end

---@private
function UIActivityGoddessView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/GiveTips/Item
--]]
	local tmp = Root:Find("UIAnimator/Window/GiveTips/Item").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.giveTips.item = tmp
	self.giveTips.item:SetActive(false)
end

---@private
function UIActivityGoddessView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/GiveTips/Item/text/num
--]]
	local tmp = Root:Find("UIAnimator/Window/GiveTips/Item/text/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.giveTips.item.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityGoddessView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/GiveTips/Item/IconSmallItem
--]]
	local tmp = Root:Find("UIAnimator/Window/GiveTips/Item/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.giveTips.item.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.giveTips.item.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIActivityGoddessView:GenerateDestroy()
	if self.giveTips.item.iconSmallItem.GenerateDestroy ~= nil then
		self.giveTips.item.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.giveTips.item.iconSmallItem) ~= nil then
		tolua.setpeer(self.giveTips.item.iconSmallItem, nil)
	end
	if tolua.getpeer(self.giveTips.item.num) ~= nil then
		tolua.setpeer(self.giveTips.item.num, nil)
	end
	if tolua.getpeer(self.giveTips.item) ~= nil then
		tolua.setpeer(self.giveTips.item, nil)
	end
	if tolua.getpeer(self.giveTips.arrow) ~= nil then
		tolua.setpeer(self.giveTips.arrow, nil)
	end
	if tolua.getpeer(self.favoring.lv) ~= nil then
		tolua.setpeer(self.favoring.lv, nil)
	end
	if self.favoring.item.iconSmallItem.GenerateDestroy ~= nil then
		self.favoring.item.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.favoring.item.iconSmallItem) ~= nil then
		tolua.setpeer(self.favoring.item.iconSmallItem, nil)
	end
	if tolua.getpeer(self.favoring.item.num) ~= nil then
		tolua.setpeer(self.favoring.item.num, nil)
	end
	if tolua.getpeer(self.favoring.item) ~= nil then
		tolua.setpeer(self.favoring.item, nil)
	end
	if tolua.getpeer(self.favoring.slider.num) ~= nil then
		tolua.setpeer(self.favoring.slider.num, nil)
	end
	if tolua.getpeer(self.favoring.slider) ~= nil then
		tolua.setpeer(self.favoring.slider, nil)
	end
	if tolua.getpeer(self.owenGift.item.num) ~= nil then
		tolua.setpeer(self.owenGift.item.num, nil)
	end
	if self.owenGift.item.iconItem.GenerateDestroy ~= nil then
		self.owenGift.item.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.owenGift.item.iconItem) ~= nil then
		tolua.setpeer(self.owenGift.item.iconItem, nil)
	end
	if tolua.getpeer(self.owenGift.item) ~= nil then
		tolua.setpeer(self.owenGift.item, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.backBtn) ~= nil then
		tolua.setpeer(self.backBtn, nil)
	end
	self.backBtn = nil
	if tolua.getpeer(self.owenGift) ~= nil then
		tolua.setpeer(self.owenGift, nil)
	end
	self.owenGift = nil
	if tolua.getpeer(self.banner) ~= nil then
		tolua.setpeer(self.banner, nil)
	end
	self.banner = nil
	if tolua.getpeer(self.favoring) ~= nil then
		tolua.setpeer(self.favoring, nil)
	end
	self.favoring = nil
	if tolua.getpeer(self.box) ~= nil then
		tolua.setpeer(self.box, nil)
	end
	self.box = nil
	if tolua.getpeer(self.timeTxt) ~= nil then
		tolua.setpeer(self.timeTxt, nil)
	end
	self.timeTxt = nil
	if tolua.getpeer(self.btnInfo) ~= nil then
		tolua.setpeer(self.btnInfo, nil)
	end
	self.btnInfo = nil
	if tolua.getpeer(self.giveTipsClickRect) ~= nil then
		tolua.setpeer(self.giveTipsClickRect, nil)
	end
	self.giveTipsClickRect = nil
	if tolua.getpeer(self.giveTipsOffsetRect) ~= nil then
		tolua.setpeer(self.giveTipsOffsetRect, nil)
	end
	self.giveTipsOffsetRect = nil
	if tolua.getpeer(self.giveTips) ~= nil then
		tolua.setpeer(self.giveTips, nil)
	end
	self.giveTips = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIActivityGoddessView