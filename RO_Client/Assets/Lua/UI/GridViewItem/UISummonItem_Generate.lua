---@class UISummonItem__Generate_extraRewardItem_percentTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UISummonItem__Generate_extraRewardItem_rewardSlider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class UISummonItem__Generate_extraRewardItem
---@field public gameObject UnityEngine.GameObject
---@field public rewardSlider UISummonItem__Generate_extraRewardItem_rewardSlider
---@field public percentTxt UISummonItem__Generate_extraRewardItem_percentTxt

---@class UISummonItem__Generate_btnDetails
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISummonItem__Generate_banner
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISummonItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private banner UISummonItem__Generate_banner
---@field private btnDetails UISummonItem__Generate_btnDetails
---@field private extraBox UnityEngine.GameObject
---@field private extraRewardItem UISummonItem__Generate_extraRewardItem
local UISummonItemView = class("UISummonItemView")

function UISummonItemView:ctor()
end

---@private
function UISummonItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISummonItemView:InitGenerate(Root, data)
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


end

---@private
function UISummonItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UISummonItemView:InitGenerate__2(Root, data)
--[[
	Banner
--]]
	local tmp = Root:Find("Banner").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.banner = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISummonItemView:InitGenerate__3(Root, data)
--[[
	BtnDetails
--]]
	local tmp = Root:Find("BtnDetails").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnDetails = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISummonItemView:InitGenerate__4(Root, data)
--[[
	ExtraBox
--]]
	local tmp = Root:Find("ExtraBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.extraBox = tmp
end

---@private
function UISummonItemView:InitGenerate__5(Root, data)
--[[
	ExtraBox/ExtraRewardItem
--]]
	local tmp = Root:Find("ExtraBox/ExtraRewardItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.extraRewardItem = tmp
end

---@private
function UISummonItemView:InitGenerate__6(Root, data)
--[[
	ExtraBox/ExtraRewardItem/RewardSlider
--]]
	local tmp = Root:Find("ExtraBox/ExtraRewardItem/RewardSlider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.extraRewardItem.rewardSlider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function UISummonItemView:InitGenerate__7(Root, data)
--[[
	ExtraBox/ExtraRewardItem/PercentTxt
--]]
	local tmp = Root:Find("ExtraBox/ExtraRewardItem/PercentTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.extraRewardItem.percentTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UISummonItemView:GenerateDestroy()
	if tolua.getpeer(self.extraRewardItem.percentTxt) ~= nil then
		tolua.setpeer(self.extraRewardItem.percentTxt, nil)
	end
	if tolua.getpeer(self.extraRewardItem.rewardSlider) ~= nil then
		tolua.setpeer(self.extraRewardItem.rewardSlider, nil)
	end
	if tolua.getpeer(self.extraRewardItem) ~= nil then
		tolua.setpeer(self.extraRewardItem, nil)
	end
	if tolua.getpeer(self.btnDetails) ~= nil then
		tolua.setpeer(self.btnDetails, nil)
	end
	if tolua.getpeer(self.banner) ~= nil then
		tolua.setpeer(self.banner, nil)
	end
	if tolua.getpeer(self.extraBox) ~= nil then
		tolua.setpeer(self.extraBox, nil)
	end
	self.extraBox = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISummonItemView