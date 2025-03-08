---@class UIArtifactNotesTips__Generate_condition3_btnGoto
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactNotesTips__Generate_condition3_dsc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactNotesTips__Generate_condition3_actived
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIArtifactNotesTips__Generate_condition3
---@field public gameObject UnityEngine.GameObject
---@field public actived UIArtifactNotesTips__Generate_condition3_actived
---@field public dsc UIArtifactNotesTips__Generate_condition3_dsc
---@field public btnGoto UIArtifactNotesTips__Generate_condition3_btnGoto
---@field public label UnityEngine.GameObject

---@class UIArtifactNotesTips__Generate_condition2_btnGoto
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactNotesTips__Generate_condition2_dsc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactNotesTips__Generate_condition2_actived
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIArtifactNotesTips__Generate_condition2
---@field public gameObject UnityEngine.GameObject
---@field public actived UIArtifactNotesTips__Generate_condition2_actived
---@field public dsc UIArtifactNotesTips__Generate_condition2_dsc
---@field public btnGoto UIArtifactNotesTips__Generate_condition2_btnGoto
---@field public label UnityEngine.GameObject

---@class UIArtifactNotesTips__Generate_condition1_btnGoto
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactNotesTips__Generate_condition1_dsc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIArtifactNotesTips__Generate_condition1_actived
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIArtifactNotesTips__Generate_condition1
---@field public gameObject UnityEngine.GameObject
---@field public actived UIArtifactNotesTips__Generate_condition1_actived
---@field public dsc UIArtifactNotesTips__Generate_condition1_dsc
---@field public btnGoto UIArtifactNotesTips__Generate_condition1_btnGoto
---@field public label UnityEngine.GameObject

---@class UIArtifactNotesTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactNotesTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIArtifactNotesTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIArtifactNotesTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIArtifactNotesTips__Generate_uIAnimator
---@field private AnyBtn UIArtifactNotesTips__Generate_AnyBtn
---@field private btnClose UIArtifactNotesTips__Generate_btnClose
---@field private condition1 UIArtifactNotesTips__Generate_condition1
---@field private condition2 UIArtifactNotesTips__Generate_condition2
---@field private condition3 UIArtifactNotesTips__Generate_condition3
local UIArtifactNotesTipsView = class("UIArtifactNotesTipsView", require("UIViewBase"))

function UIArtifactNotesTipsView:ctor()
end

---@private
function UIArtifactNotesTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIArtifactNotesTipsView:InitGenerate(Root, data)
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
	self:InitGenerate__17(Root,data)
	self:InitGenerate__18(Root,data)
	self:InitGenerate__19(Root,data)


end

---@private
function UIArtifactNotesTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIArtifactNotesTipsView:InitGenerate__2(Root, data)
--[[
	UIAnimator
--]]
	local tmp = Root:Find("UIAnimator").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIAnimator = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIArtifactNotesTipsView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIArtifactNotesTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIArtifactNotesTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition1
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition1 = tmp
end

---@private
function UIArtifactNotesTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition1/Actived
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition1/Actived").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition1.actived = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIArtifactNotesTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition1/Dsc
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition1/Dsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition1.dsc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIArtifactNotesTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition1/BtnGoto
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition1/BtnGoto").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition1.btnGoto = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIArtifactNotesTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition1/Label
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition1/Label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition1.label = tmp
end

---@private
function UIArtifactNotesTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition2
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition2 = tmp
end

---@private
function UIArtifactNotesTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition2/Actived
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition2/Actived").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition2.actived = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIArtifactNotesTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition2/Dsc
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition2/Dsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition2.dsc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIArtifactNotesTipsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition2/BtnGoto
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition2/BtnGoto").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition2.btnGoto = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIArtifactNotesTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition2/Label
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition2/Label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition2.label = tmp
end

---@private
function UIArtifactNotesTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition3
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition3 = tmp
end

---@private
function UIArtifactNotesTipsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition3/Actived
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition3/Actived").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition3.actived = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIArtifactNotesTipsView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition3/Dsc
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition3/Dsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition3.dsc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIArtifactNotesTipsView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition3/BtnGoto
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition3/BtnGoto").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition3.btnGoto = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIArtifactNotesTipsView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bg/List/Condition3/Label
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/List/Condition3/Label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.condition3.label = tmp
end

---@private
function UIArtifactNotesTipsView:GenerateDestroy()
	if tolua.getpeer(self.condition3.label) ~= nil then
		tolua.setpeer(self.condition3.label, nil)
	end
	if tolua.getpeer(self.condition3.btnGoto) ~= nil then
		tolua.setpeer(self.condition3.btnGoto, nil)
	end
	if tolua.getpeer(self.condition3.dsc) ~= nil then
		tolua.setpeer(self.condition3.dsc, nil)
	end
	if tolua.getpeer(self.condition3.actived) ~= nil then
		tolua.setpeer(self.condition3.actived, nil)
	end
	if tolua.getpeer(self.condition2.label) ~= nil then
		tolua.setpeer(self.condition2.label, nil)
	end
	if tolua.getpeer(self.condition2.btnGoto) ~= nil then
		tolua.setpeer(self.condition2.btnGoto, nil)
	end
	if tolua.getpeer(self.condition2.dsc) ~= nil then
		tolua.setpeer(self.condition2.dsc, nil)
	end
	if tolua.getpeer(self.condition2.actived) ~= nil then
		tolua.setpeer(self.condition2.actived, nil)
	end
	if tolua.getpeer(self.condition1.label) ~= nil then
		tolua.setpeer(self.condition1.label, nil)
	end
	if tolua.getpeer(self.condition1.btnGoto) ~= nil then
		tolua.setpeer(self.condition1.btnGoto, nil)
	end
	if tolua.getpeer(self.condition1.dsc) ~= nil then
		tolua.setpeer(self.condition1.dsc, nil)
	end
	if tolua.getpeer(self.condition1.actived) ~= nil then
		tolua.setpeer(self.condition1.actived, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.condition1) ~= nil then
		tolua.setpeer(self.condition1, nil)
	end
	self.condition1 = nil
	if tolua.getpeer(self.condition2) ~= nil then
		tolua.setpeer(self.condition2, nil)
	end
	self.condition2 = nil
	if tolua.getpeer(self.condition3) ~= nil then
		tolua.setpeer(self.condition3, nil)
	end
	self.condition3 = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIArtifactNotesTipsView