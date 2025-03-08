local UIVoyageReformingView = require("UIVoyage/UIVoyageReformingView_Generate")

function UIVoyageReformingView:OnAwake(data)
	self.controller = require("UIVoyage/UIVoyageReformingCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIVoyageReformingView:AddEventListener()
end

function UIVoyageReformingView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIVoyageReformingView:Init()
	self.animator:Play('ShipReforming')
	self.checkoutNum = 0
	if self.forceShowTimer then
		self.forceShowTimer.time = 0.5
	else
		self.forceShowTimer = Timer.New(slot(self.CheckResult, self), 0.5, -1)
	end
	if not self.forceShowTimer.running then
		self.forceShowTimer:Start()
	end
end

function UIVoyageReformingView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIVoyageReformingView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
end

function UIVoyageReformingView:OnHide()

end

function UIVoyageReformingView:OnShow(data)
	self.controller:SetData(data)

end

function UIVoyageReformingView:OnClose()
end

function UIVoyageReformingView:OnDispose()
	self.checkoutNum = nil
	if self.forceShowTimer then
		self.forceShowTimer:Stop()
		self.forceShowTimer = nil
	end
	self.controller:OnDispose()
end

function UIVoyageReformingView:OnClickCloseBtn()
	if self.forceShowTimer and self.forceShowTimer.running then
		return
	end
	self:UIClose()
end

function UIVoyageReformingView:CheckResult()
	self.checkoutNum = self.checkoutNum + 1
	if self.checkoutNum > 5 then
		self:ShowResult(false)
		return
	end
	local result = ManagerContainer.DataMgr.VoyageDataMgr:GetRefreshAirShipResult()
	if result then
		self:ShowResult(true)
	elseif result == false then
		self:ShowResult(false)
	end
end

function UIVoyageReformingView:ShowResult(success)
	if self.forceShowTimer then
		self.forceShowTimer:Stop()
	end
	self.fail:SetActive(not success)
	self.success:SetActive(success)
	self.animator:Play('ShipReformingResult')
end

return UIVoyageReformingView

