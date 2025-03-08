---@class UIGM__Generate_hideUIBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_dropdown
---@field public gameObject UnityEngine.GameObject
---@field public dropdown UnityEngine.UI.Dropdown

---@class UIGM__Generate_rollEffectBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_forceGuideBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_friendBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_storyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_userNameBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_newbieBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_oneKeyGm
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_btnBack
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_send
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_inputField
---@field public gameObject UnityEngine.GameObject
---@field public inputField UnityEngine.UI.InputField

---@class UIGM__Generate_addFashion
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_addEquip
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_addPartnerExp
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_addHeroJobLv
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_addHeroLv
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate_addGold
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGM__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private addGold UIGM__Generate_addGold
---@field private addHeroLv UIGM__Generate_addHeroLv
---@field private addHeroJobLv UIGM__Generate_addHeroJobLv
---@field private addPartnerExp UIGM__Generate_addPartnerExp
---@field private addEquip UIGM__Generate_addEquip
---@field private addFashion UIGM__Generate_addFashion
---@field private inputField UIGM__Generate_inputField
---@field private send UIGM__Generate_send
---@field private btnBack UIGM__Generate_btnBack
---@field private oneKeyGm UIGM__Generate_oneKeyGm
---@field private newbieBtn UIGM__Generate_newbieBtn
---@field private userNameBtn UIGM__Generate_userNameBtn
---@field private storyBtn UIGM__Generate_storyBtn
---@field private friendBtn UIGM__Generate_friendBtn
---@field private forceGuideBtn UIGM__Generate_forceGuideBtn
---@field private rollEffectBtn UIGM__Generate_rollEffectBtn
---@field private dropdown UIGM__Generate_dropdown
---@field private hideUIBtn UIGM__Generate_hideUIBtn
local UIGMView = class("UIGMView", require("UIViewBase"))

function UIGMView:ctor()
end

---@private
function UIGMView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGMView:InitGenerate(Root, data)
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


end

---@private
function UIGMView:InitGenerate__1(Root, data)
--[[
	AddGold
--]]
	local tmp = Root:Find("AddGold").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addGold = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__2(Root, data)
--[[
	AddHeroLv
--]]
	local tmp = Root:Find("AddHeroLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addHeroLv = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__3(Root, data)
--[[
	AddHeroJobLv
--]]
	local tmp = Root:Find("AddHeroJobLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addHeroJobLv = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__4(Root, data)
--[[
	AddPartnerExp
--]]
	local tmp = Root:Find("AddPartnerExp").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addPartnerExp = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__5(Root, data)
--[[
	AddEquip
--]]
	local tmp = Root:Find("AddEquip").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addEquip = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__6(Root, data)
--[[
	AddFashion
--]]
	local tmp = Root:Find("AddFashion").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.addFashion = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__7(Root, data)
--[[
	InputField
--]]
	local tmp = Root:Find("InputField").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.inputField = tmp

	tmp.inputField = tmp:GetComponent(Enum.TypeInfo.InputField)
end

---@private
function UIGMView:InitGenerate__8(Root, data)
--[[
	Send
--]]
	local tmp = Root:Find("Send").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.send = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__9(Root, data)
--[[
	BtnBack
--]]
	local tmp = Root:Find("BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBack = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__10(Root, data)
--[[
	OneKeyGm
--]]
	local tmp = Root:Find("OneKeyGm").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.oneKeyGm = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__11(Root, data)
--[[
	NewbieBtn
--]]
	local tmp = Root:Find("NewbieBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.newbieBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__12(Root, data)
--[[
	UserNameBtn
--]]
	local tmp = Root:Find("UserNameBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.userNameBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__13(Root, data)
--[[
	StoryBtn
--]]
	local tmp = Root:Find("StoryBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.storyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__14(Root, data)
--[[
	FriendBtn
--]]
	local tmp = Root:Find("FriendBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.friendBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__15(Root, data)
--[[
	ForceGuideBtn
--]]
	local tmp = Root:Find("ForceGuideBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.forceGuideBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__16(Root, data)
--[[
	RollEffectBtn
--]]
	local tmp = Root:Find("RollEffectBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rollEffectBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:InitGenerate__17(Root, data)
--[[
	Dropdown
--]]
	local tmp = Root:Find("Dropdown").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dropdown = tmp

	tmp.dropdown = tmp:GetComponent(Enum.TypeInfo.Dropdown)
end

---@private
function UIGMView:InitGenerate__18(Root, data)
--[[
	HideUIBtn
--]]
	local tmp = Root:Find("HideUIBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.hideUIBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGMView:GenerateDestroy()
	if tolua.getpeer(self.addGold) ~= nil then
		tolua.setpeer(self.addGold, nil)
	end
	self.addGold = nil
	if tolua.getpeer(self.addHeroLv) ~= nil then
		tolua.setpeer(self.addHeroLv, nil)
	end
	self.addHeroLv = nil
	if tolua.getpeer(self.addHeroJobLv) ~= nil then
		tolua.setpeer(self.addHeroJobLv, nil)
	end
	self.addHeroJobLv = nil
	if tolua.getpeer(self.addPartnerExp) ~= nil then
		tolua.setpeer(self.addPartnerExp, nil)
	end
	self.addPartnerExp = nil
	if tolua.getpeer(self.addEquip) ~= nil then
		tolua.setpeer(self.addEquip, nil)
	end
	self.addEquip = nil
	if tolua.getpeer(self.addFashion) ~= nil then
		tolua.setpeer(self.addFashion, nil)
	end
	self.addFashion = nil
	if tolua.getpeer(self.inputField) ~= nil then
		tolua.setpeer(self.inputField, nil)
	end
	self.inputField = nil
	if tolua.getpeer(self.send) ~= nil then
		tolua.setpeer(self.send, nil)
	end
	self.send = nil
	if tolua.getpeer(self.btnBack) ~= nil then
		tolua.setpeer(self.btnBack, nil)
	end
	self.btnBack = nil
	if tolua.getpeer(self.oneKeyGm) ~= nil then
		tolua.setpeer(self.oneKeyGm, nil)
	end
	self.oneKeyGm = nil
	if tolua.getpeer(self.newbieBtn) ~= nil then
		tolua.setpeer(self.newbieBtn, nil)
	end
	self.newbieBtn = nil
	if tolua.getpeer(self.userNameBtn) ~= nil then
		tolua.setpeer(self.userNameBtn, nil)
	end
	self.userNameBtn = nil
	if tolua.getpeer(self.storyBtn) ~= nil then
		tolua.setpeer(self.storyBtn, nil)
	end
	self.storyBtn = nil
	if tolua.getpeer(self.friendBtn) ~= nil then
		tolua.setpeer(self.friendBtn, nil)
	end
	self.friendBtn = nil
	if tolua.getpeer(self.forceGuideBtn) ~= nil then
		tolua.setpeer(self.forceGuideBtn, nil)
	end
	self.forceGuideBtn = nil
	if tolua.getpeer(self.rollEffectBtn) ~= nil then
		tolua.setpeer(self.rollEffectBtn, nil)
	end
	self.rollEffectBtn = nil
	if tolua.getpeer(self.dropdown) ~= nil then
		tolua.setpeer(self.dropdown, nil)
	end
	self.dropdown = nil
	if tolua.getpeer(self.hideUIBtn) ~= nil then
		tolua.setpeer(self.hideUIBtn, nil)
	end
	self.hideUIBtn = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGMView