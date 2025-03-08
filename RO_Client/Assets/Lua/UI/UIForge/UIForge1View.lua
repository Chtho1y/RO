local UIForge1View = require("UIForge/UIForge1View_Generate")

local itemType, jobType
local isFirst = true

local equipDatas
local pageToggleData = {}

local frameTimer
local vec = Vector2(-710,0)
function UIForge1View:OnAwake(data)
	self.controller = require("UIForge/UIForge1Ctr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIForge1View:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EQUIP_FORGE_SUCCESS, function(type)
		--if type == 1 then
		--	self:Refresh(true)
		--else
		--	self:UIClose()
		--end

		self:Refresh(true)
	end)
end

function UIForge1View:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIForge1View:Init()
	self:InitGridView()
	--self:InitToggles()

	--self:InitEquips()
end

function UIForge1View:InitGridView()
	local loopGridViewInitParam = SuperScrollView.LoopGridViewInitParam.CopyDefaultInitParam()
	loopGridViewInitParam.mSnapVecThreshold = 9999

	self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:LoopGridUpdate(gridView, itemIndex, row, column)
	end, nil, nil, loopGridViewInitParam)

	local data = self.controller:GetData()
	local idx = data and data[1] or 1
	for k, v in pairs(Enum.EquipForgeType) do
		local item
		if self.toggleGroup.transform.childCount >= k then
			item = self.toggleGroup.transform:GetChild(k - 1)
		else
			local toggle = UnityEngine.GameObject.Instantiate(self.toggle)
			item = toggle.transform
			item:SetParent(self.toggleGroup.transform)
			item.localPosition = Vector3.zero
		end
		local txt = item:Find("Txt"):GetComponent(Enum.TypeInfo.UILocalizeScript)
		txt:SetContent(v[2])
		item.localScale = Vector3.one
		item.gameObject:SetActive(true)
		local toggle = item:GetComponent(Enum.TypeInfo.Toggle)
		if k == idx then
			toggle.isOn = true
		end

		self.uiBase:AddToggleEventListener(toggle, self, self.ChangeViewPage, k)
	end

	local groupRect =self.toggleGroup:GetComponent(Enum.TypeInfo.RectTransform)
	groupRect.anchoredPosition = data[1] < 6 and Vector2.zero or vec
	self:ChangeViewPage(nil, data[1])
	--CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.toggleGroup, 1, self.ChangeViewPage)
end

function UIForge1View:InitToggles()
	local data = self.controller:GetData()

	if data ~= nil then
		self.toggleScrollView.loopGridView:MovePanelToItemByIndex(data[1] - 1)
	else
		self.toggleScrollView.loopGridView:MovePanelToItemByIndex(0)
	end

	--self.toggleScrollView.loopGridView:RefreshAllShownItem()
end

function UIForge1View:LoopToggleGridUpdate(gridView, itemIndex, row, column)
	local data = self.controller:GetData()

	local item = gridView:NewListViewItem(self.toggle.name)
	local txt = item.transform:Find("Txt"):GetComponent(Enum.TypeInfo.UILocalizeScript)
	txt:SetContent(Enum.EquipForgeType[itemIndex + 1][2])
	local toggle = item:GetComponent(Enum.TypeInfo.Toggle)

	if pageToggleData.toggleDefaultIndex ~= itemIndex + 1 then
		toggle.isOn = false
	end
	return item
end

function UIForge1View:ChangeType(toggle, data, result)
	CommonUtil.CloseUIClearAsyncSeqIds(self)
	if result then
		self.controller:SetData(data)
		if isFirst then
			isFirst = false
			self:InitEquips()
		else
			self.scrollView.loopGridView:RecycleAllItem()
			CommonUtil.ClearGridViewItem(self, Enum.PrefabNames.EquipComposeItem)
			self:Refresh()
		end
	end
end

function UIForge1View:ChangeViewPage(toggle, idx)
	local data = Enum.EquipForgeType[idx]
	self.controller:SetData(data)
	if isFirst then
		isFirst = false
		self:InitEquips()
	else
		self.scrollView.loopGridView:RecycleAllItem()
		CommonUtil.ClearGridViewItem(self, Enum.PrefabNames.EquipComposeItem)
		self:Refresh()
	end
end

function UIForge1View:InitEquips()
	local data = self.controller:GetData()
	itemType = data[3]
	if itemType == Enum.SlotEquipType.Weapon then
		jobType = data[1]
	else
		jobType = nil
	end

	local ownedCoin = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.Coin)
	equipDatas = ManagerContainer.CfgMgr:GetAllEquipDatasByTypeAndJob1(itemType, jobType)

	local minIdx = 0
	for i = 1,#equipDatas do
		local equipCfgData1 = ManagerContainer.CfgMgr:GetEquipById(equipDatas[i].Id)
		local logicData = ManagerContainer.DataMgr.EquipData:GetEquipDataMapById(equipDatas[i].Id)
		local count = 0
		if logicData ~= nil then
			count = logicData.num
		end
		local canCompose = ownedCoin >= equipCfgData1.CostMoney and count >= 3

		if i < #equipDatas then
			if canCompose and minIdx == 0 then
				minIdx = i - 1
			end
		end
	end

	self.scrollView.loopGridView:SetListItemCount(#equipDatas, true)
	if minIdx > -1 then
		self.scrollView.loopGridView:MovePanelToItemByIndex(minIdx)
	end
end

function UIForge1View:Refresh(needRefresh)
	local data = self.controller:GetData()
	itemType = data[3]
	if itemType == Enum.SlotEquipType.Weapon then
		jobType = data[1]
	else
		jobType = nil
	end

	local ownedCoin = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.Coin)
	equipDatas = ManagerContainer.CfgMgr:GetAllEquipDatasByTypeAndJob1(itemType, jobType)

	local minIdx = 0
	for i = 1,#equipDatas do
		local equipCfgData1 = ManagerContainer.CfgMgr:GetEquipById(equipDatas[i].Id)
		local logicData = ManagerContainer.DataMgr.EquipData:GetEquipDataMapById(equipDatas[i].Id)
		local count = 0
		if logicData ~= nil then
			count = logicData.num
		end
		local canCompose = ownedCoin >= equipCfgData1.CostMoney and count >= 3

		if i < #equipDatas then
			if canCompose and minIdx == 0 then
				minIdx = i - 1
			end
		end
	end

	self.scrollView.loopGridView:SetListItemCount(#equipDatas)
	self.scrollView.loopGridView:FinishSnapImmediately()
	if minIdx > -1 then
		self.scrollView.loopGridView:MovePanelToItemByIndex(minIdx)
	end
	if needRefresh then
		self.scrollView.loopGridView:RefreshAllShownItem()
	end
end

function UIForge1View:LoopGridUpdate(gridView, itemIndex, row, column)

	local item = gridView:NewListViewItem(Enum.PrefabNames.EquipComposeItem)
	item.gameObject.name = itemIndex
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, Enum.PrefabNames.EquipComposeItem, item.gameObject)
	local logicData = ManagerContainer.DataMgr.EquipData:GetEquipDataMapById(equipDatas[itemIndex + 1].Id)
	local count = 0
	if logicData ~= nil then
		count = logicData.num
	end
	local data = {cfgId = equipDatas[itemIndex + 1].Id, num = count}
	CommonUtil.UpdateItemPrefab(self, itemLua, data, Enum.ItemIEnterType.EquipForge, self, self.OnEquipCompose)
	return item
end

function UIForge1View:OnEquipCompose(button, params)
	local logicData = params[0]
	self.controller:SendEquipForge(logicData.cfgId, logicData.curForgeCount)
end

function UIForge1View:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIForge1View:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	--CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.toggleGroup, 1, self.ChangeViewPage)

	self.uiBase:AddButtonEventListener(self.btnClose.button, function()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, function()
		self:UIHide()
	end)


	self.uiBase:AddButtonEventListener(self.btnOneKey.button, function()
		local list, totalCost, noMate, coinLack = ManagerContainer.DataMgr.EquipData:GetAllCanForgeEquipIds(itemType, jobType)
		if coinLack or coinLack == nil then
			CommonUtil.ItemNotEnoughHandle(Enum.ItemType.Coin)
			return
		end
		if noMate or noMate == nil then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(Enum.ActionNotiveType.MetaLack)
			return
		end
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIForgePop, {list, CommonUtil.FormatNumber(totalCost), itemType, jobType})
	end)
end

function UIForge1View:OnHide()

end

function UIForge1View:OnShow(data)
	--self.controller:SetData(data)
	--self:Init()
end

function UIForge1View:OnClose()

end

function UIForge1View:OnDispose()
	self.scrollView.loopGridView:Dispose()
end

return UIForge1View

