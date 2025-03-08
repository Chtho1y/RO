local UICardTipsView = require("UICardTips/UICardTipsView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

local defineLvStr = " <color=#1f9300>+%s</color>"
local canOneKey = false
function UICardTipsView:OnAwake(data)
	self.controller = require("UICardTips/UICardTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UICardTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CARD_LIST_REFRESH, function()
		CommonUtil.BatchDisposeItems(self)
		--ManagerContainer.LuaUIMgr:AttrNoticeDisplay(self.controller:GetSlotIndex())
		self:Init()
	end)
end

function UICardTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UICardTipsView:Init()
	canOneKey = false
	local cfgId = self.controller:GetCfgId()
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)

	local slotIndex = self.controller:GetSlotIndex()
	local slotType = self.controller:GetSlotType()
	local slots = ManagerContainer.DataMgr.UserData:GetCurSlotInfos(slotIndex)
	local refineLv = slots[slotType].level
	-- 道具图标
	IconItemCtr:SetData(self, self.topItem.iconItem, self.controller.data, Enum.ItemIEnterType.HeroEquip)

	-- 道具名称
	local name = I18N.T(itemCfgData.Name)
	if refineLv > 0 then
		self.textName.text.text = name..(string.format(defineLvStr, refineLv))
	else
		self.textName.text.text = name
	end
	-- 道具类型
	self.textType.uILocalizeScript:SetContent("ItemTypeDes_" .. itemCfgData.ResType)

	--卡片信息
	local cardList = slots[slotType].card_id_list
	local list = {}
	for i = 1, Constant.CARD_SLOT_LIMIT do
		if cardList[i] ~= nil and cardList[i] > 0 then
			canOneKey = true
		end
		local condition = ManagerContainer.CfgMgr:GetCardUnlockConditionById(slotType * 100 + i)
		if condition ~= nil then
			list[#list + 1] =
				{cfgId = cardList[i] ~= nil and cardList[i] or 0, condition = condition.UnlockingCondition[1], idx = i,
				 slotType = slotType, slotIndex = slotIndex}
		end

		if cardList[i] == nil or cardList[i] == 0 then
			self["slot"..i].slotBlueCard:SetActive(false)
			self["slot"..i].slotPurpleCard:SetActive(false)
			self["slot"..i].slotGoldCard:SetActive(false)
		else
			local cardData = ManagerContainer.CfgMgr:GetCardDataById(cardList[i])
			self["slot"..i].slotBlueCard:SetActive(cardData.CardType == Enum.CardType.NORMAL)
			self["slot"..i].slotPurpleCard:SetActive(cardData.CardType == Enum.CardType.MINIBOSS)
			self["slot"..i].slotGoldCard:SetActive(cardData.CardType == Enum.CardType.MVP)
		end
	end
	for k,v in pairs(list) do
		CommonUtil.BatchCreateItems(self, self["cardslotItem"..k], self.cardScrollView.content.transform, v)
	end

	--self.cardScrollView.content.verticalLayoutGroup:SetLayoutHorizontal()
	--self.cardScrollView.content.verticalLayoutGroup:SetLayoutVertical()

	ManagerContainer.RedPointMgr.HeroRPCtr:RefreshRoleCardSlotRP(slotIndex)
end

function UICardTipsView:ShowCardList(button, params)
	local logicData = params[0]
	local cardDatas = ManagerContainer.DataMgr.CardData:GetAllCardDatasByType(logicData.slotType)
	if cardDatas == nil or #cardDatas == 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NoCardTips")
	else
		self:UIClose()
		logicData.tipsData = self.controller:GetData()
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardListTips, logicData)
	end
end

function UICardTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UICardTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, function ()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, function ()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.btnOneKeyRemove.button, function ()
		if not canOneKey then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(Enum.ActionNotiveType.CardUnloadTips)
			return
		end
		self.controller:SendOneKeyRemoveCard()
	end)
end

function UICardTipsView:OnHide()
	--if self.fxGoes ~= nil then
	--	for i =1, #self.fxGoes do
	--		ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath,self.fxGoes[i].name,self.fxGoes[i].go)
	--	end
	--	self.fxGoes = {}
	--end
	CommonUtil.BatchDisposeItems(self)
end

function UICardTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UICardTipsView:OnClose()

end

function UICardTipsView:OnDispose()

end

return UICardTipsView

