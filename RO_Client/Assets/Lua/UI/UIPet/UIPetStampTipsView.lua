local UIPetStampTipsView = require("UIPet/UIPetStampTipsView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

function UIPetStampTipsView:OnAwake(data)
	self.controller = require("UIPet/UIPetStampTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetStampTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIPetStampTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPetStampTipsView:Init()
	self:Refresh()
end

function UIPetStampTipsView:Refresh()
	local stampData = self.controller:GetStampData()
	if not stampData then return end

	local cfgData = ManagerContainer.CfgMgr:GetPetEquipCfgDataById(stampData.cfgId)
	if not cfgData then return end
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(stampData.cfgId)
	if not itemCfgData then return end

	local lvCfgData = ManagerContainer.CfgMgr:GetPetEquipExpCfgDataByLvAndCfgId(stampData.lv, stampData.cfgId)
	if not lvCfgData then return end

	IconItemCtr:SetData(self, self.iconItem, stampData, Enum.ItemIEnterType.PetStamp)
	self.textName.text.text = I18N.T(cfgData.Name)
	CommonUtil.LoadIcon(self, Constant.Pet_Stamp_Slot_Icons[cfgData.Type], function (sprite)
		self.type1.image.image.sprite = sprite
	end)

	local dcs = cfgData.Desc or itemCfgData.Describe
	self.desTxt.text.text = I18N.T(dcs)

	local baseAttrs = clone(lvCfgData.Nature)
	table.sort(baseAttrs, function (a,b)
		return a[1] < b[1]
	end)

	local idx = 0
	for i = 1, #baseAttrs do
		idx = idx + 1
		CommonUtil.BatchCreateItemsLoopWithMould(self, self.attrItem, self.baseAttr.grid.transform, baseAttrs[i], i, Enum.ItemIEnterType.Attr)
	end

	local isMaxLv = stampData.lv >= cfgData.MaxLevel
	local canAdvance = cfgData.Advance > 0

	self.bottomBox:SetActive(not isMaxLv or (isMaxLv and canAdvance))

	local petId = self.controller:GetPetId()
	local slotIdx = self.controller:GetSlotIdx()
	local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(petId)
	if petData and slotIdx then
		self.btnPetStampLvUp:SetActive(not isMaxLv)
		self.btnAdvance:SetActive(isMaxLv and canAdvance)
		if not isMaxLv then
			local lvUpRP = ManagerContainer.RedPointMgr.PetRPCtr:GetPetSlotLvUpRPState(petData.id, slotIdx)
			self.btnPetStampLvUp.uIRedPointRP:SetActive(lvUpRP)
		elseif isMaxLv and canAdvance then
			local advanceRP = ManagerContainer.RedPointMgr.PetRPCtr:GetPetSlotAdvanceRPState(petData.id, slotIdx)
			self.btnAdvance.uIRedPointRP:SetActive(advanceRP)
		end
	else
		self.btnPetStampLvUp.uIRedPointRP:SetActive(false)
		self.btnAdvance.uIRedPointRP:SetActive(false)
	end
end

function UIPetStampTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPetStampTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnChange.button, self, self.OnChangeClick)
	self.uiBase:AddButtonEventListener(self.btnPetStampLvUp.button, self, self.OnLvUpClick)
	self.uiBase:AddButtonEventListener(self.btnAdvance.button, self, self.OnLvUpClick)
end

function UIPetStampTipsView:OnCloseClick()
	self:UIClose()
end

function UIPetStampTipsView:OnChangeClick()
	self:UIClose()
	local stampData = self.controller:GetStampData()
	local data = {curStamp = stampData, type = stampData.type, slotIdx = self.controller:GetSlotIdx(), petId = self.controller:GetPetId()}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetStampList, data)
end

function UIPetStampTipsView:OnLvUpClick()
	self:UIClose()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIStampLvUp, self.controller:GetData())
end

function UIPetStampTipsView:OnHide()

end

function UIPetStampTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIPetStampTipsView:OnClose()
end

function UIPetStampTipsView:OnDispose()
	self.controller:OnDispose()
end

return UIPetStampTipsView

