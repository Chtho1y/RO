local UIRuneShopBuyTipsView = require("UIRuneShop/UIRuneShopBuyTipsView_Generate")

function UIRuneShopBuyTipsView:OnAwake(data)
	self.controller = require("UIRuneShop/UIRuneShopBuyTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIRuneShopBuyTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIRuneShopBuyTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIRuneShopBuyTipsView:Init()
	self.controller:InitData()
	local goodsData = self.controller:GetCurGoodsData()
	if not goodsData then
		self.textTitle.text.text = ''
		self.buyLimitTxt.text.text = ''
		self.presentPrice.number.text.text = ''
		self.goodsList.loopHorizontalScrollRect.horizontal = false
		CommonUtil.LoopGridViewEleCreateNew(self, self.goodsList.loopHorizontalScrollRect, nil, {}, 0, self, self.UpdateIconItem, nil, nil, 0)
		return
	end
	self.textTitle.text.text = self.controller:GetGiftName()
	if not self.controller:IsLimitNum() then
		self.buyLimitTxt.text.text = ''
	else
		self.buyLimitTxt.text.text = string.formatbykey('RuneShopLimitBuy', tostring(self.controller:GetRemainNum()))
	end
	local price = self.controller:GetPrice()
	if price <= 0 then
		self.presentPrice.number.text.text = string.formatbykey('Free')
	else
		self.presentPrice.number.text.text = tostring(price)
	end
	self.goodsList.loopHorizontalScrollRect.horizontal = (#self.controller:GetRewards() > 4)
	CommonUtil.LoopGridViewEleCreateNew(self, self.goodsList.loopHorizontalScrollRect, nil, self.controller:GetRewards(), 0, self, self.UpdateIconItem)
end

function UIRuneShopBuyTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIRuneShopBuyTipsView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnBuy.button, self, self.OnClickBuyBtn)
end

function UIRuneShopBuyTipsView:OnHide()

end

function UIRuneShopBuyTipsView:OnShow(data)
	if data then
		self.controller:SetData(data)
		self.controller:InitData()
		self:Init()
	end
end

function UIRuneShopBuyTipsView:OnClose()
end

function UIRuneShopBuyTipsView:OnDispose()
	self.goodsList.loopHorizontalScrollRect:ClearCells()
	self.goodsList.loopHorizontalScrollRect:ClearAnchoredPostion()
	self.controller:OnDispose()
end

function UIRuneShopBuyTipsView:OnClickCloseBtn()
	self:UIClose()
end

function UIRuneShopBuyTipsView:OnClickBuyBtn()
	local errorCodeKey = self.controller:SendPay()
	if errorCodeKey then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCodeKey)
		return
	end
	self:UIClose()
end

function UIRuneShopBuyTipsView:UpdateIconItem(itemLua, itemIdx, itemData)
	if not itemLua or not itemData then return end
	CommonUtil.UpdateItemPrefab(self, itemLua, itemData, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
end

function UIRuneShopBuyTipsView:ShowItemTips(button, params)
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

return UIRuneShopBuyTipsView

