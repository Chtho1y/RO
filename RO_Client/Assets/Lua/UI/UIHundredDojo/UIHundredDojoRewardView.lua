local UIHundredDojoRewardView = require("UIHundredDojo/UIHundredDojoRewardView_Generate")

function UIHundredDojoRewardView:OnAwake(data)
	self.controller = require("UIHundredDojo/UIHundredDojoRewardCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIHundredDojoRewardView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIHundredDojoRewardView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIHundredDojoRewardView:Init()
	self.controller:InitData()
	self:RefreshView()
end

function UIHundredDojoRewardView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIHundredDojoRewardView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button,self, self.OnClickCloseBtn)
end

function UIHundredDojoRewardView:OnHide()

end

function UIHundredDojoRewardView:OnShow(data)
	self.controller:SetData(data)

end

function UIHundredDojoRewardView:OnClose()
end

function UIHundredDojoRewardView:OnDispose()
	self.controller:OnDispose()
end

function UIHundredDojoRewardView:OnClickCloseBtn()
	self:UIClose()
end

function UIHundredDojoRewardView:RefreshView()
	local rewards = self.controller:GetRewards()
	local rewardRate = self.controller:GetRewardRate()
	if rewards then
		self:RefreshCurrencyItem(self.currency1, rewards[1], rewardRate)
		self:RefreshCurrencyItem(self.currency2, rewards[2], rewardRate)
		self:RefreshCurrencyItem(self.currency3, rewards[3], rewardRate)
	else
		self:RefreshCurrencyItem(self.currency1, nil, rewardRate)
		self:RefreshCurrencyItem(self.currency2, nil, rewardRate)
		self:RefreshCurrencyItem(self.currency3, nil, rewardRate)
	end
	local rewardTime = self.controller:GetRewardTime()
	self.rewardTimeTxt.text.text = DateTimeUtil.convertSeconds2TimeStr1(rewardTime, true, true, false)

	local currencys = self.controller:GetCurrencys()
	if currencys then
		self:RefreshReceiveResItem(self.receiveRes1, Enum.ItemIds.Coin, currencys[Enum.ItemIds.Coin])
		self:RefreshReceiveResItem(self.receiveRes2, Enum.ItemIds.HundredDojoStone, currencys[Enum.ItemIds.HundredDojoStone])
		self:RefreshReceiveResItem(self.receiveRes3, Enum.ItemIds.GuildCP, currencys[Enum.ItemIds.GuildCP])
	else
		self:RefreshReceiveResItem(self.receiveRes1, Enum.ItemIds.Coin, 0)
		self:RefreshReceiveResItem(self.receiveRes2, Enum.ItemIds.HundredDojoStone, 0)
		self:RefreshReceiveResItem(self.receiveRes3, Enum.ItemIds.GuildCP, 0)
	end

	local items = self.controller:GetItems()
	if items == 0 then
		self.nothing:SetActive(true)
		self.itemScrollView:SetActive(false)
	else
		self.nothing:SetActive(false)
		self.itemScrollView:SetActive(true)
	end
	CommonUtil.LoopGridViewEleCreateNew(self,
									self.itemScrollView.loopVerticalScrollRect,
									nil, items,0, self, self.OnUpdateItemData)
end

function UIHundredDojoRewardView:OnUpdateItemData(itemLua, idx, itemData)
	if not itemLua then return end
	CommonUtil.UpdateItemPrefab(self, itemLua, itemData, nil, self, self.OnClickItem)
end


function UIHundredDojoRewardView:RefreshCurrencyItem(currency, reward, rewardRate)
	if not currency then return end
	currency.icon.image.enabled = false
	currency.icon.image.sprite = nil
	if reward then
		local cfgId = reward[1] or 0
		local num = reward[2] or 0
		local cfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
		if cfgData then
			CommonUtil.LoadIcon(self, cfgData.MiniIcon, function(sprite)
				if sprite then
					currency.icon.image.sprite = sprite
					currency.icon.image.enabled = true
				end
			end)
		end
		if rewardRate and rewardRate > 0 then
			currency.text.text.text = tostring(Mathf.Floor(num * rewardRate))
		else
			currency.text.text.text = '-'
		end
		currency:SetActive(true)
	else
		currency:SetActive(false)
	end
end

function UIHundredDojoRewardView:RefreshReceiveResItem(currency, cfgId, num)
	if not currency then return end
	currency.icon.image.enabled = false
	currency.icon.image.sprite = nil
	if cfgId then
		local cfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
		if cfgData then
			CommonUtil.LoadIcon(self, cfgData.MiniIcon, function(sprite)
				if sprite then
					currency.icon.image.sprite = sprite
					currency.icon.image.enabled = true
				end
			end)
		end
		currency.text.text.text = tostring(num or 0)
		currency:SetActive(true)
	else
		currency:SetActive(false)
	end
end

function UIHundredDojoRewardView:OnClickItem(btn,params)
	--local logicData = params[0]
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIItemTips, item)
	local data = params[0]
	local itemData = ManagerContainer.DataMgr.BagData:GetItemDataByCfgId(data.cfgId)
	data.timeStamp = itemData and itemData.timeStamp or nil
	ManagerContainer.LuaUIMgr:OpenTips(data)
end


return UIHundredDojoRewardView

