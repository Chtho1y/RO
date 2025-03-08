local UIEquipTipsView = require("UIEquipTips/UIEquipTipsView_Generate")
local IconItemCtr = require("Common/IconItemCtr")
local ConditionJudge = require("Common/ConditionJudge")
local EquipSlotItemNewCtr = require("Common/EquipSlotItemNewCtr")

function UIEquipTipsView:OnAwake(data)
	self.controller = require("UIEquipTips/UIEquipTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIEquipTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddUIEventHandlerClickListener(self.uIEventHandler, function (go)
		if go and go.transform:IsChildOf(self.transform) then
			return
		end
		ManagerContainer.LuaUIMgr:Hide(self.uiData.id)
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HERO_EQUIP_REFRESH, function()
		local cfgId = self.controller:GetCfgId()
		local slotIndex = self.controller:GetSlotIndex()
		local equipCfgData = ManagerContainer.CfgMgr:GetEquipById(cfgId)
		-- 道具图标
		local slots = self.controller:GetSlot();
		local _cardIdList = self.controller:GetCardIdList();
		local data = {false, nil, nil, slots, slotIndex, equipCfgData.Type, nil, _cardIdList}

		EquipSlotItemNewCtr:SetData(self, self.equipSlotItemNew, data)
		self:RefreshCards()
		self:RefreshCardBtns()

		local slotIndex = self.controller:GetSlotIndex()
		ManagerContainer.LuaUIMgr:AttrNoticeDisplay(slotIndex)
	end)
end

function UIEquipTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIEquipTipsView:Init()

	local id = self.controller:GetHeroId()
	local heroConfigId = self.controller:GetHeroConfigId()
	local cfgId = self.controller:GetCfgId()
	local slotIndex = self.controller:GetSlotIndex()
	local enterType = self.controller:GetEnterType()
	local nickName = self.controller:GetNickName()

	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	if itemCfgData == nil then
		LogError(cfgId.."  isnt exist in itemCfg")
		return
	end

	local equipCfgData = ManagerContainer.CfgMgr:GetEquipById(cfgId)
	if equipCfgData == nil then
		LogError(cfgId.."  isnt exist in equipCfg")
		return
	end

	if id == 0 then
		return
	end

	local jobIcon
	if id == 1 then
		local jobData = ManagerContainer.CfgMgr:GetJobDataById(heroConfigId)
		jobIcon = jobData.JobIcon
	else
		local heroCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(heroConfigId)
		jobIcon = heroCfgData.JobIcon
	end

	CommonUtil.LoadIcon(self, jobIcon, function (sprite)
		self.jobIcon.image.sprite = sprite
	end)

	local name
	if id == 1 then
		local cfgData = ManagerContainer.CfgMgr:GetJobDataById(heroConfigId)
		if nickName == nil then
			name = CommonUtil.GetHeroJobAndNameByUid(id, heroConfigId) 
		else
			if cfgData == nil then
				name = nickName
			else
				name = I18N.T(cfgData.JobName) .. nickName
			end
		end

        
		
	else
		name = CommonUtil.GetHeroJobAndNameByUid(id, heroConfigId) 
	end
	self.heroName.text.text = name
	

	-- 道具图标
	local slots = self.controller:GetSlot();
	local _cardIdList = self.controller:GetCardIdList();
	local data = {false, nil, nil, slots, slotIndex, equipCfgData.Type, nil, _cardIdList}

	EquipSlotItemNewCtr:SetData(self, self.equipSlotItemNew, data)
	-- 道具名称
	local name = I18N.T(itemCfgData.Name)
	self.textName.text.text = name
	-- 道具描述
	self.desTxt.text.text = itemCfgData.Describe
	-- 道具类型
	self.type1.text2.text.text = I18N.T("ItemTypeDes_" .. itemCfgData.ResType)
	self.type2.text2.text.text = I18N.T(Enum.EquipTypeName[equipCfgData.Type])

	--基础属性
	self:RefreshEquipInfo(name)
	--设置一些按钮的显示状态，这个目前是给头像交互界面用的，只有头像交互界面打开tip的时候，按钮需要隐藏，应为不能对这些按钮做操作
	self:SetButtonsState();

	ManagerContainer.RedPointMgr.HeroRPCtr:RefreshRoleCardSlotRP(slotIndex)
end

--设置一些按钮的显示状态，有些界面打开这个tip仅仅是为了查看，所有一些按钮是不能用的
function UIEquipTipsView:SetButtonsState()
	local _isView = self.controller:GetIsView();
	self.btnChange.gameObject:SetActive(not _isView);
	self.btnBox.gameObject:SetActive(not _isView);
end

function UIEquipTipsView:RefreshEquipInfo(name)
	local cfgId = self.controller:GetCfgId()
	local slotIndex = self.controller:GetSlotIndex()
	local slotType = self.controller:GetSlotType()
	local slots = self.controller:GetSlot();

	local jobType = 1
	local slot = ManagerContainer.DataMgr.UserData:GetSlotBySlotIndex(slotIndex)
	if slot then
		local heroId = slot.hero_id
		if heroId == 1 then
			jobType = ManagerContainer.DataMgr.UserData:GetJobType()
		else
			local logicData = CommonUtil.GetHeroLogicDataByUid(heroId)
			local configId = logicData.configId
			local partnerData = ManagerContainer.CfgMgr:GetPartnerDataById(configId)
			jobType = partnerData.JobType
		end
	end

	local refineLv = 0
	if slots ~= nil then
		refineLv = slots[slotType].level
		--self.contentItem.textLv:SetActive(refineLv > 0)
		--if refineLv > 0 then
		--	self.contentItem.textLv.text.text = "+"..refineLv
		--end
	end

	-- 装备基本属性
	local equipCfgData = ManagerContainer.CfgMgr:GetEquipById(cfgId)
	local baseAttrs = {}
	for k,v in pairs(Enum.HeroAttrType) do
		if equipCfgData[k] and equipCfgData[k] ~= 0 then
			table.insert(baseAttrs, {Enum.HeroAttrType[k], equipCfgData[k], refineLv})
		end
	end

	table.sort(baseAttrs, function (a,b)
		return a[1] < b[1]
	end)
	local idx = 0
	for k, v in pairs(baseAttrs) do
		idx = idx + 1
		CommonUtil.BatchCreateItemsLoopWithMould(self, self.attrItem, self.baseAttr.grid.transform, v, idx, Enum.ItemIEnterType.Attr)
	end

	self.suit:SetActive(equipCfgData.Suit > 0)
	-- 装备套装属性
	if equipCfgData.Suit > 0 then
		local suitNum, suits = ManagerContainer.DataMgr.UserData:GetSuitNum(slots, slotType)
		local index = math.floor(suitNum/2)

		local equipSuitCfgData = ManagerContainer.CfgMgr:GetEquipSuitById(equipCfgData.Suit)
		local equipSuits = ManagerContainer.CfgMgr:GetSameSuitEquipsBySuitId(equipCfgData.Suit, jobType)
		self.suitTxt.text.text = equipSuitCfgData.Name
		self.suitActiveTxt.text.text = string.format("(%s/6)", suitNum)

		for i = 1, 6 do
			self["suitText"..i]:SetActive(equipSuits[i] ~= nil)
			if equipSuits[i] then
				self["suitText"..i].text.text = I18N.T(suits[i] and suits[i] or (equipSuits and equipSuits[i].Name) or "")
				self["suitText"..i].check:SetActive(suits[i] ~= nil)
				if suits[i] then
					CommonUtil.SetTextColor(self["suitText"..i].text, Constant.GreenColorText)
				end
			end
		end

		local i = 1
		local keyName = ("Suit" .. i)
		local suitAttrs = {}
		while (equipSuitCfgData[keyName] ~= nil) do
			if equipSuitCfgData[keyName] ~= "" then
				table.insert(suitAttrs, {i, equipSuitCfgData[keyName], i <= index, i})
			end
			i = i + 1
			keyName = ("Suit" .. i)
		end
		for k,v in pairs(suitAttrs) do
			local addAttr = CommonUtil.DeserializeCfgItemList(v[2])
			if #addAttr > 0 then
				addAttr = addAttr[1]
				local id = addAttr[1]
				local name = I18N.T("Attr_"..id)
				if id == Enum.HeroAttrType.Attack_Percent or id == Enum.HeroAttrType.MagicAttack_Percent then
					name = I18N.T("Attack")
				elseif id == Enum.HeroAttrType.Defense_Percent or id == Enum.HeroAttrType.MagicDefense_Percent then
					name = I18N.T("show_def")
				end
				self["additionText"..v[1]].text.text = I18N.SetLanguageValue("SuitAddAttr", v[1]*2, name, (addAttr[2]/100).."%")
				if v[3] then
					CommonUtil.SetTextColor(self["additionText"..v[1]].text, Constant.GreenColorText)
				end
			end
		end
	end

	self:RefreshCards()
	self:RefreshCardBtns()

	self.redPointItem:SetActive(self.controller:GetCanRefine())
end

function UIEquipTipsView:RefreshCards()
	local slotIndex = self.controller:GetSlotIndex()
	local slotType = self.controller:GetSlotType()
	local slots = self.controller:GetSlot();
	--卡片信息
	if slots ~= nil then
		local cardList = slots[slotType].card_id_list
		local list = {}
		for i = 1, Constant.CARD_SLOT_LIMIT do
			local condition = ManagerContainer.CfgMgr:GetCardUnlockConditionById(slotType * 100 + i)
			if condition ~= nil then
				list[#list + 1] = {cfgId = cardList[i] ~= nil and cardList[i] or 0, condition = condition.UnlockingCondition[1], idx = i}
			end
		end
		for k,v in pairs(list) do
			local cardIcon = self["cardIcon"..k]
			cardIcon.owned:SetActive(v.cfgId > 0)
			cardIcon.gameObject:SetActive(true)
			local result, val,content = ConditionJudge:ConditionPassResult1(v.condition)
			if v.cfgId > 0 then
				IconItemCtr:SetData(self, cardIcon.iconItem, v, nil, self, self.OnCardClick)
			end
			local _isView = self.controller:GetIsView();
			local _showLock = not result;
			if _isView then
				_showLock = false
				cardIcon.unowned:SetActive(v.cfgId == 0)
			else
				cardIcon.unowned:SetActive(v.cfgId == 0 and result)
			end
			cardIcon.locked:SetActive(_showLock)
			cardIcon.lvLocked.text.text = content

			if result then
				if self.rpGos == nil then
					self.rpGos = {}
				end
				local rpState = ManagerContainer.RedPointMgr.HeroRPCtr:GetRoleCardSlotRP(slotIndex, slotType, k - 1)
				if rpState == Enum.RedPointEnum.CardSlotRP then
					if self.rpGos[k] then
						self.rpGos[k]:SetActive(true)
					else
						local redPointGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.UICommonPath, Enum.RPPrefab[Enum.RPType.CardOpen])
						self.rpGos[k] = redPointGo
						self.rpGos[k].transform:SetParent(cardIcon.rpPoint.transform)
						self.rpGos[k].transform.localPosition = Vector3.zero
						self.rpGos[k].transform.localScale = Vector3.one

						self.rpGos[k]:SetActive(true)
					end
				end
			end
		end
	end
end

function UIEquipTipsView:RefreshCardBtns()
	local id = self.controller:GetHeroId()
	local slotType = self.controller:GetSlotType()
	local cardState = self.controller:InsertedCards(slotType)
	local emptyRP = ManagerContainer.RedPointMgr.HeroRPCtr:GetRoleCardSlotEmptyRP(id, slotType)
	self.btnCard:SetActive(not cardState or emptyRP)
	self.btnRemoveCard:SetActive(cardState and not emptyRP)
end

function UIEquipTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIEquipTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnChange.button, function ()
		self:UIClose()
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIEquipList, self.controller:GetData())
	end)

	self.uiBase:AddButtonEventListener(self.btnClose.button, function ()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, function ()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.btnRefine.button, function ()
		self:UIClose()
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIEquipRefineTips, self.controller:GetData()[1])
	end)

	self.uiBase:AddButtonEventListener(self.btnCard.button, self, self.OnOneKeyCardClick)
	self.uiBase:AddButtonEventListener(self.btnRemoveCard.button, self, self.OnOneKeyCardDownClick)

	self.uiBase:AddButtonEventListener(self.cardIcon1.unowned.icon.button, self, self.OnCardClick, 1)
	self.uiBase:AddButtonEventListener(self.cardIcon2.unowned.icon.button, self, self.OnCardClick, 2)
	self.uiBase:AddButtonEventListener(self.cardIcon3.unowned.icon.button, self, self.OnCardClick, 3)
	self.uiBase:AddButtonEventListener(self.cardIcon4.unowned.icon.button, self, self.OnCardClick, 4)
end

function UIEquipTipsView:OnOneKeyCardClick()
	--一键上卡
	self.controller:OnOneKeyCardUp()
end

function UIEquipTipsView:OnOneKeyCardDownClick()
	--一键卸卡
	self.controller:OnOneKeyCardDown()
end

function UIEquipTipsView:OnCardClick(button, params)
	local _isView = self.controller:GetIsView()
	if _isView then
		return;
	end
	self:UIClose()
	local data
	if type(params[0]) ~= "table" then
		data = {cfgId = 0, idx = params[0]}
	else
		data = params[0]
	end
	data.equipTipsData = self.controller:GetData()
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardTips, self.controller:GetData()[1])
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardListTips, data)
end

function UIEquipTipsView:OnHide()
end

function UIEquipTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIEquipTipsView:OnClose()

end

function UIEquipTipsView:OnDispose()
	self.uIEventHandler:RemoveListener()

	if self.rpGos then
		for k,v in pairs(self.rpGos) do
			ManagerContainer.ResMgr:RecycleGO(Constants.UICommonPath, Enum.RPPrefab[Enum.RPType.CardSlot], v)
		end
		self.rpGos = nil
	end
end

return UIEquipTipsView

