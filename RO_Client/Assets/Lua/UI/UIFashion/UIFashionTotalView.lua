local UIFashionTotalView = require("UIFashion/UIFashionTotalView_Generate")

function UIFashionTotalView:OnAwake(data)
	self.controller = require("UIFashion/UIFashionTotalCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIFashionTotalView:AddEventListener()
	-- ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FASHION_LIST_CHANGE, self, self.RefreshAllAttr)
end

function UIFashionTotalView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIFashionTotalView:Init()
	self.attrTitle.uILocalizeScript:SetContent(self.controller:GetTile())
	self.attr1Title.uILocalizeScript:SetContent(self.controller:GetTile1())

	local attr = self.controller:GetAttrs()
	local attr1 = self.controller:GetAttrs1()
	self.propertySuit:SetActive(attr ~= nil)
	self.property:SetActive(attr1 ~= nil)

	self.propertySuit.noPro:SetActive(attr == nil or #attr == 0)
	self.property.noPro:SetActive(attr1 == nil or #attr1 == 0)
end

function UIFashionTotalView:OnPageInEnd()
	self.super:OnPageInEnd()

	self:RefreshAttrs()
	self:RefreshAttrs1()
end

function UIFashionTotalView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIFashionTotalView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.CloseUI)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.CloseUI)
end

function UIFashionTotalView:OnHide()

end

function UIFashionTotalView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIFashionTotalView:OnClose()
	self.propertySuit.loopVerticalScrollRect:ClearCells()
	self.property.loopVerticalScrollRect:ClearCells()
end

function UIFashionTotalView:OnDispose()

end

function UIFashionTotalView:CloseUI()
	self:UIClose()
end

function UIFashionTotalView:RefreshAttrs()
	local attrs = self.controller:GetAttrs()
    if not attrs then return end
	CommonUtil.LoopGridViewEleCreateNew(self, self.propertySuit.loopVerticalScrollRect, nil, attrs, 0, nil, function (itemLua, idx)
		CommonUtil.UpdateItemPrefab(self, itemLua, attrs[idx + 1])
	end)
end

function UIFashionTotalView:RefreshAttrs1()
	local attrs1 = self.controller:GetAttrs1()
    if not attrs1 then return end

	CommonUtil.LoopGridViewEleCreateNew(self, self.property.loopVerticalScrollRect, nil, attrs1, 0, nil, function (itemLua, idx)
		CommonUtil.UpdateItemPrefab(self, itemLua, attrs1[idx + 1])
	end)
end

return UIFashionTotalView

