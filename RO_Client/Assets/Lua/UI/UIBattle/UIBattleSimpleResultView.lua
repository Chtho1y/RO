local UIBattleSimpleResultView = require("UIBattle/UIBattleSimpleResultView_Generate")

function UIBattleSimpleResultView:OnAwake(data)
	self.controller = require("UIBattle/UIBattleSimpleResultCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIBattleSimpleResultView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIBattleSimpleResultView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIBattleSimpleResultView:Init()
	local battleResult = self.controller:GetBattleResult()
	self.battleLose:SetActive(battleResult ~= 1)
	self.battleWin:SetActive(battleResult == 1)

	self.AnyBtn.button.interactable = false
	if self.canExitTimer then
		self.canExitTimer.time = self.canExitTimer.duration
	else
		self.canExitTimer = Timer.New(slot(self.OpenAnyBtnClick, self), 1)
	end
	if not self.canExitTimer.running then
		self.canExitTimer:Start()
	end

	if self.exitTimer then
		self.exitTimer.time = self.exitTimer.duration
	else
		self.exitTimer = Timer.New(slot(self.OnClickCancelBtn, self), 10)
	end
	if not self.exitTimer.running then
		self.exitTimer:Start()
	end
end

function UIBattleSimpleResultView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIBattleSimpleResultView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCancelBtn)
end

function UIBattleSimpleResultView:OnHide()

end

function UIBattleSimpleResultView:OnShow(data)
	self.controller:SetData(data)

end

function UIBattleSimpleResultView:OnClose()
end

function UIBattleSimpleResultView:OnDispose()
	if self.exitTimer then
		self.exitTimer:Stop()
		self.exitTimer = nil
	end
	if self.canExitTimer then
		self.canExitTimer:Stop()
		self.canExitTimer = nil
	end
	self.controller:OnDispose()
end

function UIBattleSimpleResultView:OnClickCancelBtn()
	self.controller:HandleCallback()
	self:UIClose()
end

function UIBattleSimpleResultView:OpenAnyBtnClick()
	self.AnyBtn.button.interactable = true
end

return UIBattleSimpleResultView

