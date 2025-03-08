---@class GuildLogItem__Generate_contentTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildLogItem__Generate_timeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class GuildLogItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private timeTxt GuildLogItem__Generate_timeTxt
---@field private contentTxt GuildLogItem__Generate_contentTxt
local GuildLogItemView = class("GuildLogItemView")

function GuildLogItemView:ctor()
end

---@private
function GuildLogItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function GuildLogItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)


end

---@private
function GuildLogItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function GuildLogItemView:InitGenerate__2(Root, data)
--[[
	TimeTxt
--]]
	local tmp = Root:Find("TimeTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function GuildLogItemView:InitGenerate__3(Root, data)
--[[
	ContentTxt
--]]
	local tmp = Root:Find("ContentTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.contentTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function GuildLogItemView:GenerateDestroy()
	if tolua.getpeer(self.timeTxt) ~= nil then
		tolua.setpeer(self.timeTxt, nil)
	end
	self.timeTxt = nil
	if tolua.getpeer(self.contentTxt) ~= nil then
		tolua.setpeer(self.contentTxt, nil)
	end
	self.contentTxt = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return GuildLogItemView