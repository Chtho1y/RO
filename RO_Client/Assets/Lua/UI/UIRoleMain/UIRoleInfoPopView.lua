local UIRoleInfoPopView = require("UIRoleMain/UIRoleInfoPopView_Generate")

function UIRoleInfoPopView:OnAwake(data)
	self.controller = require("UIRoleMain/UIRoleInfoPopCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIRoleInfoPopView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIRoleInfoPopView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIRoleInfoPopView:Init()
	self.controller:InitData()
	self.scrollView.loopListView:InitListView(0, function(loopListView, idx)
		return self:GetItemByIndex(loopListView, idx)
	end)
	self:RefreshView(true)
	self.scrollView.loopListView.ScrollRect.enabled = false
end

function UIRoleInfoPopView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIRoleInfoPopView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCancelBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCancelBtn)
end

function UIRoleInfoPopView:OnHide()

end

function UIRoleInfoPopView:OnShow(data)
	if data then
		self.controller:SetData(data)
		self.controller:InitData()
		self:RefreshView(true)
	end
end

function UIRoleInfoPopView:OnClose()
end

function UIRoleInfoPopView:OnDispose()
	self.scrollView.loopListView:Dispose()
	self.controller:OnDispose()
end

function UIRoleInfoPopView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.scrollView.loopListView.ScrollRect.enabled = true
end

function UIRoleInfoPopView:OnClickCancelBtn()
	self:UIClose()
end

function UIRoleInfoPopView:RefreshView(resetPos)
	self.textTitle.text.text = string.formatbykey(self.controller:GetTitleName())
	self.scrollView.loopListView:SetListItemCount(self.controller:GetDataLength(), resetPos or false)
    self.scrollView.loopListView:RefreshAllShownItem()
end

function UIRoleInfoPopView:GetItemByIndex(loopListView, idx)
	local data = self.controller:GetDataByIdx(idx + 1)
	if not data then return nil end
	local title = data[2]
	local des = data[3]
	if not title or not des then
		return nil
	end
	local iconName = data[4]
	local item = loopListView:NewListViewItem('InfoDscItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'InfoDscItem', item.gameObject)
	if itemLua then
		itemLua.textName.text.text = string.formatbykey(title)
		itemLua.textDsc.text.text = string.formatbykey(des)
		if iconName and iconName ~= '' then
			itemLua.icon:SetActive(true)
			itemLua.icon.image.sprite = nil
			itemLua.icon.image.enabled = false
			CommonUtil.LoadIcon(self, iconName, function(sprite)
				if sprite then
					itemLua.icon.image.sprite = sprite
					itemLua.icon.image.enabled = true
				end
			end)
		else
			itemLua.icon:SetActive(false)
		end
	end
	ManagerContainer.LuaUIMgr:ForceRebuildLayoutImmediate(item.CachedRectTransform)
	return item
end



return UIRoleInfoPopView

