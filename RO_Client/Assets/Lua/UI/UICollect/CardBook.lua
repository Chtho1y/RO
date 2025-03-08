local CardBook = class("CardBook")
local BitUtil = require("BitUtil")

local pageToggleData = {}
function CardBook:ctor()
end

function CardBook:InitGo(host,uiGo)
	self.host = host
	self.viewLua = CommonUtil.BindGridViewItem2Lua(self.host, "BookItem", uiGo)
	self.controller = require("UICollect/CardBookCtr"):new()
	self.host.controller:SetCardBookCtr(self.controller)

	self:InitPanel()
end

function CardBook:InitPanel()
	self:InitGrid()
	self.viewLua.qtyCard:SetActive(true)
	self.viewLua.qtyPet:SetActive(false)
	self.viewLua.qtyCollection:SetActive(false)

	self.viewLua.btnMaterials:SetActive(false)
	self.viewLua.dscBox:SetActive(false)
end

function CardBook:Hide()
	self.viewLua.gameObject:SetActive(false)
end

function CardBook:Show()
	self.viewLua.gameObject:SetActive(true)
end

function CardBook:SelectToggle()
	CommonUtil.CreateToggleMouduleOnlyBtns(self.host, pageToggleData, self.viewLua.toggleGroup, Enum.CollectQualityType.ALL, self.host.OnValueChangedToggle)
end

function CardBook:InitGrid()
	self.viewLua.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function CardBook:GetItemByRowColumn(gridView, itemIndex, row, column)
	local item = gridView:NewListViewItem('CardCollect')
	local cfgData = self.controller:GetShowDataByIdx(itemIndex + 1)
	local logicData = ManagerContainer.DataMgr.CollectionBookData:GetCollectionBookDataById(cfgData.Cardid)

	local itemlua = CommonUtil.BindGridViewItem2Lua(self.host, "CardCollect", item.gameObject)
	CommonUtil.UpdateItemPrefab(self.host, itemlua, cfgData, nil, self, self.OnCardClick)

	if logicData then
		self:RedPointRefresh(logicData, itemlua.uIRedPointRP)
	end
	return item
end

function CardBook:RedPointRefresh(logicData, redPoint)
	for i = 1,logicData.cardLevel do
		local rewarded = BitUtil.RshiftNumBandOne(logicData.rewardRec, i - 1) == 1
		if not rewarded then
			redPoint.gameObject:SetActive(true)
			return
		end
	end
end

function CardBook:OnValueChangedToggle()
	local type = pageToggleData.toggleDefaultIndex
	self.controller:GetHandBookCardCfgDatasByType(type)

	local count = self.controller:GetCurCount(type)
	local length = self.controller:GetCurShowDatasLength()
	local maxCount = length
	self.viewLua.qtyCard.text.text.text = count.."/"..maxCount

	self.viewLua.qtyCard.iconAll:SetActive(type == Enum.CollectQualityType.ALL)
	self.viewLua.qtyCard.iconNormal:SetActive(type == Enum.CollectQualityType.NORMAL)
	self.viewLua.qtyCard.iconMini:SetActive(type == Enum.CollectQualityType.MINIBOSS)
	self.viewLua.qtyCard.iconMvp:SetActive(type == Enum.CollectQualityType.MVP)

	if length > 0 then
		--self.viewLua.scrollView.loopGridView:SetListItemCount(length, true)
		self.viewLua.scrollView.loopGridView:RefreshListByIndex(length)
	end
end

function CardBook:OnCardClick(button, params)
	local cfgId = params[0]

	local data = {type = Enum.CollectType.Card, cfgId = cfgId}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICollectTips, data)
end

function CardBook:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.host.uiData.name, UIEventNames.CARD_HANDBOOK_REWARD_REFRESH, function()
		self:OnValueChangedToggle()
	end)
end

function CardBook:RemoveEventListener()

end

function CardBook:AddUIEventListener()
	self.host.uiBase:AddButtonEventListener(self.viewLua.btnBack.button, self, self.OnBtnBackClick)
end

function CardBook:OnBtnBackClick()
	if self.host and self.host.BookBack then
		self.host:BookBack()
	end
end

function CardBook:Dispose()

	self.viewLua.scrollView.loopGridView:Dispose()

	self.controller:OnDispose()
	self.controller = nil

    self.host = nil
	self.viewLua:GenerateDestroy()
    self.viewLua = nil
	pageToggleData = {}
end


return CardBook