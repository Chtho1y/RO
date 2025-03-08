---@class UIIdolSupportTips__Generate_btnSupport_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIIdolSupportTips__Generate_btnSupport
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public number UIIdolSupportTips__Generate_btnSupport_number

---@class UIIdolSupportTips__Generate_box_numBox_btnPlus
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIIdolSupportTips__Generate_box_numBox_btnMinus
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIIdolSupportTips__Generate_box_numBox_slider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class UIIdolSupportTips__Generate_box_numBox_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIIdolSupportTips__Generate_box_numBox
---@field public gameObject UnityEngine.GameObject
---@field public num UIIdolSupportTips__Generate_box_numBox_num
---@field public slider UIIdolSupportTips__Generate_box_numBox_slider
---@field public btnMinus UIIdolSupportTips__Generate_box_numBox_btnMinus
---@field public btnPlus UIIdolSupportTips__Generate_box_numBox_btnPlus

---@class UIIdolSupportTips__Generate_box
---@field public gameObject UnityEngine.GameObject
---@field public dscInfo UnityEngine.GameObject
---@field public numBox UIIdolSupportTips__Generate_box_numBox

---@class UIIdolSupportTips__Generate_idolRank_btnSupport
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIIdolSupportTips__Generate_idolRank_hotVal
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIIdolSupportTips__Generate_idolRank_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIIdolSupportTips__Generate_idolRank_vipIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIIdolSupportTips__Generate_idolRank_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIIdolSupportTips__Generate_idolRank_madel03
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIIdolSupportTips__Generate_idolRank_madel02
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIIdolSupportTips__Generate_idolRank_madel01
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIIdolSupportTips__Generate_idolRank_rank
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIIdolSupportTips__Generate_idolRank
---@field public gameObject UnityEngine.GameObject
---@field public rank UIIdolSupportTips__Generate_idolRank_rank
---@field public madel01 UIIdolSupportTips__Generate_idolRank_madel01
---@field public madel02 UIIdolSupportTips__Generate_idolRank_madel02
---@field public madel03 UIIdolSupportTips__Generate_idolRank_madel03
---@field public headItem UIIdolSupportTips__Generate_idolRank_headItem
---@field public vipIcon UIIdolSupportTips__Generate_idolRank_vipIcon
---@field public playerName UIIdolSupportTips__Generate_idolRank_playerName
---@field public hotVal UIIdolSupportTips__Generate_idolRank_hotVal
---@field public btnSupport UIIdolSupportTips__Generate_idolRank_btnSupport

---@class UIIdolSupportTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIIdolSupportTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIIdolSupportTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIIdolSupportTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIIdolSupportTips__Generate_uIAnimator
---@field private AnyBtn UIIdolSupportTips__Generate_AnyBtn
---@field private btnClose UIIdolSupportTips__Generate_btnClose
---@field private idolRank UIIdolSupportTips__Generate_idolRank
---@field private box UIIdolSupportTips__Generate_box
---@field private boxSliderHande UnityEngine.GameObject
---@field private btnSupport UIIdolSupportTips__Generate_btnSupport
local UIIdolSupportTipsView = class("UIIdolSupportTipsView", require("UIViewBase"))

function UIIdolSupportTipsView:ctor()
end

---@private
function UIIdolSupportTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIIdolSupportTipsView:InitGenerate(Root, data)
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
function UIIdolSupportTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIIdolSupportTipsView:InitGenerate__2(Root, data)
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
function UIIdolSupportTipsView:InitGenerate__3(Root, data)
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
function UIIdolSupportTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BtnClose/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnClose/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIIdolSupportTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/IdolRank
--]]
	local tmp = Root:Find("UIAnimator/Window/IdolRank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.idolRank = tmp
end

---@private
function UIIdolSupportTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/IdolRank/Rank
--]]
	local tmp = Root:Find("UIAnimator/Window/IdolRank/Rank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.idolRank.rank = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIIdolSupportTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/IdolRank/Madel01
--]]
	local tmp = Root:Find("UIAnimator/Window/IdolRank/Madel01").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.idolRank.madel01 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIIdolSupportTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/IdolRank/Madel02
--]]
	local tmp = Root:Find("UIAnimator/Window/IdolRank/Madel02").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.idolRank.madel02 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIIdolSupportTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/IdolRank/Madel03
--]]
	local tmp = Root:Find("UIAnimator/Window/IdolRank/Madel03").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.idolRank.madel03 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIIdolSupportTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/IdolRank/PlayerNode/HeadBox/HeadItem
--]]
	local tmp = Root:Find("UIAnimator/Window/IdolRank/PlayerNode/HeadBox/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.idolRank.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.idolRank.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIIdolSupportTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/IdolRank/PlayerNode/VipIcon
--]]
	local tmp = Root:Find("UIAnimator/Window/IdolRank/PlayerNode/VipIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.idolRank.vipIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIIdolSupportTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/IdolRank/PlayerNode/NameText
--]]
	local tmp = Root:Find("UIAnimator/Window/IdolRank/PlayerNode/NameText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.idolRank.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIIdolSupportTipsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/IdolRank/PlayerNode/HotVal
--]]
	local tmp = Root:Find("UIAnimator/Window/IdolRank/PlayerNode/HotVal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.idolRank.hotVal = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIIdolSupportTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/IdolRank/BtnSupport
--]]
	local tmp = Root:Find("UIAnimator/Window/IdolRank/BtnSupport").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.idolRank.btnSupport = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIIdolSupportTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bottom/Box
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Box").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.box = tmp
end

---@private
function UIIdolSupportTipsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bottom/Box/DscInfo
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Box/DscInfo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.box.dscInfo = tmp
end

---@private
function UIIdolSupportTipsView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bottom/Box/NumBox
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Box/NumBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.box.numBox = tmp
end

---@private
function UIIdolSupportTipsView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bottom/Box/NumBox/num
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Box/NumBox/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.box.numBox.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIIdolSupportTipsView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bottom/Box/NumBox/Slider
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Box/NumBox/Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.box.numBox.slider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function UIIdolSupportTipsView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bottom/Box/NumBox/Slider/Handle Slide Area
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Box/NumBox/Slider/Handle Slide Area").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxSliderHande = tmp
end

---@private
function UIIdolSupportTipsView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bottom/Box/NumBox/BtnMinus
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Box/NumBox/BtnMinus").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.box.numBox.btnMinus = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIIdolSupportTipsView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/Bottom/Box/NumBox/BtnPlus
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Box/NumBox/BtnPlus").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.box.numBox.btnPlus = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIIdolSupportTipsView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnSupport
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnSupport").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSupport = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIIdolSupportTipsView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnSupport/Content/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnSupport/Content/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSupport.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIIdolSupportTipsView:GenerateDestroy()
	if tolua.getpeer(self.btnSupport.number) ~= nil then
		tolua.setpeer(self.btnSupport.number, nil)
	end
	if tolua.getpeer(self.box.numBox.btnPlus) ~= nil then
		tolua.setpeer(self.box.numBox.btnPlus, nil)
	end
	if tolua.getpeer(self.box.numBox.btnMinus) ~= nil then
		tolua.setpeer(self.box.numBox.btnMinus, nil)
	end
	if tolua.getpeer(self.box.numBox.slider) ~= nil then
		tolua.setpeer(self.box.numBox.slider, nil)
	end
	if tolua.getpeer(self.box.numBox.num) ~= nil then
		tolua.setpeer(self.box.numBox.num, nil)
	end
	if tolua.getpeer(self.box.numBox) ~= nil then
		tolua.setpeer(self.box.numBox, nil)
	end
	if tolua.getpeer(self.box.dscInfo) ~= nil then
		tolua.setpeer(self.box.dscInfo, nil)
	end
	if tolua.getpeer(self.idolRank.btnSupport) ~= nil then
		tolua.setpeer(self.idolRank.btnSupport, nil)
	end
	if tolua.getpeer(self.idolRank.hotVal) ~= nil then
		tolua.setpeer(self.idolRank.hotVal, nil)
	end
	if tolua.getpeer(self.idolRank.playerName) ~= nil then
		tolua.setpeer(self.idolRank.playerName, nil)
	end
	if tolua.getpeer(self.idolRank.vipIcon) ~= nil then
		tolua.setpeer(self.idolRank.vipIcon, nil)
	end
	if self.idolRank.headItem.GenerateDestroy ~= nil then
		self.idolRank.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.idolRank.headItem) ~= nil then
		tolua.setpeer(self.idolRank.headItem, nil)
	end
	if tolua.getpeer(self.idolRank.madel03) ~= nil then
		tolua.setpeer(self.idolRank.madel03, nil)
	end
	if tolua.getpeer(self.idolRank.madel02) ~= nil then
		tolua.setpeer(self.idolRank.madel02, nil)
	end
	if tolua.getpeer(self.idolRank.madel01) ~= nil then
		tolua.setpeer(self.idolRank.madel01, nil)
	end
	if tolua.getpeer(self.idolRank.rank) ~= nil then
		tolua.setpeer(self.idolRank.rank, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.idolRank) ~= nil then
		tolua.setpeer(self.idolRank, nil)
	end
	self.idolRank = nil
	if tolua.getpeer(self.box) ~= nil then
		tolua.setpeer(self.box, nil)
	end
	self.box = nil
	if tolua.getpeer(self.boxSliderHande) ~= nil then
		tolua.setpeer(self.boxSliderHande, nil)
	end
	self.boxSliderHande = nil
	if tolua.getpeer(self.btnSupport) ~= nil then
		tolua.setpeer(self.btnSupport, nil)
	end
	self.btnSupport = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIIdolSupportTipsView