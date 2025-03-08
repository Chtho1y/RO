local UIBagCardListTipsView = require("UICardTips/UIBagCardListTipsView_Generate")

local cardList
function UIBagCardListTipsView:OnAwake(data)
	self.controller = require("UICardTips/UIBagCardListTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIBagCardListTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CARD_LIST_REFRESH, function()
		ManagerContainer.LuaUIMgr:AttrNoticeDisplay(self.controller:GetSlotIndex())
		self:UIClose()
	end)
end

function UIBagCardListTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIBagCardListTipsView:Init()
	cardList = self.controller:GetCardList()
	self.dscBox:SetActive(#cardList == 0)
end

function UIBagCardListTipsView:RefreshCardList()
	local newCardId = self.controller:GetCfgId()
	local newCardData = ManagerContainer.CfgMgr:GetCardDataById(newCardId)
	local slotIndex = self.controller:GetSlotIndex()
	local jobType, jobIcon
	if slotIndex == 1 then
		local heroData = ManagerContainer.DataMgr.UserData:GetHeroData()
		local jobData = ManagerContainer.CfgMgr:GetJobDataById(heroData.configId)
		jobType = jobData.JobType
	else
		local heroData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(slotIndex)
		local heroCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(heroData.configId)
		jobType = heroCfgData.JobType
	end

	for k,v in pairs(cardList) do
		ManagerContainer.GoPoolMgr:SpawnGo(Enum.PrefabNames.CardListItem, function(itemlua)
			local professhion = CommonUtil.EleInTable(jobType, newCardData.Profession)
			local state = self:CardRecommend(v, newCardId) and professhion
			local data1 = {cfgId = v, idx = state and 1 or 0, needRecommend = true}
			CommonUtil.BatchCreateItems(self, itemlua, self.cardScrollView.content.transform, data1, Enum.ItemIEnterType.EquipedCard)
			itemlua.btnReplace:SetActive(true)
			itemlua.btnPluginCard:SetActive(false)
			self.uiBase:AddButtonUniqueEventListener(itemlua.btnReplace.button, self, self.ChangeCard, k)
		end)
	end
end

function UIBagCardListTipsView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self:RefreshCardList()
end

function UIBagCardListTipsView:CardRecommend(oldCardId, newCardId)
	local oldCardData = ManagerContainer.CfgMgr:GetCardDataById(oldCardId)
	local newCardData = ManagerContainer.CfgMgr:GetCardDataById(newCardId)

	if newCardData.CardType == oldCardData.CardType then
		if newCardData.CardLevel == oldCardData.CardLevel then
			return newCardData.FightPower > oldCardData.FightPower
		else
			return newCardData.CardLevel > oldCardData.CardLevel
		end
	else
		return newCardData.CardType > oldCardData.CardType
	end
end

function UIBagCardListTipsView:ChangeCard(button, params)
	local cardSlotIndex = params[0]

	self.controller:SendInsertCard(cardSlotIndex)
end

function UIBagCardListTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIBagCardListTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, function ()
		self:UIClose()
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardEquipList)
	end)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, function ()
		self:UIClose()
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardEquipList)
	end)
end

function UIBagCardListTipsView:OnHide()

end

function UIBagCardListTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
	self:RefreshCardList()
end

function UIBagCardListTipsView:OnClose()
	cardList = nil
end

function UIBagCardListTipsView:OnDispose()

end

return UIBagCardListTipsView

