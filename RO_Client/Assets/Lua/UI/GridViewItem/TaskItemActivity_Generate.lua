---@class TaskItemActivity__Generate_getBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UnityEngine.GameObject

---@class TaskItemActivity__Generate_gotoBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UnityEngine.GameObject

---@class TaskItemActivity__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class TaskItemActivity__Generate_rewardsNode
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class TaskItemActivity__Generate_doNumTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TaskItemActivity__Generate_progress
---@field public gameObject UnityEngine.GameObject
---@field public scrollbar UnityEngine.UI.Scrollbar

---@class TaskItemActivity__Generate_taskName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TaskItemActivity__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private taskName TaskItemActivity__Generate_taskName
---@field private progress TaskItemActivity__Generate_progress
---@field private doNumTxt TaskItemActivity__Generate_doNumTxt
---@field private rewardsNode TaskItemActivity__Generate_rewardsNode
---@field private iconItem TaskItemActivity__Generate_iconItem
---@field private gotoBtn TaskItemActivity__Generate_gotoBtn
---@field private getBtn TaskItemActivity__Generate_getBtn
---@field private sealBtn UnityEngine.GameObject
---@field private endBtn UnityEngine.GameObject
local TaskItemActivityView = class("TaskItemActivityView")

function TaskItemActivityView:ctor()
end

---@private
function TaskItemActivityView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function TaskItemActivityView:InitGenerate(Root, data)
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


end

---@private
function TaskItemActivityView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function TaskItemActivityView:InitGenerate__2(Root, data)
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
function TaskItemActivityView:InitGenerate__3(Root, data)
--[[
	Scrollbar
--]]
	local tmp = Root:Find("Scrollbar").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.progress = tmp

	tmp.scrollbar = tmp:GetComponent(Enum.TypeInfo.Scrollbar)
end

---@private
function TaskItemActivityView:InitGenerate__4(Root, data)
--[[
	Ratio
--]]
	local tmp = Root:Find("Ratio").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.doNumTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function TaskItemActivityView:InitGenerate__5(Root, data)
--[[
	Reward
--]]
	local tmp = Root:Find("Reward").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardsNode = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function TaskItemActivityView:InitGenerate__6(Root, data)
--[[
	Reward/IconItem
--]]
	local tmp = Root:Find("Reward/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function TaskItemActivityView:InitGenerate__7(Root, data)
--[[
	BtnGoto
--]]
	local tmp = Root:Find("BtnGoto").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.gotoBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function TaskItemActivityView:InitGenerate__8(Root, data)
--[[
	BtnGoto/Text
--]]
	local tmp = Root:Find("BtnGoto/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.gotoBtn.text = tmp
end

---@private
function TaskItemActivityView:InitGenerate__9(Root, data)
--[[
	BtnGet
--]]
	local tmp = Root:Find("BtnGet").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.getBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function TaskItemActivityView:InitGenerate__10(Root, data)
--[[
	BtnGet/Text
--]]
	local tmp = Root:Find("BtnGet/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.getBtn.text = tmp
end

---@private
function TaskItemActivityView:InitGenerate__11(Root, data)
--[[
	Seal
--]]
	local tmp = Root:Find("Seal").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.sealBtn = tmp
end

---@private
function TaskItemActivityView:InitGenerate__12(Root, data)
--[[
	End
--]]
	local tmp = Root:Find("End").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.endBtn = tmp
end

---@private
function TaskItemActivityView:GenerateDestroy()
	if tolua.getpeer(self.endBtn) ~= nil then
		tolua.setpeer(self.endBtn, nil)
	end
	if tolua.getpeer(self.sealBtn) ~= nil then
		tolua.setpeer(self.sealBtn, nil)
	end
	if tolua.getpeer(self.getBtn.text) ~= nil then
		tolua.setpeer(self.getBtn.text, nil)
	end
	if tolua.getpeer(self.getBtn) ~= nil then
		tolua.setpeer(self.getBtn, nil)
	end
	if tolua.getpeer(self.gotoBtn.text) ~= nil then
		tolua.setpeer(self.gotoBtn.text, nil)
	end
	if tolua.getpeer(self.gotoBtn) ~= nil then
		tolua.setpeer(self.gotoBtn, nil)
	end
	if tolua.getpeer(self.doNumTxt) ~= nil then
		tolua.setpeer(self.doNumTxt, nil)
	end
	if tolua.getpeer(self.progress) ~= nil then
		tolua.setpeer(self.progress, nil)
	end
	if tolua.getpeer(self.taskName) ~= nil then
		tolua.setpeer(self.taskName, nil)
	end
	if tolua.getpeer(self.rewardsNode) ~= nil then
		tolua.setpeer(self.rewardsNode, nil)
	end
	self.rewardsNode = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return TaskItemActivityView