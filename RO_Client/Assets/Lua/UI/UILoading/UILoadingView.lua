local UILoadingView = require("UILoading/UILoadingView_Generate")

local _timeLimit = 3000;	--超过3秒就替换新的小提示
local _timerId;			--timer计时器id

function UILoadingView:OnAwake(data)
	self.controller = require("UILoading/UILoadingCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UILoadingView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Loading_Begin, self, self.OnLoadingBegin)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Loading_Progress, self, self.OnLoadingProgress)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Loading_Complete, self, self.OnLoadingComplete)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Loading_Close, self, self.OnLoadingClose)
	--打开初始化完毕后的 回调开始加载
	if nil ~= self.controller.data and nil ~= self.controller.data.FucOpenFinishedcb then
		self.controller.data.FucOpenFinishedcb()
	end
end

function UILoadingView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)
	self:Init()
	self:OnLoadingBegin()
	-- LogError("-----------------------")
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loaded_Page_OK)
end

function UILoadingView:Init()
	self:SetTip();
	_timerId = ManagerContainer.LuaTimerMgr:AddTimer(_timeLimit, -1, self, self.SetTip, nil)

	local loadingBg = self.controller:GetBgName();
	CommonUtil.LoadIcon(self, loadingBg, function (sprite)
		self.loadingBg.image.sprite = sprite
	end)
end


--设置小提示的显示
function UILoadingView:SetTip()
	local _tip = self.controller:GetTipString();
	self.tip.text.text = _tip;
end

function UILoadingView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UILoadingView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UILoadingView:OnLoadingBegin()
	LogWarning("UILoadingView:OnLoadingBegin ")
	self.scrollbar.scrollbar.size = 0
	self.numberText.text.text = "0%"
end

function UILoadingView:OnLoadingProgress(progress)
	self.scrollbar.scrollbar.size = progress
	if progress > 1 then
		progress = 1
	end
	self.numberText.text.text = math.floor(progress*100).."%"
end

function UILoadingView:OnLoadingComplete()
	LogWarning("UILoadingView:OnLoadingComplete ")

	self.scrollbar.scrollbar.size = 1
	self.numberText.text.text = "100%"
	self.transform:DOScale(1, 1):OnComplete(function ()
		self:ClosePage()
	end)
end

function UILoadingView:OnLoadingClose()
	self:ClosePage()
end

function UILoadingView:OnHide()

end

function UILoadingView:OnShow(data)

end

function UILoadingView:OnClose()
	if _timerId ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(_timerId);
		_timerId = nil;
	end
end

function UILoadingView:OnDispose()
	ManagerContainer.LuaGameMgr:CloseLoading()


end

function UILoadingView:ClosePage()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UILoading)
end

return UILoadingView

