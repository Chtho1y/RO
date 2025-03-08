local UIVoyagePrepareView = require("UIVoyage/UIVoyagePrepareView_Generate")

local MaxLv = 5

function UIVoyagePrepareView:OnAwake(data)
	self.controller = require("UIVoyage/UIVoyagePrepareCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIVoyagePrepareView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VOYAGE_AIRSHIP_CHANGED, self, self.OnVoyageAirShipChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VOYAGE_NUM_CHANGED, self, self.OnVoyageNumChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VOYAGE_SELF_AIRSHIP_DATA_CHANGED, self, self.OnVoyageAirShipDataChanged)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CURRENY_CHANGED, self, self.OnCurrenyChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ITEM_CHANGE, self, self.OnItemChanged)
end

function UIVoyagePrepareView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIVoyagePrepareView:Init()
	self.controller:InitData()
	local curSelectId = self.controller:GetCurSelectId()
	local consumes = {}
	for i = 1, MaxLv do
		local shipLua = self['ship' .. tostring(i)]
		local cfgData = ManagerContainer.CfgMgr:GetVoyageAirShipCfgById(i)
		self:InitShipView(shipLua, cfgData)
		self:RefreshSelectItem(shipLua, curSelectId == i)
		for _, consume in pairs(cfgData.Consume) do
			if not CommonUtil.EleInTable(consume[1], consumes) then
				consumes[#consumes + 1] = consume[1]
			end
		end
	end
	for i = 1, 2 do
		self:RefreshCurrenyItem(self['currency' .. tostring(i)], consumes[i])
	end
	self.consumes = consumes
	self.closeTipsToggle.toggle.isOn = self.controller:GetNotifyAirShipUpTip()
	self:RefreshBottomBtn()
end

function UIVoyagePrepareView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIVoyagePrepareView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnUpMax.button, self, self.OnClickUpMaxBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnUpOne.button, self, self.OnClickUpOneBtn)

	self.uiBase:AddToggleUniqueEventListener(self.closeTipsToggle.toggle, self, self.OnClickCloseTipsToggle)
end

function UIVoyagePrepareView:OnHide()

end

function UIVoyagePrepareView:OnShow(data)
	self.controller:SetData(data)

end

function UIVoyagePrepareView:OnClose()
end

function UIVoyagePrepareView:OnDispose()
	for i = 1, MaxLv do
		self:DisposeShipView(self['ship' .. tostring(i)])
	end
	self.consumes = nil
	self.controller:OnDispose()
end

function UIVoyagePrepareView:OnVoyageAirShipChanged(isChanged)
	if not self.controller:RefreshSelectId() then
		return
	end
	local lastSelectId = self.controller:GetLastSelectId()
	if lastSelectId then
		self:RefreshSelectItem(self['ship' .. tostring(lastSelectId)], false)
	end
	local curSelectId = self.controller:GetCurSelectId()
	if curSelectId then
		self:RefreshSelectItem(self['ship' .. tostring(curSelectId)], true)
	end
	self:RefreshBottomBtn()
end

function UIVoyagePrepareView:OnVoyageNumChanged()
	local curSelectId = self.controller:GetCurSelectId()
	if curSelectId then
		self:RefreshSelectItem(self['ship' .. tostring(curSelectId)], true)
	end
end

function UIVoyagePrepareView:OnVoyageAirShipDataChanged()
	local data = self.controller:GetSelfAirShipData()
	if not data then
		return
	end
	self:UIClose()
end

function UIVoyagePrepareView:OnCurrenyChanged(changeMap)
	if not changeMap then return end
	local changed = false
	if self.consumes then
		for i = 1, #self.consumes do
			local consume = self.consumes[i]
			if changeMap[consume] then
				self:RefreshCurrenyItem(self['currency' .. tostring(i)], consume)
				changed = true
			end
		end
	end
	if changed then
		self:RefreshBottomBtn()
	end
end

function UIVoyagePrepareView:OnItemChanged(changeMap)
	if not changeMap then return end
	local changed = false
	if self.consumes then
		for i = 1, #self.consumes do
			local consume = self.consumes[i]
			if changeMap[consume] then
				self:RefreshCurrenyItem(self['currency' .. tostring(i)], consume)
				changed = true
			end
		end
	end
	if changed then
		self:RefreshBottomBtn()
	end
end

function UIVoyagePrepareView:OnClickCloseBtn()
	self:UIClose()
end

function UIVoyagePrepareView:OnClickUpMaxBtn()
	self:UpLvAirShip(true)
end

function UIVoyagePrepareView:OnClickUpOneBtn()
	self:UpLvAirShip(false)
end

function UIVoyagePrepareView:SureUpLvAirShip(upHighest)
	local errorCode = self.controller:GetSendRefreshAirShipReqErrorCode(upHighest)
	if errorCode == 0 then
		errorCode = self.controller:SendRefreshAirShipReq(upHighest)
		if errorCode ~= 0 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		else
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIVoyageReforming)
		end
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIVoyagePrepareView:UpLvAirShip(upHighest)
	local errorCode, num, remainNum, validCosts = self.controller:GetSendRefreshAirShipReqErrorCode(upHighest)
	if errorCode == 0 then
		local len = #validCosts
		if len >= 1 then
			local vaildCost = validCosts[len]
			local cfgId = vaildCost[1]
			local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
			local notifyAirShipUpTip = self.controller:GetNotifyAirShipUpTip()
			if not notifyAirShipUpTip and itemCfgData.ResType == Enum.ItemType.Diamond then
				local paramData = {}
				local itemCfgData2 = ManagerContainer.CfgMgr:GetItemById(cfgId)
				paramData[1] = vaildCost[3] * vaildCost[4]
				paramData[2] = itemCfgData2 and string.formatbykey(itemCfgData2.Name) or ''
				local data = {upHighest and "VoyageUpAirShipTip2" or "VoyageUpAirShipTip1", paramData, upHighest, self, self.SureUpLvAirShip}
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			else
				errorCode = self.controller:SendRefreshAirShipReq(upHighest)
				if errorCode ~= 0 then
					ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
				else
					ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIVoyageReforming)
				end
			end
		else
			errorCode = self.controller:SendRefreshAirShipReq(upHighest)
			if errorCode ~= 0 then
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
			else
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIVoyageReforming)
			end
		end
	elseif errorCode == 1 then
		local len = #validCosts
		if len >= 1 then
			local vaildCost = validCosts[len]
			local cfgId = vaildCost[1]
			CommonUtil.ItemNotEnoughHandle(cfgId, self.uiData.id)
		end
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIVoyagePrepareView:OnClickCloseTipsToggle(_, _, isOn)
	self.controller:SetNotifyAirShipUpTip(isOn)
end

function UIVoyagePrepareView:OnClickSetSailBtn()
	local curSelectId = self.controller:GetCurSelectId()
	local num = self.controller:GetNum()
	local numLimit = self.controller:GetNumLimit()
	local data = {"VoyageUpAirShipTip3", {curSelectId}, nil, self, self.SureTakeOffAirShip, nil, {(numLimit - num)}}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
end

function UIVoyagePrepareView:SureTakeOffAirShip()
	local errorCode = self.controller:SendTakeOffAirShipReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIVoyagePrepareView:InitShipView(shipLua, cfgData)
	if not shipLua then
		return
	end
	if not cfgData then
		shipLua:SetActive(false)
		return
	end
	shipLua:SetActive(true)
	shipLua.shipTitle.text.text = string.formatbykey(cfgData.Name)
	local showDatas = {}
	for _, value in pairs(cfgData.TranspoertReward) do
		showDatas[#showDatas+1] = {cfgId = value[1], num = value[2]}
	end
	shipLua.rewardGroup.loopGridView:InitGridView(#showDatas, function (gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column, showDatas)
	end, nil)
end

function UIVoyagePrepareView:DisposeShipView(shipLua)
	if not shipLua then
		return
	end
	shipLua.rewardGroup.loopGridView:Dispose()
end

function UIVoyagePrepareView:GetItemByRowColumn(gridView, itemIndex, row, column, showDatas)
	local showData = showDatas[itemIndex + 1]
	local item = nil
	if showData then
		item = gridView:NewListViewItem('IconSmallItem')
		local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'IconItem', item.gameObject)
		CommonUtil.UpdateItemPrefab(self, itemlua, showData, nil, self, self.ShowItemTips)
	end
	return item
end

function UIVoyagePrepareView:ShowItemTips(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIVoyagePrepareView:RefreshSelectItem(shipLua, isOn)
	if not shipLua then
		return
	end
	shipLua.off:SetActive(not isOn)
	shipLua.on:SetActive(isOn)
	if isOn then
		local num = self.controller:GetNum()
		local numLimit = self.controller:GetNumLimit()
		shipLua.time.text.text = tostring(numLimit - num) .. '/' .. tostring(numLimit)
		shipLua.airShipItem.animator:Play('AirShipRun')
		if num >= numLimit then
			shipLua.btnSetSail.button.onClick:RemoveAllListeners()
			shipLua.btnSetSail.button.interactable = false
		else
			self.uiBase:AddButtonUniqueEventListener(shipLua.btnSetSail.button, self, self.OnClickSetSailBtn)
		end
	else
		shipLua.btnSetSail.button.onClick:RemoveAllListeners()
		shipLua.airShipItem.animator:Play('AirShipKeep')
	end
end

function UIVoyagePrepareView:RefreshCurrenyItem(currency, cfgId)
	if not currency then return end
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	if not itemCfgData then
		currency:SetActive(false)
		return
	end
	currency:SetActive(true)
	currency.icon.image.enabled = false
	currency.icon.image.sprite = nil
	CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function (sprite)
		if sprite then
			currency.icon.image.sprite = sprite
			currency.icon.image.enabled = true
		end
	end)
	currency.num.text.text = CommonUtil.FormatNumber(CommonUtil.GetOwnResCountByItemId(cfgId))
end

function UIVoyagePrepareView:RefreshBottomBtn()
	local curSelectId = self.controller:GetCurSelectId()
	local cfgData = ManagerContainer.CfgMgr:GetVoyageAirShipCfgById(curSelectId)
	self:RefreshUpBtn(self.btnUpOne, (curSelectId == MaxLv), cfgData and cfgData.Consume or nil)
	self:RefreshUpBtn(self.btnUpMax, (curSelectId == MaxLv), cfgData and cfgData.TopLevel or nil)
end

function UIVoyagePrepareView:RefreshUpBtn(itemLua, isMax, costs)
	itemLua.button.interactable = (not isMax)
	if not costs then
		return
	end
	local costLength = #costs
	if costLength <= 0 then
		return
	end
	local cost, costCfgId, costNum, ownNum, remainNum
	for i = 1, costLength do
		cost = costs[i]
		costCfgId = tonumber(cost[1])
		costNum = tonumber(cost[2])
		if i ~= costLength then
			ownNum = CommonUtil.GetOwnResCountByItemId(costCfgId)
			remainNum = Mathf.Floor(ownNum / costNum)
			if remainNum >= 1 then
				break
			end
		end
	end
	if not costCfgId then return end
	itemLua.cost.icon.image.enabled = false
	itemLua.cost.icon.image.sprite = nil
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(costCfgId)
	if itemCfgData then
		CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function (sprite)
			if sprite then
				itemLua.cost.icon.image.sprite = sprite
				itemLua.cost.icon.image.enabled = true
			end
		end)
	end
	itemLua.cost.num.text.text = tostring(costNum)
end

return UIVoyagePrepareView