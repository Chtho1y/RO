---@class FriendItemList__Generate_headItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class FriendItemList__Generate_statusLbl
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class FriendItemList__Generate_fightPower
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class FriendItemList__Generate_playerName
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class FriendItemList__Generate_playerFollow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public switchSprite SwitchSprite

---@class FriendItemList__Generate_statusImg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class FriendItemList__Generate_clapBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class FriendItemList__Generate_chatBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class FriendItemList__Generate_removeBlackBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class FriendItemList__Generate_unfollowBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class FriendItemList__Generate_followBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class FriendItemList__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private btnsGroup UnityEngine.GameObject
---@field private followBtn FriendItemList__Generate_followBtn
---@field private unfollowBtn FriendItemList__Generate_unfollowBtn
---@field private removeBlackBtn FriendItemList__Generate_removeBlackBtn
---@field private chatBtn FriendItemList__Generate_chatBtn
---@field private recruitBtnsGroup UnityEngine.GameObject
---@field private clapBtn FriendItemList__Generate_clapBtn
---@field private graduate UnityEngine.GameObject
---@field private statusImg FriendItemList__Generate_statusImg
---@field private playerFollow FriendItemList__Generate_playerFollow
---@field private playerName FriendItemList__Generate_playerName
---@field private fightPower FriendItemList__Generate_fightPower
---@field private statusLbl FriendItemList__Generate_statusLbl
---@field private headItem FriendItemList__Generate_headItem
---@field private redPoint UnityEngine.GameObject
local FriendItemListView = class("FriendItemListView")

function FriendItemListView:ctor()
end

---@private
function FriendItemListView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function FriendItemListView:InitGenerate(Root, data)
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


end

---@private
function FriendItemListView:InitGenerate__1(Root, data)
--[[
	BtnsGroup
--]]
	local tmp = Root:Find("BtnsGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnsGroup = tmp
end

---@private
function FriendItemListView:InitGenerate__2(Root, data)
--[[
	BtnsGroup/FollowBtn
--]]
	local tmp = Root:Find("BtnsGroup/FollowBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.followBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function FriendItemListView:InitGenerate__3(Root, data)
--[[
	BtnsGroup/UnfollowBtn
--]]
	local tmp = Root:Find("BtnsGroup/UnfollowBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.unfollowBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function FriendItemListView:InitGenerate__4(Root, data)
--[[
	BtnsGroup/RemoveBlackBtn
--]]
	local tmp = Root:Find("BtnsGroup/RemoveBlackBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.removeBlackBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function FriendItemListView:InitGenerate__5(Root, data)
--[[
	BtnsGroup/ChatBtn
--]]
	local tmp = Root:Find("BtnsGroup/ChatBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chatBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function FriendItemListView:InitGenerate__6(Root, data)
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
function FriendItemListView:InitGenerate__7(Root, data)
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
function FriendItemListView:InitGenerate__8(Root, data)
--[[
	RecruitBtnsGroup/Graduate
--]]
	local tmp = Root:Find("RecruitBtnsGroup/Graduate").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.graduate = tmp
end

---@private
function FriendItemListView:InitGenerate__9(Root, data)
--[[
	StatusImg
--]]
	local tmp = Root:Find("StatusImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.statusImg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function FriendItemListView:InitGenerate__10(Root, data)
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
function FriendItemListView:InitGenerate__11(Root, data)
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
function FriendItemListView:InitGenerate__12(Root, data)
--[[
	FightPowerNum
--]]
	local tmp = Root:Find("FightPowerNum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fightPower = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function FriendItemListView:InitGenerate__13(Root, data)
--[[
	StatusLbl
--]]
	local tmp = Root:Find("StatusLbl").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.statusLbl = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function FriendItemListView:InitGenerate__14(Root, data)
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
function FriendItemListView:InitGenerate__15(Root, data)
--[[
	UINewRP
--]]
	local tmp = Root:Find("UINewRP").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redPoint = tmp
end

---@private
function FriendItemListView:GenerateDestroy()
	if tolua.getpeer(self.btnsGroup) ~= nil then
		tolua.setpeer(self.btnsGroup, nil)
	end
	self.btnsGroup = nil
	if tolua.getpeer(self.followBtn) ~= nil then
		tolua.setpeer(self.followBtn, nil)
	end
	self.followBtn = nil
	if tolua.getpeer(self.unfollowBtn) ~= nil then
		tolua.setpeer(self.unfollowBtn, nil)
	end
	self.unfollowBtn = nil
	if tolua.getpeer(self.removeBlackBtn) ~= nil then
		tolua.setpeer(self.removeBlackBtn, nil)
	end
	self.removeBlackBtn = nil
	if tolua.getpeer(self.chatBtn) ~= nil then
		tolua.setpeer(self.chatBtn, nil)
	end
	self.chatBtn = nil
	if tolua.getpeer(self.recruitBtnsGroup) ~= nil then
		tolua.setpeer(self.recruitBtnsGroup, nil)
	end
	self.recruitBtnsGroup = nil
	if tolua.getpeer(self.clapBtn) ~= nil then
		tolua.setpeer(self.clapBtn, nil)
	end
	self.clapBtn = nil
	if tolua.getpeer(self.graduate) ~= nil then
		tolua.setpeer(self.graduate, nil)
	end
	self.graduate = nil
	if tolua.getpeer(self.statusImg) ~= nil then
		tolua.setpeer(self.statusImg, nil)
	end
	self.statusImg = nil
	if tolua.getpeer(self.playerFollow) ~= nil then
		tolua.setpeer(self.playerFollow, nil)
	end
	self.playerFollow = nil
	if tolua.getpeer(self.playerName) ~= nil then
		tolua.setpeer(self.playerName, nil)
	end
	self.playerName = nil
	if tolua.getpeer(self.fightPower) ~= nil then
		tolua.setpeer(self.fightPower, nil)
	end
	self.fightPower = nil
	if tolua.getpeer(self.statusLbl) ~= nil then
		tolua.setpeer(self.statusLbl, nil)
	end
	self.statusLbl = nil
	if self.headItem.GenerateDestroy ~= nil then
		self.headItem:GenerateDestroy()
	end
	if tolua.getpeer(self.headItem) ~= nil then
		tolua.setpeer(self.headItem, nil)
	end
	self.headItem = nil
	if tolua.getpeer(self.redPoint) ~= nil then
		tolua.setpeer(self.redPoint, nil)
	end
	self.redPoint = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return FriendItemListView