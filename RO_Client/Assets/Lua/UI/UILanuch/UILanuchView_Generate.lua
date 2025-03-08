---@class UILanuch__Generate_scrollbar
---@field public gameObject UnityEngine.GameObject
---@field public scrollbar UnityEngine.UI.Scrollbar

---@class UILanuch__Generate_numberText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UILanuch__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UILanuch__Generate_editionTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UILanuch__Generate_resVol_contentTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UILanuch__Generate_resVol
---@field public gameObject UnityEngine.GameObject
---@field public contentTxt UILanuch__Generate_resVol_contentTxt

---@class UILanuch__Generate_appVol_contentTxt
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UILanuch__Generate_appVol
---@field public gameObject UnityEngine.GameObject
---@field public contentTxt UILanuch__Generate_appVol_contentTxt

---@class UILanuch__Generate_btnPageAD
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UILanuch__Generate_btnCreateDesktop
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UILanuch__Generate_btnBindTicktok
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UILanuch__Generate_btnStopRecord
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UILanuch__Generate_btnStartRecord
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UILanuch__Generate_btnShare
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UILanuch__Generate_btnCADPA
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UILanuch__Generate_agreement_toggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UILanuch__Generate_agreement_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI
---@field public button UnityEngine.UI.Button

---@class UILanuch__Generate_agreement
---@field public gameObject UnityEngine.GameObject
---@field public text UILanuch__Generate_agreement_text
---@field public toggle UILanuch__Generate_agreement_toggle

---@class UILanuch__Generate_btnNotice
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UILanuch__Generate_serverText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UILanuch__Generate_btnServer
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UILanuch__Generate_serverRoot
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UILanuch__Generate_btnEnter
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UILanuch__Generate_createRoleImg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UILanuch__Generate_loginAnim
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UILanuch__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private loginAnim UILanuch__Generate_loginAnim
---@field private loginBG UnityEngine.GameObject
---@field private createRoleImg UILanuch__Generate_createRoleImg
---@field private logo UnityEngine.GameObject
---@field private mask UnityEngine.GameObject
---@field private loginRoot UnityEngine.GameObject
---@field private btnEnter UILanuch__Generate_btnEnter
---@field private serverRoot UILanuch__Generate_serverRoot
---@field private btnServer UILanuch__Generate_btnServer
---@field private serverText UILanuch__Generate_serverText
---@field private loadingServer UnityEngine.GameObject
---@field private btnNotice UILanuch__Generate_btnNotice
---@field private bg UnityEngine.GameObject
---@field private agreement UILanuch__Generate_agreement
---@field private btnCADPA UILanuch__Generate_btnCADPA
---@field private btnShare UILanuch__Generate_btnShare
---@field private btnStartRecord UILanuch__Generate_btnStartRecord
---@field private btnStopRecord UILanuch__Generate_btnStopRecord
---@field private btnBindTicktok UILanuch__Generate_btnBindTicktok
---@field private btnCreateDesktop UILanuch__Generate_btnCreateDesktop
---@field private btnPageAD UILanuch__Generate_btnPageAD
---@field private appVol UILanuch__Generate_appVol
---@field private resVol UILanuch__Generate_resVol
---@field private editionTxt UILanuch__Generate_editionTxt
---@field private loadingRoot UnityEngine.GameObject
---@field private text UILanuch__Generate_text
---@field private numberText UILanuch__Generate_numberText
---@field private scrollbar UILanuch__Generate_scrollbar
local UILanuchView = class("UILanuchView", require("UIViewBase"))

function UILanuchView:ctor()
end

---@private
function UILanuchView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UILanuchView:InitGenerate(Root, data)
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
	self:InitGenerate__22(Root,data)
	self:InitGenerate__23(Root,data)
	self:InitGenerate__24(Root,data)
	self:InitGenerate__25(Root,data)
	self:InitGenerate__26(Root,data)
	self:InitGenerate__27(Root,data)
	self:InitGenerate__28(Root,data)
	self:InitGenerate__29(Root,data)
	self:InitGenerate__30(Root,data)
	self:InitGenerate__31(Root,data)
	self:InitGenerate__32(Root,data)


end

---@private
function UILanuchView:InitGenerate__1(Root, data)
--[[
	LoginAnim
--]]
	local tmp = Root:Find("LoginAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loginAnim = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UILanuchView:InitGenerate__2(Root, data)
--[[
	LoginAnim/LoginBG
--]]
	local tmp = Root:Find("LoginAnim/LoginBG").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loginBG = tmp
end

---@private
function UILanuchView:InitGenerate__3(Root, data)
--[[
	LoginAnim/LoginBG/CreateRoleImg
--]]
	local tmp = Root:Find("LoginAnim/LoginBG/CreateRoleImg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.createRoleImg = tmp
	self.createRoleImg:SetActive(false)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UILanuchView:InitGenerate__4(Root, data)
--[[
	LoginAnim/Logo
--]]
	local tmp = Root:Find("LoginAnim/Logo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.logo = tmp
end

---@private
function UILanuchView:InitGenerate__5(Root, data)
--[[
	LoginAnim/Logo/Mask
--]]
	local tmp = Root:Find("LoginAnim/Logo/Mask").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mask = tmp
end

---@private
function UILanuchView:InitGenerate__6(Root, data)
--[[
	LoginAnim/LoginRoot
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loginRoot = tmp
end

---@private
function UILanuchView:InitGenerate__7(Root, data)
--[[
	LoginAnim/LoginRoot/BtnEnter
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/BtnEnter").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnEnter = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UILanuchView:InitGenerate__8(Root, data)
--[[
	LoginAnim/LoginRoot/ServerRoot
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/ServerRoot").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.serverRoot = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UILanuchView:InitGenerate__9(Root, data)
--[[
	LoginAnim/LoginRoot/ServerRoot/BtnServer
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/ServerRoot/BtnServer").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnServer = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UILanuchView:InitGenerate__10(Root, data)
--[[
	LoginAnim/LoginRoot/ServerRoot/BtnServer/blue/ServerText
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/ServerRoot/BtnServer/blue/ServerText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.serverText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UILanuchView:InitGenerate__11(Root, data)
--[[
	LoginAnim/LoginRoot/ServerRoot/LoadingServer
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/ServerRoot/LoadingServer").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loadingServer = tmp
end

---@private
function UILanuchView:InitGenerate__12(Root, data)
--[[
	LoginAnim/LoginRoot/BtnNotice
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/BtnNotice").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnNotice = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UILanuchView:InitGenerate__13(Root, data)
--[[
	LoginAnim/LoginRoot/BtnNotice/bg
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/BtnNotice/bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp
end

---@private
function UILanuchView:InitGenerate__14(Root, data)
--[[
	LoginAnim/LoginRoot/Agreement
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/Agreement").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.agreement = tmp
end

---@private
function UILanuchView:InitGenerate__15(Root, data)
--[[
	LoginAnim/LoginRoot/Agreement/Text
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/Agreement/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.agreement.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UILanuchView:InitGenerate__16(Root, data)
--[[
	LoginAnim/LoginRoot/Agreement/Toggle
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/Agreement/Toggle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.agreement.toggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UILanuchView:InitGenerate__17(Root, data)
--[[
	LoginAnim/LoginRoot/BtnCADPA
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/BtnCADPA").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCADPA = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UILanuchView:InitGenerate__18(Root, data)
--[[
	LoginAnim/LoginRoot/BtnShare
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/BtnShare").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnShare = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UILanuchView:InitGenerate__19(Root, data)
--[[
	LoginAnim/LoginRoot/BtnStartRecord
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/BtnStartRecord").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnStartRecord = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UILanuchView:InitGenerate__20(Root, data)
--[[
	LoginAnim/LoginRoot/BtnStopRecord
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/BtnStopRecord").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnStopRecord = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UILanuchView:InitGenerate__21(Root, data)
--[[
	LoginAnim/LoginRoot/BtnBindTicktok
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/BtnBindTicktok").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBindTicktok = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UILanuchView:InitGenerate__22(Root, data)
--[[
	LoginAnim/LoginRoot/BtnCreateDesktop
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/BtnCreateDesktop").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCreateDesktop = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UILanuchView:InitGenerate__23(Root, data)
--[[
	LoginAnim/LoginRoot/BtnPageAD
--]]
	local tmp = Root:Find("LoginAnim/LoginRoot/BtnPageAD").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPageAD = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UILanuchView:InitGenerate__24(Root, data)
--[[
	LoginAnim/Common/AppVol
--]]
	local tmp = Root:Find("LoginAnim/Common/AppVol").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.appVol = tmp
end

---@private
function UILanuchView:InitGenerate__25(Root, data)
--[[
	LoginAnim/Common/AppVol/ContentTxt
--]]
	local tmp = Root:Find("LoginAnim/Common/AppVol/ContentTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.appVol.contentTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UILanuchView:InitGenerate__26(Root, data)
--[[
	LoginAnim/Common/ResVol
--]]
	local tmp = Root:Find("LoginAnim/Common/ResVol").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.resVol = tmp
end

---@private
function UILanuchView:InitGenerate__27(Root, data)
--[[
	LoginAnim/Common/ResVol/ContentTxt
--]]
	local tmp = Root:Find("LoginAnim/Common/ResVol/ContentTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.resVol.contentTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UILanuchView:InitGenerate__28(Root, data)
--[[
	LoginAnim/Common/EditionTxt
--]]
	local tmp = Root:Find("LoginAnim/Common/EditionTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.editionTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UILanuchView:InitGenerate__29(Root, data)
--[[
	LoginAnim/LoadingRoot
--]]
	local tmp = Root:Find("LoginAnim/LoadingRoot").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.loadingRoot = tmp
end

---@private
function UILanuchView:InitGenerate__30(Root, data)
--[[
	LoginAnim/LoadingRoot/LoadingBar/Text
--]]
	local tmp = Root:Find("LoginAnim/LoadingRoot/LoadingBar/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UILanuchView:InitGenerate__31(Root, data)
--[[
	LoginAnim/LoadingRoot/LoadingBar/NumberText
--]]
	local tmp = Root:Find("LoginAnim/LoadingRoot/LoadingBar/NumberText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.numberText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UILanuchView:InitGenerate__32(Root, data)
--[[
	LoginAnim/LoadingRoot/LoadingBar/Scrollbar
--]]
	local tmp = Root:Find("LoginAnim/LoadingRoot/LoadingBar/Scrollbar").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollbar = tmp

	tmp.scrollbar = tmp:GetComponent(Enum.TypeInfo.Scrollbar)
end

---@private
function UILanuchView:GenerateDestroy()
	if tolua.getpeer(self.resVol.contentTxt) ~= nil then
		tolua.setpeer(self.resVol.contentTxt, nil)
	end
	if tolua.getpeer(self.appVol.contentTxt) ~= nil then
		tolua.setpeer(self.appVol.contentTxt, nil)
	end
	if tolua.getpeer(self.agreement.toggle) ~= nil then
		tolua.setpeer(self.agreement.toggle, nil)
	end
	if tolua.getpeer(self.agreement.text) ~= nil then
		tolua.setpeer(self.agreement.text, nil)
	end
	if tolua.getpeer(self.loginAnim) ~= nil then
		tolua.setpeer(self.loginAnim, nil)
	end
	self.loginAnim = nil
	if tolua.getpeer(self.loginBG) ~= nil then
		tolua.setpeer(self.loginBG, nil)
	end
	self.loginBG = nil
	if tolua.getpeer(self.createRoleImg) ~= nil then
		tolua.setpeer(self.createRoleImg, nil)
	end
	self.createRoleImg = nil
	if tolua.getpeer(self.logo) ~= nil then
		tolua.setpeer(self.logo, nil)
	end
	self.logo = nil
	if tolua.getpeer(self.mask) ~= nil then
		tolua.setpeer(self.mask, nil)
	end
	self.mask = nil
	if tolua.getpeer(self.loginRoot) ~= nil then
		tolua.setpeer(self.loginRoot, nil)
	end
	self.loginRoot = nil
	if tolua.getpeer(self.btnEnter) ~= nil then
		tolua.setpeer(self.btnEnter, nil)
	end
	self.btnEnter = nil
	if tolua.getpeer(self.serverRoot) ~= nil then
		tolua.setpeer(self.serverRoot, nil)
	end
	self.serverRoot = nil
	if tolua.getpeer(self.btnServer) ~= nil then
		tolua.setpeer(self.btnServer, nil)
	end
	self.btnServer = nil
	if tolua.getpeer(self.serverText) ~= nil then
		tolua.setpeer(self.serverText, nil)
	end
	self.serverText = nil
	if tolua.getpeer(self.loadingServer) ~= nil then
		tolua.setpeer(self.loadingServer, nil)
	end
	self.loadingServer = nil
	if tolua.getpeer(self.btnNotice) ~= nil then
		tolua.setpeer(self.btnNotice, nil)
	end
	self.btnNotice = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.agreement) ~= nil then
		tolua.setpeer(self.agreement, nil)
	end
	self.agreement = nil
	if tolua.getpeer(self.btnCADPA) ~= nil then
		tolua.setpeer(self.btnCADPA, nil)
	end
	self.btnCADPA = nil
	if tolua.getpeer(self.btnShare) ~= nil then
		tolua.setpeer(self.btnShare, nil)
	end
	self.btnShare = nil
	if tolua.getpeer(self.btnStartRecord) ~= nil then
		tolua.setpeer(self.btnStartRecord, nil)
	end
	self.btnStartRecord = nil
	if tolua.getpeer(self.btnStopRecord) ~= nil then
		tolua.setpeer(self.btnStopRecord, nil)
	end
	self.btnStopRecord = nil
	if tolua.getpeer(self.btnBindTicktok) ~= nil then
		tolua.setpeer(self.btnBindTicktok, nil)
	end
	self.btnBindTicktok = nil
	if tolua.getpeer(self.btnCreateDesktop) ~= nil then
		tolua.setpeer(self.btnCreateDesktop, nil)
	end
	self.btnCreateDesktop = nil
	if tolua.getpeer(self.btnPageAD) ~= nil then
		tolua.setpeer(self.btnPageAD, nil)
	end
	self.btnPageAD = nil
	if tolua.getpeer(self.appVol) ~= nil then
		tolua.setpeer(self.appVol, nil)
	end
	self.appVol = nil
	if tolua.getpeer(self.resVol) ~= nil then
		tolua.setpeer(self.resVol, nil)
	end
	self.resVol = nil
	if tolua.getpeer(self.editionTxt) ~= nil then
		tolua.setpeer(self.editionTxt, nil)
	end
	self.editionTxt = nil
	if tolua.getpeer(self.loadingRoot) ~= nil then
		tolua.setpeer(self.loadingRoot, nil)
	end
	self.loadingRoot = nil
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.numberText) ~= nil then
		tolua.setpeer(self.numberText, nil)
	end
	self.numberText = nil
	if tolua.getpeer(self.scrollbar) ~= nil then
		tolua.setpeer(self.scrollbar, nil)
	end
	self.scrollbar = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UILanuchView