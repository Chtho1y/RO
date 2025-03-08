local UIPetRootView = require("UIPet/UIPetRootView_Generate")
local PetMatsGridView = require("UIPet/PetMatsGridView")
local RectOffset = UnityEngine.RectOffset
local IconPetItemCtr = require("Common/IconPetItemCtr")

local PetRootPage = {
	Pet = 1,
	Qiyue = 2,
}
local pageToggleData = {}
local petMatsGridView

local sameNatureTypeAdd = 0
local qiyueFuncIsUnlock = true

function UIPetRootView:OnAwake(data)
	self.controller = require("UIPet/UIPetRootCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetRootView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FILTER_NTF, self, self.RefreshCardDatasByFilter)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.QIYUE_PET_CHANGE_SUCCESS, self, self.RefreshSlotChangeNtf)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.QIYUE_TOGGLE_JUMP_TRIGGER, self, self.QiyueToggleJump)
end

function UIPetRootView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPetRootView:Init()
	ManagerContainer.RedPointMgr.PetRPCtr:RefreshTotalQiyueRPState()
	sameNatureTypeAdd = GlobalConfig.Instance:GetConfigIntValue(351)* 0.01

	if not petMatsGridView then
		petMatsGridView = PetMatsGridView:new()
		petMatsGridView:Init(Enum.ItemIEnterType.PetRoot, self, self.petScrollView.loopGridView)
	end

	self.contractScrollView.loopListView:InitListView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)

	self.contractScrollView.loopListView:SetListItemCount(6, true)
end

function UIPetRootView:RefreshCardDatasByFilter(uiId, data, isFilter)
	if uiId ~= self.uiData.id then return end

	self.controller:SetFilterData(data, isFilter)
	self:OnValueChangedToggle()
end

function UIPetRootView:OnValueChangedToggle()
	self.petScrollView:SetActive(pageToggleData.toggleDefaultIndex == PetRootPage.Pet)
	self.contract:SetActive(pageToggleData.toggleDefaultIndex == PetRootPage.Qiyue)
	self.btnFilter:SetActive(pageToggleData.toggleDefaultIndex == PetRootPage.Pet)

	self.btnDecompose:SetActive(pageToggleData.toggleDefaultIndex == PetRootPage.Pet)
	self.btnBattle:SetActive(pageToggleData.toggleDefaultIndex == PetRootPage.Pet)
	self.btnStamp:SetActive(pageToggleData.toggleDefaultIndex == PetRootPage.Pet)

	self.contractInfo:SetActive(pageToggleData.toggleDefaultIndex == PetRootPage.Qiyue)

	if pageToggleData.toggleDefaultIndex == PetRootPage.Pet then
		if petMatsGridView then
			petMatsGridView:Refresh(true)
		end

		self.btnFilter.check:SetActive(self.controller:GetIsFilter())
	elseif pageToggleData.toggleDefaultIndex == PetRootPage.Qiyue then
		self.controller:RefreshQiyueDatas()

		local loopGridView = self.contractScrollView.loopListView
		local realLength = self.controller:GetShowDataRealLength()
		--loopGridView:SetListItemCount(realLength, true)
		loopGridView:RefreshAllShownItem()
	end
end

function UIPetRootView:RefreshSlotChangeNtf()
	self.controller:HasEnoughPet()

	if ManagerContainer.DataMgr.PetDataMgr:IsQiyueSuccess() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("PetContractState5")
	end

	self:OnValueChangedToggle()
end

function UIPetRootView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local length = self.controller:GetShowDataRealLength()
	if (itemIndex < 0 or itemIndex >= length) then
		return nil
	end
	local heroData = self.controller:GetShowData(itemIndex)
	local item = nil
	if heroData then
		local unlockCount = self.controller:GetPetBattleUnlockCount()

		item = gridView:NewListViewItem("PetContractItem")
		item.gameObject.name = itemIndex
		local itemlua = CommonUtil.BindGridViewItem2Lua(self, "PetContractItem", item.gameObject)
		
		--pet qiyue detail show
		local jobIcon
		if heroData.id == 1 then
			local jobData = ManagerContainer.CfgMgr:GetJobDataById(heroData.configId)
			jobIcon = jobData.JobIcon
		else
			local heroCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(heroData.configId)
			jobIcon = heroCfgData.JobIcon
		end

		CommonUtil.LoadIcon(self, jobIcon, function (sprite)
			itemlua.jobIcon.image.sprite = sprite
		end, itemlua, "jobIcon")

		local name
		if heroData.id == 1 then
			local nickName = ManagerContainer.DataMgr.UserData:GetUserNickname()
			local cfgData = ManagerContainer.CfgMgr:GetJobDataById(heroData.configId)
			if nickName == nil then
				name = CommonUtil.GetHeroJobAndNameByUid(heroData.id, heroData.configId) 
			else
				if cfgData == nil then
					name = nickName
				else
					name = I18N.T(cfgData.JobName) .. nickName
				end
			end
		else
			name = CommonUtil.GetHeroJobAndNameByUid(heroData.id, heroData.configId) 
		end
		itemlua.heroName.text.text = name

		local petId = heroData.battlePetId
		local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(petId)
		local slotList = heroData.petQiyueData.slotList

		local hasBattlePet = unlockCount >= (itemIndex + 1) and petId > 0
		itemlua.iconPetItem:SetActive(hasBattlePet)
		itemlua.petLock:SetActive(unlockCount < (itemIndex + 1))
		if hasBattlePet and petData then
            IconPetItemCtr:SetData(self,itemlua.iconPetItem, petData, Enum.ItemIEnterType.Bag)

			local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
			local natureId = petCfgData.NatureType
			local natureCfgData = ManagerContainer.CfgMgr:GetNatureDataById(natureId)
			local icon = natureCfgData.Icon
			CommonUtil.LoadIcon(self, icon, function (sprite)
				itemlua.extraBox.petQty.nature.image.sprite = sprite
			end, itemlua, "natureIcon")
		else
			CommonUtil.LoadIcon(self, Constant.Natural_Unknow_Icon, function (sprite)
				itemlua.extraBox.petQty.nature.image.sprite = sprite
			end, itemlua, "natureIcon")
		end
		local state = #slotList

		local noticed = false
		if not qiyueFuncIsUnlock then
			noticed = true
			itemlua.noticeText.uILocalizeScript:SetContent("")
		else
			if heroData.id > 1 and not heroData.owned then
				noticed = true
				itemlua.noticeText.uILocalizeScript:SetContent("PetContractState4")
			elseif unlockCount <= itemIndex then
				noticed = true
				itemlua.noticeText.uILocalizeScript:SetContent("PetContractState3")
			elseif petId == 0 then
				noticed = true
				itemlua.noticeText.uILocalizeScript:SetContent("PetContractState7")
			end
		end

		local count = 0
		local extAddPer = 0
		local natureType = petData and petData.natureType or 0
		if state > 0 and (heroData.id == 1 or heroData.owned) and unlockCount > 0 then
			local hasQiyuePet = false
			if petId > 0 then
				noticed = false
			end
			local costState, idx = self.controller:CalcUnlockSlot(slotList)
			for i = 1, 4 do
				local data = slotList[i]
				local slotItem = itemlua.contractBox["slot"..i]
				if slotItem then
					slotItem.btnLock:SetActive(data == nil)
					slotItem.iconPetItem:SetActive(data and data.petId > 0)
					local attrItem = itemlua.activatedBox["attrItem"..i]
					attrItem:SetActive(data and data.petId > 0)
					if data then
						if data.petId > 0 then
							hasQiyuePet = true
							local addPetData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(data.petId)
							if addPetData then
								if addPetData.natureType == natureType then
									count = count + 1
								end
								local addPetCfgData = ManagerContainer.CfgMgr:GetPetDataById(addPetData.cfgId)
								local totalAdd = 0
								if addPetCfgData then
									totalAdd = addPetCfgData.contract * 0.01 + (addPetData.natureType == natureType and sameNatureTypeAdd or 0) + addPetData.totalSkillUpCount * addPetCfgData.understand * 0.01
								end
								
								if attrItem then
									attrItem.text.uILocalizeScript:SetContent(addPetCfgData.Name)
									attrItem.number.text.text = totalAdd.."%"
								end
							end
							IconPetItemCtr:SetData(self,slotItem.iconPetItem, addPetData, Enum.ItemIEnterType.Bag)
						end
						slotItem.uIRedPointRP:SetActive(petId > 0 and self.controller:CanFreeQiyuePet() and data.petId == 0)
					else
						slotItem.uIRedPointRP:SetActive(costState and i == idx)
					end
					--slotItem.btnAdd.button.enabled = petId > 0
					self.uiBase:AddButtonUniqueEventListener(slotItem.btnAdd.button, self, self.OnSlotClick, itemIndex, heroData.id, i, data and data.petId or 0, petId)
					self.uiBase:AddButtonUniqueEventListener(slotItem.btnLock.button, self, self.OnSlotLockClick, itemIndex, heroData.id, idx)
				end
			end

			if not noticed and not hasQiyuePet then
				noticed = true
				itemlua.noticeText.uILocalizeScript:SetContent("PetContractState1")
			end
		else
			if not noticed and state == 0 then
				noticed = true
				itemlua.noticeText.uILocalizeScript:SetContent("PetContractState2")
			end

			local rpState = false
			for i = 1, 4 do
				local slotItem = itemlua.contractBox["slot"..i]
				local data = slotList[i]
				if slotItem then
					local costState = self.controller:CalcUnlockSlot(slotList)
					if not data and not rpState and costState and (heroData.id == 1 or heroData.owned) then
						rpState = true
						slotItem.uIRedPointRP:SetActive(true)
					else
						slotItem.uIRedPointRP:SetActive(false)
					end
					
					slotItem.btnLock:SetActive(true)
					slotItem.iconPetItem:SetActive(false)

					self.uiBase:AddButtonUniqueEventListener(slotItem.btnLock.button, self, self.OnSlotLockClick, itemIndex, heroData.id, 1)
				end
			end
		end
		
		itemlua.noticeBox:SetActive(state == 0 or noticed)
		itemlua.activatedBox:SetActive(state > 0 and not noticed)
		itemlua.btnRemoveAll:SetActive(state > 0 and not noticed)
		
		itemlua.extraBox.petQty.number.text.text = count .. "/4"
		itemlua.extraBox.petExtra.number.text.text = (count * sameNatureTypeAdd).."%"

		self.uiBase:AddButtonUniqueEventListener(itemlua.btnRemoveAll.button, self, self.OnRemoveAllClick, itemIndex, heroData.id)
	end
	return item
end

function UIPetRootView:OnSlotClick(button, params)
	self.curSelectedItemIdx = params[0]
	local heroId = params[1]
	local idx = params[2]
	local petId = params[3]
	local qiyuPetId = params[4]
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetContractTips, {heroId, idx, petId, qiyuPetId})
end

function UIPetRootView:OnSlotLockClick(button, params)
	self.curSelectedItemIdx = params[0]
	local heroId = params[1]
	local idx = params[2]

	local heroData = CommonUtil.GetHeroLogicDataByUid(heroId)
	local state,_,costId, count, cost = self.controller:CalcUnlockSlot(heroData.petQiyueData.slotList)

	if not state then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("PetContractUnlockTips")
		return
	end
	if not costId then return end

	local data = {"PetQiyueUnlock", {cost}, {heroId}, self, self.UnlockClickSure, nil, nil, {costId, count, cost}}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
end

function UIPetRootView:OnRemoveAllClick(button, params)
	self.curSelectedItemIdx = params[0]
	local heroId = params[1]
	local data = {"PetQiyueRemoveAll", nil, {heroId}, self, self.OnRemoveAllSure}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
end

function UIPetRootView:OnItemClick(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetLvUp, data.id, self.uiData.id)
end

function UIPetRootView:UnlockClickSure(params)
	local heroId = params[1]
	self.controller:SendQiyueUnlockReq(heroId)
end

function UIPetRootView:OnRemoveAllSure(params)
	local heroId = params[1]
	self.controller:HeroRemoveAllQiyueSlot(heroId)
end

function UIPetRootView:OnItemClick(button, params)
	local data = params[0]

	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetLvUp, data.id, self.uiData.id)
end

function UIPetRootView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPetRootView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnFilter.button, self, self.OnFilterClick)
	self.uiBase:AddButtonEventListener(self.btnDecompose.button, self, self.OnDecomposeClick)
	self.uiBase:AddButtonEventListener(self.btnBattle.button, self, self.OnBattleClick)
	self.uiBase:AddButtonEventListener(self.btnStamp.button, self, self.OnStampClick)
	self.uiBase:AddButtonEventListener(self.btnContractAttr.button, self, self.OnContractClick)
	self.uiBase:AddButtonEventListener(self.btnInfo.button, self, self.OnClickPlayRuleBtn)

	CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.toggleGroup, 1, self.OnValueChangedToggle)
end

function UIPetRootView:OnFilterClick()
	local data = {uiId = self.uiData.id, enter = Enum.ItemIEnterType.Pet, filterData = self.controller:GetFilterData()}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFilter, data)
end

function UIPetRootView:OnContractClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetContractAttribute)
end

function UIPetRootView:OnDecomposeClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetDecompose, 1 , self.uiData.id)
end

function UIPetRootView:OnStampClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetStamp, nil , self.uiData.id)
end

function UIPetRootView:OnBattleClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetBattle, nil , self.uiData.id)
end

function UIPetRootView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'PetContractText'})
end

function UIPetRootView:QiyueToggleJump()
	self.toggleContract.toggle.isOn = true
end

function UIPetRootView:GetFirstPetQiyueSlot()
	local loopListView = self.contractScrollView.loopListView
	local item = loopListView:GetShownItemByItemIndex(0)
	if not item then
		return
	end
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, "PetContractItem", item.gameObject)
	if not itemlua then
		return
	end
	return itemlua
end

function UIPetRootView:PetContractToggleGuide(param, owner, ownerCB)
	local itemlua = self:GetFirstPetQiyueSlot()
	if not itemlua or not itemlua.gameObject then
		if owner and ownerCB then
			ownerCB(owner)
		end
		return
	end

	if owner and ownerCB then
		ownerCB(owner, itemlua.contractBox.slot1.btnLock)
	end
end

function UIPetRootView:OnHide()
	if petMatsGridView then
		petMatsGridView:OnHide()
	end
end

function UIPetRootView:OnShow(data)
	self.controller:SetData(data)
	ManagerContainer.RedPointMgr.PetRPCtr:RefreshTotalQiyueRPState()
	self:OnValueChangedToggle()
end

function UIPetRootView:OnClose()
	self.contractScrollView.loopListView:Dispose()
	pageToggleData = nil
end

function UIPetRootView:OnDispose()
	if petMatsGridView then
		petMatsGridView:OnDispose()
		petMatsGridView = nil
	end
	self.controller:OnDispose()
	self.defaultRectOffset = nil
end

return UIPetRootView

