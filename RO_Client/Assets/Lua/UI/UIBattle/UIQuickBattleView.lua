local UIQuickBattleView = require("UIBattle/UIQuickBattleView_Generate")

function UIQuickBattleView:OnAwake(data)
	self.controller = require("UIBattle/UIQuickBattleCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIQuickBattleView:AddEventListener()

end

function UIQuickBattleView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIQuickBattleView:Init()
	self.LeftTimesLbl.text.text = tostring(self.controller:LeftCnt())
	
	local costText, enough = self.controller:GetUseCondition()
	self.StartBtnLbl.text.text = costText

	if enough == false then
		self.StartBtnLbl.text.color = Color.red
	else
		self.StartBtnLbl.text.color = Color.white
	end

end

function UIQuickBattleView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIQuickBattleView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.StartBtn.button,self, self.OnClickStart)
	self.uiBase:AddButtonEventListener(self.CloseBtn.button,self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
end

function UIQuickBattleView:OnHide()

end

function UIQuickBattleView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIQuickBattleView:OnClose()
end

function UIQuickBattleView:OnDispose()

end

function UIQuickBattleView:OnClickStart()
	if self.controller:LeftCnt() > 0 then
		ManagerContainer.LuaBattleMgr:SendQuickBattleReq()
		self:OnClickClose();
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("BtnQuickFinish")) 	--今日次数已用完
	end
end

function UIQuickBattleView:OnClickClose()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIQuickBattle)
end

return UIQuickBattleView

