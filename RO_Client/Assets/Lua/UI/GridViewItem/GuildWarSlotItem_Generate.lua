---@class GuildWarSlotItem__Generate_nameBoard_power
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class GuildWarSlotItem__Generate_nameBoard_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class GuildWarSlotItem__Generate_nameBoard_bG
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class GuildWarSlotItem__Generate_nameBoard
---@field public gameObject UnityEngine.GameObject
---@field public bG GuildWarSlotItem__Generate_nameBoard_bG
---@field public nameTxt GuildWarSlotItem__Generate_nameBoard_nameTxt
---@field public power GuildWarSlotItem__Generate_nameBoard_power

---@class GuildWarSlotItem__Generate_player
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class GuildWarSlotItem__Generate_imgThrone
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class GuildWarSlotItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private animator UnityEngine.Animator
---@field private button UnityEngine.UI.Button
---@field private imgThrone GuildWarSlotItem__Generate_imgThrone
---@field private shadow UnityEngine.GameObject
---@field private player GuildWarSlotItem__Generate_player
---@field private nameBoard GuildWarSlotItem__Generate_nameBoard
local GuildWarSlotItemView = class("GuildWarSlotItemView")

function GuildWarSlotItemView:ctor()
end

---@private
function GuildWarSlotItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function GuildWarSlotItemView:InitGenerate(Root, data)
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
function GuildWarSlotItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.animator = Root:GetComponent(Enum.TypeInfo.Animator)
	self.animator.logWarnings = false

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function GuildWarSlotItemView:InitGenerate__2(Root, data)
--[[
	ImgThrone
--]]
	local tmp = Root:Find("ImgThrone").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.imgThrone = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function GuildWarSlotItemView:InitGenerate__3(Root, data)
--[[
	Shadow
--]]
	local tmp = Root:Find("Shadow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.shadow = tmp
end

---@private
function GuildWarSlotItemView:InitGenerate__4(Root, data)
--[[
	Player
--]]
	local tmp = Root:Find("Player").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.player = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function GuildWarSlotItemView:InitGenerate__5(Root, data)
--[[
	NameBoard
--]]
	local tmp = Root:Find("NameBoard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameBoard = tmp
end

---@private
function GuildWarSlotItemView:InitGenerate__6(Root, data)
--[[
	NameBoard/BG
--]]
	local tmp = Root:Find("NameBoard/BG").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameBoard.bG = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function GuildWarSlotItemView:InitGenerate__7(Root, data)
--[[
	NameBoard/NameTxt
--]]
	local tmp = Root:Find("NameBoard/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameBoard.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function GuildWarSlotItemView:InitGenerate__8(Root, data)
--[[
	NameBoard/Power
--]]
	local tmp = Root:Find("NameBoard/Power").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameBoard.power = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function GuildWarSlotItemView:GenerateDestroy()
	if tolua.getpeer(self.nameBoard.power) ~= nil then
		tolua.setpeer(self.nameBoard.power, nil)
	end
	if tolua.getpeer(self.nameBoard.nameTxt) ~= nil then
		tolua.setpeer(self.nameBoard.nameTxt, nil)
	end
	if tolua.getpeer(self.nameBoard.bG) ~= nil then
		tolua.setpeer(self.nameBoard.bG, nil)
	end
	if tolua.getpeer(self.imgThrone) ~= nil then
		tolua.setpeer(self.imgThrone, nil)
	end
	self.imgThrone = nil
	if tolua.getpeer(self.shadow) ~= nil then
		tolua.setpeer(self.shadow, nil)
	end
	self.shadow = nil
	if tolua.getpeer(self.player) ~= nil then
		tolua.setpeer(self.player, nil)
	end
	self.player = nil
	if tolua.getpeer(self.nameBoard) ~= nil then
		tolua.setpeer(self.nameBoard, nil)
	end
	self.nameBoard = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return GuildWarSlotItemView