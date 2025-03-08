---@class DanRewardItem__Generate_itemContent
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class DanRewardItem__Generate_itemScroll
---@field public gameObject UnityEngine.GameObject
---@field public loopHorizontalScrollRect UnityEngine.UI.LoopHorizontalScrollRect

---@class DanRewardItem__Generate_danName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class DanRewardItem__Generate_rankVal
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class DanRewardItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bg UnityEngine.GameObject
---@field private rankVal DanRewardItem__Generate_rankVal
---@field private rank1 UnityEngine.GameObject
---@field private rank2 UnityEngine.GameObject
---@field private rank3 UnityEngine.GameObject
---@field private danIcon UnityEngine.GameObject
---@field private danName DanRewardItem__Generate_danName
---@field private itemScroll DanRewardItem__Generate_itemScroll
---@field private itemContent DanRewardItem__Generate_itemContent
local DanRewardItemView = class("DanRewardItemView")

function DanRewardItemView:ctor()
end

---@private
function DanRewardItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function DanRewardItemView:InitGenerate(Root, data)
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


end

---@private
function DanRewardItemView:InitGenerate__1(Root, data)
--[[
	rankBg
--]]
	local tmp = Root:Find("rankBg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp
end

---@private
function DanRewardItemView:InitGenerate__2(Root, data)
--[[
	rankVal
--]]
	local tmp = Root:Find("rankVal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rankVal = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function DanRewardItemView:InitGenerate__3(Root, data)
--[[
	Madel01
--]]
	local tmp = Root:Find("Madel01").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rank1 = tmp
end

---@private
function DanRewardItemView:InitGenerate__4(Root, data)
--[[
	Madel02
--]]
	local tmp = Root:Find("Madel02").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rank2 = tmp
end

---@private
function DanRewardItemView:InitGenerate__5(Root, data)
--[[
	Madel03
--]]
	local tmp = Root:Find("Madel03").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rank3 = tmp
end

---@private
function DanRewardItemView:InitGenerate__6(Root, data)
--[[
	icon
--]]
	local tmp = Root:Find("icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.danIcon = tmp
end

---@private
function DanRewardItemView:InitGenerate__7(Root, data)
--[[
	name
--]]
	local tmp = Root:Find("name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.danName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function DanRewardItemView:InitGenerate__8(Root, data)
--[[
	items
--]]
	local tmp = Root:Find("items").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemScroll = tmp

	tmp.loopHorizontalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopHorizontalScrollRect)
end

---@private
function DanRewardItemView:InitGenerate__9(Root, data)
--[[
	items/Viewport/Content
--]]
	local tmp = Root:Find("items/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemContent = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function DanRewardItemView:GenerateDestroy()
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.rankVal) ~= nil then
		tolua.setpeer(self.rankVal, nil)
	end
	self.rankVal = nil
	if tolua.getpeer(self.rank1) ~= nil then
		tolua.setpeer(self.rank1, nil)
	end
	self.rank1 = nil
	if tolua.getpeer(self.rank2) ~= nil then
		tolua.setpeer(self.rank2, nil)
	end
	self.rank2 = nil
	if tolua.getpeer(self.rank3) ~= nil then
		tolua.setpeer(self.rank3, nil)
	end
	self.rank3 = nil
	if tolua.getpeer(self.danIcon) ~= nil then
		tolua.setpeer(self.danIcon, nil)
	end
	self.danIcon = nil
	if tolua.getpeer(self.danName) ~= nil then
		tolua.setpeer(self.danName, nil)
	end
	self.danName = nil
	if tolua.getpeer(self.itemScroll) ~= nil then
		tolua.setpeer(self.itemScroll, nil)
	end
	self.itemScroll = nil
	if tolua.getpeer(self.itemContent) ~= nil then
		tolua.setpeer(self.itemContent, nil)
	end
	self.itemContent = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return DanRewardItemView