---@class UIFashionCompose__Generate_composeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionCompose__Generate_consume4_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionCompose__Generate_Item4
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIFashionCompose__Generate_consume4
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public text UIFashionCompose__Generate_consume4_text

---@class UIFashionCompose__Generate_consume3_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionCompose__Generate_Item3
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIFashionCompose__Generate_consume3
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public text UIFashionCompose__Generate_consume3_text

---@class UIFashionCompose__Generate_consume2_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionCompose__Generate_Item2
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIFashionCompose__Generate_consume2
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public text UIFashionCompose__Generate_consume2_text

---@class UIFashionCompose__Generate_consume1_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionCompose__Generate_Item1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIFashionCompose__Generate_consume1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public text UIFashionCompose__Generate_consume1_text

---@class UIFashionCompose__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionCompose__Generate_rawImage
---@field public gameObject UnityEngine.GameObject
---@field public rawImage UnityEngine.UI.RawImage

---@class UIFashionCompose__Generate_coinZ_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFashionCompose__Generate_coinZ
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public coinIcon UnityEngine.GameObject
---@field public diamondIcon UnityEngine.GameObject
---@field public text UIFashionCompose__Generate_coinZ_text

---@class UIFashionCompose__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionCompose__Generate_window
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIFashionCompose__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFashionCompose__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIFashionCompose__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIFashionCompose__Generate_uIAnimator
---@field private AnyBtn UIFashionCompose__Generate_AnyBtn
---@field private window UIFashionCompose__Generate_window
---@field private closeBox UnityEngine.GameObject
---@field private btnClose UIFashionCompose__Generate_btnClose
---@field private coinZ UIFashionCompose__Generate_coinZ
---@field private rawImage UIFashionCompose__Generate_rawImage
---@field private nameTxt UIFashionCompose__Generate_nameTxt
---@field private consume1 UIFashionCompose__Generate_consume1
---@field private Item1 UIFashionCompose__Generate_Item1
---@field private consume2 UIFashionCompose__Generate_consume2
---@field private Item2 UIFashionCompose__Generate_Item2
---@field private consume3 UIFashionCompose__Generate_consume3
---@field private Item3 UIFashionCompose__Generate_Item3
---@field private consume4 UIFashionCompose__Generate_consume4
---@field private Item4 UIFashionCompose__Generate_Item4
---@field private composeBtn UIFashionCompose__Generate_composeBtn
local UIFashionComposeView = class("UIFashionComposeView", require("UIViewBase"))

function UIFashionComposeView:ctor()
end

---@private
function UIFashionComposeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIFashionComposeView:InitGenerate(Root, data)
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
function UIFashionComposeView:InitGenerate__1(Root, data)
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
function UIFashionComposeView:InitGenerate__2(Root, data)
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
function UIFashionComposeView:InitGenerate__3(Root, data)
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
function UIFashionComposeView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/CloseBox
--]]
	local tmp = Root:Find("UIAnimator/Window/CloseBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBox = tmp
end

---@private
function UIFashionComposeView:InitGenerate__5(Root, data)
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
function UIFashionComposeView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/CoinZ
--]]
	local tmp = Root:Find("UIAnimator/Window/CoinZ").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coinZ = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIFashionComposeView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/CoinZ/CoinIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/CoinZ/CoinIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coinZ.coinIcon = tmp
end

---@private
function UIFashionComposeView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/CoinZ/DiamondIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/CoinZ/DiamondIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coinZ.diamondIcon = tmp
end

---@private
function UIFashionComposeView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/CoinZ/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/CoinZ/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coinZ.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionComposeView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/DscBox/RawImage
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/RawImage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rawImage = tmp

	tmp.rawImage = tmp:GetComponent(Enum.TypeInfo.RawImage)
end

---@private
function UIFashionComposeView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/DscBox/Name/NameTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Name/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionComposeView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/DscBox/Consume1
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Consume1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.consume1 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIFashionComposeView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/DscBox/Consume1/Item/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Consume1/Item/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.Item1 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.Item1.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIFashionComposeView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/DscBox/Consume1/Number/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Consume1/Number/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.consume1.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionComposeView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/DscBox/Consume2
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Consume2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.consume2 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIFashionComposeView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/DscBox/Consume2/Item/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Consume2/Item/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.Item2 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.Item2.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIFashionComposeView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/DscBox/Consume2/Number/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Consume2/Number/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.consume2.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionComposeView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/DscBox/Consume3
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Consume3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.consume3 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIFashionComposeView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/DscBox/Consume3/Item/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Consume3/Item/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.Item3 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.Item3.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIFashionComposeView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/DscBox/Consume3/Number/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Consume3/Number/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.consume3.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionComposeView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/DscBox/Consume4
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Consume4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.consume4 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIFashionComposeView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/DscBox/Consume4/Item/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Consume4/Item/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.Item4 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.Item4.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIFashionComposeView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/DscBox/Consume4/Number/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Consume4/Number/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.consume4.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFashionComposeView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/ComposeBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/ComposeBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.composeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFashionComposeView:GenerateDestroy()
	if tolua.getpeer(self.consume4.text) ~= nil then
		tolua.setpeer(self.consume4.text, nil)
	end
	if tolua.getpeer(self.consume3.text) ~= nil then
		tolua.setpeer(self.consume3.text, nil)
	end
	if tolua.getpeer(self.consume2.text) ~= nil then
		tolua.setpeer(self.consume2.text, nil)
	end
	if tolua.getpeer(self.consume1.text) ~= nil then
		tolua.setpeer(self.consume1.text, nil)
	end
	if tolua.getpeer(self.coinZ.text) ~= nil then
		tolua.setpeer(self.coinZ.text, nil)
	end
	if tolua.getpeer(self.coinZ.diamondIcon) ~= nil then
		tolua.setpeer(self.coinZ.diamondIcon, nil)
	end
	if tolua.getpeer(self.coinZ.coinIcon) ~= nil then
		tolua.setpeer(self.coinZ.coinIcon, nil)
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
	if tolua.getpeer(self.closeBox) ~= nil then
		tolua.setpeer(self.closeBox, nil)
	end
	self.closeBox = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.coinZ) ~= nil then
		tolua.setpeer(self.coinZ, nil)
	end
	self.coinZ = nil
	if tolua.getpeer(self.rawImage) ~= nil then
		tolua.setpeer(self.rawImage, nil)
	end
	self.rawImage = nil
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	if tolua.getpeer(self.consume1) ~= nil then
		tolua.setpeer(self.consume1, nil)
	end
	self.consume1 = nil
	if self.Item1.GenerateDestroy ~= nil then
		self.Item1:GenerateDestroy()
	end
	if tolua.getpeer(self.Item1) ~= nil then
		tolua.setpeer(self.Item1, nil)
	end
	self.Item1 = nil
	if tolua.getpeer(self.consume2) ~= nil then
		tolua.setpeer(self.consume2, nil)
	end
	self.consume2 = nil
	if self.Item2.GenerateDestroy ~= nil then
		self.Item2:GenerateDestroy()
	end
	if tolua.getpeer(self.Item2) ~= nil then
		tolua.setpeer(self.Item2, nil)
	end
	self.Item2 = nil
	if tolua.getpeer(self.consume3) ~= nil then
		tolua.setpeer(self.consume3, nil)
	end
	self.consume3 = nil
	if self.Item3.GenerateDestroy ~= nil then
		self.Item3:GenerateDestroy()
	end
	if tolua.getpeer(self.Item3) ~= nil then
		tolua.setpeer(self.Item3, nil)
	end
	self.Item3 = nil
	if tolua.getpeer(self.consume4) ~= nil then
		tolua.setpeer(self.consume4, nil)
	end
	self.consume4 = nil
	if self.Item4.GenerateDestroy ~= nil then
		self.Item4:GenerateDestroy()
	end
	if tolua.getpeer(self.Item4) ~= nil then
		tolua.setpeer(self.Item4, nil)
	end
	self.Item4 = nil
	if tolua.getpeer(self.composeBtn) ~= nil then
		tolua.setpeer(self.composeBtn, nil)
	end
	self.composeBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIFashionComposeView