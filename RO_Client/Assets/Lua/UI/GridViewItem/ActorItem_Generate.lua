---@class ActorItem__Generate_levelText
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class ActorItem__Generate_jobIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ActorItem__Generate_headFrame
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image

---@class ActorItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image

---@class ActorItem__Generate_head
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class ActorItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ActorItem__Generate_shadow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class ActorItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class ActorItem__Generate_name
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ActorItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private name ActorItem__Generate_name
---@field private headItem ActorItem__Generate_headItem
---@field private shadow ActorItem__Generate_shadow
---@field private bg ActorItem__Generate_bg
---@field private head ActorItem__Generate_head
---@field private frame ActorItem__Generate_frame
---@field private headFrame ActorItem__Generate_headFrame
---@field private jobIcon ActorItem__Generate_jobIcon
---@field private levelText ActorItem__Generate_levelText
local ActorItemView = class("ActorItemView")

function ActorItemView:ctor()
end

---@private
function ActorItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ActorItemView:InitGenerate(Root, data)
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
function ActorItemView:InitGenerate__1(Root, data)
--[[
	NameText
--]]
	local tmp = Root:Find("NameText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.name = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ActorItemView:InitGenerate__2(Root, data)
--[[
	HeadItem
--]]
	local tmp = Root:Find("HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem = tmp

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function ActorItemView:InitGenerate__3(Root, data)
--[[
	HeadItem/shadow
--]]
	local tmp = Root:Find("HeadItem/shadow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.shadow = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ActorItemView:InitGenerate__4(Root, data)
--[[
	HeadItem/Bg
--]]
	local tmp = Root:Find("HeadItem/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ActorItemView:InitGenerate__5(Root, data)
--[[
	HeadItem/Head
--]]
	local tmp = Root:Find("HeadItem/Head").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.head = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ActorItemView:InitGenerate__6(Root, data)
--[[
	HeadItem/HeadFrame
--]]
	local tmp = Root:Find("HeadItem/HeadFrame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frame = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ActorItemView:InitGenerate__7(Root, data)
--[[
	HeadItem/Frame
--]]
	local tmp = Root:Find("HeadItem/Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headFrame = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ActorItemView:InitGenerate__8(Root, data)
--[[
	HeadItem/JobIcon
--]]
	local tmp = Root:Find("HeadItem/JobIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.jobIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ActorItemView:InitGenerate__9(Root, data)
--[[
	HeadItem/TextLV
--]]
	local tmp = Root:Find("HeadItem/TextLV").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.levelText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function ActorItemView:GenerateDestroy()
	if tolua.getpeer(self.name) ~= nil then
		tolua.setpeer(self.name, nil)
	end
	self.name = nil
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	self.headItem = nil
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
return ActorItemView