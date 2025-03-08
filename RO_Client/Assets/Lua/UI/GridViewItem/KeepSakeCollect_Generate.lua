---@class KeepSakeCollect__Generate_level
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class KeepSakeCollect__Generate_cardLabel
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class KeepSakeCollect__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class KeepSakeCollect__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class KeepSakeCollect__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button
---@field public repeatButton UnityEngine.UI.RepeatButton

---@class KeepSakeCollect__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private collectionIconItem UnityEngine.GameObject
---@field private bg KeepSakeCollect__Generate_bg
---@field private icon KeepSakeCollect__Generate_icon
---@field private frame KeepSakeCollect__Generate_frame
---@field private cardLabel KeepSakeCollect__Generate_cardLabel
---@field private level KeepSakeCollect__Generate_level
---@field private mask UnityEngine.GameObject
---@field private uIRedPointRP UnityEngine.GameObject
local KeepSakeCollectView = class("KeepSakeCollectView")

function KeepSakeCollectView:ctor()
end

---@private
function KeepSakeCollectView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function KeepSakeCollectView:InitGenerate(Root, data)
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
function KeepSakeCollectView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function KeepSakeCollectView:InitGenerate__2(Root, data)
--[[
	CollectionIconItem
--]]
	local tmp = Root:Find("CollectionIconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.collectionIconItem = tmp
end

---@private
function KeepSakeCollectView:InitGenerate__3(Root, data)
--[[
	CollectionIconItem/Bg
--]]
	local tmp = Root:Find("CollectionIconItem/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)

	tmp.repeatButton = tmp:GetComponent(Enum.TypeInfo.RepeatButton)
end

---@private
function KeepSakeCollectView:InitGenerate__4(Root, data)
--[[
	CollectionIconItem/Icon
--]]
	local tmp = Root:Find("CollectionIconItem/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function KeepSakeCollectView:InitGenerate__5(Root, data)
--[[
	CollectionIconItem/Frame
--]]
	local tmp = Root:Find("CollectionIconItem/Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frame = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function KeepSakeCollectView:InitGenerate__6(Root, data)
--[[
	CollectionIconItem/CardLabel
--]]
	local tmp = Root:Find("CollectionIconItem/CardLabel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardLabel = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function KeepSakeCollectView:InitGenerate__7(Root, data)
--[[
	CollectionIconItem/Level
--]]
	local tmp = Root:Find("CollectionIconItem/Level").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.level = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function KeepSakeCollectView:InitGenerate__8(Root, data)
--[[
	CollectionIconItem/Mask
--]]
	local tmp = Root:Find("CollectionIconItem/Mask").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mask = tmp
end

---@private
function KeepSakeCollectView:InitGenerate__9(Root, data)
--[[
	UIRedPointRP
--]]
	local tmp = Root:Find("UIRedPointRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIRedPointRP = tmp
end

---@private
function KeepSakeCollectView:GenerateDestroy()
	if tolua.getpeer(self.collectionIconItem) ~= nil then
		tolua.setpeer(self.collectionIconItem, nil)
	end
	self.collectionIconItem = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	self.frame = nil
	if tolua.getpeer(self.cardLabel) ~= nil then
		tolua.setpeer(self.cardLabel, nil)
	end
	self.cardLabel = nil
	if tolua.getpeer(self.level) ~= nil then
		tolua.setpeer(self.level, nil)
	end
	self.level = nil
	if tolua.getpeer(self.mask) ~= nil then
		tolua.setpeer(self.mask, nil)
	end
	self.mask = nil
	if tolua.getpeer(self.uIRedPointRP) ~= nil then
		tolua.setpeer(self.uIRedPointRP, nil)
	end
	self.uIRedPointRP = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return KeepSakeCollectView