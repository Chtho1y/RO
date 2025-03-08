local UISimpleWebView = require("UIWeb/UISimpleWebView_Generate")

function UISimpleWebView:OnAwake(data)
	self.controller = require("UIWeb/UISimpleWebCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISimpleWebView:AddEventListener()
end

function UISimpleWebView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISimpleWebView:Init()
	local size = self.webView.transform.rect.size
	local scale = 1
	if size.x > 1024 then
		local scale1 = 1024 / size.x
		if scale > scale1 then
			scale = scale1
		end
	end
	if size.y > 1024 then
		local scale2 = 1024 / size.y
		if scale > scale2 then
			scale = scale2
		end
	end
	local data = self.controller.data
	local idx = nil
	local dataLen = #data
	for i = 1, dataLen do
		local char = string.sub(data, i, i)
		if char ~= '0'
			and char ~= '1'
			and char ~= '2'
			and char ~= '3'
			and char ~= '4'
			and char ~= '5'
			and char ~= '6'
			and char ~= '7'
			and char ~= '8'
			and char ~= '9'
			and char ~= '10'
			and char ~= '.'
		then
			idx = i
			break
		end
	end

	local resolution = nil
	if idx then
		resolution = string.sub(data, 1, idx - 1)
		local result, value = RO_XPCALL(function ()
			return tonumber(resolution)
		end, debug.traceback)
		if result then
			resolution = value
			data = string.sub(data, idx, dataLen)
		end
	end
	if not resolution then
		resolution = 1
	end

	self.webView:SetActive(false)
	local wentingCanvasWebVewPrefab = self.webView.wentingCanvasWebVewPrefab
	if wentingCanvasWebVewPrefab.WebView then
		wentingCanvasWebVewPrefab.WebView.LoadProgressChanged = wentingCanvasWebVewPrefab.WebView.LoadProgressChanged + System.EventHandler_Vuplex_WebView_ProgressChangedEventArgs(self.OnWebProgress, self)
		wentingCanvasWebVewPrefab.WebView:LoadUrl(data)
		wentingCanvasWebVewPrefab:SetResolution(resolution)
	else
		if wentingCanvasWebVewPrefab then
			wentingCanvasWebVewPrefab.Initialized = wentingCanvasWebVewPrefab.Initialized + System.EventHandler(self.OnWebInited, self)
		end
		wentingCanvasWebVewPrefab.InitialUrl = tostring(data)
		wentingCanvasWebVewPrefab:Init(resolution, 15, scale)
	end
end

function UISimpleWebView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	local wentingCanvasWebVewPrefab = self.webView.wentingCanvasWebVewPrefab
	if wentingCanvasWebVewPrefab then
		wentingCanvasWebVewPrefab.Initialized = wentingCanvasWebVewPrefab.Initialized - System.EventHandler(self.OnWebInited, self)
		if wentingCanvasWebVewPrefab.WebView then
			wentingCanvasWebVewPrefab.WebView.LoadProgressChanged = wentingCanvasWebVewPrefab.WebView.LoadProgressChanged - System.EventHandler_Vuplex_WebView_ProgressChangedEventArgs(self.OnWebProgress, self)
		end
	end
end

function UISimpleWebView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
end

function UISimpleWebView:OnHide()
end

function UISimpleWebView:OnShow(data)
	self.controller:SetData(data)
end

function UISimpleWebView:OnClose()
end

function UISimpleWebView:OnDispose()
	self.controller:OnDispose()
end

function UISimpleWebView:OnClickCloseBtn()
	self:UIClose()
end

function UISimpleWebView:OnWebInited()
	local wentingCanvasWebVewPrefab = self.webView.wentingCanvasWebVewPrefab
	if wentingCanvasWebVewPrefab then
		if wentingCanvasWebVewPrefab.WebView then
			wentingCanvasWebVewPrefab.WebView.LoadProgressChanged = wentingCanvasWebVewPrefab.WebView.LoadProgressChanged + System.EventHandler_Vuplex_WebView_ProgressChangedEventArgs(self.OnWebProgress, self)
			wentingCanvasWebVewPrefab.WebView:LoadUrl(wentingCanvasWebVewPrefab.InitialUrl)
		end
	end
end

function UISimpleWebView:OnWebProgress()
	self.webView:SetActive(true)
	local wentingCanvasWebVewPrefab = self.webView.wentingCanvasWebVewPrefab
	if wentingCanvasWebVewPrefab then
		if wentingCanvasWebVewPrefab.WebView then
			wentingCanvasWebVewPrefab.WebView.LoadProgressChanged = wentingCanvasWebVewPrefab.WebView.LoadProgressChanged - System.EventHandler_Vuplex_WebView_ProgressChangedEventArgs(self.OnWebProgress, self)
		end
	end
end

return UISimpleWebView

