local UIPetMySupportView = require("UIPet/UIPetMySupportView_Generate")

function UIPetMySupportView:OnAwake(data)
	self.controller = require("UIPet/UIPetMySupportCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetMySupportView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_MY_SUPPORT_CHANGE_NTF, self, self.OnMySupportChangeNtf)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_MY_SUPPORT_CHANGE_SUCCESS_NTF, self, self.Refresh)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_PAGE_IN_END_NTF, self, self.OnUIPageInEndNtf)
end

function UIPetMySupportView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPetMySupportView:Init()
	self:InitGrid()
	self.controller:RefreshShowDatas()
	self.controller:SendMySupport()
end

function UIPetMySupportView:InitGrid()
	self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIPetMySupportView:OnUIPageInEndNtf()
	--self:Refresh()
end

function UIPetMySupportView:Refresh(resetPos)
	self.controller:RefreshShowDatas()

	local count = self.controller:GetMySupportCount()
	self.count.text.text = count.."/"..Constant.MyPetSupportLimit
	local loopGridView = self.scrollView.loopGridView
	if resetPos then
		loopGridView:RefreshListByIndex(Constant.MyPetSupportLimit, 0)
	else
		loopGridView:RefreshListByIndex(Constant.MyPetSupportLimit)
	end
end

function UIPetMySupportView:GetItemByRowColumn(gridView, itemIndex, row, column)
	--local length = self.controller:GetShowDataLength()
	--if (itemIndex < 0 or itemIndex >= length) then
	--	return nil
	--end
	local showData = self.controller:GetShowDataByIdx(itemIndex)
	local item = gridView:NewListViewItem("SupportItem")
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, "SupportItem", item.gameObject)
	local data = {id = showData and showData.id or 0, idx = itemIndex + 1}
	CommonUtil.UpdateItemPrefab(self, itemlua, data, nil, self, self.OnItemClick)
	return item
end

function UIPetMySupportView:OnItemClick(button, params)
	local idx = params[0]
	local result, time = self.controller:SupportSlotIsInCD(idx)
	if result then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam("Petfetter_002", time)
	else
		local data = {fromUIId = self.uiData.id, supportIdx = idx, enterType = Enum.ItemIEnterType.PetSupport}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetMats, data)
	end
end

function UIPetMySupportView:OnMySupportChangeNtf(data)
	local id = data[1]
	local idx = data[2]
	self.controller:AddSupportData(id or 0, idx)
	self.controller:SendMySupport()
end

function UIPetMySupportView:OnItemRemoveClick(button, params)
	local id = params[0]

	self.controller:RemoveShowDataById(id)
	self.controller:SendMySupport()
end

function UIPetMySupportView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPetMySupportView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)
end

function UIPetMySupportView:OnCloseClick()
	self:UIClose()
end

function UIPetMySupportView:OnHide()

end

function UIPetMySupportView:OnShow(data)
	self.controller:SetData(data)

end

function UIPetMySupportView:OnClose()
end

function UIPetMySupportView:OnDispose()
	self.scrollView.loopGridView:Dispose()

	self.controller:OnDispose()
end

return UIPetMySupportView

