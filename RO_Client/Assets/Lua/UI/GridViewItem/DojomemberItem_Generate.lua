---@class DojomemberItem__Generate_skillNode_skillCD
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class DojomemberItem__Generate_skillNode_skillProgress
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class DojomemberItem__Generate_skillNode_skillIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class DojomemberItem__Generate_skillNode
---@field public gameObject UnityEngine.GameObject
---@field public skillIcon DojomemberItem__Generate_skillNode_skillIcon
---@field public skillProgress DojomemberItem__Generate_skillNode_skillProgress
---@field public skillCD DojomemberItem__Generate_skillNode_skillCD
---@field public keepNode UnityEngine.GameObject
---@field public waitNode UnityEngine.GameObject
---@field public extraNode UnityEngine.GameObject
---@field public forbidNode UnityEngine.GameObject
---@field public releaseNode UnityEngine.GameObject

---@class DojomemberItem__Generate_headItem_level
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class DojomemberItem__Generate_headItem_jobIcon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class DojomemberItem__Generate_headItem_headFrame
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image

---@class DojomemberItem__Generate_headItem_head
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class DojomemberItem__Generate_headItem_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class DojomemberItem__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public bg DojomemberItem__Generate_headItem_bg
---@field public head DojomemberItem__Generate_headItem_head
---@field public headFrame DojomemberItem__Generate_headItem_headFrame
---@field public jobIcon DojomemberItem__Generate_headItem_jobIcon
---@field public level DojomemberItem__Generate_headItem_level

---@class DojomemberItem__Generate_sp
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class DojomemberItem__Generate_hp
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class DojomemberItem__Generate_actorName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class DojomemberItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private animator UnityEngine.Animator
---@field private bgFriend UnityEngine.GameObject
---@field private bgEnemy UnityEngine.GameObject
---@field private actorName DojomemberItem__Generate_actorName
---@field private hp DojomemberItem__Generate_hp
---@field private sp DojomemberItem__Generate_sp
---@field private headItem DojomemberItem__Generate_headItem
---@field private skillNode DojomemberItem__Generate_skillNode
---@field private deadNode UnityEngine.GameObject
local DojomemberItemView = class("DojomemberItemView")

function DojomemberItemView:ctor()
end

---@private
function DojomemberItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function DojomemberItemView:InitGenerate(Root, data)
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


end

---@private
function DojomemberItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)

	self.animator = Root:GetComponent(Enum.TypeInfo.Animator)
	self.animator.logWarnings = false
end

---@private
function DojomemberItemView:InitGenerate__2(Root, data)
--[[
	BgFriend
--]]
	local tmp = Root:Find("BgFriend").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bgFriend = tmp
end

---@private
function DojomemberItemView:InitGenerate__3(Root, data)
--[[
	BgEnemy
--]]
	local tmp = Root:Find("BgEnemy").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bgEnemy = tmp
end

---@private
function DojomemberItemView:InitGenerate__4(Root, data)
--[[
	Name
--]]
	local tmp = Root:Find("Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.actorName = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function DojomemberItemView:InitGenerate__5(Root, data)
--[[
	HP/bloodImg
--]]
	local tmp = Root:Find("HP/bloodImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hp = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function DojomemberItemView:InitGenerate__6(Root, data)
--[[
	SP/spImg
--]]
	local tmp = Root:Find("SP/spImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.sp = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function DojomemberItemView:InitGenerate__7(Root, data)
--[[
	HeadItem
--]]
	local tmp = Root:Find("HeadItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem = tmp
end

---@private
function DojomemberItemView:InitGenerate__8(Root, data)
--[[
	HeadItem/Bg
--]]
	local tmp = Root:Find("HeadItem/Bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function DojomemberItemView:InitGenerate__9(Root, data)
--[[
	HeadItem/Head
--]]
	local tmp = Root:Find("HeadItem/Head").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem.head = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function DojomemberItemView:InitGenerate__10(Root, data)
--[[
	HeadItem/Frame
--]]
	local tmp = Root:Find("HeadItem/Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem.headFrame = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function DojomemberItemView:InitGenerate__11(Root, data)
--[[
	HeadItem/JobIcon
--]]
	local tmp = Root:Find("HeadItem/JobIcon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem.jobIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function DojomemberItemView:InitGenerate__12(Root, data)
--[[
	HeadItem/TextLV
--]]
	local tmp = Root:Find("HeadItem/TextLV").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.headItem.level = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function DojomemberItemView:InitGenerate__13(Root, data)
--[[
	Skill
--]]
	local tmp = Root:Find("Skill").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillNode = tmp
end

---@private
function DojomemberItemView:InitGenerate__14(Root, data)
--[[
	Skill/Icon
--]]
	local tmp = Root:Find("Skill/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillNode.skillIcon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function DojomemberItemView:InitGenerate__15(Root, data)
--[[
	Skill/Mask
--]]
	local tmp = Root:Find("Skill/Mask").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillNode.skillProgress = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function DojomemberItemView:InitGenerate__16(Root, data)
--[[
	Skill/CD
--]]
	local tmp = Root:Find("Skill/CD").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillNode.skillCD = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function DojomemberItemView:InitGenerate__17(Root, data)
--[[
	Skill/Keep
--]]
	local tmp = Root:Find("Skill/Keep").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillNode.keepNode = tmp
end

---@private
function DojomemberItemView:InitGenerate__18(Root, data)
--[[
	Skill/Wait
--]]
	local tmp = Root:Find("Skill/Wait").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillNode.waitNode = tmp
end

---@private
function DojomemberItemView:InitGenerate__19(Root, data)
--[[
	Skill/Extra
--]]
	local tmp = Root:Find("Skill/Extra").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillNode.extraNode = tmp
end

---@private
function DojomemberItemView:InitGenerate__20(Root, data)
--[[
	Skill/Forbidden
--]]
	local tmp = Root:Find("Skill/Forbidden").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillNode.forbidNode = tmp
end

---@private
function DojomemberItemView:InitGenerate__21(Root, data)
--[[
	Skill/Release
--]]
	local tmp = Root:Find("Skill/Release").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.skillNode.releaseNode = tmp
end

---@private
function DojomemberItemView:InitGenerate__22(Root, data)
--[[
	Dead
--]]
	local tmp = Root:Find("Dead").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.deadNode = tmp
end

---@private
function DojomemberItemView:GenerateDestroy()
	if tolua.getpeer(self.deadNode) ~= nil then
		tolua.setpeer(self.deadNode, nil)
	end
	if tolua.getpeer(self.skillNode.releaseNode) ~= nil then
		tolua.setpeer(self.skillNode.releaseNode, nil)
	end
	if tolua.getpeer(self.skillNode.forbidNode) ~= nil then
		tolua.setpeer(self.skillNode.forbidNode, nil)
	end
	if tolua.getpeer(self.skillNode.extraNode) ~= nil then
		tolua.setpeer(self.skillNode.extraNode, nil)
	end
	if tolua.getpeer(self.skillNode.waitNode) ~= nil then
		tolua.setpeer(self.skillNode.waitNode, nil)
	end
	if tolua.getpeer(self.skillNode.keepNode) ~= nil then
		tolua.setpeer(self.skillNode.keepNode, nil)
	end
	if tolua.getpeer(self.skillNode.skillCD) ~= nil then
		tolua.setpeer(self.skillNode.skillCD, nil)
	end
	if tolua.getpeer(self.skillNode.skillProgress) ~= nil then
		tolua.setpeer(self.skillNode.skillProgress, nil)
	end
	if tolua.getpeer(self.skillNode.skillIcon) ~= nil then
		tolua.setpeer(self.skillNode.skillIcon, nil)
	end
	if tolua.getpeer(self.skillNode) ~= nil then
		tolua.setpeer(self.skillNode, nil)
	end
	if tolua.getpeer(self.headItem.level) ~= nil then
		tolua.setpeer(self.headItem.level, nil)
	end
	if tolua.getpeer(self.headItem.jobIcon) ~= nil then
		tolua.setpeer(self.headItem.jobIcon, nil)
	end
	if tolua.getpeer(self.headItem.headFrame) ~= nil then
		tolua.setpeer(self.headItem.headFrame, nil)
	end
	if tolua.getpeer(self.headItem.head) ~= nil then
		tolua.setpeer(self.headItem.head, nil)
	end
	if tolua.getpeer(self.headItem.bg) ~= nil then
		tolua.setpeer(self.headItem.bg, nil)
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	if tolua.getpeer(self.sp) ~= nil then
		tolua.setpeer(self.sp, nil)
	end
	if tolua.getpeer(self.hp) ~= nil then
		tolua.setpeer(self.hp, nil)
	end
	if tolua.getpeer(self.actorName) ~= nil then
		tolua.setpeer(self.actorName, nil)
	end
	if tolua.getpeer(self.bgEnemy) ~= nil then
		tolua.setpeer(self.bgEnemy, nil)
	end
	if tolua.getpeer(self.bgFriend) ~= nil then
		tolua.setpeer(self.bgFriend, nil)
	end
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return DojomemberItemView