---@class UIGuildInfo__Generate_btnCancel
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildInfo__Generate_btnEnter_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIGuildInfo__Generate_btnEnter
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIGuildInfo__Generate_btnEnter_text

---@class UIGuildInfo__Generate_loadingItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIGuildInfo__Generate_guildPeopleItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public button UnityEngine.UI.Button

---@class UIGuildInfo__Generate_peopleList
---@field public gameObject UnityEngine.GameObject
---@field public loopListView SuperScrollView.LoopListView

---@class UIGuildInfo__Generate_verifyTypeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildInfo__Generate_peopleTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildInfo__Generate_enterLimitTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildInfo__Generate_noticeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildInfo__Generate_activeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildInfo__Generate_idTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildInfo__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildInfo__Generate_lvTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildInfo__Generate_nameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildInfo__Generate_guildBadgeItem
---@field public gameObject UnityEngine.GameObject
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIGuildInfo__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildInfo__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildInfo__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIGuildInfo__Generate_AnyBtn
---@field private btnClose UIGuildInfo__Generate_btnClose
---@field private guildBadgeItem UIGuildInfo__Generate_guildBadgeItem
---@field private nameTxt UIGuildInfo__Generate_nameTxt
---@field private lvTxt UIGuildInfo__Generate_lvTxt
---@field private text UIGuildInfo__Generate_text
---@field private idTxt UIGuildInfo__Generate_idTxt
---@field private activeTxt UIGuildInfo__Generate_activeTxt
---@field private noticeTxt UIGuildInfo__Generate_noticeTxt
---@field private enterLimitTxt UIGuildInfo__Generate_enterLimitTxt
---@field private peopleTxt UIGuildInfo__Generate_peopleTxt
---@field private verifyTypeTxt UIGuildInfo__Generate_verifyTypeTxt
---@field private appliedTag UnityEngine.GameObject
---@field private peopleList UIGuildInfo__Generate_peopleList
---@field private guildPeopleItem UIGuildInfo__Generate_guildPeopleItem
---@field private loadingItem UIGuildInfo__Generate_loadingItem
---@field private bottom UnityEngine.GameObject
---@field private bottomRoot UnityEngine.GameObject
---@field private btnEnter UIGuildInfo__Generate_btnEnter
---@field private btnCancel UIGuildInfo__Generate_btnCancel
local UIGuildInfoView = class("UIGuildInfoView", require("UIViewBase"))

function UIGuildInfoView:ctor()
end

---@private
function UIGuildInfoView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildInfoView:InitGenerate(Root, data)
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
	self:InitGenerate__19(Root,data)
	self:InitGenerate__20(Root,data)
	self:InitGenerate__21(Root,data)


end

---@private
function UIGuildInfoView:InitGenerate__1(Root, data)
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
function UIGuildInfoView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildInfoView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/Top/GuildInfo/GuildBadgeItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/GuildInfo/GuildBadgeItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildBadgeItem = CommonUtil.BindGridViewItem2LuaStatic("GuildBadgeItem", tmp)
	self.guildBadgeItem.prefabName = "GuildBadgeItem"

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIGuildInfoView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/Top/GuildInfo/NameTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/GuildInfo/NameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildInfoView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Top/GuildInfo/Lv/LvTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/GuildInfo/Lv/LvTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.lvTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildInfoView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Top/GuildInfo/Id/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/GuildInfo/Id/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildInfoView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Top/GuildInfo/Id/IdTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/GuildInfo/Id/IdTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.idTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildInfoView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Top/GuildInfo/active/activeTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/GuildInfo/active/activeTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.activeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildInfoView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Top/GuildInfo/Notice/NoticeTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/GuildInfo/Notice/NoticeTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noticeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildInfoView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Top/EnterLimit/EnterLimitTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/EnterLimit/EnterLimitTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.enterLimitTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildInfoView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Top/People/PeopleTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/People/PeopleTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.peopleTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildInfoView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Top/VerifyType/VerifyTypeTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/VerifyType/VerifyTypeTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.verifyTypeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildInfoView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Top/AppliedTag
--]]
	local tmp = Root:Find("UIAnimator/Window/Top/AppliedTag").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.appliedTag = tmp
end

---@private
function UIGuildInfoView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Center/PeopleList
--]]
	local tmp = Root:Find("UIAnimator/Window/Center/PeopleList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.peopleList = tmp

	tmp.loopListView = tmp:GetComponent(Enum.TypeInfo.LoopListView)
end

---@private
function UIGuildInfoView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Center/PeopleList/Viewport/Content/GuildPeopleItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Center/PeopleList/Viewport/Content/GuildPeopleItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildPeopleItem = CommonUtil.BindGridViewItem2LuaStatic("GuildPeopleItem", tmp)
	self.guildPeopleItem.prefabName = "GuildPeopleItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildInfoView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/Center/PeopleList/Viewport/Content/LoadingItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Center/PeopleList/Viewport/Content/LoadingItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loadingItem = CommonUtil.BindGridViewItem2LuaStatic("LoadingItem", tmp)
	self.loadingItem.prefabName = "LoadingItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIGuildInfoView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/Bottom
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottom = tmp
end

---@private
function UIGuildInfoView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/Bottom/BottomRoot
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BottomRoot").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottomRoot = tmp
end

---@private
function UIGuildInfoView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnEnter
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnEnter").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnEnter = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildInfoView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnEnter/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnEnter/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnEnter.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIGuildInfoView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/Bottom/BtnCancel
--]]
	local tmp = Root:Find("UIAnimator/Window/Bottom/BtnCancel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCancel = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildInfoView:GenerateDestroy()
	if tolua.getpeer(self.btnEnter.text) ~= nil then
		tolua.setpeer(self.btnEnter.text, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if self.guildBadgeItem.GenerateDestroy ~= nil then
		self.guildBadgeItem:GenerateDestroy()
	end
	if tolua.getpeer(self.guildBadgeItem) ~= nil then
		tolua.setpeer(self.guildBadgeItem, nil)
	end
	self.guildBadgeItem = nil
	if tolua.getpeer(self.nameTxt) ~= nil then
		tolua.setpeer(self.nameTxt, nil)
	end
	self.nameTxt = nil
	if tolua.getpeer(self.lvTxt) ~= nil then
		tolua.setpeer(self.lvTxt, nil)
	end
	self.lvTxt = nil
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.idTxt) ~= nil then
		tolua.setpeer(self.idTxt, nil)
	end
	self.idTxt = nil
	if tolua.getpeer(self.activeTxt) ~= nil then
		tolua.setpeer(self.activeTxt, nil)
	end
	self.activeTxt = nil
	if tolua.getpeer(self.noticeTxt) ~= nil then
		tolua.setpeer(self.noticeTxt, nil)
	end
	self.noticeTxt = nil
	if tolua.getpeer(self.enterLimitTxt) ~= nil then
		tolua.setpeer(self.enterLimitTxt, nil)
	end
	self.enterLimitTxt = nil
	if tolua.getpeer(self.peopleTxt) ~= nil then
		tolua.setpeer(self.peopleTxt, nil)
	end
	self.peopleTxt = nil
	if tolua.getpeer(self.verifyTypeTxt) ~= nil then
		tolua.setpeer(self.verifyTypeTxt, nil)
	end
	self.verifyTypeTxt = nil
	if tolua.getpeer(self.appliedTag) ~= nil then
		tolua.setpeer(self.appliedTag, nil)
	end
	self.appliedTag = nil
	if tolua.getpeer(self.peopleList) ~= nil then
		tolua.setpeer(self.peopleList, nil)
	end
	self.peopleList = nil
	if self.guildPeopleItem.GenerateDestroy ~= nil then
		self.guildPeopleItem:GenerateDestroy()
	end
	if tolua.getpeer(self.guildPeopleItem) ~= nil then
		tolua.setpeer(self.guildPeopleItem, nil)
	end
	self.guildPeopleItem = nil
	if self.loadingItem.GenerateDestroy ~= nil then
		self.loadingItem:GenerateDestroy()
	end
	if tolua.getpeer(self.loadingItem) ~= nil then
		tolua.setpeer(self.loadingItem, nil)
	end
	self.loadingItem = nil
	if tolua.getpeer(self.bottom) ~= nil then
		tolua.setpeer(self.bottom, nil)
	end
	self.bottom = nil
	if tolua.getpeer(self.bottomRoot) ~= nil then
		tolua.setpeer(self.bottomRoot, nil)
	end
	self.bottomRoot = nil
	if tolua.getpeer(self.btnEnter) ~= nil then
		tolua.setpeer(self.btnEnter, nil)
	end
	self.btnEnter = nil
	if tolua.getpeer(self.btnCancel) ~= nil then
		tolua.setpeer(self.btnCancel, nil)
	end
	self.btnCancel = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildInfoView