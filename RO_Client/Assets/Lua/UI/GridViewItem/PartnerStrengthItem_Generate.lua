---@class PartnerStrengthItem__Generate_addAttr3_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class PartnerStrengthItem__Generate_addAttr3_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class PartnerStrengthItem__Generate_addAttr3
---@field public gameObject UnityEngine.GameObject
---@field public text PartnerStrengthItem__Generate_addAttr3_text
---@field public number PartnerStrengthItem__Generate_addAttr3_number

---@class PartnerStrengthItem__Generate_addAttr2_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class PartnerStrengthItem__Generate_addAttr2_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class PartnerStrengthItem__Generate_addAttr2
---@field public gameObject UnityEngine.GameObject
---@field public text PartnerStrengthItem__Generate_addAttr2_text
---@field public number PartnerStrengthItem__Generate_addAttr2_number

---@class PartnerStrengthItem__Generate_addAttr1_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class PartnerStrengthItem__Generate_addAttr1_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text
---@field public uILocalizeScript UILocalizeScript

---@class PartnerStrengthItem__Generate_addAttr1
---@field public gameObject UnityEngine.GameObject
---@field public text PartnerStrengthItem__Generate_addAttr1_text
---@field public number PartnerStrengthItem__Generate_addAttr1_number

---@class PartnerStrengthItem__Generate_title
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class PartnerStrengthItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private animator UnityEngine.Animator
---@field private uIEffectCfg UIEffectCfg
---@field private mark UnityEngine.GameObject
---@field private lock UnityEngine.GameObject
---@field private title PartnerStrengthItem__Generate_title
---@field private addAttr1 PartnerStrengthItem__Generate_addAttr1
---@field private addAttr2 PartnerStrengthItem__Generate_addAttr2
---@field private addAttr3 PartnerStrengthItem__Generate_addAttr3
---@field private fxNode UnityEngine.GameObject
local PartnerStrengthItemView = class("PartnerStrengthItemView")

function PartnerStrengthItemView:ctor()
end

---@private
function PartnerStrengthItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function PartnerStrengthItemView:InitGenerate(Root, data)
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


end

---@private
function PartnerStrengthItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.animator = Root:GetComponent(Enum.TypeInfo.Animator)
	self.animator.logWarnings = false

	self.uIEffectCfg = Root:GetComponent(Enum.TypeInfo.UIEffectCfg)
end

---@private
function PartnerStrengthItemView:InitGenerate__2(Root, data)
--[[
	Mark
--]]
	local tmp = Root:Find("Mark").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mark = tmp
end

---@private
function PartnerStrengthItemView:InitGenerate__3(Root, data)
--[[
	Title/lock
--]]
	local tmp = Root:Find("Title/lock").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lock = tmp
end

---@private
function PartnerStrengthItemView:InitGenerate__4(Root, data)
--[[
	Title/Text
--]]
	local tmp = Root:Find("Title/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.title = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function PartnerStrengthItemView:InitGenerate__5(Root, data)
--[[
	AddAttr1
--]]
	local tmp = Root:Find("AddAttr1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addAttr1 = tmp
end

---@private
function PartnerStrengthItemView:InitGenerate__6(Root, data)
--[[
	AddAttr1/Text
--]]
	local tmp = Root:Find("AddAttr1/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addAttr1.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function PartnerStrengthItemView:InitGenerate__7(Root, data)
--[[
	AddAttr1/Number
--]]
	local tmp = Root:Find("AddAttr1/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addAttr1.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function PartnerStrengthItemView:InitGenerate__8(Root, data)
--[[
	AddAttr2
--]]
	local tmp = Root:Find("AddAttr2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addAttr2 = tmp
end

---@private
function PartnerStrengthItemView:InitGenerate__9(Root, data)
--[[
	AddAttr2/Text
--]]
	local tmp = Root:Find("AddAttr2/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addAttr2.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function PartnerStrengthItemView:InitGenerate__10(Root, data)
--[[
	AddAttr2/Number
--]]
	local tmp = Root:Find("AddAttr2/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addAttr2.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function PartnerStrengthItemView:InitGenerate__11(Root, data)
--[[
	AddAttr3
--]]
	local tmp = Root:Find("AddAttr3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addAttr3 = tmp
end

---@private
function PartnerStrengthItemView:InitGenerate__12(Root, data)
--[[
	AddAttr3/Text
--]]
	local tmp = Root:Find("AddAttr3/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addAttr3.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function PartnerStrengthItemView:InitGenerate__13(Root, data)
--[[
	AddAttr3/Number
--]]
	local tmp = Root:Find("AddAttr3/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addAttr3.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function PartnerStrengthItemView:InitGenerate__14(Root, data)
--[[
	FxNode
--]]
	local tmp = Root:Find("FxNode").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fxNode = tmp
end

---@private
function PartnerStrengthItemView:GenerateDestroy()
	if tolua.getpeer(self.addAttr3.number) ~= nil then
		tolua.setpeer(self.addAttr3.number, nil)
	end
	if tolua.getpeer(self.addAttr3.text) ~= nil then
		tolua.setpeer(self.addAttr3.text, nil)
	end
	if tolua.getpeer(self.addAttr2.number) ~= nil then
		tolua.setpeer(self.addAttr2.number, nil)
	end
	if tolua.getpeer(self.addAttr2.text) ~= nil then
		tolua.setpeer(self.addAttr2.text, nil)
	end
	if tolua.getpeer(self.addAttr1.number) ~= nil then
		tolua.setpeer(self.addAttr1.number, nil)
	end
	if tolua.getpeer(self.addAttr1.text) ~= nil then
		tolua.setpeer(self.addAttr1.text, nil)
	end
	if tolua.getpeer(self.mark) ~= nil then
		tolua.setpeer(self.mark, nil)
	end
	self.mark = nil
	if tolua.getpeer(self.lock) ~= nil then
		tolua.setpeer(self.lock, nil)
	end
	self.lock = nil
	if tolua.getpeer(self.title) ~= nil then
		tolua.setpeer(self.title, nil)
	end
	self.title = nil
	if tolua.getpeer(self.addAttr1) ~= nil then
		tolua.setpeer(self.addAttr1, nil)
	end
	self.addAttr1 = nil
	if tolua.getpeer(self.addAttr2) ~= nil then
		tolua.setpeer(self.addAttr2, nil)
	end
	self.addAttr2 = nil
	if tolua.getpeer(self.addAttr3) ~= nil then
		tolua.setpeer(self.addAttr3, nil)
	end
	self.addAttr3 = nil
	if tolua.getpeer(self.fxNode) ~= nil then
		tolua.setpeer(self.fxNode, nil)
	end
	self.fxNode = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return PartnerStrengthItemView