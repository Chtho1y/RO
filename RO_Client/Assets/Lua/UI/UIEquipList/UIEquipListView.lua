local UIEquipListView = require("UIEquipList/UIEquipListView_Generate")
local EquipListItemCtr = require("Common/EquipListItemCtr")
local IconItemCtr = require("Common/IconItemCtr")

function UIEquipListView:OnAwake(data)
	self.controller = require("UIEquipList/UIEquipListCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIEquipListView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
end

function UIEquipListView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIEquipListView:RefreshEquipTips(button, params)
	--local data = self.controller:GetData()
	--local data1 = {params[0], data[2], false}
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIEquipTips, data1)
	local data = params[0]
	data.state = Bit.bor(Bit.lshift(1, Enum.TipsEnterType.BaseAttr)) --CommonUtil.Get2Powers(Enum.TipsEnterType.BaseAttr)
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIEquipListView:Init()
	self.equipListEquippedItem:SetActive(false)
	self.equipBlank:SetActive(false)
end

function UIEquipListView:Refresh()
	local enterType = self.controller:GetEnterType()
	if enterType == Enum.ItemIEnterType.HeroEquip then
		self:RefreshHeroEquip()
	elseif enterType == Enum.ItemIEnterType.SkillEquip then
		self:RefreshSkillEquip()
	end
end

function UIEquipListView:OnPageInEnd()
	self.super.OnPageInEnd(self)

	self:Refresh()
end

function UIEquipListView:RefreshHeroEquip()
	local cfgId = self.controller:GetCfgId()
	--self.topItem:SetActive(cfgId > 0)

	local owner = self.controller:GetCallBackOwner()
	local cb = owner ~= nil and owner.RefreshEquipTips or nil

	local slotType = self.controller:GetSlotType()
	local equipDatas = ManagerContainer.DataMgr.EquipData:GetAllEquipDatasByType(slotType)

	self.equipListEquippedItem:SetActive(cfgId > 0)
	self.equipBlank:SetActive(cfgId == 0)

	if cfgId > 0 then
		self.topItem.grid:SetActive(true)
		self.itemDsc:SetActive(false)

		local cfgData = ManagerContainer.CfgMgr:GetEquipById(cfgId)
		self.topItem.textName.uILocalizeScript:SetContent(cfgData.Name)

		--local equipedData = ManagerContainer.CfgMgr:GetEquipById(cfgId)
		local data = {cfgId = cfgId}
		IconItemCtr:SetData(self, self.iconItem, data, Enum.ItemIEnterType.HeroEquip)

		local baseAttrs = {}
		for k,v in pairs(Enum.HeroAttrType) do
			if cfgData[k] and cfgData[k] ~= 0 then
				table.insert(baseAttrs, {Enum.HeroAttrType[k], cfgData[k]})
			end
		end
		for k, v in pairs(baseAttrs) do
			ManagerContainer.GoPoolMgr:SpawnGoNewLua(self.equipBaseAttrItem, function (itemlua)
				CommonUtil.BatchCreateItems(self, itemlua, self.topItem.grid.transform, v)
			end)
		end

		self.uiBase:AddButtonUniqueEventListener(self.btnDown.button, self.controller:GetCallBackOwner(), self.controller:GetCallBack1(), self.controller:GetSlotType(), cfgId)
		self.btnDown:SetActive(true)
		self.btnChange:SetActive(false)
	end

	if slotType == Enum.SlotEquipType.Weapon and equipDatas ~= nil then
		equipDatas = CommonUtil.ArrayFilterEquipWeapon(equipDatas, self.controller:GetJobType())
	end

	if equipDatas ~= nil then
		CommonUtil.LoopGridViewEleCreate(self, self.scrollView.loopVerticalScrollRect, self.content.verticalLayoutGroup, equipDatas, 0, function (itemLua, idx)
			local data = CommonUtil.TableClone(equipDatas[idx + 1])
			data.keepList = true
			data.needKeep = true
			data.noChange = false

			EquipListItemCtr:SetData(self, itemLua, data)
			self.uiBase:AddButtonUniqueEventListener(itemLua.btnChange.button, self.controller:GetCallBackOwner(), self.controller:GetCallBack(), self.controller:GetSlotType(), equipDatas[idx + 1].cfgId)
		end)
	end
end

function UIEquipListView:RefreshSkillEquip()
	local enterType = self.controller:GetEnterType()
	local cfgId = self.controller:GetCfgId()
	local logicData = self.controller:GetLogicData()

	self.equipListEquippedItem:SetActive(cfgId > 0)
	self.equipBlank:SetActive(cfgId == 0)

	if cfgId > 0 then
		self.topItem.grid:SetActive(false)
		self.itemDsc:SetActive(true)

		local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(cfgId)
		if cfgData then
			self.topItem.textName.uILocalizeScript:SetContent(cfgData.Name)
		end

		IconItemCtr:SetData(self, self.iconItem, logicData, Enum.ItemIEnterType.Bag)

		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
		if itemCfgData then
			self.itemDsc.text.text = I18N.T(itemCfgData.Describe)
		end

		self.uiBase:AddButtonUniqueEventListener(self.btnDown.button, self.controller:GetCallBackOwner(), self.controller:GetCallBack1())
		self.btnDown:SetActive(true)
		self.btnChange:SetActive(false)
	end

	local skillEquipDatas = self.controller:GetFilterSkillEquips()
	if skillEquipDatas ~= nil then
		CommonUtil.LoopGridViewEleCreate(self, self.scrollView.loopVerticalScrollRect, self.content.verticalLayoutGroup, skillEquipDatas, 0, function (itemLua, idx)
			local data = skillEquipDatas[idx + 1]
			EquipListItemCtr:SetData(self, itemLua, data, self, self.RefreshEquipTips, enterType)
			self.uiBase:AddButtonUniqueEventListener(itemLua.btnChange.button, self.controller:GetCallBackOwner(), self.controller:GetCallBack(), data.id)
		end)
	end
end

function UIEquipListView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIEquipListView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, function ()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, function ()
		self:UIClose()
	end)
end

function UIEquipListView:OnHide()
end

function UIEquipListView:OnShow(data)
	self.controller:SetData(data)
	self:Refresh()
end

function UIEquipListView:OnClose()
	self.scrollView.loopVerticalScrollRect:ClearCells()
end

function UIEquipListView:OnDispose()


end

return UIEquipListView

