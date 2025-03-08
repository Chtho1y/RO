---@class UIActivityChipRewardCom__Generate_backBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityChipRewardCom__Generate_time
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIActivityChipRewardCom__Generate_btnInfo
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityChipRewardCom__Generate_banner
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIActivityChipRewardCom__Generate_exchangeItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIActivityChipRewardCom__Generate_boxExchange
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UIActivityChipRewardCom__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityChipRewardCom__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIActivityChipRewardCom__Generate_AnyBtn
---@field private boxExchange UIActivityChipRewardCom__Generate_boxExchange
---@field private exchangeItem UIActivityChipRewardCom__Generate_exchangeItem
---@field private banner UIActivityChipRewardCom__Generate_banner
---@field private btnInfo UIActivityChipRewardCom__Generate_btnInfo
---@field private time UIActivityChipRewardCom__Generate_time
---@field private backBtn UIActivityChipRewardCom__Generate_backBtn
local UIActivityChipRewardComView = class("UIActivityChipRewardComView", require("UIViewBase"))

function UIActivityChipRewardComView:ctor()
end

---@private
function UIActivityChipRewardComView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIActivityChipRewardComView:InitGenerate(Root, data)
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


end

---@private
function UIActivityChipRewardComView:InitGenerate__1(Root, data)
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
function UIActivityChipRewardComView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxExchange
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxExchange").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boxExchange = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIActivityChipRewardComView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxExchange/Viewport/Content/ExchangeItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxExchange/Viewport/Content/ExchangeItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.exchangeItem = CommonUtil.BindGridViewItem2LuaStatic("ExchangeItem", tmp)
	self.exchangeItem.prefabName = "ExchangeItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIActivityChipRewardComView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BannerBg/Banner
--]]
	local tmp = Root:Find("UIAnimator/Window/BannerBg/Banner").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.banner = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIActivityChipRewardComView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BannerBg/BtnInfo
--]]
	local tmp = Root:Find("UIAnimator/Window/BannerBg/BtnInfo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnInfo = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityChipRewardComView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BannerBg/TimeLimit/Time
--]]
	local tmp = Root:Find("UIAnimator/Window/BannerBg/TimeLimit/Time").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.time = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIActivityChipRewardComView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.backBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityChipRewardComView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.boxExchange) ~= nil then
		tolua.setpeer(self.boxExchange, nil)
	end
	self.boxExchange = nil
	if self.exchangeItem.GenerateDestroy ~= nil then
		self.exchangeItem:GenerateDestroy()
	end
	if tolua.getpeer(self.exchangeItem) ~= nil then
		tolua.setpeer(self.exchangeItem, nil)
	end
	self.exchangeItem = nil
	if tolua.getpeer(self.banner) ~= nil then
		tolua.setpeer(self.banner, nil)
	end
	self.banner = nil
	if tolua.getpeer(self.btnInfo) ~= nil then
		tolua.setpeer(self.btnInfo, nil)
	end
	self.btnInfo = nil
	if tolua.getpeer(self.time) ~= nil then
		tolua.setpeer(self.time, nil)
	end
	self.time = nil
	if tolua.getpeer(self.backBtn) ~= nil then
		tolua.setpeer(self.backBtn, nil)
	end
	self.backBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIActivityChipRewardComView