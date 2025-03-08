local DemonRewardItemCtr = {}

function DemonRewardItemCtr:SetData(wnd, item, logicData, enterType)
    self.uiData = wnd
    local cfgId = logicData.rewardItemId
    local cfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
    if not cfgData then
        return
    end

    CommonUtil.LoadIcon(wnd, cfgData.Icon , function (sprite)
        item.boxIcon.image.sprite = sprite
    end)

    item.scrollView.loopGridView:Dispose()
    item.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
        return self:GetItemByRowColumn(gridView, itemIndex, row, column,logicData.reviewAwards)
    end, nil)
    item.scrollView.loopGridView:RefreshListByIndex(logicData.reviewAwards and #logicData.reviewAwards, 0)
end

function DemonRewardItemCtr:GetItemByRowColumn(gridView, itemIndex, row, column,AwardList)
    local item = nil
	item = gridView:NewListViewItem('IconSmallItem')
	local cfgId = AwardList[itemIndex + 1]
	local showData = {cfgId = cfgId}
	local itemLua = CommonUtil.BindGridViewItem2Lua(self.uiData, 'IconItem', item.gameObject)
	CommonUtil.UpdateItemPrefab(self.uiData, itemLua, showData)
    itemLua.bg.button.enabled = true
    self.uiData.uiBase:AddButtonUniqueEventListener(itemLua.bg.button, self, self.OnClickCloseBtn,showData)
	return item
end
function DemonRewardItemCtr:OnClickCloseBtn(button,params)
    local showData = params[0]
    ManagerContainer.LuaUIMgr:OpenTips({cfgId = showData.cfgId})
end

return DemonRewardItemCtr