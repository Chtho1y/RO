---@class StudentListItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class StudentListItem__Generate_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class StudentListItem__Generate_playerFollow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public switchSprite SwitchSprite

---@class StudentListItem__Generate_clapBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public image UnityEngine.GameObject

---@class StudentListItem__Generate_statusLbl
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class StudentListItem__Generate_statusImg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class StudentListItem__Generate_recruitValueNum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class StudentListItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private recruitValueNum StudentListItem__Generate_recruitValueNum
---@field private statusImg StudentListItem__Generate_statusImg
---@field private statusLbl StudentListItem__Generate_statusLbl
---@field private recruitBtnsGroup UnityEngine.GameObject
---@field private clapBtn StudentListItem__Generate_clapBtn
---@field private graduated UnityEngine.GameObject
---@field private label UnityEngine.GameObject
---@field private playerFollow StudentListItem__Generate_playerFollow
---@field private playerName StudentListItem__Generate_playerName
---@field private headItem StudentListItem__Generate_headItem
local StudentListItemView = class("StudentListItemView")

function StudentListItemView:ctor()
end

---@private
function StudentListItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function StudentListItemView:InitGenerate(Root, data)
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
function StudentListItemView:InitGenerate__1(Root, data)
--[[
	RecruitValueBg/RecruitValueNum
--]]
	local tmp = Root:Find("RecruitValueBg/RecruitValueNum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.recruitValueNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function StudentListItemView:InitGenerate__2(Root, data)
--[[
	StatusBg/StatusImg
--]]
	local tmp = Root:Find("StatusBg/StatusImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.statusImg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function StudentListItemView:InitGenerate__3(Root, data)
--[[
	StatusBg/StatusLbl
--]]
	local tmp = Root:Find("StatusBg/StatusLbl").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.statusLbl = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function StudentListItemView:InitGenerate__4(Root, data)
--[[
	RecruitBtnsGroup
--]]
	local tmp = Root:Find("RecruitBtnsGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.recruitBtnsGroup = tmp
end

---@private
function StudentListItemView:InitGenerate__5(Root, data)
--[[
	RecruitBtnsGroup/ClapBtn
--]]
	local tmp = Root:Find("RecruitBtnsGroup/ClapBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.clapBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function StudentListItemView:InitGenerate__6(Root, data)
--[[
	RecruitBtnsGroup/ClapBtn/image
--]]
	local tmp = Root:Find("RecruitBtnsGroup/ClapBtn/image").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.clapBtn.image = tmp
end

---@private
function StudentListItemView:InitGenerate__7(Root, data)
--[[
	RecruitBtnsGroup/Graduated
--]]
	local tmp = Root:Find("RecruitBtnsGroup/Graduated").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.graduated = tmp
end

---@private
function StudentListItemView:InitGenerate__8(Root, data)
--[[
	RecruitBtnsGroup/Graduated/Label
--]]
	local tmp = Root:Find("RecruitBtnsGroup/Graduated/Label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.label = tmp
end

---@private
function StudentListItemView:InitGenerate__9(Root, data)
--[[
	NameGroup/FollowImg
--]]
	local tmp = Root:Find("NameGroup/FollowImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerFollow = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.switchSprite = tmp:GetComponent(Enum.TypeInfo.SwitchSprite)
end

---@private
function StudentListItemView:InitGenerate__10(Root, data)
--[[
	NameGroup/Name
--]]
	local tmp = Root:Find("NameGroup/Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function StudentListItemView:InitGenerate__11(Root, data)
--[[
	HeadItem
--]]
	local tmp = Root:Find("HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem = CommonUtil.BindGridViewItem2LuaStatic("HeadItem", tmp)
	self.headItem.prefabName = "HeadItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function StudentListItemView:GenerateDestroy()
	if tolua.getpeer(self.clapBtn.image) ~= nil then
		tolua.setpeer(self.clapBtn.image, nil)
	end
	if tolua.getpeer(self.recruitValueNum) ~= nil then
		tolua.setpeer(self.recruitValueNum, nil)
	end
	self.recruitValueNum = nil
	if tolua.getpeer(self.statusImg) ~= nil then
		tolua.setpeer(self.statusImg, nil)
	end
	self.statusImg = nil
	if tolua.getpeer(self.statusLbl) ~= nil then
		tolua.setpeer(self.statusLbl, nil)
	end
	self.statusLbl = nil
	if tolua.getpeer(self.recruitBtnsGroup) ~= nil then
		tolua.setpeer(self.recruitBtnsGroup, nil)
	end
	self.recruitBtnsGroup = nil
	if tolua.getpeer(self.clapBtn) ~= nil then
		tolua.setpeer(self.clapBtn, nil)
	end
	self.clapBtn = nil
	if tolua.getpeer(self.graduated) ~= nil then
		tolua.setpeer(self.graduated, nil)
	end
	self.graduated = nil
	if tolua.getpeer(self.label) ~= nil then
		tolua.setpeer(self.label, nil)
	end
	self.label = nil
	if tolua.getpeer(self.playerFollow) ~= nil then
		tolua.setpeer(self.playerFollow, nil)
	end
	self.playerFollow = nil
	if tolua.getpeer(self.playerName) ~= nil then
		tolua.setpeer(self.playerName, nil)
	end
	self.playerName = nil
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	self.headItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return StudentListItemView