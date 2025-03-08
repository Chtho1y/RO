local UIItemTipsView = require("UIItemTips/UIItemTipsView_Generate")

function UIItemTipsView:OnAwake(data)
	self.controller = require("UIItemTips/UIItemTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIItemTipsView:AddEventListener()
	self.uiBase:AddUIEventHandlerClickListener(self.uIEventHandler, function (go)
		if go and go.transform:IsChildOf(self.transform) then
			return
		end
		ManagerContainer.LuaUIMgr:Hide(self.uiData.id)
	end)
end

function UIItemTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIItemTipsView:Init()
	local isOpenFunc = self.controller:IsOpenFuncBtn()
	local cfgId = self.controller:GetCfgId()
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)

	-- 道具图标
	ManagerContainer.GoPoolMgr:SpawnItemGo(itemCfgData.ResType, function(itemlua)
		CommonUtil.BatchCreateItems(self, itemlua, self.contentItem.transform, self.controller:GetExtData() or self.controller.data, Enum.ItemIEnterType.ItemTips)
	end)

	-- 道具名称
	self.textName.text.text = itemCfgData.Name
	-- 道具类型
	self.textType.uILocalizeScript:SetContent("ItemTypeDes_" .. itemCfgData.ResType)

	-- 道具描述
	self.desTxt.text.text = itemCfgData.Describe

	if itemCfgData.ResType == Enum.ItemType.Equip then
		-- 装备基本属性
		local equipCfgData = ManagerContainer.CfgMgr:GetEquipById(cfgId)
		local baseAttrs = {}
		for k,v in pairs(Enum.HeroAttrType) do
			if equipCfgData[k] and equipCfgData[k] ~= 0 then
				table.insert(baseAttrs, {Enum.HeroAttrType[k], equipCfgData[k]})
			end
		end

		for _,v in pairs(baseAttrs) do
			ManagerContainer.GoPoolMgr:SpawnGo(Enum.PrefabNames.EquipBaseAttrItem, function(itemlua)
				CommonUtil.BatchCreateItems(self, itemlua, self.equipBox.base.grid.transform, v)
			end)
		end

		self.equipBox.suit:SetActive(equipCfgData.Suit > 0)
		-- 装备套装属性
		if equipCfgData.Suit > 0 then
			-- 装备套装属性
			local equipSuitCfgData = ManagerContainer.CfgMgr:GetEquipSuitById(equipCfgData.Suit)
			self.suitTxt.text.text = equipSuitCfgData.Name
			self.suitActiveTxt.text.text = "(0/3)"
			local i = 1
			local keyName = ("Suit" .. i)
			local suitAttrs = {}
			while (equipSuitCfgData[keyName] ~= nil) do
				if equipSuitCfgData[keyName] ~= "" then
					table.insert(suitAttrs, {i, equipSuitCfgData[keyName], false, i})
				end
				i = i + 1
				keyName = ("Suit" .. i)
			end
			for _,v in pairs(suitAttrs) do
				ManagerContainer.GoPoolMgr:SpawnGo(Enum.PrefabNames.EquipSuitAttrItem, function(itemlua)
					CommonUtil.BatchCreateItems(self, itemlua, self.equipBox.suit.transform, v)
				end)
			end
		end
		if isOpenFunc then
			self.uiBase:AddButtonUniqueEventListener(self.btn_Equip.button, self, function()
				ManagerContainer.LuaUIMgr:Hide(self.uiData.id)
				ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Role)
			end)

			self.uiBase:AddButtonUniqueEventListener(self.btn_Compose.button, self, function ()
				self:UIClose()
				local forgeType = CommonUtil.GetEquipForgeTypeByCfgId(cfgId)
				local data
				if forgeType ~= nil then
					data = Enum.EquipForgeType[forgeType]
				end
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIForge1, data)
			end)
		end
		self.btn_Sell:SetActive(false)
		self.btn_Equip:SetActive(false)
		self.btn_Info:SetActive(false)
		self.btn_Decompose:SetActive(false)
		self.equipBox:SetActive(true)
		self.btnBox:SetActive(isOpenFunc)
        self.bottomBox:SetActive(not isOpenFunc)
		self.btn_Compose:SetActive(isOpenFunc)
	elseif itemCfgData.ResType == Enum.ItemType.ParterChip then
		local composeItem = itemCfgData.ComposeItem
		local multi = false
		local owned = false
		local parterId = nil
		if composeItem and #composeItem > 0 then
			if type(composeItem[1]) == 'number' then
				-- 单个
				parterId = composeItem[1]
				local data = ManagerContainer.DataMgr.PartnerData:GetPartnerDataById(parterId)
				owned = ((data and data.owned) and data.owned or false)
			else
				multi = true
			end
		end
		if isOpenFunc then
			self.btn_Decompose.text.text.text = (owned and '分解' or '合成')
			if not multi then
				self.uiBase:AddButtonUniqueEventListener(self.btn_Info.button, self, function()
					ManagerContainer.LuaUIMgr:Hide(self.uiData.id)
					local partnerData = ManagerContainer.CfgMgr:GetPartnerDataById(parterId)
					ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Role, partnerData)
				end)
			end
			self.uiBase:AddButtonUniqueEventListener(self.btn_Decompose.button, self, function()
				ManagerContainer.LuaUIMgr:Hide(self.uiData.id)
				if owned then
					ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChipRoom, {self.controller:GetCfgId()})
				else
					self.controller:SendComposeChip()
				end
			end)
		end
		self.btn_Sell:SetActive(false)
		self.btn_Equip:SetActive(false)
		if not multi then self.btn_Info:SetActive(isOpenFunc) end
		self.btn_Decompose:SetActive(isOpenFunc)
		self.equipBox:SetActive(false)
		self.btnBox:SetActive(isOpenFunc)
        self.bottomBox:SetActive(not isOpenFunc)
		self.btn_Compose:SetActive(false)
	else
		self.btn_Sell:SetActive(false)
		self.btn_Equip:SetActive(false)
		self.btn_Info:SetActive(false)
		self.btn_Decompose:SetActive(false)
		self.equipBox:SetActive(false)
		self.btnBox:SetActive(false)
        self.bottomBox:SetActive(true)
		self.btn_Compose:SetActive(false)
	end
end

function UIItemTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIItemTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, function()
		ManagerContainer.LuaUIMgr:Hide(self.uiData.id)
	end)
end

function UIItemTipsView:OnHide()
	self.hideFrameCount = Time.frameCount
end

function UIItemTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
	if self.hideFrameCount and self.hideFrameCount < Time.frameCount then
		self.window.animator:Rebind()
	end
end

function UIItemTipsView:OnClose()
end

function UIItemTipsView:OnDispose()


	self.uIEventHandler:RemoveListener()
end

return UIItemTipsView

