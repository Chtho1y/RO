---@class RedPointItem__Generate_recommend
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RedPointItem__Generate_new
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RedPointItem__Generate_refine
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RedPointItem__Generate_skillTree
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RedPointItem__Generate_lvUp
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RedPointItem__Generate_equipment
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class RedPointItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private bg UnityEngine.GameObject
---@field private equipment RedPointItem__Generate_equipment
---@field private lvUp RedPointItem__Generate_lvUp
---@field private skillTree RedPointItem__Generate_skillTree
---@field private refine RedPointItem__Generate_refine
---@field private redPoint UnityEngine.GameObject
---@field private new RedPointItem__Generate_new
---@field private card UnityEngine.GameObject
---@field private hart UnityEngine.GameObject
---@field private recommend RedPointItem__Generate_recommend
---@field private cardOpen UnityEngine.GameObject
local RedPointItemView = class("RedPointItemView")

function RedPointItemView:ctor()
end

---@private
function RedPointItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function RedPointItemView:InitGenerate(Root, data)
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
function RedPointItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function RedPointItemView:InitGenerate__2(Root, data)
--[[
	RedPoint/Bg
--]]
	local tmp = Root:Find("RedPoint/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp
end

---@private
function RedPointItemView:InitGenerate__3(Root, data)
--[[
	RedPoint/Equipment
--]]
	local tmp = Root:Find("RedPoint/Equipment").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.equipment = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RedPointItemView:InitGenerate__4(Root, data)
--[[
	RedPoint/LvUp
--]]
	local tmp = Root:Find("RedPoint/LvUp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lvUp = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RedPointItemView:InitGenerate__5(Root, data)
--[[
	RedPoint/SkillTree
--]]
	local tmp = Root:Find("RedPoint/SkillTree").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillTree = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RedPointItemView:InitGenerate__6(Root, data)
--[[
	RedPoint/Refine
--]]
	local tmp = Root:Find("RedPoint/Refine").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refine = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RedPointItemView:InitGenerate__7(Root, data)
--[[
	RedPoint/RedPoint
--]]
	local tmp = Root:Find("RedPoint/RedPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redPoint = tmp
end

---@private
function RedPointItemView:InitGenerate__8(Root, data)
--[[
	RedPoint/New
--]]
	local tmp = Root:Find("RedPoint/New").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.new = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RedPointItemView:InitGenerate__9(Root, data)
--[[
	RedPoint/Card
--]]
	local tmp = Root:Find("RedPoint/Card").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.card = tmp
end

---@private
function RedPointItemView:InitGenerate__10(Root, data)
--[[
	RedPoint/Hart
--]]
	local tmp = Root:Find("RedPoint/Hart").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hart = tmp
end

---@private
function RedPointItemView:InitGenerate__11(Root, data)
--[[
	RedPoint/Recommend
--]]
	local tmp = Root:Find("RedPoint/Recommend").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.recommend = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function RedPointItemView:InitGenerate__12(Root, data)
--[[
	RedPoint/CardOpen
--]]
	local tmp = Root:Find("RedPoint/CardOpen").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardOpen = tmp
end

---@private
function RedPointItemView:GenerateDestroy()
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.equipment) ~= nil then
		tolua.setpeer(self.equipment, nil)
	end
	self.equipment = nil
	if tolua.getpeer(self.lvUp) ~= nil then
		tolua.setpeer(self.lvUp, nil)
	end
	self.lvUp = nil
	if tolua.getpeer(self.skillTree) ~= nil then
		tolua.setpeer(self.skillTree, nil)
	end
	self.skillTree = nil
	if tolua.getpeer(self.refine) ~= nil then
		tolua.setpeer(self.refine, nil)
	end
	self.refine = nil
	if tolua.getpeer(self.redPoint) ~= nil then
		tolua.setpeer(self.redPoint, nil)
	end
	self.redPoint = nil
	if tolua.getpeer(self.new) ~= nil then
		tolua.setpeer(self.new, nil)
	end
	self.new = nil
	if tolua.getpeer(self.card) ~= nil then
		tolua.setpeer(self.card, nil)
	end
	self.card = nil
	if tolua.getpeer(self.hart) ~= nil then
		tolua.setpeer(self.hart, nil)
	end
	self.hart = nil
	if tolua.getpeer(self.recommend) ~= nil then
		tolua.setpeer(self.recommend, nil)
	end
	self.recommend = nil
	if tolua.getpeer(self.cardOpen) ~= nil then
		tolua.setpeer(self.cardOpen, nil)
	end
	self.cardOpen = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return RedPointItemView