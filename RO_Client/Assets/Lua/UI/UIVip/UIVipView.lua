local UIVipView = require("UIVip/UIVipView_Generate")

function UIVipView:OnAwake(data)
	self.controller = require("UIVip/UIVipCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIVipView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VIP_LV_CHANGED, self, self.OnVipLvChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VIP_EXP_CHANGED, self, self.OnVipExpChanged)
end

function UIVipView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIVipView:Init()
	self.customerServiceData = nil
	self.gainList.loopListView:InitListView(0, function(loopListView, itemIndex)
		return self:GetItemByIndex(loopListView, itemIndex)
	end)
	self.gainList.loopListView.ScrollRect.enabled = false
	self.expSlider.slider.interactable = false

	self:RefreshTopView()
	self:RefreshBottomView()
	self:RefreshSwitchButton()
	self:StartCheckCustomerService()
end

function UIVipView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIVipView:AddUIEventListener()
	-- self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnBack.button, self, self.OnClickCloseBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnUpLv.button, self, self.OnClickUpLvBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnInfo.button, self, self.OnClickInfoBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnLeft.button, self, self.OnClickLeftBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnRight.button, self, self.OnClickRightBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnCustomerService.button, self, self.OnClickCustomerServiceBtn)
end

function UIVipView:OnHide()

end

function UIVipView:OnShow(data)
	self.controller:SetData(data)

end

function UIVipView:OnClose()
end

function UIVipView:OnDispose()
	self.customerServiceData = nil
	self:DisposeCheckCustomerService()
	self.gainList.loopListView:Dispose()
	self.rewardList.loopHorizontalScrollRect:ClearCells()
	self.controller:OnDispose()
end

function UIVipView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.gainList.loopListView.ScrollRect.enabled = true
end

function UIVipView:OnVipLvChanged()
	self:RefreshLvView()
	self:StartCheckCustomerService()
end

function UIVipView:OnVipExpChanged()
	self:RefreshExpView()
end

function UIVipView:OnClickCloseBtn()
	self:UIClose()
end

function UIVipView:OnClickUpLvBtn()
	if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIRuneShop) then
		local uibase = ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UIRuneShop)
		if uibase then
			local luaTable = uibase.MLuaTable
			if luaTable then
				if luaTable.OnShow then
					luaTable:OnShow({Enum.RuneShopType.Gifts, Enum.RuneShopSubType.Gold})
				end
			end
		end
	else
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.Gifts, Enum.RuneShopSubType.Gold})
	end
	self:UIClose()
end

function UIVipView:OnClickInfoBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'VipExplain'})
end

function UIVipView:OnClickLeftBtn()
	if not self.controller:ChangeCurShowVipLv(false) then
		return
	end
	self:RefreshBottomView()
	self:RefreshSwitchButton()
end

function UIVipView:OnClickRightBtn()
	if not self.controller:ChangeCurShowVipLv(true) then
		return
	end
	self:RefreshBottomView()
	self:RefreshSwitchButton()
end

function UIVipView:OnClickCustomerServiceBtn()
	local infos = self:GetCustomerServiceInfos()
	if not infos then
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICustomerServiceTips, infos)
end

function UIVipView:RefreshTopView()
	self:RefreshLvView()
	self:RefreshExpView()
end

function UIVipView:RefreshLvView()
	local curVipLv = self.controller:GetCurVipLv()
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(curVipLv)

	self.vipIcon.image.sprite = nil
	self.vipIcon.image.enabled = false
	self.vipFrame.image.sprite = nil
	self.vipFrame.image.enabled = false
	if not vipCfg then
		self.curVipNameTxt.text.text = ''
		return
	end
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
	self.curVipNameTxt.text.text = string.formatbykey(vipCfg.Name)

	self.expTxt.sealIcon.image.sprite = nil
	self.expTxt.sealIcon.image.enabled = false
	local nextVipCfg = ManagerContainer.CfgMgr:GetVipCfgById(curVipLv + 1)
	if nextVipCfg then
		CommonUtil.LoadIcon(self, nextVipCfg.SmallIcon, function(sprite)
			if sprite then
				self.expTxt.sealIcon.image.sprite = sprite
				self.expTxt.sealIcon.image.enabled = true
			end
		end)
	end
end

function UIVipView:RefreshExpView()
	local curVipLv = self.controller:GetCurVipLv()
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(curVipLv)

	if not vipCfg then
		self.expTxt:SetActive(false)
		self.expSlider:SetActive(false)
		return
	end

	local curVipExp = self.controller:GetCurVipExp()

	self.expTxt:SetActive(true)
	self.expSlider:SetActive(true)
	local nextVipCfg = ManagerContainer.CfgMgr:GetVipCfgById(curVipLv + 1)
	if nextVipCfg then
		self.expTxt.text.text = string.formatbykey('VipUpLv', tostring(vipCfg.VipExp - curVipExp), string.formatbykey(nextVipCfg.Name))
		self.expSlider.slider.value = Mathf.Clamp01(curVipExp / vipCfg.VipExp)
	else
		self.expTxt.text.text = string.formatbykey('VipUpLvMax')
		self.expSlider.slider.value = 1
	end
	self.number.text.text = tostring(curVipExp) .. '/' .. tostring(vipCfg.VipExp)
end

function UIVipView:RefreshBottomView()
	local vipLv = self.controller:GetCurShowVipLv()
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
	if not vipCfg then
		self.vipNameTxt.text.text = ''
		self.gainList.loopListView:SetListItemCount(0)
		CommonUtil.LoopGridViewEleCreateNew(self, self.rewardList.loopHorizontalScrollRect, nil, {}, 0, self, self.UpdateRewardItem)
		return
	end
	self.vipNameTxt.text.text = string.formatbykey(vipCfg.Name)
	self.gainList.loopListView:SetListItemCount(vipCfg.UnlockDes and #vipCfg.UnlockDes or 0)
	self.gainList.loopListView:RefreshAllShownItem()
	CommonUtil.LoopGridViewEleCreateNew(self, self.rewardList.loopHorizontalScrollRect, nil, vipCfg.Reward and vipCfg.Reward or {}, 0, self, self.UpdateRewardItem)
end

function UIVipView:RefreshSwitchButton()
	self.btnLeft:SetActive(self.controller:HasPrev())
	self.btnRight:SetActive(self.controller:HasNext())
end

function UIVipView:UpdateRewardItem(itemLua, itemIdx, itemData)
	if not itemLua or not itemData then return end
	CommonUtil.UpdateItemPrefab(self, itemLua.iconItem, {cfgId = itemData[1], num = itemData[2]}, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
	itemLua.check:SetActive(self.controller:IsReachLv())
end

function UIVipView:ShowItemTips(button, params)
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

function UIVipView:GetItemByIndex(loopListView, itemIndex)
	local vipLv = self.controller:GetCurShowVipLv()
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

function UIVipView:StartCheckCustomerService()
	self.btnCustomerService.gameObject:SetActive(false)
	local isShow = self.controller:IsShowCustomerVipLv()
	if not isShow then
		self:StopCheckCustomerService()
		return
	end
	if self.reqWWW then
		return
	end
	local url = PlatformPack.CUSTOMER_SERVICE_INFO_URL .. '?timesamp=' .. tostring(os.time())
	local platform = ManagerContainer.LuaGameMgr.platform
	if platform and platform ~= '' then
		url = url .. '&platform=' .. tostring(platform)
	end
	local subplatform = ManagerContainer.LuaGameMgr.channelName
	if subplatform and subplatform ~= '' then
		url = url .. '&sub_platform=' .. tostring(subplatform)
	end
	self.reqWWW = UnityEngine.WWW(url)
	if not self.checkReqWWWTimer then
		self.checkReqWWWTimer = FrameTimer.New(slot(self.CheckCustomerService, self), 1, -1)
	end
	if not self.checkReqWWWTimer.running then
		self.checkReqWWWTimer:Start()
	end
end

function UIVipView:StopCheckCustomerService()
	if self.reqWWW then
		self.reqWWW:Dispose()
		self.reqWWW = nil
	end
	if self.checkReqWWWTimer and self.checkReqWWWTimer.running then
		self.checkReqWWWTimer:Stop()
	end
end

function UIVipView:DisposeCheckCustomerService()
	self:StopCheckCustomerService()
	self.checkReqWWWTimer = nil
end

function UIVipView:CheckCustomerService()
	if not self.checkReqWWWTimer then
		self:StopCheckCustomerService()
		return
	end
	if self.reqWWW.isDone then
		local content = nil
		if not self.reqWWW.error or self.reqWWW.error == '' then
			content = self.reqWWW.text
		end
		self:StopCheckCustomerService()
		if content then
			local ok, result = RO_XPCALL(JSON.decode, debug.traceback, JSON, content)
			if ok then
				self.customerServiceData = result
				local infos = self:GetCustomerServiceInfos()
				self.btnCustomerService.gameObject:SetActive((infos ~= nil))
			else
				LogError('[wboy] CheckCustomerService Fail ' .. tostring(result))
			end
		end
	end
end

function UIVipView:GetCustomerServiceInfos()
	if not self.customerServiceData then
		return nil
	end
	if not self.customerServiceData.open then
		return nil
	end
	local datas = self.customerServiceData.infos
	if not datas or #datas <= 0 then
		return nil
	end
	return datas
end

return UIVipView

