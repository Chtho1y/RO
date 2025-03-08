---@class UISettings__Generate_verText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISettings__Generate_sound_toggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UISettings__Generate_sound_slider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class UISettings__Generate_sound
---@field public gameObject UnityEngine.GameObject
---@field public slider UISettings__Generate_sound_slider
---@field public toggle UISettings__Generate_sound_toggle

---@class UISettings__Generate_music_toggle
---@field public gameObject UnityEngine.GameObject
---@field public toggle UnityEngine.UI.Toggle

---@class UISettings__Generate_music_slider
---@field public gameObject UnityEngine.GameObject
---@field public slider UnityEngine.UI.Slider

---@class UISettings__Generate_music
---@field public gameObject UnityEngine.GameObject
---@field public slider UISettings__Generate_music_slider
---@field public toggle UISettings__Generate_music_toggle

---@class UISettings__Generate_changeServerButton
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISettings__Generate_serverNameTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UISettings__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISettings__Generate_alpha
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISettings__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UISettings__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UISettings__Generate_uIAnimator
---@field private alpha UISettings__Generate_alpha
---@field private window UnityEngine.GameObject
---@field private btnClose UISettings__Generate_btnClose
---@field private serverNameTxt UISettings__Generate_serverNameTxt
---@field private changeServerButton UISettings__Generate_changeServerButton
---@field private music UISettings__Generate_music
---@field private sound UISettings__Generate_sound
---@field private verText UISettings__Generate_verText
local UISettingsView = class("UISettingsView", require("UIViewBase"))

function UISettingsView:ctor()
end

---@private
function UISettingsView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISettingsView:InitGenerate(Root, data)
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


end

---@private
function UISettingsView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UISettingsView:InitGenerate__2(Root, data)
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
function UISettingsView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.alpha = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISettingsView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window
--]]
	local tmp = Root:Find("UIAnimator/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp
end

---@private
function UISettingsView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/Bg/CloseBox/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/CloseBox/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISettingsView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Bg/ServerInfo/ServerNameTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ServerInfo/ServerNameTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.serverNameTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISettingsView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Bg/ServerInfo/ChangeServerButton
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/ServerInfo/ChangeServerButton").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.changeServerButton = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISettingsView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Bg/VolumeSettings/Music
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/VolumeSettings/Music").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.music = tmp
end

---@private
function UISettingsView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Bg/VolumeSettings/Music/Slider
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/VolumeSettings/Music/Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.music.slider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function UISettingsView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Bg/VolumeSettings/Music/Toggle
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/VolumeSettings/Music/Toggle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.music.toggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UISettingsView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Bg/VolumeSettings/Sound
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/VolumeSettings/Sound").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.sound = tmp
end

---@private
function UISettingsView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Bg/VolumeSettings/Sound/Slider
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/VolumeSettings/Sound/Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.sound.slider = tmp

	tmp.slider = tmp:GetComponent(Enum.TypeInfo.Slider)
end

---@private
function UISettingsView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Bg/VolumeSettings/Sound/Toggle
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/VolumeSettings/Sound/Toggle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.sound.toggle = tmp

	tmp.toggle = tmp:GetComponent(Enum.TypeInfo.Toggle)
end

---@private
function UISettingsView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Bg/VerBox/VerText
--]]
	local tmp = Root:Find("UIAnimator/Window/Bg/VerBox/VerText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.verText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UISettingsView:GenerateDestroy()
	if tolua.getpeer(self.sound.toggle) ~= nil then
		tolua.setpeer(self.sound.toggle, nil)
	end
	if tolua.getpeer(self.sound.slider) ~= nil then
		tolua.setpeer(self.sound.slider, nil)
	end
	if tolua.getpeer(self.music.toggle) ~= nil then
		tolua.setpeer(self.music.toggle, nil)
	end
	if tolua.getpeer(self.music.slider) ~= nil then
		tolua.setpeer(self.music.slider, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.alpha) ~= nil then
		tolua.setpeer(self.alpha, nil)
	end
	self.alpha = nil
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	if tolua.getpeer(self.serverNameTxt) ~= nil then
		tolua.setpeer(self.serverNameTxt, nil)
	end
	self.serverNameTxt = nil
	if tolua.getpeer(self.changeServerButton) ~= nil then
		tolua.setpeer(self.changeServerButton, nil)
	end
	self.changeServerButton = nil
	if tolua.getpeer(self.music) ~= nil then
		tolua.setpeer(self.music, nil)
	end
	self.music = nil
	if tolua.getpeer(self.sound) ~= nil then
		tolua.setpeer(self.sound, nil)
	end
	self.sound = nil
	if tolua.getpeer(self.verText) ~= nil then
		tolua.setpeer(self.verText, nil)
	end
	self.verText = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISettingsView