---@class HeadItem__Generate_levelText
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class HeadItem__Generate_jobIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class HeadItem__Generate_headFrame
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image

---@class HeadItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image

---@class HeadItem__Generate_head
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class HeadItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class HeadItem__Generate_shadow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class HeadItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private layoutElement UnityEngine.UI.LayoutElement
---@field private shadow HeadItem__Generate_shadow
---@field private bg HeadItem__Generate_bg
---@field private head HeadItem__Generate_head
---@field private frame HeadItem__Generate_frame
---@field private headFrame HeadItem__Generate_headFrame
---@field private jobIcon HeadItem__Generate_jobIcon
---@field private levelText HeadItem__Generate_levelText
local HeadItemView = class("HeadItemView")

function HeadItemView:ctor()
end

---@private
function HeadItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function HeadItemView:InitGenerate(Root, data)
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
function HeadItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.layoutElement = Root:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function HeadItemView:InitGenerate__2(Root, data)
--[[
	shadow
--]]
	local tmp = Root:Find("shadow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.shadow = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function HeadItemView:InitGenerate__3(Root, data)
--[[
	Bg
--]]
	local tmp = Root:Find("Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function HeadItemView:InitGenerate__4(Root, data)
--[[
	Head
--]]
	local tmp = Root:Find("Head").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.head = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function HeadItemView:InitGenerate__5(Root, data)
--[[
	HeadFrame
--]]
	local tmp = Root:Find("HeadFrame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frame = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function HeadItemView:InitGenerate__6(Root, data)
--[[
	Frame
--]]
	local tmp = Root:Find("Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headFrame = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function HeadItemView:InitGenerate__7(Root, data)
--[[
	JobIcon
--]]
	local tmp = Root:Find("JobIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.jobIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function HeadItemView:InitGenerate__8(Root, data)
--[[
	TextLV
--]]
	local tmp = Root:Find("TextLV").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.levelText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function HeadItemView:GenerateDestroy()
	if tolua.getpeer(self.shadow) ~= nil then
		tolua.setpeer(self.shadow, nil)
	end
	self.shadow = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.head) ~= nil then
		tolua.setpeer(self.head, nil)
	end
	self.head = nil
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	self.frame = nil
	if tolua.getpeer(self.headFrame) ~= nil then
		tolua.setpeer(self.headFrame, nil)
	end
	self.headFrame = nil
	if tolua.getpeer(self.jobIcon) ~= nil then
		tolua.setpeer(self.jobIcon, nil)
	end
	self.jobIcon = nil
	if tolua.getpeer(self.levelText) ~= nil then
		tolua.setpeer(self.levelText, nil)
	end
	self.levelText = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return HeadItemView