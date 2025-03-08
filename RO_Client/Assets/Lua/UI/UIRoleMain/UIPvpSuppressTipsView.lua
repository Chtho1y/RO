local UIPvpSuppressTipsView = require("UIRoleMain/UIPvpSuppressTipsView_Generate")

function UIPvpSuppressTipsView:OnAwake(data)
	self.controller = require("UIRoleMain/UIPvpSuppressTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPvpSuppressTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_SKILL_CHANGED,self,self.RefreshPress)

end

function UIPvpSuppressTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPvpSuppressTipsView:Init()
	local currValue = ManagerContainer.DataMgr.UserData:GetCurrRoleSkillPress()
	local maxValue = ManagerContainer.DataMgr.UserData:GetAllUnlockRoleSkillPress()
	self.text.text.text = currValue.."/"..maxValue
end

function UIPvpSuppressTipsView:RefreshPress()
	local currValue = ManagerContainer.DataMgr.UserData:GetCurrRoleSkillPress()
	local maxValue = ManagerContainer.DataMgr.UserData:GetAllUnlockRoleSkillPress()
	self.text.text.text = currValue.."/"..maxValue
end

function UIPvpSuppressTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPvpSuppressTipsView:OnCloseClick()
	self:UIClose()
end

function UIPvpSuppressTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self,self.OnCloseClick)
end

function UIPvpSuppressTipsView:OnHide()

end

function UIPvpSuppressTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIPvpSuppressTipsView:OnClose()
end

function UIPvpSuppressTipsView:OnDispose()
	self.controller:OnDispose()
end

return UIPvpSuppressTipsView

