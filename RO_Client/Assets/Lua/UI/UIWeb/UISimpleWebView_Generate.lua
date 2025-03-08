---@class UISimpleWeb__Generate_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISimpleWeb__Generate_webView
---@field public gameObject UnityEngine.GameObject
---@field public wentingCanvasWebVewPrefab Vuplex.WebView.WentingCanvasWebVewPrefab

---@class UISimpleWeb__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UISimpleWeb__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UISimpleWeb__Generate_AnyBtn
---@field private webView UISimpleWeb__Generate_webView
---@field private btnClose UISimpleWeb__Generate_btnClose
local UISimpleWebView = class("UISimpleWebView", require("UIViewBase"))

function UISimpleWebView:ctor()
end

---@private
function UISimpleWebView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UISimpleWebView:InitGenerate(Root, data)
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


end

---@private
function UISimpleWebView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function UISimpleWebView:InitGenerate__2(Root, data)
--[[
	Alpha
--]]
	local tmp = Root:Find("Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISimpleWebView:InitGenerate__3(Root, data)
--[[
	Window/WebView
--]]
	local tmp = Root:Find("Window/WebView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.webView = tmp

	tmp.wentingCanvasWebVewPrefab = tmp:GetComponent(Enum.TypeInfo.WentingCanvasWebVewPrefab)
end

---@private
function UISimpleWebView:InitGenerate__4(Root, data)
--[[
	Window/BtnClose
--]]
	local tmp = Root:Find("Window/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UISimpleWebView:GenerateDestroy()
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.webView) ~= nil then
		tolua.setpeer(self.webView, nil)
	end
	self.webView = nil
	if tolua.getpeer(self.btnClose) ~= nil then
		tolua.setpeer(self.btnClose, nil)
	end
	self.btnClose = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UISimpleWebView