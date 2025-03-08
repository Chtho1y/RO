local UIVipLvUpView = require("UIVip/UIVipLvUpView_Generate")

function UIVipLvUpView:OnAwake(data)
	self.controller = require("UIVip/UIVipLvUpCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIVipLvUpView:AddEventListener()
end

function UIVipLvUpView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIVipLvUpView:Init()
	self.gainList.loopListView:InitListView(0, function(loopListView, itemIndex)
		return self:GetItemByIndex(loopListView, itemIndex)
	end)
	self:InitView()
end

function UIVipLvUpView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIVipLvUpView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
end

function UIVipLvUpView:OnHide()

end

function UIVipLvUpView:OnShow(data)
	self.controller:SetData(data)

end

function UIVipLvUpView:OnClose()
end

function UIVipLvUpView:OnDispose()
	self.canClose = nil
	if self.animTimer then
		self.animTimer:Stop()
		self.animTimer = nil
	end
	if self.closeTimer then
		self.closeTimer:Stop()
		self.closeTimer = nil
	end
	self.gainList.loopListView:Dispose()
	self.reward.loopHorizontalScrollRect:ClearCells()
	self.controller:OnDispose()
end

function UIVipLvUpView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self:StartVipAnim()
end

function UIVipLvUpView:OnClickCloseBtn()
	if not self.canClose then return end
	local isNext = self.controller:RefreshNextChange()
	if not isNext then
		self:UIClose()
		return
	end
	self:InitView()
	self:StartVipAnim()
end

function UIVipLvUpView:InitView()
	self.canClose = false

	local lastLv, curLv = self.controller:GetInfo()
	local lastVipCfg = ManagerContainer.CfgMgr:GetVipCfgById(lastLv)
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(curLv)

	self:RefreshView(lastVipCfg)
	if self.animTimer then
		self.animTimer:Stop()
		self.animTimer = nil
	end
	self.animTimer = Timer.New(function()
		self:RefreshView(vipCfg)
	end, 1)

	if self.closeTimer then
		self.closeTimer:Stop()
		self.closeTimer = nil
	end
	local duration = GlobalConfig.Instance:GetConfigFloatValue(250)
	if duration <= 0 then
		duration = 4
	end
	self.closeTimer = Timer.New(function()
		self:StopVipAnim()
	end, duration)
	self.godSeal.animator:Play('VipKeep', -1, 0)
	self.godSeal.animator:Update(0)

	self.gainList.loopListView:SetListItemCount(0)
	CommonUtil.LoopGridViewEleCreateNew(self, self.reward.loopHorizontalScrollRect, nil, {}, 0, self, self.UpdateRewardItem)
end

function UIVipLvUpView:StartVipAnim()
	self.godSeal.animator:Play('VipLevelUp', -1, 0)
	self.godSeal.animator:Update(0)
	if self.animTimer then
		self.animTimer:Start()
	end
	if self.closeTimer then
		self.closeTimer:Start()
	end
end

function UIVipLvUpView:StopVipAnim()
	self.canClose = true
	local _, curLv = self.controller:GetInfo()
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(curLv)
	if not vipCfg then
		self.gainList.loopListView:SetListItemCount(0)
		CommonUtil.LoopGridViewEleCreateNew(self, self.reward.loopHorizontalScrollRect, nil, {}, 0, self, self.UpdateRewardItem)
		return
	end
	self.gainList.loopListView:SetListItemCount(0)
	self.gainList.loopListView:SetListItemCount(vipCfg.UnlockDes and #vipCfg.UnlockDes or 0)
	self.gainList.loopListView:RefreshAllShownItem()
	CommonUtil.LoopGridViewEleCreateNew(self, self.reward.loopHorizontalScrollRect, nil, vipCfg.Reward and vipCfg.Reward or {}, 0, self, self.UpdateRewardItem)
end

function UIVipLvUpView:RefreshView(vipCfg)
	self.vipIcon.image.sprite = nil
	self.vipIcon.image.enabled = false
	self.vipFrame.image.sprite = nil
	self.vipFrame.image.enabled = false
	if vipCfg then
		self.curVipNameTxt.text.text = string.formatbykey(vipCfg.Name)
		CommonUtil.LoadIcon(self, vipCfg.BigIcon, function(sprite)
			if sprite then
				self.vipIcon.image.sprite = sprite
				self.vipIcon.image.enabled = true
			end
		end)
		CommonUtil.LoadIcon(self, vipCfg.BigFrame, function(sprite)
			if sprite then
				self.vipFrame.image.sprite = sprite
				self.vipFrame.image.enabled = true
			end
		end)
	else
		self.curVipNameTxt.text.text = ''
	end
end

function UIVipLvUpView:GetItemByIndex(loopListView, itemIndex)
	local _, vipLv = self.controller:GetInfo()
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
	if not vipCfg then return nil end
	if not vipCfg.UnlockDes then return nil end
	local unlockDes = vipCfg.UnlockDes[itemIndex + 1]
	if not unlockDes then return nil end
	local item = loopListView:NewListViewItem('VipUnlockDesItem')
	local isNew = unlockDes[1] or 0
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'VipUnlockDesItem', item.gameObject)
	if itemLua then
		itemLua.exist:SetActive(isNew ~= 1)
		itemLua.new:SetActive(isNew == 1)
		local params = {}
		local langKey = unlockDes[2]
		for i = 3, #unlockDes do
			params[#params + 1] = tostring(unlockDes[i])
		end
		itemLua.desTxt.text.text = string.formatbykey(langKey, unpack(params))
	end
	ManagerContainer.LuaUIMgr:ForceRebuildLayoutImmediate(item.CachedRectTransform)
	return item
end

function UIVipLvUpView:RefreshBottomView()
	local _, vipLv = self.controller:GetInfo()
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
	if not vipCfg then
		self.vipNameTxt.text.text = ''
		self.gainList.loopListView:SetListItemCount(0)
		CommonUtil.LoopGridViewEleCreateNew(self, self.reward.loopHorizontalScrollRect, nil, {}, 0, self, self.UpdateRewardItem)
		return
	end
	self.vipNameTxt.text.text = string.formatbykey(vipCfg.Name)
	self.gainList.loopListView:SetListItemCount(vipCfg.UnlockDes and #vipCfg.UnlockDes or 0)
	self.gainList.loopListView:RefreshAllShownItem()
	CommonUtil.LoopGridViewEleCreateNew(self, self.reward.loopHorizontalScrollRect, nil, vipCfg.Reward and vipCfg.Reward or {}, 0, self, self.UpdateRewardItem)
end

function UIVipLvUpView:UpdateRewardItem(itemLua, itemIdx, itemData)
	if not itemLua or not itemData then return end
	CommonUtil.UpdateItemPrefab(self, itemLua.iconItem, {cfgId = itemData[1], num = itemData[2]}, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
	itemLua.check:SetActive(false)
end

function UIVipLvUpView:ShowItemTips(button, params)
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

return UIVipLvUpView

