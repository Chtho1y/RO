---@class UIBattleBossTips__Generate_bossDesc
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleBossTips__Generate_TxtRectTrans
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIBattleBossTips__Generate_skillTemplate
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIBattleBossTips__Generate_skillList
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIBattleBossTips__Generate_natureName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleBossTips__Generate_bossLevel
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleBossTips__Generate_bossName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleBossTips__Generate_natureImg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIBattleBossTips__Generate_bossImg
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image

---@class UIBattleBossTips__Generate_bgImg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIBattleBossTips__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBattleBossTips__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBattleBossTips__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIBattleBossTips__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIBattleBossTips__Generate_uIAnimator
---@field private AnyBtn UIBattleBossTips__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private closeBtn UIBattleBossTips__Generate_closeBtn
---@field private bossNode UnityEngine.GameObject
---@field private bgImg UIBattleBossTips__Generate_bgImg
---@field private bossImg UIBattleBossTips__Generate_bossImg
---@field private natureImg UIBattleBossTips__Generate_natureImg
---@field private bossName UIBattleBossTips__Generate_bossName
---@field private bossLevel UIBattleBossTips__Generate_bossLevel
---@field private natureName UIBattleBossTips__Generate_natureName
---@field private baseAttr UnityEngine.GameObject
---@field private atrrList UnityEngine.GameObject
---@field private attrTemp UnityEngine.GameObject
---@field private skillList UIBattleBossTips__Generate_skillList
---@field private skillTemplate UIBattleBossTips__Generate_skillTemplate
---@field private TxtRectTrans UIBattleBossTips__Generate_TxtRectTrans
---@field private bossDesc UIBattleBossTips__Generate_bossDesc
local UIBattleBossTipsView = class("UIBattleBossTipsView", require("UIViewBase"))

function UIBattleBossTipsView:ctor()
end

---@private
function UIBattleBossTipsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIBattleBossTipsView:InitGenerate(Root, data)
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


end

---@private
function UIBattleBossTipsView:InitGenerate__1(Root, data)
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
function UIBattleBossTipsView:InitGenerate__2(Root, data)
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
function UIBattleBossTipsView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window
--]]
	local tmp = Root:Find("UIAnimator/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp
end

---@private
function UIBattleBossTipsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIBattleBossTipsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Boss
--]]
	local tmp = Root:Find("UIAnimator/Window/Boss").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossNode = tmp
end

---@private
function UIBattleBossTipsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Boss/Top/bgboss
--]]
	local tmp = Root:Find("UIAnimator/Window/Boss/Top/bgboss").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bgImg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIBattleBossTipsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Boss/Top/Slot/Pos/Npc1
--]]
	local tmp = Root:Find("UIAnimator/Window/Boss/Top/Slot/Pos/Npc1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossImg = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIBattleBossTipsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Boss/Top/BaseInfo/Image
--]]
	local tmp = Root:Find("UIAnimator/Window/Boss/Top/BaseInfo/Image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.natureImg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIBattleBossTipsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Boss/Top/BaseInfo/BossName
--]]
	local tmp = Root:Find("UIAnimator/Window/Boss/Top/BaseInfo/BossName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleBossTipsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Boss/Top/BaseInfo/numlevel
--]]
	local tmp = Root:Find("UIAnimator/Window/Boss/Top/BaseInfo/numlevel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossLevel = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleBossTipsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Boss/Top/BaseInfo/textnature
--]]
	local tmp = Root:Find("UIAnimator/Window/Boss/Top/BaseInfo/textnature").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.natureName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleBossTipsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Boss/Top/BaseAttr
--]]
	local tmp = Root:Find("UIAnimator/Window/Boss/Top/BaseAttr").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.baseAttr = tmp
end

---@private
function UIBattleBossTipsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Boss/Top/BaseAttr/Attributes
--]]
	local tmp = Root:Find("UIAnimator/Window/Boss/Top/BaseAttr/Attributes").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.atrrList = tmp
end

---@private
function UIBattleBossTipsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Boss/Top/BaseAttr/Attributes/OriginalAttribute
--]]
	local tmp = Root:Find("UIAnimator/Window/Boss/Top/BaseAttr/Attributes/OriginalAttribute").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrTemp = tmp
end

---@private
function UIBattleBossTipsView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Boss/Skill/DragList
--]]
	local tmp = Root:Find("UIAnimator/Window/Boss/Skill/DragList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillList = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIBattleBossTipsView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Boss/Skill/DragList/SkillItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Boss/Skill/DragList/SkillItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillTemplate = CommonUtil.BindGridViewItem2LuaStatic("SkillItem", tmp)
	self.skillTemplate.prefabName = "SkillItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIBattleBossTipsView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/DscBox/Scroll View/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Scroll View/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.TxtRectTrans = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIBattleBossTipsView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/DscBox/Scroll View/Viewport/Content/DesTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/DscBox/Scroll View/Viewport/Content/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bossDesc = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleBossTipsView:GenerateDestroy()
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if tolua.getpeer(self.closeBtn) ~= nil then
		tolua.setpeer(self.closeBtn, nil)
	end
	self.closeBtn = nil
	if tolua.getpeer(self.bossNode) ~= nil then
		tolua.setpeer(self.bossNode, nil)
	end
	self.bossNode = nil
	if tolua.getpeer(self.bgImg) ~= nil then
		tolua.setpeer(self.bgImg, nil)
	end
	self.bgImg = nil
	if tolua.getpeer(self.bossImg) ~= nil then
		tolua.setpeer(self.bossImg, nil)
	end
	self.bossImg = nil
	if tolua.getpeer(self.natureImg) ~= nil then
		tolua.setpeer(self.natureImg, nil)
	end
	self.natureImg = nil
	if tolua.getpeer(self.bossName) ~= nil then
		tolua.setpeer(self.bossName, nil)
	end
	self.bossName = nil
	if tolua.getpeer(self.bossLevel) ~= nil then
		tolua.setpeer(self.bossLevel, nil)
	end
	self.bossLevel = nil
	if tolua.getpeer(self.natureName) ~= nil then
		tolua.setpeer(self.natureName, nil)
	end
	self.natureName = nil
	if tolua.getpeer(self.baseAttr) ~= nil then
		tolua.setpeer(self.baseAttr, nil)
	end
	self.baseAttr = nil
	if tolua.getpeer(self.atrrList) ~= nil then
		tolua.setpeer(self.atrrList, nil)
	end
	self.atrrList = nil
	if tolua.getpeer(self.attrTemp) ~= nil then
		tolua.setpeer(self.attrTemp, nil)
	end
	self.attrTemp = nil
	if tolua.getpeer(self.skillList) ~= nil then
		tolua.setpeer(self.skillList, nil)
	end
	self.skillList = nil
	if self.skillTemplate.GenerateDestroy ~= nil then
		self.skillTemplate:GenerateDestroy()
	end
	if tolua.getpeer(self.skillTemplate) ~= nil then
		tolua.setpeer(self.skillTemplate, nil)
	end
	self.skillTemplate = nil
	if tolua.getpeer(self.TxtRectTrans) ~= nil then
		tolua.setpeer(self.TxtRectTrans, nil)
	end
	self.TxtRectTrans = nil
	if tolua.getpeer(self.bossDesc) ~= nil then
		tolua.setpeer(self.bossDesc, nil)
	end
	self.bossDesc = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIBattleBossTipsView