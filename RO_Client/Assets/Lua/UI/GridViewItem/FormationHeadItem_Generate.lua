---@class FormationHeadItem__Generate_btnDown
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class FormationHeadItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class FormationHeadItem__Generate_btnUp
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class FormationHeadItem__Generate_leaderText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class FormationHeadItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private leaderText FormationHeadItem__Generate_leaderText
---@field private btnUp FormationHeadItem__Generate_btnUp
---@field private empty UnityEngine.GameObject
---@field private headItem FormationHeadItem__Generate_headItem
---@field private btnDown FormationHeadItem__Generate_btnDown
local FormationHeadItemView = class("FormationHeadItemView")

function FormationHeadItemView:ctor()
end

---@private
function FormationHeadItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function FormationHeadItemView:InitGenerate(Root, data)
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
function FormationHeadItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function FormationHeadItemView:InitGenerate__2(Root, data)
--[[
	LeaderText
--]]
	local tmp = Root:Find("LeaderText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leaderText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function FormationHeadItemView:InitGenerate__3(Root, data)
--[[
	BtnUp
--]]
	local tmp = Root:Find("BtnUp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnUp = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function FormationHeadItemView:InitGenerate__4(Root, data)
--[[
	Empty
--]]
	local tmp = Root:Find("Empty").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.empty = tmp
end

---@private
function FormationHeadItemView:InitGenerate__5(Root, data)
--[[
	HeadItem
--]]
	local tmp = Root:Find("HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function FormationHeadItemView:InitGenerate__6(Root, data)
--[[
	BtnDown
--]]
	local tmp = Root:Find("BtnDown").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnDown = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function FormationHeadItemView:GenerateDestroy()
	if tolua.getpeer(self.leaderText) ~= nil then
		tolua.setpeer(self.leaderText, nil)
	end
	self.leaderText = nil
	if tolua.getpeer(self.btnUp) ~= nil then
		tolua.setpeer(self.btnUp, nil)
	end
	self.btnUp = nil
	if tolua.getpeer(self.empty) ~= nil then
		tolua.setpeer(self.empty, nil)
	end
	self.empty = nil
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	self.headItem = nil
	if tolua.getpeer(self.btnDown) ~= nil then
		tolua.setpeer(self.btnDown, nil)
	end
	self.btnDown = nil
	self.inited = false
end
return FormationHeadItemView