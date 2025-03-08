---@class CardCollect__Generate_cardLabel
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardCollect__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardCollect__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class CardCollect__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button
---@field public repeatButton UnityEngine.UI.RepeatButton

---@class CardCollect__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private cardIconItem UnityEngine.GameObject
---@field private bg CardCollect__Generate_bg
---@field private icon CardCollect__Generate_icon
---@field private frame CardCollect__Generate_frame
---@field private cardLabel CardCollect__Generate_cardLabel
---@field private mask UnityEngine.GameObject
---@field private uIRedPointRP UnityEngine.GameObject
local CardCollectView = class("CardCollectView")

function CardCollectView:ctor()
end

---@private
function CardCollectView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CardCollectView:InitGenerate(Root, data)
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


end

---@private
function CardCollectView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function CardCollectView:InitGenerate__2(Root, data)
--[[
	CardIconItem
--]]
	local tmp = Root:Find("CardIconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardIconItem = tmp
end

---@private
function CardCollectView:InitGenerate__3(Root, data)
--[[
	CardIconItem/Bg
--]]
	local tmp = Root:Find("CardIconItem/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)

	tmp.repeatButton = tmp:GetComponent(Enum.TypeInfo.RepeatButton)
end

---@private
function CardCollectView:InitGenerate__4(Root, data)
--[[
	CardIconItem/Icon
--]]
	local tmp = Root:Find("CardIconItem/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function CardCollectView:InitGenerate__5(Root, data)
--[[
	CardIconItem/Frame
--]]
	local tmp = Root:Find("CardIconItem/Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frame = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function CardCollectView:InitGenerate__6(Root, data)
--[[
	CardIconItem/CardLabel
--]]
	local tmp = Root:Find("CardIconItem/CardLabel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardLabel = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function CardCollectView:InitGenerate__7(Root, data)
--[[
	CardIconItem/Mask
--]]
	local tmp = Root:Find("CardIconItem/Mask").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mask = tmp
end

---@private
function CardCollectView:InitGenerate__8(Root, data)
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
function CardCollectView:GenerateDestroy()
	if tolua.getpeer(self.cardIconItem) ~= nil then
		tolua.setpeer(self.cardIconItem, nil)
	end
	self.cardIconItem = nil
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
return CardCollectView