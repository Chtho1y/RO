---@class TaskItemMain__Generate_btnNotFinish_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class TaskItemMain__Generate_btnNotFinish
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text TaskItemMain__Generate_btnNotFinish_text

---@class TaskItemMain__Generate_item5
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class TaskItemMain__Generate_item4
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class TaskItemMain__Generate_item3
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class TaskItemMain__Generate_item2
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class TaskItemMain__Generate_item1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class TaskItemMain__Generate_btnGoto
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UnityEngine.GameObject

---@class TaskItemMain__Generate_btnGet_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class TaskItemMain__Generate_btnGet
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text TaskItemMain__Generate_btnGet_text

---@class TaskItemMain__Generate_ratio
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TaskItemMain__Generate_scrollbar
---@field public gameObject UnityEngine.GameObject
---@field public scrollbar UnityEngine.UI.Scrollbar

---@class TaskItemMain__Generate_taskName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TaskItemMain__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bgActive UnityEngine.GameObject
---@field private taskName TaskItemMain__Generate_taskName
---@field private scrollbar TaskItemMain__Generate_scrollbar
---@field private ratio TaskItemMain__Generate_ratio
---@field private btnGet TaskItemMain__Generate_btnGet
---@field private btnGoto TaskItemMain__Generate_btnGoto
---@field private item1 TaskItemMain__Generate_item1
---@field private item2 TaskItemMain__Generate_item2
---@field private item3 TaskItemMain__Generate_item3
---@field private item4 TaskItemMain__Generate_item4
---@field private item5 TaskItemMain__Generate_item5
---@field private btnNotFinish TaskItemMain__Generate_btnNotFinish
local TaskItemMainView = class("TaskItemMainView")

function TaskItemMainView:ctor()
end

---@private
function TaskItemMainView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function TaskItemMainView:InitGenerate(Root, data)
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
	self:InitGenerate__14(Root,data)
	self:InitGenerate__15(Root,data)
	self:InitGenerate__16(Root,data)


end

---@private
function TaskItemMainView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function TaskItemMainView:InitGenerate__2(Root, data)
--[[
	BgActive
--]]
	local tmp = Root:Find("BgActive").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bgActive = tmp
end

---@private
function TaskItemMainView:InitGenerate__3(Root, data)
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
function TaskItemMainView:InitGenerate__4(Root, data)
--[[
	Scrollbar
--]]
	local tmp = Root:Find("Scrollbar").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollbar = tmp

	tmp.scrollbar = tmp:GetComponent(Enum.TypeInfo.Scrollbar)
end

---@private
function TaskItemMainView:InitGenerate__5(Root, data)
--[[
	Ratio
--]]
	local tmp = Root:Find("Ratio").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.ratio = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function TaskItemMainView:InitGenerate__6(Root, data)
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
function TaskItemMainView:InitGenerate__7(Root, data)
--[[
	BtnGet/Text
--]]
	local tmp = Root:Find("BtnGet/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnGet.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function TaskItemMainView:InitGenerate__8(Root, data)
--[[
	BtnGoto
--]]
	local tmp = Root:Find("BtnGoto").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnGoto = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function TaskItemMainView:InitGenerate__9(Root, data)
--[[
	BtnGoto/Text
--]]
	local tmp = Root:Find("BtnGoto/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnGoto.text = tmp
end

---@private
function TaskItemMainView:InitGenerate__10(Root, data)
--[[
	IconSmallItem1
--]]
	local tmp = Root:Find("IconSmallItem1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item1 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.item1.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function TaskItemMainView:InitGenerate__11(Root, data)
--[[
	IconSmallItem2
--]]
	local tmp = Root:Find("IconSmallItem2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item2 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.item2.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function TaskItemMainView:InitGenerate__12(Root, data)
--[[
	IconSmallItem3
--]]
	local tmp = Root:Find("IconSmallItem3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item3 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.item3.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function TaskItemMainView:InitGenerate__13(Root, data)
--[[
	IconSmallItem4
--]]
	local tmp = Root:Find("IconSmallItem4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item4 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.item4.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function TaskItemMainView:InitGenerate__14(Root, data)
--[[
	IconSmallItem5
--]]
	local tmp = Root:Find("IconSmallItem5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item5 = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.item5.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function TaskItemMainView:InitGenerate__15(Root, data)
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
function TaskItemMainView:InitGenerate__16(Root, data)
--[[
	BtnNotFinish/Text
--]]
	local tmp = Root:Find("BtnNotFinish/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnNotFinish.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function TaskItemMainView:GenerateDestroy()
	if tolua.getpeer(self.btnNotFinish.text) ~= nil then
		tolua.setpeer(self.btnNotFinish.text, nil)
	end
	if tolua.getpeer(self.btnNotFinish) ~= nil then
		tolua.setpeer(self.btnNotFinish, nil)
	end
	if self.item5.GenerateDestroy ~= nil then
		self.item5:GenerateDestroy()
	end
	if tolua.getpeer(self.item5) ~= nil then
		tolua.setpeer(self.item5, nil)
	end
	if self.item4.GenerateDestroy ~= nil then
		self.item4:GenerateDestroy()
	end
	if tolua.getpeer(self.item4) ~= nil then
		tolua.setpeer(self.item4, nil)
	end
	if self.item3.GenerateDestroy ~= nil then
		self.item3:GenerateDestroy()
	end
	if tolua.getpeer(self.item3) ~= nil then
		tolua.setpeer(self.item3, nil)
	end
	if self.item2.GenerateDestroy ~= nil then
		self.item2:GenerateDestroy()
	end
	if tolua.getpeer(self.item2) ~= nil then
		tolua.setpeer(self.item2, nil)
	end
	if self.item1.GenerateDestroy ~= nil then
		self.item1:GenerateDestroy()
	end
	if tolua.getpeer(self.item1) ~= nil then
		tolua.setpeer(self.item1, nil)
	end
	if tolua.getpeer(self.btnGoto.text) ~= nil then
		tolua.setpeer(self.btnGoto.text, nil)
	end
	if tolua.getpeer(self.btnGet.text) ~= nil then
		tolua.setpeer(self.btnGet.text, nil)
	end
	if tolua.getpeer(self.btnGet) ~= nil then
		tolua.setpeer(self.btnGet, nil)
	end
	if tolua.getpeer(self.ratio) ~= nil then
		tolua.setpeer(self.ratio, nil)
	end
	if tolua.getpeer(self.scrollbar) ~= nil then
		tolua.setpeer(self.scrollbar, nil)
	end
	if tolua.getpeer(self.taskName) ~= nil then
		tolua.setpeer(self.taskName, nil)
	end
	if tolua.getpeer(self.bgActive) ~= nil then
		tolua.setpeer(self.bgActive, nil)
	end
	if tolua.getpeer(self.btnGoto) ~= nil then
		tolua.setpeer(self.btnGoto, nil)
	end
	self.btnGoto = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return TaskItemMainView