local UIGuildWarActivityShopView = require("UIActivity/UIActivityTowerView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

local RankBgColorIcon = {"FrameNew/bg_label_red", "FrameNew/bg_label_yellow", "FrameNew/bg_label_purple", "FrameNew/bg_label_blue", "FrameNew/bg_label_green", "FrameNew/bg_label_green"}
local RankBGColor = {Color(1, 0.76, 0.72, 1), Color(1, 0.86, 0.57, 1), Color(0.98, 0.67, 1, 1), Color(0.65, 0.87, 1, 1), Color(0.66, 0.92, 0.71, 1), Color(0.66, 0.92, 0.71, 1)}
local BannerPath = 'RankBanner/banner_tower_guildwar_cn'

local pageToggleData = {}
local countlimit = 10
local reward
function UIGuildWarActivityShopView:OnAwake(data)
	self.controller = require("UIGuildWar/UIGuildWarActivityShopCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildWarActivityShopView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RUNE_SHOP_DATA_CHANGED, self, self.RefreshNew)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_OPEN_STATE_CHANGED, self, self.OnOpenStateChanged)
end

function UIGuildWarActivityShopView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildWarActivityShopView:Init()
	self.rankIdx = 0
	self.controller:InitData()

	self:InitGrid()
	self:InitTopInfo()
end

function UIGuildWarActivityShopView:InitGrid()
	self.RankListScroll.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetRankItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self.LimitedListScroll.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetShopItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)

	self.RankListScroll.loopGridView.ScrollRect.enabled = false
	self.LimitedListScroll.loopGridView.ScrollRect.enabled = false
	self.RankListScroll:SetActive(true)
	self.LimitedListScroll:SetActive(true)
end

function UIGuildWarActivityShopView:InitTopInfo()
	self.mapToggle.text.uILocalizeScript:SetContent("RankReward")
	self.rewardsToggle.text.uILocalizeScript:SetContent("GuildWarDiagram31")

	CommonUtil.LoadIcon(self, BannerPath, function (sprite)
		self.banner1.image.sprite = sprite
	end)

	self.btnQuestion:SetActive(false)
	self.timeBox:SetActive(false)
	self.banner1:SetActive(true)
	self.banner2:SetActive(false)
	self.banner3:SetActive(false)
	self.btnGoto:SetActive(false)
	self.btnGetRewards:SetActive(false)
	self.bottom:SetActive(false)
end

function UIGuildWarActivityShopView:OnValueChangedToggle(index, needRefresh)
	local rankListState = (pageToggleData.toggleDefaultIndex <= 2)
	local limitedState = (pageToggleData.toggleDefaultIndex == 3)

	self.rankListBox:SetActive(rankListState)
	self.limitedBox:SetActive(limitedState)

	if rankListState then
		local cfgDatas = nil
		if pageToggleData.toggleDefaultIndex == 1 then
			cfgDatas = self.controller:GetGuildsmenRewords()
		elseif pageToggleData.toggleDefaultIndex == 2 then
			cfgDatas = self.controller:GetMvpRewords()
		end
		local num = cfgDatas and #cfgDatas or 0
		if not needRefresh then
			self.RankListScroll.loopGridView:RefreshListByIndex(num, 0)
		else
			self.RankListScroll.loopGridView:RefreshListByIndex(num)
		end
	elseif limitedState then
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

function UIGuildWarActivityShopView:RefreshNew()
	if pageToggleData.toggleDefaultIndex == 3 then
		self:OnValueChangedToggle(nil, true)
	end
end

function UIGuildWarActivityShopView:GetRankItemByRowColumn(gridView, itemIndex, row, column)
	local cfgDatas = nil
	if pageToggleData.toggleDefaultIndex == 1 then
		cfgDatas = self.controller:GetGuildsmenRewords()
	elseif pageToggleData.toggleDefaultIndex == 2 then
		cfgDatas = self.controller:GetMvpRewords()
	end
	if not cfgDatas then
		return nil
	end
	local cfgData = cfgDatas[itemIndex + 1]
	if not cfgData then
		return nil
	end
	local item = gridView:NewListViewItem('RankRewardsItem')
	item.gameObject.name = itemIndex
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'RankRewardsItem', item.gameObject)
	itemLua.textName:SetActive(false)
	itemLua.textDsc:SetActive(false)
	itemLua.num:SetActive(false)
	itemLua.textAdvTarget:SetActive(true)
	itemLua.textLowestTarget:SetActive(false)
	itemLua.labelEstimate:SetActive(false)
	itemLua.labelReceived:SetActive(false)

	local rank = nil
	local rankLangKey = nil
	local nameLangKey = nil

	local itemDatas = nil
	if pageToggleData.toggleDefaultIndex == 1 then
		rank = cfgData[1]
		rankLangKey = cfgData[2]
		itemDatas = cfgData[3]
	elseif pageToggleData.toggleDefaultIndex == 2 then
		local type = cfgData[1]
		rank = cfgData[2]
		rankLangKey = cfgData[3]
		itemDatas = cfgData[4]
		if rank == 1 then
			if type == 1 then
				nameLangKey = 'GuildWarDiagram26'
			else
				nameLangKey = 'GuildWarDiagram25'
			end
		elseif rank == 2 then
			if type == 1 then
				nameLangKey = 'GuildWarDiagram28'
			else
				nameLangKey = 'GuildWarDiagram27'
			end
		else
			if type == 1 then
				nameLangKey = 'GuildWarDiagram30'
			else
				nameLangKey = 'GuildWarDiagram29'
			end
		end
	end
	CommonUtil.LoadIcon(self, RankBgColorIcon[rank], function (sprite)
		itemLua.imageLabel.image.sprite = sprite
	end, itemLua, "rankBg")
	itemLua.nameBG.image.color = RankBGColor[rank]

	itemLua.labelRank.text.uILocalizeScript:SetContent(rankLangKey)
	itemLua.textAdvTarget.text.text = nameLangKey and I18N.T(nameLangKey) or ''

	CommonUtil.BatchCreateItemsLoopSpawnPrefabNew1(self, itemDatas, Enum.PrefabNames.IconSmallItem, "IconItem", itemLua.RewardsNode.transform, Enum.ItemIEnterType.Bag, self, self.OnItemClick)
	return item
end

function UIGuildWarActivityShopView:GetShopItemByRowColumn(gridView, itemIndex, row, column)
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

function UIGuildWarActivityShopView:OnItemClick(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIGuildWarActivityShopView:OnPay(button, params)
	local data = params[0]
	local shopType, shopSubType = self.controller:GetCurShopType()
	local errorCode = ManagerContainer.PayMgr:RuneShopPay(shopType, shopSubType, data.id)
	local errorCodeKey = ManagerContainer.PayMgr:GetInitPayErrorCodeLangKey(errorCode)
	if not errorCodeKey then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCodeKey)
	end
end

function UIGuildWarActivityShopView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuildWarActivityShopView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.backBtn.button, self, self.OnCloseClick)
	CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.toggleGroup, 1, self.OnValueChangedToggle, self)
end

function UIGuildWarActivityShopView:OnCloseClick()
	self:UIClose()
end

function UIGuildWarActivityShopView:OnHide()
end

function UIGuildWarActivityShopView:OnShow(data)
	self.controller:SetData(data)
end

function UIGuildWarActivityShopView:OnClose()
end

function UIGuildWarActivityShopView:OnDispose()
	CommonUtil.RecycleFromBatchItemsByPrefabName(self, Enum.PrefabNames.IconSmallItem)
	self.RankListScroll.loopGridView:Dispose()
	CommonUtil.RecycleFromBatchItemsByPrefabName(self, Enum.PrefabNames.RankShopRewardIconItem)
	self.LimitedListScroll.loopGridView:Dispose()
	self.controller:OnDispose()
end

function UIGuildWarActivityShopView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.RankListScroll.loopGridView.ScrollRect.enabled = true
	self.LimitedListScroll.loopGridView.ScrollRect.enabled = true
end

function UIGuildWarActivityShopView:OnOpenStateChanged(isOpen)
	if isOpen then return end
	self:UIClose()
end

return UIGuildWarActivityShopView

