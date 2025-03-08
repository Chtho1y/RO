local UIOptionalGiftView = require("UITips/UIOptionalGiftView_Generate")

function UIOptionalGiftView:OnAwake(data)
	self.controller = require("UITips/UIOptionalGiftCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIOptionalGiftView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ITEM_CHANGE, self, self.OnItemChanged)
end

function UIOptionalGiftView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIOptionalGiftView:Init()
	self.scrollView.loopGridView:InitGridView(0, function (gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self.scrollView.loopGridView.ScrollRect.enabled = false

	self.controller:RefreshData()
	self:RefreshData()
end

function UIOptionalGiftView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIOptionalGiftView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btn_OK.button, self, self.OnClickSureBtn)
end

function UIOptionalGiftView:OnHide()

end

function UIOptionalGiftView:OnShow(data)
	if data then
		self.controller:SetData(data)
		self.controller:RefreshData()
		self:RefreshData()
	end
end

function UIOptionalGiftView:OnClose()
end

function UIOptionalGiftView:OnDispose()
	self.scrollView.loopGridView:Dispose()
	self.controller:OnDispose()
end

function UIOptionalGiftView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.scrollView.loopGridView.ScrollRect.enabled = true
end

function UIOptionalGiftView:OnItemChanged()
	if self.controller:CanCost() then
		self:RefreshDes()
	else
		self:UIClose()
	end
end

function UIOptionalGiftView:OnClickCloseBtn()
	self:UIClose()
end

function UIOptionalGiftView:OnClickSureBtn()
	local lastIdx = self.controller:GetSelectIdx()
	local errorCode = self.controller:SendOpenGiftReq()
	if errorCode == 0 then
		if lastIdx then
			self.scrollView.loopGridView:RefreshItemByItemIndex(lastIdx - 1)
		end
		self:RefreshSureBtnState()
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIOptionalGiftView:OnClickItemBtn(_, params)
	if not params then return end
	local idx = params[0]
	local itemData = params[1]
	if not idx or not itemData then
		return
	end
	local lastIdx = self.controller:GetSelectIdx()
	if not self.controller:SetSelectIdx(idx) then
		return
	end
	if lastIdx then
		self.scrollView.loopGridView:RefreshItemByItemIndex(lastIdx - 1)
	end
	self.scrollView.loopGridView:RefreshItemByItemIndex(idx - 1)
	self:RefreshSureBtnState()
end


function UIOptionalGiftView:RefreshData()
	local num = self.controller:GetSelectCfgIdNum()
	self.scrollView.loopGridView:RefreshListByIndex(num, 0)
	local cfgData = self.controller:GetCfgData()
	self.textTitle.text.text = cfgData and string.formatbykey(cfgData.Name) or ''
	self:RefreshSureBtnState()
	self:RefreshDes()
end

function UIOptionalGiftView:RefreshSureBtnState()
	self.btn_OK.button.interactable = (self.controller:GetSelectIdx() ~= nil)
end

function UIOptionalGiftView:RefreshDes()
	self.decomposeDsc.uILocalizeScript:SetContentAndValues('DscChooseOne', {self.controller:GetOwnResCountByItemId()})
end

function UIOptionalGiftView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local idx = itemIndex + 1
	local itemData = self.controller:GetSelectItemData(idx)
	if not itemData or not itemData.cfgId or not itemData.num or itemData.num <= 0 then
		return nil
	end
	local item = gridView:NewListViewItem('GiftListItem')
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'GiftListItem', item.gameObject)
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(itemData.cfgId)
	if itemCfgData then
		itemlua.textName.text.text = string.formatbykey(itemCfgData.Name)
		itemlua.iconSmallItem:SetActive(true)
		CommonUtil.UpdateItemPrefab(self, itemlua.iconSmallItem, itemData, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
	else
		itemlua.textName.text.text = ''
		itemlua.iconSmallItem:SetActive(false)
	end
	itemlua.selected:SetActive(self.controller:GetSelectIdx() == idx)
	self.uiBase:AddButtonUniqueEventListener(itemlua.button, self, self.OnClickItemBtn, idx, itemData)
	return item
end

function UIOptionalGiftView:ShowItemTips(_, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

return UIOptionalGiftView

