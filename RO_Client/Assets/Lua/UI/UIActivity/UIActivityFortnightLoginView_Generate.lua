---@class UIActivityFortnightLogin__Generate_backBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityFortnightLogin__Generate_curRewardName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityFortnightLogin__Generate_curDayTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIActivityFortnightLogin__Generate_image
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIActivityFortnightLogin__Generate_templateItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image

---@class UIActivityFortnightLogin__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIActivityFortnightLogin__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIActivityFortnightLogin__Generate_AnyBtn
---@field private rewardsNode UnityEngine.GameObject
---@field private templateItem UIActivityFortnightLogin__Generate_templateItem
---@field private image UIActivityFortnightLogin__Generate_image
---@field private curDayTxt UIActivityFortnightLogin__Generate_curDayTxt
---@field private curRewardName UIActivityFortnightLogin__Generate_curRewardName
---@field private backBtn UIActivityFortnightLogin__Generate_backBtn
local UIActivityFortnightLoginView = class("UIActivityFortnightLoginView", require("UIViewBase"))

function UIActivityFortnightLoginView:ctor()
end

---@private
function UIActivityFortnightLoginView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIActivityFortnightLoginView:InitGenerate(Root, data)
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
function UIActivityFortnightLoginView:InitGenerate__1(Root, data)
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
function UIActivityFortnightLoginView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/Bottom/Rewards
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Rewards").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardsNode = tmp
end

---@private
function UIActivityFortnightLoginView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Bottom/Rewards/RewardItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/Rewards/RewardItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.templateItem = CommonUtil.BindGridViewItem2LuaStatic("RewardItem", tmp)
	self.templateItem.prefabName = "RewardItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIActivityFortnightLoginView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Baner/Image
--]]
	local tmp = Root:Find("UIAnimator/Window/Baner/Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.image = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIActivityFortnightLoginView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Baner/Slogan/Day
--]]
	local tmp = Root:Find("UIAnimator/Window/Baner/Slogan/Day").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curDayTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityFortnightLoginView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Baner/Slogan/Item
--]]
	local tmp = Root:Find("UIAnimator/Window/Baner/Slogan/Item").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.curRewardName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIActivityFortnightLoginView:InitGenerate__7(Root, data)
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
function UIActivityFortnightLoginView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.rewardsNode) ~= nil then
		tolua.setpeer(self.rewardsNode, nil)
	end
	self.rewardsNode = nil
	if self.templateItem.GenerateDestroy ~= nil then
		self.templateItem:GenerateDestroy()
	end
	if tolua.getpeer(self.templateItem) ~= nil then
		tolua.setpeer(self.templateItem, nil)
	end
	self.templateItem = nil
	if tolua.getpeer(self.image) ~= nil then
		tolua.setpeer(self.image, nil)
	end
	self.image = nil
	if tolua.getpeer(self.curDayTxt) ~= nil then
		tolua.setpeer(self.curDayTxt, nil)
	end
	self.curDayTxt = nil
	if tolua.getpeer(self.curRewardName) ~= nil then
		tolua.setpeer(self.curRewardName, nil)
	end
	self.curRewardName = nil
	if tolua.getpeer(self.backBtn) ~= nil then
		tolua.setpeer(self.backBtn, nil)
	end
	self.backBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIActivityFortnightLoginView