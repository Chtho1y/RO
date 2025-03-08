local UIActivityDailyRechargeView = require("UIActivity/UIActivityDailyRechargeView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

function UIActivityDailyRechargeView:OnAwake(data)
	self.controller = require("UIActivity/UIActivityDailyRechargeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIActivityDailyRechargeView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_Data_Change,self,self.ActivityRefresh);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_Daily_Comulative_Refresh, self, self.Refresh)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PAY_DAY_RECHARGE_CHANGED, self, self.Refresh)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_CLOSE_COMPELETED, self, self.OnUICloseCompleted)
end

function UIActivityDailyRechargeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIActivityDailyRechargeView:InitGrid()
	self.rewards.loopListView:InitListView(0, function(gridView, itemIndex, row, column)
		return self:GetRankItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIActivityDailyRechargeView:Init()
	self:InitGrid()
	self:Refresh()
end

function UIActivityDailyRechargeView:OnPageInEnd()
	self.super.OnPageInEnd(self)

	if self.rewardList then
		local length = #self.rewardList + 1
		self.rewards.scrollRect.enabled = length > 5
	end
end

function UIActivityDailyRechargeView:ActivityRefresh(actid)
	if self.controller:GetActId() == actid then
		self:Refresh()
	end
end

function UIActivityDailyRechargeView:Refresh()
	local rewardState, curDay = self.controller:GetDailyRewardState()
	local displayCfgData = ManagerContainer.CfgMgr:GetNextActivitiesTiredChargeCfgById(rewardState, curDay)
	local realCfgData = self.controller:GetNextTiredChargeCfgData()
	self.rewards:SetActive(displayCfgData ~= nil)

	local dailyTiredCount = self.controller:GetDailyTiredChargeCount()

	self.text1:SetActive(displayCfgData and rewardState < displayCfgData.Id and dailyTiredCount < displayCfgData.RechargeAmount)
	self.text2:SetActive(displayCfgData == nil)
	self.text3:SetActive(displayCfgData and rewardState < displayCfgData.Id and dailyTiredCount >= displayCfgData.RechargeAmount)
	self.text2.text.text = dailyTiredCount
	self.text3.text.text = dailyTiredCount

	if displayCfgData then
		local needChargeCount = self.controller:GetNeedChargeCount()
		local count = dailyTiredCount >= displayCfgData.RechargeAmount and displayCfgData.RechargeAmount or needChargeCount
		self.text1.text.text = count
		if dailyTiredCount >= displayCfgData.RechargeAmount then
			self.bottomDsc.uILocalizeScript:SetContentAndValues("DscRecharge01", {dailyTiredCount})
		else
			self.bottomDsc.uILocalizeScript:SetContentAndValues("DscRecharge02", {dailyTiredCount, count})
		end
		self:RefreshReward(displayCfgData)
	else
		self.bottomDsc.uILocalizeScript:SetContentAndValues("DscRecharge01", {dailyTiredCount})
	end

	self.btnConfirm:SetActive(displayCfgData == nil)
	self.btnReceive:SetActive(displayCfgData and rewardState < displayCfgData.Id and dailyTiredCount >= displayCfgData.RechargeAmount)
	self.btnRecharge:SetActive(displayCfgData and rewardState < displayCfgData.Id and dailyTiredCount < displayCfgData.RechargeAmount)

	self.btnReceive.uIRedPointRP:SetActive(self.controller:GetDailyRPState())
end

function UIActivityDailyRechargeView:RefreshReward(cfgData)
	self.rewardList = clone(cfgData.Reward)
	for i = #self.rewardList, 1, -1 do
		local cfgId = self.rewardList[i][1]
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
		if itemCfgData.ItemTime > 0 and itemCfgData.ItemTime ~= 5 then
			table.remove(self.rewardList, i)
		elseif itemCfgData.ItemTime == 5 then
			local isIn = self.controller:IsInActivityDrops(cfgId)
			if not isIn then
				table.remove(self.rewardList, i)
			end
		end
	end
	local length = #self.rewardList + 1
	self.rewards.loopListView:SetListItemCount(length, true)
	self.rewards.loopListView:RefreshAllShownItem()
end

function UIActivityDailyRechargeView:GetRankItemByRowColumn(gridView, itemIndex, row, column)
	local item
	if itemIndex == 0 then
		item = gridView:NewListViewItem('Empty')
	else
		local reward = self.rewardList[itemIndex]
		local cfgId = reward[1]
		item = gridView:NewListViewItem('IconItem')
		local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'IconItem', item.gameObject)
		local data = {cfgId = cfgId, num = reward[2]}
		IconItemCtr:SetData(self, itemLua, data, Enum.ItemIEnterType.Bag, self, self.ShowItemClick)
	end
	item.gameObject.name = itemIndex
	return item
end

function UIActivityDailyRechargeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIActivityDailyRechargeView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.backBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnConfirm.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnReceive.button, self, self.OnRewardReceive)
	self.uiBase:AddButtonEventListener(self.btnRecharge.button, self, self.OnGotoPay)
end

function UIActivityDailyRechargeView:ShowItemClick(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIActivityDailyRechargeView:OnCloseClick()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIActivityDailyRechargeView:OnRewardReceive()
	self.controller:SendRewardReq(self.uiData.id)
end

function UIActivityDailyRechargeView:OnUICloseCompleted(owner)
	if owner.uiData.id ~= Enum.UIPageName.UIRuneShop then return end
	if ManagerContainer.LuaUIMgr:PageInHideStack(self.uiBase) then
		ManagerContainer.LuaUIMgr:Show(Enum.UIPageName.UIActivityDailyRecharge)
	end
end

function UIActivityDailyRechargeView:OnGotoPay()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.Gifts, Enum.RuneShopSubType.Gold})
	ManagerContainer.LuaUIMgr:Hide(Enum.UIPageName.UIActivityDailyRecharge)
end

function UIActivityDailyRechargeView:OnHide()

end

function UIActivityDailyRechargeView:OnShow(data)
	self.controller:SetData(data)

end

function UIActivityDailyRechargeView:OnClose()

	self.rewards.loopListView:Dispose()
end

function UIActivityDailyRechargeView:OnDispose()
	self.controller:OnDispose()
end

return UIActivityDailyRechargeView

