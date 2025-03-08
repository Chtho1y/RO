---@class UIChapter__Generate_text2
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIChapter__Generate_textC
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIChapter__Generate_logoLt
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIChapter__Generate_logo1
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIChapter__Generate_uICapterAnim
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIChapter__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uICapterAnim UIChapter__Generate_uICapterAnim
---@field private logo1 UIChapter__Generate_logo1
---@field private logoLt UIChapter__Generate_logoLt
---@field private textC UIChapter__Generate_textC
---@field private text2 UIChapter__Generate_text2
local UIChapterView = class("UIChapterView", require("UIViewBase"))

function UIChapterView:ctor()
end

---@private
function UIChapterView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIChapterView:InitGenerate(Root, data)
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


end

---@private
function UIChapterView:InitGenerate__1(Root, data)
--[[
	UICapterAnim
--]]
	local tmp = Root:Find("UICapterAnim").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uICapterAnim = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIChapterView:InitGenerate__2(Root, data)
--[[
	UICapterAnim/MoveBox/Logo/Logo1
--]]
	local tmp = Root:Find("UICapterAnim/MoveBox/Logo/Logo1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.logo1 = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIChapterView:InitGenerate__3(Root, data)
--[[
	UICapterAnim/MoveBox/Logo/LogoLt
--]]
	local tmp = Root:Find("UICapterAnim/MoveBox/Logo/LogoLt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.logoLt = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIChapterView:InitGenerate__4(Root, data)
--[[
	UICapterAnim/MoveBox/TextC
--]]
	local tmp = Root:Find("UICapterAnim/MoveBox/TextC").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.textC = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIChapterView:InitGenerate__5(Root, data)
--[[
	UICapterAnim/MoveBox/TextBox/Text2
--]]
	local tmp = Root:Find("UICapterAnim/MoveBox/TextBox/Text2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text2 = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIChapterView:GenerateDestroy()
	if tolua.getpeer(self.uICapterAnim) ~= nil then
		tolua.setpeer(self.uICapterAnim, nil)
	end
	self.uICapterAnim = nil
	if tolua.getpeer(self.logo1) ~= nil then
		tolua.setpeer(self.logo1, nil)
	end
	self.logo1 = nil
	if tolua.getpeer(self.logoLt) ~= nil then
		tolua.setpeer(self.logoLt, nil)
	end
	self.logoLt = nil
	if tolua.getpeer(self.textC) ~= nil then
		tolua.setpeer(self.textC, nil)
	end
	self.textC = nil
	if tolua.getpeer(self.text2) ~= nil then
		tolua.setpeer(self.text2, nil)
	end
	self.text2 = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIChapterView