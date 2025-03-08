local UISummonResultView = require("UISummon/UISummonResultView_Generate")
local MultiTypeAssetLoadSystem = require('MultiTypeAssetLoadSystem')

local OnePoss = Vector3.zero

local FivePoss = {
	Vector3(-240, 90), Vector3(0, 90), Vector3(240, 90), Vector3(-120, -120), Vector3(120, -120)
}

function UISummonResultView:OnAwake(data)
	self.controller = require("UISummon/UISummonResultCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISummonResultView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ITEM_CHANGE, self, self.OnItemChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.DIAMOND_CHANGED, self, self.OnDiamondChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SUMMON_DATA_CHANGED, self, self.OnSummonDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_CLOSE_COMPELETED, self, self.OnUICloseCompleted)
end

function UISummonResultView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISummonResultView:Init()
	self.controller:InitData()
	self.isPageInEnd = false
	self.animing = nil
	self.needAnim = nil
	if not self.loadSystem then
		self.loadSystem = MultiTypeAssetLoadSystem:new()
		self.loadSystem:SetCompleteCB(self, self.LoadedAssets)
	end
	self.loadSystem:Cancel()
	self.currency:SetActive(false)
	self:RefreshTopCurrency()
	self:RefreshCostCurrency()
	self:PreLoadAssets()
end

function UISummonResultView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UISummonResultView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnConfirm.button, self, self.OnClickConfirmBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnOne.button, self, self.OnClickSummonBtn, 1)
	self.uiBase:AddButtonUniqueEventListener(self.btnFive.button, self, self.OnClickSummonBtn, 2)
end

function UISummonResultView:OnHide()

end

function UISummonResultView:OnShow(data)
	if data then
		self.controller:SetData(data)
	end
end

function UISummonResultView:OnClose()
end

function UISummonResultView:OnDispose()
	self.isPageInEnd = nil
	if self.loadSystem then
		self.loadSystem:Dispose()
		self.loadSystem = nil
	end
	DG.Tweening.DOTween.Kill(self.extraRewardItem.rewardSlider.slider)
	if self.sliderAnimTimer then
		self.sliderAnimTimer:Stop()
		self.sliderAnimTimer = nil
	end
	if self.fxTimer then
		self.fxTimer:Stop()
		self.fxTimer = nil
	end
	if self.extraRewardTimer then
		self.extraRewardTimer:Stop()
		self.extraRewardTimer = nil
	end
	self.animing = nil
	self.needAnim = nil
	self:DisposeIconItems()
	self:DisposeIconLightPurples()
	self:DisposeIconLightGolds()
	self:DisposeIconLightReds()
	self:DisposeRedPoints()
	self:DisposeCurrency()
	self.controller:OnDispose()
end

function UISummonResultView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.isPageInEnd = true
	self:StartRewardAnim()
end

function UISummonResultView:OnItemChanged()
	self:RefreshTopCurrency()
	self:RefreshCostCurrency()
end

function UISummonResultView:OnDiamondChanged()
	self:RefreshTopCurrency()
	self:RefreshCostCurrency()
end

function UISummonResultView:OnSummonDataChanged()
	if not self.isPageInEnd or self.animing then return end
	if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UISummonResult) then
		return
	end
	if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UISummonAnim) then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISummonAnim)
	else
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SUMMON_AGAIN_DATA_CHANGED)
		self:UIClose()
	end
end

function UISummonResultView:OnUICloseCompleted(owner)
	if owner.uiData.id ~= Enum.UIPageName.UIRuneShop then return end
	if ManagerContainer.LuaUIMgr:PageInHideStack(self.uiBase) then
		ManagerContainer.LuaUIMgr:Show(Enum.UIPageName.UISummonResult)
	end
end

function UISummonResultView:OnClickCurrencyBuyBtn(_, params)
	if not self.isPageInEnd or self.animing then return end
	local cfgId = params[0]
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	if not itemCfgData then return end
	if itemCfgData.ResType == Enum.ItemType.Diamond then
		if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UISummonAnim) then
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.Gifts, Enum.RuneShopSubType.Gold}, Enum.UIPageName.UISummonAnim)
			ManagerContainer.LuaUIMgr:Hide(Enum.UIPageName.UISummonResult)
		else
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.Gifts, Enum.RuneShopSubType.Gold})
			self:UIClose()
		end
	end
end

function UISummonResultView:OnClickConfirmBtn()
	if not self.isPageInEnd or self.animing then return end
	self:UIClose()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UISummonAnim)
end

function UISummonResultView:SureBuy(idx)
	local errorCode, summonNum, remainSummonNum, vaildCosts = self.controller:GetSendSummonReqErrorCode(idx)
	if errorCode == 0 then
		errorCode = self.controller:SendSummonReq(summonNum)
		if errorCode ~= 0 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	elseif errorCode == 1 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	elseif errorCode == 2 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	elseif errorCode == 3 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	elseif errorCode == 4 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UISummonResultView:SureJumpBuy(idx)
	if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UISummonAnim) then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.Gifts, Enum.RuneShopSubType.Gold}, Enum.UIPageName.UISummonAnim)
		ManagerContainer.LuaUIMgr:Hide(Enum.UIPageName.UISummonResult)
	else
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.Gifts, Enum.RuneShopSubType.Gold})
		self:UIClose()
	end
end

function UISummonResultView:OnClickSummonBtn(_, params)
	if not self.isPageInEnd or self.animing then return end
	local idx = params[0]
	local errorCode, summonNum, remainSummonNum, vaildCosts = self.controller:GetSendSummonReqErrorCode(idx)
	if errorCode == 0 then
		local len = #vaildCosts
		if len > 1 then
			local vaildCost = vaildCosts[len]
			local cfgId = vaildCost[1]
			local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
			if itemCfgData.ResType == Enum.ItemType.Diamond and vaildCost[4] < summonNum then
				local paramData = {}
				local vaildCost2 = vaildCosts[1]
				local cfgId2 = vaildCost2[1]
				local itemCfgData2 = ManagerContainer.CfgMgr:GetItemById(cfgId2)
				paramData[1] = itemCfgData2 and string.formatbykey(itemCfgData2.Name) or ''
				paramData[2] = string.formatbykey('Supplementary', tostring(vaildCost[3] * vaildCost[4]), itemCfgData and string.formatbykey(itemCfgData.Name) or '', tostring(vaildCost[4]), paramData[1])
				local data = {"SummonNoItemTip", paramData, idx, self, self.SureBuy}
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			else
				errorCode = self.controller:SendSummonReq(summonNum)
				if errorCode ~= 0 then
					ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
				end
			end
		else
			errorCode = self.controller:SendSummonReq(summonNum)
			if errorCode ~= 0 then
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
			end
		end
	elseif errorCode == 1 then
		local len = #vaildCosts
		if len >= 1 then
			local vaildCost = vaildCosts[len]
			if Constant.OpenPay then
				local cfgId = vaildCost[1]
				local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
				if itemCfgData.ResType == Enum.ItemType.Diamond then
					local data = {"SummonNoDiamondTip", nil, idx, self, self.SureJumpBuy}
					ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
					return
				end
			end
		end
		local vaildCost = vaildCosts[1]
		local cfgId = vaildCost[1]
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam('InsufficientQuantity', itemCfgData and string.formatbykey(itemCfgData.Name) or '', '')
	elseif errorCode == 2 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	elseif errorCode == 3 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	elseif errorCode == 4 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UISummonResultView:OnClickIconItem(_, params)
	if not self.isPageInEnd or self.animing then return end
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UISummonResultView:PreLoadAssets()
	self.loadSystem:Cancel()
	local rewards = self.controller:GetRewards()
	local hasNew, hasRed, hasGold, hasPurple, hasExtra
	for i = 1, #rewards do
		local reward = rewards[i]
		local quality1, quality2 = self.controller:GetShowQuality(reward.cfgId)
		if quality1 == 3 then
			hasRed = true
		elseif quality1 == 2 then
			hasGold = true
		elseif quality1 == 1 then
			hasPurple = true
		end
	end

	if self.controller:IsHasExtra() then
		self.bG.animator:Play('ExtraKeep')
		local lastPrecent = self.controller:GetLastSummonPercent()
		self.extraRewardItem.rewardSlider.slider.value = lastPrecent
		local summonNum = self.controller:GetSummonNum()
		local validPercent = CommonUtil.GetPreciseDecimal(lastPrecent * 100)
		if validPercent <= 0 and summonNum > 0 then
			validPercent = 1
		end
		self.extraRewardItem.percentTxt.text.text = tostring(validPercent) .. '%'
		local extraReward = self.controller:GetExtraReward()
		if extraReward then
			local quality1, quality2 = self.controller:GetShowQuality(extraReward.cfgId)
			if quality1 == 3 then
				hasRed = true
			elseif quality1 == 2 then
				hasGold = true
			elseif quality1 == 1 then
				hasPurple = true
			end
			hasExtra = true
		end
	else
		self.bG.animator:Play('NoExtraKeep')
	end
	self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.UIItemDir, 'IconItem')
	if hasRed then
		self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.UIPath, 'UISummon/IconLightRed')
	end
	if hasGold then
		self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.UIPath, 'UISummon/IconLightGold')
	end
	if hasPurple then
		self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.UIPath, 'UISummon/IconLightPurple')
	end
	if hasNew then
		self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.UICommonPath, 'UINewRP')
	end
	if hasExtra then
		self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.UIEffectPath, 'FX_UI_MVP_01')
	end
	self.loadSystem:Begin()
end

function UISummonResultView:LoadedAssets()
	local rewards = self.controller:GetRewards()

	local rewardNum = #rewards
	if rewardNum > 5 then
		rewardNum = 5
	end
	self.iconItemIdx = 0
	if not self.rewardIconItems then
		self.rewardIconItems = {}
	end
	self.lightRedIdx = 0
	if not self.rewardLightReds then
		self.rewardLightReds = {}
	end
	self.lightGoldIdx = 0
	if not self.rewardLightGolds then
		self.rewardLightGolds = {}
	end
	self.lightPurpleIdx = 0
	if not self.rewardLightPurples then
		self.rewardLightPurples = {}
	end
	self.newRPIdx = 0
	if not self.newRPGos then
		self.newRPGos = {}
	end

	if rewardNum == 1 then
		self:AddReward(rewards[1], OnePoss, self)
	else
		for i = 1, rewardNum do
			self:AddReward(rewards[i], FivePoss[i], self)
		end
	end
	if self.controller:IsHasExtra() then
		self.bG.animator:Play('ExtraKeep')
		local lastPrecent = self.controller:GetLastSummonPercent()
		self.extraRewardItem.rewardSlider.slider.value = lastPrecent
		local summonNum = self.controller:GetSummonNum()
		local validPercent = CommonUtil.GetPreciseDecimal(lastPrecent * 100)
		if validPercent <= 0 and summonNum > 0 then
			validPercent = 1
		end
		self.extraRewardItem.percentTxt.text.text = tostring(validPercent) .. '%'
		local extraReward = self.controller:GetExtraReward()
		if extraReward then
			self:AddReward(extraReward, Vector3.zero, self.extraAnim)
		end
		self.needAnim = true
		self:StartRewardAnim()
	else
		self.needAnim = false
		self.bG.animator:Play('NoExtraKeep')
	end

	for i = self.iconItemIdx + 1, #self.rewardIconItems do
		if self.rewardIconItems[i] then
			self.rewardIconItems:SetActive(false)
		end
	end
	for i = self.lightRedIdx + 1, #self.rewardLightReds do
		if self.rewardLightReds[i] then
			self.rewardLightReds:SetActive(false)
		end
	end
	for i = self.lightGoldIdx + 1, #self.rewardLightGolds do
		if self.rewardLightGolds[i] then
			self.rewardLightGolds:SetActive(false)
		end
	end
	for i = self.lightPurpleIdx + 1, #self.rewardLightPurples do
		if self.rewardLightPurples[i] then
			self.rewardLightPurples:SetActive(false)
		end
	end
	for i = self.newRPIdx + 1, #self.newRPGos do
		if self.newRPGos[i] then
			self.newRPGos:SetActive(false)
		end
	end
end

function UISummonResultView:AddReward(reward, pos, parent)
	local idx = self.iconItemIdx + 1
	local iconItem = self.rewardIconItems[idx]
	if not iconItem then
		local iconItemGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIItemDir, 'IconItem')
		if iconItemGo then
			iconItem = CommonUtil.BindGridViewItem2Lua(self, 'IconItem', iconItemGo)
			self.rewardIconItems[idx] = iconItem
		end
	end
	if iconItem then
		iconItem.transform:SetParent(parent.iconParent.transform)
		iconItem.transform.localPosition = pos
		iconItem.transform.localRotation = Quaternion.identity
		iconItem.transform.localScale = Vector3.one
		CommonUtil.UpdateItemPrefab(self, iconItem, reward, Enum.ItemIEnterType.Bag, self, self.OnClickIconItem)
		iconItem:SetActive(true)
		self.iconItemIdx = idx
	end
	local quality1, quality2 = self.controller:GetShowQuality(reward.cfgId)
	if quality1 == 3 then
		self.lightRedIdx = self:AddLight(self.rewardLightReds, self.lightRedIdx, parent, pos, quality2, 'UISummon/IconLightRed')
	elseif quality1 == 2 then
		self.lightGoldIdx = self:AddLight(self.rewardLightGolds, self.lightGoldIdx, parent, pos, quality2, 'UISummon/IconLightGold')
	elseif quality1 == 1 then
		self.lightPurpleIdx = self:AddLight(self.rewardLightPurples, self.lightPurpleIdx, parent, pos, quality2, 'UISummon/IconLightPurple')
	end
	if reward.isNew then
		self:AddNew(parent, pos)
	end
end

function UISummonResultView:AddLight(lights, lastLightIdx, parent, pos, isCircle, prefabName)
	local lightIdx = lastLightIdx + 1
	local light = lights[lightIdx]
	if not light then
		local lightGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, prefabName)
		if lightGo then
			light = CommonUtil.BindGridViewItem2Lua(self, 'IconLight', lightGo)
			lights[lightIdx] = light
		end
	end
	if light then
		light.transform:SetParent(parent.iconLightParent.transform)
		light.transform.localPosition = pos
		light.transform.localRotation = Quaternion.identity
		light.transform.localScale = Vector3.one
		light.lightCircle:SetActive(isCircle)
		light:SetActive(true)
	else
		lightIdx = lastLightIdx
	end
	return lightIdx
end

function UISummonResultView:AddNew(parent, pos)
	local newRPIdx = self.newRPIdx + 1
	local newRPGo = self.newRPGos[newRPIdx]
	if not newRPGo then
		newRPGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.UICommonPath, 'UINewRP')
		self.newRPGos[newRPIdx] = newRPGo
	end
	if newRPGo then
		newRPGo.transform:SetParent(parent.iconIsNewParent.transform)
		newRPGo.transform.localPosition = pos + Vector3(80, 80, 0)
		newRPGo.transform.localRotation = Quaternion.identity
		newRPGo.transform.localScale = Vector3.one
		newRPGo:SetActive(true)
		self.newRPIdx = newRPIdx
	end
end

function UISummonResultView:StartRewardAnim()
	if not self.isPageInEnd then return end
	if not self.controller:IsHasExtra() then return end
	if not self.needAnim then return end
	self.needAnim = false
	local lastPrecent = self.controller:GetLastSummonPercent()
	local curPrecent = self.controller:GetSummonPercent()
	self.extraRewardItem.rewardSlider.slider.value = lastPrecent
	local function OnUpdate()
		local summonNum = self.controller:GetSummonNum()
		local percent = self.extraRewardItem.rewardSlider.slider.value
		local validPercent = CommonUtil.GetPreciseDecimal(percent * 100)
		if validPercent <= 0 and summonNum > 0 then
			validPercent = 1
		end
		self.extraRewardItem.percentTxt.text.text = tostring(validPercent) .. '%'
	end
	OnUpdate()
	local time = (curPrecent - lastPrecent) * 10
	self.extraRewardItem.rewardSlider.slider:DOValue(curPrecent, time):OnUpdate(OnUpdate):OnComplete(OnUpdate)
	self.animing = true
	if not self.sliderAnimTimer then
		self.sliderAnimTimer = Timer.New(slot(self.ShowFx, self), time)
	else
		self.sliderAnimTimer.time = time
		self.sliderAnimTimer.duration = time
	end
	if not self.sliderAnimTimer.running then
		self.sliderAnimTimer:Start()
	end
end

function UISummonResultView:ShowFx()
	local extraReward = self.controller:GetExtraReward()
	if not extraReward then
		self:ShowExtraReward()
		return
	end
	if not self.extraFxGo then
		self:ShowExtraReward()
		return
	end
	if not self.fxTimer then
		self.fxTimer = Timer.New(slot(self.ShowExtraReward, self), 1)
	else
		self.fxTimer.time = 1
		self.fxTimer.duration = 1
	end
	if not self.fxTimer.running then
		self.fxTimer:Start()
	end
	self.extraFxGo:SetActive(true)
end

function UISummonResultView:ShowExtraReward()
	if self.extraFxGo then
		self.extraFxGo:SetActive(false)
	end
	local extraReward = self.controller:GetExtraReward()
	if not extraReward then
		self.animing = false
		return
	end
	self.bG.animator:Play('ExtraShow')
	if not self.extraRewardTimer then
		self.extraRewardTimer = Timer.New(function()
			self.animing = false
		end, 1)
	else
		self.extraRewardTimer.time = 1
		self.extraRewardTimer.duration = 1
	end
	if not self.extraRewardTimer.running then
		self.extraRewardTimer:Start()
	end
end

function UISummonResultView:DisposeIconItems()
	if not self.rewardIconItems then return end
	for _, iconItem in pairs(self.rewardIconItems) do
		-- 常用，所以回收到对象池
		ManagerContainer.ResMgr:RecycleGO(Constants.UIItemDir, 'IconItem', iconItem.gameObject)
	end
	self.iconItemIdx = nil
	self.rewardIconItems = nil
end

function UISummonResultView:DisposeIconLightPurples()
	if not self.rewardLightPurples then return end
	for _, lightPurple in pairs(self.rewardLightPurples) do
		CommonUtil.DestroyGO(lightPurple.gameObject)
	end
	self.lightPurpleIdx = nil
	self.rewardLightPurples = nil
end

function UISummonResultView:DisposeIconLightGolds()
	if not self.rewardLightGolds then return end
	for _, lightGold in pairs(self.rewardLightGolds) do
		CommonUtil.DestroyGO(lightGold.gameObject)
	end
	self.lightGoldIdx = nil
	self.rewardLightGolds = nil
end

function UISummonResultView:DisposeIconLightReds()
	if not self.rewardLightReds then return end
	for _, lightRed in pairs(self.rewardLightReds) do
		CommonUtil.DestroyGO(lightRed.gameObject)
	end
	self.lightRedIdx = nil
	self.rewardLightReds = nil
end

function UISummonResultView:DisposeRedPoints()
	if not self.newRPGos then return end
	for _, newRPGo in pairs(self.newRPGos) do
		-- 常用，所以回收到对象池
		ManagerContainer.ResMgr:RecycleGO(Constants.UICommonPath, 'UINewRP', newRPGo.gameObject)
	end
	self.newRPIdx = nil
	self.newRPGos = nil
end

function UISummonResultView:RefreshTopCurrency()
	local cfg = self.controller:GetCfgData()
	local costs = cfg.Cost
	local num = costs and #costs or 0
	local length = 0
	if not self.currencys then
		self.currencys = {}
	else
		length = #self.currencys
	end
	local currency = nil
	local parent = self.currency.transform.parent
	for i = 1, num do
		if i <= length then
			currency = self.currencys[i]
		else
			currency = CommonUtil.Instantiate(self.currency.gameObject, parent)
			if tolua.getpeer(currency) == nil then
				tolua.setpeer(currency, {})
			end
			local icon = currency.transform:Find('Icon').gameObject
			if tolua.getpeer(icon) == nil then
				tolua.setpeer(icon, {})
			end
			icon.image = icon:GetComponent(Enum.TypeInfo.Image)
			currency.icon = icon
			local number = currency.transform:Find('Number').gameObject
			if tolua.getpeer(number) == nil then
				tolua.setpeer(number, {})
			end
			number.text = number:GetComponent(Enum.TypeInfo.Text)
			currency.number = number
			local btnBuy = currency.transform:Find('BtnBuy').gameObject
			if tolua.getpeer(btnBuy) == nil then
				tolua.setpeer(btnBuy, {})
			end
			btnBuy.button = btnBuy:GetComponent(Enum.TypeInfo.Button)
			currency.btnBuy = btnBuy
			self.currencys[i] = currency
		end
		currency:SetActive(true)

		currency.icon.image.enabled = false
		currency.icon.image.sprite = nil
		local cfgId = tonumber(costs[i][1])
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
		if itemCfgData then
			CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function(sprite)
				if sprite then
					currency.icon.image.sprite = sprite
					currency.icon.image.enabled = true
				end
			end)
			if itemCfgData.ResType == Enum.ItemType.Diamond then
				currency.btnBuy:SetActive(Constant.OpenPay)
				self.uiBase:AddButtonUniqueEventListener(currency.btnBuy.button, self, self.OnClickCurrencyBuyBtn, cfgId)
			else
				currency.btnBuy:SetActive(false)
				currency.btnBuy.button.onClick:RemoveAllListeners()
			end
		else
			currency.btnBuy:SetActive(false)
			currency.btnBuy.button.onClick:RemoveAllListeners()
		end
		currency.number.text.text = CommonUtil.FormatNumber(self.controller:GetOwnResCountByItemId(cfgId))
	end

	for i = num + 1, length do
		currency = self.currencys[i]
		currency:SetActive(false)
		currency.btnBuy:SetActive(false)
		currency.btnBuy.button.onClick:RemoveAllListeners()
	end
end

function UISummonResultView:DisposeCurrency()
	if not self.currencys then return end
	for _, currency in pairs(self.currencys) do
		CommonUtil.DestroyGO(currency)
		if tolua.getpeer(currency.btnBuy) ~= nil then
			tolua.setpeer(currency.btnBuy, nil)
		end
		if tolua.getpeer(currency.number) ~= nil then
			tolua.setpeer(currency.number, nil)
		end
		if tolua.getpeer(currency.icon) ~= nil then
			tolua.setpeer(currency.icon, nil)
		end
		if tolua.getpeer(currency) ~= nil then
			tolua.setpeer(currency, nil)
		end
	end
	self.currencys = nil
end

function UISummonResultView:RefreshCostCurrency()
	local cfg = self.controller:GetCfgData()
	local method = cfg.Method
	local costs = cfg.Cost
	local costCfgId, costNum
	local cost = nil
	if costs then
		local costLength = #costs
		for i = 1, costLength do
			cost = costs[i]
			if self.controller:GetOwnResCountByItemId(cost[1]) > 0 or i == costLength then
				costCfgId = tonumber(cost[1])
				costNum = tonumber(cost[2])
				break
			end
		end
	end

	self.currencyOne.icon.image.enabled = false
	self.currencyOne.icon.image.sprite = nil
	self.currencyFive.icon.image.enabled = false
	self.currencyFive.icon.image.sprite = nil

	if not costCfgId or not costNum or not method then
		self.one:SetActive(false)
		self.five:SetActive(false)
	else
		local method1 = method[1]
		local method2 = method[2]
		local curMethod = self.controller:GetSummonNum()
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(costCfgId)
		CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function(sprite)
			if sprite then
				self.currencyOne.icon.image.sprite = sprite
				self.currencyOne.icon.image.enabled = true
				self.currencyFive.icon.image.sprite = sprite
				self.currencyFive.icon.image.enabled = true
			end
		end)
		if method1 == curMethod then
			self.currencyOne.number.text.text = tostring(tonumber(method1) * costNum)
			self.one:SetActive(true)
		else
			self.one:SetActive(false)
		end
		if method2 == curMethod then
			self.currencyFive.number.text.text = tostring(tonumber(method2) * costNum)
			self.five:SetActive(true)
		else
			self.five:SetActive(false)
		end
	end
end

return UISummonResultView

