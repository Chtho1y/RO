---@class BattleLogItem__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public contentSizeFitter UnityEngine.UI.ContentSizeFitter
---@field public text UnityEngine.UI.Text

---@class BattleLogItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private layoutElement UnityEngine.UI.LayoutElement
---@field private text BattleLogItem__Generate_text
local BattleLogItemView = class("BattleLogItemView")

function BattleLogItemView:ctor()
end

---@private
function BattleLogItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function BattleLogItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)


end

---@private
function BattleLogItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)

	self.layoutElement = Root:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function BattleLogItemView:InitGenerate__2(Root, data)
--[[
	Text
--]]
	local tmp = Root:Find("Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.contentSizeFitter = tmp:GetComponent(Enum.TypeInfo.ContentSizeFitter)

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function BattleLogItemView:GenerateDestroy()
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return BattleLogItemView