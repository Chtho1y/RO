---@class HundredDojoLogItem__Generate_fightBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class HundredDojoLogItem__Generate_contentTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class HundredDojoLogItem__Generate_timeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class HundredDojoLogItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private timeTxt HundredDojoLogItem__Generate_timeTxt
---@field private contentTxt HundredDojoLogItem__Generate_contentTxt
---@field private fightBtn HundredDojoLogItem__Generate_fightBtn
local HundredDojoLogItemView = class("HundredDojoLogItemView")

function HundredDojoLogItemView:ctor()
end

---@private
function HundredDojoLogItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function HundredDojoLogItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)


end

---@private
function HundredDojoLogItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function HundredDojoLogItemView:InitGenerate__2(Root, data)
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
function HundredDojoLogItemView:InitGenerate__3(Root, data)
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
function HundredDojoLogItemView:InitGenerate__4(Root, data)
--[[
	FightBtn
--]]
	local tmp = Root:Find("FightBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fightBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function HundredDojoLogItemView:GenerateDestroy()
	if tolua.getpeer(self.timeTxt) ~= nil then
		tolua.setpeer(self.timeTxt, nil)
	end
	self.timeTxt = nil
	if tolua.getpeer(self.contentTxt) ~= nil then
		tolua.setpeer(self.contentTxt, nil)
	end
	self.contentTxt = nil
	if tolua.getpeer(self.fightBtn) ~= nil then
		tolua.setpeer(self.fightBtn, nil)
	end
	self.fightBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return HundredDojoLogItemView