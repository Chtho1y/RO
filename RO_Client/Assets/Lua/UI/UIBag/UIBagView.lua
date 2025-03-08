local UIBagView = require("UIBag/UIBagView_Generate")

local RectOffset = UnityEngine.RectOffset
local IconItemCtr = require("Common/IconItemCtr")

function UIBagView:OnAwake(data)
	self.controller = require("UIBag/UIBagCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIBagView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EQUIP_CHANGE, self, self.RefreshEquipDatas)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ITEM_CHANGE, self, self.RefreshItemDatas)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CARD_CHANGE, self, self.RefreshCardDatas)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.WISHBOX_SLOT_CHANGE, self, self.RefreshWishSlotData)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FILTER_NTF, self, self.RefreshCardDatasByFilter)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.WISHBOX_SLOT_SHOWANIMATION, self, self.PlayWishSlotAnimation)	
end

function UIBagView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIBagView:Init()
	self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self.toggleGroup.toggleGroup:SetAllTogglesOff()
	local bagViewPageType = self.controller:GetBagViewPageType()
	if bagViewPageType == Enum.BagViewPageType.Equip then
		self.toggleEquip.toggle.isOn = true
	elseif bagViewPageType == Enum.BagViewPageType.Item then
		self.toggleItems.toggle.isOn = true
	elseif bagViewPageType == Enum.BagViewPageType.Card then
		self.toggleCards.toggle.isOn = true
	elseif bagViewPageType == Enum.BagViewPageType.SkillEquip then
		self.toggleArtifact.toggle.isOn = true
	end
	-- self.isInit = false
	-- self.delayTimer = FrameTimer.New(function()
	-- 	self:InitData()
	-- end, 1)
	-- self.delayTimer:Start()
	self.controller:RefreshShowDataType()
	self:RefreshViewPage(true)
	self:RefreshWishSlotData()
	self:RefreshWishSlotAnim()

	self.delayTimer = FrameTimer.New(function()
		if bagViewPageType == Enum.BagViewPageType.Card then
			local lockStatus = ManagerContainer.UIFuncUnlockMgr:GetTargetFuncLockStatus(self, self.btnDecompose)
			if lockStatus then
				self.btnDecompose_lock:SetActive(lockStatus)
			end
			lockStatus = ManagerContainer.UIFuncUnlockMgr:GetTargetFuncLockStatus(self, self.btnProduce)
			if lockStatus then
				self.btnProduce_lock:SetActive(lockStatus)
			end
		else
			self.btnDecompose:SetActive(false)
			self.btnProduce:SetActive(false)
			self.btnDecompose_lock:SetActive(false)
			self.btnProduce_lock:SetActive(false)
		end
	end, 1)
	self.delayTimer:Start()
end
function UIBagView:RefreshWishSlotAnim()
	local wishSlotData = ManagerContainer.DataMgr.BagData:GetWishSlotData()
	if wishSlotData and #wishSlotData > 0 then
		for i = 1, #wishSlotData do
			local wishItem = self["wishSlot"..i]
			if wishItem then
				wishItem.wishShow:SetActive(true)
				wishItem.wishShow.animator:Play("WishShow",0,1.5)
			end
		end
	end
end

function UIBagView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIBagView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddToggleEventListener(self.toggleEquip.toggle, self, self.OnValueChangedToggle, Enum.BagViewPageType.Equip)
	self.uiBase:AddToggleEventListener(self.toggleItems.toggle, self, self.OnValueChangedToggle, Enum.BagViewPageType.Item)
	self.uiBase:AddToggleEventListener(self.toggleCards.toggle, self, self.OnValueChangedToggle, Enum.BagViewPageType.Card)
	self.uiBase:AddToggleEventListener(self.toggleArtifact.toggle, self, self.OnValueChangedToggle, Enum.BagViewPageType.SkillEquip)

	self.uiBase:AddButtonEventListener(self.btnBack.button, self, self.OnClickBackBtn)
	self.uiBase:AddButtonEventListener(self.btnDecompose.button, self, self.OnClickDecomposeBtn)
	self.uiBase:AddButtonEventListener(self.btnProduce.button, self, self.OnClickProduceBtn)
	self.uiBase:AddButtonEventListener(self.btnArtifactDecompose.button, self, self.OnArtifactDecomposeClick)
	self.uiBase:AddButtonEventListener(self.btnArtifactReforge.button, self, self.OnArtifactReforgeClick)

	self.uiBase:AddButtonEventListener(self.btnFilter.button, self, self.OnFilterClick)
end

function UIBagView:OnHide()
	-- if self.delayTimer then
	-- 	self.delayTimer:Stop()
	-- end
	-- self.delayTimer = nil
	-- self.isInit = nil
	-- local loopGridView = self.scrollView.loopGridView
	-- if loopGridView and self.defaultRectOffset then
	-- 	loopGridView:SetPadding(self.defaultRectOffset)
	-- end
	-- self.defaultRectOffset = nil

	if self.delayTimer then
		self.delayTimer:Stop()
	end
	self.delayTimer = nil
end

function UIBagView:OnShow(data)
	self.controller:SetData(data)
	self.scrollView.loopGridView:SetListItemCount(0, true)
	self.toggleGroup.toggleGroup:SetAllTogglesOff()
	local bagViewPageType = self.controller:GetBagViewPageType()
	if bagViewPageType == Enum.BagViewPageType.Equip then
		self.toggleEquip.toggle.isOn = true
	elseif bagViewPageType == Enum.BagViewPageType.Item then
		self.toggleItems.toggle.isOn = true
	elseif bagViewPageType == Enum.BagViewPageType.Card then
		self.toggleCards.toggle.isOn = true
	elseif bagViewPageType == Enum.BagViewPageType.SkillEquip then
		self.toggleArtifact.toggle.isOn = true
	end
	self.delayTimer = FrameTimer.New(function()
		if bagViewPageType == Enum.BagViewPageType.Card then
			local lockStatus = ManagerContainer.UIFuncUnlockMgr:GetTargetFuncLockStatus(self, self.btnDecompose)
			if lockStatus then
				self.btnDecompose_lock:SetActive(lockStatus)
			end
			lockStatus = ManagerContainer.UIFuncUnlockMgr:GetTargetFuncLockStatus(self, self.btnProduce)
			if lockStatus then
				self.btnProduce_lock:SetActive(lockStatus)
			end
		else
			self.btnDecompose:SetActive(false)
			self.btnProduce:SetActive(false)
			self.btnDecompose_lock:SetActive(false)
			self.btnProduce_lock:SetActive(false)
		end
	end, 1)
	self.delayTimer:Start()
	self.controller:RefreshShowDataType()
	self:RefreshViewPage(true)
end

function UIBagView:OnClose()
	self.scrollView.loopGridView:Dispose()
end

function UIBagView:PlayWishSlotAnimation(idx)
	local wishItem = self["wishSlot"..idx + 1]
	if wishItem then
		wishItem.wishShow.animator:Play("WishShow",0,0)
	end
end

function UIBagView:RefreshWishSlotData()
	local wishSlotData = ManagerContainer.DataMgr.BagData:GetWishSlotData()
	if not wishSlotData then
		self:DisposeRefreshTimer()
		return
	end
	local isNeedTimer = false
	for i = 1, #wishSlotData do
		local wishItem = self["wishSlot"..i]
		local wishData = wishSlotData[i]
		local currTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
		if wishItem then	
			local currEndTime = wishData.end_time * 1000 - currTime
			--wishItem.wishShow:SetActive(false)
			wishItem.lock:SetActive(not wishData.isOpen)
			wishItem.luckyLabel:SetActive(wishData.luckyItem ~= nil)
			wishItem.lucky:SetActive(wishData.isLucky)
			wishItem.iconSmallItem.gameObject:SetActive(wishData.item ~= nil)
			wishItem.times:SetActive(currEndTime > 0)
			if wishData.end_time > 0 then
				isNeedTimer = true
				local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(wishData.end_time * 1000)
				if remainTime >= 0 then
					wishItem.times.text.text.text = DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false)
				end
			end
			if wishData.item then
				local data = {cfgId = wishData.item.key,num = wishData.item.value}
				IconItemCtr:SetData(self, wishItem.iconSmallItem, data)
			end
			wishItem.iconSmallItem.redPoint:SetActive(wishData.end_time == 0 or currEndTime <= 0)
			self.uiBase:AddButtonUniqueEventListener(wishItem.button.button, self, self.OnWishSlotItemClick,i)
		end
	end
	if isNeedTimer then
		self:StartRefreshTimer()
	end
end
function UIBagView:GetShowItemByIdx(idx)
    local item = self.scrollView.loopGridView:GetShownItemByItemIndex(idx)
    if item then
        local itemlua = CommonUtil.GetBindGridViewItem2Lua(self, "IconItem", item.gameObject)
        return itemlua
    end
end

function UIBagView:StartRefreshTimer()
	local timer = self.refreshTimer
	if not timer then
		timer = Timer.New(slot(self.RefreshTimer,self), 1, -1)
		self.refreshTimer = timer
	end
	if not timer.running then
		timer:Start()
	end
end

function UIBagView:DisposeRefreshTimer()
	self:StopRefreshTimer()
	self.refreshTimer = nil
end

function UIBagView:OnWishSlotItemClick(btn,param)
	local wishSlotData = ManagerContainer.DataMgr.BagData:GetWishSlotData()
	if not wishSlotData then
		return
	end
	local idx = param[0]
	local wishItem = self["wishSlot"..idx]
	local wishData = wishSlotData[idx]
	if wishData then
		if wishData.isOpen then
			if wishData.item then
				local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(wishData.end_time * 1000)
				if 	remainTime <= 0 then
					ManagerContainer.DataMgr.BagData:SendWishAccelerateReq(idx - 1)
				else
					if wishData.src_item then
						local wishcfg = ManagerContainer.CfgMgr:GetWishCfgById(wishData.src_item)
						if wishcfg then
							local cost = wishcfg.AccelerateCost
							local txt =	DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false)
							local data = {cfgId = cost[1][1],needNum = cost[1][2],timeTxt = txt,idx = idx}
							ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGetNowPop,data)
						end
					end
				end
			else
				self:RefreshWishNoticeItem()
			end
		else
			local cfgdata = GlobalConfig.Instance:GetConfigStrValue(348)
			local costData =  CommonUtil.DeserializeGlobalStrToNumberTable(cfgdata)
			local costNum = costData[1][2]
			ManagerContainer.LuaUIMgr:ShowMessageBox("WishSlotUnlockTips",{costNum},nil,self,self.WishSlotUnlockSure,nil)
		end
	end
end

function UIBagView:RefreshWishNoticeItem()
	if self.wishNoticetimer  and self.wishNoticetimer.running then
		return
	end
	local showDatas = self.controller:GetAllShowDatas()
	if not self.NoticeItemList then
		self.NoticeItemList = {}
	end
	local refreshPos = nil
	local parentGo = self.noticeItemParent.transform
	if showDatas and #showDatas > 0 then
		for i = 1, #showDatas do
			local cfgData = ManagerContainer.CfgMgr:GetItemById(showDatas[i].cfgId)
			if cfgData  then
				if cfgData.ResType == Enum.ItemType.WishBox or cfgData.ResType == Enum.ItemType.OptionalWishBox then
					if not refreshPos then
						refreshPos = true
						local loopGridView = self.scrollView.loopGridView
						local length = self.controller:GetShowDataLength()
						loopGridView:RefreshListByIndex(length, i)
						if not self.wishNoticetimer then
							self.wishNoticetimer = Timer.New(slot(self.RefreshWishNoticeTimer,self), 2.5, 1)
							self.wishNoticetimer:Start()
						end
					end
					local itemLua = self:GetShowItemByIdx(i - 1)
					if itemLua then
						local newGo = UnityEngine.GameObject.Instantiate(self.bagNoticeItem.gameObject)
						newGo:SetActive(true)
						newGo.transform:SetParent(parentGo)
						newGo.transform.localScale = Vector3.New(1,1,1)
						newGo.transform.position = itemLua.transform.position
						table.insert(self.NoticeItemList,newGo)
					end
				end
			end
		end
	end
	if not refreshPos then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NoWishBox")
	end
end

function UIBagView:RefreshWishNoticeTimer()
	if self.NoticeItemList then
		for i = 1, #self.NoticeItemList do
			local go = self.NoticeItemList[i]
			if go then
				CommonUtil.DestroyGO(go)
			end
		end
		self.NoticeItemList = nil
	end
	if self.wishNoticetimer then
		self.wishNoticetimer:Stop()
	end
	self.wishNoticetimer = nil
end

function UIBagView:WishSlotUnlockSure()
	--确认解锁数据是否足够
	local cfgdata = GlobalConfig.Instance:GetConfigStrValue(348)
	local costData =  CommonUtil.DeserializeGlobalStrToNumberTable(cfgdata)
	local costId = costData[1][1]
	local costNum = costData[1][2]
	local hasNum = CommonUtil.GetOwnResCountByItemId(costId)
	if hasNum >= costNum then
		ManagerContainer.DataMgr.BagData:SendWishSlotUnlockReq()
	else
		CommonUtil.ItemNotEnoughHandle(costId)
	end
end

function UIBagView:RefreshTimer()
	local wishSlotData = ManagerContainer.DataMgr.BagData:GetWishSlotData()
	if not wishSlotData then
		self:DisposeRefreshTimer()
		return
	end
	local minEndTime = nil
	for i = 1, #wishSlotData do
		if not minEndTime then
			minEndTime = wishSlotData[1].end_time
		else
			if wishSlotData[i].end_time > 0 and minEndTime > wishSlotData[i].end_time then
				minEndTime =  wishSlotData[i].end_time
			end
		end
	end
	for i = 1, #wishSlotData do
		local wishData = wishSlotData[i]
		local wishItem = self["wishSlot"..i]
		if wishItem then
			if wishData.end_time > 0 then
				local endTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(wishData.end_time * 1000)
				if endTime >= 0 then
					wishItem.times.text.text.text = DateTimeUtil.convertSeconds2TimeStr1(endTime, true, true, false)
				else
					wishItem.times:SetActive(false)
				end
			end
		end
	end
	if not minEndTime then
		return
	end
	local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(minEndTime * 1000)
	if not remainTime or remainTime <= 0 then
		self:RefreshWishSlotData()
	else
		if self.refreshTimer then
			local validTime = nil
			if remainTime >= 86400 then
				validTime = remainTime % 3600
				if validTime == 0 then validTime = 3600 end
			elseif remainTime >= 3600 then
				validTime = remainTime % 60
				if validTime == 0 then validTime = 60 end
			else
				validTime = 1
			end
			if validTime then
				self.refreshTimer.duration = validTime
			else
				self:StopRefreshTimer()
			end
		end
	end
end

function UIBagView:StopRefreshTimer()
	if self.refreshTimer then
		self.refreshTimer:Stop()
	end
end

function UIBagView:OnDispose()
	-- if self.inited then
	-- 	if self.delayTimer then
	-- 		self.delayTimer:Stop()
	-- 	end
	-- 	self.delayTimer = nil
	-- 	self.isInit = nil
	-- 	local loopGridView = self.scrollView.loopGridView
	-- 	loopGridView:Dispose()
	-- 	if self.defaultRectOffset then
	-- 		loopGridView:SetPadding(self.defaultRectOffset)
	-- 	end
	-- 	self.defaultRectOffset = nil
	-- end
	-- self.scrollView.loopGridView:Dispose()
	if self.delayTimer then
		self.delayTimer:Stop()
	end
	self.delayTimer = nil
	if self.NoticeItemList then
		for i = 1, #self.NoticeItemList do
			local go = self.NoticeItemList[i]
			if go then
				CommonUtil.DestroyGO(go)
			end
		end
		self.NoticeItemList = nil
	end
	if self.wishNoticetimer then
		self.wishNoticetimer:Stop()
	end
	self.wishNoticetimer = nil
	if self.wishShowtimer then
		self.wishShowtimer:Stop()
	end
	self.wishShowtimer = nil
	self:DisposeRefreshTimer()
end

function UIBagView:GetItemByRowColumn(gridView, itemIndex, row, column)
	-- local length = self.controller:GetShowDataLength()
	-- if (itemIndex < 0 or itemIndex >= length) then
	-- 	return nil
	-- end
	local showData = self.controller:GetShowData(itemIndex)
	local item = nil
	if showData then
		item = gridView:NewListViewItem('IconItem')
		local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'IconItem', item.gameObject)
		CommonUtil.UpdateItemPrefab(self, itemlua, showData, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
	else
		item = gridView:NewListViewItem('IconEmptyItem')
	end
	return item
end

function UIBagView:RefreshEquipDatas()
	self:RefreshDatas(Enum.BagViewPageType.Equip)
end

function UIBagView:RefreshItemDatas()
	self:RefreshDatas(Enum.BagViewPageType.Item)
end

function UIBagView:RefreshCardDatas()
	self:RefreshDatas(Enum.BagViewPageType.Card)
end

function UIBagView:RefreshCardDatasByFilter(uiId, data, isFilter)
	if uiId ~= self.uiData.id then return end

	self.controller:SetFilterData(data, isFilter)
	self:RefreshDatas(Enum.BagViewPageType.Card)
end

function UIBagView:RefreshDatas(bagViewPageType)
	self.controller:RefreshViewDatas(bagViewPageType)
	if self.controller:GetBagViewPageType() == bagViewPageType then
		self:RefreshViewPage()
	end
end

-- function UIBagView:InitData()
-- 	local loopGridView = self.scrollView.loopGridView
-- 	local itemSize = loopGridView.ItemSize
-- 	local itemPadding = loopGridView.ItemPadding
-- 	local padding = loopGridView.Padding
-- 	local itemSizeWithPadding = itemPadding + itemSize
-- 	local width = loopGridView.ViewPortWidth - padding.left - padding.right + itemPadding.x
-- 	local height = loopGridView.ViewPortHeight - padding.top
-- 	local row = Mathf.Floor(width / (itemSizeWithPadding.x))
-- 	local column = Mathf.Ceil(height / (itemSizeWithPadding.y))
-- 	local realWidth = row * itemSizeWithPadding.x
-- 	local offset = width - realWidth
-- 	if offset > 0 then
-- 		offset = offset * 0.5
-- 		local newPadding = RectOffset(offset + padding.left, offset + padding.right, padding.top, padding.bottom)
-- 		loopGridView:SetPadding(newPadding)
-- 	end
-- 	loopGridView:SetGridFixedGroupCount(SuperScrollView.GridFixedType.ColumnCountFixed, row)
-- 	self.defaultRectOffset = padding
-- 	self.isInit = true
-- 	self.controller:SetGridRowColumn(row, column)
-- 	self.controller:RefreshShowDataType()
-- 	self:RefreshViewPage(true)
-- end

function UIBagView:RefreshViewPage(resetPos)
	-- if not self.isInit then return end
	local bagViewPageType = self.controller:GetBagViewPageType()
	if self.NoticeItemList then
		for i = 1, #self.NoticeItemList do
			local go = self.NoticeItemList[i]
			if go then
				CommonUtil.DestroyGO(go)
			end
		end
		self.NoticeItemList = nil
	end

	self.btnFilter:SetActive(bagViewPageType == Enum.BagViewPageType.Card)
	self.btnArtifactDecompose:SetActive(bagViewPageType == Enum.BagViewPageType.SkillEquip)
	self.btnArtifactReforge:SetActive(bagViewPageType == Enum.BagViewPageType.SkillEquip)
	self.wishBox:SetActive(bagViewPageType == Enum.BagViewPageType.Item)
	if bagViewPageType == Enum.BagViewPageType.Equip then
		-- 装备
		self.btnDecompose:SetActive(false)
		self.btnProduce:SetActive(false)
		self.btnDecompose_lock:SetActive(false)
		self.btnProduce_lock:SetActive(false)
		
	elseif bagViewPageType == Enum.BagViewPageType.Item then
		-- 道具
		self:RefreshWishSlotAnim()
		self.btnDecompose:SetActive(false)
		self.btnProduce:SetActive(false)
		self.btnDecompose_lock:SetActive(false)
		self.btnProduce_lock:SetActive(false)
	elseif bagViewPageType == Enum.BagViewPageType.Card then
		-- 卡片
		local lockStatus = ManagerContainer.UIFuncUnlockMgr:GetTargetFuncLockStatus(self, self.btnDecompose)
		self.btnDecompose:SetActive(not lockStatus)
		if lockStatus then
			self.btnDecompose_lock:SetActive(lockStatus)
		end
		lockStatus = ManagerContainer.UIFuncUnlockMgr:GetTargetFuncLockStatus(self, self.btnProduce)
		self.btnProduce:SetActive(not lockStatus)
		if lockStatus then
			self.btnProduce_lock:SetActive(lockStatus)
		end
	elseif bagViewPageType == Enum.BagViewPageType.SkillEquip then
		-- 神器
		self.btnDecompose:SetActive(false)
		self.btnProduce:SetActive(false)
		self.btnDecompose_lock:SetActive(false)
		self.btnProduce_lock:SetActive(false)

		self.btnArtifactDecompose:SetActive(true)
	end
	local loopGridView = self.scrollView.loopGridView
	local length = self.controller:GetShowDataLength()
	if resetPos then
		loopGridView:RefreshListByIndex(length, 0)
	else
		loopGridView:RefreshListByIndex(length)
	end

	self.btnFilter.check:SetActive(self.controller:GetIsFilter())
end

function UIBagView:ShowItemTips(button, params)
	local bagViewPageType = self.controller:GetBagViewPageType()
	if bagViewPageType == Enum.BagViewPageType.SkillEquip then
		local data = params[0]
		local params = {{cfgId = data.cfgId, jobType = data.JobType, logicData = data}, Enum.ItemIEnterType.SkillEquip, self.uiData.id}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIArtifactTips, params)
	else
		local data = clone(params[0])
		data.displayBtn = true
		data.source = self.uiData.id
		local _extData = {_id = data.id, cfgId = data.cfgId}
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(data.cfgId)
		if itemCfgData and itemCfgData.SkipInterface > 0 and itemCfgData.ResType ~= Enum.ItemType.Gift then
			if data.state == nil then data.state = 0 end
	
			data.state = Bit.bor(data.state, Bit.lshift(1, Enum.TipsEnterType.BtnGoto)) --data.state + CommonUtil.Get2Powers(Enum.TipsEnterType.BtnGoto)
		end
		ManagerContainer.LuaUIMgr:OpenTips(data, _extData)
	end
end

function UIBagView:OnValueChangedToggle(toggle, bagViewPageType, isOn)
	if not isOn then return end
	if self.controller:SetBagViewPageType(bagViewPageType) then
		self:RefreshViewPage(true)
	end
end

function UIBagView:OnClickBackBtn()
	-- 酒馆按钮打开的界面，不能直接关闭，暂时屏蔽关闭
	-- if ManagerContainer.FSMMgr:IsMainCityState() then
	-- 	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Town)
	-- else
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Adventure)
	-- end
end

function UIBagView:OnClickDecomposeBtn()
	if self.controller:GetBagViewPageType() ~= Enum.BagViewPageType.Card then
		return
	end
	self:UIHide()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardList, Enum.CardFuncType.Compose)
end

function UIBagView:OnClickProduceBtn()
	if self.controller:GetBagViewPageType() ~= Enum.BagViewPageType.Card then
		return
	end
	self:UIHide()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardList, Enum.CardFuncType.Recreate)
end

function UIBagView:OnArtifactDecomposeClick()
	if self.controller:GetBagViewPageType() ~= Enum.BagViewPageType.SkillEquip then
		return
	end
	self:UIHide()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetDecompose, 2, self.uiData.id)
end

function UIBagView:OnArtifactReforgeClick()
	if self.controller:GetBagViewPageType() ~= Enum.BagViewPageType.SkillEquip then
		return
	end
	self:UIHide()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIArtifactReforge, nil, self.uiData.id)
end

function UIBagView:OnFilterClick()
	local data = {uiId = self.uiData.id, enter = Enum.ItemIEnterType.Bag, filterData = self.controller:GetFilterData()}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFilter, data)
end

--强制引导
function UIBagView:FindBagFirstCard(owner, ownerCB)
	local target
	local item = self.scrollView.loopGridView:GetShownItemByRowColumn(0, 0)
	if item.ItemPrefabName == "IconItem" then
		target = item.transform:Find("bg").gameObject
	end
	if target == nil then
		if owner and ownerCB then
			ownerCB(owner)
			return
		end
	end

	if owner and ownerCB then
		ownerCB(owner, target)
		return
	end
end

return UIBagView

