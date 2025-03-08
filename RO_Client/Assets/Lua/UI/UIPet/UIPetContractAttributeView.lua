local UIPetContractAttributeView = require("UIPet/UIPetContractAttributeView_Generate")
local IconPetItemCtr = require("Common/IconPetItemCtr")

local pageToggleData = {}
local baseAttrs = {}
local addAttrs = {}
function UIPetContractAttributeView:OnAwake(data)
	self.controller = require("UIPet/UIPetContractAttributeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetContractAttributeView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.QUERY_PET_QIYUE_ATTRS_SUCCESS, self, self.OnQueryQiyueBattlePetAttrs)
end

function UIPetContractAttributeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPetContractAttributeView:Init()
	self.controller:QueryPetDetailInfo()
	self:ClearTop()
end

function UIPetContractAttributeView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	
	--CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.toggleGroup, 1, self.OnValueChangedToggle)
end

function UIPetContractAttributeView:ClearTop()
	local unlockCount = self.controller:GetUnlockCount()
	for i = 1, 4 do
		local toggleItem = self["toggle"..i]
		toggleItem.petLock:SetActive(unlockCount < i)
		toggleItem.iconPetItem:SetActive(false)
		toggleItem.toggle.interactable = false
	end
end

function UIPetContractAttributeView:RefreshTop()
	local unlockCount = self.controller:GetUnlockCount()
	for i = 1, 4 do
		local battlePetData = self.controller:GetBattlePetDataByIdx(i)
		local toggleItem = self["toggle"..i]
		toggleItem.petLock:SetActive(unlockCount < i)
		toggleItem.iconPetItem:SetActive(unlockCount >= i and battlePetData ~= nil)
		toggleItem.toggle.interactable = unlockCount >= i
		if unlockCount >= i and battlePetData ~= nil then
			IconPetItemCtr:SetData(self,toggleItem.iconPetItem, battlePetData, Enum.ItemIEnterType.Pet)
		end
	end
end

function UIPetContractAttributeView:OnQueryQiyueBattlePetAttrs()
	self.controller:RefreshQiyueAttrs()
	self:RefreshTop()
	CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.toggleGroup, 1, self.OnValueChangedToggle)
end

function UIPetContractAttributeView:OnValueChangedToggle()
	if pageToggleData.toggleDefaultIndex == 1 then
		self:RefreshTotalQiyueAttrs()
	else
		self:RefreshTBattlePetQiyueAttrs()
	end
end

function UIPetContractAttributeView:RefreshTotalQiyueAttrs()
	self.noContract:SetActive(false)
	self.scrollView:SetActive(true)
	local baseAttrs, addAttrs = self.controller:GetTotalQiyueAttrs()
	self:RefreshBottomAttrs(baseAttrs, addAttrs)
end

function UIPetContractAttributeView:RefreshTBattlePetQiyueAttrs()
	local idx = pageToggleData.toggleDefaultIndex - 1
	local hasQiyue = self.controller:IsPetHaveQiyueByIdx(idx)
	self.noContract:SetActive(not hasQiyue)
	self.scrollView:SetActive(hasQiyue)
	if hasQiyue then
		local baseAttrs, addAttrs = self.controller:GetPetQiyueAttrsByIdx(idx)
		self:RefreshBottomAttrs(baseAttrs, addAttrs)
	end
end

function UIPetContractAttributeView:RefreshBottomAttrs(baseAttrs, addAttrs)
	CommonUtil.LoopGridViewEleCreate(self, self.baseSView.loopVerticalScrollRect, self.baseSView.content.gridLayoutGroup, baseAttrs, 0, function (itemLua, idx)
		CommonUtil.UpdateItemPrefab(self, itemLua, baseAttrs[idx + 1])
	end)

	CommonUtil.LoopGridViewEleCreate(self, self.addSView.loopVerticalScrollRect, self.addSView.content.gridLayoutGroup, addAttrs, 0, function (itemLua, idx)
		CommonUtil.UpdateItemPrefab(self, itemLua, addAttrs[idx + 1])
	end)

	self.addSView:SetActive(#addAttrs > 0)
	self.none:SetActive(#addAttrs == 0)
end

function UIPetContractAttributeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIPetContractAttributeView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)

end

function UIPetContractAttributeView:OnCloseClick()
	self:UIClose()
end

function UIPetContractAttributeView:OnHide()

end

function UIPetContractAttributeView:OnShow(data)
	self.controller:SetData(data)

end

function UIPetContractAttributeView:OnClose()
end

function UIPetContractAttributeView:OnDispose()
	self.controller:OnDispose()
end

return UIPetContractAttributeView

