local UIShopBuyTips1 = class("UIShopBuyTips1")

function UIShopBuyTips1:ctor()
end

function UIShopBuyTips1:InitGo(host,uiGo)
    self.host = host
	self.viewLua = CommonUtil.BindGridViewItem2Lua(self.host, "UIShopBuyTips1", uiGo)
	
    self:InitPanel()
end

function UIShopBuyTips1:InitPanel()

end

function UIShopBuyTips1:AddEventListener()
end

function UIShopBuyTips1:RemoveEventListener()
end

function UIShopBuyTips1:AddUIEventListener()
	self.host.uiBase:AddButtonUniqueEventListener(self.viewLua.btnClose.button, self, self.OnClickCloseBtn)
	self.host.uiBase:AddButtonUniqueEventListener(self.viewLua.AnyBtn.button, self, self.OnClickCloseBtn)

	self.host.uiBase:AddButtonUniqueEventListener(self.viewLua.btnBuy.button, self.host, self.host.OnClickBuyBtn)
end

function UIShopBuyTips1:Show(goodsData)
	self:AddEventListener()

	if not goodsData then
		self.viewLua.textTitle.text.text = ''
		self.viewLua.buyLimitTxt.text.text = ''
		self.viewLua.presentPrice.number.text.text = ''
		self.viewLua.goodsList.loopHorizontalScrollRect.horizontal = false
		CommonUtil.LoopGridViewEleCreateNew(self, self.goodsList.loopHorizontalScrollRect, nil, {}, 0, self, self.UpdateIconItem, nil, nil, 0)
		return
	end
	self.curGoodsData = goodsData
	local cfgData = goodsData.cfgData
	local remainNum = goodsData:GetRemainBuyNum()
	local isLimitNum = (remainNum >= 0)

	self.viewLua.textTitle.text.text = I18N.T(cfgData.GoodsName)
	if not isLimitNum then
		self.viewLua.buyLimitTxt.text.text = ''
	else
		self.viewLua.buyLimitTxt.text.text = string.formatbykey('RuneShopLimitBuy', tostring(remainNum))
	end
	local price = goodsData.curPrice
	if price <= 0 then
		self.viewLua.presentPrice.number.text.text = string.formatbykey('Free')
	else
		self.viewLua.presentPrice.number.text.text = tostring(price)
	end
	local rewards = {}
	for _,v in pairs(cfgData.Reward) do
		rewards[#rewards + 1] = {cfgId = v[1], num = v[2]}
	end
	self.viewLua.goodsList.loopHorizontalScrollRect.horizontal = (#rewards > 4)

	self.viewLua:SetActive(true)
	CommonUtil.LoopGridViewEleCreateNew(self.host, self.viewLua.goodsList.loopHorizontalScrollRect, nil, rewards, 0, self, self.UpdateIconItem)
end

function UIShopBuyTips1:UpdateIconItem(itemLua, itemIdx, itemData)
	if not itemLua or not itemData then return end
	CommonUtil.UpdateItemPrefab(self.host, itemLua, itemData, Enum.ItemIEnterType.Bag, self.host, self.host.ShowItemTips)
end

function UIShopBuyTips1:OnClickCloseBtn()
	self:Hide()
end

function UIShopBuyTips1:Hide()
    self:RemoveEventListener()
	self.viewLua:SetActive(false)
	self:Clear()
end

function UIShopBuyTips1:HidePlayerNodes()

end

function UIShopBuyTips1:Clear()
	self.curGoodsData = nil
end

function UIShopBuyTips1:Dispose()
	self:Hide()
    self.host = nil
    self.viewLua = nil
end


return UIShopBuyTips1