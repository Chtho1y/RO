local UICardListView = require("UICardList/UICardListView_Generate")
local CardIconBigItemCtr = require("Common/CardIconBigItemCtr")
local CardIconItemCtr = require("Common/CardIconItemCtr")
local IconItemCtr = require("Common/IconItemCtr")
local EquipBaseAttrItemCtr = require("Common/EquipBaseAttrItemCtr")
local RectOffset = UnityEngine.RectOffset

local pageToggleData = {}
local costId, costRes,costNum
local costId1, costRes1,costNum1
local lastPage

local cardDatas
local cardDataLength = 0

local ComposeCountLimit = 20

local updateHandle

local lastComposeLogicData, lastComposeItem

local cardDropList = {"CardFilterAll", "CardFilterNormal", "CardFilterMiniBoss", "CardFilterMVP"}
function UICardListView:OnAwake(data)
	self.controller = require("UICardList/UICardListCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UICardListView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.ITEM_CHANGE,self,self.RefreshCurrency)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.CARD_TRANS_REFRESH,self,self.PlayTransAnim)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CARD_RECREATE_REFRESH, function()
		self:ChangeViewPage(pageToggleData.toggleDefaultIndex, true)
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GET_ONE_BIG_CARD_AFTER_RECREATE, function(newId)
		self:RecreateSuccessDisplay(newId)
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GET_ONE_BIG_CARD_AFTER_COMPOSE, function(newId)
		if newId == nil then return end
		local data =  {cfgId = newId, num = 1}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardGot, data)
	end)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VIP_LV_CHANGED, self, self.OnVipLvChanged)
end

function UICardListView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UICardListView:Init()
	local data = self.controller:GetData()
	local unlock = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(37)
	if not unlock then
		data = Enum.CardFuncType.Compose
		self.controller:SetData(data)
	end

	DropDownHelper.ClearDropDown(self.produce.dropdownFilter.dropdown);
	DropDownHelper.SetStartName(self.produce.dropdownFilter.dropdown, I18N.T(cardDropList[1]))
	for i = 1, #cardDropList do
		DropDownHelper.SetDropDownItems(self.produce.dropdownFilter.dropdown, I18N.T(cardDropList[i]));
	end

	self:InitGrid()
	self:RefreshProduceCost()
	self:RefreshComposeCost()
	self:RefreshTransCardShow()
	if not updateHandle then
		updateHandle = UpdateBeat:CreateListener(self.Update, self)
	end

	UpdateBeat:AddListener(updateHandle)
end

function UICardListView:InitGrid()
	self.produce.scrollview.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)

	self.compose.scrollview.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)

	self.trans.scrollview.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	
	--self.compose.cardResult.loopListView:InitListView(0, function(gridView, itemIndex, row, column)
	--	return self:RefreshComposeBigCard(gridView, itemIndex, row, column)
	--end, nil)

	self.delayTimer = FrameTimer.New(function()
		self:InitGridRowAndColumn()
	end, 1)
	self.delayTimer:Start()
end

function UICardListView:InitGridRowAndColumn()
	local loopGridView = self.produce.scrollview.loopGridView
	local itemSize = loopGridView.ItemSize
	local itemPadding = loopGridView.ItemPadding
	local padding = loopGridView.Padding
	local itemSizeWithPadding = itemPadding + itemSize
	local width = loopGridView.ViewPortWidth - padding.left - padding.right + itemPadding.x
	local height = loopGridView.ViewPortHeight - padding.top
	local row = Mathf.Floor(width / (itemSizeWithPadding.x))
	local column = Mathf.Ceil(height / (itemSizeWithPadding.y))
	local realWidth = row * itemSizeWithPadding.x
	local offset = width - realWidth
	if offset > 0 then
		offset = offset * 0.5
		local newPadding = RectOffset(offset + padding.left, offset + padding.right, padding.top, padding.bottom)
		loopGridView:SetPadding(newPadding)
	end
	loopGridView:SetGridFixedGroupCount(SuperScrollView.GridFixedType.ColumnCountFixed, row)
	self.row = row
	self.minColumn = column

	loopGridView = self.compose.scrollview.loopGridView
	itemSize = loopGridView.ItemSize
	itemPadding = loopGridView.ItemPadding
	padding = loopGridView.Padding
	itemSizeWithPadding = itemPadding + itemSize
	width = loopGridView.ViewPortWidth - padding.left - padding.right + itemPadding.x
	height = loopGridView.ViewPortHeight - padding.top
	row = Mathf.Floor(width / (itemSizeWithPadding.x))
	column = Mathf.Ceil(height / (itemSizeWithPadding.y))
	realWidth = row * itemSizeWithPadding.x
	offset = width - realWidth
	if offset > 0 then
		offset = offset * 0.5
		local newPadding = RectOffset(offset + padding.left, offset + padding.right, padding.top, padding.bottom)
		loopGridView:SetPadding(newPadding)
	end
	loopGridView:SetGridFixedGroupCount(SuperScrollView.GridFixedType.ColumnCountFixed, row)
	self.row1 = row
	self.minColumn1 = column

	loopGridView = self.trans.scrollview.loopGridView
	itemSize = loopGridView.ItemSize
	itemPadding = loopGridView.ItemPadding
	padding = loopGridView.Padding
	itemSizeWithPadding = itemPadding + itemSize
	width = loopGridView.ViewPortWidth - padding.left - padding.right + itemPadding.x
	height = loopGridView.ViewPortHeight - padding.top
	row = Mathf.Floor(width / (itemSizeWithPadding.x))
	column = Mathf.Ceil(height / (itemSizeWithPadding.y))
	realWidth = row * itemSizeWithPadding.x
	offset = width - realWidth
	if offset > 0 then
		offset = offset * 0.5
		local newPadding = RectOffset(offset + padding.left, offset + padding.right, padding.top, padding.bottom)
		loopGridView:SetPadding(newPadding)
	end
	loopGridView:SetGridFixedGroupCount(SuperScrollView.GridFixedType.ColumnCountFixed, row)
	self.row2 = row
	self.minColumn2 = column

	self.isInit = true
	self:ChangeViewPage(pageToggleData.toggleDefaultIndex)
end

function UICardListView:RefreshProduceCost()
	local cost = GlobalConfig.Instance:GetConfigStrValue(GlobalConfig.c_card_recreate_cost)
	if cost ~= nil then
		cost = string.split(cost,':')
		costId = tonumber(cost[1])
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(costId)
		costRes = itemCfgData.Icon
		costNum = tonumber(cost[2])

		CommonUtil.LoadIcon(self, itemCfgData.Icon, function (sprite)
			self.produce.cost.icon.image.sprite = sprite
		end)
		--self.produce.cost.text.text.text = costNum
		if self.controller:IsProduceFree() then
			CommonUtil.IsConditionOutColor(self.produce.cost.text.text, false, string.formatbykey('Free'))
			return
		end
		CommonUtil.IsConditionOutColor(self.produce.cost.text.text, false, CommonUtil.FormatNumber(costNum))
	end
end

function UICardListView:RecreateSuccessDisplay(newId)
	ManagerContainer.LuaUIMgr:OpenInputMask(Enum.UISibling[Enum.UIType.Story])
	local blueCount = 0
	for i = 1,3 do
		local logicData = self.controller:GetCostCard(i)
		if logicData ~= nil then
			local cardCfgData = ManagerContainer.CfgMgr:GetCardDataById(logicData.cfgId)
			if cardCfgData.CardType == Enum.CardType.NORMAL then
				self["slotLt"..i].image.sprite = self.slotLtGreen.image.sprite
				blueCount = blueCount + 1
			elseif cardCfgData.CardType == Enum.CardType.MINIBOSS then
				self["slotLt"..i].image.sprite = self.slotLtBlue.image.sprite
			elseif cardCfgData.CardType == Enum.CardType.MVP then
				self["slotLt"..i].image.sprite = self.slotLtGold.image.sprite
			end
		end
	end

	local needShow = blueCount < 3
	if needShow then
		self.anim:SetActive(true)

		local cardCfgData = ManagerContainer.CfgMgr:GetCardDataById(newId)
		if cardCfgData.CardType == Enum.CardType.NORMAL then
			self.anim.animator:SetInteger("type", 0)
			self.transform:DOScale(1, 3):OnComplete(function()
				self:OpenCardGot(newId)
			end)
		elseif cardCfgData.CardType == Enum.CardType.MINIBOSS then
			self.anim.animator:SetInteger("type", 1)
			self.transform:DOScale(1, 3.2):OnComplete(function()
				self:OpenCardGot(newId)
			end)
		elseif cardCfgData.CardType == Enum.CardType.MVP then
			self.anim.animator:SetInteger("type", 2)
			self.transform:DOScale(1, 3.4):OnComplete(function()
				self:OpenCardGot(newId)
			end)
		end
		self.anim.animator:Play("Start")
	else
		self:OpenCardGot(newId)
	end
end

function UICardListView:OpenCardGot(newId)
	self.anim:SetActive(false)
	self:ChangeViewPage(pageToggleData.toggleDefaultIndex, true)
	self:RefreshRecreateChance()
	local data =  {cfgId = newId, num = 1}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardGot, data)
	ManagerContainer.LuaUIMgr:CloseInputMask()
end

function UICardListView:RefreshRecreateBigCard(configId)
	local logicData = {cfgId = configId}
	CardIconBigItemCtr:SetData(self, self.cardIconBigItem, logicData, Enum.ItemIEnterType.CardRecreate, true)
end

--function UICardListView:RefreshComposeBigCard(configId)
--	local logicData = {cfgId = configId}
--	CardIconBigItemCtr:SetData(self, self.resultCard, logicData, Enum.ItemIEnterType.CardRecreate, true)
--end

function UICardListView:OnVipLvChanged()
	if self.controller:IsProduceFree() then
		CommonUtil.IsConditionOutColor(self.produce.cost.text.text, false, string.formatbykey('Free'))
	else
		local resOwned = CommonUtil.GetOwnResCountByItemId(costId)
		CommonUtil.IsConditionOutColor(self.produce.cost.text.text, costNum > resOwned, CommonUtil.FormatNumber(costNum))
	end
end

function UICardListView:RefreshCostProduceCard(idx)
	local logicData = self.controller:GetCostCard(idx)
	local cardItem = self.produce["slot"..idx]
	CardIconItemCtr:SetData(self, cardItem, logicData, Enum.ItemIEnterType.CardSelectedRecreate, self, self.RemoveCostBigCard, idx, true)
	--CardIconBigItemCtr:SetData(self, bigCardItem, logicData, Enum.ItemIEnterType.CardRecreate, self, self.RemoveCostBigCard, idx)

	local canCostMore = self.controller:CanCostMore()
	--self.dsc:SetActive(not canCostMore)

	if self.controller:IsProduceFree() then
		CommonUtil.IsConditionOutColor(self.produce.cost.text.text, false, string.formatbykey('Free'))
	else
		local resOwned = CommonUtil.GetOwnResCountByItemId(costId)
		CommonUtil.IsConditionOutColor(self.produce.cost.text.text, costNum > resOwned, CommonUtil.FormatNumber(costNum))
	end
	--self.produce.cost.text.text.text = canCostMore and 0 or CommonUtil.FormatNumber(costNum)

	self:RefreshRecreateChance()
end

function UICardListView:RemoveCostBigCard(button, params)
	local logicData = params[0]
	if logicData == nil then return end

	local costCardItem = logicData.itemMaster

	logicData.cost = logicData.cost or 0
	if logicData.cost <= 0 then
		return
	end

	logicData.cost = logicData.cost - 1
	local num = logicData.num > 90 and "..." or logicData.num
	costCardItem.iconItem.num.text.text = CommonUtil.StringConcat(logicData.cost, "/", num)

	if logicData.cost <= 0 then
		costCardItem.btnRemove:SetActive(false)
	end

	local idx = self.controller:AutoRemoveCostCard(logicData)
	self:RefreshCostProduceCard(idx)
end

function UICardListView:RefreshAllCostProduceCard()
	self.controller:NilCostCards()
	--self.cardName.text.text = ""
	for i = 1, 3 do
		self:RefreshCostProduceCard(i)
	end
end

function UICardListView:RefreshComposeCost()
	self.compose.cost.text.text.text = 0
	--
	--local cost = GlobalConfig.Instance:GetConfigStrValue(121)
	--if cost ~= nil then
	--	cost = string.split(cost,':')
	--	costId1 = tonumber(cost[1])
	--	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(costId1)
	--	costRes1 = itemCfgData.Icon
	--	costNum1 = tonumber(cost[2])
	--
	--	CommonUtil.LoadIcon(self, itemCfgData.Icon, function (sprite)
	--		self.compose.cost.icon.image.sprite = sprite
	--	end)
	--
	--	self.compose.cost.text.text.text = 0
	--end
end

function UICardListView:AddRecreateCard(button, params)
	local logicData = params[0]
	local cardIconItem = params[1]

	if not self.controller:CanCostMore() then
		return 0
	end

	logicData.cost = logicData.cost or 0
	if logicData.cost >= logicData.num then
		return 1
	end

	logicData.cost = logicData.cost + 1
	--local num = math.min(logicData.num, 99)
	cardIconItem.iconItem.num.text.text = CommonUtil.StringConcat(logicData.cost, "/", logicData.num)

	cardIconItem.btnRemove:SetActive(true)

	local idx = self.controller:AutoAddCostCard(logicData)

	self:RefreshCostProduceCard(idx, cardIconItem)

	if logicData.cost >= logicData.num then
		return 1
	end

	return 2
end

function UICardListView:SetTransSlotData(btn,param)
	local idx = param[0].idx
	local result, oldIdx,newIdx = self.controller:SetTransSlotIdx(idx + 1)
		if result > 0 then
			if result == 1 then
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("TransCardUnfull01")
			elseif result == 2 then
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("TransCardUnfull02")
			end
			return
		end
	self:RefreshTransCardShow(oldIdx)
end

function UICardListView:RefreshTransCardShow(oldIdx)
	if oldIdx then
		local oldItemLua = self:GetCardItemByIdx(oldIdx)
		if oldItemLua then
			local showData = self.controller:GetShowData(oldIdx - 1)
			oldItemLua.iconItem.num.text.text = CommonUtil.StringConcat( showData.isSelect and 1 or 0, "/", showData.num)
			oldItemLua.selected2:SetActive(false)
		end
	end
	local leftSelectedIdx, rightSelectedIdx = self.controller:GetTransferSlotIdx()
	if leftSelectedIdx and rightSelectedIdx then
		local leftData = self.controller:GetShowData(leftSelectedIdx - 1)
		local rightData = self.controller:GetShowData(rightSelectedIdx - 1)
		local table = GlobalConfig.Instance:GetConfigStrValue(352)
		local costTable = self:DeserializeGlobalStrToNumberTable(table)
		local cost = 0
		local costId
		local minValue = math.min(leftData.level, rightData.level)
		local maxValue = math.max(leftData.level, rightData.level)
		for i = minValue + 1, maxValue do
			local costData = costTable[i]
			if costData then
				cost = cost + costData[3]
				costId = costData[2]
			end
		end
		local num = CommonUtil.GetOwnResCountByItemId(costId or 268)
		if num < cost then
			self.btnTrans.num.text.text = string.format(Constant.RedColorText,tostring(cost))
		else
			self.btnTrans.num.text.text = tostring(cost)
		end
	else
		self.btnTrans.num.text.text = 0
	end
	self.transItem1:SetActive(leftSelectedIdx ~= nil)
	self.transItem2:SetActive(rightSelectedIdx ~= nil)
	self.transItem1Name:SetActive(leftSelectedIdx ~= nil)
	self.transItem2Name:SetActive(rightSelectedIdx ~= nil)
	if leftSelectedIdx then
		local curItemLua = self:GetCardItemByIdx(leftSelectedIdx)
		if curItemLua then
			curItemLua.selected2:SetActive(true)
			local showData = self.controller:GetShowData(leftSelectedIdx - 1)
			CardIconItemCtr:SetData(self, self.transItem1, showData)
			curItemLua.iconItem.num.text.text = CommonUtil.StringConcat( showData.isSelect and 1 or 0, "/", showData.num)
			local cfgData = ManagerContainer.CfgMgr:GetItemById(showData.cfgId)
			if cfgData then
				self.transItem1Name.text.text = cfgData.Name
			end
		end
	end	
	if rightSelectedIdx then
		local curItemLua = self:GetCardItemByIdx(rightSelectedIdx)
		if curItemLua then
			curItemLua.selected2:SetActive(true)
			local showData = self.controller:GetShowData(rightSelectedIdx - 1)
			CardIconItemCtr:SetData(self, self.transItem2, showData)
			curItemLua.iconItem.num.text.text = CommonUtil.StringConcat( showData.isSelect and 1 or 0, "/", showData.num)
			local cfgData = ManagerContainer.CfgMgr:GetItemById(showData.cfgId)
			if cfgData then
				self.transItem2Name.text.text = cfgData.Name
			end
		end
	end
end

function UICardListView:GetCardItemByIdx(idx)
	local item = self.trans.scrollview.loopGridView:GetShownItemByItemIndex(idx - 1)
    if item then
        local itemlua = CommonUtil.GetBindGridViewItem2Lua(self, "CardIconItem", item.gameObject)
        return itemlua
    end
end

function UICardListView:RemoveRecreateCard(button, params)
	local logicData = params[0]
	local cardIconItem = params[1]

	logicData.cost = logicData.cost or 0
	if logicData.cost <= 0 then
		return
	end

	logicData.cost = logicData.cost - 1
	--local num = math.min(logicData.num, 99)
	cardIconItem.iconItem.num.text.text = CommonUtil.StringConcat(logicData.cost, "/", logicData.num)

	if logicData.cost <= 0 then
		cardIconItem.btnRemove:SetActive(false)
	end
	local idx = self.controller:AutoRemoveCostCard(logicData)
	self:RefreshCostProduceCard(idx, cardIconItem)
end

function UICardListView:Update()
	if not pageToggleData then return end

	if pageToggleData.toggleDefaultIndex ~= 2 then
		return
	end

	if self.composeTasks then
		for k, v in pairs(self.composeTasks) do
			if v.newTask then
				if v.isAdd then
					--local max = #self.composeCardIds
					--self.compose.cardResult.loopListView:SetListItemCount(max, true)
                    self:AddNewComposeBigCard(v)
                    v.newTask = false
				else
                    --local result = self.compose.cardResult.loopListView:IsItemVisibleByItemIndex(v.idx - 1)
                    --if result then
                    --    self.compose.cardResult.loopListView:RefreshItemByItemIndex(v.idx - 1)
                    --else
                    --    self:ComposeBigCardShowCompeleted(v)
                    --end

                    local result = self:RemoveComposeBigCard(v)
                    if result then
                        v.newTask = false
                    end
				end
			end
		end
	end
end

function UICardListView:ChangeComposeCard(button, params)
	local logicData = params[0]
	local cardIconItem = params[1]

    self:ChangeComposeCard1(logicData, cardIconItem)
end

function UICardListView:ChangeComposeCard1(logicData, cardIconItem)
    local nextCardId = logicData.cfgId + 100
    local nextCardCfgData = ManagerContainer.CfgMgr:GetCardDataById(nextCardId)
    if nextCardCfgData == nil then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("154")
        return
    end

    local isAdd = true
    local isIn, k = CommonUtil.EleInTable(nextCardId, self.composeCardIds)
    if isIn then
        isAdd = false
    end

    local task = self.composeTasks[nextCardId]
    if task and task.isAnimationing then
        return
    end

    local idx
    local cost = 0
    if isAdd then
		local cfgDate = ManagerContainer.CfgMgr:GetCardDataById(logicData.cfgId)
        local num = math.floor(logicData.num/3)
        cost = num * cfgDate.UpCost
        --if cost > resRemain then
        --    num = math.floor(resRemain / costNum)
        --    cost = num * costNum
        --end

        if #self.composeCardIds >= ComposeCountLimit then
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ComposeMax")
            return
        end

        self.composeCardIds[#self.composeCardIds + 1] = nextCardId
        self.composeCosts[nextCardId] = cost
		self.composeCardIdCounts[nextCardId] = num;

        idx = #self.composeCardIds
        --LogHRWarning("up  "..nextCardId)
        self.totalCost = self.totalCost + cost
        cardIconItem.iconItem.num.text.text = CommonUtil.StringConcat(num*3, "/", logicData.num)
    else
        idx = k
        cardIconItem.iconItem.num.text.text = CommonUtil.StringConcat("0/", logicData.num)
        --LogHRWarning("down  "..nextCardId)
        self.totalCost = self.totalCost - self.composeCosts[nextCardId]
        self.composeCosts[nextCardId] = nil
		self.composeCardIdCounts[nextCardId] = nil;
    end

    cardIconItem.selected2:SetActive(isAdd)

    task = {idx = idx, cfgId = nextCardId, isAdd = isAdd, needShow = true, newTask = true, cost = cost, isAnimationing = false}
    self.composeTasks[nextCardId] = task

    self:SetComposeNums()
    self:ComposeAllSelectedRefresh()
end

function UICardListView:ChangeComposeCard2(nextCardId, logicData, cardIconItem)
    local task = self.composeTasks[nextCardId]
    if task and task.isAnimationing then
        return
    end

    local resRemain = CommonUtil.GetOwnResCountByItemId(costId)
    --local remain = resRemain - self.totalCost
    --if remain < costNum then
	--	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CardResettingNoMoney1")
    --    return
    --end
	local cfgDate = ManagerContainer.CfgMgr:GetCardDataById(logicData.cfgId)
    local num = math.floor(logicData.num/3)
    local cost = num * cfgDate.UpCost
    --if cost > resRemain then
    --    num = math.floor(resRemain / costNum)
    --    cost = num * costNum
    --end

    if #self.composeCardIds >= ComposeCountLimit then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ComposeMax")
        return
    end
    self.composeCardIds[#self.composeCardIds + 1] = nextCardId
    self.composeCosts[nextCardId] = cost
	self.composeCardIdCounts[nextCardId] = num;

    local idx = #self.composeCardIds

    self.totalCost = self.totalCost + cost
    cardIconItem.iconItem.num.text.text = CommonUtil.StringConcat(num*3, "/", logicData.num)

    cardIconItem.selected2:SetActive(true)

    task = {idx = idx, cfgId = nextCardId, isAdd = true, needShow = true, newTask = true, cost = cost, isAnimationing = false}
    self.composeTasks[nextCardId] = task
end

function UICardListView:ComposeAllSelectedRefresh()
    self.noToggleClick = true
    if #self.composeCardIds == ComposeCountLimit or #self.composeCardIds >= #cardDatas then
        self.compose.filter.toggle.isOn = true
    else
        self.compose.filter.toggle.isOn = false
    end

    self.noToggleClick = false
end

function UICardListView:RemoveComposeCard(button, params)
    self:RemoveComposeCard1(params[0], params[1])

    self:SetComposeNums()
    self:ComposeAllSelectedRefresh()
end

function UICardListView:RemoveComposeCard1(cardId, composeCard)
    if not cardId then
        return
    end
    local lastCardId = cardId - 100
    local lastCardCfgData = ManagerContainer.CfgMgr:GetCardDataById(lastCardId)
    if lastCardCfgData then
        local task = self.composeTasks[cardId]
        if task and task.isAnimationing then
            return
        end
        local isIn, k = CommonUtil.EleInTable(cardId, self.composeCardIds)

        local smallIcon = self:GetSmallCardIcon(lastCardId)
        local cardData = ManagerContainer.DataMgr.CardData:GetCardById(lastCardId)

		if composeCard and self.composeCardIdCounts[cardId] ~= nil and self.composeCardIdCounts[cardId] > 0 then
			self.composeCardIdCounts[cardId] = self.composeCardIdCounts[cardId] - 1
		end

		if composeCard and self.composeCardIdCounts[cardId] == 0 then
			self.composeCardIdCounts[cardId] = nil
		elseif not composeCard then
			self.composeCardIdCounts[cardId] = nil
		end
		if self.composeCardIdCounts[cardId] == nil then
			if smallIcon then
				smallIcon.iconItem.num.text.text = CommonUtil.StringConcat("0/", cardData.num)
				smallIcon.selected2:SetActive(false)
			end
			--LogHRWarning("down  "..nextCardId)
			self.totalCost = self.totalCost - self.composeCosts[cardId]
			self.composeCosts[cardId] = nil

			task = {idx = k, cfgId = cardId, isAdd = false, needShow = true, newTask = true, cost = 0, isAnimationing = false}
			self.composeTasks[cardId] = task
		else
			if composeCard then
				composeCard.cardIconBigItem.count.text.text = self.composeCardIdCounts[cardId]
			end
			self.composeCosts[cardId] = self.composeCosts[cardId] - lastCardCfgData.UpCost
			self.totalCost = self.totalCost - lastCardCfgData.UpCost

			if smallIcon then
				smallIcon.iconItem.num.text.text = CommonUtil.StringConcat(self.composeCardIdCounts[cardId] * 3, "/", cardData.num)
			end
		end
    end
end

function UICardListView:RefreshRecreateChance()
	local normalChance = 0
	local miniChance = 0
	local bossChance = 0

	local count = 0
	for i = 1, 3 do
		local logicData = self.controller:GetCostCard(i)
		if logicData ~= nil then
			count = count + 1
			local cardData = ManagerContainer.CfgMgr:GetCardDataById(logicData.cfgId)
			local resetData = ManagerContainer.CfgMgr:GetCardResetDataByLevelAndType(cardData.CardLevel, cardData.CardType)
			normalChance = normalChance + resetData.Normal
			miniChance = miniChance + resetData.Mini
			bossChance = bossChance + resetData.Boss
		end
	end

	self.dsc:SetActive(count >= 3)
	self.unselected:SetActive(count < 3)
	local total = normalChance + miniChance + bossChance

	local normal = total > 0 and normalChance/total or 0
	normal = tonumber(CommonUtil.FormatPercentNumber(normal))
	local mini = total > 0 and miniChance/total or 0
	mini = tonumber(CommonUtil.FormatPercentNumber(mini))
	local boss = 100 - normal - mini
	boss = (boss <= 100 and boss > 0 and bossChance > 0) and boss or bossChance
	self.dsc.text01.text.text = I18N.SetLanguageValue("CardRemakeProbability1", (normal == 0 or normal == 100) and normal or string.format("%.2f",normal))
	self.dsc.text02.text.text = I18N.SetLanguageValue("CardRemakeProbability2", (mini == 0 or mini == 100) and mini or string.format("%.2f",mini))
	self.dsc.text03.text.text = I18N.SetLanguageValue("CardRemakeProbability3", (boss == 0 or boss == 100) and boss or string.format("%.2f",boss))
end

function UICardListView:GetSmallCardIcon(cfgId)
	local idx = 0
	for k,v in pairs(cardDatas) do
		if v.cfgId == cfgId then
			idx = k - 1
			break
		end
	end
    local smallCard = self.compose.scrollview.loopGridView:GetShownItemByItemIndex(idx)
    if not smallCard then
        return nil
    end

    return CommonUtil.GetBindGridViewItem2Lua(self, 'CardIconItem', smallCard.gameObject)
end

function UICardListView:ReenableToggle()
	self.compose.filter.toggle.enabled = true
	self.toggleTimer = nil
end

function UICardListView:AllSelectComposeCards(toggle, logicData, result)
	if not self.toggleTimer then
		self.toggleTimer = ManagerContainer.LuaTimerMgr:AddTimer(500, 1, self, self.ReenableToggle, nil)
	end
    if self.noToggleClick then return end

	self.compose.filter.toggle.enabled = false
    if result then
		local areadyCount = #self.composeCardIds
		self.delta = ComposeCountLimit - areadyCount
		self.curIdx = 0

		self.compose.scrollview.loopGridView:MovePanelToItemByIndex(0)
		self.compose.scrollview.loopGridView:RefreshAllShownItem()
		--self.compose.scrollview.loopGridView:FinishSnapImmediately()
		--self.compose.scrollview.loopGridView:SetListItemCount(#cardDatas, true)


        --local idx = 0
        --for i = 1, #cardDatas do
        --    local nextCardId = cardDatas[i].cfgId + 100
        --    local nextCardCfgData = ManagerContainer.CfgMgr:GetCardDataById(nextCardId)
        --    if nextCardCfgData and idx < delta and not CommonUtil.EleInTable(nextCardId, self.composeCardIds) then
        --        local smallIcon = self:GetSmallCardIcon(cardDatas[i].cfgId)
		--		if smallIcon then
		--			self:ChangeComposeCard2(nextCardId, cardDatas[i], smallIcon)
		--		end
        --        idx = idx + 1
        --    end
        --end
    else
        for i = 1, #self.composeCardIds do
            self:RemoveComposeCard1(self.composeCardIds[i])
        end
    end

    self:SetComposeNums()
end

function UICardListView:ChangeViewPage(index, needRefresh)
	if not self.isInit then return end

	if lastPage ~= index then
		self.controller:ClearLeftSlotIdx()
		self.controller:ClearRightSlotIdx()
		self:RefreshTransCardShow()
		lastPage = index
		self.controller:SetEleIndex(0)
		self.produce.dropdownFilter.dropdown.value = 0

		needRefresh = true
	end

	local scrollView
	local row, minColumn
	if index == Enum.CardFuncType.Recreate then
		-- 重置
		scrollView = self.produce.scrollview
		cardDatas = self.controller:GetCardDatas(self.controller:GetEleIndex())
		self:RefreshAllCostProduceCard()
		self:RefreshRecreateBigCard()

		self.produce:SetActive(true)
		self.compose:SetActive(false)
		self.trans:SetActive(false)

		self.compose.filter:SetActive(false)
		row = self.row
		minColumn = self.minColumn

		self.produce.noCards:SetActive(#cardDatas == 0)
	elseif index == Enum.CardFuncType.Compose then
		-- 合成
		--self.controller:ResetDecomposeCardDatas()
		scrollView = self.compose.scrollview
		cardDatas = self.controller:GetComposeCardDatas(self.controller:GetEleIndex(), true)
		self:ResetComposeState()

		self.produce:SetActive(false)
		self.compose:SetActive(true)
		self.trans:SetActive(false)

		--self.compose.filter.toggle.isOn = canCompose
		self.compose.filter:SetActive(true)

		row = self.row1
		minColumn = self.minColumn1

		self.compose.noCard:SetActive(#self.composeCardIds == 0)
		self.compose.noCards:SetActive(#cardDatas == 0)
	elseif index == Enum.CardFuncType.Trans then
		-- 合成
		--self.controller:ResetDecomposeCardDatas()
		scrollView = self.trans.scrollview
		cardDatas = self.controller:RefreshMvpCradList()

		self.produce:SetActive(false)
		self.compose:SetActive(false)
		self.trans:SetActive(true)
		self:RefreshCurrency()

		--self.compose.filter.toggle.isOn = canCompose

		row = self.row2
		minColumn = self.minColumn2

		self.trans.noCards:SetActive(#cardDatas == 0)
	else
		return
	end

	cardDataLength = 0
	if #cardDatas > 0 then
		cardDataLength = #cardDatas
		if row and minColumn then
			local minLength = row * minColumn
			if cardDataLength <= minLength then
				cardDataLength = minLength
			else
				cardDataLength = Mathf.Ceil(cardDataLength / row) * row
			end
		end
	end

	local max = cardDataLength
	scrollView.loopGridView:SetListItemCount(max, true)
	if needRefresh then
		scrollView.loopGridView:RefreshListByIndex(max)
	end
	--self.produce.scrollview.loopGridView:RefreshAllShownItem()
end

function UICardListView:RefreshCurrency()
	local cfgData = ManagerContainer.CfgMgr:GetItemById(268)
	if cfgData then
		local num = CommonUtil.GetOwnResCountByItemId(268)
		self.currency.number.text.text = tostring(num)
		CommonUtil.LoadIcon(self, cfgData.Icon, function (sprite)
			self.currency.icon.image.sprite = sprite
		end)
	end
end

function UICardListView:ResetComposeState()
	self.composeTasks = {}
	self.composeCardIds = {}
	self.composeCardIdCounts = {}
	self.composeCosts = {}
	self.totalCost = 0
	self.curIdx = nil
	self.delta = nil

	self.compose.filter.toggle.isOn = false;
	self:SetComposeNums()

    CommonUtil.RecycleFromBatchItemsByPrefabName(self, Enum.PrefabNames.CardComposeItem)

	self.compose.filter.toggle.enabled = true

	if self.toggleTimer then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self.toggleTimer)
		self.toggleTimer = nil
	end
end

function UICardListView:SetComposeNums()
	local resRemain = CommonUtil.GetOwnResCountByItemId(costId)
	--self.compose.cost.text.text.text = CommonUtil.FormatNumber(cost)
	CommonUtil.IsConditionOutColor(self.compose.cost.text.text, self.totalCost > resRemain, CommonUtil.FormatNumber(self.totalCost))

	local count = 0
	for _,v in pairs(self.composeCardIdCounts) do
		count = count + v
	end
	self.compose.number.text.text = count   --I18N.SetLanguageValue("ComposeCard", count)
end

function UICardListView:GetItemByRowColumn(gridView, itemIndex, row, column)
	if (cardDatas == nil or itemIndex < 0 or itemIndex >= cardDataLength) then
		return nil
	end
	local showData = cardDatas[itemIndex + 1]
	local item = nil
	if showData then
		item = gridView:NewListViewItem('CardIconItem')
		local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'CardIconItem', item.gameObject)
		showData.itemMaster = itemlua
        item.name = showData.cfgId

		if lastPage == Enum.CardFuncType.Recreate then
			CommonUtil.UpdateItemPrefab(self, itemlua, showData, Enum.ItemIEnterType.CardRecreate, self, self.AddRecreateCard)
			itemlua.iconItem.num.text.text = CommonUtil.StringConcat(showData.cost or 0, "/", showData.num)
			self.uiBase:AddButtonUniqueEventListener(itemlua.btnRemove.button, self, self.RemoveRecreateCard, showData, itemlua)
			itemlua.btnRemove:SetActive(showData.cost and showData.cost > 0)
		elseif lastPage == Enum.CardFuncType.Trans then
			showData.idx = itemIndex
			CommonUtil.UpdateItemPrefab(self, itemlua, showData, Enum.ItemIEnterType.CardRecreate, self, self.SetTransSlotData)
			itemlua.iconItem.num.text.text = CommonUtil.StringConcat( showData.isSelect and 1 or 0, "/", showData.num)
			itemlua.selected2:SetActive(showData.isSelect)
		else
			CommonUtil.UpdateItemPrefab(self, itemlua, showData, Enum.ItemIEnterType.CardCompose, self, self.ChangeComposeCard)
			--self.uiBase:AddButtonUniqueEventListener(itemlua.btnRemove.button, self, self.RemoveComposeCard, showData, itemlua)

			local nextCardId = showData.cfgId + 100
			local active = CommonUtil.EleInTable(nextCardId, self.composeCardIds)
			itemlua.selected2:SetActive(active)

			if self.delta and self.curIdx then
				local nextCardCfgData = ManagerContainer.CfgMgr:GetCardDataById(nextCardId)
				if nextCardCfgData and self.curIdx < self.delta and not active then
					self:ChangeComposeCard2(nextCardId, showData, itemlua)
					self.curIdx = self.curIdx + 1

					if self.curIdx > self.delta then
						self.delta = nil
						self.curIdx = nil
					end
				end
			end
		end
	else
		item = gridView:NewListViewItem('IconEmptyItem')
	end
	return item
end

--function UICardListView:RefreshComposeBigCard(gridView, itemIndex, row, column)
--	if (itemIndex < 0 or itemIndex >= #self.composeCardIds) then
--		return nil
--	end
--	local cfgId = self.composeCardIds[itemIndex + 1]
--	local task = self.composeTasks[cfgId]
--	local item = gridView:NewListViewItem('CardComposeItem')
--
--	item.name = itemIndex.."   ".. cfgId
--	local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'CardComposeItem', item.gameObject)
--
--	local data = {isCurIdx = task.idx == itemIndex + 1, task = task}
--	CommonUtil.UpdateItemPrefab(self, itemlua, data, self, self.ComposeBigCardShowCompeleted)
--
--	task.needShow = false
--	return item
--end

function UICardListView:AddNewComposeBigCard(task)
    ManagerContainer.GoPoolMgr:SpawnGo(Enum.PrefabNames.CardComposeItem, function(itemlua)
        itemlua.gameObject.name = task.cfgId

        local data = {isCurIdx = true, task = task}
        CommonUtil.BatchCreateItems(self, itemlua, self.compose.content.transform, data, self, self.ComposeBigCardShowCompeleted)
        self.uiBase:AddButtonUniqueEventListener(itemlua.cardIconBigItem.bg.button, self, self.RemoveComposeCard, task.cfgId, itemlua)

		itemlua.cardIconBigItem.count:SetActive(true)
		itemlua.cardIconBigItem.count.text.text = self.composeCardIdCounts[task.cfgId]
        task.needShow = false
    end)

	self.compose.content.rectTransform.anchoredPosition = Vector2.zero
end

function UICardListView:RemoveComposeBigCard(task)
    local itemGo = self.compose.content.transform:Find(task.cfgId)
    if itemGo == nil then
        return false
    end
    local itemLua = CommonUtil.GetBatchItemByGo(self, Enum.PrefabNames.CardComposeItem, itemGo.gameObject)
    if itemLua == nil then
        return false
    end

    local data = {isCurIdx = true, task = task}
    CommonUtil.UpdateItemPrefab(self, itemLua, data, self, self.ComposeBigCardShowCompeleted)
    return true
end

function UICardListView:ComposeBigCardShowCompeleted(task, item)
    --LogHRWarning("show over  "..task.cfgId)
	if not task.isAdd then
        local result, k = CommonUtil.EleInTable(task.cfgId, self.composeCardIds)
        if result then
            table.remove(self.composeCardIds, k)
            self.composeTasks[task.cfgId] = nil

            --local max = #self.composeCardIds
            --self.compose.cardResult.loopListView:SetListItemCount(max, true)

            ManagerContainer.GoPoolMgr:RecycleGo(item)
            --LogHRWarning(Inspect(self.composeCardIds))
        end
	end

	self.compose.noCard:SetActive(#self.composeCardIds == 0)
	self:ComposeAllSelectedRefresh()
end

function UICardListView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UICardListView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.toggleGroup, self.controller:GetData(), self.ChangeViewPage)

	self.uiBase:AddDropdownEventListener(self.produce.dropdownFilter.dropdown, function (dropdown, value)
		self.controller:SetEleIndex(value)
		self:ChangeViewPage(pageToggleData.toggleDefaultIndex, true)
	end)

	self.uiBase:AddButtonEventListener(self.btnBack.button, function (buttton, params)
		ManagerContainer.LuaUIMgr:OpenSourceUI(self, Enum.BagViewPageType.Card)
	end)

	self.uiBase:AddButtonEventListener(self.btnProduce.button, function (buttton, params)
		if self.controller:CanCostMore() then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CardResettingUnfull")
			return
		end

		if not self.controller:IsProduceFree() then
			local ownResCount = CommonUtil.GetOwnResCountByItemId(costId)
			if ownResCount < costNum then
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CardResettingNoMoney")
				return
			end
		end

		if self.controller:RecreateNeedNotice() then
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardProduceNotice, Enum.UIPageName.UICardList)
			return
		end

		self.controller:SendCardReceate()
	end)

	self.uiBase:AddButtonEventListener(self.btnCompose.button, function (buttton, params)
		--if self.controller:CanCostMore() then
		--	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CardResettingUnfull1")
		--	return
		--end

		local ownResCount = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.Coin)
		if ownResCount < self.totalCost then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CardResettingNoMoney1")
			return
		end

		--if self.controller:RecreateNeedNotice() then
		--	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardProduceNotice, Enum.UIPageName.UICardList)
		--	return
		--end

		self.controller:SendCardCompose(self.composeCardIds, self.composeCardIdCounts)
	end)
	self.uiBase:AddButtonEventListener(self.btnTrans.button,self,self.OnClickBtnTrans)
	self.uiBase:AddButtonEventListener(self.transBox.bg1.button,self,self.OnClickLeft)
	self.uiBase:AddButtonEventListener(self.transBox.bg2.button,self,self.OnClickRight)

	self.uiBase:AddToggleEventListener(self.compose.filter.toggle, self, self.AllSelectComposeCards, nil)
end

function UICardListView:OnClickBtnTrans()
	local leftSelectedIdx, rightSelectedIdx = self.controller:GetTransferSlotIdx()
	if not leftSelectedIdx or not rightSelectedIdx then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CardTransDsc01")
		return
	end
	local leftData = self.controller:GetShowData(leftSelectedIdx - 1)
	local rightData = self.controller:GetShowData(rightSelectedIdx - 1)
	local table = GlobalConfig.Instance:GetConfigStrValue(352)
	local costTable = self:DeserializeGlobalStrToNumberTable(table)
	local cost = 0
	local costId
	local minValue = math.min(leftData.level, rightData.level)
	local maxValue = math.max(leftData.level, rightData.level)
	for i = minValue + 1, maxValue do
		local costData = costTable[i]
		if costData then
			cost = cost + costData[3]
			costId = costData[2]
		end
	end
	local num = CommonUtil.GetOwnResCountByItemId(costId or 268)
	if num < cost then
		CommonUtil.ItemNotEnoughHandle(costId or 268)
		return
	else
		local data = {"CardTransTips", nil, nil, self, self.OnSure}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
	end
end

function UICardListView:DeserializeGlobalStrToNumberTable(table)
	local table = string.split(table, ';')
    local table1 = {}
    for _, value in pairs(table) do
        if value then
            if string.find(value, ':') then
                local info = string.split(value, ':')
                for i = 1, #info do
                    info[i] = tonumber(info[i])
                end
                table1[info[1]] = info
            else
                table1[value] = tonumber(value)
            end
        end
    end
    return table1
end
function UICardListView:OnSure()
	self.controller:SendTransReq()
end

function UICardListView:PlayTransAnim(data)
	self.controller:ClearLeftSlotIdx()
	self.controller:ClearRightSlotIdx()
	self:RefreshTransCardShow()
	self:ChangeViewPage(pageToggleData.toggleDefaultIndex, true)
	self.uITransSuccess:SetActive(true)
	local data1 = {cfgId = data.leftId}
	local data2 = {cfgId = data.rightId}
	IconItemCtr:SetData(self, self.iconItem1, data1)
	local cfgData = ManagerContainer.CfgMgr:GetCardDataById(data.rightId)
	if cfgData then
		local level = cfgData.CardLevel
		CommonUtil.LoadIcon(self, Constant.Quality_Equip_LV_Icons[level], function (sprite)
			self.iconItem1.level.image.sprite = sprite
		end)
		CommonUtil.LoadIcon(self, Constant.Quality_Equip_LV_Icons[level], function (sprite)
			self.newlevel.image.sprite = sprite
		end)
	end
	IconItemCtr:SetData(self, self.iconItem2, data2)
	local cfgData = ManagerContainer.CfgMgr:GetCardDataById(data.leftId)
	if cfgData then
		local level = cfgData.CardLevel
		CommonUtil.LoadIcon(self, Constant.Quality_Equip_LV_Icons[level], function (sprite)
			self.iconItem2.level.image.sprite = sprite
		end)
		CommonUtil.LoadIcon(self, Constant.Quality_Equip_LV_Icons[level], function (sprite)
			self.oldlevel.image.sprite = sprite
		end)
	end
end

function UICardListView:OnClickLeft()
	local leftSelectedIdx, rightSelectedIdx = self.controller:GetTransferSlotIdx()
	if not leftSelectedIdx then return end
	self.controller:ClearLeftSlotIdx()
	self:RefreshTransCardShow(leftSelectedIdx)
end

function UICardListView:OnClickRight()
	local leftSelectedIdx, rightSelectedIdx = self.controller:GetTransferSlotIdx()
	if not rightSelectedIdx then return end
	self.controller:ClearRightSlotIdx()
	self:RefreshTransCardShow(rightSelectedIdx)
end

function UICardListView:OnHide()

end

function UICardListView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UICardListView:OnClose()
	DropDownHelper.ClearDropDown(self.produce.dropdownFilter.dropdown);

	if updateHandle ~= nil then
		UpdateBeat:RemoveListener(updateHandle)
		updateHandle = nil
	end
	pageToggleData = nil
end

function UICardListView:OnDispose()
	self.composeTasks = {}
	self.composeCardIds = {}
	self.composeCardIdCounts = {}
	self.composeCosts = {}
	self.totalCost = 0
	self.curIdx = nil
	self.delta = nil

	if self.toggleTimer then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self.toggleTimer)
		self.toggleTimer = nil
	end

	self.produce.scrollview.loopGridView:Dispose()
	self.compose.scrollview.loopGridView:Dispose()
	self.trans.scrollview.loopGridView:Dispose()
	--self.compose.cardResult.loopListView:Dispose()

	if self.delayTimer then
		self.delayTimer:Stop()
	end
	self.delayTimer = nil
	self.isInit = nil

	lastComposeLogicData = nil
	lastComposeItem = nil
end

return UICardListView

