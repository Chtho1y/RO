---@class GuildWarBuyBuffItem__Generate_lv10
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class GuildWarBuyBuffItem__Generate_lv9
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class GuildWarBuyBuffItem__Generate_lv8
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class GuildWarBuyBuffItem__Generate_lv7
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class GuildWarBuyBuffItem__Generate_lv6
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class GuildWarBuyBuffItem__Generate_lv5
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class GuildWarBuyBuffItem__Generate_lv4
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class GuildWarBuyBuffItem__Generate_lv3
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class GuildWarBuyBuffItem__Generate_lv2
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class GuildWarBuyBuffItem__Generate_lv1
---@field public gameObject UnityEngine.GameObject
---@field public uIImageSwitchSprite UIImageSwitchSprite

---@class GuildWarBuyBuffItem__Generate_btnBuy
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class GuildWarBuyBuffItem__Generate_dsc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildWarBuyBuffItem__Generate_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class GuildWarBuyBuffItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class GuildWarBuyBuffItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private icon GuildWarBuyBuffItem__Generate_icon
---@field private num GuildWarBuyBuffItem__Generate_num
---@field private dsc GuildWarBuyBuffItem__Generate_dsc
---@field private btnBuy GuildWarBuyBuffItem__Generate_btnBuy
---@field private lv1 GuildWarBuyBuffItem__Generate_lv1
---@field private lv2 GuildWarBuyBuffItem__Generate_lv2
---@field private lv3 GuildWarBuyBuffItem__Generate_lv3
---@field private lv4 GuildWarBuyBuffItem__Generate_lv4
---@field private lv5 GuildWarBuyBuffItem__Generate_lv5
---@field private lv6 GuildWarBuyBuffItem__Generate_lv6
---@field private lv7 GuildWarBuyBuffItem__Generate_lv7
---@field private lv8 GuildWarBuyBuffItem__Generate_lv8
---@field private lv9 GuildWarBuyBuffItem__Generate_lv9
---@field private lv10 GuildWarBuyBuffItem__Generate_lv10
local GuildWarBuyBuffItemView = class("GuildWarBuyBuffItemView")

function GuildWarBuyBuffItemView:ctor()
end

---@private
function GuildWarBuyBuffItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function GuildWarBuyBuffItemView:InitGenerate(Root, data)
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
function GuildWarBuyBuffItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function GuildWarBuyBuffItemView:InitGenerate__2(Root, data)
--[[
	IconSmallItem/Icon
--]]
	local tmp = Root:Find("IconSmallItem/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function GuildWarBuyBuffItemView:InitGenerate__3(Root, data)
--[[
	IconSmallItem/Num
--]]
	local tmp = Root:Find("IconSmallItem/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function GuildWarBuyBuffItemView:InitGenerate__4(Root, data)
--[[
	Dsc
--]]
	local tmp = Root:Find("Dsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dsc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function GuildWarBuyBuffItemView:InitGenerate__5(Root, data)
--[[
	BtnBuy
--]]
	local tmp = Root:Find("BtnBuy").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBuy = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function GuildWarBuyBuffItemView:InitGenerate__6(Root, data)
--[[
	Levels/Lv1
--]]
	local tmp = Root:Find("Levels/Lv1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lv1 = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function GuildWarBuyBuffItemView:InitGenerate__7(Root, data)
--[[
	Levels/Lv2
--]]
	local tmp = Root:Find("Levels/Lv2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lv2 = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function GuildWarBuyBuffItemView:InitGenerate__8(Root, data)
--[[
	Levels/Lv3
--]]
	local tmp = Root:Find("Levels/Lv3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lv3 = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function GuildWarBuyBuffItemView:InitGenerate__9(Root, data)
--[[
	Levels/Lv4
--]]
	local tmp = Root:Find("Levels/Lv4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lv4 = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function GuildWarBuyBuffItemView:InitGenerate__10(Root, data)
--[[
	Levels/Lv5
--]]
	local tmp = Root:Find("Levels/Lv5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lv5 = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function GuildWarBuyBuffItemView:InitGenerate__11(Root, data)
--[[
	Levels/Lv6
--]]
	local tmp = Root:Find("Levels/Lv6").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lv6 = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function GuildWarBuyBuffItemView:InitGenerate__12(Root, data)
--[[
	Levels/Lv7
--]]
	local tmp = Root:Find("Levels/Lv7").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lv7 = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function GuildWarBuyBuffItemView:InitGenerate__13(Root, data)
--[[
	Levels/Lv8
--]]
	local tmp = Root:Find("Levels/Lv8").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lv8 = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function GuildWarBuyBuffItemView:InitGenerate__14(Root, data)
--[[
	Levels/Lv9
--]]
	local tmp = Root:Find("Levels/Lv9").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lv9 = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function GuildWarBuyBuffItemView:InitGenerate__15(Root, data)
--[[
	Levels/Lv10
--]]
	local tmp = Root:Find("Levels/Lv10").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lv10 = tmp

	tmp.uIImageSwitchSprite = tmp:GetComponent(Enum.TypeInfo.UIImageSwitchSprite)
end

---@private
function GuildWarBuyBuffItemView:GenerateDestroy()
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.num) ~= nil then
		tolua.setpeer(self.num, nil)
	end
	self.num = nil
	if tolua.getpeer(self.dsc) ~= nil then
		tolua.setpeer(self.dsc, nil)
	end
	self.dsc = nil
	if tolua.getpeer(self.btnBuy) ~= nil then
		tolua.setpeer(self.btnBuy, nil)
	end
	self.btnBuy = nil
	if tolua.getpeer(self.lv1) ~= nil then
		tolua.setpeer(self.lv1, nil)
	end
	self.lv1 = nil
	if tolua.getpeer(self.lv2) ~= nil then
		tolua.setpeer(self.lv2, nil)
	end
	self.lv2 = nil
	if tolua.getpeer(self.lv3) ~= nil then
		tolua.setpeer(self.lv3, nil)
	end
	self.lv3 = nil
	if tolua.getpeer(self.lv4) ~= nil then
		tolua.setpeer(self.lv4, nil)
	end
	self.lv4 = nil
	if tolua.getpeer(self.lv5) ~= nil then
		tolua.setpeer(self.lv5, nil)
	end
	self.lv5 = nil
	if tolua.getpeer(self.lv6) ~= nil then
		tolua.setpeer(self.lv6, nil)
	end
	self.lv6 = nil
	if tolua.getpeer(self.lv7) ~= nil then
		tolua.setpeer(self.lv7, nil)
	end
	self.lv7 = nil
	if tolua.getpeer(self.lv8) ~= nil then
		tolua.setpeer(self.lv8, nil)
	end
	self.lv8 = nil
	if tolua.getpeer(self.lv9) ~= nil then
		tolua.setpeer(self.lv9, nil)
	end
	self.lv9 = nil
	if tolua.getpeer(self.lv10) ~= nil then
		tolua.setpeer(self.lv10, nil)
	end
	self.lv10 = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return GuildWarBuyBuffItemView