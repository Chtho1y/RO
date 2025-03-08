---@class UISeasonRewardItem__Generate_progress
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISeasonRewardItem__Generate_rewardName
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UISeasonRewardItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISeasonRewardItem__Generate_shadow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISeasonRewardItem__Generate_flag
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISeasonRewardItem__Generate_circle
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UISeasonRewardItem__Generate_content
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UISeasonRewardItem__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopHorizontalScrollRect UnityEngine.UI.LoopHorizontalScrollRect
---@field public loopScrollRectDragEventInherit LoopScrollRectDragEventInherit

---@class UISeasonRewardItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private scrollView UISeasonRewardItem__Generate_scrollView
---@field private content UISeasonRewardItem__Generate_content
---@field private cornerMark UnityEngine.GameObject
---@field private rewarded UnityEngine.GameObject
---@field private label UnityEngine.GameObject
---@field private circle UISeasonRewardItem__Generate_circle
---@field private flag UISeasonRewardItem__Generate_flag
---@field private shadow UISeasonRewardItem__Generate_shadow
---@field private icon UISeasonRewardItem__Generate_icon
---@field private rewardName UISeasonRewardItem__Generate_rewardName
---@field private progress UISeasonRewardItem__Generate_progress
local UISeasonRewardItemView = class("UISeasonRewardItemView")

function UISeasonRewardItemView:ctor()
end

---@private
function UISeasonRewardItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISeasonRewardItemView:InitGenerate(Root, data)
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


end

---@private
function UISeasonRewardItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UISeasonRewardItemView:InitGenerate__2(Root, data)
--[[
	Scroll View
--]]
	local tmp = Root:Find("Scroll View").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopHorizontalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopHorizontalScrollRect)

	tmp.loopScrollRectDragEventInherit = tmp:GetComponent(Enum.TypeInfo.LoopScrollRectDragEventInherit)
end

---@private
function UISeasonRewardItemView:InitGenerate__3(Root, data)
--[[
	Scroll View/Viewport/Content
--]]
	local tmp = Root:Find("Scroll View/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UISeasonRewardItemView:InitGenerate__4(Root, data)
--[[
	CornerMark
--]]
	local tmp = Root:Find("CornerMark").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cornerMark = tmp
	self.cornerMark:SetActive(false)
end

---@private
function UISeasonRewardItemView:InitGenerate__5(Root, data)
--[[
	Rewarded
--]]
	local tmp = Root:Find("Rewarded").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewarded = tmp
	self.rewarded:SetActive(false)
end

---@private
function UISeasonRewardItemView:InitGenerate__6(Root, data)
--[[
	Rewarded/Label
--]]
	local tmp = Root:Find("Rewarded/Label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.label = tmp
end

---@private
function UISeasonRewardItemView:InitGenerate__7(Root, data)
--[[
	circle
--]]
	local tmp = Root:Find("circle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.circle = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISeasonRewardItemView:InitGenerate__8(Root, data)
--[[
	Flag
--]]
	local tmp = Root:Find("Flag").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.flag = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISeasonRewardItemView:InitGenerate__9(Root, data)
--[[
	shadow
--]]
	local tmp = Root:Find("shadow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.shadow = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISeasonRewardItemView:InitGenerate__10(Root, data)
--[[
	icon
--]]
	local tmp = Root:Find("icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UISeasonRewardItemView:InitGenerate__11(Root, data)
--[[
	RewardName
--]]
	local tmp = Root:Find("RewardName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UISeasonRewardItemView:InitGenerate__12(Root, data)
--[[
	Progress
--]]
	local tmp = Root:Find("Progress").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.progress = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISeasonRewardItemView:GenerateDestroy()
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	if tolua.getpeer(self.cornerMark) ~= nil then
		tolua.setpeer(self.cornerMark, nil)
	end
	self.cornerMark = nil
	if tolua.getpeer(self.rewarded) ~= nil then
		tolua.setpeer(self.rewarded, nil)
	end
	self.rewarded = nil
	if tolua.getpeer(self.label) ~= nil then
		tolua.setpeer(self.label, nil)
	end
	self.label = nil
	if tolua.getpeer(self.circle) ~= nil then
		tolua.setpeer(self.circle, nil)
	end
	self.circle = nil
	if tolua.getpeer(self.flag) ~= nil then
		tolua.setpeer(self.flag, nil)
	end
	self.flag = nil
	if tolua.getpeer(self.shadow) ~= nil then
		tolua.setpeer(self.shadow, nil)
	end
	self.shadow = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.rewardName) ~= nil then
		tolua.setpeer(self.rewardName, nil)
	end
	self.rewardName = nil
	if tolua.getpeer(self.progress) ~= nil then
		tolua.setpeer(self.progress, nil)
	end
	self.progress = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISeasonRewardItemView