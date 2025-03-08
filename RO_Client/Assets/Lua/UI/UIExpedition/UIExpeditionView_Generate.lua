---@class UIExpedition__Generate_ruleBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpedition__Generate_helpLogBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpedition__Generate_timesNode_leftTimesTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExpedition__Generate_timesNode
---@field public gameObject UnityEngine.GameObject
---@field public leftTimesTxt UIExpedition__Generate_timesNode_leftTimesTxt

---@class UIExpedition__Generate_backBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpedition__Generate_BtnRank
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpedition__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIExpedition__Generate_dungeonGroupScrollList_content
---@field public gameObject UnityEngine.GameObject
---@field public verticalLayoutGroup UnityEngine.UI.VerticalLayoutGroup

---@class UIExpedition__Generate_dungeonGroupScrollList
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect
---@field public content UIExpedition__Generate_dungeonGroupScrollList_content

---@class UIExpedition__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIExpedition__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIExpedition__Generate_AnyBtn
---@field private dungeonGroupScrollList UIExpedition__Generate_dungeonGroupScrollList
---@field private text UIExpedition__Generate_text
---@field private BtnRank UIExpedition__Generate_BtnRank
---@field private backBtn UIExpedition__Generate_backBtn
---@field private timesNode UIExpedition__Generate_timesNode
---@field private helpLogBtn UIExpedition__Generate_helpLogBtn
---@field private ruleBtn UIExpedition__Generate_ruleBtn
local UIExpeditionView = class("UIExpeditionView", require("UIViewBase"))

function UIExpeditionView:ctor()
end

---@private
function UIExpeditionView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIExpeditionView:InitGenerate(Root, data)
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


end

---@private
function UIExpeditionView:InitGenerate__1(Root, data)
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
function UIExpeditionView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/DungeonGroup
--]]
	local tmp = Root:Find("UIAnimator/Window/DungeonGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dungeonGroupScrollList = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIExpeditionView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/DungeonGroup/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/DungeonGroup/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dungeonGroupScrollList.content = tmp

	tmp.verticalLayoutGroup = tmp:GetComponent(Enum.TypeInfo.VerticalLayoutGroup)
end

---@private
function UIExpeditionView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Top/Image/Image/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/Image/Image/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExpeditionView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Top/Image/BtnRank
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/Image/BtnRank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.BtnRank = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExpeditionView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.backBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExpeditionView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Times
--]]
	local tmp = Root:Find("UIAnimator/Window/Times").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timesNode = tmp
end

---@private
function UIExpeditionView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Times/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/Times/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timesNode.leftTimesTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIExpeditionView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BtnHelpLog
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnHelpLog").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.helpLogBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExpeditionView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BtnInfo
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnInfo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.ruleBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIExpeditionView:GenerateDestroy()
	if tolua.getpeer(self.timesNode.leftTimesTxt) ~= nil then
		tolua.setpeer(self.timesNode.leftTimesTxt, nil)
	end
	if tolua.getpeer(self.dungeonGroupScrollList.content) ~= nil then
		tolua.setpeer(self.dungeonGroupScrollList.content, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.dungeonGroupScrollList) ~= nil then
		tolua.setpeer(self.dungeonGroupScrollList, nil)
	end
	self.dungeonGroupScrollList = nil
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.BtnRank) ~= nil then
		tolua.setpeer(self.BtnRank, nil)
	end
	self.BtnRank = nil
	if tolua.getpeer(self.backBtn) ~= nil then
		tolua.setpeer(self.backBtn, nil)
	end
	self.backBtn = nil
	if tolua.getpeer(self.timesNode) ~= nil then
		tolua.setpeer(self.timesNode, nil)
	end
	self.timesNode = nil
	if tolua.getpeer(self.helpLogBtn) ~= nil then
		tolua.setpeer(self.helpLogBtn, nil)
	end
	self.helpLogBtn = nil
	if tolua.getpeer(self.ruleBtn) ~= nil then
		tolua.setpeer(self.ruleBtn, nil)
	end
	self.ruleBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIExpeditionView