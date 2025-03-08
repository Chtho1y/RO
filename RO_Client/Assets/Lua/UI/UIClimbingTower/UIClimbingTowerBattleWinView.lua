local UIClimbingTowerBattleWinView = require("UIClimbingTower/UIClimbingTowerBattleWinView_Generate")

function UIClimbingTowerBattleWinView:OnAwake(data)
	self.controller = require("UIClimbingTower/UIClimbingTowerBattleWinCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIClimbingTowerBattleWinView:AddEventListener()

end

function UIClimbingTowerBattleWinView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIClimbingTowerBattleWinView:Init()
	self:SetRewardInfo(self.controller:GetLevelRewards())

	local type = self.controller:GetLastUITowerType()
	self.btnNextTower:SetActive(type == Enum.UnlimitTowerType.ClimbingTower)
end

function UIClimbingTowerBattleWinView:SetRewardInfo(rewardData)
	if rewardData~= nil then
		self.ItemScrollView:SetActive(true)
		CommonUtil.LoopGridViewEleCreateNew(self,
									self.ItemScrollView.loopVerticalScrollRect,
									self.ItemContent.gridLayoutGroup,rewardData,0,self,self.OnUpdateItemData)
	else
		self.ItemScrollView:SetActive(false)
	end
end

function UIClimbingTowerBattleWinView:OnUpdateItemData(itemLua,idx,itemData)
	CommonUtil.SetRewardItemDataNew(self,itemData[1],itemLua,itemData[2],itemData[3], self.OnClickItem)
end

function UIClimbingTowerBattleWinView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIClimbingTowerBattleWinView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.btnNextTower.button,self, self.OnClickNext)
end

function UIClimbingTowerBattleWinView:OnHide()

end

function UIClimbingTowerBattleWinView:OnShow(data)
	self.controller:SetData(data)

end

function UIClimbingTowerBattleWinView:OnClose()
end

function UIClimbingTowerBattleWinView:OnDispose()
	self.controller:OnDispose()
end

function UIClimbingTowerBattleWinView:OnClickNext()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE,self.controller:BackPageId())
	--ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
	self.controller:EnterNextBattle()
end

function UIClimbingTowerBattleWinView:OnClickClose()
	local type = self.controller:GetLastUITowerType()
	if type == Enum.UnlimitTowerType.PeakTower then
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_PVPCIMBINGBATTLE,self.controller:BackPageId())
	else
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE,self.controller:BackPageId())
	end
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
end

function UIClimbingTowerBattleWinView:OnClickItem(btn,params)
	local logicData = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(logicData)
end

return UIClimbingTowerBattleWinView

