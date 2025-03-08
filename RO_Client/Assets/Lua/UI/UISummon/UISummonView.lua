local UISummonView = require("UISummon/UISummonView_Generate")

function UISummonView:OnAwake(data)
	self.controller = require("UISummon/UISummonCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISummonView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ITEM_CHANGE, self, self.OnItemChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.DIAMOND_CHANGED, self, self.OnDiamondChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SUMMON_DATA_CHANGED, self, self.OnSummonDataChanged)
end

function UISummonView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISummonView:Init()
	-- 清除红点信息
	self.controller:ReadyData()

	self.dot:SetActive(false)
	self.isMoving = false
	self.window.animator:Play('UIShow')
	self.currency:SetActive(false)

	local initParam = SuperScrollView.LoopListViewInitParam()
	initParam.mSmoothDumpRate = 0.05
	initParam.mSnapVecThreshold = 9999
	self.scrollView.loopListView.OffsetSnapCenterPercent = 0.4
	self.scrollView.loopListView.ItemSnapEnable = true
	self.scrollView.loopListView:InitListView(-1, function(loopListView, idx)
		return self:GetItemByIndex(loopListView, idx)
	end, nil, initParam)
	self.scrollView.loopListView:MovePanelToItemIndex(self.controller:GetListIdx(), 0)
	self:RefreshView()
	local isFromActivity = self.controller:GetEnterType()
	self.timeBox:SetActive(isFromActivity)
	if isFromActivity then	--打开是否来自活动界面
		self:InitTop()
	end
end

function UISummonView:InitTop()
	if not self.updateTimer then
		self.updateTimer = Timer.New(slot(self.UpdateMinute, self), 1, -1)
	end
	if not self.updateTimer.running then
		self.updateTimer:Start()
	end
	self:RefreshRemainTime()
end
function UISummonView:RefreshRemainTime()
	local remainTime = self.controller:GetRemainTime()
	if not remainTime or remainTime <= 0 then
		self:StopRefreshTimer()
		self:OnClickCloseBtn()
		return false
	else
		if self.updateTimer then
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
				self.updateTimer.duration = validTime
			else
				self:StopRefreshTimer()
			end
		end
	end
	self.timeBox.TimeTxt.text.text = DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false)
	return true
end

function UISummonView:StopRefreshTimer()
	if self.updateTimer then
		self.updateTimer:Stop()
	end
end

function UISummonView:UpdateMinute()
	self:RefreshRemainTime()
end

function UISummonView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	self.scrollView.loopListView.mOnSnapItemFinished = nil
end

function UISummonView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnPlayRule.button, self, self.OnClickPlayRuleBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnOne.button, self, self.OnClickSummonBtn, 1)
	self.uiBase:AddButtonUniqueEventListener(self.btnFive.button, self, self.OnClickSummonBtn, 2)

	self.uiBase:AddButtonUniqueEventListener(self.btnArrowL.button, self, self.OnClickArrowBtn, false)
	self.uiBase:AddButtonUniqueEventListener(self.btnArrowR.button, self, self.OnClickArrowBtn, true)

	self.scrollView.loopListView.mOnBeginDragAction = function()
		return self:OnBeginDragAction()
	end
	self.scrollView.loopListView.mOnSnapItemFinished = function(loopListView, loopListViewItem)
		return self:OnSnapItemFinished(loopListView, loopListViewItem)
	end
end

function UISummonView:OnHide()

end

function UISummonView:OnShow(data)
	if data then
		self.controller:SetData(data)
	end
	self.scrollView.loopListView:RefreshAllShownItem()
	self:RefreshTopCurrency()
	self:RefreshCostCurrency()
	self:RefreshSummonBtn()
	--打开限时礼包
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.LIMIT_RECHARGE_OPEN_UI_NTF)
end

function UISummonView:OnClose()
	if self.updateTimer then
		self.updateTimer:Stop()
		self.updateTimer = nil
	end
end

function UISummonView:OnDispose()
	self:DisposeCurrency()
	self:DisposeDot()
	self.isMoving = nil
	self.scrollView.loopListView:Dispose()
	self.controller:OnDispose()
end

function UISummonView:OnItemChanged()
	self:RefreshTopCurrency()
	self:RefreshCostCurrency()
end

function UISummonView:OnDiamondChanged()
	self:RefreshTopCurrency()
	self:RefreshCostCurrency()
end

function UISummonView:OnSummonDataChanged()
	if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UISummon) then
		return
	end
	if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UISummonAnim) then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISummonAnim, nil, self.uiData.id)
	end
end

function UISummonView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UISummonView:OnClickPlayRuleBtn()
	local actId = self.controller:GetActivityId()
	if actId then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'SummonPlayExplain_'..actId})
	else
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'SummonPlayExplain'})
	end
end

function UISummonView:OnClickCurrencyBuyBtn(_, params)
	local cfgId = params[0]
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	if not itemCfgData then return end
	if itemCfgData.ResType == Enum.ItemType.Diamond then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.Gifts, Enum.RuneShopSubType.Gold}, self.uiData.id)
	end
end

function UISummonView:SureBuy(idx)
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

function UISummonView:SureJumpBuy(idx)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.Gifts, Enum.RuneShopSubType.Gold}, self.uiData.id)
end

function UISummonView:OnClickSummonBtn(_, params)
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

function UISummonView:OnClickArrowBtn(_, params)
	local isRight = params[0]
	local listIdx = self.controller:GetListIdx()
	if isRight then
		listIdx = listIdx + 1
	else
		listIdx = listIdx - 1
	end
	self.scrollView.loopListView:SetSnapTargetItemIndex(listIdx)
	self.isMoving = true
	self.window.animator:Play('UIRemove')
end

function UISummonView:OnClickDetailsBtn(btn, params)
	local showList = params[0]
	table.sort(showList,function(a,b)
		local cfgA = ManagerContainer.CfgMgr:GetItemById(a)
		local cfgB = ManagerContainer.CfgMgr:GetItemById(b)
		if cfgA and cfgB then
			if cfgA.Quality == cfgB.Quality then
				if cfgA.ResType == Enum.ItemType.SkillEquip or cfgB.ResType == Enum.ItemType.SkillEquip then
					local artifactA = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(cfgA.Id)
					local artifactB = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(cfgB.Id)
					if artifactA and artifactB  then
						if artifactA.ArtifactMaxLevel == artifactB.ArtifactMaxLevel   then
							return cfgA.Id > cfgB.Id
						else
							return artifactA.ArtifactMaxLevel > artifactB.ArtifactMaxLevel
						end
					end
				else
					return cfgA.Id > cfgB.Id
				end
			else
				return cfgA.Quality > cfgB.Quality
			end
		end
	end)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIArtifactRewardsList,showList)
end

function UISummonView:OnBeginDragAction()
	self.isMoving = true
	self.window.animator:Play('UIRemove')
end

function UISummonView:OnSnapItemFinished(loopListView, loopListViewItem)
	self.isMoving = false
	self.window.animator:Play('UIShow')
	if not self.controller:SetListIdx(loopListViewItem.ItemIndex) then
		return
	end
	self:RefreshView()
end

function UISummonView:GetItemByIndex(loopListView, listIdx)
	local idx = self.controller:GetSelectIdxByListIdx(listIdx)
	local cfg = self.controller:GetCfgByIdx(idx)
	if not cfg then return nil end
	local item = loopListView:NewListViewItem('UISummonItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'UISummonItem', item.gameObject)
	if itemLua then
		itemLua.banner.image.enabled = false
		itemLua.banner.image.sprite = nil
		CommonUtil.LoadIcon(self, cfg.ShowImg, function(sprite)
			if sprite then
				itemLua.banner.image.sprite = sprite
				itemLua.banner.image.enabled = true
			end
		end, itemLua, 'BannerIconAsync')
		local summonShow = cfg.Show
		local isShow = summonShow and #summonShow > 0
		itemLua.btnDetails:SetActive(isShow)
		if isShow then
			self.uiBase:AddButtonUniqueEventListener(itemLua.btnDetails.button, self, self.OnClickDetailsBtn, summonShow)
		end
		if not cfg.Total or cfg.Total <= 0 then
			itemLua.extraBox:SetActive(false)
		else
			itemLua.extraBox:SetActive(true)
			local summonNum = self.controller:GetSummonNumByIdx(idx)
			local percent = (summonNum / cfg.Total)
			itemLua.extraRewardItem.rewardSlider.slider.value = percent
			local validPercent = CommonUtil.GetPreciseDecimal(percent * 100)
			if validPercent <= 0 and summonNum > 0 then
				validPercent = 1
			end
			itemLua.extraRewardItem.percentTxt.text.text = tostring(validPercent) .. '%'
		end
	end
	item.CachedRectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Horizontal, loopListView.ViewPortWidth)
	return item
end

function UISummonView:RefreshView()
	self:RefreshSummonBtn()
	self:RefreshTopCurrency()

	local selectIdx = self.controller:GetSelectIdx()
	local length = self.controller:GetCfgLength()

	if length <= 1 then
		self.btnArrowL:SetActive(false)
		self.btnArrowR:SetActive(false)
	else
		self.btnArrowL:SetActive(true)
		self.btnArrowR:SetActive(true)
	end

	if not self.dots then self.dots = {} end
	local num = #self.dots
	local dot = nil
	local parent = self.dotToggleGroup.transform
	for i = 1, length do
		if i <= num then
			dot = self.dots[i]
		else
			dot = CommonUtil.Instantiate(self.dot.gameObject, parent)
			if tolua.getpeer(dot) == nil then
				tolua.setpeer(dot, {})
			end
			dot.toggle = dot:GetComponent(Enum.TypeInfo.Toggle)
			self.dots[i] = dot
		end
		dot:SetActive(true)
		dot.toggle.isOn = (i == selectIdx)
	end
	for i = length + 1, num do
		dot = self.dots[i]
		dot:SetActive(false)
	end
end

function UISummonView:RefreshSummonBtn()
	local selectIdx = self.controller:GetSelectIdx()
	local cfg = self.controller:GetCfgByIdx(selectIdx)
	if cfg.UnLock and cfg.UnLock > 0 then
		local result, val, content = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(cfg.UnLock)
		if not result then
			self.leftAnim:SetActive(false)
			self.rightAnim:SetActive(false)
			self.lockAnim:SetActive(true)
			self.lockTxt.text.text = tostring(content)
			return
		end
	end

	self.leftAnim:SetActive(true)
	self.rightAnim:SetActive(true)
	self.lockAnim:SetActive(false)
	self:RefreshCostCurrency()
end

function UISummonView:RefreshTopCurrency()
	local selectIdx = self.controller:GetSelectIdx()
	local cfg = self.controller:GetCfgByIdx(selectIdx)
	local costs = cfg.Cost
	local num = costs and #costs or 0
	local length = 0
	if not self.currencys then
		self.currencys = {}
	else
		length = #self.currencys
	end
	local parent = self.currency.transform.parent
	for i = 1, num do
		local currency = nil
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
		local currency = self.currencys[i]
		currency:SetActive(false)
		currency.btnBuy:SetActive(false)
		currency.btnBuy.button.onClick:RemoveAllListeners()
	end
end

function UISummonView:RefreshCostCurrency()
	local selectIdx = self.controller:GetSelectIdx()
	local cfg = self.controller:GetCfgByIdx(selectIdx)
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
		self.leftAnim:SetActive(false)
		self.rightAnim:SetActive(false)
	else
		local method1 = method[1]
		local method2 = method[2]
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(costCfgId)
		CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function(sprite)
			if sprite then
				self.currencyOne.icon.image.sprite = sprite
				self.currencyOne.icon.image.enabled = true
				self.currencyFive.icon.image.sprite = sprite
				self.currencyFive.icon.image.enabled = true
			end
		end)
		if method1 then
			self.currencyOne.number.text.text = tostring(tonumber(method1) * costNum)
			self.leftAnim:SetActive(true)
		else
			self.leftAnim:SetActive(false)
		end
		if method2 then
			self.currencyFive.number.text.text = tostring(tonumber(method2) * costNum)
			self.rightAnim:SetActive(true)
		else
			self.rightAnim:SetActive(false)
		end
	end
end

function UISummonView:DisposeCurrency()
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

function UISummonView:DisposeDot()
	if not self.dots then return end
	for _, dot in pairs(self.dots) do
		CommonUtil.DestroyGO(dot)
		dot.toggle = nil
		if tolua.getpeer(dot) ~= nil then
			tolua.setpeer(dot, nil)
		end
	end
	self.dots = nil
end

return UISummonView

