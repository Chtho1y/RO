local UIREShopView = require("UIShop/UIREShopView_Generate")
local UIShopBuyTips1 = require("UIShop/UIShopBuyTips1")
local UIShopGoldBuyTips = require("UIShop/UIShopGoldBuyTips")

local exchangeCostKey = 308
local exchangeCosts
function UIREShopView:OnAwake(data)
	self.controller = require("UIShop/UIREShopCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIREShopView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SHOP_DATA_CHANGED, self, self.OnShopDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Open_Activity_Refresh, self, self.OnOpenActivityRefresh)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_Data_Change, self, self.OnActivityDataChange)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RED_ENVELOPE_CASH_EXCHANGE_SUCCESS, self, self.RefreshResAndRedEnvelope)
end

function UIREShopView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIREShopView:Init()
	local val = GlobalConfig.Instance:GetConfigStrValue(exchangeCostKey)
	if val ~= "" and val ~= nil then
		exchangeCosts = CommonUtil.DeserializeGlobalStrToTable(val)
	end

	self.controller:InitData()
	self.controller:RefreshCurShopData(true)
	self.shopCurrencyItem:SetActive(false)

	self:RefreshRedEnvelope()
	self:RefreshResourceBoxs()
	self:InitGoods()
	self:RefreshGoods(true)

	self:InitSubPanels()
end

function UIREShopView:InitSubPanels()
	if self.shopBuyTips1 == nil then
		self.shopBuyTips1 = UIShopBuyTips1:new()
	end
	self.shopBuyTips1:InitGo(self,self.uiBase:FindChildGo("UIShop/UIShopBuyTips1"))
	self.shopBuyTips1:Hide()

	if self.shopGoldBuyTips == nil then
		self.shopGoldBuyTips = UIShopGoldBuyTips:new()
	end
	self.shopGoldBuyTips:InitGo(self,self.uiBase:FindChildGo("UIShop/UIShopGoldBuyTips"))
	self.shopGoldBuyTips:Hide()
end

function UIREShopView:RefreshResAndRedEnvelope()
	self:RefreshResourceBoxs()
	self:RefreshRedEnvelope()
end

function UIREShopView:RefreshResourceBoxs()
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

function UIREShopView:RefreshRedEnvelope()
	if not exchangeCosts or not exchangeCosts[1] then return end

	local resId = tonumber(exchangeCosts[1][1])
	local count = tonumber(exchangeCosts[1][2])
	local ownerCount = CommonUtil.GetOwnResCountByItemId(resId)

	local state = ownerCount >= count
	if not state then
		self.redEnvelope.desc.text.text = string.formatbykey("CashShopTips01", count)
	end
	self.redEnvelope.desc:SetActive(not state)
	self.redEnvelope.btnSure:SetActive(state)
end

function UIREShopView:InitGoods()
	self.goodsScrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetShopGoodsItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIREShopView:CreateCurrencyItem()
	local go = CommonUtil.Instantiate(self.shopCurrencyItem.gameObject, self.resourceBox.transform)
	return CommonUtil.BindGridViewItem2Lua(self, 'ShopCurrencyItem', go)
end

function UIREShopView:RefreshGoods(resetPos)
	local shopData = self.controller:GetCurShopData()
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

function UIREShopView:GetShopGoodsItemByRowColumn(gridView, itemIndex, row, column)
	local shopData = self.controller:GetCurShopData()
	if not shopData then return nil end
	local goods = shopData:GetShowGoodsDatas()
	if not goods then return nil end
	local goodsData = goods[itemIndex + 1]
	if not goodsData then return nil end
	local item = gridView:NewListViewItem('RuneShopGoodsItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'RuneShopGoodsItem', item.gameObject)
	if itemLua then
		itemLua.itemIcon.image.sprite = nil
		itemLua.itemIcon.image.enabled = false
		local cfgData = goodsData.cfgData

		itemLua.presentPrice.icon:SetActive(true)
		itemLua.presentPrice.currency:SetActive(false)
		
		if cfgData then
			CommonUtil.LoadIcon(self, cfgData.GoodsPic, function(sprite)
				if sprite then
					itemLua.itemIcon.image.sprite = sprite
					itemLua.itemIcon.image.enabled = true
				end
			end, itemLua, 'ItemIcon')

			local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgData.PayForType)
			CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function (sprite)
				itemLua.presentPrice.icon.image.sprite = sprite
			end, itemLua, 'CurrenyIcon')

			itemLua.itemName.text.text = string.formatbykey(cfgData.GoodsName)
			itemLua.discount:SetActive(false)
			self:RefreshGiftsItem(itemLua, nil, nil, cfgData.Reward)
		else
			itemLua.discount:SetActive(false)
			itemLua.itemName.text.text = ''
			itemLua.specialReward:SetActive(false)
			itemLua.goodsItems:SetActive(false)
		end
		local remainBuyNum = goodsData:GetRemainBuyNum()
		if remainBuyNum >= 0 then
			itemLua.purchaseLimit:SetActive(true)
			itemLua.purchaseLimit.text.text = string.formatbykey('RuneShopLimitBuy', tostring(remainBuyNum))
		else
			itemLua.purchaseLimit:SetActive(false)
		end
		local price = goodsData.curPrice
		if price <= 0 then
			itemLua.presentPrice.number.text.text = string.formatbykey('Free')
		else
			itemLua.presentPrice.number.text.text = tostring(price)
		end
		if goodsData:IsSoldout() then
			itemLua.soldout:SetActive(true)
			itemLua.button.onClick:RemoveAllListeners()
			itemLua.presentPrice.button.onClick:RemoveAllListeners()
		else
			itemLua.soldout:SetActive(false)
			self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickGiftItem, goodsData)
			self.uiBase:AddButtonUniqueEventListener(itemLua.presentPrice.button, self, self.OnClickGiftPrice, goodsData)
		end
	end

	return item
end

function UIREShopView:RefreshGiftsItem(itemLua, bgPic, numPic, rewards)
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

function UIREShopView:DisposeCurrencyItems()
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

function UIREShopView:OnClickGiftItem(button, params)
	local goodsData = params[0]
	self.controller:SetCurGoodsData(goodsData)
	if self.shopBuyTips1 then
		self.shopBuyTips1:Show(goodsData)
	end
end

function UIREShopView:OnRedEnvelopeBtnClick(button, params)
	if self.shopGoldBuyTips then
		self.shopGoldBuyTips:Show()
	end
end

function UIREShopView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'CashShopExplain'})
end

function UIREShopView:OnClickGiftPrice(button, params)
	local goodsData = params[0]
	self.controller:SetCurGoodsData(goodsData)
	self:OnClickBuyBtn()
end

function UIREShopView:OnClickBuyBtn()
	local errorCode, itemCfgId = self.controller:SendShopBuyItemReq()
	LogWarning("errorCode "..errorCode)
	if errorCode ~= 0 then
		if errorCode == 391 then
			CommonUtil.ItemNotEnoughHandle(itemCfgId, Enum.UIPageName.UIShop)
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
	if self.shopBuyTips1 then
		self.shopBuyTips1:Hide()
	end
end

function UIREShopView:ShowItemTips(button, params)
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

function UIREShopView:OnShopDataChanged(shopId)
	local cfgData = self.controller:GetCurShopCfgData()
	if cfgData and cfgData.Id ~= shopId then return end
	self.controller:RefreshCurShopData()
	self:RefreshRedEnvelope()
	self:RefreshResourceBoxs()
	self:RefreshGoods()
end

function UIREShopView:OnOpenActivityRefresh(actIds)
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
	self:RefreshRedEnvelope()
	self:RefreshResourceBoxs()
	self:RefreshGoods()
end

function UIREShopView:OnActivityDataChange(actId)
	if not actId then return end
	local activityItem = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(actId)
	if not activityItem then return end
	if activityItem.type ~= Enum.ActivityType.ACTIVITY_TYPE_SHOP then
		return
	end
	self.controller:InitData()
	self.controller:RefreshCurShopData(true)
	self:RefreshRedEnvelope()
	self:RefreshResourceBoxs()
	self:RefreshGoods()
end

function UIREShopView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIREShopView:AddUIEventListener()
	self.shopBuyTips1:AddUIEventListener()
	self.shopGoldBuyTips:AddUIEventListener()

	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.redEnvelope.btnSure.button, self, self.OnRedEnvelopeBtnClick)
	self.uiBase:AddButtonEventListener(self.btnInfo.button, self, self.OnClickPlayRuleBtn)
end

function UIREShopView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIREShopView:OnHide()

end

function UIREShopView:OnShow(data)
	if data then
		self.controller:SetData(data)
	end
	self.controller:InitData()
	self.controller:RefreshCurShopData(true)
	self:RefreshResourceBoxs()
	self:RefreshGoods()
end

function UIREShopView:OnClose()
	if self.shopBuyTips1 ~= nil then
		self.shopBuyTips1:Dispose()
		self.shopBuyTips1 = nil
	end

	if self.shopGoldBuyTips ~= nil then
		self.shopGoldBuyTips:Dispose()
		self.shopGoldBuyTips = nil
	end
end

function UIREShopView:OnDispose()
	self.goodsScrollView.loopGridView:Dispose()
	self:DisposeCurrencyItems()
	self.controller:OnDispose()
end

return UIREShopView

