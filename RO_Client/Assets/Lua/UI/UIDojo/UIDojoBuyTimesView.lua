local UIDojoBuyTimesView = require("UIDojo/UIDojoBuyTimesView_Generate")

function UIDojoBuyTimesView:OnAwake(data)
	self.controller = require("UIDojo/UIDojoBuyTimesCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIDojoBuyTimesView:AddEventListener()

end

function UIDojoBuyTimesView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
	self:SetUIData()
end

function UIDojoBuyTimesView:Init()
end

function UIDojoBuyTimesView:SetUIData()
	local cost = self.controller:GetCostNum()
	local remainCount = self.controller:GetRemainCount()
	self.costText.text.text = tostring(cost)
	if remainCount then
		self.title:SetActive(true)
		self.leftTimesText.text.text = tostring(remainCount)
	else
		self.title:SetActive(false)
	end
end

function UIDojoBuyTimesView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIDojoBuyTimesView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.buyBtn.button,self, self.OnClickBuy)
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
end

function UIDojoBuyTimesView:OnHide()
end

function UIDojoBuyTimesView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIDojoBuyTimesView:OnClose()

end

function UIDojoBuyTimesView:OnDispose()
	if self.delayTimer then
		self.delayTimer:Stop()
	end
	self.delayTimer = nil
end

function UIDojoBuyTimesView:OnClickBuy()
	self.controller:HandleCallback()
	self:OnClickClose()
end

function UIDojoBuyTimesView:OnClickClose()
	self.delayTimer = FrameTimer.New(function()
		ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
	end, 1)
	self.delayTimer:Start()
end

return UIDojoBuyTimesView

