local UIWorldBossListView = require("UIWorldBoss/UIWorldBossListView_Generate")

function UIWorldBossListView:OnAwake(data)
	self.controller = require("UIWorldBoss/UIWorldBossListCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIWorldBossListView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.WORLD_BOSS_LIST_CHANGED, self, self.OnWorldBossListChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.WORLD_BOSS_CHALLENGE_COUNT_CHANGED, self, self.OnWorldBossChallengeCountChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VIP_LV_CHANGED, self, self.OnVipLvChanged)
end

function UIWorldBossListView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIWorldBossListView:Init()
	self.controller:InitData()
	self:InitList()
	self:RefreshList()
	self:RefreshChallengeCount()
end

function UIWorldBossListView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIWorldBossListView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	self.uiBase:AddButtonEventListener(self.btnBack.button, self, self.OnClickBackBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnClickBackBtn)
	self.uiBase:AddButtonEventListener(self.btnRefresh.button, self, self.OnClickRefreshBtn)
	self.uiBase:AddButtonEventListener(self.btnPlayRule.button, self, self.OnClickPlayRuleBtn)
end

function UIWorldBossListView:OnHide()
	-- if self.updateTimer then
	-- 	self.updateTimer:Stop()
	-- end
	-- self.updateTimer = nil
	-- self.controller:ClearWorldBossList()
end

function UIWorldBossListView:OnShow(data)
	self.controller:SetData(data)
	-- self:RefreshList()
	-- self:RefreshChallengeCount()
end

function UIWorldBossListView:OnClose()

end

function UIWorldBossListView:OnDispose()
	local loopGridView = self.list.loopGridView
	loopGridView:Dispose()
	if self.updateTimer then
		self.updateTimer:Stop()
	end
	self.updateTimer = nil
end

function UIWorldBossListView:OnWorldBossListChanged()
	self.controller:RefreshWorldBossList()
	self:RefreshList()
end

function UIWorldBossListView:OnWorldBossChallengeCountChanged()
	self.controller:RefreshMaxCount()
	self:RefreshChallengeCount()
end

function UIWorldBossListView:OnVipLvChanged()
	self.controller:RefreshMaxCount()
	self:RefreshChallengeCount()
end

function UIWorldBossListView:InitList()
	self.list.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	if self.updateTimer then
		self.updateTimer:Stop()
	end
	self.updateTimer = nil
	self.updateTimer = Timer.New(function()
		self:UpdateCheckTimer()
	end, 1, -1)
	self.updateTimer:Start()
end

function UIWorldBossListView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local itemData = self.controller:GetWorldBossByItemIndex(itemIndex)
	if not itemData then
		return nil
	end
	local item = gridView:NewListViewItem('WorldBossItem')
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'WorldBossItem', item.gameObject)
	itemlua.bossImage.image.sprite = nil
	itemlua.bossImage.image.enabled = false
	local bossId = itemData.bossId
	local bosstype = itemData.boss_summon_type
	local worldBossCfgData = ManagerContainer.DataMgr.WorldBossData:GetWorldBossDataById(bossId,bosstype)
	local rewardDatas = nil
	local lockLevelId = nil
	if worldBossCfgData then
		CommonUtil.LoadIcon(self, worldBossCfgData.BossPicture, function (sprite)
			itemlua.bossImage.image.sprite = sprite
			itemlua.bossImage.image.enabled = true
		end, itemlua, "WorldBossItemIconAsyncIdx")

		lockLevelId = worldBossCfgData.Tiaozhantiaojian
		rewardDatas = worldBossCfgData.FirstReward

		local summonId = itemData.cfgId
        local npcCfgData = ManagerContainer.CfgMgr:GetNpcCfgById(summonId)
        if npcCfgData then
            itemlua.bossName.text.text = I18N.SetLanguageValue(npcCfgData.Name)
        else
			LogError('[Wboy] Can not find Npc ' .. tostring(summonId))
        end
	else
		LogError('[Wboy] Can not find WorldBoss ' .. tostring(bossId))
	end
	self:RefreshItemRewards(itemlua, rewardDatas)

	itemlua.btnChallengeCoast:SetActive(false)
	itemlua.btnChallenge:SetActive(false)

	if lockLevelId then		
		local locked = true
		local curLevelId = self.controller:GetCurLevelId()
		if curLevelId then
			locked = (curLevelId < lockLevelId)
		end
		if locked then
			local levelName = ''
			local levelCfgData = ManagerContainer.CfgMgr:GetLevelDataById(lockLevelId)
			if levelCfgData then
				levelName = I18N.T(levelCfgData.Name)
			end
			itemlua.textLock.uILocalizeScript:SetContentAndValues('FunUnLock11', {levelName})
			itemlua.lock:SetActive(true)
			itemlua.hp:SetActive(false)
			itemlua.btnChallenge:SetActive(false)
			itemlua.leaveTimer:SetActive(false)
			itemlua.labelLeave:SetActive(false)
			itemlua.reviveTimer:SetActive(false)
			CommonUtil.NeedUIGray(itemlua.bossImage.image, false)
			return item
		end
	end

	local isLeaving = false
	local isEnter = false
	if itemData.expireTime and itemData.expireTime > 0 then
		isLeaving = true
		isEnter = false
	elseif itemData.nextTime and itemData.nextTime > 0 then
		isLeaving = false
		isEnter = true
	end
	if isLeaving then
		local button
		local ItemId = 0
		local CostNum = 0
		if worldBossCfgData.Consume then		
			button = itemlua.btnChallengeCoast	
			ItemId = worldBossCfgData.Consume[1][1]
			CostNum =  worldBossCfgData.Consume[1][2]
			itemlua.CostNum.text.text = tostring(CostNum)
			local itemCfgData = ManagerContainer.CfgMgr:GetItemById(ItemId)
			CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function (sprite)
				itemlua.CostIcon.image.sprite = sprite
			end)
		else			
			button = itemlua.btnChallenge
		end		
		button:SetActive(true)
		button.button.interactable = (not itemData.isFight)
		if not itemData.isFight then
			self.uiBase:AddButtonUniqueEventListener(button.button, self, self.OnClickChallengeBtn, itemIndex,ItemId,CostNum)
		end
	end

	itemlua.lock:SetActive(false)

	itemlua.hp:SetActive(true)
	local precent = (itemData.curHp / itemData.totalHp)
	local precentVaild = CommonUtil.GetPreciseDecimalFloor(precent * 100, 2)
	if precentVaild <= 0 and itemData.curHp > 0 then
		precentVaild = 0.01
	end
	itemlua.bossHP.text.text = tostring(precentVaild) .. '%'
	itemlua.slider.slider.value = precent

	itemlua.leaveTimer:SetActive(isLeaving)
	itemlua.labelLeave:SetActive(isEnter)
	itemlua.reviveTimer:SetActive(isEnter)
	CommonUtil.NeedUIGray(itemlua.bossImage.image, isEnter)
	self:UpdateItemLuaTime(itemlua, itemData)
	return item
end

function UIWorldBossListView:RefreshItemRewards(itemlua, rewardDatas)
	local index = 1
	if rewardDatas then
		if type(rewardDatas[1]) == 'number' then
			rewardDatas = {rewardDatas}
		end
		local rewardNum = Mathf.Min(#rewardDatas, 3)
		for i = 1, rewardNum do
			local slot = itemlua['slot' .. index]
			if slot then
				local itemCfgId = rewardDatas[i][1]
				local itemCfgData = ManagerContainer.CfgMgr:GetItemById(itemCfgId)
				if itemCfgData then
					slot:SetActive(true)
					local itemNum = rewardDatas[i][2]
					local logicData = {cfgId = itemCfgId, num = itemNum}
					CommonUtil.UpdateItemPrefab(self, slot.iconSmallItem, logicData, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
					index = index + 1
				end
			end
		end
	end
	for i = index, 3 do
		local slot = itemlua['slot' .. i]
		if slot then
			slot:SetActive(false)
		end
	end
end

function UIWorldBossListView:ShowItemTips(button, params)
	local data = params[0]
	--ManagerContainer.LuaUIMgr:OpenItemTips(data.cfgId, nil, data)
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIWorldBossListView:RefreshList()
	local worldBossDatas = self.controller:GetWorldBossList()
	local num = worldBossDatas and #worldBossDatas or 0
	if num <= 0 then
		self.list.loopGridView:SetListItemCount(0, true)
		self.noBoss:SetActive(true)
		return
	end
	self.noBoss:SetActive(false)
	self.list.loopGridView:RefreshListByIndex(num, 0)
end

function UIWorldBossListView:RefreshChallengeCount()
	local count = self.controller:GetChallengeCount() or 0
	local maxCount = self.controller:GetMaxCount() or 0
	if maxCount < count then
		maxCount = count
	end
	self.num.text.text = string.formatbykey('DscFightTimes', (maxCount - count))
end

function UIWorldBossListView:UpdateCheckTimer()
	local worldBossDatas = self.controller:GetWorldBossList()
	if not worldBossDatas then return end
	local num = #worldBossDatas
	if num <= 0 then return end
	local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	local nextUpdateTime = nil
	for i = 1, num do
		nextUpdateTime = self.controller:GetNextUpdateTime(i)
		if nextUpdateTime == nil or (int64.__lt(0, nextUpdateTime) and int64.__le(nextUpdateTime, curTime)) then
			local worldBossData = worldBossDatas[i]
			-- 需要更新时间
			self.controller:RefreshNextUpdateTime(worldBossData, i, curTime)
			self:UpdateItemShowTime(i, worldBossData, curTime)
		end
	end
end

function UIWorldBossListView:UpdateItemShowTime(i, worldBossData, curTime)
	if not worldBossData then return end
	local item = self.list.loopGridView:GetShownItemByItemIndex(i - 1)
	if not item then return end
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'WorldBossItem', item.gameObject)
	if not itemlua then return end
	self:UpdateItemLuaTime(itemlua, worldBossData, curTime)
end

function UIWorldBossListView:UpdateItemLuaTime(itemlua, worldBossData, curTime)
	if not itemlua then return end
	if not worldBossData then return end
	if not curTime then curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime() end
	local remainTime = 0
	if int64.__lt(0, worldBossData.expireTime) then
		remainTime = (worldBossData.expireTime - curTime) / 1000
		remainTime = type(remainTime) == "number" and remainTime or #remainTime
		remainTime = Mathf.Ceil(remainTime)
		if remainTime / 60 >= 1 then
			itemlua.leaveTimer.text.text.text = I18N.SetLanguageValue('OutTime1', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true))
		else
			itemlua.leaveTimer.text.text.text = I18N.SetLanguageValue('OutTime2')
		end
	elseif int64.__lt(0, worldBossData.nextTime) then
		remainTime = (worldBossData.nextTime - curTime) / 1000
		remainTime = type(remainTime) == "number" and remainTime or #remainTime
		remainTime = Mathf.Ceil(remainTime)
		itemlua.reviveTimer.text.text.text = I18N.SetLanguageValue('InTime1', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true))
	end
end

function UIWorldBossListView:OnClickChallengeBtn(btn, params)
	local itemIndex = params[0]
	local CostitemId = params[1]
	local ItemCostCount = params[2]
	local itemData = self.controller:GetWorldBossByItemIndex(itemIndex)
	if not itemData then return end
	if CostitemId > 0 then
		local CurItemCount =  CommonUtil.GetOwnResCountByItemId(CostitemId)
		if CurItemCount < ItemCostCount then
			CommonUtil.PopErrorTips("WorldBossChangePlay")
			return
		end
	end
	self.controller:SendChallengeBossReq(itemData.bossId, itemData.bossSummonIdx)
end

function UIWorldBossListView:OnClickBackBtn()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
	-- self:UIClose()
end

function UIWorldBossListView:OnClickRefreshBtn()
	local errorCode = self.controller:SendRefreshBossListReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(100007)
	end
end

function UIWorldBossListView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'WorldBossPlayExplain'})
end

return UIWorldBossListView