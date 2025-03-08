local UIDojoExitView = require("UIDojo/UIDojoExitView_Generate")

function UIDojoExitView:OnAwake(data)
	self.controller = require("UIDojo/UIDojoExitCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIDojoExitView:AddEventListener()

end

function UIDojoExitView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIDojoExitView:Init()
	if self.controller:GetData() ~= true then  --是否播放录像退出
		ManagerContainer.LuaDojoMgr:CloseBattlePage();
	end	

	local _second = GlobalConfig.Instance:GetConfigIntValue(166);
	LuaBattleBridge.PlayTweenAlpha(self.centerView, 0, _second);
	self._timer = ManagerContainer.LuaTimerMgr:AddTimer(_second * 1000, 1, self, self.DownAlpha, nil)
end

function UIDojoExitView:DownAlpha()
	if self.controller:GetData() ~= true then  --是否播放录像退出
		ManagerContainer.LuaDojoMgr:BackDojoMain();
	else
		ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIDojoExit)
	end	
	
end

function UIDojoExitView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIDojoExitView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIDojoExitView:OnHide()

end

function UIDojoExitView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIDojoExitView:OnClose()

end

function UIDojoExitView:OnDispose()
	if self._timer ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self._timer)
		self._timer = nil
	end
end

return UIDojoExitView

