local UICardItemTipsView = require("UICardTips/UICardItemTipsView_Generate")

function UICardItemTipsView:OnAwake(data)
	self.controller = require("UICardTips/UICardItemTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UICardItemTipsView:AddEventListener()

end

function UICardItemTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UICardItemTipsView:Init()
end

function UICardItemTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UICardItemTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UICardItemTipsView:OnHide()

end

function UICardItemTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UICardItemTipsView:OnClose()

end

function UICardItemTipsView:OnDispose()

end

return UICardItemTipsView

