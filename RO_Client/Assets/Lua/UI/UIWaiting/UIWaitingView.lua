local UIWaitingView = require("UIWaiting/UIWaitingView_Generate")

function UIWaitingView:OnAwake(data)
	self.controller = require("UIWaiting/UIWaitingCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIWaitingView:AddEventListener()

end

function UIWaitingView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIWaitingView:Init()
end

function UIWaitingView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIWaitingView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIWaitingView:OnHide()

end

function UIWaitingView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIWaitingView:OnClose()

end

function UIWaitingView:OnDispose()


end

return UIWaitingView

