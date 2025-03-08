---@class LevelIncreaseItem__Generate_AZenyLbl
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class LevelIncreaseItem__Generate_BZenyLbl
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class LevelIncreaseItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class LevelIncreaseItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class LevelIncreaseItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private bg LevelIncreaseItem__Generate_bg
---@field private icon LevelIncreaseItem__Generate_icon
---@field private BZenyLbl LevelIncreaseItem__Generate_BZenyLbl
---@field private AZenyLbl LevelIncreaseItem__Generate_AZenyLbl
---@field private ZenyUpgrade UnityEngine.GameObject
local LevelIncreaseItemView = class("LevelIncreaseItemView")

function LevelIncreaseItemView:ctor()
end

---@private
function LevelIncreaseItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function LevelIncreaseItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)
	self:InitGenerate__6(Root,data)


end

---@private
function LevelIncreaseItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function LevelIncreaseItemView:InitGenerate__2(Root, data)
--[[
	bg
--]]
	local tmp = Root:Find("bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function LevelIncreaseItemView:InitGenerate__3(Root, data)
--[[
	bg/NumberItem/Icon
--]]
	local tmp = Root:Find("bg/NumberItem/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function LevelIncreaseItemView:InitGenerate__4(Root, data)
--[[
	bg/NumberItem/Number1
--]]
	local tmp = Root:Find("bg/NumberItem/Number1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.BZenyLbl = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function LevelIncreaseItemView:InitGenerate__5(Root, data)
--[[
	bg/NumberItem/Number2
--]]
	local tmp = Root:Find("bg/NumberItem/Number2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AZenyLbl = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function LevelIncreaseItemView:InitGenerate__6(Root, data)
--[[
	bg/NumberItem/Upgrade
--]]
	local tmp = Root:Find("bg/NumberItem/Upgrade").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.ZenyUpgrade = tmp
end

---@private
function LevelIncreaseItemView:GenerateDestroy()
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.BZenyLbl) ~= nil then
		tolua.setpeer(self.BZenyLbl, nil)
	end
	self.BZenyLbl = nil
	if tolua.getpeer(self.AZenyLbl) ~= nil then
		tolua.setpeer(self.AZenyLbl, nil)
	end
	self.AZenyLbl = nil
	if tolua.getpeer(self.ZenyUpgrade) ~= nil then
		tolua.setpeer(self.ZenyUpgrade, nil)
	end
	self.ZenyUpgrade = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return LevelIncreaseItemView