local UIShopView = require("UIShop/UIShopView_Generate")

function UIShopView:OnAwake(data)
	self.controller = require("UIShop/UIShopCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIShopView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SHOP_DATA_CHANGED, self, self.OnShopDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Open_Activity_Refresh, self, self.OnOpenActivityRefresh)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_Data_Change, self, self.OnActivityDataChange)
end

function UIShopView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIShopView:Init()
	self.controller:InitData()
	self.controller:RefreshCurShopData(true)
	self.shopCurrencyItem:SetActive(false)
	self:InitLabels()
	self:RefreshLabels(true)
	self:RefreshResourceBoxs()
	self:RefreshGirlDialogue()
	self:InitGoods()
	self:RefreshGoods(true)
end

function UIShopView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

	self.labelScrollView.loopGridView.mOnBeginDragAction = nil
	self.labelScrollView.loopGridView.mOnSnapItemFinished = nil
end

function UIShopView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnRefresh.button, self, self.OnClickRefreshBtn)

	self.labelScrollView.loopGridView.mOnBeginDragAction = function(gridView)
		gridView.ItemSnapEnable = false
	end
	self.labelScrollView.loopGridView.mOnSnapItemFinished = function(gridView, gridViewItem)
		gridView.ItemSnapEnable = false
	end
end

function UIShopView:OnHide()

end

function UIShopView:OnShow(data)
	if data then
		self.controller:SetData(data)
	end
	self.controller:InitData()
	self.controller:RefreshCurShopData(true)
	self:RefreshLabels()
	self:RefreshResourceBoxs()
	self:RefreshGirlDialogue()
	self:RefreshGoods()
end

function UIShopView:OnClose()
end

function UIShopView:OnDispose()
	if self.needRefreshTimer then
		self.needRefreshTimer:Stop()
		self.needRefreshTimer = nil
	end
	if self.labelRefreshTimer then
		self.labelRefreshTimer:Stop()
		self.labelRefreshTimer = nil
	end
	if self.dialogueTimer then
		self.dialogueTimer:Stop()
		self.dialogueTimer = nil
	end
	self:DisposeRefreshTimer()
	self:DisposeShopGoodsItemTimer()
	self.goodsScrollView.loopGridView:Dispose()
	self.labelScrollView.loopGridView:Dispose()
	self:DisposeCurrencyItems()
	self.controller:OnDispose()
end

function UIShopView:OnShopDataChanged(shopId)
	local cfgData = self.controller:GetCurShopCfgData()
	if cfgData and cfgData.Id ~= shopId then return end
	self.controller:RefreshCurShopData()
	self:RefreshResourceBoxs()
	self:RefreshGoods()
end

function UIShopView:OnOpenActivityRefresh(actIds)
	if not actIds then return end
	local changed = false
	for _, actId in pairs(actIds) do
		local activityItem = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(actId)
		if activityItem and activityItem.type == Enum.ActivityType.ACTIVITY_TYPE_SHOP then
			changed = true
			break
		end
	end
	if not changed then return end
	self.controller:InitData()
	self.controller:RefreshCurShopData(true)
	self:RefreshLabels()
	self:RefreshResourceBoxs()
	self:RefreshGirlDialogue()
	self:RefreshGoods()
end

function UIShopView:OnActivityDataChange(actId)
	if not actId then return end
	local activityItem = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(actId)
	if not activityItem then return end
	if activityItem.type ~= Enum.ActivityType.ACTIVITY_TYPE_SHOP then
		return
	end
	self.controller:InitData()
	self.controller:RefreshCurShopData(true)
	self:RefreshLabels()
	self:RefreshResourceBoxs()
	self:RefreshGirlDialogue()
	self:RefreshGoods()
end


function UIShopView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIShopView:OnClickRefreshBtn()
	local cfgData = self.controller:GetCurShopCfgData()
	if not cfgData then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(397)
		return
	end
	-- if cfgData.ShopType ~= 2 then
	-- 	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(397)
	-- 	return
	-- end
	local costNum, costCfgId = self.controller:GetRefreshCostInfo()
	local costName
	if costCfgId then
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(costCfgId)
		if itemCfgData then
			costName = itemCfgData.Name
		end
	end
	local shopData = self.controller:GetCurShopData()
	local refreshNum = shopData and shopData:GetRefreshCount() or 0
	local refreshMaxNum = cfgData.RefreshNum or 0
	local data = {"ShopRefreshSure", {tostring(costNum), tostring(costName)}, nil, self, self.SureRefreshShop, nil, {(refreshMaxNum - refreshNum)}}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
end

function UIShopView:SureRefreshShop()
	local errorCode, itemCfgId = self.controller:SendRefreshShopReq()
	if errorCode ~= 0 then
		-- if errorCode == 396 then
		-- 	CommonUtil.ItemNotEnoughHandle(itemCfgId, self)
		-- else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		-- end
	-- else
	-- 	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ShopTips")
	end
end

function UIShopView:OnClickLabelItem(btn, params)
	local itemIndex = params[0]
	local idx = itemIndex + 1
	local lastIdx = self.controller:GetCurSelectIdx()
	if not self.controller:SetCurSelectIdx(idx) then return end
	self:RefreshLabelSelectState(lastIdx - 1, false)
	self:RefreshLabelSelectState(itemIndex, true)
	self:RefreshLabelsSnap(itemIndex)
	self:RefreshResourceBoxs()
	self:RefreshGirlDialogue()
	self:RefreshGoods(true)
end

function UIShopView:InitLabels()
	local initParam = SuperScrollView.LoopGridViewInitParam()
	initParam.mSmoothDumpRate = 0.05
	self.labelScrollView.loopGridView.ItemSnapEnable = false
	self.labelScrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetLabelItemByRowColumn(gridView, itemIndex, row, column)
	end, nil, nil, initParam)
end

function UIShopView:RefreshLabelsSnap(itemIndex)
	local loopGridView = self.labelScrollView.loopGridView
	local pair1 = loopGridView:GetRowColumnByItemIndex(itemIndex)
	local pair2 = loopGridView:GetRowColumnByItemIndex(itemIndex + 1)
	local offset = loopGridView.ContainerTrans.anchoredPosition
	local itemPosStart = loopGridView:GetItemPos(pair1.mRow, pair1.mColumn) + offset
	local itemPosEnd = loopGridView:GetItemPos(pair2.mRow, pair2.mColumn) + offset
	local rect = loopGridView.ScrollRect.viewport.rect
	local isStart = (itemPosStart.x >= rect.xMin) and (itemPosStart.x <= rect.xMax)
	local isEnd = (itemPosEnd.x >= rect.xMin) and (itemPosEnd.x <= rect.xMax)
	if isStart and isEnd then
		return
	end
	loopGridView.ItemSnapEnable = true
	loopGridView:SetSnapTargetItemRowColumn(pair1.mRow, pair1.mColumn)
	if isEnd then
		loopGridView.ItemSnapPivot = Vector2.zero
		loopGridView.ViewPortSnapPivot = Vector2.zero
		return
	end
	loopGridView.ItemSnapPivot = Vector2.one
	loopGridView.ViewPortSnapPivot = Vector2.one
end

function UIShopView:RefreshLabels(resetPos)
	local datas = self.controller:GetShopLs()
	local length = datas and #datas or 0
	if resetPos then
		local idx = self.controller:GetCurSelectIdx()
		self.labelScrollView.loopGridView:RefreshListByIndex(length, idx and (idx - 1) or 0)
	else
		self.labelScrollView.loopGridView:RefreshListByIndex(length)
	end

	local nearestRemainTime = self.controller:GetNearestRemainTime()
	if nearestRemainTime then
		if nearestRemainTime <= 0 then
			nearestRemainTime = 1
		end
		if not self.labelRefreshTimer then
			self.labelRefreshTimer = Timer.New(slot(self.RefreshLabelsTimer, self), nearestRemainTime, -1)
		else
			self.labelRefreshTimer.time = 0
			self.labelRefreshTimer.duration = nearestRemainTime
		end
		if not self.labelRefreshTimer.running then
			self.labelRefreshTimer:Start()
		end
	else
		if self.labelRefreshTimer and self.labelRefreshTimer.running then
			self.labelRefreshTimer:Stop()
		end
	end
end

function UIShopView:RefreshLabelsTimer()
	if self.labelRefreshTimer and self.labelRefreshTimer.running then
		self.labelRefreshTimer:Stop()
	end
	self.controller:InitData()
	self:RefreshLabels()
	self:RefreshGirlDialogue()
	self:RefreshGoods()
end

function UIShopView:RefreshLabelSelectState(itemIndex, state)
	local item = self.labelScrollView.loopGridView:GetShownItemByItemIndex(itemIndex)
	if not item then return end
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'ShopLabelToggleItem', item.gameObject)
	if not itemLua then return end
	if state then
		itemLua.off:SetActive(false)
		itemLua.on:SetActive(true)
		itemLua.button.onClick:RemoveAllListeners()
		itemLua.button.interactable = false
	else
		itemLua.off:SetActive(true)
		itemLua.on:SetActive(false)
		itemLua.button.interactable = true
		self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickLabelItem, itemIndex)
	end
end

function UIShopView:GetLabelItemByRowColumn(gridView, itemIndex, row, column)
	local idx = itemIndex + 1
	local itemData = self.controller:GetShopByIdx(idx)
	if not itemData then
		return nil
	end
	local item = gridView:NewListViewItem('ShopLabelToggleItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'ShopLabelToggleItem', item.gameObject)
	itemLua.icon.image.sprite = nil
	itemLua.icon.image.enabled = false
	CommonUtil.LoadIcon(self, itemData.Icon, function(sprite)
		if sprite then
			itemLua.icon.image.sprite = sprite
			itemLua.icon.image.enabled = true
		end
	end)

	itemLua.nameTxt.uILocalizeScript:SetContent(itemData.Name)

	if (self.controller:GetCurSelectIdx() == idx) then
		itemLua.off:SetActive(false)
		itemLua.on:SetActive(true)
		itemLua.button.onClick:RemoveAllListeners()
		itemLua.button.interactable = false
	else
		itemLua.off:SetActive(true)
		itemLua.on:SetActive(false)
		itemLua.button.interactable = true
		self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickLabelItem, itemIndex)
	end
	return item
end

function UIShopView:RefreshResourceBoxs()
	local cfgData = self.controller:GetCurShopCfgData()
	local currencyLs = cfgData and cfgData.Currency or nil
	local showIdx = 0
	local currencys = self.currencys
	if not currencys then
		currencys = {}
		self.currencys = currencys
	end
	if currencyLs then
		for i = 1, #currencyLs do
			showIdx = i
			local itemId = currencyLs[i]
			local itemLua = currencys[i]
			if not itemLua then
				itemLua = self:CreateCurrencyItem()
				currencys[i] = itemLua
			end
			itemLua:SetActive(true)
			itemLua.icon.image.sprite = nil
			itemLua.icon.image.enabled = false
			local itemCfgData = ManagerContainer.CfgMgr:GetItemById(itemId)
			if itemCfgData then
				CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function(sprite)
					itemLua.icon.image.sprite = sprite
					itemLua.icon.image.enabled = true
				end)
				itemLua.number.text.text = CommonUtil.FormatNumber(CommonUtil.GetOwnResCountByItemId(itemId))
			else
				itemLua.number.text.text = '0'
			end
		end
	end

	for i = showIdx + 1, #currencys do
		local currency = currencys[i]
		if currency then
			currency:SetActive(false)
		end
	end
end

function UIShopView:CreateCurrencyItem()
	local go = CommonUtil.Instantiate(self.shopCurrencyItem.gameObject, self.resourceBox.transform)
	return CommonUtil.BindGridViewItem2Lua(self, 'ShopCurrencyItem', go)
end

function UIShopView:DisposeCurrencyItems()
	if not self.currencys then return end
	for _, currency in pairs(self.currencys) do
		if currency then
			local go = currency.gameObject
			CommonUtil.ClearGridViewItem(self, currency)
			CommonUtil.DestroyGO(go)
		end
	end
	self.currencys = nil
end

function UIShopView:RefreshGirlDialogue()
	local cfgData = self.controller:GetCurShopCfgData()
	local endTime = self.controller:GeCurEndTime()
	if endTime and endTime > 0 then
		local remainTime = endTime - ManagerContainer.LuaTimerMgr:GetTimeSecond()
		if remainTime > 0 then
			self.talkBoxTxt.uILocalizeScript:SetContentAndValues(cfgData and cfgData.Desc or '', {DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, true)})
			local validTime = nil
			if remainTime >= 86400 then
				validTime = remainTime % 3600
				if validTime == 0 then validTime = 3600 end
			elseif remainTime >= 3600 then
				validTime = remainTime % 60
				if validTime == 0 then validTime = 60 end
			else
				validTime = 1
			end
			if not self.dialogueTimer then
				self.dialogueTimer = Timer.New(slot(self.RefreshGirlDialogue, self), validTime, -1)
			else
				self.dialogueTimer.duration = validTime
			end
			if not self.dialogueTimer.running then
				self.dialogueTimer:Start()
			end
			return
		end
	end
	if self.dialogueTimer and self.dialogueTimer.running then
		self.dialogueTimer:Stop()
	end
	self.talkBoxTxt.uILocalizeScript:SetContentAndValues(cfgData and cfgData.Desc or '', {DateTimeUtil.convertSeconds2TimeStr1(0, true, true, true)})
end

function UIShopView:InitGoods()
	self.goodsScrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetShopGoodsItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIShopView:RefreshGoods(resetPos)
	local cfgData = self.controller:GetCurShopCfgData()
	local shopData = self.controller:GetCurShopData()
	local shopType = cfgData and cfgData.ShopType or nil
	self.timeBox:SetActive(shopType == 2)
	if shopType == 2 then
		local remainTime  = 0
		local refreshTime = shopData and shopData:GetRefreshTime() or 0
		if refreshTime and refreshTime > 0 then
			remainTime = ManagerContainer.LuaTimerMgr:GetRemainSeconds(refreshTime)
		end
		self.textTime.text.text = string.formatbykey('ShopOutTime', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false))
		if not remainTime or remainTime <= 0 then
			self:StopRefreshTimer()
		else
			self:StartRefreshTimer()
		end
	else
		self.textTime.text.text = ''
		self:StopRefreshTimer()
	end

	local length = 0
	if shopData then
		local goods = shopData:GetShowGoodsDatas()
		if goods then
			length = #goods
		end
		-- 处理在时间段显示的商品，或不需要通过服务器就能刷新的数据
		-- local remain = ManagerContainer.LuaTimerMgr:GetRemainSeconds(shopData:GetNeedRefreshTime())
		-- if self.needRefreshTimer then
		-- 	self.needRefreshTimer:Stop()
		-- end
		-- if remain > 0 then
		-- 	self.needRefreshTimer = Timer.New(function()
		-- 		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ShopTips")
		-- 		local curShopData = self.controller:GetCurShopData()
		-- 		if curShopData then
		-- 			curShopData:RefreshShowGoodsDatas()
		-- 		end
		-- 		self:RefreshGoods(true)
		-- 	end, remain + 1, 1)
		-- 	if not self.needRefreshTimer.running then
		-- 		self.needRefreshTimer:Start()
		-- 	end
		-- end
	end
	if resetPos then
		self.goodsScrollView.loopGridView:RefreshListByIndex(length, 0)
	else
		self.goodsScrollView.loopGridView:RefreshListByIndex(length)
	end
end


function UIShopView:StartRefreshTimer()
	local timer = self.refreshTimer
	if not timer then
		timer = Timer.New(function()
			self:RefreshTimer()
		end, 1, -1)
		self.refreshTimer = timer
	end
	if not timer.running then
		timer:Start()
	end
end

function UIShopView:StopRefreshTimer()
	if self.refreshTimer then
		self.refreshTimer:Stop()
	end
end

function UIShopView:DisposeRefreshTimer()
	self:StopRefreshTimer()
	self.refreshTimer = nil
end

function UIShopView:RefreshTimer()
	local cfgData = self.controller:GetCurShopCfgData()
	local shopData = self.controller:GetCurShopData()
	if not cfgData or not shopData then
		self:StopRefreshTimer()
		return
	end
	local remainTime  = 0
	local refreshTime = shopData:GetRefreshTime()
	if refreshTime and refreshTime > 0 then
		remainTime = ManagerContainer.LuaTimerMgr:GetRemainSeconds(refreshTime)
	end
	self.textTime.text.text = I18N.SetLanguageValue('ShopOutTime', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false))
	if not remainTime or remainTime <= 0 then
		self:StopRefreshTimer()
	else
		if self.refreshTimer then
			local validTime = nil
			if remainTime >= 86400 then
				validTime = remainTime % 3600
				if validTime == 0 then validTime = 3600 end
			elseif remainTime >= 3600 then
				validTime = remainTime % 60
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


function UIShopView:GetShopGoodsItemByRowColumn(gridView, itemIndex, row, column)
	local shopData = self.controller:GetCurShopData()
	if not shopData then return nil end
	local goods = shopData:GetShowGoodsDatas()
	if not goods then return nil end
	local goodsData = goods[itemIndex + 1]
	if not goodsData then return nil end
	local item = gridView:NewListViewItem('ShopGoodsItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'ShopGoodsItem', item.gameObject)
	local goodsCfgData = goodsData:GetGoodsCfgData()

	local data = {cfgId = goodsCfgData.GoodsItem}
	-- CommonUtil.UpdateItemPrefab(self, itemLua.iconItem, data, nil, self, self.ShowItemTips, data)
	CommonUtil.UpdateItemPrefab(self, itemLua.iconItem, data, nil)

	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(goodsCfgData.PayForType)
	CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function (sprite)
		itemLua.presentPrice.icon.image.sprite = sprite
		itemLua.originalPrice.icon.image.sprite = sprite
    end, itemLua, 'CurrenyIcon')

	itemLua.itemName.text.text = goodsCfgData.GoodsName
	itemLua.presentPrice.number.text.text = goodsData.curPrice	--现价
    if goodsData:IsDiscount() then --折扣
		itemLua.discount:SetActive(true)
		itemLua.originalPrice:SetActive(true)
        local discountNum = goodsData.disPercent
        --不是中文环境
        if not (ManagerContainer.LuaGameMgr.CurLangKey == "_cn"
                or ManagerContainer.LuaGameMgr.CurLangKey == "_tw") then
					discountNum = 100 - goodsData.disPercent
        else
            discountNum = goodsData.disPercent * 0.1
        end
        itemLua.discount.text.text.text = I18N.SetLanguageValue("ShopDiscount", tostring(discountNum))	-- {0}折,中文是：{0}折，非中文是{0}%off
		itemLua.originalPrice.number.text.text = goodsData.price
	elseif goodsData.hot then	--热销
		itemLua.discount:SetActive(true)
		itemLua.originalPrice:SetActive(false)
		itemLua.discount.text.text.text = I18N.T("ShopSellwell")
	else
		itemLua.discount:SetActive(false)
		itemLua.originalPrice:SetActive(false)
	end

	local limitType = goodsData.limitType
	if limitType == Enum.LimitBuyType.NoLimit then
		itemLua.purchaseLimit:SetActive(false)
		itemLua.limitBox:SetActive(false)
		self:StopShopGoodsItemTimer(itemLua)
	elseif limitType == Enum.LimitBuyType.Forever then
		itemLua.purchaseLimit:SetActive(true)
		local remainNum = (goodsData.count - goodsData.buyNum)
		if remainNum < 0 then remainNum = 0 end
		itemLua.purchaseLimit.text.text = string.formatbykey("ShopForeverBuy", remainNum)
		itemLua.limitBox:SetActive(false)
		self:StopShopGoodsItemTimer(itemLua)
	elseif limitType == Enum.LimitBuyType.Daily then
		itemLua.purchaseLimit:SetActive(true)
		local remainNum = (goodsData.count - goodsData.buyNum)
		if remainNum < 0 then remainNum = 0 end
		itemLua.purchaseLimit.text.text = string.formatbykey("ShopDayBuy", remainNum)
		itemLua.limitBox:SetActive(true)
		itemLua.timeLimit.text.text = goodsData:CalculateLimitTime()
		self:StartShopGoodsItemTimer(itemLua, goodsData)
	elseif limitType == Enum.LimitBuyType.Week then
		itemLua.purchaseLimit:SetActive(true)
		local remainNum = (goodsData.count - goodsData.buyNum)
		if remainNum < 0 then remainNum = 0 end
		itemLua.purchaseLimit.text.text = string.formatbykey("ShopLoopBuy", remainNum)
		itemLua.limitBox:SetActive(true)
		itemLua.timeLimit.text.text = goodsData:CalculateLimitTime()
		self:StartShopGoodsItemTimer(itemLua, goodsData)
	elseif limitType == Enum.LimitBuyType.Time then
		itemLua.purchaseLimit:SetActive(true)
		local remainNum = (goodsData.count - goodsData.buyNum)
		if remainNum < 0 then remainNum = 0 end
		itemLua.purchaseLimit.text.text = string.formatbykey("ShopLimitBuy", remainNum)
		itemLua.limitBox:SetActive(true)
		itemLua.timeLimit.text.text = goodsData:CalculateLimitTime()
		self:StartShopGoodsItemTimer(itemLua, goodsData)
	elseif limitType == Enum.LimitBuyType.Special then
		itemLua.purchaseLimit:SetActive(true)
		local remainNum = (goodsData.count - goodsData.buyNum)
		if remainNum < 0 then remainNum = 0 end
		itemLua.purchaseLimit.text.text = string.formatbykey("ShopLimitBuy", remainNum)
		itemLua.limitBox:SetActive(false)
		self:StopShopGoodsItemTimer(itemLua)
	else
		itemLua.purchaseLimit:SetActive(false)
		itemLua.limitBox:SetActive(false)
		self:StopShopGoodsItemTimer(itemLua)
	end
	itemLua.soldout:SetActive(goodsData:IsSoldout())
    self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickShopGoodsItem, goodsData)
	self.uiBase:AddButtonUniqueEventListener(itemLua.presentPrice.button, self, self.OnClickShopGoodsItem, goodsData)

	return item
end

-- function UIShopView:ShowItemTips(button, params)
-- 	local data = params[0]
-- 	ManagerContainer.LuaUIMgr:OpenTips(data)
-- end

function UIShopView:OnClickShopGoodsItem(btn, params)
	local shopData = self.controller:GetCurShopData()
	if not shopData then return end
    -- if ManagerContainer.LuaTimerMgr:GetRemainSeconds(shopData:GetNeedRefreshDataTime()) <= 0 then
	-- 	local errorCode = self.controller:SendShopInfoReq()
	-- 	if errorCode ~= 0 then
	-- 		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	-- 	else
	-- 		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ShopTips")
	-- 	end
    -- end
	local goodsData = params[0]
	if not goodsData then return end
	-- if goodsData:IsCanBuy() then
	if not goodsData:IsSoldout() then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIShopBuyTips, {shopData.shopId, goodsData.id})
	end
end


function UIShopView:StartShopGoodsItemTimer(itemLua, goodsData)
	local timer = self.shopGoodsItemTimer
	if not timer then
		timer = Timer.New(function()
			self:RefreshShopGoodsItemTimer()
		end, 1, -1)
		self.shopGoodsItemTimer = timer
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

function UIShopView:StopShopGoodsItemTimer(itemLua)
	local timer = self.shopGoodsItemTimer
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

function UIShopView:DisposeShopGoodsItemTimer()
	if self.shopGoodsItemTimer then
		self.shopGoodsItemTimer:Stop()
		self.shopGoodsItemTimer.updateItemMap = nil
		self.shopGoodsItemTimer = nil
	end
end

function UIShopView:RefreshShopGoodsItemTimer()
	local timer = self.shopGoodsItemTimer
	if not timer then return end
	local updateItemMap = timer.updateItemMap
	if not updateItemMap or table_is_empty(updateItemMap) then
		timer:Stop()
		return
	end
	for itemLua, goodsData in pairs(updateItemMap) do
		itemLua.limitBox:SetActive(true)
        itemLua.timeLimit.text.text = goodsData:CalculateLimitTime()
	end
end

return UIShopView

