local UIChipDecomposeTipsView = require("UIChip/UIChipDecomposeTipsView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

function UIChipDecomposeTipsView:OnAwake(data)
	self.controller = require("UIChip/UIChipDecomposeTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIChipDecomposeTipsView:AddEventListener()

end

function UIChipDecomposeTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIChipDecomposeTipsView:Init()
	local isSelected = self.controller:IsSelected()
	for i = 1, 5 do
		local num = self.controller:GetDecomposeQualityNum(i)
		local quality = self['quality' .. i]
		if num <= 0 then
			quality:SetActive(false)
		else
			quality:SetActive(true)
			if isSelected then
				quality.checkBox:SetActive(false)
			else
				quality.checkBox:SetActive(true)
				quality.checkBox.toggle.isOn = self.controller:GetSelectedQuality(i)
			end
			quality.content.text.text = I18N.T('Chipresolve_' .. i) .. ' x' .. tostring(num)
		end
	end

	local awards = self.controller:GetDecomposeAwards()
	for i = 1,3 do
		self["award"..i]:SetActive(i <= #awards)
		if i <= #awards then
			local data = {cfgId = awards[i][1], num = awards[i][2]}
			local itemLua = self["awardItem"..i]
			IconItemCtr:SetData(self, itemLua, data, Enum.ItemIEnterType.CardCompose, self, self.ShowItemTips)
			self["award"..i].text.text.text = data.num
		end
	end
end

function UIChipDecomposeTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIChipDecomposeTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	for i = 1, 5 do
		self['quality' .. i].checkBox.toggle.onValueChanged:AddListener(function(isOn)
			self.controller:SetSelectedQuality(i, isOn)
		end)
	end

	self.uiBase:AddButtonEventListener(self.btnClose.button, function (buttton, params)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RESET_CHIP_DECOMPOSE_CACHE_COUNTS)
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.alpha.button, function (buttton, params)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RESET_CHIP_DECOMPOSE_CACHE_COUNTS)
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.btnCancle.button, function (buttton, params)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RESET_CHIP_DECOMPOSE_CACHE_COUNTS)
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.btnDecompose.button, function (buttton, params)
		local errorCode = self.controller:GetErrorCode()
		if errorCode == 0 then
			self:SureDecompose()
		elseif errorCode == 1 then
			self:UIHide()
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChipProduceNotice, {self, self.SureDecompose, self.CancelDecompose})
		elseif errorCode == 2 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('ChipDecomposeTips03')
		elseif errorCode == 3 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('ChipDecomposeTips04')
		end
	end)
end

function UIChipDecomposeTipsView:OnHide()

end

function UIChipDecomposeTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIChipDecomposeTipsView:OnClose()

end

function UIChipDecomposeTipsView:OnDispose()

end

function UIChipDecomposeTipsView:SureDecompose()
	self.controller:SendDecompose()
	self:UIClose()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RESET_CHIP_DECOMPOSE_CACHE_COUNTS)
end

function UIChipDecomposeTipsView:CancelDecompose()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChipDecomposeTips)
end

return UIChipDecomposeTipsView

