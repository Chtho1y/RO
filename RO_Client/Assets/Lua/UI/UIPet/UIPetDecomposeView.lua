local UIPetDecomposeView = require("UIPet/UIPetDecomposeView_Generate")
local PetMatsGridView = require("UIPet/PetMatsGridView")
local IconItemCtr = require "Common/IconItemCtr"

local DecomposeType = {
	Pet = 1,
	SkillEquip = 2,
}

local petMatsGridView

local decomposeLimit = 15
local autoQualityLimit = 1

local oneKeyState = false

function UIPetDecomposeView:OnAwake(data)
	self.controller = require("UIPet/UIPetDecomposeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetDecomposeView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_DECOMPOSE_SUCCESS_NTF, self, self.OnDecomposeSuccessNTF)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FILTER_NTF, self, self.RefreshCardDatasByFilter)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VIP_LV_CHANGED, self, self.OnVipLvChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SKILL_EQUIP_DECOMPOSE_REFRESH, self, self.OnDecomposeSuccessNTF)
end

function UIPetDecomposeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPetDecomposeView:Init()
	decomposeLimit = GlobalConfig.Instance:GetConfigIntValue(227)
	autoQualityLimit = GlobalConfig.Instance:GetConfigIntValue(271)

	local type = self.controller:GetData()
	self.btnPetShop:SetActive(type == DecomposeType.Pet)
	self:RefreshUIText(type)

	if not petMatsGridView then
		petMatsGridView = PetMatsGridView:new()
	end

	if type == DecomposeType.Pet then
		local percent = self.controller:GetVipPercent()
		self.decomposeDsc.uILocalizeScript:SetContentAndValues("DscPetDecomposeAll", {percent * 100})
		if petMatsGridView then
			petMatsGridView:Init(Enum.ItemIEnterType.PetMats, self, self.scrollview.loopGridView)
		end
	else
		self.decomposeDsc.uILocalizeScript:SetContent("ArtifactSmeltTips")
		if petMatsGridView then
			petMatsGridView:Init(Enum.ItemIEnterType.SkillEquip, self, self.scrollview.loopGridView)
		end
	end

	-- self.returnUI.scrollView.loopListView:InitListView(0, function(gridView, itemIndex, row, column)
	-- 	return self:GetItemByIndex(gridView, itemIndex, row, column)
	-- end, nil)
	-- self:Refresh()
end

function UIPetDecomposeView:OnPageInEnd()
	self.super.OnPageInEnd(self)

	self:Refresh()
end

function UIPetDecomposeView:RefreshUIText(type)
	if type == DecomposeType.Pet then
		self.boardTitle.uILocalizeScript:SetContent("TitlePetDecompose")
		self.decompose.text.uILocalizeScript:SetContent("DscChooseAdvenceMet")
		self.btnDecompose.text.uILocalizeScript:SetContent("BtnDecompose")
		self.noticeTitle.uILocalizeScript:SetContent("TitlePetDecompose")
		self.btnSure.uILocalizeScript:SetContent("BtnDecompose")
		self.desTxt.uILocalizeScript:SetContent("DscNoPets")
	elseif type == DecomposeType.SkillEquip then
		self.boardTitle.uILocalizeScript:SetContent("ArtifactSmelTitle")
		self.decompose.text.uILocalizeScript:SetContent("ArtifactSmeltType")
		self.btnDecompose.text.uILocalizeScript:SetContent("ArtifactSmeltButton")
		self.noticeTitle.uILocalizeScript:SetContent("ArtifactSmelTitle")
		self.btnSure.uILocalizeScript:SetContent("ArtifactSmeltButton")
		self.desTxt.uILocalizeScript:SetContent("DscNoArtifact")
	end
end

function UIPetDecomposeView:RefreshCount()
	local type = self.controller:GetData()

	local count = self.controller:GetSelectedPetLength()
	local defaultCount = self.controller:GetDefaultCount()
	local autoSelectedCount = self.controller:GetAutoSelectedPetCount()
	self.number.text.text = count.."/"..decomposeLimit

	oneKeyState = defaultCount > 0 and count >= defaultCount
	self.btnOneKey.on:SetActive(oneKeyState)
	self.btnOneKey.off:SetActive(not oneKeyState)

	if type == DecomposeType.Pet then
		self.btnOneKey.text.uILocalizeScript:SetContent(oneKeyState and "TextAutoChoose_001" or "TextAutoChoose")
	elseif type == DecomposeType.SkillEquip then
		self.btnOneKey.text.uILocalizeScript:SetContent(oneKeyState and "TextAutoChoose_001" or "TextAutoChoose")
	end
end

function UIPetDecomposeView:OnDecomposeSuccessNTF()
	oneKeyState = false
	self.controller:OneKeyCancelSelectedPet()
	self.controller:ClearSelected()
	self:Refresh(true)
end

function UIPetDecomposeView:RefreshCardDatasByFilter(uiId, data, isFilter)
	if uiId ~= self.uiData.id then return end

	self.controller:SetFilterData(data, isFilter)
	self.controller:ClearSelected()
	self:Refresh()
end

function UIPetDecomposeView:OnVipLvChanged()
	self:RefreshReturnUI()
end

function UIPetDecomposeView:Refresh(resetPos)
	if petMatsGridView then
		petMatsGridView:Refresh(resetPos)
	end
	self:RefreshCount()
	self.btnFilter.check:SetActive(self.controller:GetIsFilter())
end

function UIPetDecomposeView:OnItemClick(button, params)
	local data = params[0]
	local itemlua = params[1]

	local isSelected, idx = self.controller:IsSelected(data.id)
	if not isSelected then
		local type = self.controller:GetData()
		if type == DecomposeType.Pet then
			if data.isBattle then
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petcompound_007")
				return
			end
	
			local selectedCount = self.controller:GetSelectedPetLength()
			if selectedCount >= decomposeLimit then
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petcompound_001")
				return
			end
	
			if data.isRelevant then
				local data = {"PetCostNotify7", nil, {data, itemlua}, self, self.ItemClickSure}
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
				return
			end
	
			if data.quality > autoQualityLimit then
				local data = {"PetCostNotify3", nil, {data, itemlua}, self, self.ItemClickSure}
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
				return
			end
			if self.controller:WasSkillUp(data) then
				local data = {"PetCostNotify2", nil, {data, itemlua}, self, self.ItemClickSure}
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
				return
			end
			if data.advanceLevel > 0 then
				local data = {"PetCostNotify5", nil, {data, itemlua}, self, self.ItemClickSure}
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
				return
			end
			if data.level > 1 then
				local data = {"PetCostNotify1", nil, {data, itemlua}, self, self.ItemClickSure}
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
				return
			end
		elseif type == DecomposeType.SkillEquip then
			-- if data.quality > autoQualityLimit then
			-- 	local data = {"SkillEquipDecomposeTip1", nil, {data, itemlua}, self, self.ItemClickSure}
			-- 	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			-- 	return
			-- end
			if data.starLv > 0 then
				local data = {"SkillEquipDecomposeTip2", nil, {data, itemlua}, self, self.ItemClickSure}
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
				return
			end
		end
		
		self:AddSelectedPet(data.id, itemlua)
	else
		self:RemoveSelectedPet(data.id, idx, itemlua)
	end
	self:RefreshCount()
end

function UIPetDecomposeView:ItemClickSure(params)
	local data = params[1]
	local itemlua = params[2]

	self:AddSelectedPet(data.id, itemlua)

	self:RefreshCount()
end

function UIPetDecomposeView:AddSelectedPet(id, itemlua)
	local result = self.controller:AddSelectedId(id)

	if result then
		itemlua.selected:SetActive(true)
	end
end

function UIPetDecomposeView:RemoveSelectedPet(id, idx, itemlua)
	self.controller:RemoveSeletedId(id)
	itemlua.selected:SetActive(false)
end

function UIPetDecomposeView:RefreshReturnUI()
	local data, percent = self.controller:DecomposeReturnCalc()

	local type = self.controller:GetData()
	if type == DecomposeType.Pet then
		self.dscTxt.uILocalizeScript:SetContentAndValues("DscPetDecomposeAll", {percent * 100})
	elseif type == DecomposeType.SkillEquip then
		self.dscTxt.uILocalizeScript:SetContent("ArtifactSmeltTips")
	end

	-- local loopListView = self.returnUI.scrollView.loopListView
	-- local length = self.controller:GetCurCostReturnLength()
	-- loopListView:SetListItemCount(length)
	-- loopListView:RefreshAllShownItem()

	for i = 1, self.returnUI.content.transform.childCount do
        self.returnUI.content.transform:GetChild(i - 1).gameObject:SetActive(false)
    end

    local idx = 0
    for _,v in pairs(data) do
        if v.num > 0 then
            idx = idx + 1
            local cfgId = v.cfgId
            local cfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
            local num = v.num
            local data1 = {cfgId = v.cfgId, num = num}
            CommonUtil.BatchCreateItemsLoopSpawnItem(self, cfgData.ResType, self.returnUI.content.transform, data1, idx, Enum.ItemIEnterType.Bag, self, self.OnRewardClick)
        end
    end

	self.returnUI:SetActive(true)
end

function UIPetDecomposeView:GetItemByIndex(loopListView, itemIndex)
	local data = self.controller:GetCostReturnByIdx(itemIndex)
	if not data then return end

	local item = loopListView:NewListViewItem('IconItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'IconItem', item.gameObject)
	if itemLua then
		IconItemCtr:SetData(self, itemLua, data, Enum.ItemIEnterType.Bag, self, self.OnRewardClick)
	end
	return item
end

function UIPetDecomposeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPetDecomposeView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnBack.button, self, self.OnCloseClick)

	self.uiBase:AddButtonEventListener(self.btnOneKey.button, self, self.OnOneKeyClick)

	self.uiBase:AddButtonEventListener(self.btnDecompose.button, self, self.OnDecomposeClick)
	self.uiBase:AddButtonEventListener(self.returnUI.btnRight.button, self, self.OnReturnSure)
	self.uiBase:AddButtonEventListener(self.returnUI.btnCancle.button, self, self.OnCloseReturn)
	self.uiBase:AddButtonEventListener(self.returnUI.btnClose.button, self, self.OnCloseReturn)
	self.uiBase:AddButtonEventListener(self.btnPlayRule.button, self, self.OnClickPlayRuleBtn)

	self.uiBase:AddButtonEventListener(self.btnFilter.button, self, self.OnFilterClick)
	self.uiBase:AddButtonUniqueEventListener(self.btnPetShop.button, self, self.OnClickPetShopBtn)
end

function UIPetDecomposeView:OnFilterClick()
	local data = {uiId = self.uiData.id, enter = Enum.ItemIEnterType.Pet, filterData = self.controller:GetFilterData()}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFilter, data)
end

function UIPetDecomposeView:OnCloseClick()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIPetDecomposeView:OnClickPlayRuleBtn()
	local type = self.controller:GetData()
	if type == DecomposeType.Pet then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'PetText002'})
	elseif type == DecomposeType.SkillEquip then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'ArtifactSmeltButtonTips'})
	end	
end

function UIPetDecomposeView:OnClickPetShopBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIShop, 5, self.uiData.id)
end

function UIPetDecomposeView:OnOneKeyClick()
	local type = self.controller:GetData()

	local selectedCount = self.controller:GetSelectedPetLength()
	local autoSelectedCount = self.controller:GetAutoSelectedPetCount()
	if selectedCount == 0 and autoSelectedCount == 0 then
		if type == DecomposeType.Pet then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petcompound_002")
		elseif type == DecomposeType.SkillEquip then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ArtifactSmeltButtonTips1")
		end
		return
	end
	if not oneKeyState then
		self.controller:OneKeySelectPet()
	else
		self.controller:OneKeyCancelSelectedPet()
	end
	--oneKeyState = not oneKeyState
	--self.btnOneKey.on:SetActive(oneKeyState)
	--self.btnOneKey.off:SetActive(not oneKeyState)
	self:Refresh(true)
end

function UIPetDecomposeView:OnDecomposeClick()
	local length = self.controller:GetSelectedPetLength()
	if length == 0 then
		return
	end
	self:RefreshReturnUI()
end

function UIPetDecomposeView:OnRewardClick(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIPetDecomposeView:OnReturnSure()
	self.controller:SendPetDecompose()
	self:OnCloseReturn()
end

function UIPetDecomposeView:OnCloseReturn()
	self.returnUI:SetActive(false)
end

function UIPetDecomposeView:OnHide()
	if petMatsGridView then
		petMatsGridView:OnHide()
	end
end

function UIPetDecomposeView:OnShow(data)
	self.controller:SetData(data)

end

function UIPetDecomposeView:OnClose()
	if petMatsGridView then
		petMatsGridView:OnDispose()
		petMatsGridView = nil
	end
end

function UIPetDecomposeView:OnDispose()
	self.controller:OnDispose()
end

return UIPetDecomposeView

