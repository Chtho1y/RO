---@class UIRoleChangeJob__Generate_content
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIRoleChangeJob__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIRoleChangeJob__Generate_job5
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIRoleChangeJob__Generate_job4
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIRoleChangeJob__Generate_job3
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIRoleChangeJob__Generate_job2
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIRoleChangeJob__Generate_job1
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UIRoleChangeJob__Generate_btnTest
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRoleChangeJob__Generate_btnSkill
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRoleChangeJob__Generate_desc
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIRoleChangeJob__Generate_model
---@field public gameObject UnityEngine.GameObject
---@field public rawImage UnityEngine.UI.RawImage
---@field public uIEventTriggerListener UIEventTriggerListener

---@class UIRoleChangeJob__Generate_btnBack
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRoleChangeJob__Generate_btnChange
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRoleChangeJob__Generate_btnChange2_cost
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIRoleChangeJob__Generate_btnChange2_ic
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIRoleChangeJob__Generate_btnChange2
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public ic UIRoleChangeJob__Generate_btnChange2_ic
---@field public cost UIRoleChangeJob__Generate_btnChange2_cost

---@class UIRoleChangeJob__Generate_btnChangeJob
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRoleChangeJob__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIRoleChangeJob__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIRoleChangeJob__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIRoleChangeJob__Generate_uIAnimator
---@field private AnyBtn UIRoleChangeJob__Generate_AnyBtn
---@field private dscBox UnityEngine.GameObject
---@field private boardImage UnityEngine.GameObject
---@field private btnChangeJob UIRoleChangeJob__Generate_btnChangeJob
---@field private btnChange2 UIRoleChangeJob__Generate_btnChange2
---@field private btnChange UIRoleChangeJob__Generate_btnChange
---@field private btnBack UIRoleChangeJob__Generate_btnBack
---@field private changeJob UnityEngine.GameObject
---@field private model UIRoleChangeJob__Generate_model
---@field private desc UIRoleChangeJob__Generate_desc
---@field private btnSkill UIRoleChangeJob__Generate_btnSkill
---@field private btnTest UIRoleChangeJob__Generate_btnTest
---@field private top UnityEngine.GameObject
---@field private group UnityEngine.GameObject
---@field private job1 UIRoleChangeJob__Generate_job1
---@field private job2 UIRoleChangeJob__Generate_job2
---@field private job3 UIRoleChangeJob__Generate_job3
---@field private job4 UIRoleChangeJob__Generate_job4
---@field private job5 UIRoleChangeJob__Generate_job5
---@field private taskBox UnityEngine.GameObject
---@field private scrollView UIRoleChangeJob__Generate_scrollView
---@field private content UIRoleChangeJob__Generate_content
---@field private jobMax UnityEngine.GameObject
local UIRoleChangeJobView = class("UIRoleChangeJobView", require("UIViewBase"))

function UIRoleChangeJobView:ctor()
end

---@private
function UIRoleChangeJobView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIRoleChangeJobView:InitGenerate(Root, data)
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
	self:InitGenerate__20(Root,data)
	self:InitGenerate__21(Root,data)
	self:InitGenerate__22(Root,data)
	self:InitGenerate__23(Root,data)
	self:InitGenerate__24(Root,data)
	self:InitGenerate__25(Root,data)
	self:InitGenerate__26(Root,data)
	self:InitGenerate__27(Root,data)


end

---@private
function UIRoleChangeJobView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIRoleChangeJobView:InitGenerate__2(Root, data)
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
function UIRoleChangeJobView:InitGenerate__3(Root, data)
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
function UIRoleChangeJobView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/DscBox
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscBox = tmp
end

---@private
function UIRoleChangeJobView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BoardImage
--]]
	local tmp = Root:Find("UIAnimator/Window/BoardImage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boardImage = tmp
end

---@private
function UIRoleChangeJobView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BtnChangeJob
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnChangeJob").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChangeJob = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIRoleChangeJobView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BtnChange2
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnChange2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChange2 = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIRoleChangeJobView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BtnChange2/Content/ic
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnChange2/Content/ic").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChange2.ic = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIRoleChangeJobView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BtnChange2/Content/cost
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnChange2/Content/cost").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChange2.cost = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIRoleChangeJobView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BtnChange
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnChange").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChange = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIRoleChangeJobView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBack = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIRoleChangeJobView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/ChangeJob
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.changeJob = tmp
end

---@private
function UIRoleChangeJobView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/ChangeJob/Stage/Model
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob/Stage/Model").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.model = tmp

	tmp.rawImage = tmp:GetComponent(Enum.TypeInfo.RawImage)

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
end

---@private
function UIRoleChangeJobView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/ChangeJob/Stage/descBg/desc
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob/Stage/descBg/desc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desc = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIRoleChangeJobView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/ChangeJob/Stage/BtnSkill
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob/Stage/BtnSkill").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSkill = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIRoleChangeJobView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/ChangeJob/Stage/BtnTest
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob/Stage/BtnTest").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnTest = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIRoleChangeJobView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/ChangeJob/Top
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob/Top").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.top = tmp
end

---@private
function UIRoleChangeJobView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/ChangeJob/Top/group
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob/Top/group").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.group = tmp
end

---@private
function UIRoleChangeJobView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/ChangeJob/Top/group/Toggle1
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob/Top/group/Toggle1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.job1 = CommonUtil.BindGridViewItem2LuaStatic("RoleJobToggleItem", tmp)
	self.job1.prefabName = "RoleJobToggleItem"

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIRoleChangeJobView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/ChangeJob/Top/group/Toggle2
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob/Top/group/Toggle2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.job2 = CommonUtil.BindGridViewItem2LuaStatic("RoleJobToggleItem", tmp)
	self.job2.prefabName = "RoleJobToggleItem"

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIRoleChangeJobView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/ChangeJob/Top/group/Toggle3
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob/Top/group/Toggle3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.job3 = CommonUtil.BindGridViewItem2LuaStatic("RoleJobToggleItem", tmp)
	self.job3.prefabName = "RoleJobToggleItem"

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIRoleChangeJobView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/ChangeJob/Top/group/Toggle4
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob/Top/group/Toggle4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.job4 = CommonUtil.BindGridViewItem2LuaStatic("RoleJobToggleItem", tmp)
	self.job4.prefabName = "RoleJobToggleItem"

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIRoleChangeJobView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/ChangeJob/Top/group/Toggle5
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob/Top/group/Toggle5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.job5 = CommonUtil.BindGridViewItem2LuaStatic("RoleJobToggleItem", tmp)
	self.job5.prefabName = "RoleJobToggleItem"

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIRoleChangeJobView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/ChangeJob/TaskBox
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob/TaskBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.taskBox = tmp
end

---@private
function UIRoleChangeJobView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/ChangeJob/TaskBox/Scroll View
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob/TaskBox/Scroll View").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIRoleChangeJobView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/ChangeJob/TaskBox/Scroll View/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/ChangeJob/TaskBox/Scroll View/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIRoleChangeJobView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/JobMax
--]]
	local tmp = Root:Find("UIAnimator/Window/JobMax").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.jobMax = tmp
end

---@private
function UIRoleChangeJobView:GenerateDestroy()
	if tolua.getpeer(self.btnChange2.cost) ~= nil then
		tolua.setpeer(self.btnChange2.cost, nil)
	end
	if tolua.getpeer(self.btnChange2.ic) ~= nil then
		tolua.setpeer(self.btnChange2.ic, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.dscBox) ~= nil then
		tolua.setpeer(self.dscBox, nil)
	end
	self.dscBox = nil
	if tolua.getpeer(self.boardImage) ~= nil then
		tolua.setpeer(self.boardImage, nil)
	end
	self.boardImage = nil
	if tolua.getpeer(self.btnChangeJob) ~= nil then
		tolua.setpeer(self.btnChangeJob, nil)
	end
	self.btnChangeJob = nil
	if tolua.getpeer(self.btnChange2) ~= nil then
		tolua.setpeer(self.btnChange2, nil)
	end
	self.btnChange2 = nil
	if tolua.getpeer(self.btnChange) ~= nil then
		tolua.setpeer(self.btnChange, nil)
	end
	self.btnChange = nil
	if tolua.getpeer(self.btnBack) ~= nil then
		tolua.setpeer(self.btnBack, nil)
	end
	self.btnBack = nil
	if tolua.getpeer(self.changeJob) ~= nil then
		tolua.setpeer(self.changeJob, nil)
	end
	self.changeJob = nil
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
	if tolua.getpeer(self.btnTest) ~= nil then
		tolua.setpeer(self.btnTest, nil)
	end
	self.btnTest = nil
	if tolua.getpeer(self.top) ~= nil then
		tolua.setpeer(self.top, nil)
	end
	self.top = nil
	if tolua.getpeer(self.group) ~= nil then
		tolua.setpeer(self.group, nil)
	end
	self.group = nil
	if self.job1.GenerateDestroy ~= nil then
		self.job1:GenerateDestroy()
	end
	if tolua.getpeer(self.job1) ~= nil then
		tolua.setpeer(self.job1, nil)
	end
	self.job1 = nil
	if self.job2.GenerateDestroy ~= nil then
		self.job2:GenerateDestroy()
	end
	if tolua.getpeer(self.job2) ~= nil then
		tolua.setpeer(self.job2, nil)
	end
	self.job2 = nil
	if self.job3.GenerateDestroy ~= nil then
		self.job3:GenerateDestroy()
	end
	if tolua.getpeer(self.job3) ~= nil then
		tolua.setpeer(self.job3, nil)
	end
	self.job3 = nil
	if self.job4.GenerateDestroy ~= nil then
		self.job4:GenerateDestroy()
	end
	if tolua.getpeer(self.job4) ~= nil then
		tolua.setpeer(self.job4, nil)
	end
	self.job4 = nil
	if self.job5.GenerateDestroy ~= nil then
		self.job5:GenerateDestroy()
	end
	if tolua.getpeer(self.job5) ~= nil then
		tolua.setpeer(self.job5, nil)
	end
	self.job5 = nil
	if tolua.getpeer(self.taskBox) ~= nil then
		tolua.setpeer(self.taskBox, nil)
	end
	self.taskBox = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	if tolua.getpeer(self.jobMax) ~= nil then
		tolua.setpeer(self.jobMax, nil)
	end
	self.jobMax = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIRoleChangeJobView