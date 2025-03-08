local UIRewardsBuyTipsView = require("UIRuneShop/UIRewardsBuyTipsView_Generate")

function UIRewardsBuyTipsView:OnAwake(data)
	self.controller = require("UIRuneShop/UIRewardsBuyTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIRewardsBuyTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
end

function UIRewardsBuyTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIRewardsBuyTipsView:Init()
	self.controller:InitData()
	local goodsData = self.controller:GetCurGoodsData()
	self.goodsList.loopVerticalScrollRect.vertical = false
	if not goodsData then
		self.textTitle.text.text = ''
	
		self.presentPrice.number.text.text = ''
		
		CommonUtil.LoopGridViewEleCreateNew(self, self.goodsList.loopVerticalScrollRect, nil, {}, 0, self, self.UpdateIconItem, nil, nil, 0)
		return
	end
	self.textTitle.text.text = self.controller:GetGiftName()
	
	local price = self.controller:GetPrice()
	if price <= 0 then
		self.presentPrice.number.text.text = string.formatbykey('Free')
	else
		self.presentPrice.number.text.text = tostring(price)
	end
	--
	CommonUtil.LoopGridViewEleCreateNew(self, self.goodsList.loopVerticalScrollRect, nil, self.controller:GetCurGoodsData(), 0, self, self.UpdateIconItem)
	self.goodsList.loopVerticalScrollRect.vertical = (#self.controller:GetCurGoodsData() > 8)
	self.goodsList.loopVerticalScrollRect:SetItemStartIdx(0)
	self.buyLimitTxt.text.text = string.formatbykey('HighRewardText',self.controller:GetExpUp())
	
end

function UIRewardsBuyTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIRewardsBuyTipsView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnBuy.button, self, self.OnClickBuyBtn)
end

function UIRewardsBuyTipsView:OnHide()

end

function UIRewardsBuyTipsView:OnShow(data)

	if data then
		self.controller:SetData(data)
		self.controller:InitData()
		self:Init()
	end
end

function UIRewardsBuyTipsView:OnClose()
end

function UIRewardsBuyTipsView:OnDispose()
	self.goodsList.loopVerticalScrollRect:ClearCells()
	self.goodsList.loopVerticalScrollRect:ClearAnchoredPostion()
	self.controller:OnDispose()
end

function UIRewardsBuyTipsView:OnClickCloseBtn()
	self:UIClose()
end

function UIRewardsBuyTipsView:OnClickBuyBtn()
	local errorCodeKey = self.controller:SendPay()
	if errorCodeKey then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCodeKey)
		return
	end
	self:UIClose()
end

function UIRewardsBuyTipsView:UpdateIconItem(itemLua, itemIdx, itemData)
	if not itemLua or not itemData then return end
	CommonUtil.UpdateItemPrefab(self, itemLua, itemData, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
end

function UIRewardsBuyTipsView:ShowItemTips(button, params)
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

return UIRewardsBuyTipsView

