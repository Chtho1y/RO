local UICardListTipsView = require("UICardTips/UICardListTipsView_Generate")
local CardListItemCtr = require("Common/CardListItemCtr")
local CardListEquippedItemCtr = require("Common/CardListEquippedItemCtr")

local cardDatas
local needRecommend
function UICardListTipsView:OnAwake(data)
	self.controller = require("UICardTips/UICardListTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UICardListTipsView:RefreshCardData()
	local slotIndex = self.controller:GetSlotIndex()
	--local slotType = self.controller:GetSlotType()
	--local cardSlot = self.controller:GetCardSlotIndex()
	--
	--local slots = ManagerContainer.DataMgr.UserData:GetCurSlotInfos(slotIndex)
	--local cfgId = slots[slotType].card_id_list[cardSlot] or 0
	--self.controller:SetCfgId(cfgId)

	ManagerContainer.LuaUIMgr:AttrNoticeDisplay(slotIndex)
end

function UICardListTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CARD_LIST_REFRESH, function()
		self:RefreshCardData()
		--self:Init()
		self:UIClose()
	end)
end

function UICardListTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

local function IsInCardList(val, list)
	for _,v in pairs(list) do
		if val == v.cfgId then
			return true
		end
	end
	return false
end

function UICardListTipsView:Init()
	local cfgId = self.controller:GetCfgId()
	local jobType = self.controller:GetHeroJobType()
	local list = ManagerContainer.DataMgr.CardData:GetAllCardDatasByType(self.controller:GetSlotType())
	CommonUtil.ArraySortSelections(list, Enum.TableSortRule.Down, "CardType", "CardLevel", "FightPower", "cfgId")
	--筛选 排序
	cardDatas = CommonUtil.ArrayFilterSelections(list, Enum.FilterType.AND, {"Profession"}, {jobType})
	needRecommend = false
	if cardDatas ~= nil and next(cardDatas)  then
		needRecommend = true
		CommonUtil.ArraySortSelections(cardDatas, Enum.TableSortRule.Down, "CardType", "CardLevel", "FightPower", "cfgId")

		local curCardCfg = ManagerContainer.CfgMgr:GetCardDataById(cfgId)
		if curCardCfg and curCardCfg.FightPower >= cardDatas[1].FightPower then
			needRecommend = false
		end
	end

	if list then
		for _,v in pairs(list) do
			if not IsInCardList(v.cfgId, cardDatas) then
				cardDatas[#cardDatas + 1] = v
			end
		end
	end

	self.cardListEquippedItem:SetActive(cfgId > 0)
	self.cardSlotBlank:SetActive(cfgId == 0)
	if cfgId > 0 then
		local itemLua = self.cardListEquippedItem
		local data = {cfgId = cfgId, heroId = self.controller:GetHeroId()}
		CardListEquippedItemCtr:SetData(self, itemLua, data, self, self.ShowCardTips)
		self.uiBase:AddButtonUniqueEventListener(itemLua.btnRemove.button, self, self.RemoveCard, cfgId)
	end

	self.dscBox:SetActive(cardDatas == nil)
	self.cardScrollView:SetActive(cardDatas ~= nil)
end

function UICardListTipsView:OnPageInEnd()
	self.super:OnPageInEnd()

	local cfgId = self.controller:GetCfgId()
	if cardDatas ~= nil then
		CommonUtil.LoopGridViewEleCreateNew(self, self.cardScrollView.loopVerticalScrollRect, self.cardScrollView.content.verticalLayoutGroup, cardDatas, 0, nil, function (itemLua, idx)
			cardDatas[idx + 1].idx = idx + 1
			cardDatas[idx + 1].needRecommend = needRecommend
			CardListItemCtr:SetData(self, itemLua, cardDatas[idx + 1], self, self.ShowCardTips)
			self.uiBase:AddButtonUniqueEventListener(itemLua.btnPluginCard.button, self, self.InsertCard, cardDatas[idx + 1].cfgId)
			self.uiBase:AddButtonUniqueEventListener(itemLua.btnReplace.button, self, self.InsertCard, cardDatas[idx + 1].cfgId)
			itemLua.btnReplace:SetActive(cfgId > 0)
			itemLua.btnPluginCard:SetActive(cfgId == 0)
		end)
	end
end

function UICardListTipsView:ShowCardTips(button, params)

end

function UICardListTipsView:InsertCard(button, params)
	self.controller:SendInsertCard(params[0])
	local data = self.controller:GetData()
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardTips, data.tipsData)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIEquipTips, data.equipTipsData)
	--self:UIClose()
end

function UICardListTipsView:RemoveCard(button, params)
	self.controller:SendRemoveCard()
	local data = self.controller:GetData()
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardTips, data.tipsData)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIEquipTips, data.equipTipsData)
	--self:UIClose()
end

function UICardListTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UICardListTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
end

function UICardListTipsView:OnCloseClick()
	self:UIClose()
	local data = self.controller:GetData()
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardTips, data.tipsData)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIEquipTips, data.equipTipsData)
end

function UICardListTipsView:OnHide()

end

function UICardListTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UICardListTipsView:OnClose()
	self.cardScrollView.loopVerticalScrollRect:ClearCells()
	cardDatas = nil
end

function UICardListTipsView:OnDispose()

end

return UICardListTipsView

