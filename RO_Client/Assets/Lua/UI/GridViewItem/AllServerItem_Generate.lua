---@class AllServerItem__Generate_playerBox_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class AllServerItem__Generate_playerBox_jobIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class AllServerItem__Generate_playerBox_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class AllServerItem__Generate_playerBox_headIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class AllServerItem__Generate_playerBox_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class AllServerItem__Generate_playerBox
---@field public gameObject UnityEngine.GameObject
---@field public nameTxt AllServerItem__Generate_playerBox_nameTxt
---@field public headIcon AllServerItem__Generate_playerBox_headIcon
---@field public frame AllServerItem__Generate_playerBox_frame
---@field public jobIcon AllServerItem__Generate_playerBox_jobIcon
---@field public num AllServerItem__Generate_playerBox_num

---@class AllServerItem__Generate_serverName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class AllServerItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private button UnityEngine.UI.Button
---@field private serverName AllServerItem__Generate_serverName
---@field private playerBox AllServerItem__Generate_playerBox
---@field private labelCurrent UnityEngine.GameObject
---@field private labelMaintaining UnityEngine.GameObject
---@field private labelNew UnityEngine.GameObject
---@field private redPointTesting UnityEngine.GameObject
local AllServerItemView = class("AllServerItemView")

function AllServerItemView:ctor()
end

---@private
function AllServerItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function AllServerItemView:InitGenerate(Root, data)
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
	self:InitGenerate__12(Root,data)


end

---@private
function AllServerItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.button = Root:GetComponent(Enum.TypeInfo.Button)
end

---@private
function AllServerItemView:InitGenerate__2(Root, data)
--[[
	ServerName
--]]
	local tmp = Root:Find("ServerName").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.serverName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function AllServerItemView:InitGenerate__3(Root, data)
--[[
	PlayerBox
--]]
	local tmp = Root:Find("PlayerBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerBox = tmp
end

---@private
function AllServerItemView:InitGenerate__4(Root, data)
--[[
	PlayerBox/NameTxt
--]]
	local tmp = Root:Find("PlayerBox/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerBox.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function AllServerItemView:InitGenerate__5(Root, data)
--[[
	PlayerBox/Head/HeadIcon
--]]
	local tmp = Root:Find("PlayerBox/Head/HeadIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerBox.headIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function AllServerItemView:InitGenerate__6(Root, data)
--[[
	PlayerBox/Head/Frame
--]]
	local tmp = Root:Find("PlayerBox/Head/Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerBox.frame = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function AllServerItemView:InitGenerate__7(Root, data)
--[[
	PlayerBox/Head/JobIcon
--]]
	local tmp = Root:Find("PlayerBox/Head/JobIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerBox.jobIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function AllServerItemView:InitGenerate__8(Root, data)
--[[
	PlayerBox/Head/Num
--]]
	local tmp = Root:Find("PlayerBox/Head/Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerBox.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function AllServerItemView:InitGenerate__9(Root, data)
--[[
	LabelCurrent
--]]
	local tmp = Root:Find("LabelCurrent").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelCurrent = tmp
end

---@private
function AllServerItemView:InitGenerate__10(Root, data)
--[[
	LabelMaintaining
--]]
	local tmp = Root:Find("LabelMaintaining").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelMaintaining = tmp
end

---@private
function AllServerItemView:InitGenerate__11(Root, data)
--[[
	LabelNew
--]]
	local tmp = Root:Find("LabelNew").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.labelNew = tmp
end

---@private
function AllServerItemView:InitGenerate__12(Root, data)
--[[
	LabelNew/UITesting
--]]
	local tmp = Root:Find("LabelNew/UITesting").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redPointTesting = tmp
	self.redPointTesting:SetActive(false)
end

---@private
function AllServerItemView:GenerateDestroy()
	if tolua.getpeer(self.playerBox.num) ~= nil then
		tolua.setpeer(self.playerBox.num, nil)
	end
	if tolua.getpeer(self.playerBox.jobIcon) ~= nil then
		tolua.setpeer(self.playerBox.jobIcon, nil)
	end
	if tolua.getpeer(self.playerBox.frame) ~= nil then
		tolua.setpeer(self.playerBox.frame, nil)
	end
	if tolua.getpeer(self.playerBox.headIcon) ~= nil then
		tolua.setpeer(self.playerBox.headIcon, nil)
	end
	if tolua.getpeer(self.playerBox.nameTxt) ~= nil then
		tolua.setpeer(self.playerBox.nameTxt, nil)
	end
	if tolua.getpeer(self.playerBox) ~= nil then
		tolua.setpeer(self.playerBox, nil)
	end
	if tolua.getpeer(self.serverName) ~= nil then
		tolua.setpeer(self.serverName, nil)
	end
	self.serverName = nil
	if tolua.getpeer(self.labelCurrent) ~= nil then
		tolua.setpeer(self.labelCurrent, nil)
	end
	self.labelCurrent = nil
	if tolua.getpeer(self.labelMaintaining) ~= nil then
		tolua.setpeer(self.labelMaintaining, nil)
	end
	self.labelMaintaining = nil
	if tolua.getpeer(self.labelNew) ~= nil then
		tolua.setpeer(self.labelNew, nil)
	end
	self.labelNew = nil
	if tolua.getpeer(self.redPointTesting) ~= nil then
		tolua.setpeer(self.redPointTesting, nil)
	end
	self.redPointTesting = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return AllServerItemView