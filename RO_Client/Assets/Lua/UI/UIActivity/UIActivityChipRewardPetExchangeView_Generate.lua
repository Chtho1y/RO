---@class UIActivityChipRewardPetExchange__Generate_backBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityChipRewardPetExchange__Generate_time
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIActivityChipRewardPetExchange__Generate_btnInfo
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityChipRewardPetExchange__Generate_banner
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIActivityChipRewardPetExchange__Generate_btnReceive
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityChipRewardPetExchange__Generate_btnRecharge
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityChipRewardPetExchange__Generate_dscTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityChipRewardPetExchange__Generate_petExchangeItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIActivityChipRewardPetExchange__Generate_boxExchange
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UIActivityChipRewardPetExchange__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityChipRewardPetExchange__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIActivityChipRewardPetExchange__Generate_AnyBtn
---@field private boxExchange UIActivityChipRewardPetExchange__Generate_boxExchange
---@field private petExchangeItem UIActivityChipRewardPetExchange__Generate_petExchangeItem
---@field private dscTxt UIActivityChipRewardPetExchange__Generate_dscTxt
---@field private btnRecharge UIActivityChipRewardPetExchange__Generate_btnRecharge
---@field private btnReceive UIActivityChipRewardPetExchange__Generate_btnReceive
---@field private labelReceived1 UnityEngine.GameObject
---@field private banner UIActivityChipRewardPetExchange__Generate_banner
---@field private btnInfo UIActivityChipRewardPetExchange__Generate_btnInfo
---@field private time UIActivityChipRewardPetExchange__Generate_time
---@field private backBtn UIActivityChipRewardPetExchange__Generate_backBtn
local UIActivityChipRewardPetExchangeView = class("UIActivityChipRewardPetExchangeView", require("UIViewBase"))

function UIActivityChipRewardPetExchangeView:ctor()
end

---@private
function UIActivityChipRewardPetExchangeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIActivityChipRewardPetExchangeView:InitGenerate(Root, data)
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


end

---@private
function UIActivityChipRewardPetExchangeView:InitGenerate__1(Root, data)
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
function UIActivityChipRewardPetExchangeView:InitGenerate__2(Root, data)
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
function UIActivityChipRewardPetExchangeView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Bottom/BoxExchange/Viewport/Content/PetExchangeItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BoxExchange/Viewport/Content/PetExchangeItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.petExchangeItem = CommonUtil.BindGridViewItem2LuaStatic("PetExchangeItem", tmp)
	self.petExchangeItem.prefabName = "PetExchangeItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIActivityChipRewardPetExchangeView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBox/Dsc/DscTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBox/Dsc/DscTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityChipRewardPetExchangeView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBox/BtnRecharge
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBox/BtnRecharge").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRecharge = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityChipRewardPetExchangeView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBox/BtnReceive
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBox/BtnReceive").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnReceive = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIActivityChipRewardPetExchangeView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnBox/LabelReceived1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnBox/LabelReceived1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelReceived1 = tmp
end

---@private
function UIActivityChipRewardPetExchangeView:InitGenerate__8(Root, data)
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
function UIActivityChipRewardPetExchangeView:InitGenerate__9(Root, data)
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
function UIActivityChipRewardPetExchangeView:InitGenerate__10(Root, data)
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
function UIActivityChipRewardPetExchangeView:InitGenerate__11(Root, data)
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
function UIActivityChipRewardPetExchangeView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.boxExchange) ~= nil then
		tolua.setpeer(self.boxExchange, nil)
	end
	self.boxExchange = nil
	if self.petExchangeItem.GenerateDestroy ~= nil then
		self.petExchangeItem:GenerateDestroy()
	end
	if tolua.getpeer(self.petExchangeItem) ~= nil then
		tolua.setpeer(self.petExchangeItem, nil)
	end
	self.petExchangeItem = nil
	if tolua.getpeer(self.dscTxt) ~= nil then
		tolua.setpeer(self.dscTxt, nil)
	end
	self.dscTxt = nil
	if tolua.getpeer(self.btnRecharge) ~= nil then
		tolua.setpeer(self.btnRecharge, nil)
	end
	self.btnRecharge = nil
	if tolua.getpeer(self.btnReceive) ~= nil then
		tolua.setpeer(self.btnReceive, nil)
	end
	self.btnReceive = nil
	if tolua.getpeer(self.labelReceived1) ~= nil then
		tolua.setpeer(self.labelReceived1, nil)
	end
	self.labelReceived1 = nil
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
return UIActivityChipRewardPetExchangeView