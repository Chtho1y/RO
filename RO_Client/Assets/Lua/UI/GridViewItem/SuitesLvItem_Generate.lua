---@class SuitesLvItem__Generate_numlv
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class SuitesLvItem__Generate_suitesName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class SuitesLvItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private activity UnityEngine.GameObject
---@field private suitesName SuitesLvItem__Generate_suitesName
---@field private numlv SuitesLvItem__Generate_numlv
local SuitesLvItemView = class("SuitesLvItemView")

function SuitesLvItemView:ctor()
end

---@private
function SuitesLvItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function SuitesLvItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function SuitesLvItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function SuitesLvItemView:InitGenerate__2(Root, data)
--[[
	Activity
--]]
	local tmp = Root:Find("Activity").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.activity = tmp
end

---@private
function SuitesLvItemView:InitGenerate__3(Root, data)
--[[
	SuitesName
--]]
	local tmp = Root:Find("SuitesName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.suitesName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function SuitesLvItemView:InitGenerate__4(Root, data)
--[[
	numlv
--]]
	local tmp = Root:Find("numlv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.numlv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function SuitesLvItemView:GenerateDestroy()
	if tolua.getpeer(self.numlv) ~= nil then
		tolua.setpeer(self.numlv, nil)
	end
	if tolua.getpeer(self.suitesName) ~= nil then
		tolua.setpeer(self.suitesName, nil)
	end
	if tolua.getpeer(self.activity) ~= nil then
		tolua.setpeer(self.activity, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return SuitesLvItemView