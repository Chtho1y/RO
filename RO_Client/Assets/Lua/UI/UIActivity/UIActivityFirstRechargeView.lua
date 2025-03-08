local UIActivityFirstRechargeView = require("UIActivity/UIActivityFirstRechargeView_Generate")

local GiftType = {
	First = 1,		-- 首充
	Hundred = 2,	-- 百元
}

function UIActivityFirstRechargeView:OnAwake(data)
	self.controller = require("UIActivity/UIActivityFirstRechargeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIActivityFirstRechargeView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PAY_TOTAL_RECHARGE_CHANGED, self, self.OnPayTotalRechargeChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_Data_Change, self, self.OnActivityDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_FirstRecharge_Change, self, self.OnActivityFirstRechargeChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_CLOSE_COMPELETED, self, self.OnUICloseCompleted)
end

function UIActivityFirstRechargeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIActivityFirstRechargeView:Init()
	self.controller:InitData()
	self.firstRechargeItem.rewards.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self:RefreshView()
end

function UIActivityFirstRechargeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIActivityFirstRechargeView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.backBtn.button, self, self.OnClickCloseBtn)

	self.uiBase:AddToggleUniqueEventListener(self.firstToggle.toggle, self, self.OnClickToggle, GiftType.First)
	self.uiBase:AddToggleUniqueEventListener(self.hundredToggle.toggle, self, self.OnClickToggle, GiftType.Hundred)

	self.uiBase:AddButtonUniqueEventListener(self.btnRecharge.button, self, self.OnClickRechargeBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnReceive.button, self, self.OnClickReceiveBtn)

	self.uiBase:AddToggleUniqueEventListener(self.toggle1.toggle, self, self.OnClickDayToggle, 1)
	self.uiBase:AddToggleUniqueEventListener(self.toggle2.toggle, self, self.OnClickDayToggle, 2)
	self.uiBase:AddToggleUniqueEventListener(self.toggle3.toggle, self, self.OnClickDayToggle, 3)
end

function UIActivityFirstRechargeView:OnHide()

end

function UIActivityFirstRechargeView:OnShow(data)
	self.controller:SetData(data)
end

function UIActivityFirstRechargeView:OnClose()
end

function UIActivityFirstRechargeView:OnDispose()
	if self.firstRechargeItem and self.firstRechargeItem.rewards and self.firstRechargeItem.rewards.loopGridView then
		self.firstRechargeItem.rewards.loopGridView:Dispose()
	end
	self.controller:OnDispose()
end

function UIActivityFirstRechargeView:OnPayTotalRechargeChanged()
	self:RefreshRewardState()
end

function UIActivityFirstRechargeView:OnActivityDataChanged()
	local giftType = self.controller:GetGiftType()
	if giftType == GiftType.Hundred then
		self:RefreshRewards()
		self:RefreshRewardState()
	end
end

function UIActivityFirstRechargeView:OnActivityFirstRechargeChanged()
	local giftType = self.controller:GetGiftType()
	if giftType == GiftType.First then
		self:RefreshRewards()
		self:RefreshRewardState()
	end
end

function UIActivityFirstRechargeView:OnUICloseCompleted(owner)
	if owner.uiData.id ~= Enum.UIPageName.UIRuneShop then return end
	if ManagerContainer.LuaUIMgr:PageInHideStack(self.uiBase) then
		ManagerContainer.LuaUIMgr:Show(Enum.UIPageName.UIActivityFirstRecharge)
	end
end

function UIActivityFirstRechargeView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIActivityFirstRechargeView:OnClickToggle(tog, params, b)
	if not b then return end
	local giftType = params[0]
	if self.controller:ChangeGiftType(giftType) then
		self:RefreshBanner()
		self:RefreshRewards()
		self:RefreshRewardState()
	end
end

function UIActivityFirstRechargeView:OnClickRechargeBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.Gifts, Enum.RuneShopSubType.Gold})
	ManagerContainer.LuaUIMgr:Hide(Enum.UIPageName.UIActivityFirstRecharge)
end

function UIActivityFirstRechargeView:OnClickReceiveBtn()
	self.controller:SendGetReward()
end

function UIActivityFirstRechargeView:OnClickDayToggle(tog, params, b)
	if not params then return end
	local dayIdx = params[0]
	if not b then
		local lastDayIdx = self.controller:GetDayIdx()
		if dayIdx == lastDayIdx then
			tog.isOn = true
		end
		return
	end
	if self.controller:ChangeDayIdx(dayIdx) then
		self:RefreshRewards()
		self:RefreshRewardState()
	end
end

function UIActivityFirstRechargeView:RefreshView()
	self:RefreshToggleGroup()
	self:RefreshBanner()
	self:RefreshRewards()
	self:RefreshRewardState()
end

function UIActivityFirstRechargeView:RefreshToggleGroup()
	local giftType = self.controller:GetGiftType()
	local toggleGroup = self.toggleGroup.toggleGroup
	local oldAllowSwitchOff = toggleGroup.allowSwitchOff
	toggleGroup.allowSwitchOff = true
	self.firstToggle.toggle.isOn = (giftType == GiftType.First)
	self.hundredToggle.toggle.isOn = (giftType == GiftType.Hundred)
	toggleGroup.allowSwitchOff = oldAllowSwitchOff
end

function UIActivityFirstRechargeView:RefreshBanner()
	local giftType = self.controller:GetGiftType()
	self.banner1:SetActive(giftType == GiftType.First)
	self.banner2:SetActive(giftType == GiftType.Hundred)
end

function UIActivityFirstRechargeView:RefreshRewards()
	local cfgData = self.controller:GetCfgData()
	if not cfgData then
		self.firstRechargeItem:SetActive(false)
		return
	end
	local idx = self.controller:GetDayIdx()
	self.toggle1.toggle.isOn = (idx == 1)
	self.toggle2.toggle.isOn = (idx == 2)
	self.toggle3.toggle.isOn = (idx == 3)
	if not idx then
		self.firstRechargeItem:SetActive(false)
		return
	end
	self:RefreshFirstRechargeItem(self.firstRechargeItem, idx, cfgData['Reward' .. tostring(idx)], cfgData['Value' .. tostring(idx)])
end

function UIActivityFirstRechargeView:RefreshRewardState()
	local idx = self.controller:GetDayIdx()
	local rewardState = nil
	if idx then
		rewardState = self.controller:GetRewardStateByDay(idx)
	else
		rewardState = Enum.ActivityRewardState.NotGot
	end
	local curNum, targetNum = self.controller:GetTargetRechargeInfo()
	if targetNum > 0 then
		self.dscTxt.text.text = string.formatbykey('DscRecharge02', tostring(curNum), tostring(targetNum))
		self.btnRecharge:SetActive(true)
		self.btnReceive:SetActive(false)
		self.btnWating:SetActive(false)
		self.labelReceived:SetActive(false)
	else
		self.dscTxt.text.text = ''
		self.btnRecharge:SetActive(false)
		if rewardState == Enum.ActivityRewardState.Got then
			self.btnReceive:SetActive(true)
			self.btnWating:SetActive(false)
			self.labelReceived:SetActive(false)
		elseif rewardState == Enum.ActivityRewardState.GotAndHas then
			self.btnReceive:SetActive(false)
			self.btnWating:SetActive(false)
			self.labelReceived:SetActive(true)
		else
			self.btnReceive:SetActive(false)
			self.btnWating:SetActive(true)
			self.labelReceived:SetActive(false)
		end
	end
end

function UIActivityFirstRechargeView:RefreshFirstRechargeItem(itemLua, day, rewards, value)
	itemLua.textDays.text.text = string.formatbykey('TitleFirstRechargeRewards', tostring(day))
	itemLua.numValue.text.text = tostring(value)
	self.firstRechargeItem.rewards.loopGridView:RefreshListByIndex(rewards and #rewards or 0, 0)
	local rewardState = self.controller:GetRewardStateByDay(day)
	itemLua.mask:SetActive(rewardState == Enum.ActivityRewardState.GotAndHas)
	itemLua.received:SetActive(rewardState == Enum.ActivityRewardState.GotAndHas)
	itemLua.available:SetActive(rewardState == Enum.ActivityRewardState.Got)
	local _, targetNum = self.controller:GetTargetRechargeInfo()
	if targetNum > 0 then
		itemLua.mask:SetActive(false)
		itemLua.received:SetActive(false)
		itemLua.available:SetActive(false)
		itemLua.wating:SetActive(false)
	else
		if rewardState == Enum.ActivityRewardState.Got then
			itemLua.mask:SetActive(false)
			itemLua.received:SetActive(false)
			itemLua.available:SetActive(true)
			itemLua.wating:SetActive(false)
		elseif rewardState == Enum.ActivityRewardState.GotAndHas then
			itemLua.mask:SetActive(true)
			itemLua.received:SetActive(true)
			itemLua.available:SetActive(false)
			itemLua.wating:SetActive(false)
		else
			itemLua.mask:SetActive(false)
			itemLua.received:SetActive(false)
			itemLua.available:SetActive(false)
			itemLua.wating:SetActive(true)
		end
	end
end

function UIActivityFirstRechargeView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local cfgData = self.controller:GetCfgData()
	if not cfgData then
		return nil
	end
	local idx = self.controller:GetDayIdx()
	if not idx then
		return nil
	end
	local showData = cfgData['Reward' .. tostring(idx)]
	local item = nil
	if showData then
		local itemData = showData[itemIndex + 1]
		if itemData then
			item = gridView:NewListViewItem('IconSmallItem')
			local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'IconItem', item.gameObject)
			CommonUtil.UpdateItemPrefab(self, itemlua, {cfgId = itemData[1], num = itemData[2]}, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
		end
	end
	return item
end

function UIActivityFirstRechargeView:ShowItemTips(button, params)
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

return UIActivityFirstRechargeView

