---@class UIRoleChangeJobTips__Generate_btnChangeJob_numcost
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIRoleChangeJobTips__Generate_btnChangeJob_image
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIRoleChangeJobTips__Generate_btnChangeJob
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public image UIRoleChangeJobTips__Generate_btnChangeJob_image
---@field public numcost UIRoleChangeJobTips__Generate_btnChangeJob_numcost

---@class UIRoleChangeJobTips__Generate_roleJobToggleItem
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIRoleChangeJobTips__Generate_content
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public toggleGroup UnityEngine.UI.ToggleGroup
---@field public horizontalLayoutGroup UnityEngine.UI.HorizontalLayoutGroup

---@class UIRoleChangeJobTips__Generate_btnSkill
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRoleChangeJobTips__Generate_desc
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIRoleChangeJobTips__Generate_model
---@field public gameObject UnityEngine.GameObject
---@field public rawImage UnityEngine.UI.RawImage
---@field public uIEventTriggerListener UIEventTriggerListener

---@class UIRoleChangeJobTips__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRoleChangeJobTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRoleChangeJobTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIRoleChangeJobTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIRoleChangeJobTips__Generate_uIAnimator
---@field private AnyBtn UIRoleChangeJobTips__Generate_AnyBtn
---@field private btnClose UIRoleChangeJobTips__Generate_btnClose
---@field private model UIRoleChangeJobTips__Generate_model
---@field private desc UIRoleChangeJobTips__Generate_desc
---@field private btnSkill UIRoleChangeJobTips__Generate_btnSkill
---@field private content UIRoleChangeJobTips__Generate_content
---@field private roleJobToggleItem UIRoleChangeJobTips__Generate_roleJobToggleItem
---@field private rightArrow UnityEngine.GameObject
---@field private leftArrow UnityEngine.GameObject
---@field private btnChangeJob UIRoleChangeJobTips__Generate_btnChangeJob
---@field private desTxt UnityEngine.GameObject
local UIRoleChangeJobTipsView = class("UIRoleChangeJobTipsView", require("UIViewBase"))

function UIRoleChangeJobTipsView:ctor()
end

---@private
function UIRoleChangeJobTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIRoleChangeJobTipsView:InitGenerate(Root, data)
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


end

---@private
function UIRoleChangeJobTipsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIRoleChangeJobTipsView:InitGenerate__2(Root, data)
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
function UIRoleChangeJobTipsView:InitGenerate__3(Root, data)
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
function UIRoleChangeJobTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIRoleChangeJobTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Stage/Model
--]]
	local tmp = Root:Find("UIAnimator/Window/Stage/Model").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.model = tmp

	tmp.rawImage = tmp:GetComponent(Enum.TypeInfo.RawImage)

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
end

---@private
function UIRoleChangeJobTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Stage/descBg/desc
--]]
	local tmp = Root:Find("UIAnimator/Window/Stage/descBg/desc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desc = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIRoleChangeJobTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Stage/BtnSkill
--]]
	local tmp = Root:Find("UIAnimator/Window/Stage/BtnSkill").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSkill = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIRoleChangeJobTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/JobScroll/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/JobScroll/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.toggleGroup = tmp:GetComponent(Enum.TypeInfo.ToggleGroup)

	tmp.horizontalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.HorizontalLayoutGroup)
end

---@private
function UIRoleChangeJobTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/JobScroll/Viewport/Content/RoleJobToggleItem
--]]
	local tmp = Root:Find("UIAnimator/Window/JobScroll/Viewport/Content/RoleJobToggleItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.roleJobToggleItem = CommonUtil.BindGridViewItem2LuaStatic("RoleJobToggleItem", tmp)
	self.roleJobToggleItem.prefabName = "RoleJobToggleItem"

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIRoleChangeJobTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/RightArrow
--]]
	local tmp = Root:Find("UIAnimator/Window/RightArrow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rightArrow = tmp
end

---@private
function UIRoleChangeJobTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/LeftArrow
--]]
	local tmp = Root:Find("UIAnimator/Window/LeftArrow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.leftArrow = tmp
end

---@private
function UIRoleChangeJobTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnChangeJob
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnChangeJob").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChangeJob = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIRoleChangeJobTipsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnChangeJob/Content/Image
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnChangeJob/Content/Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChangeJob.image = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIRoleChangeJobTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnChangeJob/Content/numcost
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnChangeJob/Content/numcost").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChangeJob.numcost = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIRoleChangeJobTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Bottom/DesTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desTxt = tmp
end

---@private
function UIRoleChangeJobTipsView:GenerateDestroy()
	if tolua.getpeer(self.btnChangeJob.numcost) ~= nil then
		tolua.setpeer(self.btnChangeJob.numcost, nil)
	end
	if tolua.getpeer(self.btnChangeJob.image) ~= nil then
		tolua.setpeer(self.btnChangeJob.image, nil)
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
	if tolua.getpeer(self.model) ~= nil then
		tolua.setpeer(self.model, nil)
	end
	self.model = nil
	if tolua.getpeer(self.desc) ~= nil then
		tolua.setpeer(self.desc, nil)
	end
	self.desc = nil
	if tolua.getpeer(self.btnSkill) ~= nil then
		tolua.setpeer(self.btnSkill, nil)
	end
	self.btnSkill = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	if self.roleJobToggleItem.GenerateDestroy ~= nil then
		self.roleJobToggleItem:GenerateDestroy()
	end
	if tolua.getpeer(self.roleJobToggleItem) ~= nil then
		tolua.setpeer(self.roleJobToggleItem, nil)
	end
	self.roleJobToggleItem = nil
	if tolua.getpeer(self.rightArrow) ~= nil then
		tolua.setpeer(self.rightArrow, nil)
	end
	self.rightArrow = nil
	if tolua.getpeer(self.leftArrow) ~= nil then
		tolua.setpeer(self.leftArrow, nil)
	end
	self.leftArrow = nil
	if tolua.getpeer(self.btnChangeJob) ~= nil then
		tolua.setpeer(self.btnChangeJob, nil)
	end
	self.btnChangeJob = nil
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIRoleChangeJobTipsView