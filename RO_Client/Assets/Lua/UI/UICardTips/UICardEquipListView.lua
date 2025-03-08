local UICardEquipListView = require("UICardTips/UICardEquipListView_Generate")
local CardEquipItemCtr = require("Common/CardEquipItemCtr")

function UICardEquipListView:OnAwake(data)
	self.controller = require("UICardTips/UICardEquipListCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UICardEquipListView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CARD_LIST_REFRESH, function()
		ManagerContainer.LuaUIMgr:AttrNoticeDisplay(self.controller:GetSlotIndex())
		self:UIClose()
	end)
end

function UICardEquipListView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UICardEquipListView:Init()
	for i = 1, 6 do
		self["card"..i]:SetActive(false)
	end

	local cfgId = self.controller:GetData()
	local cardData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)
	local slotType = cardData.CardLocation
	local slotsRoot = ManagerContainer.DataMgr.UserData:GetAllSlotInfos()
	for k,v in pairs(slotsRoot) do
		if #v.slot_list > 0 then
			local slot = v.slot_list[slotType]
			if slot.equip_id > 0 then
				local jobType, jobIcon
				local name = ""
				if k == 1 then
					local heroData = ManagerContainer.DataMgr.UserData:GetHeroData()
					local jobData = ManagerContainer.CfgMgr:GetJobDataById(heroData.configId)
					jobType = jobData.JobType
					jobIcon = jobData.JobIcon
					name = ManagerContainer.DataMgr.UserData:GetUserNickname()
				else
					local heroData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(v.hero_id)
					local heroCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(heroData.configId)
					jobType = heroCfgData.JobType
					jobIcon = heroCfgData.JobIcon
					name = I18N.T(heroCfgData.Name)
				end

				self["card"..k]:SetActive(true)
				local data = {cfgId = slot.equip_id, slotType = slotType, card_list = slot.card_id_list, belongName = name}
				local cardSlotIndex = CardEquipItemCtr:SetData(self, self["card"..k], data)

				local cardSlotCount = ManagerContainer.RedPointMgr.HeroRPCtr:GetCardSlotCountByType(slotType)
				local professhion = CommonUtil.EleInTable(jobType, cardData.Profession)
				local state = false
				local isEmpty = true
				if #slot.card_id_list >= cardSlotCount then
					for k,v in pairs(slot.card_id_list) do
						if v > 0 then
							isEmpty = false
							local state1 = self:CardRecommend(v, cfgId)
							if state1 then
								state = true
							end
						else
							state = true
						end
					end
				else
					state = true
				end
				if isEmpty then
					state = professhion
				else
					state = state and professhion
				end
				self["card"..k].labelRecommend:SetActive(state)

				CommonUtil.LoadIcon(self, jobIcon, function (sprite)
					self["card"..k].jobIcon.image.sprite = sprite
				end)

				if cardSlotIndex == 0 then
					self.uiBase:AddButtonUniqueEventListener(self["card"..k].btnChange.button, self, self.ChangeCard, k, slotType, cardSlotIndex, self.controller:GetData(), slot.card_id_list)
					self["card"..k].btnEquip.button.interactable = false
					self["card"..k].btnChange.button.interactable = true
				else
					self.uiBase:AddButtonUniqueEventListener(self["card"..k].btnEquip.button, self, self.InsertCard, k, slotType, cardSlotIndex, self.controller:GetData())
					self["card"..k].btnChange.button.interactable = false
					self["card"..k].btnEquip.button.interactable = true
				end
			end
		end
	end
end

function UICardEquipListView:CardRecommend(oldCardId, newCardId)
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

function UICardEquipListView:InsertCard(button, params)
	local slotIndex = params[0]
	local slotType = params[1]
	local cardSlotIndex = params[2]
	local cfgId = params[3]

	self.controller:SendInsertCard(slotIndex, slotType, cardSlotIndex, cfgId)

	ManagerContainer.RedPointMgr.HeroRPCtr:RefreshRoleCardSlotRP(slotIndex)
end

function UICardEquipListView:ChangeCard(button, params)
	local slotIndex = params[0]
	local slotType = params[1]
	local cardSlotIndex = params[2]
	local cfgId = params[3]
	local cardList = params[4]

	self.controller:SetSlotIndex(slotIndex)

	local data = {cardList = cardList, slotType = slotType, idx = cardSlotIndex, cfgId = cfgId, slotIndex = slotIndex, cardSlotIndex = cardSlotIndex}
	self:UIHide()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBagCardListTips, data)
end

function UICardEquipListView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UICardEquipListView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, function ()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.btnClose.button, function ()
		self:UIClose()
	end)
end

function UICardEquipListView:OnHide()

end

function UICardEquipListView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UICardEquipListView:OnClose()

end

function UICardEquipListView:OnDispose()

end

--强制引导
function UICardEquipListView:BagCardInsert(owner, ownerCB)
	local target
	local cardData = ManagerContainer.CfgMgr:GetCardDataById(self.controller:GetData())
	local slotType = cardData.CardLocation
	local slotsRoot = ManagerContainer.DataMgr.UserData:GetAllSlotInfos()
	for k,v in pairs(slotsRoot) do
		if #v.slot_list > 0 then
			local slot = v.slot_list[slotType]
			if slot.equip_id > 0 then
				local name = ""
				if k == 1 then
					name = ManagerContainer.DataMgr.UserData:GetUserNickname()
				else
					local heroData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(v.hero_id)
					local heroCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(heroData.configId)
					name = heroCfgData.Name
				end

				local data = {cfgId = slot.equip_id, slotType = slotType, card_list = slot.card_id_list, belongName = name}
				local cardSlotIndex = CardEquipItemCtr:SetData(self, self["card"..k], data)

				if cardSlotIndex == 0 then
					target = self["card"..k].btnChange
				else
					target = self["card"..k].btnEquip
				end
				if target then
					break
				end
			end
		end
	end

	if target == nil then
		if owner and ownerCB then
			ownerCB(owner)
			return
		end
	end

	if owner and ownerCB then
		ownerCB(owner, target)
		return
	end
end

return UICardEquipListView

