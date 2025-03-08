local UIExpeditionDungeonInfoView = require("UIExpedition/UIExpeditionDungeonInfoView_Generate")

function UIExpeditionDungeonInfoView:OnAwake(data)
	self.controller = require("UIExpedition/UIExpeditionDungeonInfoCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIExpeditionDungeonInfoView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Expedition_RefreshData,self,self.RefreshData)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Expedition_ResetData,self,self.OnExpeditionResetData)
end

function UIExpeditionDungeonInfoView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIExpeditionDungeonInfoView:Init()
	self:InitListView()
	self:ShowLevelBg()
	self:SetLevelData()
	self:ShowLevelRewards()
	self:RefreshTeamHPStatus()
end

function UIExpeditionDungeonInfoView:InitListView()
	self.boxScrollList.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIExpeditionDungeonInfoView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIExpeditionDungeonInfoView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.nextLevelBtn.button,self, self.OnClickNextLevel)
	self.uiBase:AddButtonEventListener(self.lastLevelBtn.button,self, self.OnClickLastLevel)
	self.uiBase:AddButtonEventListener(self.getAllRewardBtn.button,self, self.OnClickGetAllReward)
	self.uiBase:AddButtonEventListener(self.arrangeBtn.button,self, self.OnClickArrangeBtn)
	self.uiBase:AddButtonEventListener(self.skillBtn.button,self, self.OnClickSkillBtn)
	self.uiBase:AddButtonEventListener(self.petBtn.button,self, self.OnClickPetBtn)
	self.uiBase:AddButtonEventListener(self.blessBtn.button,self, self.OnClickBlessBtn)
end

function UIExpeditionDungeonInfoView:OnHide()
	--self.boxScrollList.loopGridView:Dispose()
end

function UIExpeditionDungeonInfoView:OnShow(data)
	self.controller:SetData(data)

end

function UIExpeditionDungeonInfoView:OnClose()
	self.boxScrollList.loopGridView:Dispose()
	self.levelDatas = nil
end

function UIExpeditionDungeonInfoView:OnDispose()
	self.controller:OnDispose()
end

function UIExpeditionDungeonInfoView:RefreshData(isSingleReward)
	self:SetLevelData()
	self:ShowLevelRewards(isSingleReward)
	self:RefreshTeamHPStatus()
end

function UIExpeditionDungeonInfoView:ShowLevelBg()
	local mapData = self.controller:GetMapData()
	if mapData.levelBg ~= nil and mapData.levelBg ~= "" then
		CommonUtil.LoadIcon(self, mapData.levelBg, function (sprite)
			self.levelBg.image.sprite = sprite
		end)
	end
end

function UIExpeditionDungeonInfoView:OnExpeditionResetData()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIExpeditionArrange)
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UISkillSettings)
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIPetBattle)
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIExpeditionBless)
	self:UIClose()
end

function UIExpeditionDungeonInfoView:RefreshTeamHPStatus()
	local totalHPPercent = 0
	local hasDead = false
	local heroIds = ManagerContainer.DataMgr.ExpeditionDataMgr:GetCurrBattleTeamMembers()
	if #heroIds > 0 then
		for i = 1, #heroIds do
			local hpPercent,spPercent = ManagerContainer.DataMgr.ExpeditionDataMgr:GetHeroHPAndSP(heroIds[i])
			if hpPercent == 0 then
                hasDead = true
            end
			totalHPPercent = totalHPPercent + hpPercent
		end
		totalHPPercent = totalHPPercent / #heroIds
	end

	self.arrangeBtn.hpTipsNode.tips.text.text = string.format('%.1f', totalHPPercent) .. "%"
	if hasDead then
        self.arrangeBtn.hpTipsNode.healthFlag:SetActive(false)
        self.arrangeBtn.hpTipsNode.warningFlag:SetActive(false)
        self.arrangeBtn.hpTipsNode.deadFlag:SetActive(true)
        self.arrangeBtn.hpTipsNode.tips:SetActive(false)
    else
        if totalHPPercent >= 90 then
            self.arrangeBtn.hpTipsNode.healthFlag:SetActive(true)
            self.arrangeBtn.hpTipsNode.warningFlag:SetActive(false)
            self.arrangeBtn.hpTipsNode.deadFlag:SetActive(false)
			self.arrangeBtn.hpTipsNode.tips:SetActive(true)
			self.arrangeBtn.hpTipsNode.tips.text.color = Color.New(0, 177/255, 101/255, 1)
        else
            self.arrangeBtn.hpTipsNode.healthFlag:SetActive(false)
            self.arrangeBtn.hpTipsNode.warningFlag:SetActive(true)
            self.arrangeBtn.hpTipsNode.deadFlag:SetActive(false)
			self.arrangeBtn.hpTipsNode.tips:SetActive(true)
			self.arrangeBtn.hpTipsNode.tips.text.color = Color.New(1, 150/255, 0, 1)
        end
    end
end

function UIExpeditionDungeonInfoView:SetLevelData()
	local mapData = self.controller:GetMapData()
	local curLevelId = ManagerContainer.DataMgr.ExpeditionDataMgr:GetCurLevelId()
	if mapData.isPassed then
		curLevelId = mapData.maxLevelNum
	end
	
	local bossList = ManagerContainer.DataMgr.ExpeditionDataMgr:GetBossList()
	local challengeBossSlot = ManagerContainer.DataMgr.ExpeditionDataMgr:ChanllengeSlotIdx() 
	local levelData = mapData:FindLevelByLevelId(curLevelId)
	local deltaLevel = mapData:GetNextGoodRewardLevel(curLevelId)

	if deltaLevel > 0 then
		self.tipsTxt.text.text = string.formatbykey("ExpeditionBox",deltaLevel)
	else
		self.tipsTxt.text.text = string.formatbykey("ExpeditionBigBox")
	end
	self.title.text.text = mapData.name
	self.curLevelTxt.text.text = tostring(curLevelId) .. "/" .. mapData.maxLevelNum
	
	local CurScore = ManagerContainer.DataMgr.ExpeditionDataMgr:GetCurScore()
	local MaxScore = ManagerContainer.DataMgr.ExpeditionDataMgr:GetMaxScore()
	local CurLevelScore = levelData:GetScore()
	self.score1.number.text.text = tostring(CurLevelScore)
	self.score2.number.text.text = tostring(MaxScore)
	self.score3.number.text.text = tostring(CurScore)

	for i = 1, 3 do
		local bossItem = self:GetBossItem(i)
		bossItem:SetActive(false)
	end

	if mapData.isPassed then
		self.passedNode:SetActive(true)
	else
		self.passedNode:SetActive(false)
		if challengeBossSlot>= 1 and challengeBossSlot<=3  then
			local bossMaxHP,bossMaxSp = levelData:GetBossMaxHPAndSp(bossList[challengeBossSlot].id)
			local bossCfg = ManagerContainer.CfgMgr:GetNpcCfgById(bossList[challengeBossSlot].id)
			if bossCfg ~= nil then
				local hpPercent = bossList[challengeBossSlot].hp / bossMaxHP
				self:SetBossData(self:GetBossItem(challengeBossSlot),bossCfg,hpPercent,challengeBossSlot,bossList[challengeBossSlot].id)
			end
		else			
			for i = 1, #bossList do
				local bossInfo = bossList[i]
				local bossCfg = ManagerContainer.CfgMgr:GetNpcCfgById(bossInfo.id)
				if bossCfg ~= nil then
					self:SetBossData(self:GetBossItem(i),bossCfg,1,i,bossInfo.id)
				end
			end
		end
	end
end

function UIExpeditionDungeonInfoView:SetBossData(bossItemLua,bossCfg,hpPercent,bossSlotIdx,BossId)
	bossItemLua.bossName.text.text = bossCfg.Name
	bossItemLua.hpProgress.slider.value = hpPercent
	--boss 积分
	local CurBossScore = ManagerContainer.DataMgr.ExpeditionDataMgr:GetCurBossScore(BossId)
	bossItemLua.scoreTxt.text.text = "+"..tostring(CurBossScore)

	if bossCfg.Icon~= nil then
		CommonUtil.LoadIcon(self, bossCfg.Icon, function (sprite)
			bossItemLua.bossImg.image.sprite = sprite
			bossItemLua.bossImg.image:SetNativeSize()
			if bossCfg.IconOffset~= nil then
				local offset = Vector2(bossCfg.IconOffset[1],bossCfg.IconOffset[2])
				bossItemLua.bossImg.rectTransform.anchoredPosition = offset
			end	
		end)
	end
		
	local natureCfg = ManagerContainer.CfgMgr:GetNatureDataById(bossCfg.NatureId)
	if natureCfg ~= nil and natureCfg.Icon~=nil then
		CommonUtil.LoadIcon(self, natureCfg.Icon, function (sprite)
			bossItemLua.natureImg.image.sprite = sprite
		end)
	end

	self.uiBase:AddButtonUniqueEventListener(bossItemLua.challengeBtn.button,self, self.OnClickChallengeBoss,bossSlotIdx)
	self.uiBase:AddButtonUniqueEventListener(bossItemLua.bossImg.button,self, self.OnClickViewBossDetail,bossSlotIdx)
	bossItemLua:SetActive(true)
end

function UIExpeditionDungeonInfoView:OnClickViewBossDetail(btn,params)
	local bossList = ManagerContainer.DataMgr.ExpeditionDataMgr:GetBossList()
	local bossSlotIdx = params[0]
	local bossData = bossList[bossSlotIdx]
	local bossActor = ActorData.CreateNpcPlayerActor(0,bossData.id,bossData.level)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleBossTips,bossActor)
end

function UIExpeditionDungeonInfoView:GetBossItem(idx)
	if idx == 1 then
		return self.bossItem1
	elseif idx == 2 then
		return self.bossItem2
	else
		return self.bossItem3
	end
end

function UIExpeditionDungeonInfoView:RefreshRewards(isSingleReward)
	self.controller:RefreshMapData()
	local mapData = self.controller:GetMapData()
	if self.levelDatas == nil then
		self.levelDatas = {}
	end
	if mapData.allLevels ~= nil then
		for _,v in pairs(mapData.allLevels) do
			self.levelDatas[v.levelId] = v
		end
	end

	local loopGridView = self.boxScrollList.loopGridView
	local length = #self.levelDatas
	if not isSingleReward then
		loopGridView:SetListItemCount(length, true)
	else
		loopGridView:RefreshListByIndex(length)
	end
	loopGridView:RefreshAllShownItem()
	self.onekeyRP:SetActive(mapData:HasRedPoint())
end

function UIExpeditionDungeonInfoView:ShowLevelRewards(isSingleReward)
	local curLevelId = self.controller:GetCurLevelId()
	local mapData = self.controller:GetMapData()
	--local startLevelId = curLevelId
	--if (curLevelId+5) > mapData.maxLevelNum then
	--	startLevelId = mapData.maxLevelNum - 5
	--else
	--	if math.fmod(curLevelId, 5) > 0 then
	--		startLevelId =  curLevelId - math.fmod(curLevelId, 5) + 1
	--	else
	--		if curLevelId == 5 then
	--			startLevelId = 0
	--		else
	--			startLevelId = curLevelId - 4
	--		end
	--	end
	--end

	self:RefreshRewards(isSingleReward)
	if not isSingleReward then
		local curIdx = curLevelId < #mapData.allLevels - 4 and curLevelId - 1 or #mapData.allLevels - 5
		self.boxScrollList.loopGridView:MovePanelToItemByIndex(curIdx)
	end
end

function UIExpeditionDungeonInfoView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local levelData = self.levelDatas[itemIndex + 1]
	local item
	if levelData then
		item = gridView:NewListViewItem('DungeonRewardBox')
		local rewardLua = CommonUtil.BindGridViewItem2Lua(self, 'DungeonRewardBox', item.gameObject)
		local levelData = self.levelDatas[itemIndex + 1]
		local idx = itemIndex
		CommonUtil.LoadIcon(self, levelData.closeRewardBoxImg, function (sprite)
			rewardLua.closeNode.image.sprite = sprite
		end,rewardLua,"CloseRewardBoxIdx")
		CommonUtil.LoadIcon(self, levelData.openRewardBoxImg, function (sprite)
			rewardLua.openNode.image.sprite = sprite
		end,rewardLua,"OpenRewardBoxIdx")

		rewardLua.currentNode:SetActive(not levelData.isPassed and (idx+1) == self.controller:GetCurLevelId())
		rewardLua.levelNum.text.text = "第" .. (idx+1) .. "关"
		if levelData.isGotReward then
			rewardLua.openNode:SetActive(true)
			rewardLua.closeNode:SetActive(false)
			rewardLua.activeNode:SetActive(false)
			self.uiBase:AddButtonUniqueEventListener(rewardLua.button,self, self.OnClickViewRewardBox,levelData.levelId)
		elseif levelData.isPassed then
			rewardLua.openNode:SetActive(false)
			rewardLua.closeNode:SetActive(true)
			rewardLua.activeNode:SetActive(true)
			self.uiBase:AddButtonUniqueEventListener(rewardLua.button,self, self.OnClickGetRewardBox,levelData.levelId)
		else
			rewardLua.openNode:SetActive(false)
			rewardLua.closeNode:SetActive(true)
			rewardLua.activeNode:SetActive(false)
			self.uiBase:AddButtonUniqueEventListener(rewardLua.button,self, self.OnClickViewRewardBox,levelData.levelId)
		end
	end
	return item
end

function UIExpeditionDungeonInfoView:OnClickViewRewardBox(btn,params)
	local mapData = self.controller:GetMapData()
	local levelId = params[0]
	local levelData = mapData:FindLevelByLevelId(levelId)
	if levelData ~= nil  and levelData.rewards ~= nil and #levelData.rewards > 0 then
		ManagerContainer.LuaUIMgr:ShowMinRewardTips(levelData.rewards)
	end
end

function UIExpeditionDungeonInfoView:OnClickGetRewardBox(btn,params)
	local levelId = params[0]
	local mapData = self.controller:GetMapData()
	ManagerContainer.DataMgr.ExpeditionDataMgr:SendGotRewardReq(mapData.mapId,levelId)
end

function UIExpeditionDungeonInfoView:OnClickCloseBtn()
	self:UIClose()
end

function UIExpeditionDungeonInfoView:OnClickNextLevel()
	local idx = self.boxScrollList.loopGridView:FindNearestItemIndex()
	local startPos = idx + 5
	self.boxScrollList.loopGridView:MovePanelToItemByIndex(startPos)
end

function UIExpeditionDungeonInfoView:OnClickLastLevel()
	local idx = self.boxScrollList.loopGridView:FindNearestItemIndex()
	local startPos = idx - 5
	if startPos < 0 then
		self.boxScrollList.loopGridView:MovePanelToItemByIndex(0)
		return
	end
	self.boxScrollList.loopGridView:MovePanelToItemByIndex(startPos)
end

function UIExpeditionDungeonInfoView:OnClickGetAllReward()
	local mapData = self.controller:GetMapData()
	ManagerContainer.DataMgr.ExpeditionDataMgr:SendGotRewardReq(mapData.mapId,0)
end

function UIExpeditionDungeonInfoView:OnClickArrangeBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExpeditionArrange)
end

function UIExpeditionDungeonInfoView:OnClickSkillBtn()
	ManagerContainer.LuaUIMgr:Hide(self.uiData.id)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISkillSettings,{1},self.uiData.id)
end

function UIExpeditionDungeonInfoView:OnClickPetBtn()
	ManagerContainer.LuaUIMgr:Hide(self.uiData.id)
	local data = {list = ManagerContainer.DataMgr.ExpeditionDataMgr:GetCurrBattleTeamMembers()}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetBattle,data,self.uiData.id)
end

function UIExpeditionDungeonInfoView:OnClickBlessBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExpeditionBless)
end

function UIExpeditionDungeonInfoView:OnClickChallengeBoss(btn,params)
	local bossSlotIdx = params[0]
	ManagerContainer.DataMgr.ExpeditionDataMgr:SendChallengeBossStart(bossSlotIdx)
end

return UIExpeditionDungeonInfoView

