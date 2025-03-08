local UIIdolActivityShopView = require("UIActivity/UIActivityTowerView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

local RankBgColorIcon = {"FrameNew/bg_label_red", "FrameNew/bg_label_yellow", "FrameNew/bg_label_purple", "FrameNew/bg_label_blue", "FrameNew/bg_label_green", "FrameNew/bg_label_green"}
local RankBGColor = {Color(1, 0.76, 0.72, 1), Color(1, 0.86, 0.57, 1), Color(0.98, 0.67, 1, 1), Color(0.65, 0.87, 1, 1), Color(0.66, 0.92, 0.71, 1), Color(0.66, 0.92, 0.71, 1)}
local BannerPath = 'RankBanner/banner_idol_sale_cn'

local pageToggleData = {}
local countlimit = 10
local reward
function UIIdolActivityShopView:OnAwake(data)
	self.controller = require("UISeason/UIIdolActivityShopCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIIdolActivityShopView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RUNE_SHOP_DATA_CHANGED, self, self.RefreshNew)
end

function UIIdolActivityShopView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIIdolActivityShopView:Init()
	self.rankIdx = 0
	self.controller:InitData()
	self.controller:SendShopInfoReq()
	self:InitGrid()
	self:InitTopInfo()
end

function UIIdolActivityShopView:InitGrid()
	self.LimitedListScroll.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetShopItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)

	self.LimitedListScroll.loopGridView.ScrollRect.enabled = false
	self.LimitedListScroll:SetActive(true)
end

function UIIdolActivityShopView:InitTopInfo()
	self.mapToggle:SetActive(false)
	self.rewardsToggle:SetActive(false)
	self.saleToggle.toggle.isOn = true
	CommonUtil.LoadIcon(self, BannerPath, function (sprite)
		self.banner1.image.sprite = sprite
	end)
	self.rankListBox:SetActive(false)
	self.btnQuestion:SetActive(false)
	self.timeBox:SetActive(false)
	self.banner1:SetActive(true)
	self.banner2:SetActive(false)
	self.banner3:SetActive(false)
	self.btnGoto:SetActive(false)
	self.btnGetRewards:SetActive(false)
	self.bottom:SetActive(false)
end

function UIIdolActivityShopView:OnValueChangedToggle(index, needRefresh)
	local limitedState = (pageToggleData.toggleDefaultIndex == 1)
	self.limitedBox:SetActive(limitedState)
	if limitedState then
		self.controller:RefreshCurShopData(true)
		local datas = self.controller:GetShowGoodsDatas()
		local num = datas and #datas or 0
		if not needRefresh then
			self.LimitedListScroll.loopGridView:RefreshListByIndex(num, 0)
		else
			self.LimitedListScroll.loopGridView:RefreshListByIndex(num)
		end
	end
end

function UIIdolActivityShopView:RefreshNew()
	if pageToggleData.toggleDefaultIndex == 1 then
		self:OnValueChangedToggle(nil, true)
	end
end

function UIIdolActivityShopView:GetShopItemByRowColumn(gridView, itemIndex, row, column)
	local datas = self.controller:GetShowGoodsDatas()
	if not datas then return end

	local item = gridView:NewListViewItem('RankShopLimitedItem')
	item.gameObject.name = itemIndex
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'RankShopLimitedItem', item.gameObject)
	local data = datas[itemIndex + 1]
	local cfgData = data.cfgData
	CommonUtil.LoadIcon(self, cfgData.Banner, function (sprite)
		itemLua.itemBg.image.sprite = sprite
	end)
	CommonUtil.LoadIcon(self, cfgData.NameImg, function (sprite)
		itemLua.itemText.image.sprite = sprite
	end)

	itemLua.saveLabel.text.text.text = cfgData.ExtraNum
	itemLua.presentPrice.number.text.text = data.price
	itemLua.labelLimited.textLimited.uILocalizeScript:SetContentAndValues("RushListLimitBuy", {data:GetRemainBuyNum()})

	itemLua.soldout:SetActive(not data:IsCanBuy())

	local itemDatas = {}
	for _,v in pairs(cfgData.Reward) do
		local itemData = {cfgId = v[1], num = v[2]}
		itemDatas[#itemDatas + 1] = itemData
	end

	CommonUtil.BatchCreateItemsLoopSpawnPrefabNew(self, itemDatas, Enum.PrefabNames.RankShopRewardIconItem, itemLua.RewardsNode.transform, Enum.ItemIEnterType.Bag, self, self.OnItemClick)

	self.uiBase:AddButtonUniqueEventListener(itemLua.presentPrice.button, self, self.OnPay, data)
	return item
end

function UIIdolActivityShopView:OnItemClick(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIIdolActivityShopView:OnPay(button, params)
	if not ManagerContainer.DataMgr.CompetitionData:CanOpenSeasonUI() then
		return
	end
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if IsOver then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LabelOver")
		return
	end
	local data = params[0]
	local shopType, shopSubType = self.controller:GetCurShopType()
	local errorCode = ManagerContainer.PayMgr:RuneShopPay(shopType, shopSubType, data.id)
	local errorCodeKey = ManagerContainer.PayMgr:GetInitPayErrorCodeLangKey(errorCode)
	if not errorCodeKey then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCodeKey)
	end
end

function UIIdolActivityShopView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIIdolActivityShopView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.backBtn.button, self, self.OnCloseClick)
	CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.toggleGroup, 1, self.OnValueChangedToggle, self)
end

function UIIdolActivityShopView:OnCloseClick()
	self:UIClose()
end

function UIIdolActivityShopView:OnHide()
end

function UIIdolActivityShopView:OnShow(data)
	self.controller:SetData(data)
end

function UIIdolActivityShopView:OnClose()
end

function UIIdolActivityShopView:OnDispose()
	CommonUtil.RecycleFromBatchItemsByPrefabName(self, Enum.PrefabNames.IconSmallItem)
	CommonUtil.RecycleFromBatchItemsByPrefabName(self, Enum.PrefabNames.RankShopRewardIconItem)
	self.LimitedListScroll.loopGridView:Dispose()
	self.controller:OnDispose()
end

function UIIdolActivityShopView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.LimitedListScroll.loopGridView.ScrollRect.enabled = true
end

function UIIdolActivityShopView:OnOpenStateChanged(isOpen)
	if isOpen then return end
	self:UIClose()
end

return UIIdolActivityShopView

