local UIChipRoomView = require("UIChip/UIChipRoomView_Generate")

function UIChipRoomView:OnAwake(data)
	self.controller = require("UIChip/UIChipRoomCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIChipRoomView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RESET_CHIP_DECOMPOSE_CACHE_COUNTS, function()
		self.controller:ResetChipsCost()
		self:RefreshShow(false)
	end)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CHIP_CHANGE, function()
		self.controller:ResetChipsCost()
		self:RefreshShow(true)
	end)
end

function UIChipRoomView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIChipRoomView:Init()
	self:RefreshShow(true)
end

function UIChipRoomView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIChipRoomView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnBack.button, function (buttton, params)
		self:UIClose()
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBag, Enum.BagViewPageType.Chip)
	end)

	self.uiBase:AddButtonEventListener(self.btnDecompose.button, function (buttton, params)
		local list, num =  self.controller:GetExpectDecomposeChips()
		if num <= 0 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('ChipDecomposeTips04')
			return
		end
		local data = {list, true}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChipDecomposeTips,data)
	end)

	self.uiBase:AddButtonEventListener(self.btnOneKeyDecompose.button, function (buttton, params)
		local list, num =  self.controller:GetExpectDecomposeChips(true)
		if num <= 0 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('ChipDecomposeTips04')
			return
		end
		local data = {list, false}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChipDecomposeTips, data)
	end)
end

function UIChipRoomView:OnHide()

end

function UIChipRoomView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIChipRoomView:OnClose()
end

function UIChipRoomView:OnDispose()
	self.decompose.loopVerticalScrollRect:ClearCells()
end

function UIChipRoomView:RefreshShow(refreshData)
	if refreshData then
		self.controller:RefreshCanDecomposeChips()
	end
	local chipDatas = self.controller:GetCanDecomposeChips()
	local hasData = #chipDatas > 0
	self.decompose.noChips:SetActive(not hasData)
	CommonUtil.LoopGridViewEleCreate(self,
			self.decompose.loopVerticalScrollRect,
			self.decompose.content.gridLayoutGroup,
			chipDatas,
			0,
			function(itemlua, idx)
				CommonUtil.UpdateItemPrefab(self, itemlua, chipDatas[idx + 1])
			end)
end

return UIChipRoomView

