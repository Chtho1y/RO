---@class UIFruitUse__Generate_seniorText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFruitUse__Generate_seniorImage
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIFruitUse__Generate_primaryText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFruitUse__Generate_primaryImage
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIFruitUse__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFruitUse__Generate_textTitle
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIFruitUse__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFruitUse__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIFruitUse__Generate_AnyBtn
---@field private textTitle UIFruitUse__Generate_textTitle
---@field private closeBox UnityEngine.GameObject
---@field private btnClose UIFruitUse__Generate_btnClose
---@field private primaryImage UIFruitUse__Generate_primaryImage
---@field private primaryText UIFruitUse__Generate_primaryText
---@field private seniorImage UIFruitUse__Generate_seniorImage
---@field private seniorText UIFruitUse__Generate_seniorText
---@field private hero1 UnityEngine.GameObject
---@field private hero2 UnityEngine.GameObject
---@field private hero3 UnityEngine.GameObject
---@field private hero4 UnityEngine.GameObject
---@field private hero5 UnityEngine.GameObject
---@field private hero6 UnityEngine.GameObject
local UIFruitUseView = class("UIFruitUseView", require("UIViewBase"))

function UIFruitUseView:ctor()
end

---@private
function UIFruitUseView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIFruitUseView:InitGenerate(Root, data)
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


end

---@private
function UIFruitUseView:InitGenerate__1(Root, data)
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
function UIFruitUseView:InitGenerate__2(Root, data)
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
function UIFruitUseView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBox = tmp
end

---@private
function UIFruitUseView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFruitUseView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/Content/Fruit/Primary/PrimaryImage
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Content/Fruit/Primary/PrimaryImage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.primaryImage = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIFruitUseView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/Content/Fruit/Primary/PrimaryText
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Content/Fruit/Primary/PrimaryText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.primaryText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFruitUseView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/Content/Fruit/Senior/SeniorImage
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Content/Fruit/Senior/SeniorImage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.seniorImage = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIFruitUseView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/Content/Fruit/Senior/SeniorText
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Content/Fruit/Senior/SeniorText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.seniorText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFruitUseView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/Content/FruitHeroItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Content/FruitHeroItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero1 = CommonUtil.BindGridViewItem2LuaStatic("FruitHeroItem", tmp)
	self.hero1.prefabName = "FruitHeroItem"
end

---@private
function UIFruitUseView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/Content/FruitHeroItem (1)
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Content/FruitHeroItem (1)").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero2 = CommonUtil.BindGridViewItem2LuaStatic("FruitHeroItem", tmp)
	self.hero2.prefabName = "FruitHeroItem"
end

---@private
function UIFruitUseView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/Content/FruitHeroItem (2)
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Content/FruitHeroItem (2)").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero3 = CommonUtil.BindGridViewItem2LuaStatic("FruitHeroItem", tmp)
	self.hero3.prefabName = "FruitHeroItem"
end

---@private
function UIFruitUseView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/Content/FruitHeroItem (3)
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Content/FruitHeroItem (3)").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero4 = CommonUtil.BindGridViewItem2LuaStatic("FruitHeroItem", tmp)
	self.hero4.prefabName = "FruitHeroItem"
end

---@private
function UIFruitUseView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/Content/FruitHeroItem (4)
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Content/FruitHeroItem (4)").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero5 = CommonUtil.BindGridViewItem2LuaStatic("FruitHeroItem", tmp)
	self.hero5.prefabName = "FruitHeroItem"
end

---@private
function UIFruitUseView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/Content/FruitHeroItem (5)
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/Content/FruitHeroItem (5)").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero6 = CommonUtil.BindGridViewItem2LuaStatic("FruitHeroItem", tmp)
	self.hero6.prefabName = "FruitHeroItem"
end

---@private
function UIFruitUseView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.textTitle) ~= nil then
		tolua.setpeer(self.textTitle, nil)
	end
	self.textTitle = nil
	if tolua.getpeer(self.closeBox) ~= nil then
		tolua.setpeer(self.closeBox, nil)
	end
	self.closeBox = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.primaryImage) ~= nil then
		tolua.setpeer(self.primaryImage, nil)
	end
	self.primaryImage = nil
	if tolua.getpeer(self.primaryText) ~= nil then
		tolua.setpeer(self.primaryText, nil)
	end
	self.primaryText = nil
	if tolua.getpeer(self.seniorImage) ~= nil then
		tolua.setpeer(self.seniorImage, nil)
	end
	self.seniorImage = nil
	if tolua.getpeer(self.seniorText) ~= nil then
		tolua.setpeer(self.seniorText, nil)
	end
	self.seniorText = nil
	if self.hero1.GenerateDestroy ~= nil then
		self.hero1:GenerateDestroy()
	end
	if tolua.getpeer(self.hero1) ~= nil then
		tolua.setpeer(self.hero1, nil)
	end
	self.hero1 = nil
	if self.hero2.GenerateDestroy ~= nil then
		self.hero2:GenerateDestroy()
	end
	if tolua.getpeer(self.hero2) ~= nil then
		tolua.setpeer(self.hero2, nil)
	end
	self.hero2 = nil
	if self.hero3.GenerateDestroy ~= nil then
		self.hero3:GenerateDestroy()
	end
	if tolua.getpeer(self.hero3) ~= nil then
		tolua.setpeer(self.hero3, nil)
	end
	self.hero3 = nil
	if self.hero4.GenerateDestroy ~= nil then
		self.hero4:GenerateDestroy()
	end
	if tolua.getpeer(self.hero4) ~= nil then
		tolua.setpeer(self.hero4, nil)
	end
	self.hero4 = nil
	if self.hero5.GenerateDestroy ~= nil then
		self.hero5:GenerateDestroy()
	end
	if tolua.getpeer(self.hero5) ~= nil then
		tolua.setpeer(self.hero5, nil)
	end
	self.hero5 = nil
	if self.hero6.GenerateDestroy ~= nil then
		self.hero6:GenerateDestroy()
	end
	if tolua.getpeer(self.hero6) ~= nil then
		tolua.setpeer(self.hero6, nil)
	end
	self.hero6 = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIFruitUseView