local UIRewardsTipsView = require("UIActivity/UIRewardsTipsView_Generate")

function UIRewardsTipsView:OnAwake(data)
	self.controller = require("UIActivity/UIRewardsTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIRewardsTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIRewardsTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIRewardsTipsView:Init()
	local rewards = self.controller:GetData()
	if not rewards or #rewards == 0 then
		CommonUtil.LoopGridViewEleCreateNew(self, self.goodsList.loopVerticalScrollRect, nil, {}, 0, self, self.UpdateIconItem, nil, nil, 0)
		return
	end
	local icons = {}
	for i = 1,#rewards do
		icons[i] = {cfgId = rewards[i][1], num = rewards[i][2]}
	end
	CommonUtil.LoopGridViewEleCreateNew(self, self.goodsList.loopVerticalScrollRect, nil, icons, 0, self, self.UpdateIconItem)
	self.goodsList.loopVerticalScrollRect.vertical = (#icons > 8)
	self.goodsList.loopVerticalScrollRect:SetItemStartIdx(0)
end

function UIRewardsTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIRewardsTipsView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
end

function UIRewardsTipsView:OnClickCloseBtn()
	self:UIClose()
end

function UIRewardsTipsView:UpdateIconItem(itemLua, itemIdx, itemData)
	if not itemLua or not itemData then return end
	CommonUtil.UpdateItemPrefab(self, itemLua, itemData, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
end

function UIRewardsTipsView:ShowItemTips(button, params)
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

function UIRewardsTipsView:OnHide()

end

function UIRewardsTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIRewardsTipsView:OnClose()
	self.goodsList.loopVerticalScrollRect:ClearCells()
	self.goodsList.loopVerticalScrollRect:ClearAnchoredPostion()
end

function UIRewardsTipsView:OnDispose()
	self.controller:OnDispose()
end

return UIRewardsTipsView

