local KeepSakeBook = class("KeepSakeBook")

local pageToggleData = {}
function KeepSakeBook:ctor()
end

function KeepSakeBook:InitGo(host,uiGo)
	self.host = host
	self.viewLua = CommonUtil.BindGridViewItem2Lua(self.host, "BookItem", uiGo)
	self.controller = require("UICollect/KeepSakeBookCtr"):new()
	self.host.controller:SetKeepSakeBookCtr(self.controller)

	self:InitPanel()
end

function KeepSakeBook:InitPanel()
	self:InitGrid()
	self.viewLua.qtyCard:SetActive(false)
	self.viewLua.qtyPet:SetActive(false)
	self.viewLua.qtyCollection:SetActive(true)

	self.viewLua.btnMaterials:SetActive(true)
	self.viewLua.dscBox:SetActive(true)
end

function KeepSakeBook:Hide()
	self.viewLua.gameObject:SetActive(false)
end

function KeepSakeBook:Show()
	self.viewLua.gameObject:SetActive(true)
end

function KeepSakeBook:SelectToggle()
	CommonUtil.CreateToggleMouduleOnlyBtns(self.host, pageToggleData, self.viewLua.toggleGroup, Enum.CollectQualityType.ALL, self.host.OnValueChangedToggle)
end

function KeepSakeBook:InitGrid()
	self.viewLua.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function KeepSakeBook:GetItemByRowColumn(gridView, itemIndex, row, column)
	local item = gridView:NewListViewItem('KeepSakeCollect')
	local cfgData = self.controller:GetShowDataByIdx(itemIndex + 1)

	local itemlua = CommonUtil.BindGridViewItem2Lua(self.host, "KeepSakeCollect", item.gameObject)
	CommonUtil.UpdateItemPrefab(self.host, itemlua, cfgData, nil, self, self.OnCollectionClick)
    --
    --local lv = ManagerContainer.DataMgr.KeepSakeBookData:GetKeepSakeBookDataById(cfgData.Id) or 0
    --
    --local isMax = cfgData["MaterialLevel"..(lv + 1)] == nil
	itemlua.uIRedPointRP:SetActive(cfgData.canLvUp)
	return item
end

function KeepSakeBook:OnValueChangedToggle()
	--LogHRWarning("OnValueChangedToggle")
	local type = pageToggleData.toggleDefaultIndex
	self.controller:GetHandBookKeepSakeCfgDatasByType(type)

	local count = self.controller:GetCurCount(type)
	local length = self.controller:GetCurShowDatasLength()
	local maxCount = length
	self.viewLua.qtyCollection.text.text.text = count.."/"..maxCount

	self.viewLua.qtyCollection.iconAll:SetActive(type == Enum.CollectQualityType.ALL)
	self.viewLua.qtyCollection.iconNormal:SetActive(type == Enum.CollectQualityType.NORMAL)
	self.viewLua.qtyCollection.iconMini:SetActive(type == Enum.CollectQualityType.MINIBOSS)
	self.viewLua.qtyCollection.iconMvp:SetActive(type == Enum.CollectQualityType.MVP)

	if length > 0 then
		--self.viewLua.scrollView.loopGridView:SetListItemCount(length, true)
		self.viewLua.scrollView.loopGridView:RefreshListByIndex(length)
	end
end

function KeepSakeBook:OnCollectionClick(button, params)
	local cfgId = params[0]

	local data = {type = Enum.CollectType.KeepSake, cfgId = cfgId}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICollectTips, data)
end

function KeepSakeBook:AddEventListener()

end

function KeepSakeBook:RemoveEventListener()

end

function KeepSakeBook:AddUIEventListener()
	self.host.uiBase:AddButtonEventListener(self.viewLua.btnBack.button, self, self.OnBtnBackClick)
	self.host.uiBase:AddButtonEventListener(self.viewLua.btnMaterials.button, self, self.OnBtnMaterialClick)
end

function KeepSakeBook:OnBtnBackClick()
	if self.host and self.host.BookBack then
		self.host:BookBack()
	end
end

function KeepSakeBook:OnBtnMaterialClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIMaterialsTips)
end

function KeepSakeBook:Dispose()

	self.viewLua.scrollView.loopGridView:Dispose()

	self.controller:OnDispose()
	self.controller = nil

    self.host = nil
	self.viewLua:GenerateDestroy()
    self.viewLua = nil
	pageToggleData = {}
end


return KeepSakeBook