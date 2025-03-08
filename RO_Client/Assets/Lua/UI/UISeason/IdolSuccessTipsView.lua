local IdolSuccessTipsView = require("UISeason/IdolSuccessTipsView_Generate")
local timer = 1.5

function IdolSuccessTipsView:OnAwake(data)
	self.controller = require("UISeason/IdolSuccessTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function IdolSuccessTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function IdolSuccessTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function IdolSuccessTipsView:Init()
	if self.updateTimer then
		self.updateTimer:Stop()
		self.updateTimer = nil
	end
	if not self.updateTimer then
		self.updateTimer = Timer.New(slot(self.UIClose, self), timer, 1)
	end
	if not self.updateTimer.running then
		self.updateTimer:Start()
	end
end

function IdolSuccessTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function IdolSuccessTipsView:AddUIEventListener()

end


function IdolSuccessTipsView:OnShow(data)
	self.controller:SetData(data)

end

function IdolSuccessTipsView:OnClose()
end

function IdolSuccessTipsView:OnDispose()
	self.controller:OnDispose()
	if self.updateTimer then
		self.updateTimer:Stop()
		self.updateTimer = nil
	end
end

return IdolSuccessTipsView

