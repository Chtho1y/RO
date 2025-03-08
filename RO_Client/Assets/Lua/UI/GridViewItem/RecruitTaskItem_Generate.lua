---@class RecruitTaskItem__Generate_btnNotFinish
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UnityEngine.GameObject

---@class RecruitTaskItem__Generate_overText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RecruitTaskItem__Generate_btnGet
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UnityEngine.GameObject

---@class RecruitTaskItem__Generate_count
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RecruitTaskItem__Generate_dsc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RecruitTaskItem__Generate_taskName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class RecruitTaskItem__Generate_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class RecruitTaskItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private iconSmallItem RecruitTaskItem__Generate_iconSmallItem
---@field private taskName RecruitTaskItem__Generate_taskName
---@field private dsc RecruitTaskItem__Generate_dsc
---@field private count RecruitTaskItem__Generate_count
---@field private btnGet RecruitTaskItem__Generate_btnGet
---@field private seal UnityEngine.GameObject
---@field private overText RecruitTaskItem__Generate_overText
---@field private btnNotFinish RecruitTaskItem__Generate_btnNotFinish
local RecruitTaskItemView = class("RecruitTaskItemView")

function RecruitTaskItemView:ctor()
end

---@private
function RecruitTaskItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RecruitTaskItemView:InitGenerate(Root, data)
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


end

---@private
function RecruitTaskItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function RecruitTaskItemView:InitGenerate__2(Root, data)
--[[
	IconSmallItem
--]]
	local tmp = Root:Find("IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function RecruitTaskItemView:InitGenerate__3(Root, data)
--[[
	TaskName
--]]
	local tmp = Root:Find("TaskName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.taskName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RecruitTaskItemView:InitGenerate__4(Root, data)
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
function RecruitTaskItemView:InitGenerate__5(Root, data)
--[[
	Count
--]]
	local tmp = Root:Find("Count").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.count = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RecruitTaskItemView:InitGenerate__6(Root, data)
--[[
	BtnGet
--]]
	local tmp = Root:Find("BtnGet").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnGet = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function RecruitTaskItemView:InitGenerate__7(Root, data)
--[[
	BtnGet/Text
--]]
	local tmp = Root:Find("BtnGet/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnGet.text = tmp
end

---@private
function RecruitTaskItemView:InitGenerate__8(Root, data)
--[[
	Seal
--]]
	local tmp = Root:Find("Seal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.seal = tmp
end

---@private
function RecruitTaskItemView:InitGenerate__9(Root, data)
--[[
	Seal/LabelSeal/OverText
--]]
	local tmp = Root:Find("Seal/LabelSeal/OverText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.overText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function RecruitTaskItemView:InitGenerate__10(Root, data)
--[[
	BtnNotFinish
--]]
	local tmp = Root:Find("BtnNotFinish").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnNotFinish = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function RecruitTaskItemView:InitGenerate__11(Root, data)
--[[
	BtnNotFinish/Text
--]]
	local tmp = Root:Find("BtnNotFinish/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnNotFinish.text = tmp
end

---@private
function RecruitTaskItemView:GenerateDestroy()
	if tolua.getpeer(self.btnNotFinish.text) ~= nil then
		tolua.setpeer(self.btnNotFinish.text, nil)
	end
	if tolua.getpeer(self.btnNotFinish) ~= nil then
		tolua.setpeer(self.btnNotFinish, nil)
	end
	if tolua.getpeer(self.overText) ~= nil then
		tolua.setpeer(self.overText, nil)
	end
	if tolua.getpeer(self.seal) ~= nil then
		tolua.setpeer(self.seal, nil)
	end
	if tolua.getpeer(self.btnGet.text) ~= nil then
		tolua.setpeer(self.btnGet.text, nil)
	end
	if tolua.getpeer(self.btnGet) ~= nil then
		tolua.setpeer(self.btnGet, nil)
	end
	if tolua.getpeer(self.count) ~= nil then
		tolua.setpeer(self.count, nil)
	end
	if tolua.getpeer(self.dsc) ~= nil then
		tolua.setpeer(self.dsc, nil)
	end
	if tolua.getpeer(self.taskName) ~= nil then
		tolua.setpeer(self.taskName, nil)
	end
	if self.iconSmallItem.GenerateDestroy ~= nil then
		self.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconSmallItem) ~= nil then
		tolua.setpeer(self.iconSmallItem, nil)
	end
	self.iconSmallItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RecruitTaskItemView