---@class VipUnlockDesItem__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class VipUnlockDesItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private desTxt VipUnlockDesItem__Generate_desTxt
---@field private exist UnityEngine.GameObject
---@field private new UnityEngine.GameObject
local VipUnlockDesItemView = class("VipUnlockDesItemView")

function VipUnlockDesItemView:ctor()
end

---@private
function VipUnlockDesItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function VipUnlockDesItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function VipUnlockDesItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function VipUnlockDesItemView:InitGenerate__2(Root, data)
--[[
	DesTxt
--]]
	local tmp = Root:Find("DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function VipUnlockDesItemView:InitGenerate__3(Root, data)
--[[
	DesTxt/Exist
--]]
	local tmp = Root:Find("DesTxt/Exist").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.exist = tmp
end

---@private
function VipUnlockDesItemView:InitGenerate__4(Root, data)
--[[
	DesTxt/New
--]]
	local tmp = Root:Find("DesTxt/New").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.new = tmp
end

---@private
function VipUnlockDesItemView:GenerateDestroy()
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	if tolua.getpeer(self.exist) ~= nil then
		tolua.setpeer(self.exist, nil)
	end
	self.exist = nil
	if tolua.getpeer(self.new) ~= nil then
		tolua.setpeer(self.new, nil)
	end
	self.new = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return VipUnlockDesItemView