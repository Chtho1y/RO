---@class UIChipRoom__Generate_btnDecompose
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class UIChipRoom__Generate_btnOneKeyDecompose
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class UIChipRoom__Generate_btnBack
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIChipRoom__Generate_DscNoChip2
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIChipRoom__Generate_decompose_content
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIChipRoom__Generate_decompose
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UIChipRoom__Generate_decompose_content
---@field public noChips UnityEngine.GameObject

---@class UIChipRoom__Generate_toggleGroup
---@field public gameObject UnityEngine.GameObject
---@field public toggleGroup UnityEngine.UI.ToggleGroup

---@class UIChipRoom__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private toggleGroup UIChipRoom__Generate_toggleGroup
---@field private redPoint2 UnityEngine.GameObject
---@field private decompose UIChipRoom__Generate_decompose
---@field private DscNoChip2 UIChipRoom__Generate_DscNoChip2
---@field private btnBack UIChipRoom__Generate_btnBack
---@field private btnOneKeyDecompose UIChipRoom__Generate_btnOneKeyDecompose
---@field private btnDecompose UIChipRoom__Generate_btnDecompose
local UIChipRoomView = class("UIChipRoomView", require("UIViewBase"))

function UIChipRoomView:ctor()
end

---@private
function UIChipRoomView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIChipRoomView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
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
function UIChipRoomView:InitGenerate__1(Root, data)
--[[
	ListRoot/Window/ToggleGroup
--]]
	local tmp = Root:Find("ListRoot/Window/ToggleGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.toggleGroup = tmp

	tmp.toggleGroup = tmp:GetComponent(Enum.TypeInfo.ToggleGroup)
end

---@private
function UIChipRoomView:InitGenerate__2(Root, data)
--[[
	ListRoot/Window/ToggleGroup/Decompose/RedPoint
--]]
	local tmp = Root:Find("ListRoot/Window/ToggleGroup/Decompose/RedPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redPoint2 = tmp
end

---@private
function UIChipRoomView:InitGenerate__3(Root, data)
--[[
	ListRoot/Window/Decompose
--]]
	local tmp = Root:Find("ListRoot/Window/Decompose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.decompose = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIChipRoomView:InitGenerate__4(Root, data)
--[[
	ListRoot/Window/Decompose/Viewport/Content
--]]
	local tmp = Root:Find("ListRoot/Window/Decompose/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.decompose.content = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIChipRoomView:InitGenerate__5(Root, data)
--[[
	ListRoot/Window/Decompose/NoChips
--]]
	local tmp = Root:Find("ListRoot/Window/Decompose/NoChips").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.decompose.noChips = tmp
end

---@private
function UIChipRoomView:InitGenerate__6(Root, data)
--[[
	ListRoot/Window/Decompose/NoChips/DesTxt
--]]
	local tmp = Root:Find("ListRoot/Window/Decompose/NoChips/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.DscNoChip2 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIChipRoomView:InitGenerate__7(Root, data)
--[[
	ListRoot/Window/BtnBack
--]]
	local tmp = Root:Find("ListRoot/Window/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBack = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChipRoomView:InitGenerate__8(Root, data)
--[[
	ListRoot/Window/BtnOneKeyDecompose
--]]
	local tmp = Root:Find("ListRoot/Window/BtnOneKeyDecompose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnOneKeyDecompose = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChipRoomView:InitGenerate__9(Root, data)
--[[
	ListRoot/Window/BtnDecompose
--]]
	local tmp = Root:Find("ListRoot/Window/BtnDecompose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnDecompose = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIChipRoomView:GenerateDestroy()
	if tolua.getpeer(self.decompose.noChips) ~= nil then
		tolua.setpeer(self.decompose.noChips, nil)
	end
	if tolua.getpeer(self.decompose.content) ~= nil then
		tolua.setpeer(self.decompose.content, nil)
	end
	if tolua.getpeer(self.toggleGroup) ~= nil then
		tolua.setpeer(self.toggleGroup, nil)
	end
	self.toggleGroup = nil
	if tolua.getpeer(self.redPoint2) ~= nil then
		tolua.setpeer(self.redPoint2, nil)
	end
	self.redPoint2 = nil
	if tolua.getpeer(self.decompose) ~= nil then
		tolua.setpeer(self.decompose, nil)
	end
	self.decompose = nil
	if tolua.getpeer(self.DscNoChip2) ~= nil then
		tolua.setpeer(self.DscNoChip2, nil)
	end
	self.DscNoChip2 = nil
	if tolua.getpeer(self.btnBack) ~= nil then
		tolua.setpeer(self.btnBack, nil)
	end
	self.btnBack = nil
	if tolua.getpeer(self.btnOneKeyDecompose) ~= nil then
		tolua.setpeer(self.btnOneKeyDecompose, nil)
	end
	self.btnOneKeyDecompose = nil
	if tolua.getpeer(self.btnDecompose) ~= nil then
		tolua.setpeer(self.btnDecompose, nil)
	end
	self.btnDecompose = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIChipRoomView