---@class UIIdolGiftItem__Generate_slider_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIIdolGiftItem__Generate_slider_item_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIIdolGiftItem__Generate_slider_item_btnBox
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public box1 UnityEngine.GameObject
---@field public box2 UnityEngine.GameObject
---@field public box3 UnityEngine.GameObject
---@field public box4 UnityEngine.GameObject

---@class UIIdolGiftItem__Generate_slider_item
---@field public gameObject UnityEngine.GameObject
---@field public btnBox UIIdolGiftItem__Generate_slider_item_btnBox
---@field public num UIIdolGiftItem__Generate_slider_item_num

---@class UIIdolGiftItem__Generate_slider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider
---@field public item UIIdolGiftItem__Generate_slider_item
---@field public num UIIdolGiftItem__Generate_slider_num

---@class UIIdolGiftItem__Generate_btnSupport
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIIdolGiftItem__Generate_flag_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIIdolGiftItem__Generate_flag_playername
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIIdolGiftItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIIdolGiftItem__Generate_flag
---@field public gameObject UnityEngine.GameObject
---@field public playername UIIdolGiftItem__Generate_flag_playername
---@field public headItem UIIdolGiftItem__Generate_flag_headItem

---@class UIIdolGiftItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private flag UIIdolGiftItem__Generate_flag
---@field private bg UIIdolGiftItem__Generate_bg
---@field private btnSupport UIIdolGiftItem__Generate_btnSupport
---@field private slider UIIdolGiftItem__Generate_slider
local UIIdolGiftItemView = class("UIIdolGiftItemView")

function UIIdolGiftItemView:ctor()
end

---@private
function UIIdolGiftItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIIdolGiftItemView:InitGenerate(Root, data)
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
	self:InitGenerate__15(Root,data)


end

---@private
function UIIdolGiftItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIIdolGiftItemView:InitGenerate__2(Root, data)
--[[
	Flag
--]]
	local tmp = Root:Find("Flag").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.flag = tmp
end

---@private
function UIIdolGiftItemView:InitGenerate__3(Root, data)
--[[
	Flag/bg
--]]
	local tmp = Root:Find("Flag/bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIIdolGiftItemView:InitGenerate__4(Root, data)
--[[
	Flag/playername
--]]
	local tmp = Root:Find("Flag/playername").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.flag.playername = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIIdolGiftItemView:InitGenerate__5(Root, data)
--[[
	Flag/HeadItem
--]]
	local tmp = Root:Find("Flag/HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.flag.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.flag.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIIdolGiftItemView:InitGenerate__6(Root, data)
--[[
	BtnSupport
--]]
	local tmp = Root:Find("BtnSupport").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSupport = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIIdolGiftItemView:InitGenerate__7(Root, data)
--[[
	Favoring/Slider
--]]
	local tmp = Root:Find("Favoring/Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function UIIdolGiftItemView:InitGenerate__8(Root, data)
--[[
	Favoring/Slider/Handle/Item
--]]
	local tmp = Root:Find("Favoring/Slider/Handle/Item").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slider.item = tmp
	self.slider.item:SetActive(false)
end

---@private
function UIIdolGiftItemView:InitGenerate__9(Root, data)
--[[
	Favoring/Slider/Handle/Item/BtnBox
--]]
	local tmp = Root:Find("Favoring/Slider/Handle/Item/BtnBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slider.item.btnBox = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIIdolGiftItemView:InitGenerate__10(Root, data)
--[[
	Favoring/Slider/Handle/Item/BtnBox/box1
--]]
	local tmp = Root:Find("Favoring/Slider/Handle/Item/BtnBox/box1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slider.item.btnBox.box1 = tmp
end

---@private
function UIIdolGiftItemView:InitGenerate__11(Root, data)
--[[
	Favoring/Slider/Handle/Item/BtnBox/box2
--]]
	local tmp = Root:Find("Favoring/Slider/Handle/Item/BtnBox/box2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slider.item.btnBox.box2 = tmp
end

---@private
function UIIdolGiftItemView:InitGenerate__12(Root, data)
--[[
	Favoring/Slider/Handle/Item/BtnBox/box3
--]]
	local tmp = Root:Find("Favoring/Slider/Handle/Item/BtnBox/box3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slider.item.btnBox.box3 = tmp
end

---@private
function UIIdolGiftItemView:InitGenerate__13(Root, data)
--[[
	Favoring/Slider/Handle/Item/BtnBox/box4
--]]
	local tmp = Root:Find("Favoring/Slider/Handle/Item/BtnBox/box4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slider.item.btnBox.box4 = tmp
end

---@private
function UIIdolGiftItemView:InitGenerate__14(Root, data)
--[[
	Favoring/Slider/Handle/Item/text/num
--]]
	local tmp = Root:Find("Favoring/Slider/Handle/Item/text/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slider.item.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIIdolGiftItemView:InitGenerate__15(Root, data)
--[[
	Favoring/Slider/Handle/box/num
--]]
	local tmp = Root:Find("Favoring/Slider/Handle/box/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.slider.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIIdolGiftItemView:GenerateDestroy()
	if tolua.getpeer(self.slider.num) ~= nil then
		tolua.setpeer(self.slider.num, nil)
	end
	if tolua.getpeer(self.slider.item.num) ~= nil then
		tolua.setpeer(self.slider.item.num, nil)
	end
	if tolua.getpeer(self.slider.item.btnBox.box4) ~= nil then
		tolua.setpeer(self.slider.item.btnBox.box4, nil)
	end
	if tolua.getpeer(self.slider.item.btnBox.box3) ~= nil then
		tolua.setpeer(self.slider.item.btnBox.box3, nil)
	end
	if tolua.getpeer(self.slider.item.btnBox.box2) ~= nil then
		tolua.setpeer(self.slider.item.btnBox.box2, nil)
	end
	if tolua.getpeer(self.slider.item.btnBox.box1) ~= nil then
		tolua.setpeer(self.slider.item.btnBox.box1, nil)
	end
	if tolua.getpeer(self.slider.item.btnBox) ~= nil then
		tolua.setpeer(self.slider.item.btnBox, nil)
	end
	if tolua.getpeer(self.slider.item) ~= nil then
		tolua.setpeer(self.slider.item, nil)
	end
	if tolua.getpeer(self.slider) ~= nil then
		tolua.setpeer(self.slider, nil)
	end
	if tolua.getpeer(self.btnSupport) ~= nil then
		tolua.setpeer(self.btnSupport, nil)
	end
	if self.flag.headItem.GenerateDestroy ~= nil then
		self.flag.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.flag.headItem) ~= nil then
		tolua.setpeer(self.flag.headItem, nil)
	end
	if tolua.getpeer(self.flag.playername) ~= nil then
		tolua.setpeer(self.flag.playername, nil)
	end
	if tolua.getpeer(self.flag) ~= nil then
		tolua.setpeer(self.flag, nil)
	end
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIIdolGiftItemView