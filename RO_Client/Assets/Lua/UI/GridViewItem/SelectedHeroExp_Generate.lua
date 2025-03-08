---@class SelectedHeroExp__Generate_helpNode
---@field public gameObject UnityEngine.GameObject
---@field public symbolText WXB.SymbolText

---@class SelectedHeroExp__Generate_heroName
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class SelectedHeroExp__Generate_heroLv
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class SelectedHeroExp__Generate_jobIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class SelectedHeroExp__Generate_replaceBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class SelectedHeroExp__Generate_heroImg
---@field public gameObject UnityEngine.GameObject
---@field public rawImage UnityEngine.UI.RawImage

---@class SelectedHeroExp__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private heroImg SelectedHeroExp__Generate_heroImg
---@field private replaceBtn SelectedHeroExp__Generate_replaceBtn
---@field private jobIcon SelectedHeroExp__Generate_jobIcon
---@field private heroLv SelectedHeroExp__Generate_heroLv
---@field private heroName SelectedHeroExp__Generate_heroName
---@field private helpNode SelectedHeroExp__Generate_helpNode
local SelectedHeroExpView = class("SelectedHeroExpView")

function SelectedHeroExpView:ctor()
end

---@private
function SelectedHeroExpView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function SelectedHeroExpView:InitGenerate(Root, data)
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
function SelectedHeroExpView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function SelectedHeroExpView:InitGenerate__2(Root, data)
--[[
	Mod
--]]
	local tmp = Root:Find("Mod").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.heroImg = tmp

	tmp.rawImage = tmp:GetComponent(Enum.TypeInfo.RawImage)
end

---@private
function SelectedHeroExpView:InitGenerate__3(Root, data)
--[[
	ReplaceBtn
--]]
	local tmp = Root:Find("ReplaceBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.replaceBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function SelectedHeroExpView:InitGenerate__4(Root, data)
--[[
	Job
--]]
	local tmp = Root:Find("Job").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.jobIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function SelectedHeroExpView:InitGenerate__5(Root, data)
--[[
	Job/NumLv
--]]
	local tmp = Root:Find("Job/NumLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.heroLv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function SelectedHeroExpView:InitGenerate__6(Root, data)
--[[
	Name
--]]
	local tmp = Root:Find("Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.heroName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function SelectedHeroExpView:InitGenerate__7(Root, data)
--[[
	HelpEmoj
--]]
	local tmp = Root:Find("HelpEmoj").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.helpNode = tmp

	tmp.symbolText = tmp:GetComponent(Enum.TypeInfo.SymbolText)
end

---@private
function SelectedHeroExpView:GenerateDestroy()
	if tolua.getpeer(self.helpNode) ~= nil then
		tolua.setpeer(self.helpNode, nil)
	end
	if tolua.getpeer(self.heroName) ~= nil then
		tolua.setpeer(self.heroName, nil)
	end
	if tolua.getpeer(self.heroLv) ~= nil then
		tolua.setpeer(self.heroLv, nil)
	end
	if tolua.getpeer(self.jobIcon) ~= nil then
		tolua.setpeer(self.jobIcon, nil)
	end
	if tolua.getpeer(self.replaceBtn) ~= nil then
		tolua.setpeer(self.replaceBtn, nil)
	end
	if tolua.getpeer(self.heroImg) ~= nil then
		tolua.setpeer(self.heroImg, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return SelectedHeroExpView