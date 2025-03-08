local UISkillExpCostView = require("UISkillExpBattle/UISkillExpCostView_Generate")

function UISkillExpCostView:OnAwake(data)
	self.controller = require("UISkillExpBattle/UISkillExpCostCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISkillExpCostView:AddEventListener()

end

function UISkillExpCostView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISkillExpCostView:Init()
	-- local slotData = ManagerContainer.DataMgr.SkillExpBattleData:FindSlotData(self.controller:GetData())
	-- if slotData ~= nil then
	-- 	local bossData = ManagerContainer.DataMgr.SkillExpBattleData:FindBossData(slotData.bossId)
	-- 	if bossData ~=nil then
	-- 		self.incomeText.text.text = tostring(bossData.exp)
	-- 	end
	-- 	self.evilExpText.text.text = ManagerContainer.DataMgr.SkillExpBattleData.costEvilExp ..  "是否继续挑战? "
	-- end
end

function UISkillExpCostView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UISkillExpCostView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self,self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self,self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.cancelBtn.button,self,self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.challengeBtn.button,self,self.OnClickChallenge)
end

function UISkillExpCostView:OnHide()

end

function UISkillExpCostView:OnShow(data)
	self.controller:SetData(data)

end

function UISkillExpCostView:OnClose()
end

function UISkillExpCostView:OnDispose()
	self.controller:OnDispose()
end

function UISkillExpCostView:OnClickClose()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
end

function UISkillExpCostView:OnClickChallenge()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Evil_Confirm_Challenge,self.controller:GetData())
	self:OnClickClose()
end

return UISkillExpCostView

