local UIShopBuyTipsView = require("UIShop/UIShopBuyTipsView_Generate")

function UIShopBuyTipsView:OnAwake(data)
	self.controller = require("UIShop/UIShopBuyTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIShopBuyTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIShopBuyTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIShopBuyTipsView:Init()
	if not self.controller:IsValidData() then
		self.iconItem:SetActive(false)
		self.limitBox:SetActive(false)
		self.itemName.text.text = ''
		self.desTxt.text.text = ''
		self.buyNumTxt.text.text = ''
		self.presentPrice.number.text.text = ''
		if self.timer then
			self.timer:Stop()
			self.timer = nil
		end
		return
	end
	self.iconItem:SetActive(true)
	local goodsData = self.controller:GetCurGoodsData()
	local goodsCfgData = goodsData:GetGoodsCfgData()
	local data = {cfgId = goodsCfgData.GoodsItem}
	CommonUtil.UpdateItemPrefab(self, self.iconItem, data, nil, self, self.ShowItemTips, data)

	local havenum = CommonUtil.GetOwnResCountByItemId(goodsCfgData.GoodsItem)
	self.itemnum.text.text = tostring(havenum)
	self.itemName.text.text = goodsCfgData.GoodsName
	self.desTxt.text.text = goodsCfgData.GoodsDesc
	self:RefreshCost()
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(goodsCfgData.PayForType)
	CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function (sprite)
        self.presentPrice.icon.image.sprite = sprite
    end)

	local limitType = goodsData.limitType
	if limitType == Enum.LimitBuyType.NoLimit then
		self.limitBox:SetActive(false)
	elseif limitType == Enum.LimitBuyType.Forever then
		self.limitBox:SetActive(false)
	elseif limitType == Enum.LimitBuyType.Daily then
		self.limitBox:SetActive(true)
		self.timeLimit.text.text = goodsData:CalculateLimitTime()
		self.timer = Timer.New(slot(self.RefreshTimer, self), 1, -1)
	elseif limitType == Enum.LimitBuyType.Week then
		self.limitBox:SetActive(true)
		self.timeLimit.text.text = goodsData:CalculateLimitTime()
		self.timer = Timer.New(slot(self.RefreshTimer, self), 1, -1)
	elseif limitType == Enum.LimitBuyType.Time then
		self.limitBox:SetActive(true)
		self.timeLimit.text.text = goodsData:CalculateLimitTime()
		self.timer = Timer.New(slot(self.RefreshTimer, self), 1, -1)
	elseif limitType == Enum.LimitBuyType.Special then
		self.limitBox:SetActive(false)
	else
		self.limitBox:SetActive(false)
	end
	if self.timer then
		self.timer:Start()
	end
end

function UIShopBuyTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	self.btnMinus.repeatButton:AddRepeatClickEventListener(nil, nil)
	self.btnAdd.repeatButton:AddRepeatClickEventListener(nil, nil)
end

function UIShopBuyTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)

	self.uiBase:AddButtonEventListener(self.btnMax.button, self, self.OnClickMaxBtn)
	self.uiBase:AddButtonEventListener(self.btnBuy.button, self, self.OnClickBuyBtn)
	self.btnMinus.repeatButton:AddRepeatClickEventListener(self, self.OnClickMinusBuyNum)
	self.btnAdd.repeatButton:AddRepeatClickEventListener(self, self.OnClickAddBuyNum)
end

function UIShopBuyTipsView:OnHide()

end

function UIShopBuyTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIShopBuyTipsView:OnClose()
end

function UIShopBuyTipsView:OnDispose()
	if self.timer then
		self.timer:Stop()
		self.timer = nil
	end
	self.controller:OnDispose()
end

function UIShopBuyTipsView:OnClickCloseBtn()
	self:UIClose()
end

function UIShopBuyTipsView:OnClickMaxBtn()
	if self.controller:SetBuyNum(self.controller:GetMaxBuyNumOnce()) then
		self:RefreshCost()
	end
end

function UIShopBuyTipsView:OnClickBuyBtn()
	local errorCode, itemCfgId = self.controller:SendShopBuyItemReq()
	if errorCode ~= 0 then
		if errorCode == 391 then
			CommonUtil.ItemNotEnoughHandle(itemCfgId, Enum.UIPageName.UIShop)
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
	self:UIClose()
end

function UIShopBuyTipsView:OnClickMinusBuyNum()
	if self.controller:ChangeDeltaBuyNum(-1) then
		self:RefreshCost()
	end
end

function UIShopBuyTipsView:OnClickAddBuyNum()
	if self.controller:ChangeDeltaBuyNum(1) then
		self:RefreshCost()
	end
end

function UIShopBuyTipsView:RefreshCost()
	if not self.controller:IsValidData() then return end
	self.buyNumTxt.text.text = tostring(self.controller:GetBuyNum())
	self.presentPrice.number.text.text = tostring(self.controller:GetBuyNum() * self.controller:GetCurPrice())
end

function UIShopBuyTipsView:RefreshTimer()
	local goodsData = self.controller:GetCurGoodsData()
	if not goodsData then return end
	self.limitBox:SetActive(true)
	self.timeLimit.text.text = goodsData:CalculateLimitTime()
end

return UIShopBuyTipsView

