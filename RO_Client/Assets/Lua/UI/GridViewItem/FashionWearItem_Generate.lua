---@class FashionWearItem__Generate_fashionName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class FashionWearItem__Generate_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class FashionWearItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class FashionWearItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class FashionWearItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class FashionWearItem__Generate_group
---@field public gameObject UnityEngine.GameObject
---@field public canvasGroup UnityEngine.CanvasGroup

---@class FashionWearItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private group FashionWearItem__Generate_group
---@field private bg FashionWearItem__Generate_bg
---@field private icon FashionWearItem__Generate_icon
---@field private frame FashionWearItem__Generate_frame
---@field private selected UnityEngine.GameObject
---@field private disable UnityEngine.GameObject
---@field private image UnityEngine.GameObject
---@field private selected2 UnityEngine.GameObject
---@field private redPoint UnityEngine.GameObject
---@field private num FashionWearItem__Generate_num
---@field private nameBox UnityEngine.GameObject
---@field private fashionName FashionWearItem__Generate_fashionName
local FashionWearItemView = class("FashionWearItemView")

function FashionWearItemView:ctor()
end

---@private
function FashionWearItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function FashionWearItemView:InitGenerate(Root, data)
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


end

---@private
function FashionWearItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function FashionWearItemView:InitGenerate__2(Root, data)
--[[
	Group
--]]
	local tmp = Root:Find("Group").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.group = tmp

	tmp.canvasGroup = tmp:GetComponent(Enum.TypeInfo.CanvasGroup)
end

---@private
function FashionWearItemView:InitGenerate__3(Root, data)
--[[
	Group/Bg
--]]
	local tmp = Root:Find("Group/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function FashionWearItemView:InitGenerate__4(Root, data)
--[[
	Group/Icon
--]]
	local tmp = Root:Find("Group/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function FashionWearItemView:InitGenerate__5(Root, data)
--[[
	Group/Frame
--]]
	local tmp = Root:Find("Group/Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frame = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function FashionWearItemView:InitGenerate__6(Root, data)
--[[
	Selected
--]]
	local tmp = Root:Find("Selected").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selected = tmp
end

---@private
function FashionWearItemView:InitGenerate__7(Root, data)
--[[
	Disable
--]]
	local tmp = Root:Find("Disable").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.disable = tmp
end

---@private
function FashionWearItemView:InitGenerate__8(Root, data)
--[[
	Disable/image
--]]
	local tmp = Root:Find("Disable/image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.image = tmp
end

---@private
function FashionWearItemView:InitGenerate__9(Root, data)
--[[
	Selected2
--]]
	local tmp = Root:Find("Selected2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selected2 = tmp
end

---@private
function FashionWearItemView:InitGenerate__10(Root, data)
--[[
	UIRedPointRP
--]]
	local tmp = Root:Find("UIRedPointRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redPoint = tmp
end

---@private
function FashionWearItemView:InitGenerate__11(Root, data)
--[[
	Num
--]]
	local tmp = Root:Find("Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function FashionWearItemView:InitGenerate__12(Root, data)
--[[
	NameBox
--]]
	local tmp = Root:Find("NameBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameBox = tmp
end

---@private
function FashionWearItemView:InitGenerate__13(Root, data)
--[[
	NameBox/fashionName
--]]
	local tmp = Root:Find("NameBox/fashionName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fashionName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function FashionWearItemView:GenerateDestroy()
	if tolua.getpeer(self.fashionName) ~= nil then
		tolua.setpeer(self.fashionName, nil)
	end
	if tolua.getpeer(self.nameBox) ~= nil then
		tolua.setpeer(self.nameBox, nil)
	end
	if tolua.getpeer(self.group) ~= nil then
		tolua.setpeer(self.group, nil)
	end
	self.group = nil
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
	if tolua.getpeer(self.selected) ~= nil then
		tolua.setpeer(self.selected, nil)
	end
	self.selected = nil
	if tolua.getpeer(self.disable) ~= nil then
		tolua.setpeer(self.disable, nil)
	end
	self.disable = nil
	if tolua.getpeer(self.image) ~= nil then
		tolua.setpeer(self.image, nil)
	end
	self.image = nil
	if tolua.getpeer(self.selected2) ~= nil then
		tolua.setpeer(self.selected2, nil)
	end
	self.selected2 = nil
	if tolua.getpeer(self.redPoint) ~= nil then
		tolua.setpeer(self.redPoint, nil)
	end
	self.redPoint = nil
	if tolua.getpeer(self.num) ~= nil then
		tolua.setpeer(self.num, nil)
	end
	self.num = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return FashionWearItemView