local UIRuneShopView = require("UIRuneShop/UIRuneShopView_Generate")

local FirstBuyBgIconPath = 'ShopIcons/txt_club_first'
local ExtraBuyBgIconPath = 'ShopIcons/txt_club_free_extra_cn'

local RuneShopRewardsPath = 'UIRuneShop/RewardsBoxItem'

local lastClickLogTime
local lastClickNum

function UIRuneShopView:OnAwake(data)
	self.controller = require("UIRuneShop/UIRuneShopCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIRuneShopView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.COIN_CHANGED, self, self.OnCoinChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.DIAMOND_CHANGED, self, self.OnDiamondChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VIP_LV_CHANGED, self, self.OnVipLvChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RUNE_SHOP_DATA_CHANGED, self, self.OnRuneShopDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RUNE_SHOP_REWARDS_DATA_CHANGED, self, self.OnRuneShopRewardsDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_CLOSEED_TASK_PAGE, self, self.OnCloseTask)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_TASK_JUMP, self, self.OnCloseAirShip)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RED_POINT_MGR_NOTICE, self, self.OnRPNotify)
end

function UIRuneShopView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)
	self:Init()
end

function UIRuneShopView:Init()
	self.controller:InitData()
	self.itemStart = true
	lastClickLogTime = nil
	lastClickNum = nil

	self.giftsBox.scrollView.loopGridView:InitGridView(0, function(loopGridView, itemIdx, row, column)
		return self:GetItemByRowColumnGifts(loopGridView, itemIdx, row, column)
	end, nil, nil)

	self.limitedBox.scrollView.loopGridView:InitGridView(0, function(loopGridView, itemIdx, row, column)
		return self:GetItemByRowColumnLimited(loopGridView, itemIdx, row, column)
	end, nil, nil)

	self:RefreshCoinView()
	self:RefreshGoldView()
	self:RefreshVipView()
	self:RefreshToggleGroupView()
	self:RefreshShopView(true)
end

function UIRuneShopView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIRuneShopView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnVIP.button, self, self.OnClickVipBtn)
	self.uiBase:AddToggleUniqueEventListener(self.monthToggle.toggle, self, self.OnClickOneToggle, Enum.RuneShopType.MonthCard)
	self.uiBase:AddToggleUniqueEventListener(self.giftsToggle.toggle, self, self.OnClickOneToggle, Enum.RuneShopType.Gifts)
	self.uiBase:AddToggleUniqueEventListener(self.limitedToggle.toggle, self, self.OnClickOneToggle, Enum.RuneShopType.LimitTime)
	self.uiBase:AddToggleUniqueEventListener(self.rewardsToggle.toggle, self, self.OnClickRewardsToggle)
	self.uiBase:AddButtonUniqueEventListener(self.dailyBtn.button, self, self.OnClickShopSubBtn, Enum.RuneShopSubType.Daily)
	self.uiBase:AddButtonUniqueEventListener(self.weekBtn.button, self, self.OnClickShopSubBtn, Enum.RuneShopSubType.Week)
	self.uiBase:AddButtonUniqueEventListener(self.monthBtn.button, self, self.OnClickShopSubBtn, Enum.RuneShopSubType.Month)
	self.uiBase:AddButtonUniqueEventListener(self.goldBtn.button, self, self.OnClickShopSubBtn, Enum.RuneShopSubType.Gold)
	self.uiBase:AddButtonUniqueEventListener(self.btnLog.button, self, self.OnClickBtnLog)
end

function UIRuneShopView:OnHide()

end

function UIRuneShopView:OnShow(data)
	if data then
		self.controller:SetData(data)
		self.controller:InitData()
	end
	self:RefreshCoinView()
	self:RefreshGoldView()
	self:RefreshVipView()
	self:RefreshToggleGroupView()
	self:RefreshShopView(true)
	--
end

function UIRuneShopView:OnClose()
end

function UIRuneShopView:OnDispose()
	self:DisposeRefreshTimer()
	self.giftsBox.scrollView.loopGridView:Dispose()
	self.limitedBox.scrollView.loopGridView:Dispose()
	if self.rewardsBoxItem then
		self.rewardsBoxItemLua.scrollView.loopGridView:Dispose()
	end
	if self.seqId then
		ManagerContainer.ResMgr:UnloadAssetBySeqId(self.seqId)
		self.seqId = nil
	end
	if self.rewardsBoxItem then 
		ManagerContainer.ResMgr:RecycleGO(Constants.UIPath, RuneShopRewardsPath, self.rewardsBoxItem.gameObject)
		self.rewardsBoxItem = nil
		self.isInited = false
	end
	lastClickLogTime = nil
	lastClickNum = nil
	self.controller:OnDispose()
end

function UIRuneShopView:OnCoinChanged()
	self:RefreshCoinView()
end

function UIRuneShopView:OnDiamondChanged()
	self:RefreshGoldView()
end

function UIRuneShopView:OnVipLvChanged()
	self:RefreshVipView()
end

function UIRuneShopView:OnRuneShopDataChanged(runeShopType, runeShopSubType)
	if runeShopType ~= self.controller:GetShopType() then return end
	local curRuneShopSubType = self.controller:GetShopSubType()
	if curRuneShopSubType and runeShopSubType ~= curRuneShopSubType then return end
	self.controller:RefreshCurShopData()
	self:RefreshShopView()
end

function UIRuneShopView:OnRuneShopRewardsDataChanged()
	self:RefreshShopView()
end

function UIRuneShopView:OnRPNotify(rpType)
	if rpType ~= Enum.RPNotifyType.RuneShopLimitGift then
		return
	end
	if Enum.RuneShopType.LimitTime ~= self.controller:GetShopType() then return end
	local curRuneShopSubType = self.controller:GetShopSubType()
	if curRuneShopSubType and nil ~= curRuneShopSubType then return end
	self:RefreshShopView()
end

function UIRuneShopView:OnClickBtnLog(button, params)
	local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	if not lastClickLogTime or (curTime - lastClickLogTime) > 15000 then
		lastClickLogTime = curTime
		lastClickNum = 0
	end
	if not lastClickNum then
		lastClickNum = 0
	end
	lastClickNum = lastClickNum + 1
	if lastClickNum >= 30 then
		lastClickNum = 0
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'Log1', true})
	end
end

function UIRuneShopView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIRuneShopView:OnClickVipBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIVip)
end

function UIRuneShopView:OnClickOneToggle(tog, params, b)
	if not b then return end
	local shopType = params[0]
	if self.controller:ChangeShopType(shopType) then
		self:RefreshShopView(true)
	end
end

function UIRuneShopView:OnClickRewardsToggle(tog, params, b)
	if not b then return end
	if self.controller:ChangeShopType(nil) then
		self:RefreshShopView(true)
	end
end



function UIRuneShopView:OnClickShopSubBtn(btn, params)
	local shopSubType = params[0]
	if self.controller:ChangeShopSubType(shopSubType) then
		self:RefreshGiftsView(true)
	end
end

function UIRuneShopView:OnClickMonthCardPrice(button, params)
	local id = params[0]
	local errorCodeKey = self.controller:SendPay(id)
	if not errorCodeKey then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCodeKey)
	end
end


function UIRuneShopView:OnClickGiftItem(button, params)
	local id = params[0]
	local runeShopType = self.controller:GetShopType()
	local runeShopSubType = self.controller:GetShopSubType()
	if runeShopType == Enum.RuneShopType.Gifts then
		if runeShopSubType == Enum.RuneShopSubType.Gold then
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShopGoldBuyTips, {runeShopType, runeShopSubType, id})
			return
		end
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShopBuyTips, {runeShopType, runeShopSubType, id})
end

function UIRuneShopView:OnClickGiftPrice(button, params)
	-- 直接发起支付
	local id = params[0]
	local errorCodeKey = self.controller:SendPay(id)
	if not errorCodeKey then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCodeKey)
	end
end

function UIRuneShopView:OnClickLimitedItem(button, params)
	local id = params[0]
	local itemIdx = params[1]
	local runeShopType = self.controller:GetShopType()
	local runeShopSubType = self.controller:GetShopSubType()
	if runeShopType == Enum.RuneShopType.Gifts then
		if runeShopSubType == Enum.RuneShopSubType.Gold then
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShopGoldBuyTips, {runeShopType, runeShopSubType, id})
			return
		end
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShopBuyTips, {runeShopType, runeShopSubType, id})
	ManagerContainer.RedPointMgr.RSLimitGiftRPCtr:CancelRedPointStatusById(id)
	self.limitedBox.scrollView.loopGridView:RefreshItemByItemIndex(itemIdx)
end

function UIRuneShopView:OnClickLimitedPrice(button, params)
	-- 直接发起支付
	local id = params[0]
	local itemIdx = params[1]
	local errorCodeKey = self.controller:SendPay(id)
	if not errorCodeKey then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCodeKey)
	end
	ManagerContainer.RedPointMgr.RSLimitGiftRPCtr:CancelRedPointStatusById(id)
	self.limitedBox.scrollView.loopGridView:RefreshItemByItemIndex(itemIdx)
end

function UIRuneShopView:OnClickPlayRuleBtn()
	local rule
	rule = "AirshipText"
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', rule})
end

function UIRuneShopView:OnClickTaskExpBtn()
	ManagerContainer.DataMgr.TaskDataNew:OpenTaskPanel();
end

function UIRuneShopView:OnClickBuyAdvancedRewardsBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRewardsBuyTips, {runeShopType, nil, 0})
end

function UIRuneShopView:OnClickGetAdvancedRewardBtn()
	if self.rewardsBaseData:GetMaxRewardsNum() > 0 then
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPLORE_EXTRA_REWARD_REQ)
	end
	
end

function UIRuneShopView:OnCloseTask()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EXPLORE_INFO_REQ)
end

function UIRuneShopView:OnCloseAirShip()
	ManagerContainer.LuaUIMgr:Close(Enum.UIPageName.UIRuneShop)
end

function UIRuneShopView:PreLoadAssets()
	if not self.rewardsBoxItem then
		self.rewardsBoxItem = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, RuneShopRewardsPath)
		if self.rewardsBoxItem then
			self.rewardsBoxItemLua =  CommonUtil.BindGridViewItem2LuaStatic("RewardsBoxItem",self.rewardsBoxItem.gameObject)
			self.rewardsBoxItemLua.transform:SetParent(self.rewardsBox.transform)
			self.rewardsBoxItemLua.transform.localPosition = Vector3.zero
			self.rewardsBoxItemLua.transform.localRotation = Quaternion.identity
			self.rewardsBoxItemLua.transform.localScale = Vector3.one
			self.rectTrans = self.rewardsBoxItemLua.rectTransform
			self.rectTrans.offsetMax = Vector2(0,0)
			self.rectTrans.offsetMin = Vector2(0,0)
			self.rectTrans.anchoredPosition3D = Vector3.zero
			self.rectTrans.anchoredPosition = Vector2(0,0)

			self.uiBase:AddButtonUniqueEventListener(self.rewardsBoxItemLua.btnPlayRule.button, self, self.OnClickPlayRuleBtn)
			self.uiBase:AddButtonUniqueEventListener(self.rewardsBoxItemLua.btnBuyMore.button, self, self.OnClickBuyAdvancedRewardsBtn)
			self.uiBase:AddButtonUniqueEventListener(self.btnTaskExp.button, self, self.OnClickTaskExpBtn)

			self.rewardsBoxItemLua.scrollView.loopGridView:InitGridView(0, function(loopGridView, itemIdx, row, column)
				return self:GetItemByRowColumnRewards(loopGridView, itemIdx, row, column)
			end, nil, nil)

			self:RefreshRewardsView()
		end
	end
	
end

function UIRuneShopView:RefreshCoinView()
	self.coin.number.text.text = CommonUtil.FormatNumber(self.controller:GetOwnResCountByItemId(Enum.ItemType.Coin))
end

function UIRuneShopView:RefreshGoldView()
	self.gold.number.text.text = CommonUtil.FormatNumber(self.controller:GetOwnResCountByItemId(Enum.ItemType.Diamond))
end

function UIRuneShopView:RefreshVipView()
	local curVipLv = self.controller:GetCurVipLv()
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(curVipLv)

	self.vipIcon.image.sprite = nil
	self.vipIcon.image.enabled = false
	self.vipFrame.image.sprite = nil
	self.vipFrame.image.enabled = false
	if not vipCfg then
		self.vipNameTxt.text.text = ''
		return
	end
	CommonUtil.LoadIcon(self, vipCfg.BigIcon, function(sprite)
		if sprite then
			self.vipIcon.image.sprite = sprite
			self.vipIcon.image.enabled = true
		end
	end)
	CommonUtil.LoadIcon(self, vipCfg.BigFrame, function(sprite)
		if sprite then
			self.vipFrame.image.sprite = sprite
			self.vipFrame.image.enabled = true
		end
	end)
	self.vipNameTxt.text.text = string.formatbykey(vipCfg.Name)
end

function UIRuneShopView:RefreshToggleGroupView()
	if not ManagerContainer.DataMgr.RuneShopDataMgr:GetAirShipIsOpen() then
		self.rewardsToggle:SetActive(false)
	else
		local state = true
		local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(54)
        if not unlockState then
            state = false
        end
		self.rewardsToggle:SetActive(state)
	end
	local shopType = self.controller:GetShopType()
	local toggleGroup = self.content.toggleGroup
	local oldAllowSwitchOff = toggleGroup.allowSwitchOff
	toggleGroup.allowSwitchOff = true
	self.monthToggle.toggle.isOn = (shopType == Enum.RuneShopType.MonthCard)
	self.giftsToggle.toggle.isOn = (shopType == Enum.RuneShopType.Gifts)
	self.limitedToggle.toggle.isOn = (shopType == Enum.RuneShopType.LimitTime)
	self.rewardsToggle.toggle.isOn = (shopType == nil)
	toggleGroup.allowSwitchOff = oldAllowSwitchOff
end

function UIRuneShopView:RefreshShopView(resetPos)
	

	self:StopAndClearRefreshTimer()
	local shopType = self.controller:GetShopType()

	if not shopType then
		self.monthBox:SetActive(false)
		self.giftsBox:SetActive(false)
		self.limitedBox:SetActive(false)
		self.rewardsBox:SetActive(true)
		self.rewardsExpBox:SetActive(true)
		if self.rewardsBoxItem then
			self:RefreshRewardsView()
		else
			self.seqId = ManagerContainer.ResMgr:LuaLoadAssets(Enum.ResourceType.GameObject, Constants.UIPath, { RuneShopRewardsPath}, self,  self.PreLoadAssets)
		end
		
		self.textBox.text.text = string.formatbykey('DscClub04')
		return
	end

	if shopType == Enum.RuneShopType.MonthCard then
		self.monthBox:SetActive(true)
		self.giftsBox:SetActive(false)
		self.limitedBox:SetActive(false)
		self.rewardsBox:SetActive(false)
		self.rewardsExpBox:SetActive(false)
		self:RefreshMonthCardView()
		self.textBox.text.text = string.formatbykey('DscClub01')
	elseif shopType == Enum.RuneShopType.Gifts then
		self.monthBox:SetActive(false)
		self.giftsBox:SetActive(true)
		self.limitedBox:SetActive(false)
		self.rewardsBox:SetActive(false)
		self.rewardsExpBox:SetActive(false)
		self:RefreshGiftsView(resetPos)
		self.textBox.text.text = string.formatbykey('DscClub02')
	elseif shopType == Enum.RuneShopType.LimitTime then
		self.monthBox:SetActive(false)
		self.giftsBox:SetActive(false)
		self.limitedBox:SetActive(true)
		self.rewardsBox:SetActive(false)
		self.rewardsExpBox:SetActive(false)
		self:RefreshLimitedView(resetPos)
		self.textBox.text.text = string.formatbykey('DscClub03')
	else
		self.monthBox:SetActive(false)
		self.giftsBox:SetActive(false)
		self.limitedBox:SetActive(false)
		self.rewardsBox:SetActive(false)
		self.rewardsExpBox:SetActive(false)
		self.textBox.text.text = ''
	end
end

function UIRuneShopView:RefreshMonthCardView()
	self:RefreshOneMonthCardView(self.monthCard1, 1)
	self:RefreshOneMonthCardView(self.monthCard2, 2)
end

function UIRuneShopView:RefreshOneMonthCardView(itemLua, idx)
	local showGoodsDatas = self.controller:GetShowGoodsDatas()
	if not showGoodsDatas then
		itemLua:SetActive(false)
		return
	end
	local showGoodsData = showGoodsDatas[idx]
	if not showGoodsData then
		itemLua:SetActive(false)
		return
	end
	itemLua:SetActive(true)
	local cfgData = showGoodsData:GetCfgData()
	local buyRewards = cfgData.BuyReward
	if buyRewards then
		local buyReward = buyRewards[1]
		if buyReward then
			self:RefreshCurrenyItem(itemLua.buyReward1, buyReward[1], buyReward[2], true)
		else
			self:RefreshCurrenyItem(itemLua.buyReward1)
		end
		buyReward = buyRewards[2]
		if buyReward then
			self:RefreshCurrenyItem(itemLua.buyReward2, buyReward[1], buyReward[2], true)
		else
			self:RefreshCurrenyItem(itemLua.buyReward2)
		end
	else
		self:RefreshCurrenyItem(itemLua.buyReward1)
		self:RefreshCurrenyItem(itemLua.buyReward2)
	end

	local dayRewards = cfgData.DayReward
	if dayRewards then
		local dayReward = dayRewards[1]
		if dayReward then
			self:RefreshCurrenyItem(itemLua.dailyReward, dayReward[1], dayReward[2], true)
		else
			self:RefreshCurrenyItem(itemLua.dailyReward)
		end
	else
		self:RefreshCurrenyItem(itemLua.dailyReward)
	end

	local totalRewards = cfgData.TotalReward
	if totalRewards then
		local totalReward = totalRewards[1]
		if totalReward then
			self:RefreshCurrenyItem(itemLua.totalReward, totalReward[1], totalReward[2], true)
		else
			self:RefreshCurrenyItem(itemLua.totalReward)
		end
	else
		self:RefreshCurrenyItem(itemLua.totalReward)
	end

	local price = showGoodsData:GetPrice()
	if price <= 0 then
		itemLua.presentPrice.number.text.text = string.formatbykey('Free')
	else
		itemLua.presentPrice.number.text.text = tostring(price)
	end

	local timerStr, outTime = showGoodsData:CalculateLimitTime()
	if not outTime then
		self:StartRefreshTimer(itemLua, showGoodsData)
		itemLua.textDsc.text.text = string.formatbykey('DscClubMonth2', timerStr)
		itemLua.active:SetActive(true)
		itemLua.unActive:SetActive(false)
	else
		self:StopRefreshTimer(itemLua)
		local mdec = cfgData.Monthdec
		if mdec then
			itemLua.textDsc.text.text = string.formatbykey(cfgData.Monthdec)
		else
			itemLua.textDsc.text.text = ""
		end
		
		itemLua.active:SetActive(false)
		itemLua.unActive:SetActive(true)
	end
	self.uiBase:AddButtonUniqueEventListener(itemLua.presentPrice.button, self, self.OnClickMonthCardPrice, showGoodsData:GetId())
end

function UIRuneShopView:RefreshGiftsView(resetPos)
	local shopSubType = self.controller:GetShopSubType()
	if shopSubType == Enum.RuneShopSubType.Week then
		self:RefreshShopSubBtnState(self.dailyBtn, false)
		self:RefreshShopSubBtnState(self.weekBtn, true)
		self:RefreshShopSubBtnState(self.monthBtn, false)
		self:RefreshShopSubBtnState(self.goldBtn, false)
	elseif shopSubType == Enum.RuneShopSubType.Month then
		self:RefreshShopSubBtnState(self.dailyBtn, false)
		self:RefreshShopSubBtnState(self.weekBtn, false)
		self:RefreshShopSubBtnState(self.monthBtn, true)
		self:RefreshShopSubBtnState(self.goldBtn, false)
	elseif shopSubType == Enum.RuneShopSubType.Gold then
		self:RefreshShopSubBtnState(self.dailyBtn, false)
		self:RefreshShopSubBtnState(self.weekBtn, false)
		self:RefreshShopSubBtnState(self.monthBtn, false)
		self:RefreshShopSubBtnState(self.goldBtn, true)
	else -- Enum.RuneShopSubType.Daily
		self:RefreshShopSubBtnState(self.dailyBtn, true)
		self:RefreshShopSubBtnState(self.weekBtn, false)
		self:RefreshShopSubBtnState(self.monthBtn, false)
		self:RefreshShopSubBtnState(self.goldBtn, false)
	end

	local endTime = self.controller:GetRemainTime()
	if endTime then
		self:StartRefreshTimer(self, true)
		if endTime < 0 then endTime = 0 end
		self.timeBox:SetActive(true)
		self.timeBox.textTime.text.text = string.formatbykey('RuneShopRefreshTime', DateTimeUtil.convertSeconds2TimeStr1(endTime, true, true, false))
	else
		self:StopRefreshTimer(self)
		self.timeBox:SetActive(false)
	end
	local showGoodsDatas = self.controller:GetShowGoodsDatas()
	local length = (showGoodsDatas and #showGoodsDatas or 0)
	if resetPos then
		self.giftsBox.scrollView.loopGridView:RefreshListByIndex(length, 0)
	else
		self.giftsBox.scrollView.loopGridView:RefreshListByIndex(length)
	end
end

function UIRuneShopView:RefreshShopSubBtnState(itemLua, isOn)
	itemLua.off:SetActive(not isOn)
	itemLua.on:SetActive(isOn)
	itemLua.button.interactable = (not isOn)
end

function UIRuneShopView:GetItemByRowColumnGifts(loopGridView, itemIdx, row, column)
	local data = self.controller:GetShowGoodsDataByIdx(itemIdx + 1)
	if not data then return nil end
	local item = loopGridView:NewListViewItem('RuneShopGoodsItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'RuneShopGoodsItem', item.gameObject)
	if itemLua then
		itemLua.itemIcon.image.sprite = nil
		itemLua.itemIcon.image.enabled = false
		local cfgData = data.cfgData
		if cfgData then
			CommonUtil.LoadIcon(self, cfgData.Pic, function(sprite)
				if sprite then
					itemLua.itemIcon.image.sprite = sprite
					itemLua.itemIcon.image.enabled = true
				end
			end, itemLua, 'ItemIcon')
			itemLua.itemName.text.text = string.formatbykey(cfgData.Name)
			if cfgData.FirstBuyReward and #cfgData.FirstBuyReward > 0 and data:IsFirstBuy() then
				itemLua.discount:SetActive(true)
				itemLua.discount.text.text.text = string.formatbykey('LabelFirst')
				self:RefreshGiftsItem(itemLua, FirstBuyBgIconPath, cfgData.FirstBuyPic, cfgData.Reward)
			elseif cfgData.ExtraBuyReward and #cfgData.ExtraBuyReward > 0 then
				itemLua.discount:SetActive(true)
				itemLua.discount.text.text.text = string.formatbykey('LabelExtra')
				self:RefreshGiftsItem(itemLua, ExtraBuyBgIconPath, cfgData.ExtraBuyPic, cfgData.Reward)
			else
				itemLua.discount:SetActive(false)
				self:RefreshGiftsItem(itemLua, nil, nil, cfgData.Reward)
			end
		else
			itemLua.discount:SetActive(false)
			itemLua.itemName.text.text = ''
			itemLua.specialReward:SetActive(false)
			itemLua.goodsItems:SetActive(false)
		end
		local remainBuyNum = data:GetRemainBuyNum()
		if remainBuyNum >= 0 then
			itemLua.purchaseLimit:SetActive(true)
			itemLua.purchaseLimit.text.text = string.formatbykey('RuneShopLimitBuy', tostring(remainBuyNum))
		else
			itemLua.purchaseLimit:SetActive(false)
		end
		local price = data:GetPrice()
		if price <= 0 then
			itemLua.presentPrice.number.text.text = string.formatbykey('Free')
		else
			itemLua.presentPrice.number.text.text = tostring(price)
		end
		if data:IsSoldout() then
			itemLua.soldout:SetActive(true)
			itemLua.button.onClick:RemoveAllListeners()
			itemLua.presentPrice.button.onClick:RemoveAllListeners()
		else
			itemLua.soldout:SetActive(false)
			self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickGiftItem, data:GetId())
			self.uiBase:AddButtonUniqueEventListener(itemLua.presentPrice.button, self, self.OnClickGiftPrice, data:GetId())
		end
	end
	return item
end

function UIRuneShopView:RefreshGiftsItem(itemLua, bgPic, numPic, rewards)
	if numPic and numPic ~= '' then
		itemLua.specialReward.bg.image.sprite = nil
		itemLua.specialReward.bg.image.enabled = false
		CommonUtil.LoadIcon(self, bgPic, function(sprite)
			if sprite then
				itemLua.specialReward.bg.image.sprite = sprite
				itemLua.specialReward.bg.image.enabled = true
			end
		end, itemLua, 'SpecialRewardBgIcon')
		itemLua.specialReward.num.image.sprite = nil
		itemLua.specialReward.num.image.enabled = false
		CommonUtil.LoadIcon(self, numPic, function(sprite)
			if sprite then
				itemLua.specialReward.num.image.sprite = sprite
				itemLua.specialReward.num.image.enabled = true
			end
		end, itemLua, 'SpecialRewardNumIcon')
		itemLua.specialReward:SetActive(true)
		itemLua.goodsItems:SetActive(false)
	else
		itemLua.specialReward:SetActive(false)
		if rewards then
			itemLua.goodsItems:SetActive(true)
			local reward = rewards[1]
			if reward then
				itemLua.iconSmallItem1:SetActive(true)
				CommonUtil.UpdateItemPrefab(self, itemLua.iconSmallItem1, {cfgId = reward[1], num = reward[2]}, Enum.ItemIEnterType.Bag)
			else
				itemLua.iconSmallItem1:SetActive(false)
			end
			reward = rewards[2]
			if reward then
				itemLua.iconSmallItem2:SetActive(true)
				CommonUtil.UpdateItemPrefab(self, itemLua.iconSmallItem2, {cfgId = reward[1], num = reward[2]}, Enum.ItemIEnterType.Bag)
			else
				itemLua.iconSmallItem2:SetActive(false)
			end
			reward = rewards[3]
			if reward then
				itemLua.iconSmallItem3:SetActive(true)
				CommonUtil.UpdateItemPrefab(self, itemLua.iconSmallItem3, {cfgId = reward[1], num = reward[2]}, Enum.ItemIEnterType.Bag)
			else
				itemLua.iconSmallItem3:SetActive(false)
			end
		else
			itemLua.goodsItems:SetActive(false)
		end
	end
end

function UIRuneShopView:RefreshLimitedView(resetPos)
	local showGoodsDatas = self.controller:GetShowGoodsDatas()
	local length = (showGoodsDatas and #showGoodsDatas or 0)
	if resetPos then
		self.limitedBox.scrollView.loopGridView:RefreshListByIndex(length, 0)
	else
		self.limitedBox.scrollView.loopGridView:RefreshListByIndex(length)
	end
end

--悬赏战令页面
function UIRuneShopView:RefreshRewardsView()
	if not self.rewardsBoxItemLua then return end
	if ManagerContainer.DataMgr.RuneShopDataMgr.isRewardsDataDirty then
		self.rewardsBoxItemLua:SetActive(false)
		return
	end
	self.rewardsBoxItemLua:SetActive(true)
	self.rewardsBaseData = self.controller:GetRewardsBaseData()

	local showGoodsDatas = self.rewardsBaseData:GetShowRewardsData()
	local curLv = self.rewardsBaseData:GetShowRewardsCurLv()
	local curExp = self.rewardsBaseData:GetShowRewardsCurExp()
	local curCfg = self.rewardsBaseData:GetRewardsCurRoundCfg()

	if not curCfg then
		self.rewardsBoxItemLua:SetActive(false)
		return
	end
	self.isShowAirShip = false
	local length = (showGoodsDatas and #showGoodsDatas or 0)
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopRewards, false)
	--页面下方关于当前等级的信息展示
	local nextlv = curLv + 1
	if nextlv > length then
		nextlv = length
	end
	if curLv == length then
		self.rewardsmax:SetActive(true)
		self.numexp.text.text = tostring(curExp)..'/'.. tostring(curCfg.ExpCost) 
		self.expSlider.slider.value = curExp/curCfg.ExpCost
	else
		self.rewardsmax:SetActive(false)
		self.curLvData = self.controller:GetShowRewardsDataByIdx(nextlv)
		self.numexp.text.text = tostring(curExp)..'/'.. tostring(self.curLvData.cfgData.Exp) 
		self.expSlider.slider.value = curExp/self.curLvData.cfgData.Exp
	end
	self.rewardslv.text.text = tostring(curLv)
	self.rewardsBoxItemLua.btnBuyMore.num.text.text = tostring(curCfg.MissonExpUp)..'%'
	self.expUpBlue.num.text.text = tostring(curCfg.MissonExpUp)..'%'
	--根据等级经验 刷新小游艇
	local newLv =length - curLv
	--因为多一个开始节点和结束最终奖励节点，所以+2
	self.rewardsBoxItemLua.scrollView.loopGridView:RecycleAllItem()
	if self.isInited then
		self.rewardsBoxItemLua.scrollView.loopGridView:RefreshListByIndex(length+2 )
	else
		self.rewardsBoxItemLua.scrollView.loopGridView:RefreshListByIndex(length+2 , newLv)
	end
	self.rewardsBoxItemLua.scrollView.loopGridView.mOnBeginDragAction = function(gridView)
		self:RefreshBigRewardsFloatTips(gridView)
	end
	self.rewardsBoxItemLua.scrollView.loopGridView.mOnDragingAction = function(gridView)
		self:RefreshBigRewardsFloatTips(gridView)
	end
	self.rewardsBoxItemLua.scrollView.loopGridView.mOnEndDragAction = function(gridView)
		self:RefreshBigRewardsFloatTips(gridView)
	end
	
	
	self.isInited = true
	local isCash = self.rewardsBaseData:GetRewardsIsCash()
	if isCash == 1 then
		self.rewardsBoxItemLua.btnBuyMore:SetActive(false)
		self.rewardsBoxItemLua.labelUnLocked:SetActive(true)
		self.expUpBlue:SetActive(true)
	else
		self.rewardsBoxItemLua.btnBuyMore:SetActive(true)
		self.rewardsBoxItemLua.labelUnLocked:SetActive(false)
		self.expUpBlue:SetActive(false)
	end
	
	local endTime = self.rewardsBaseData:RefreshRewaradsRemainTime()
	if endTime then
		self:StartRefreshTimer(self.rewardsBoxItemLua, true)
		if endTime < 0 then endTime = 0 end
		self:RefreshBigRewardsFloatTips(nil)
		self.rewardsBoxItemLua.timeBox:SetActive(true)
		self.rewardsBoxItemLua.timeBox.textTime.text.text = string.formatbykey('AirshipTime', DateTimeUtil.convertSeconds2TimeStr1(endTime, true, true, false))
	else
		self:StopRefreshTimer(self.rewardsBoxItemLua)
		self.rewardsBoxItemLua.timeBox:SetActive(false)
	end
	
end

--大奖标签跳转
function UIRuneShopView:JumpToTarget(button , params)
	local data = clone(params[0])
	self.rewardsBoxItemLua.scrollView.loopGridView:RefreshListByIndex(#self.controller:GetShowRewardsData()+2 , data.targetid)
	self:RefreshBigRewardsFloatTips()
end

--设置悬赏单个对象
function UIRuneShopView:UpdateRewardsItem(itemLua, idx, data, isEnd)
	local curExp = self.rewardsBaseData:GetShowRewardsCurExp()
	local curLv = self.rewardsBaseData:GetShowRewardsCurLv()

	--最终奖励宝箱
	if isEnd then
		self.uiBase:AddButtonUniqueEventListener(itemLua.btnBuyMore.button, self, self.OnClickGetAdvancedRewardBtn)
		local costExp = ManagerContainer.CfgMgr:GetRuneShopExploreCfgByRound(self.rewardsBaseData:GetShowRewardsRoundData()).ExpCost
		if self.rewardsBaseData:GetMaxRewardsNum() > 0 then
			itemLua.chestAnim.animator:Play('Open')
			itemLua.redPoint:SetActive(true)
			itemLua.btnBuyMore.num.text.text = tostring(self.rewardsBaseData:GetMaxRewardsNum())
			
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopRewards, true)
		else
			itemLua.chestAnim.animator:Play('Close')
			itemLua.redPoint:SetActive(false)
			--self.uiBase:(itemLua.btnBuyMore.button, self, self.OnClickGetAdvancedRewardBtn)
		end
		
		if self.rewardsBaseData:GetRewardsIsMax() then
			itemLua.airShip:SetActive(true)
			itemLua.levelSlider.slider.value = 1
		else
			if curLv == #self.rewardsBaseData:GetShowRewardsData() then
				itemLua.airShip:SetActive(true)
				itemLua.levelSlider.slider.value = curExp/costExp
			else
				itemLua.airShip:SetActive(false)
			end
		end
		itemLua.dsc.text.text.text = string.formatbykey("DscRewardsMax",tostring(costExp),'1')
	--通用item
	else
		--0级开始
		if idx == 0 then
			itemLua.startItem:SetActive(true)
			itemLua.rewardsBox2:SetActive(false)
			itemLua.levelBox2:SetActive(false)
			if curLv == 0 and  curExp/self.curLvData.cfgData.Exp < 0.15 then
				itemLua.startItem.airShip:SetActive(true)
			else
				itemLua.startItem.airShip:SetActive(false)
			end
		--常规等级
		else
			CommonUtil.UpdateItemPrefab(self, itemLua, data, Enum.ItemIEnterType.Bag, self, nil)
			--self.tempItemLua = itemLua
			itemLua.numlv.text.text = idx
			
			itemLua.startItem:SetActive(false)
			itemLua.rewardsBox2:SetActive(true)
			itemLua.levelBox2:SetActive(true)

			itemLua.rewardsBox2.bgyellow:SetActive(false)
			if data.cfgData.RewardSign > 0 then
				itemLua.rewardsBox2.bgyellow:SetActive(true)
			end
			
			if	data.isReward then
				--0为 默认状态
				if data.isReward == 0 then 
					itemLua.rewardsLeft.arrived:SetActive(false)
					itemLua.rewardsLeft.received:SetActive(false)
					
				--1为已领取	
				elseif data.isReward == 1 then 
					itemLua.rewardsLeft.arrived:SetActive(false)
					itemLua.rewardsLeft.received:SetActive(true)
				--可领取
				elseif data.isReward == 2 then
					itemLua.rewardsLeft.arrived:SetActive(true)
					itemLua.rewardsLeft.received:SetActive(false)
				end

			else
				itemLua.rewardsLeft.arrived:SetActive(false)
				itemLua.rewardsLeft.received:SetActive(false)
			end


			if	data.isCashReward and self.rewardsBaseData:GetRewardsIsCash()==1 then
				--0为 默认状态
				if data.isCashReward == 0 then 
					itemLua.rewardsRight.arrived:SetActive(false)
					itemLua.rewardsRight.received:SetActive(false)
				
				--1为已领取	
				elseif data.isCashReward == 1 then 
					itemLua.rewardsRight.arrived:SetActive(false)
					itemLua.rewardsRight.received:SetActive(true)
					--可领取
				elseif data.isCashReward == 2 then
					itemLua.rewardsRight.arrived:SetActive(true)
					itemLua.rewardsRight.received:SetActive(false)
				end

			else
				itemLua.rewardsRight.arrived:SetActive(false)
				itemLua.rewardsRight.received:SetActive(false)
			end
			

			itemLua.activity:SetActive(false)
			--直接根据等级判断，小于当前等级的直接拉满，大于当前等级的则为空
			if curLv+1 > idx then
				itemLua.levelSlider.slider.value = 1
				itemLua.activity:SetActive(true)
			elseif curLv < idx+1 then
				itemLua.levelSlider.slider.value = 0
			end
			
			--左侧经验条slider，因遮挡问题，只有经验超出10%，小飞机才会飞到下一级
			if curLv == #self.rewardsBaseData:GetShowRewardsData() then

				itemLua.airShip:SetActive(false)
			else
				if curLv+1 == idx and curExp/self.curLvData.cfgData.Exp > 0.15 then
					itemLua.airShip:SetActive(true)
					--LogError('aaacc'..curExp.."aac"..self.curLvData.cfgData.Exp)
					itemLua.levelSlider.slider.value = curExp/self.curLvData.cfgData.Exp
					self.isShowAirShip = true
				else
					if curLv == idx and not self.isShowAirShip then
						itemLua.airShip:SetActive(true)
						--itemLua.levelSlider.slider.value = self.controller:GetShowRewardsCurExp()/self.curLvData.cfgData.Exp
					else
						itemLua.airShip:SetActive(false)
					end
					
				end
			end

		
		end
	end
end

function UIRuneShopView:RefreshBigRewardsFloatTips(gridView)
	--通过content高度计算当前处于哪个位置
	local py = self.rewardsBoxItemLua.scrollView.content.transform.localPosition.y
	local mid = #self.rewardsBaseData:GetShowRewardsData() - self:Toint(py/240)

	--下方的大奖小图标
	local minid = self.controller:GetShowReardsNearMinCashReward(mid -3)

	if minid then
		self.rewardsBoxItemLua.btnGotoDown:SetActive(true)
		local logicData ={}
		local rdata=self.controller:GetShowRewardsDataByIdx(minid)
		if	rdata.cfgData.RewardSign == 1 then
			logicData = {cfgId = rdata.cfgData.Reward[1][1],num = rdata.cfgData.Reward[1][2] , targetid = #self.controller:GetShowRewardsData()-minid}
		elseif rdata.cfgData.RewardSign == 2 then
			logicData = {cfgId = rdata.cfgData.CashReward[1][1],num = rdata.cfgData.CashReward[1][2] , targetid = #self.controller:GetShowRewardsData()-minid}
		end
		
		CommonUtil.UpdateItemPrefab(self, self.rewardsBoxItemLua.btnGotoDown.iconSmallItem, logicData, Enum.ItemIEnterType.Bag, self, self.JumpToTarget)
	else
		self.rewardsBoxItemLua.btnGotoDown:SetActive(false)
	end
	--上方的大奖小图标
	local maxid = self.controller:GetShowReardsNearMaxCashReward(mid +3)
	if maxid then
		self.rewardsBoxItemLua.btnGotoUp:SetActive(true)
		local logicData ={}
		local rdata=self.controller:GetShowRewardsDataByIdx(maxid)
		if rdata.cfgData.RewardSign == 1 then
			logicData = {cfgId = rdata.cfgData.Reward[1][1],num = rdata.cfgData.Reward[1][2] , targetid = #self.controller:GetShowRewardsData()-maxid}
		elseif rdata.cfgData.RewardSign == 2 then
			logicData = {cfgId = rdata.cfgData.CashReward[1][1],num = rdata.cfgData.CashReward[1][2] , targetid = #self.controller:GetShowRewardsData()-maxid}
		end
		
		CommonUtil.UpdateItemPrefab(self, self.rewardsBoxItemLua.btnGotoUp.iconSmallItem, logicData, Enum.ItemIEnterType.Bag, self, self.JumpToTarget)
	else
		self.rewardsBoxItemLua.btnGotoUp:SetActive(false)
	end
end

function UIRuneShopView:Toint(n)
    local s = tostring(n)
    local i,j = s:find('%.')
    if i then
        return tonumber(s:sub(1,i-1))
    else
        return n
    end
end

function UIRuneShopView:GetItemByRowColumnLimited(loopGridView, itemIdx, row, column)
	local data = self.controller:GetShowGoodsDataByIdx(itemIdx + 1)
	if not data then return nil end
	local item = loopGridView:NewListViewItem('RuneShopLimitedItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'RuneShopLimitedItem', item.gameObject)
	if itemLua then
		itemLua.itemIcon.image.sprite = nil
		itemLua.itemIcon.image.enabled = false
		local cfgData = data.cfgData
		if cfgData then
			CommonUtil.LoadIcon(self, cfgData.Banner, function(sprite)
				if sprite then
					itemLua.itemIcon.image.sprite = sprite
					itemLua.itemIcon.image.enabled = true
				end
			end, itemLua, 'ItemIcon')
		end
		if data:HasEndTime() then
			local timerStr = data:CalculateLimitTime()
			itemLua.timerLab.text.text.text = string.formatbykey('RuneShopLimitTime', timerStr)
			itemLua.timerLab:SetActive(true)
			self:StartRefreshTimer(itemLua, data)
		else
			self:StopRefreshTimer(itemLua)
			itemLua.timerLab:SetActive(false)
		end
		local price = data:GetPrice()
		if price <= 0 then
			itemLua.presentPrice.number.text.text = string.formatbykey('Free')
		else
			itemLua.presentPrice.number.text.text = tostring(price)
		end
		if data:IsSoldout() then
			itemLua.soldout:SetActive(true)
			itemLua.button.onClick:RemoveAllListeners()
			itemLua.presentPrice.button.onClick:RemoveAllListeners()
		else
			itemLua.soldout:SetActive(false)
			self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickLimitedItem, data:GetId(), itemIdx)
			self.uiBase:AddButtonUniqueEventListener(itemLua.presentPrice.button, self, self.OnClickLimitedPrice, data:GetId(), itemIdx)
		end
		itemLua.redPoint:SetActive(ManagerContainer.RedPointMgr.RSLimitGiftRPCtr:GetRedPointStatusById(data:GetId()))
	end
	return item
end

function UIRuneShopView:GetItemByRowColumnRewards(loopGridView, itemIdx, row, column)
	--通用等级奖励
	local item
	if itemIdx == 0 then 
		item = loopGridView:NewListViewItem('CloudTop')
		local itemEndLua = CommonUtil.BindGridViewItem2Lua(self, 'CloudTop', item.gameObject)
		self:UpdateRewardsItem(itemEndLua , itemIdx , data ,true)
	else
		item = loopGridView:NewListViewItem('RuneShopRewardsItem')
		local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'RuneShopRewardsItem', item.gameObject)
		local data
		local showGoodsDatas = self.controller:GetShowRewardsData()
		local length = (showGoodsDatas and #showGoodsDatas or 0)
		if itemIdx-1 < length then 
			data = self.controller:GetShowRewardsDataByIdx(length-(itemIdx-1))
		end
		self:UpdateRewardsItem(itemLua , length-(itemIdx-1) , data)
	end
	return item
end


function UIRuneShopView:RefreshCurrenyItem(itemLua, itemCfgId, itemNum, ignoreIcon)
	if not itemCfgId or not itemNum then
		itemLua:SetActive(false)
		return
	end
	itemLua.number.text.text = CommonUtil.FormatNumber(itemNum)
	itemLua:SetActive(true)
	if ignoreIcon then return end
	itemLua.icon.image.sprite = nil
	itemLua.icon.image.enabled = false
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(itemCfgId)
	if itemCfgData then
		CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function(sprite)
			if sprite then
				itemLua.icon.image.sprite = sprite
				itemLua.icon.image.enabled = true
			end
		end)
	end
end


function UIRuneShopView:StartRefreshTimer(itemLua, goodsData)
	local timer = self.refreshTimer
	if not timer then
		timer = Timer.New(slot(self.RefreshTimer, self), 1, -1)
		self.refreshTimer = timer
	end
	local updateItemMap = timer.updateItemMap
	if not updateItemMap then
		updateItemMap = {}
		timer.updateItemMap = updateItemMap
	end
	updateItemMap[itemLua] = goodsData
	if not timer.running then
		timer:Start()
	end
end

function UIRuneShopView:StopRefreshTimer(itemLua)
	local timer = self.refreshTimer
	if timer then
		local updateItemMap = timer.updateItemMap
		if updateItemMap then
			updateItemMap[itemLua] = nil
		end
		if not updateItemMap or table_is_empty(updateItemMap) then
			timer:Stop()
		end
	end
end

function UIRuneShopView:StopAndClearRefreshTimer()
	if self.refreshTimer then
		self.refreshTimer:Stop()
		self.refreshTimer.time = 1
		self.refreshTimer.duration = 1
		self.refreshTimer.updateItemMap = nil
	end
end

function UIRuneShopView:DisposeRefreshTimer()
	self:StopAndClearRefreshTimer()
	self.refreshTimer = nil
end

function UIRuneShopView:RefreshTimer()
	local timer = self.refreshTimer
	if not timer then return end
	local updateItemMap = timer.updateItemMap
	if not updateItemMap or table_is_empty(updateItemMap) then
		timer:Stop()
		return
	end
	local minRemainTime = nil
	local runeShopType = self.controller:GetShopType()
	if self.controller.isAirShip then
		local endTime = self.controller:GetRewardsRemainTime()
		if endTime then
			if endTime < 0 then
				endTime = 0
			end
			if endTime <= 0 then
				timer.updateItemMap = nil
				if self.controller:ChangeShopType(Enum.RuneShopType.MonthCard) then
					self:RefreshToggleGroupView()
					self:RefreshShopView(true)
				end
				if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIRewardsBuyTips) then
					ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIRewardsBuyTips)
				end
				ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.RuneShopRewards, false)
				ManagerContainer.CfgMgr.RuneShopExploreRewardCfg =nil
				ManagerContainer.CfgMgr.RuneShopRoundMap = nil
				self.rewardsToggle:SetActive(false)
			end
			self.rewardsBoxItemLua.timeBox:SetActive(true)
			self.rewardsBoxItemLua.timeBox.textTime.text.text = string.formatbykey('AirshipTime', DateTimeUtil.convertSeconds2TimeStr1(endTime, true, true, false))
		else
			self.rewardsBoxItemLua.timeBox:SetActive(false)
			timer.updateItemMap = nil
		end
		if endTime and endTime > 0 then
			if not minRemainTime or minRemainTime > endTime then
				minRemainTime = endTime
			end
		end
		return
	end
	if runeShopType == Enum.RuneShopType.MonthCard then
		for itemLua, goodsData in pairs(updateItemMap) do
			local timerStr, outTime, remainTime = goodsData:CalculateLimitTime()
			if not outTime then
				itemLua.textDsc.text.text = string.formatbykey('DscClubMonth2', timerStr)
				itemLua.active:SetActive(true)
				itemLua.unActive:SetActive(false)
			else
				updateItemMap[itemLua] = nil
				itemLua.textDsc.text.text = string.formatbykey('DscClubMonth1')
				itemLua.active:SetActive(false)
				itemLua.unActive:SetActive(true)
			end
			if remainTime and remainTime > 0 then
				if not minRemainTime or minRemainTime > remainTime then
					minRemainTime = remainTime
				end
			end
		end
		if minRemainTime and minRemainTime > 0 then
			minRemainTime = 1
		end
	elseif runeShopType == Enum.RuneShopType.Gifts then
		local endTime = self.controller:GetRemainTime()
		if endTime then
			if endTime < 0 then endTime = 0 end
			if endTime <= 0 then
				timer.updateItemMap = nil
			end
			self.timeBox:SetActive(true)
			self.timeBox.textTime.text.text = string.formatbykey('RuneShopRefreshTime', DateTimeUtil.convertSeconds2TimeStr1(endTime, true, true, false))
		else
			self.timeBox:SetActive(false)
			timer.updateItemMap = nil
		end
		if endTime and endTime > 0 then
			if not minRemainTime or minRemainTime > endTime then
				minRemainTime = endTime
			end
		end
	elseif runeShopType == Enum.RuneShopType.LimitTime then
		for itemLua, goodsData in pairs(updateItemMap) do
			if goodsData:HasEndTime() then
				local timerStr, outTime, remainTime = goodsData:CalculateLimitTime()
				if outTime then
					updateItemMap[itemLua] = nil
				end
				itemLua.timerLab.text.text.text = string.formatbykey('RuneShopLimitTime', timerStr)
				itemLua.timerLab:SetActive(true)
				if remainTime and remainTime > 0 then
					if not minRemainTime or minRemainTime > remainTime then
						minRemainTime = remainTime
					end
				end
			else
				updateItemMap[itemLua] = nil
				itemLua.timerLab:SetActive(false)
			end
			if minRemainTime and minRemainTime > 0 then
				minRemainTime = 1
			end
		end
	
		
	end
	if not minRemainTime or minRemainTime <= 0 then
		self:StopRefreshTimer()
	else
		-- 降低刷新频率
		if self.refreshTimer then
			local validTime = nil
			if minRemainTime >= 86400 then
				validTime = minRemainTime % 3600
				if validTime == 0 then validTime = 3600 end
			elseif minRemainTime >= 3600 then
				validTime = minRemainTime % 60
				if validTime == 0 then validTime = 60 end
			else
				validTime = 1
			end
			if validTime then
				self.refreshTimer.duration = validTime
			else
				self:StopRefreshTimer()
			end
		end
	end
end


return UIRuneShopView

