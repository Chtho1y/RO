---@class UIExpeditionArrange__Generate_backBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionArrange__Generate_helpLogBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionArrange__Generate_helpBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpeditionArrange__Generate_hero6
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIExpeditionArrange__Generate_hero5
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIExpeditionArrange__Generate_hero4
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIExpeditionArrange__Generate_hero3
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIExpeditionArrange__Generate_hero2
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIExpeditionArrange__Generate_hero1
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIExpeditionArrange__Generate_fighterPowerText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExpeditionArrange__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private selectedHero1 UnityEngine.GameObject
---@field private selectedHero2 UnityEngine.GameObject
---@field private selectedHero3 UnityEngine.GameObject
---@field private selectedHero4 UnityEngine.GameObject
---@field private fighterPowerText UIExpeditionArrange__Generate_fighterPowerText
---@field private roleList UnityEngine.GameObject
---@field private roleListAnim UnityEngine.GameObject
---@field private hero1 UIExpeditionArrange__Generate_hero1
---@field private hero2 UIExpeditionArrange__Generate_hero2
---@field private hero3 UIExpeditionArrange__Generate_hero3
---@field private hero4 UIExpeditionArrange__Generate_hero4
---@field private hero5 UIExpeditionArrange__Generate_hero5
---@field private hero6 UIExpeditionArrange__Generate_hero6
---@field private helpBtn UIExpeditionArrange__Generate_helpBtn
---@field private helpLogBtn UIExpeditionArrange__Generate_helpLogBtn
---@field private backBtn UIExpeditionArrange__Generate_backBtn
local UIExpeditionArrangeView = class("UIExpeditionArrangeView", require("UIViewBase"))

function UIExpeditionArrangeView:ctor()
end

---@private
function UIExpeditionArrangeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIExpeditionArrangeView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
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
function UIExpeditionArrangeView:InitGenerate__1(Root, data)
--[[
	Window/CenterView/Character1
--]]
	local tmp = Root:Find("Window/CenterView/Character1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectedHero1 = tmp
end

---@private
function UIExpeditionArrangeView:InitGenerate__2(Root, data)
--[[
	Window/CenterView/Character2
--]]
	local tmp = Root:Find("Window/CenterView/Character2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectedHero2 = tmp
end

---@private
function UIExpeditionArrangeView:InitGenerate__3(Root, data)
--[[
	Window/CenterView/Character3
--]]
	local tmp = Root:Find("Window/CenterView/Character3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectedHero3 = tmp
end

---@private
function UIExpeditionArrangeView:InitGenerate__4(Root, data)
--[[
	Window/CenterView/Character4
--]]
	local tmp = Root:Find("Window/CenterView/Character4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selectedHero4 = tmp
end

---@private
function UIExpeditionArrangeView:InitGenerate__5(Root, data)
--[[
	Window/CenterView/FightPowerInfo/Val
--]]
	local tmp = Root:Find("Window/CenterView/FightPowerInfo/Val").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fighterPowerText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExpeditionArrangeView:InitGenerate__6(Root, data)
--[[
	Window/BottomView/RoleList
--]]
	local tmp = Root:Find("Window/BottomView/RoleList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.roleList = tmp
end

---@private
function UIExpeditionArrangeView:InitGenerate__7(Root, data)
--[[
	Window/BottomView/RoleList/RoleListAnim
--]]
	local tmp = Root:Find("Window/BottomView/RoleList/RoleListAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.roleListAnim = tmp
end

---@private
function UIExpeditionArrangeView:InitGenerate__8(Root, data)
--[[
	Window/BottomView/RoleList/RoleListAnim/Role1
--]]
	local tmp = Root:Find("Window/BottomView/RoleList/RoleListAnim/Role1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero1 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIExpeditionArrangeView:InitGenerate__9(Root, data)
--[[
	Window/BottomView/RoleList/RoleListAnim/Role2
--]]
	local tmp = Root:Find("Window/BottomView/RoleList/RoleListAnim/Role2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero2 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIExpeditionArrangeView:InitGenerate__10(Root, data)
--[[
	Window/BottomView/RoleList/RoleListAnim/Role3
--]]
	local tmp = Root:Find("Window/BottomView/RoleList/RoleListAnim/Role3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero3 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIExpeditionArrangeView:InitGenerate__11(Root, data)
--[[
	Window/BottomView/RoleList/RoleListAnim/Role4
--]]
	local tmp = Root:Find("Window/BottomView/RoleList/RoleListAnim/Role4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero4 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIExpeditionArrangeView:InitGenerate__12(Root, data)
--[[
	Window/BottomView/RoleList/RoleListAnim/Role5
--]]
	local tmp = Root:Find("Window/BottomView/RoleList/RoleListAnim/Role5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero5 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIExpeditionArrangeView:InitGenerate__13(Root, data)
--[[
	Window/BottomView/RoleList/RoleListAnim/Role6
--]]
	local tmp = Root:Find("Window/BottomView/RoleList/RoleListAnim/Role6").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hero6 = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIExpeditionArrangeView:InitGenerate__14(Root, data)
--[[
	Window/BottomView/Content/BtnCall
--]]
	local tmp = Root:Find("Window/BottomView/Content/BtnCall").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.helpBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExpeditionArrangeView:InitGenerate__15(Root, data)
--[[
	Window/BottomView/Content/BtnLog
--]]
	local tmp = Root:Find("Window/BottomView/Content/BtnLog").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.helpLogBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExpeditionArrangeView:InitGenerate__16(Root, data)
--[[
	Window/BottomView/Content/BtnBack
--]]
	local tmp = Root:Find("Window/BottomView/Content/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.backBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExpeditionArrangeView:GenerateDestroy()
	if tolua.getpeer(self.selectedHero1) ~= nil then
		tolua.setpeer(self.selectedHero1, nil)
	end
	self.selectedHero1 = nil
	if tolua.getpeer(self.selectedHero2) ~= nil then
		tolua.setpeer(self.selectedHero2, nil)
	end
	self.selectedHero2 = nil
	if tolua.getpeer(self.selectedHero3) ~= nil then
		tolua.setpeer(self.selectedHero3, nil)
	end
	self.selectedHero3 = nil
	if tolua.getpeer(self.selectedHero4) ~= nil then
		tolua.setpeer(self.selectedHero4, nil)
	end
	self.selectedHero4 = nil
	if tolua.getpeer(self.fighterPowerText) ~= nil then
		tolua.setpeer(self.fighterPowerText, nil)
	end
	self.fighterPowerText = nil
	if tolua.getpeer(self.roleList) ~= nil then
		tolua.setpeer(self.roleList, nil)
	end
	self.roleList = nil
	if tolua.getpeer(self.roleListAnim) ~= nil then
		tolua.setpeer(self.roleListAnim, nil)
	end
	self.roleListAnim = nil
	if tolua.getpeer(self.hero1) ~= nil then
		tolua.setpeer(self.hero1, nil)
	end
	self.hero1 = nil
	if tolua.getpeer(self.hero2) ~= nil then
		tolua.setpeer(self.hero2, nil)
	end
	self.hero2 = nil
	if tolua.getpeer(self.hero3) ~= nil then
		tolua.setpeer(self.hero3, nil)
	end
	self.hero3 = nil
	if tolua.getpeer(self.hero4) ~= nil then
		tolua.setpeer(self.hero4, nil)
	end
	self.hero4 = nil
	if tolua.getpeer(self.hero5) ~= nil then
		tolua.setpeer(self.hero5, nil)
	end
	self.hero5 = nil
	if tolua.getpeer(self.hero6) ~= nil then
		tolua.setpeer(self.hero6, nil)
	end
	self.hero6 = nil
	if tolua.getpeer(self.helpBtn) ~= nil then
		tolua.setpeer(self.helpBtn, nil)
	end
	self.helpBtn = nil
	if tolua.getpeer(self.helpLogBtn) ~= nil then
		tolua.setpeer(self.helpLogBtn, nil)
	end
	self.helpLogBtn = nil
	if tolua.getpeer(self.backBtn) ~= nil then
		tolua.setpeer(self.backBtn, nil)
	end
	self.backBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIExpeditionArrangeView