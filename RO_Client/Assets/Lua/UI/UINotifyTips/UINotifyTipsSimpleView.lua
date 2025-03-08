local UINotifyTipsSimpleView = require("UINotifyTips/UINotifyTipsSimpleView_Generate")

function UINotifyTipsSimpleView:OnAwake(data)
	self.controller = require("UINotifyTips/UINotifyTipsSimpleCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UINotifyTipsSimpleView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UINotifyTipsSimpleView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UINotifyTipsSimpleView:Init(isRefresh)
	local title, content = self.controller:GetTitleAndContent()
	self.boardTitle.text.text = string.formatbykey(title)
	self.desTxt.text.text = content
	if not isRefresh then
		self.scrollView.scrollRect.enabled = false
	end
end

function UINotifyTipsSimpleView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UINotifyTipsSimpleView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.BtnClose.button, self, self.OnClickCloseBtn)
end

function UINotifyTipsSimpleView:OnHide()

end

function UINotifyTipsSimpleView:OnShow(data)
	if self.controller:SetData(data) then
		self:Init(true)
	end
end

function UINotifyTipsSimpleView:OnClose()
end

function UINotifyTipsSimpleView:OnDispose()
	self.controller:OnDispose()
end

function UINotifyTipsSimpleView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.scrollView.scrollRect.enabled = true
end

function UINotifyTipsSimpleView:OnClickCloseBtn()
	self:UIClose()
end

return UINotifyTipsSimpleView

