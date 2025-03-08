local UIRuneShopGoldBuyTipsView = require("UIRuneShop/UIRuneShopGoldBuyTipsView_Generate")

function UIRuneShopGoldBuyTipsView:OnAwake(data)
	self.controller = require("UIRuneShop/UIRuneShopGoldBuyTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIRuneShopGoldBuyTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIRuneShopGoldBuyTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIRuneShopGoldBuyTipsView:Init()
	self.controller:InitData()
	local goodsData = self.controller:GetCurGoodsData()
	if not goodsData then
		self.textTitle.text.text = ''
		self.buyLimitTxt.text.text = ''
		self.presentPrice.number.text.text = ''
		self.image.image.enabled = false
		self.image.image.sprite = nil
		return
	end
	local cfgData = goodsData.cfgData
	if cfgData then
		CommonUtil.LoadIcon(self, cfgData.Pic, function(sprite)
			if sprite then
				self.image.image.sprite = sprite
				self.image.image.enabled = true
			end
		end)

		local rewards = cfgData.Reward
		local reward
		local goldNum = 0
		if rewards then
			for i = 1, #rewards do
				reward = rewards[i]
				if reward[1] == Enum.ItemType.Diamond then
					if reward[2] then
						goldNum = goldNum + reward[2]
					end
				end
			end
		end
		local extraGoldNum = 0

		if cfgData.FirstBuyReward and #cfgData.FirstBuyReward > 0 and goodsData:IsFirstBuy() then
			self.textTitle.text.text = tostring(cfgData.Name) .. string.formatbykey('RuneShopGoldTitle1')
			rewards = cfgData.FirstBuyReward
			for i = 1, #rewards do
				reward = rewards[i]
				if reward[1] == Enum.ItemType.Diamond then
					if reward[2] then
						extraGoldNum = extraGoldNum + reward[2]
					end
				end
			end
		elseif cfgData.ExtraBuyReward and #cfgData.ExtraBuyReward > 0 then
			self.textTitle.text.text = tostring(cfgData.Name) .. string.formatbykey('RuneShopGoldTitle2')
			rewards = cfgData.ExtraBuyReward
			for i = 1, #rewards do
				reward = rewards[i]
				if reward[1] == Enum.ItemType.Diamond then
					if reward[2] then
						extraGoldNum = extraGoldNum + reward[2]
					end
				end
			end
		else
			self.textTitle.text.text = tostring(cfgData.Name)
		end
		local contentStr = '+' .. tostring((goldNum + extraGoldNum))
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(Enum.ItemType.Diamond)
		if itemCfgData then
			contentStr = contentStr .. tostring(itemCfgData.Name)
		end
		self.goldText.text.text = contentStr
		self.buyLimitTxt.text.text = string.formatbykey('RuneShopGoldDsc', tostring(goldNum), tostring(extraGoldNum))
	else
		self.image.image.enabled = false
		self.image.image.sprite = nil
		self.textTitle.text.text = ''
		self.goldText.text.text = '+0'
		self.buyLimitTxt.text.text = ''
	end
	local price = goodsData:GetPrice()
	if price <= 0 then
		self.presentPrice.number.text.text = string.formatbykey('Free')
	else
		self.presentPrice.number.text.text = tostring(price)
	end
end

function UIRuneShopGoldBuyTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIRuneShopGoldBuyTipsView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnBuy.button, self, self.OnClickBuyBtn)
end

function UIRuneShopGoldBuyTipsView:OnHide()

end

function UIRuneShopGoldBuyTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIRuneShopGoldBuyTipsView:OnClose()
end

function UIRuneShopGoldBuyTipsView:OnDispose()
	self.controller:OnDispose()
end

function UIRuneShopGoldBuyTipsView:OnClickCloseBtn()
	self:UIClose()
end

function UIRuneShopGoldBuyTipsView:OnClickBuyBtn()
	local errorCodeKey = self.controller:SendPay()
	if errorCodeKey then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCodeKey)
		return
	end
	self:UIClose()
end



return UIRuneShopGoldBuyTipsView

