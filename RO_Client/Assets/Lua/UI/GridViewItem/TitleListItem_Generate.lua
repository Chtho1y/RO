---@class TitleListItem__Generate_PropertyText2
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TitleListItem__Generate_property2
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TitleListItem__Generate_PropertyText1
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TitleListItem__Generate_property1
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TitleListItem__Generate_btnRemove
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class TitleListItem__Generate_btnActive
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class TitleListItem__Generate_btnEquip
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class TitleListItem__Generate_target
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TitleListItem__Generate_taskDsc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TitleListItem__Generate_timeLimit
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class TitleListItem__Generate_titleImg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class TitleListItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private titleImg TitleListItem__Generate_titleImg
---@field private timeLimit TitleListItem__Generate_timeLimit
---@field private taskDsc TitleListItem__Generate_taskDsc
---@field private target TitleListItem__Generate_target
---@field private btnEquip TitleListItem__Generate_btnEquip
---@field private btnActive TitleListItem__Generate_btnActive
---@field private btnRemove TitleListItem__Generate_btnRemove
---@field private property1 TitleListItem__Generate_property1
---@field private PropertyText1 TitleListItem__Generate_PropertyText1
---@field private property2 TitleListItem__Generate_property2
---@field private PropertyText2 TitleListItem__Generate_PropertyText2
---@field private mask UnityEngine.GameObject
---@field private equipLight UnityEngine.GameObject
local TitleListItemView = class("TitleListItemView")

function TitleListItemView:ctor()
end

---@private
function TitleListItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function TitleListItemView:InitGenerate(Root, data)
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
function TitleListItemView:InitGenerate__1(Root, data)
--[[
	TitleImg
--]]
	local tmp = Root:Find("TitleImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.titleImg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function TitleListItemView:InitGenerate__2(Root, data)
--[[
	TimeLimit
--]]
	local tmp = Root:Find("TimeLimit").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timeLimit = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function TitleListItemView:InitGenerate__3(Root, data)
--[[
	TaskDsc
--]]
	local tmp = Root:Find("TaskDsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.taskDsc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function TitleListItemView:InitGenerate__4(Root, data)
--[[
	Target
--]]
	local tmp = Root:Find("Target").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.target = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function TitleListItemView:InitGenerate__5(Root, data)
--[[
	BtnEquip
--]]
	local tmp = Root:Find("BtnEquip").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnEquip = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function TitleListItemView:InitGenerate__6(Root, data)
--[[
	BtnActive
--]]
	local tmp = Root:Find("BtnActive").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnActive = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function TitleListItemView:InitGenerate__7(Root, data)
--[[
	BtnRemove
--]]
	local tmp = Root:Find("BtnRemove").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRemove = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function TitleListItemView:InitGenerate__8(Root, data)
--[[
	Property1
--]]
	local tmp = Root:Find("Property1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property1 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function TitleListItemView:InitGenerate__9(Root, data)
--[[
	Property1/Text
--]]
	local tmp = Root:Find("Property1/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.PropertyText1 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function TitleListItemView:InitGenerate__10(Root, data)
--[[
	Property2
--]]
	local tmp = Root:Find("Property2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.property2 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function TitleListItemView:InitGenerate__11(Root, data)
--[[
	Property2/Text
--]]
	local tmp = Root:Find("Property2/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.PropertyText2 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function TitleListItemView:InitGenerate__12(Root, data)
--[[
	Mask
--]]
	local tmp = Root:Find("Mask").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mask = tmp
end

---@private
function TitleListItemView:InitGenerate__13(Root, data)
--[[
	EquipLight
--]]
	local tmp = Root:Find("EquipLight").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipLight = tmp
end

---@private
function TitleListItemView:GenerateDestroy()
	if tolua.getpeer(self.titleImg) ~= nil then
		tolua.setpeer(self.titleImg, nil)
	end
	self.titleImg = nil
	if tolua.getpeer(self.timeLimit) ~= nil then
		tolua.setpeer(self.timeLimit, nil)
	end
	self.timeLimit = nil
	if tolua.getpeer(self.taskDsc) ~= nil then
		tolua.setpeer(self.taskDsc, nil)
	end
	self.taskDsc = nil
	if tolua.getpeer(self.target) ~= nil then
		tolua.setpeer(self.target, nil)
	end
	self.target = nil
	if tolua.getpeer(self.btnEquip) ~= nil then
		tolua.setpeer(self.btnEquip, nil)
	end
	self.btnEquip = nil
	if tolua.getpeer(self.btnActive) ~= nil then
		tolua.setpeer(self.btnActive, nil)
	end
	self.btnActive = nil
	if tolua.getpeer(self.btnRemove) ~= nil then
		tolua.setpeer(self.btnRemove, nil)
	end
	self.btnRemove = nil
	if tolua.getpeer(self.property1) ~= nil then
		tolua.setpeer(self.property1, nil)
	end
	self.property1 = nil
	if tolua.getpeer(self.PropertyText1) ~= nil then
		tolua.setpeer(self.PropertyText1, nil)
	end
	self.PropertyText1 = nil
	if tolua.getpeer(self.property2) ~= nil then
		tolua.setpeer(self.property2, nil)
	end
	self.property2 = nil
	if tolua.getpeer(self.PropertyText2) ~= nil then
		tolua.setpeer(self.PropertyText2, nil)
	end
	self.PropertyText2 = nil
	if tolua.getpeer(self.mask) ~= nil then
		tolua.setpeer(self.mask, nil)
	end
	self.mask = nil
	if tolua.getpeer(self.equipLight) ~= nil then
		tolua.setpeer(self.equipLight, nil)
	end
	self.equipLight = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return TitleListItemView