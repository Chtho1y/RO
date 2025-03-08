---@class CloudTop__Generate_levelSlider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class CloudTop__Generate_btnBuyMore_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class CloudTop__Generate_chestAnim
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class CloudTop__Generate_btnBuyMore
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public num CloudTop__Generate_btnBuyMore_num

---@class CloudTop__Generate_dsc_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class CloudTop__Generate_dsc
---@field public gameObject UnityEngine.GameObject
---@field public text CloudTop__Generate_dsc_text

---@class CloudTop__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private dsc CloudTop__Generate_dsc
---@field private btnBuyMore CloudTop__Generate_btnBuyMore
---@field private chestAnim CloudTop__Generate_chestAnim
---@field private redPoint UnityEngine.GameObject
---@field private levelBox UnityEngine.GameObject
---@field private levelSlider CloudTop__Generate_levelSlider
---@field private airShip UnityEngine.GameObject
local CloudTopView = class("CloudTopView")

function CloudTopView:ctor()
end

---@private
function CloudTopView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function CloudTopView:InitGenerate(Root, data)
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


end

---@private
function CloudTopView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function CloudTopView:InitGenerate__2(Root, data)
--[[
	CloudAnim/Dsc
--]]
	local tmp = Root:Find("CloudAnim/Dsc").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dsc = tmp
end

---@private
function CloudTopView:InitGenerate__3(Root, data)
--[[
	CloudAnim/Dsc/Text
--]]
	local tmp = Root:Find("CloudAnim/Dsc/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dsc.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function CloudTopView:InitGenerate__4(Root, data)
--[[
	CloudAnim/BtnBuyMore
--]]
	local tmp = Root:Find("CloudAnim/BtnBuyMore").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBuyMore = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function CloudTopView:InitGenerate__5(Root, data)
--[[
	CloudAnim/BtnBuyMore/ChestAnim
--]]
	local tmp = Root:Find("CloudAnim/BtnBuyMore/ChestAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.chestAnim = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function CloudTopView:InitGenerate__6(Root, data)
--[[
	CloudAnim/BtnBuyMore/RedPoint
--]]
	local tmp = Root:Find("CloudAnim/BtnBuyMore/RedPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redPoint = tmp
end

---@private
function CloudTopView:InitGenerate__7(Root, data)
--[[
	CloudAnim/BtnBuyMore/RedPoint/Text
--]]
	local tmp = Root:Find("CloudAnim/BtnBuyMore/RedPoint/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBuyMore.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function CloudTopView:InitGenerate__8(Root, data)
--[[
	LevelBox
--]]
	local tmp = Root:Find("LevelBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.levelBox = tmp
end

---@private
function CloudTopView:InitGenerate__9(Root, data)
--[[
	LevelBox/LevelSlider
--]]
	local tmp = Root:Find("LevelBox/LevelSlider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.levelSlider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function CloudTopView:InitGenerate__10(Root, data)
--[[
	LevelBox/LevelSlider/AirShip
--]]
	local tmp = Root:Find("LevelBox/LevelSlider/AirShip").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.airShip = CommonUtil.BindGridViewItem2LuaStatic("AirShip", tmp)
	self.airShip.prefabName = "AirShip"
end

---@private
function CloudTopView:GenerateDestroy()
	if tolua.getpeer(self.levelSlider) ~= nil then
		tolua.setpeer(self.levelSlider, nil)
	end
	if tolua.getpeer(self.btnBuyMore.num) ~= nil then
		tolua.setpeer(self.btnBuyMore.num, nil)
	end
	if tolua.getpeer(self.chestAnim) ~= nil then
		tolua.setpeer(self.chestAnim, nil)
	end
	if tolua.getpeer(self.btnBuyMore) ~= nil then
		tolua.setpeer(self.btnBuyMore, nil)
	end
	if tolua.getpeer(self.dsc.text) ~= nil then
		tolua.setpeer(self.dsc.text, nil)
	end
	if tolua.getpeer(self.dsc) ~= nil then
		tolua.setpeer(self.dsc, nil)
	end
	self.dsc = nil
	if tolua.getpeer(self.redPoint) ~= nil then
		tolua.setpeer(self.redPoint, nil)
	end
	self.redPoint = nil
	if tolua.getpeer(self.levelBox) ~= nil then
		tolua.setpeer(self.levelBox, nil)
	end
	self.levelBox = nil
	if self.airShip.GenerateDestroy ~= nil then
		self.airShip:GenerateDestroy()
	end
	if tolua.getpeer(self.airShip) ~= nil then
		tolua.setpeer(self.airShip, nil)
	end
	self.airShip = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return CloudTopView