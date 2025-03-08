---@class ArtifactPropertyItem__Generate_btnActivation
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class ArtifactPropertyItem__Generate_dsc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ArtifactPropertyItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private star UnityEngine.GameObject
---@field private dsc ArtifactPropertyItem__Generate_dsc
---@field private btnActivation ArtifactPropertyItem__Generate_btnActivation
---@field private rp UnityEngine.GameObject
---@field private bg UnityEngine.GameObject
---@field private hart UnityEngine.GameObject
local ArtifactPropertyItemView = class("ArtifactPropertyItemView")

function ArtifactPropertyItemView:ctor()
end

---@private
function ArtifactPropertyItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ArtifactPropertyItemView:InitGenerate(Root, data)
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


end

---@private
function ArtifactPropertyItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ArtifactPropertyItemView:InitGenerate__2(Root, data)
--[[
	Star
--]]
	local tmp = Root:Find("Star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.star = tmp
end

---@private
function ArtifactPropertyItemView:InitGenerate__3(Root, data)
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
function ArtifactPropertyItemView:InitGenerate__4(Root, data)
--[[
	BtnActivation
--]]
	local tmp = Root:Find("BtnActivation").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnActivation = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ArtifactPropertyItemView:InitGenerate__5(Root, data)
--[[
	UIRedNotesRP
--]]
	local tmp = Root:Find("UIRedNotesRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rp = tmp
end

---@private
function ArtifactPropertyItemView:InitGenerate__6(Root, data)
--[[
	UIRedNotesRP/RedPoint/Bg
--]]
	local tmp = Root:Find("UIRedNotesRP/RedPoint/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp
end

---@private
function ArtifactPropertyItemView:InitGenerate__7(Root, data)
--[[
	UIRedNotesRP/RedPoint/Hart
--]]
	local tmp = Root:Find("UIRedNotesRP/RedPoint/Hart").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hart = tmp
end

---@private
function ArtifactPropertyItemView:GenerateDestroy()
	if tolua.getpeer(self.star) ~= nil then
		tolua.setpeer(self.star, nil)
	end
	self.star = nil
	if tolua.getpeer(self.dsc) ~= nil then
		tolua.setpeer(self.dsc, nil)
	end
	self.dsc = nil
	if tolua.getpeer(self.btnActivation) ~= nil then
		tolua.setpeer(self.btnActivation, nil)
	end
	self.btnActivation = nil
	if tolua.getpeer(self.rp) ~= nil then
		tolua.setpeer(self.rp, nil)
	end
	self.rp = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.hart) ~= nil then
		tolua.setpeer(self.hart, nil)
	end
	self.hart = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return ArtifactPropertyItemView