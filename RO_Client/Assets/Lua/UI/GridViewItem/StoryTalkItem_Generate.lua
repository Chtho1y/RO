---@class StoryTalkItem__Generate_talkRgt_dsc
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public text UnityEngine.UI.Text

---@class StoryTalkItem__Generate_talkRgt_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class StoryTalkItem__Generate_talkRgt_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class StoryTalkItem__Generate_talkRgt
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public bg StoryTalkItem__Generate_talkRgt_bg
---@field public text StoryTalkItem__Generate_talkRgt_text
---@field public dsc StoryTalkItem__Generate_talkRgt_dsc
---@field public next UnityEngine.GameObject

---@class StoryTalkItem__Generate_talkLft_dsc
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public text UnityEngine.UI.Text

---@class StoryTalkItem__Generate_talkLft_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class StoryTalkItem__Generate_talkLft_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class StoryTalkItem__Generate_talkLft
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public bg StoryTalkItem__Generate_talkLft_bg
---@field public text StoryTalkItem__Generate_talkLft_text
---@field public dsc StoryTalkItem__Generate_talkLft_dsc
---@field public next UnityEngine.GameObject

---@class StoryTalkItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private layoutElement UnityEngine.UI.LayoutElement
---@field private canvasGroup UnityEngine.CanvasGroup
---@field private talkLft StoryTalkItem__Generate_talkLft
---@field private talkRgt StoryTalkItem__Generate_talkRgt
local StoryTalkItemView = class("StoryTalkItemView")

function StoryTalkItemView:ctor()
end

---@private
function StoryTalkItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function StoryTalkItemView:InitGenerate(Root, data)
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
	self:InitGenerate__8(Root,data)
	self:InitGenerate__9(Root,data)
	self:InitGenerate__10(Root,data)
	self:InitGenerate__11(Root,data)


end

---@private
function StoryTalkItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)

	self.layoutElement = Root:GetComponent(Enum.TypeInfo.LayoutElement)

	self.canvasGroup = Root:GetComponent(Enum.TypeInfo.CanvasGroup)
end

---@private
function StoryTalkItemView:InitGenerate__2(Root, data)
--[[
	TalkLft
--]]
	local tmp = Root:Find("TalkLft").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.talkLft = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function StoryTalkItemView:InitGenerate__3(Root, data)
--[[
	TalkLft/Name/bg
--]]
	local tmp = Root:Find("TalkLft/Name/bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.talkLft.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function StoryTalkItemView:InitGenerate__4(Root, data)
--[[
	TalkLft/Name/Text
--]]
	local tmp = Root:Find("TalkLft/Name/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.talkLft.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function StoryTalkItemView:InitGenerate__5(Root, data)
--[[
	TalkLft/Dsc
--]]
	local tmp = Root:Find("TalkLft/Dsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.talkLft.dsc = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function StoryTalkItemView:InitGenerate__6(Root, data)
--[[
	TalkLft/Next
--]]
	local tmp = Root:Find("TalkLft/Next").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.talkLft.next = tmp
end

---@private
function StoryTalkItemView:InitGenerate__7(Root, data)
--[[
	TalkRgt
--]]
	local tmp = Root:Find("TalkRgt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.talkRgt = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function StoryTalkItemView:InitGenerate__8(Root, data)
--[[
	TalkRgt/Name/bg
--]]
	local tmp = Root:Find("TalkRgt/Name/bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.talkRgt.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function StoryTalkItemView:InitGenerate__9(Root, data)
--[[
	TalkRgt/Name/Text
--]]
	local tmp = Root:Find("TalkRgt/Name/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.talkRgt.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function StoryTalkItemView:InitGenerate__10(Root, data)
--[[
	TalkRgt/Dsc
--]]
	local tmp = Root:Find("TalkRgt/Dsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.talkRgt.dsc = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function StoryTalkItemView:InitGenerate__11(Root, data)
--[[
	TalkRgt/Next
--]]
	local tmp = Root:Find("TalkRgt/Next").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.talkRgt.next = tmp
end

---@private
function StoryTalkItemView:GenerateDestroy()
	if tolua.getpeer(self.talkRgt.next) ~= nil then
		tolua.setpeer(self.talkRgt.next, nil)
	end
	if tolua.getpeer(self.talkRgt.dsc) ~= nil then
		tolua.setpeer(self.talkRgt.dsc, nil)
	end
	if tolua.getpeer(self.talkRgt.text) ~= nil then
		tolua.setpeer(self.talkRgt.text, nil)
	end
	if tolua.getpeer(self.talkRgt.bg) ~= nil then
		tolua.setpeer(self.talkRgt.bg, nil)
	end
	if tolua.getpeer(self.talkLft.next) ~= nil then
		tolua.setpeer(self.talkLft.next, nil)
	end
	if tolua.getpeer(self.talkLft.dsc) ~= nil then
		tolua.setpeer(self.talkLft.dsc, nil)
	end
	if tolua.getpeer(self.talkLft.text) ~= nil then
		tolua.setpeer(self.talkLft.text, nil)
	end
	if tolua.getpeer(self.talkLft.bg) ~= nil then
		tolua.setpeer(self.talkLft.bg, nil)
	end
	if tolua.getpeer(self.talkLft) ~= nil then
		tolua.setpeer(self.talkLft, nil)
	end
	self.talkLft = nil
	if tolua.getpeer(self.talkRgt) ~= nil then
		tolua.setpeer(self.talkRgt, nil)
	end
	self.talkRgt = nil
	self.inited = false
end
return StoryTalkItemView