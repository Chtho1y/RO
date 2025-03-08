---@class UISummonShow__Generate_skip
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummonShow__Generate_btnWeixin
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummonShow__Generate_btnWeibo
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummonShow__Generate_particle
---@field public gameObject UnityEngine.GameObject
---@field public uIParticle UIExtensions.UIParticle

---@class UISummonShow__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UISummonShow__Generate_modelImg
---@field public gameObject UnityEngine.GameObject
---@field public rawImage UnityEngine.UI.RawImage

---@class UISummonShow__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISummonShow__Generate_itemShow
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISummonShow__Generate_btnNext
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummonShow__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISummonShow__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UISummonShow__Generate_uIAnimator
---@field private bGBlueBottom UnityEngine.GameObject
---@field private bGPinkBottom UnityEngine.GameObject
---@field private bGYellowBottom UnityEngine.GameObject
---@field private btnNext UISummonShow__Generate_btnNext
---@field private itemShow UISummonShow__Generate_itemShow
---@field private bGBlue UnityEngine.GameObject
---@field private bGPink UnityEngine.GameObject
---@field private bGYellow UnityEngine.GameObject
---@field private nameTxt UISummonShow__Generate_nameTxt
---@field private label UnityEngine.GameObject
---@field private mVP UnityEngine.GameObject
---@field private mini UnityEngine.GameObject
---@field private normal UnityEngine.GameObject
---@field private labelNew UnityEngine.GameObject
---@field private rT UnityEngine.GameObject
---@field private modelImg UISummonShow__Generate_modelImg
---@field private item UnityEngine.GameObject
---@field private iconItem UISummonShow__Generate_iconItem
---@field private particle UISummonShow__Generate_particle
---@field private starBox UnityEngine.GameObject
---@field private star1 UnityEngine.GameObject
---@field private star2 UnityEngine.GameObject
---@field private star3 UnityEngine.GameObject
---@field private star4 UnityEngine.GameObject
---@field private star5 UnityEngine.GameObject
---@field private btnWeibo UISummonShow__Generate_btnWeibo
---@field private btnWeixin UISummonShow__Generate_btnWeixin
---@field private skip UISummonShow__Generate_skip
local UISummonShowView = class("UISummonShowView", require("UIViewBase"))

function UISummonShowView:ctor()
end

---@private
function UISummonShowView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISummonShowView:InitGenerate(Root, data)
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
	self:InitGenerate__25(Root,data)
	self:InitGenerate__26(Root,data)
	self:InitGenerate__27(Root,data)
	self:InitGenerate__28(Root,data)
	self:InitGenerate__29(Root,data)


end

---@private
function UISummonShowView:InitGenerate__1(Root, data)
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
function UISummonShowView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/BG/BGBlueBottom
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BGBlueBottom").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bGBlueBottom = tmp
end

---@private
function UISummonShowView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BG/BGPinkBottom
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BGPinkBottom").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bGPinkBottom = tmp
end

---@private
function UISummonShowView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BG/BGYellowBottom
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BGYellowBottom").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bGYellowBottom = tmp
end

---@private
function UISummonShowView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BtnNext
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnNext").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnNext = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonShowView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/ItemShow
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemShow = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UISummonShowView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/ItemShow/BG/BGBlue
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/BG/BGBlue").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bGBlue = tmp
end

---@private
function UISummonShowView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/ItemShow/BG/BGPink
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/BG/BGPink").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bGPink = tmp
end

---@private
function UISummonShowView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/ItemShow/BG/BGYellow
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/BG/BGYellow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bGYellow = tmp
end

---@private
function UISummonShowView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/ItemShow/NameBox/NameAnim/NameTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/NameBox/NameAnim/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISummonShowView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/ItemShow/NameBox/NameAnim/Label
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/NameBox/NameAnim/Label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.label = tmp
end

---@private
function UISummonShowView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/ItemShow/NameBox/NameAnim/Label/MVP
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/NameBox/NameAnim/Label/MVP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mVP = tmp
end

---@private
function UISummonShowView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/ItemShow/NameBox/NameAnim/Label/Mini
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/NameBox/NameAnim/Label/Mini").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mini = tmp
end

---@private
function UISummonShowView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/ItemShow/NameBox/NameAnim/Label/Normal
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/NameBox/NameAnim/Label/Normal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.normal = tmp
end

---@private
function UISummonShowView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/ItemShow/NameBox/NameAnim/LabelNew
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/NameBox/NameAnim/LabelNew").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelNew = tmp
end

---@private
function UISummonShowView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/ItemShow/ResultAnim/RT
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/ResultAnim/RT").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rT = tmp
end

---@private
function UISummonShowView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/ItemShow/ResultAnim/RT/ModelImg
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/ResultAnim/RT/ModelImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.modelImg = tmp

	tmp.rawImage = tmp:GetComponent(Enum.TypeInfo.RawImage)
end

---@private
function UISummonShowView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/ItemShow/ResultAnim/Item
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/ResultAnim/Item").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item = tmp
end

---@private
function UISummonShowView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/ItemShow/ResultAnim/Item/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/ResultAnim/Item/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UISummonShowView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/ItemShow/ResultAnim/particle
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/ResultAnim/particle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.particle = tmp

	tmp.uIParticle = tmp:GetComponent(Enum.TypeInfo.UIParticle)
end

---@private
function UISummonShowView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/ItemShow/StarBox
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/StarBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.starBox = tmp
end

---@private
function UISummonShowView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/ItemShow/StarBox/Stars/Star1
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/StarBox/Stars/Star1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.star1 = tmp
end

---@private
function UISummonShowView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/ItemShow/StarBox/Stars/Star2
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/StarBox/Stars/Star2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.star2 = tmp
end

---@private
function UISummonShowView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/ItemShow/StarBox/Stars/Star3
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/StarBox/Stars/Star3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.star3 = tmp
end

---@private
function UISummonShowView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/ItemShow/StarBox/Stars/Star4
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/StarBox/Stars/Star4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.star4 = tmp
end

---@private
function UISummonShowView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/ItemShow/StarBox/Stars/Star5
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/StarBox/Stars/Star5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.star5 = tmp
end

---@private
function UISummonShowView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/ItemShow/BtnBox/BtnWeibo
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/BtnBox/BtnWeibo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnWeibo = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonShowView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/ItemShow/BtnBox/BtnWeixin
--]]
	local tmp = Root:Find("UIAnimator/Window/ItemShow/BtnBox/BtnWeixin").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnWeixin = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonShowView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/Skip
--]]
	local tmp = Root:Find("UIAnimator/Window/Skip").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skip = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonShowView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.bGBlueBottom) ~= nil then
		tolua.setpeer(self.bGBlueBottom, nil)
	end
	self.bGBlueBottom = nil
	if tolua.getpeer(self.bGPinkBottom) ~= nil then
		tolua.setpeer(self.bGPinkBottom, nil)
	end
	self.bGPinkBottom = nil
	if tolua.getpeer(self.bGYellowBottom) ~= nil then
		tolua.setpeer(self.bGYellowBottom, nil)
	end
	self.bGYellowBottom = nil
	if tolua.getpeer(self.btnNext) ~= nil then
		tolua.setpeer(self.btnNext, nil)
	end
	self.btnNext = nil
	if tolua.getpeer(self.itemShow) ~= nil then
		tolua.setpeer(self.itemShow, nil)
	end
	self.itemShow = nil
	if tolua.getpeer(self.bGBlue) ~= nil then
		tolua.setpeer(self.bGBlue, nil)
	end
	self.bGBlue = nil
	if tolua.getpeer(self.bGPink) ~= nil then
		tolua.setpeer(self.bGPink, nil)
	end
	self.bGPink = nil
	if tolua.getpeer(self.bGYellow) ~= nil then
		tolua.setpeer(self.bGYellow, nil)
	end
	self.bGYellow = nil
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	if tolua.getpeer(self.label) ~= nil then
		tolua.setpeer(self.label, nil)
	end
	self.label = nil
	if tolua.getpeer(self.mVP) ~= nil then
		tolua.setpeer(self.mVP, nil)
	end
	self.mVP = nil
	if tolua.getpeer(self.mini) ~= nil then
		tolua.setpeer(self.mini, nil)
	end
	self.mini = nil
	if tolua.getpeer(self.normal) ~= nil then
		tolua.setpeer(self.normal, nil)
	end
	self.normal = nil
	if tolua.getpeer(self.labelNew) ~= nil then
		tolua.setpeer(self.labelNew, nil)
	end
	self.labelNew = nil
	if tolua.getpeer(self.rT) ~= nil then
		tolua.setpeer(self.rT, nil)
	end
	self.rT = nil
	if tolua.getpeer(self.modelImg) ~= nil then
		tolua.setpeer(self.modelImg, nil)
	end
	self.modelImg = nil
	if tolua.getpeer(self.item) ~= nil then
		tolua.setpeer(self.item, nil)
	end
	self.item = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if tolua.getpeer(self.particle) ~= nil then
		tolua.setpeer(self.particle, nil)
	end
	self.particle = nil
	if tolua.getpeer(self.starBox) ~= nil then
		tolua.setpeer(self.starBox, nil)
	end
	self.starBox = nil
	if tolua.getpeer(self.star1) ~= nil then
		tolua.setpeer(self.star1, nil)
	end
	self.star1 = nil
	if tolua.getpeer(self.star2) ~= nil then
		tolua.setpeer(self.star2, nil)
	end
	self.star2 = nil
	if tolua.getpeer(self.star3) ~= nil then
		tolua.setpeer(self.star3, nil)
	end
	self.star3 = nil
	if tolua.getpeer(self.star4) ~= nil then
		tolua.setpeer(self.star4, nil)
	end
	self.star4 = nil
	if tolua.getpeer(self.star5) ~= nil then
		tolua.setpeer(self.star5, nil)
	end
	self.star5 = nil
	if tolua.getpeer(self.btnWeibo) ~= nil then
		tolua.setpeer(self.btnWeibo, nil)
	end
	self.btnWeibo = nil
	if tolua.getpeer(self.btnWeixin) ~= nil then
		tolua.setpeer(self.btnWeixin, nil)
	end
	self.btnWeixin = nil
	if tolua.getpeer(self.skip) ~= nil then
		tolua.setpeer(self.skip, nil)
	end
	self.skip = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISummonShowView