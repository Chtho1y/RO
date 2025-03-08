---@class UIMainCity1__Generate_redEnvelope_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIMainCity1__Generate_redEnvelope_btnSmall
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_redEnvelope
---@field public gameObject UnityEngine.GameObject
---@field public btnSmall UIMainCity1__Generate_redEnvelope_btnSmall
---@field public text UIMainCity1__Generate_redEnvelope_text

---@class UIMainCity1__Generate_btnNotifyActivity
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnMail
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnSummon
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnEquipForge
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnFashion
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnGuild
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnCard
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnFriend
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnKapula
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnSign
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnExpedition
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnWorldBoss
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnEvil
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnAirship
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnArena
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnDojo
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_btnClimbingTower
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIMainCity1__Generate_cityRoot
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect

---@class UIMainCity1__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private cityRoot UIMainCity1__Generate_cityRoot
---@field private btnClimbingTower UIMainCity1__Generate_btnClimbingTower
---@field private btnDojo UIMainCity1__Generate_btnDojo
---@field private btnArena UIMainCity1__Generate_btnArena
---@field private btnAirship UIMainCity1__Generate_btnAirship
---@field private btnEvil UIMainCity1__Generate_btnEvil
---@field private btnWorldBoss UIMainCity1__Generate_btnWorldBoss
---@field private btnExpedition UIMainCity1__Generate_btnExpedition
---@field private btnSign UIMainCity1__Generate_btnSign
---@field private btnKapula UIMainCity1__Generate_btnKapula
---@field private btnFriend UIMainCity1__Generate_btnFriend
---@field private btnCard UIMainCity1__Generate_btnCard
---@field private btnGuild UIMainCity1__Generate_btnGuild
---@field private btnFashion UIMainCity1__Generate_btnFashion
---@field private imageEquip UnityEngine.GameObject
---@field private btnEquipForge UIMainCity1__Generate_btnEquipForge
---@field private btnSummon UIMainCity1__Generate_btnSummon
---@field private btnMail UIMainCity1__Generate_btnMail
---@field private btnNotifyActivity UIMainCity1__Generate_btnNotifyActivity
---@field private middleView UnityEngine.GameObject
---@field private redEnvelope UIMainCity1__Generate_redEnvelope
local UIMainCity1View = class("UIMainCity1View", require("UIViewBase"))

function UIMainCity1View:ctor()
end

---@private
function UIMainCity1View:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIMainCity1View:InitGenerate(Root, data)
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


end

---@private
function UIMainCity1View:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UIMainCity1View:InitGenerate__2(Root, data)
--[[
	MainCityRoot/CityRoot
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cityRoot = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)
end

---@private
function UIMainCity1View:InitGenerate__3(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor8/FloorRoot/Image02/btnClimbingTower
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor8/FloorRoot/Image02/btnClimbingTower").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClimbingTower = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__4(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor8/FloorRoot/Image03/btnDojo
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor8/FloorRoot/Image03/btnDojo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnDojo = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__5(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor8/FloorRoot/Image04/Flot/btnArena
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor8/FloorRoot/Image04/Flot/btnArena").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnArena = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__6(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor8/FloorRoot/Image05/Flot/btnAirship
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor8/FloorRoot/Image05/Flot/btnAirship").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnAirship = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__7(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor6/FloorRoot/Image01/btnEvil
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor6/FloorRoot/Image01/btnEvil").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnEvil = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__8(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor6/FloorRoot/Image02/btnWorldBoss
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor6/FloorRoot/Image02/btnWorldBoss").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnWorldBoss = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__9(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor5/FloorRoot/btnExpedition
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor5/FloorRoot/btnExpedition").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnExpedition = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__10(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor5/FloorRoot/btnSign
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor5/FloorRoot/btnSign").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSign = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__11(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor5/FloorRoot/btnKapula
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor5/FloorRoot/btnKapula").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnKapula = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__12(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor5/FloorRoot/btnFriend
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor5/FloorRoot/btnFriend").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnFriend = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__13(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor4/FloorRoot/HouseRight/btnCard
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor4/FloorRoot/HouseRight/btnCard").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCard = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__14(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor4/FloorRoot/HouseRight/btnGuild
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor4/FloorRoot/HouseRight/btnGuild").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnGuild = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__15(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor4/FloorRoot/HouseLeft/btnFashion
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor4/FloorRoot/HouseLeft/btnFashion").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnFashion = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__16(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor4/FloorRoot/HouseLeft/ImageEquip
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor4/FloorRoot/HouseLeft/ImageEquip").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.imageEquip = tmp
end

---@private
function UIMainCity1View:InitGenerate__17(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor4/FloorRoot/HouseLeft/btnEquipForge
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor4/FloorRoot/HouseLeft/btnEquipForge").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnEquipForge = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__18(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor4/FloorRoot/btnSummon
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor4/FloorRoot/btnSummon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSummon = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__19(Root, data)
--[[
	MainCityRoot/CityRoot/Viewport/bg/floor3/FloorRoot/btnMail
--]]
	local tmp = Root:Find("MainCityRoot/CityRoot/Viewport/bg/floor3/FloorRoot/btnMail").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnMail = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__20(Root, data)
--[[
	TopView/TopBtns/BtnNotifyActivity
--]]
	local tmp = Root:Find("TopView/TopBtns/BtnNotifyActivity").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnNotifyActivity = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__21(Root, data)
--[[
	MiddleView
--]]
	local tmp = Root:Find("MiddleView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.middleView = tmp
end

---@private
function UIMainCity1View:InitGenerate__22(Root, data)
--[[
	MiddleView/RedEnvelope
--]]
	local tmp = Root:Find("MiddleView/RedEnvelope").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redEnvelope = tmp
end

---@private
function UIMainCity1View:InitGenerate__23(Root, data)
--[[
	MiddleView/RedEnvelope/BtnSmall
--]]
	local tmp = Root:Find("MiddleView/RedEnvelope/BtnSmall").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redEnvelope.btnSmall = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIMainCity1View:InitGenerate__24(Root, data)
--[[
	MiddleView/RedEnvelope/BtnSmall/Timer/Text
--]]
	local tmp = Root:Find("MiddleView/RedEnvelope/BtnSmall/Timer/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redEnvelope.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIMainCity1View:GenerateDestroy()
	if tolua.getpeer(self.redEnvelope.text) ~= nil then
		tolua.setpeer(self.redEnvelope.text, nil)
	end
	if tolua.getpeer(self.redEnvelope.btnSmall) ~= nil then
		tolua.setpeer(self.redEnvelope.btnSmall, nil)
	end
	if tolua.getpeer(self.cityRoot) ~= nil then
		tolua.setpeer(self.cityRoot, nil)
	end
	self.cityRoot = nil
	if tolua.getpeer(self.btnClimbingTower) ~= nil then
		tolua.setpeer(self.btnClimbingTower, nil)
	end
	self.btnClimbingTower = nil
	if tolua.getpeer(self.btnDojo) ~= nil then
		tolua.setpeer(self.btnDojo, nil)
	end
	self.btnDojo = nil
	if tolua.getpeer(self.btnArena) ~= nil then
		tolua.setpeer(self.btnArena, nil)
	end
	self.btnArena = nil
	if tolua.getpeer(self.btnAirship) ~= nil then
		tolua.setpeer(self.btnAirship, nil)
	end
	self.btnAirship = nil
	if tolua.getpeer(self.btnEvil) ~= nil then
		tolua.setpeer(self.btnEvil, nil)
	end
	self.btnEvil = nil
	if tolua.getpeer(self.btnWorldBoss) ~= nil then
		tolua.setpeer(self.btnWorldBoss, nil)
	end
	self.btnWorldBoss = nil
	if tolua.getpeer(self.btnExpedition) ~= nil then
		tolua.setpeer(self.btnExpedition, nil)
	end
	self.btnExpedition = nil
	if tolua.getpeer(self.btnSign) ~= nil then
		tolua.setpeer(self.btnSign, nil)
	end
	self.btnSign = nil
	if tolua.getpeer(self.btnKapula) ~= nil then
		tolua.setpeer(self.btnKapula, nil)
	end
	self.btnKapula = nil
	if tolua.getpeer(self.btnFriend) ~= nil then
		tolua.setpeer(self.btnFriend, nil)
	end
	self.btnFriend = nil
	if tolua.getpeer(self.btnCard) ~= nil then
		tolua.setpeer(self.btnCard, nil)
	end
	self.btnCard = nil
	if tolua.getpeer(self.btnGuild) ~= nil then
		tolua.setpeer(self.btnGuild, nil)
	end
	self.btnGuild = nil
	if tolua.getpeer(self.btnFashion) ~= nil then
		tolua.setpeer(self.btnFashion, nil)
	end
	self.btnFashion = nil
	if tolua.getpeer(self.imageEquip) ~= nil then
		tolua.setpeer(self.imageEquip, nil)
	end
	self.imageEquip = nil
	if tolua.getpeer(self.btnEquipForge) ~= nil then
		tolua.setpeer(self.btnEquipForge, nil)
	end
	self.btnEquipForge = nil
	if tolua.getpeer(self.btnSummon) ~= nil then
		tolua.setpeer(self.btnSummon, nil)
	end
	self.btnSummon = nil
	if tolua.getpeer(self.btnMail) ~= nil then
		tolua.setpeer(self.btnMail, nil)
	end
	self.btnMail = nil
	if tolua.getpeer(self.btnNotifyActivity) ~= nil then
		tolua.setpeer(self.btnNotifyActivity, nil)
	end
	self.btnNotifyActivity = nil
	if tolua.getpeer(self.middleView) ~= nil then
		tolua.setpeer(self.middleView, nil)
	end
	self.middleView = nil
	if tolua.getpeer(self.redEnvelope) ~= nil then
		tolua.setpeer(self.redEnvelope, nil)
	end
	self.redEnvelope = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIMainCity1View