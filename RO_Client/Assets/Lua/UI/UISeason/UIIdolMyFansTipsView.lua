local UIIdolMyFansTipsView = require("UISeason/UIIdolMyFansTipsView_Generate")
local FansInfoList = {}

function UIIdolMyFansTipsView:OnAwake(data)
	self.controller = require("UISeason/UIIdolMyFansTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIIdolMyFansTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_IDOL_MYFANS_INFO, self, self.RefreshPlayerInfo)
end

function UIIdolMyFansTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIIdolMyFansTipsView:Init()
	self:InitGrid()
	ManagerContainer.DataMgr.IdolData:SendGetSelfFansInfoReq()
end

function UIIdolMyFansTipsView:InitGrid()
	self.rankScroll.scrollRect.enabled = false
	self.rankScroll.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIIdolMyFansTipsView:RefreshPlayerInfo()
	FansInfoList = ManagerContainer.DataMgr.IdolData:GetMyFansData()
	self.rankScroll.loopGridView:RefreshListByIndex(FansInfoList and #FansInfoList or 0,0)
end

function UIIdolMyFansTipsView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local item = nil
	item = gridView:NewListViewItem('FansItem')
	local data = FansInfoList[itemIndex + 1]
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'FansItem', item.gameObject)
	itemLua.text.text.text = I18N.SetLanguageValue('MyFans1',CommonUtil.GetVaildNickName(data.name),data.score)
	return item
end

function UIIdolMyFansTipsView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.rankScroll.scrollRect.enabled = true
end

function UIIdolMyFansTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIIdolMyFansTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.closeBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
end

function UIIdolMyFansTipsView:OnClickCloseBtn()
	self:UIClose()
end

function UIIdolMyFansTipsView:OnHide()

end

function UIIdolMyFansTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIIdolMyFansTipsView:OnClose()
end

function UIIdolMyFansTipsView:OnDispose()
	self.controller:OnDispose()
	self.rankScroll.loopGridView:Dispose()
end

return UIIdolMyFansTipsView

