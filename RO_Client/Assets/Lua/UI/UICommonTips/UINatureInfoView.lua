local UINatureInfoView = require("UICommonTips/UINatureInfoView_Generate")

function UINatureInfoView:OnAwake(data)
	self.controller = require("UICommonTips/UINatureInfoCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UINatureInfoView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UINatureInfoView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UINatureInfoView:Init()
end

function UINatureInfoView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UINatureInfoView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)
end

function UINatureInfoView:OnCloseClick()
	self:UIClose()
end

function UINatureInfoView:OnHide()

end

function UINatureInfoView:OnShow(data)
	self.controller:SetData(data)

end

function UINatureInfoView:OnClose()
end

function UINatureInfoView:OnDispose()
	self.controller:OnDispose()
end

return UINatureInfoView

