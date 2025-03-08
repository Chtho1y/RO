---@class TaskItemRefresh__Generate_btnNotFinish
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UnityEngine.GameObject

---@class TaskItemRefresh__Generate_overText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TaskItemRefresh__Generate_btnGet
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UnityEngine.GameObject

---@class TaskItemRefresh__Generate_btnGoto
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UnityEngine.GameObject

---@class TaskItemRefresh__Generate_ratio
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TaskItemRefresh__Generate_scrollbar
---@field public gameObject UnityEngine.GameObject
---@field public scrollbar UnityEngine.UI.Scrollbar

---@class TaskItemRefresh__Generate_item_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class TaskItemRefresh__Generate_item_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class TaskItemRefresh__Generate_item
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public icon TaskItemRefresh__Generate_item_icon
---@field public num TaskItemRefresh__Generate_item_num

---@class TaskItemRefresh__Generate_taskName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TaskItemRefresh__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private taskName TaskItemRefresh__Generate_taskName
---@field private item TaskItemRefresh__Generate_item
---@field private scrollbar TaskItemRefresh__Generate_scrollbar
---@field private ratio TaskItemRefresh__Generate_ratio
---@field private btnGoto TaskItemRefresh__Generate_btnGoto
---@field private btnGet TaskItemRefresh__Generate_btnGet
---@field private seal UnityEngine.GameObject
---@field private overText TaskItemRefresh__Generate_overText
---@field private btnNotFinish TaskItemRefresh__Generate_btnNotFinish
local TaskItemRefreshView = class("TaskItemRefreshView")

function TaskItemRefreshView:ctor()
end

---@private
function TaskItemRefreshView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function TaskItemRefreshView:InitGenerate(Root, data)
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


end

---@private
function TaskItemRefreshView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function TaskItemRefreshView:InitGenerate__2(Root, data)
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
function TaskItemRefreshView:InitGenerate__3(Root, data)
--[[
	Item
--]]
	local tmp = Root:Find("Item").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function TaskItemRefreshView:InitGenerate__4(Root, data)
--[[
	Item/Icon
--]]
	local tmp = Root:Find("Item/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function TaskItemRefreshView:InitGenerate__5(Root, data)
--[[
	Item/Num
--]]
	local tmp = Root:Find("Item/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.item.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function TaskItemRefreshView:InitGenerate__6(Root, data)
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
function TaskItemRefreshView:InitGenerate__7(Root, data)
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
function TaskItemRefreshView:InitGenerate__8(Root, data)
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
function TaskItemRefreshView:InitGenerate__9(Root, data)
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
function TaskItemRefreshView:InitGenerate__10(Root, data)
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
function TaskItemRefreshView:InitGenerate__11(Root, data)
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
function TaskItemRefreshView:InitGenerate__12(Root, data)
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
function TaskItemRefreshView:InitGenerate__13(Root, data)
--[[
	Seal/OverText
--]]
	local tmp = Root:Find("Seal/OverText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.overText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function TaskItemRefreshView:InitGenerate__14(Root, data)
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
function TaskItemRefreshView:InitGenerate__15(Root, data)
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
function TaskItemRefreshView:GenerateDestroy()
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
	if tolua.getpeer(self.btnGoto.text) ~= nil then
		tolua.setpeer(self.btnGoto.text, nil)
	end
	if tolua.getpeer(self.btnGoto) ~= nil then
		tolua.setpeer(self.btnGoto, nil)
	end
	if tolua.getpeer(self.ratio) ~= nil then
		tolua.setpeer(self.ratio, nil)
	end
	if tolua.getpeer(self.scrollbar) ~= nil then
		tolua.setpeer(self.scrollbar, nil)
	end
	if tolua.getpeer(self.item.num) ~= nil then
		tolua.setpeer(self.item.num, nil)
	end
	if tolua.getpeer(self.item.icon) ~= nil then
		tolua.setpeer(self.item.icon, nil)
	end
	if tolua.getpeer(self.item) ~= nil then
		tolua.setpeer(self.item, nil)
	end
	if tolua.getpeer(self.taskName) ~= nil then
		tolua.setpeer(self.taskName, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return TaskItemRefreshView