local UIPayWaitingView = require("UIWaiting/UIPayWaitingView_Generate")

function UIPayWaitingView:OnAwake(data)
	self.controller = require("UIWaiting/UIPayWaitingCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPayWaitingView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIPayWaitingView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPayWaitingView:Init()
end

function UIPayWaitingView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPayWaitingView:AddUIEventListener()

end

function UIPayWaitingView:OnHide()

end

function UIPayWaitingView:OnShow(data)
	self.controller:SetData(data)

end

function UIPayWaitingView:OnClose()
end

function UIPayWaitingView:OnDispose()
	self.controller:OnDispose()
end

return UIPayWaitingView

