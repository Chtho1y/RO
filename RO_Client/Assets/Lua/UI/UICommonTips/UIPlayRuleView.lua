local UIPlayRuleView = require("UICommonTips/UIPlayRuleView_Generate")

function UIPlayRuleView:OnAwake(data)
	self.controller = require("UICommonTips/UIPlayRuleCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPlayRuleView:AddEventListener()

end

function UIPlayRuleView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPlayRuleView:Init()
	self.titleLab.text.text = self.controller:GetTitleStr()
	self.contentLab.text.text = self.controller:GetContentStr()
end

function UIPlayRuleView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPlayRuleView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCancelBtn)
end

function UIPlayRuleView:OnHide()

end

function UIPlayRuleView:OnShow(data)
	self.controller:SetData(data)

end

function UIPlayRuleView:OnClose()
end

function UIPlayRuleView:OnDispose()
	self.controller:OnDispose()
end

function UIPlayRuleView:OnClickCloseBtn()
	if self.controller:IsCopy() then
		UnityEngine.GUIUtility.systemCopyBuffer = self.controller:GetContentStr()
	end
	self:UIClose()
end

function UIPlayRuleView:OnClickCancelBtn()
	self:UIClose()
end

return UIPlayRuleView

