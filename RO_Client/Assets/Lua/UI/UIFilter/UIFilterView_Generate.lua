---@class UIFilter__Generate_btnConfirm_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIFilter__Generate_btnConfirm
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIFilter__Generate_btnConfirm_text

---@class UIFilter__Generate_btnReset_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIFilter__Generate_btnReset
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIFilter__Generate_btnReset_text

---@class UIFilter__Generate_typeAllToggle_txt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFilter__Generate_typeAllToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public txt UIFilter__Generate_typeAllToggle_txt

---@class UIFilter__Generate_filter3Name
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIFilter__Generate_attrAllToggle_txt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFilter__Generate_attrAllToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public txt UIFilter__Generate_attrAllToggle_txt

---@class UIFilter__Generate_rarityAllToggle_txt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIFilter__Generate_rarityAllToggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle
---@field public txt UIFilter__Generate_rarityAllToggle_txt

---@class UIFilter__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFilter__Generate_textTitle
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIFilter__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIFilter__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIFilter__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIFilter__Generate_uIAnimator
---@field private AnyBtn UIFilter__Generate_AnyBtn
---@field private textTitle UIFilter__Generate_textTitle
---@field private btnClose UIFilter__Generate_btnClose
---@field private rarityAllToggle UIFilter__Generate_rarityAllToggle
---@field private rarityToggleGrid UnityEngine.GameObject
---@field private attrAllToggle UIFilter__Generate_attrAllToggle
---@field private attrToggleGrid UnityEngine.GameObject
---@field private filter3Name UIFilter__Generate_filter3Name
---@field private typeAllToggle UIFilter__Generate_typeAllToggle
---@field private typeToggleGrid UnityEngine.GameObject
---@field private bottomBox UnityEngine.GameObject
---@field private btnReset UIFilter__Generate_btnReset
---@field private btnConfirm UIFilter__Generate_btnConfirm
local UIFilterView = class("UIFilterView", require("UIViewBase"))

function UIFilterView:ctor()
end

---@private
function UIFilterView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIFilterView:InitGenerate(Root, data)
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


end

---@private
function UIFilterView:InitGenerate__1(Root, data)
--[[
	UIAnimator
--]]
	local tmp = Root:Find("UIAnimator").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIAnimator = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIFilterView:InitGenerate__2(Root, data)
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
function UIFilterView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BG/TextTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TextTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textTitle = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIFilterView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BG/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFilterView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BG/FilterBox/Filter1/Title/toggle
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/FilterBox/Filter1/Title/toggle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rarityAllToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIFilterView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BG/FilterBox/Filter1/Title/toggle/Txt
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/FilterBox/Filter1/Title/toggle/Txt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rarityAllToggle.txt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFilterView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BG/FilterBox/Filter1/grid
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/FilterBox/Filter1/grid").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rarityToggleGrid = tmp
end

---@private
function UIFilterView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BG/FilterBox/Filter2/Title/toggle
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/FilterBox/Filter2/Title/toggle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrAllToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIFilterView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BG/FilterBox/Filter2/Title/toggle/Txt
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/FilterBox/Filter2/Title/toggle/Txt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrAllToggle.txt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFilterView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BG/FilterBox/Filter2/grid
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/FilterBox/Filter2/grid").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.attrToggleGrid = tmp
end

---@private
function UIFilterView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BG/FilterBox/Filter3/Title/name
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/FilterBox/Filter3/Title/name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.filter3Name = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIFilterView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BG/FilterBox/Filter3/Title/toggle
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/FilterBox/Filter3/Title/toggle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.typeAllToggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UIFilterView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BG/FilterBox/Filter3/Title/toggle/Txt
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/FilterBox/Filter3/Title/toggle/Txt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.typeAllToggle.txt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIFilterView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/BG/FilterBox/Filter3/grid
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/FilterBox/Filter3/grid").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.typeToggleGrid = tmp
end

---@private
function UIFilterView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/BG/BottomBox
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BottomBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottomBox = tmp
end

---@private
function UIFilterView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/BG/BottomBox/BtnReset
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BottomBox/BtnReset").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnReset = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFilterView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/BG/BottomBox/BtnReset/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BottomBox/BtnReset/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnReset.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIFilterView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/BG/BottomBox/BtnConfirm
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BottomBox/BtnConfirm").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnConfirm = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIFilterView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/BG/BottomBox/BtnConfirm/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/BottomBox/BtnConfirm/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnConfirm.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIFilterView:GenerateDestroy()
	if tolua.getpeer(self.btnConfirm.text) ~= nil then
		tolua.setpeer(self.btnConfirm.text, nil)
	end
	if tolua.getpeer(self.btnReset.text) ~= nil then
		tolua.setpeer(self.btnReset.text, nil)
	end
	if tolua.getpeer(self.typeAllToggle.txt) ~= nil then
		tolua.setpeer(self.typeAllToggle.txt, nil)
	end
	if tolua.getpeer(self.attrAllToggle.txt) ~= nil then
		tolua.setpeer(self.attrAllToggle.txt, nil)
	end
	if tolua.getpeer(self.rarityAllToggle.txt) ~= nil then
		tolua.setpeer(self.rarityAllToggle.txt, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.textTitle) ~= nil then
		tolua.setpeer(self.textTitle, nil)
	end
	self.textTitle = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.rarityAllToggle) ~= nil then
		tolua.setpeer(self.rarityAllToggle, nil)
	end
	self.rarityAllToggle = nil
	if tolua.getpeer(self.rarityToggleGrid) ~= nil then
		tolua.setpeer(self.rarityToggleGrid, nil)
	end
	self.rarityToggleGrid = nil
	if tolua.getpeer(self.attrAllToggle) ~= nil then
		tolua.setpeer(self.attrAllToggle, nil)
	end
	self.attrAllToggle = nil
	if tolua.getpeer(self.attrToggleGrid) ~= nil then
		tolua.setpeer(self.attrToggleGrid, nil)
	end
	self.attrToggleGrid = nil
	if tolua.getpeer(self.filter3Name) ~= nil then
		tolua.setpeer(self.filter3Name, nil)
	end
	self.filter3Name = nil
	if tolua.getpeer(self.typeAllToggle) ~= nil then
		tolua.setpeer(self.typeAllToggle, nil)
	end
	self.typeAllToggle = nil
	if tolua.getpeer(self.typeToggleGrid) ~= nil then
		tolua.setpeer(self.typeToggleGrid, nil)
	end
	self.typeToggleGrid = nil
	if tolua.getpeer(self.bottomBox) ~= nil then
		tolua.setpeer(self.bottomBox, nil)
	end
	self.bottomBox = nil
	if tolua.getpeer(self.btnReset) ~= nil then
		tolua.setpeer(self.btnReset, nil)
	end
	self.btnReset = nil
	if tolua.getpeer(self.btnConfirm) ~= nil then
		tolua.setpeer(self.btnConfirm, nil)
	end
	self.btnConfirm = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIFilterView