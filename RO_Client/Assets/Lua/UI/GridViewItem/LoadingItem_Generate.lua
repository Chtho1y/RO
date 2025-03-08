---@class LoadingItem__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class LoadingItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private layoutElement UnityEngine.UI.LayoutElement
---@field private root UnityEngine.GameObject
---@field private desTxt LoadingItem__Generate_desTxt
---@field private wait UnityEngine.GameObject
local LoadingItemView = class("LoadingItemView")

function LoadingItemView:ctor()
end

---@private
function LoadingItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function LoadingItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function LoadingItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)

	self.layoutElement = Root:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function LoadingItemView:InitGenerate__2(Root, data)
--[[
	Root
--]]
	local tmp = Root:Find("Root").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.root = tmp
end

---@private
function LoadingItemView:InitGenerate__3(Root, data)
--[[
	Root/DesTxt
--]]
	local tmp = Root:Find("Root/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function LoadingItemView:InitGenerate__4(Root, data)
--[[
	Root/DesTxt/Wait
--]]
	local tmp = Root:Find("Root/DesTxt/Wait").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.wait = tmp
end

---@private
function LoadingItemView:GenerateDestroy()
	if tolua.getpeer(self.root) ~= nil then
		tolua.setpeer(self.root, nil)
	end
	self.root = nil
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	if tolua.getpeer(self.wait) ~= nil then
		tolua.setpeer(self.wait, nil)
	end
	self.wait = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return LoadingItemView