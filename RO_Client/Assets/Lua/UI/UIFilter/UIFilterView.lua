local UIFilterView = require("UIFilter/UIFilterView_Generate")
local MultiTypeAssetLoadSystem = require("MultiTypeAssetLoadSystem")

local togglePath = "UIFilter/toggle"
local RarityNames =
{
	string.format(Constant.BlueColorText, "Normal"),
	string.format(Constant.PurpleColorText, "Mini"),
	string.format(Constant.GoldenColorText, "Mvp"),
}

function UIFilterView:OnAwake(data)
	self.controller = require("UIFilter/UIFilterCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIFilterView:AddEventListener()

end

function UIFilterView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIFilterView:Init()
	local val = GlobalConfig.Instance:GetConfigStrValue(185)
	self.rarities = CommonUtil.DeserializeGlobalStrToTable(val)

	local val = GlobalConfig.Instance:GetConfigStrValue(186)
	self.attrs = CommonUtil.DeserializeGlobalStrToTable(val)

	local enter = self.controller:GetEnter()
	if enter == Enum.ItemIEnterType.Bag then
		-- self.textTitle.text.text = I18N.T("CardList")

		self.types = {}
		for i = 1, #Enum.EquipTypeName do
			self.types[#self.types + 1] = i
		end

		self.filter3Name.uILocalizeScript:SetContent("Position")
    elseif enter == Enum.ItemIEnterType.Pet then
        -- self.textTitle.text.text = I18N.T("PetList")

		local val = GlobalConfig.Instance:GetConfigStrValue(187)
		self.types = CommonUtil.DeserializeGlobalStrToTable(val)
		self.filter3Name.uILocalizeScript:SetContent("FilterElement")
	end

	local filterData = self.controller:GetFilterData()

	self:InitSelections(filterData)

	self.loadSystem = MultiTypeAssetLoadSystem:new()
	self.loadSystem:SetCompleteCB(self, self.PreloadedAssets)

	self:PreLoadToggle()
end

function UIFilterView:InitSelections(filterData)
	if #filterData.raritySelections == 0 and #filterData.attrSelections == 0 and #filterData.typeSelections == 0 then
		for k,v in pairs(self.rarities) do
			filterData.raritySelections[#filterData.raritySelections + 1] = tonumber(v)
		end

		for k,v in pairs(self.attrs) do
			filterData.attrSelections[#filterData.attrSelections + 1] = tonumber(v)
		end

		for k,v in pairs(self.types) do
			filterData.typeSelections[#filterData.typeSelections + 1] = tonumber(v)
		end
	end
end

function UIFilterView:PreLoadToggle()
	self.loadSystem:RemoveLoadAllAsset()

	self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.UIPath, togglePath)
	self.loadSystem:Begin()
end

function UIFilterView:PreloadedAssets()
	local filterData = self.controller:GetFilterData()
	self:InitRarityToggles(filterData.raritySelections)
	self:InitAttrsToggles(filterData.attrSelections)
	self:InitTypesToggles(filterData.typeSelections)

	self:RaritySelectionsChanged()
	self:AttrSelectionsChanged()
	self:TypeSelectionsChanged()
end

local function AllSelectionState(selections, list)
	for _,v in pairs(list) do
		if not CommonUtil.EleInTable(tonumber(v), selections) then
			return false
		end
	end
	return true
end

function UIFilterView:InitRarityToggles(selections)
	self.rarityToggles = {}
	self.raritySelections = selections
	local allSelection = AllSelectionState(selections, self.rarities)

    self.rarityAllToggle.toggle.isOn = allSelection

	self.uiBase:AddToggleEventListener(self.rarityAllToggle.toggle, self, self.OnRarityToggleClick, 0)

	local trans = self.rarityToggleGrid.transform
	for i = 1,#self.rarities do
		local toggle
		if trans.childCount >= i then
			toggle = trans:GetChild(i - 1)
		else
			local go = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, togglePath)
			toggle = go.transform
			toggle:SetParent(trans)
			toggle.localPosition = Vector3.zero
			toggle.localRotation = Quaternion.identity
			toggle.localScale = Vector3.one
		end

		local state = self.rarities[i] ~= nil
		toggle.gameObject:SetActive(state)
		if state then
			local btnToggle = toggle:GetComponent(Enum.TypeInfo.Toggle)

			if allSelection or (not allSelection and CommonUtil.EleInTable(tonumber(self.rarities[i]), selections)) then
				btnToggle.isOn = true
			else
				btnToggle.isOn = false
			end

			self.uiBase:AddToggleUniqueEventListener(btnToggle, self, self.OnRarityToggleClick, i)

			local txt = toggle:Find("Txt"):GetComponent(Enum.TypeInfo.Text)
			txt.text = RarityNames[tonumber(self.rarities[i])]

			self.rarityToggles[i] = btnToggle
		end
	end
end

function UIFilterView:InitAttrsToggles(selections)
	self.attrToggles = {}
	self.attrSelections = selections

	local allSelection = AllSelectionState(selections, self.attrs)

    self.attrAllToggle.toggle.isOn = allSelection

	self.uiBase:AddToggleEventListener(self.attrAllToggle.toggle, self, self.OnAttrToggleClick, 0)
	local trans = self.attrToggleGrid.transform
	for i = 1,#self.attrs do
		local toggle
		if trans.childCount >= i then
			toggle = trans:GetChild(i - 1)
		else
			local go = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, togglePath)
			toggle = go.transform
			toggle:SetParent(trans)
			toggle.localPosition = Vector3.zero
			toggle.localRotation = Quaternion.identity
			toggle.localScale = Vector3.one
		end

		local state = self.attrs[i] ~= nil
		toggle.gameObject:SetActive(state)
		if state then
			local btnToggle = toggle:GetComponent(Enum.TypeInfo.Toggle)

			if allSelection or (not allSelection and CommonUtil.EleInTable(tonumber(self.attrs[i]), selections)) then
				btnToggle.isOn = true
			else
				btnToggle.isOn = false
			end

			self.uiBase:AddToggleUniqueEventListener(btnToggle, self, self.OnAttrToggleClick, i)

			local txt = toggle:Find("Txt"):GetComponent(Enum.TypeInfo.Text)
			txt.text = I18N.T("Attr_"..tonumber(self.attrs[i]))

			self.attrToggles[i] = btnToggle
		end
	end
end

function UIFilterView:InitTypesToggles(selections)
	local enter = self.controller:GetEnter()

	self.typeToggles = {}
	self.typeSelections = selections

	local allSelection = AllSelectionState(selections, self.types)

    self.typeAllToggle.toggle.isOn = allSelection

	self.uiBase:AddToggleEventListener(self.typeAllToggle.toggle, self, self.OnTypeToggleClick, 0)
	local trans = self.typeToggleGrid.transform

	for i = 1,trans.childCount do
		trans:GetChild(i - 1).gameObject:SetActive(false)
	end

	for i = 1,#self.types do
		local toggle
		if trans.childCount >= i then
			toggle = trans:GetChild(i - 1)
		else
			local go = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, togglePath)
			toggle = go.transform
			toggle:SetParent(trans)
			toggle.localPosition = Vector3.zero
			toggle.localRotation = Quaternion.identity
			toggle.localScale = Vector3.one
		end

		local state = self.types[i] ~= nil
		toggle.gameObject:SetActive(state)
		if state then
			local btnToggle = toggle:GetComponent(Enum.TypeInfo.Toggle)

			if allSelection or (not allSelection and CommonUtil.EleInTable(tonumber(self.types[i]), selections)) then
				btnToggle.isOn = true
			else
				btnToggle.isOn = false
			end

			self.uiBase:AddToggleUniqueEventListener(btnToggle, self, self.OnTypeToggleClick, i)

			local txt = toggle:Find("Txt"):GetComponent(Enum.TypeInfo.Text)

			if enter == Enum.ItemIEnterType.Bag then
				txt.text = I18N.T(Enum.EquipTypeName[self.types[i]])
			elseif enter == Enum.ItemIEnterType.Pet then
				txt.text = I18N.T("RoleFilter"..tonumber(self.types[i]))
			end

			self.typeToggles[i] = btnToggle
		end
	end
end

function UIFilterView:OnRarityToggleClick(toggle, idx, isOn)
	if self.selected ~= nil and self.selected ~= toggle then return end

	self.selected = toggle
	if idx == 0 then
		for i = 1, #self.rarityToggles do
			self.rarityToggles[i].isOn = isOn
		end
	else
		if self.rarityAllToggle.toggle.isOn and not isOn then
			self.rarityAllToggle.toggle.isOn = false
		end
	end

	self.delayTimer = FrameTimer.New(function()
		self:RaritySelectionsChanged(true)
	end, 1)
	self.delayTimer:Start()
end

function UIFilterView:OnAttrToggleClick(toggle, idx, isOn)
	if self.selected ~= nil and self.selected ~= toggle then return end

	self.selected = toggle
	if idx == 0 then
		for i = 1, #self.attrToggles do
			self.attrToggles[i].isOn = isOn
		end
	else
		if self.attrAllToggle.toggle.isOn and not isOn then
			self.attrAllToggle.toggle.isOn = false
		end
	end

	self.delayTimer1 = FrameTimer.New(function()
		self:AttrSelectionsChanged(true)
	end, 1)
	self.delayTimer1:Start()
end

function UIFilterView:OnTypeToggleClick(toggle, idx, isOn)
	if self.selected ~= nil and self.selected ~= toggle then return end

	self.selected = toggle

	if idx == 0 then
		for i = 1, #self.typeToggles do
			self.typeToggles[i].isOn = isOn
		end
	else
		if self.typeAllToggle.toggle.isOn and not isOn then
			self.typeAllToggle.toggle.isOn = false
		end
	end

	self.delayTimer2 = FrameTimer.New(function()
		self:TypeSelectionsChanged(true)
	end, 1)
	self.delayTimer2:Start()
end

local function SelectionsChanged(allToggle, selections, toggles, list)
	selections = {}
	if allToggle.isOn then
		for k,v in pairs(list) do
			selections[#selections + 1] = tonumber(list[k])
		end
	else
		for k,v in pairs(toggles) do
			if v.isOn then
				selections[#selections + 1] = tonumber(list[k])
			end
		end
	end

	if #selections == #list then
		allToggle.isOn = true
	end

	--LogHRWarning(Inspect(selections))
	return selections
end

function UIFilterView:RaritySelectionsChanged(needGray)
	self.raritySelections = SelectionsChanged(self.rarityAllToggle.toggle, self.raritySelections, self.rarityToggles, self.rarities)
	self.selected = nil

	if needGray then
		self:RefresBtnConfirmState()
	end
end

function UIFilterView:AttrSelectionsChanged(needGray)
	self.attrSelections = SelectionsChanged(self.attrAllToggle.toggle, self.attrSelections, self.attrToggles, self.attrs)
	self.selected = nil

	if needGray then
		self:RefresBtnConfirmState()
	end
end

function UIFilterView:TypeSelectionsChanged(needGray)
	self.typeSelections = SelectionsChanged(self.typeAllToggle.toggle, self.typeSelections, self.typeToggles, self.types)
	self.selected = nil

	if needGray then
		self:RefresBtnConfirmState()
	end
end

function UIFilterView:RefresBtnConfirmState()
	local state = #self.raritySelections > 0 or #self.attrSelections > 0 or #self.typeSelections > 0
	CommonUtil.SetTotalChildrenGray(self.btnConfirm, not state)
	self.btnConfirm.button.interactable = state
end

function UIFilterView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIFilterView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnReset.button,self, self.OnResetClick)
	self.uiBase:AddButtonEventListener(self.btnClose.button,self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnConfirm.button,self, self.OnConfirmClick)
end

function UIFilterView:OnResetClick()
    self.selected = self.rarityAllToggle.toggle
	self.rarityAllToggle.toggle.isOn = true

    self.selected = self.attrAllToggle.toggle
	self.attrAllToggle.toggle.isOn = true

    self.selected = self.typeAllToggle.toggle
	self.typeAllToggle.toggle.isOn = true

	self.selected = nil
	self.delayTimer3 = FrameTimer.New(function()
		self:ConfirmFilter()
	end, 1)
	self.delayTimer3:Start()
end

function UIFilterView:OnCloseClick()
	self:UIClose()
end

function UIFilterView:OnConfirmClick()
	self:ConfirmFilter()

	self:UIClose()
end

function UIFilterView:ConfirmFilter()
	local filterData = {}
	filterData.raritySelections = clone(self.raritySelections)
	filterData.attrSelections = clone(self.attrSelections)
	filterData.typeSelections = clone(self.typeSelections)

	local rarityAll = #self.raritySelections == #self.rarities
	local attrAll = #self.attrSelections == #self.attrs
	local typeAll = #self.typeSelections == #self.types
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.FILTER_NTF, self.controller:GetUIId(), filterData, not rarityAll or not attrAll or not typeAll)
end

function UIFilterView:OnHide()

end

function UIFilterView:OnShow(data)
	self.controller:SetData(data)

end

function UIFilterView:OnClose()
end

function UIFilterView:OnDispose()

	self.controller:OnDispose()

	if self.delayTimer then
		self.delayTimer:Stop()
	end
	self.delayTimer = nil

	if self.delayTimer1 then
		self.delayTimer1:Stop()
	end
	self.delayTimer1 = nil

	if self.delayTimer2 then
		self.delayTimer2:Stop()
	end
	self.delayTimer2 = nil

	if self.delayTimer3 then
		self.delayTimer3:Stop()
	end
	self.delayTimer3 = nil

	self.rarities = nil
	self.raritySelections = nil
	self.rarityToggles = nil

	self.attr = nil
	self.attrSelections = nil
	self.attrToggles = nil

	self.types = nil
	self.typeSelections = nil
	self.typeToggles = nil

	self.selected = nil
end

return UIFilterView

