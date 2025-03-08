local UIOptionalWishBoxView = require("UITips/UIOptionalWishBoxView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

function UIOptionalWishBoxView:OnAwake(data)
	self.controller = require("UITips/UIOptionalWishBoxCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIOptionalWishBoxView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIOptionalWishBoxView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIOptionalWishBoxView:Init()
	local cfgId = self.controller:GetCfgId()
	local wishCfg = ManagerContainer.CfgMgr:GetWishCfgById(cfgId)
	self.selectIdx = nil
	self.btnOK.button.interactable = self.selectIdx ~= nil
	self.scrollView.scrollRect.enabled = false
	if wishCfg then
		self.rewardData = wishCfg.WishReward
		local len  = self.rewardData and #self.rewardData or 0
		self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
			return self:GetItemByRowColumn(gridView, itemIndex, row, column)
		end, nil)
		self.scrollView.loopGridView:RefreshListByIndex(len, 0)
	end
end
function UIOptionalWishBoxView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.scrollView.scrollRect.enabled = true
end

function UIOptionalWishBoxView:OnItemClick(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end


function UIOptionalWishBoxView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local item = gridView:NewListViewItem('WishBoxListItem')
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'WishBoxListItem', item.gameObject)
	local rewardData = self.rewardData[itemIndex + 1]
	local data = {cfgId = rewardData[2],num = rewardData[3]}
	IconItemCtr:SetData(self, itemlua.iconItem, data,nil,self,self.OnItemClick)
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(rewardData[2])
	itemlua.selected:SetActive(self.selectIdx == itemIndex)
	if itemCfgData then
		itemlua.textName.text.text  = itemCfgData.Name
		local dcs = itemCfgData.Describe
		itemlua.desText.text.text = I18N.T(dcs)
	end
	self.uiBase:AddButtonUniqueEventListener(itemlua.button, self, self.OnSelectItemClick,itemIndex)
	return item
end

function UIOptionalWishBoxView:OnSelectItemClick(btn,param)
	if self.selectIdx then
		if self.selectIdx == param[0] then
			return
		end
		local itemLua = self:GetShowItemByIdx(self.selectIdx)
		if itemLua then
			itemLua.selected:SetActive(false)
		end
	end
	self.selectIdx = param[0]
	local itemLua = self:GetShowItemByIdx(self.selectIdx)
	if itemLua then
		itemLua.selected:SetActive(true)
	end
	self.btnOK.button.interactable = self.selectIdx ~= nil
end

function UIOptionalWishBoxView:GetShowItemByIdx(idx)
    local item = self.scrollView.loopGridView:GetShownItemByItemIndex(idx)
    if item then
        local itemlua = CommonUtil.GetBindGridViewItem2Lua(self, "WishBoxListItem", item.gameObject)
        return itemlua
    end
end

function UIOptionalWishBoxView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIOptionalWishBoxView:OnClickCloseBtn()
	self:UIClose()
end

function UIOptionalWishBoxView:OnClickOkBtn()
	if self.selectIdx then
		local data = self.rewardData[self.selectIdx + 1]
		local cfgId = data[2]
		local id = self.controller:GetId()
		ManagerContainer.DataMgr.BagData:SendWishBoxReq({id = id,cfgId = cfgId})
	end
	self:UIClose()
end

function UIOptionalWishBoxView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnOK.button, self, self.OnClickOkBtn)
end


function UIOptionalWishBoxView:OnHide()

end

function UIOptionalWishBoxView:OnShow(data)
	self.controller:SetData(data)

end

function UIOptionalWishBoxView:OnClose()
end

function UIOptionalWishBoxView:OnDispose()
	self.controller:OnDispose()
	self.scrollView.loopGridView:Dispose()
end

return UIOptionalWishBoxView

