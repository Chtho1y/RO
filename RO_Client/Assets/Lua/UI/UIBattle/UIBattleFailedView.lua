local UIBattleFailedView = require("UIBattle/UIBattleFailedView_Generate")

function UIBattleFailedView:OnAwake(data)
	self.controller = require("UIBattle/UIBattleFailedCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIBattleFailedView:AddEventListener()
end

function UIBattleFailedView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIBattleFailedView:Init()
end

function UIBattleFailedView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIBattleFailedView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
end

function UIBattleFailedView:OnHide()

end

function UIBattleFailedView:OnShow(data)
	self.controller:SetData(data)

end

function UIBattleFailedView:OnClose()
end

function UIBattleFailedView:OnDispose()
	self.controller:OnDispose()
end

function UIBattleFailedView:OnClickClose()
	if self.controller:GetData() then
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE,Enum.UIPageName.UIExpedition,true)
	end
	self:UIClose()
end

return UIBattleFailedView

