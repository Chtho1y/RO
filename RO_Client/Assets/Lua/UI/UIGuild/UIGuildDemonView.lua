local UIGuildDemonView = require("UIGuild/UIGuildDemonView_Generate")
local PreviewSystem = require("PreviewSystem")
local RankList = {}
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')

function UIGuildDemonView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildDemonCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildDemonView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_DEMON_PLAYER_RANK_INFO, self, self.RefreshPlayerInfo)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_DEMON_VIEW_INFO, self, self.Refresh)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_DEMON_FIGHT_VIEW_INFO, self, self.RefreshFightCountUI)

end

function UIGuildDemonView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildDemonView:Init()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.GuildDemonBoss, false)
	ManagerContainer.DataMgr.GuildDemonData:SendGuildDemonInfoReq()
	self:InitGrid()
	self.btnChallenge.button.interactable = false
	self:StartRefreshTimer()
end

function UIGuildDemonView:Refresh()
	if not self.previewSystem then
		self.previewSystem = PreviewSystem:new('GuildDemonPreview')
		self.previewSystem:SetView(Vector3(0, 1.93, 4.75), Quaternion.Euler(0, 180, 0))
	else
		self.previewSystem:RemoveAllGo()
	end
	self.bossImg.rawImage.texture = self.previewSystem:GetRenderTexture()
	self:RefreshModel()
	self:RefreshUIData()
end

function UIGuildDemonView:OnClickOtherHeadBtn(button,params)
	local uid = params[0]
	local selfUid = ManagerContainer.DataMgr.UserData:GetUserId()
	if selfUid == uid then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatError1")
		return
	end
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

function UIGuildDemonView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIGuildDemonView:StartRefreshTimer()
	local timer = self.refreshTimer
	if not timer then
		timer = Timer.New(slot(self.RefreshTimer,self), 1, -1)
		self.refreshTimer = timer
	end
	if not timer.running then
		timer:Start()
	end
end

function UIGuildDemonView:StopRefreshTimer()
	if self.refreshTimer then
		self.refreshTimer:Stop()
	end
end

function UIGuildDemonView:DisposeRefreshTimer()
	self:StopRefreshTimer()
	self.refreshTimer = nil
end

function UIGuildDemonView:RefreshTimer()
	local fightTime = ManagerContainer.DataMgr.GuildDemonData:GetBossEndTime()
	local remainTime  = nil
	if fightTime and fightTime > 0 then
		remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(fightTime)
		if remainTime > 0 then
			self.timeTxt.text.text = I18N.SetLanguageValue('OutTime1', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false))
		else
			self.timeTxt.text.text =  I18N.SetLanguageValue("GuildDemonLeave")
		end
	else
		self.timeTxt.text.text =  I18N.SetLanguageValue("GuildDemonLeave")
	end
	local fightCount =  ManagerContainer.DataMgr.GuildDemonData:GetfightCount()
	self.btnChallenge.button.interactable = remainTime and remainTime > 0 and fightCount > 0
	if not remainTime or remainTime <= 0 then
		self:StopRefreshTimer()
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

function UIGuildDemonView:InitGrid()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	self.loadStatusLoopListCtr = LoadStatusLoopListCtr:new(self, self.dmgRank.loopListView, 0, 50,
															false, nil, nil,
															true, 'LoadingItem', Enum.ListLoadingStatus.WaitLoad,
															self.GetItemByIndex, nil, self.OnBeginLoad)
	self.dmgRank.scrollRect.enabled = false
    self:InitData()
end

function UIGuildDemonView:OnBeginLoad(isLeft)
	-- 发送获得后续公会玩家信息
	local uids = ManagerContainer.DataMgr.GuildDemonData:GetPlayerUids()
	ManagerContainer.DataMgr.GuildDemonData:SendGetGuildMemberInfoReq(Enum.FriendTogglePageType.GuildDemonPlayerInfo,uids)
end

function UIGuildDemonView:RefreshPlayerInfo()
	RankList = ManagerContainer.DataMgr.GuildDemonData:GetMyGuildRankList()
	if not RankList then
		self.loadStatusLoopListCtr:OnAllLoaded()
		self.loadStatusLoopListCtr:RefreshMaxDataLength(0)
		self.loadStatusLoopListCtr:RefreshDataLength(0)
		return
	end
	local maxLength = ManagerContainer.DataMgr.GuildDemonData:GetPlayerInfoLimit()
	local dataLength = ManagerContainer.DataMgr.GuildDemonData:GetPlayerInfosLength()
	self.loadStatusLoopListCtr:OnAllLoaded()
	self.loadStatusLoopListCtr:RefreshMaxDataLength(maxLength)
	self.loadStatusLoopListCtr:RefreshDataLength(dataLength)
end

function UIGuildDemonView:GetItemByIndex(gridView,idx,itemIndex)
	local item = nil
	item = gridView:NewListViewItem('DmgRankItem')
	local showData = RankList[itemIndex + 1]
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'DmgRankItem', item.gameObject)
	CommonUtil.UpdateItemPrefab(self, itemLua, showData)
	return item
end

function UIGuildDemonView:InitData()
	self:RefreshPlayerInfo()
end

function UIGuildDemonView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.dmgRank.scrollRect.enabled = true
end

function UIGuildDemonView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	self.uiBase:AddButtonUniqueEventListener(self.btnPlayRule.button, self, self.OnClickPlayRuleBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnBack.button, self, self.OnClickBackBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnLog.button, self, self.OnClickLogRankBtn)
	self.uiBase:AddButtonUniqueEventListener(self.nowBox.button, self, self.OnClickOpenNowRewardBtn)
	self.uiBase:AddButtonUniqueEventListener(self.nextBox.button, self, self.OnClickOpenNextRewardBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnAdd.button, self, self.OnClickBuyTimesBtn)
	self.uiBase:AddButtonUniqueEventListener(self.bossName.button, self, self.OnClickBossNameBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnChallenge.button, self, self.OnClickBtnChallengeBtn)
end

function UIGuildDemonView:OnClickBtnChallengeBtn()
	self.controller:ChallengeBoss()
end

function UIGuildDemonView:OnClickBossNameBtn()
	local demonId = ManagerContainer.DataMgr.GuildDemonData:GetdemonId()
	local demonData = ManagerContainer.CfgMgr:GetGuildDemonCfgCfgById(demonId)
	if demonData and demonData.BossLvMax == 1 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("VipUpLvMax")
		return
	end
	--local nextLvDay = ManagerContainer.DataMgr.GuildDemonData:GetNextLvDay()
	ManagerContainer.LuaUIMgr:ShowMinTips("NextDay")
end

function UIGuildDemonView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'GuildDemonExplain'})
end

function UIGuildDemonView:OnClickLogRankBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildDemonRank, nil, self.uiData.id)
end

function UIGuildDemonView:RefreshFightCountUI()
	local fightCount =  ManagerContainer.DataMgr.GuildDemonData:GetfightCount()
	local fightTime = ManagerContainer.DataMgr.GuildDemonData:GetBossEndTime()
	local remainTime  = nil
	if fightTime and fightTime > 0 then
		remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(fightTime)
	end
	self.btnChallenge.button.interactable = remainTime and remainTime > 0 and fightCount > 0
	self.timesBox.condTxt.text.text = I18N.SetLanguageValue("GuildInfo_034",fightCount)
end

function UIGuildDemonView:RefreshUIData()
	--获取当前显示BOSS
	local demonId = ManagerContainer.DataMgr.GuildDemonData:GetdemonId()
	local demonData = ManagerContainer.CfgMgr:GetGuildDemonCfgCfgById(demonId)
    if not demonData then
        return
    end
	local mvpBrief  = ManagerContainer.DataMgr.GuildDemonData:GetmvpInfo()
	if mvpBrief then
		self.mvpEmpty:SetActive(false)
		local curRoleLv = mvpBrief.level
		local jobCfgId = mvpBrief.config_id
		local jobCfgData = ManagerContainer.CfgMgr:GetJobDataById(jobCfgId)
		local headIcon = CommonUtil.GetPlayerHeadIcon(mvpBrief)
		local _fakerData = {Level = curRoleLv, ProfessionIcon = jobCfgData.JobIcon, HeadIcon = headIcon, IsHero = true};
		local _headFrameId = mvpBrief.head_frame_id
		CommonUtil.SetPlayerHeadAndFrame(self, self.headItem, _fakerData,false, _headFrameId,self,self.OnClickOtherHeadBtn,mvpBrief.uid);
		local vipLv = mvpBrief.vip_level
        local vipIcon = nil
        if vipLv and vipLv >= 0 then
            local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
            if vipCfg then
                vipIcon = vipCfg.SmallIcon
            end
        end
		CommonUtil.LoadIcon(self, vipIcon , function (sprite)
			self.mvpVipIcon.image.sprite = sprite
		end)
		self.mvpName.text.text = CommonUtil.GetVaildNickName(mvpBrief.nick_name)
	else
		self.mvpEmpty:SetActive(true)
	end
	local bossLv = ManagerContainer.DataMgr.GuildDemonData:GetBossLv()
	local summonId = demonData.SummonId or 0
	local npcData = ManagerContainer.CfgMgr:GetNpcCfgById(summonId)
	if not npcData then
		return
	end
	self.bossName.text.text = I18N.SetLanguageValue("GuildDemonName",npcData.Name,bossLv)
	self:RefreshFightCountUI()
	--设置自己伤害量和MVP伤害量slider
	local totalHarm = ManagerContainer.DataMgr.GuildDemonData:GettotalHarm()
	local MVPHarm = ManagerContainer.DataMgr.GuildDemonData:GetmvpHarm()
	local myHarm = ManagerContainer.DataMgr.GuildDemonData:GetmyHarm()
	local myharm = myHarm / totalHarm
	local mvpharm = MVPHarm / totalHarm
	self.mvpSlider.slider.value = MVPHarm == 0 and MVPHarm or mvpharm
	self.mySlider.slider.value = myHarm == 0 and myHarm or myharm
	self.dmgNumber.text.text = CommonUtil.FormatNumber(myHarm)
	if myHarm == 0 then
		self.mySlidertxt.text.text = "0%"
	elseif myharm < 0.001 then
		self.mySlidertxt.text.text = "0.1%"
	elseif myharm >= 1 then
		self.mySlidertxt.text.text = "100%"
	elseif myharm >= 0.999 then
		self.mySlidertxt.text.text = "99.9%"
	else
		self.mySlidertxt.text.text = string.format("%.1f",myharm * 100).."%"
	end
	if MVPHarm == 0 then
		self.mvpSlidertxt.text.text = "0%"
	elseif mvpharm < 0.001 then
		self.mvpSlidertxt.text.text = "0.1%"	
	elseif mvpharm >= 1 then
		self.mvpSlidertxt.text.text = "100%"
	elseif mvpharm >= 0.999 then
		self.mvpSlidertxt.text.text = "99.9%"
	else
		self.mvpSlidertxt.text.text = string.format("%.1f",mvpharm * 100).."%"
	end
	--设置当前和下一档次奖励宝箱图标
	local currRank = ManagerContainer.DataMgr.GuildDemonData:GetcurrRank()
	local nextRank = ManagerContainer.DataMgr.GuildDemonData:GetnextRank()
	local damageReward = demonData.DamageReward
	local damageSegment = CommonUtil.DeserializeGlobalStrToNumberTable(demonData.DamageSegment)
	if damageSegment and #damageSegment > 0 then
		local currMaxHarm = damageSegment[currRank + 1] and damageSegment[currRank + 1][2] or 0
		local nextMaxHarm = damageSegment[nextRank+ 1] and  damageSegment[nextRank + 1][2] or damageSegment[#damageSegment][2]
		local harm = (totalHarm - currMaxHarm) / (nextMaxHarm - currMaxHarm)
		self.harmSlider.slider.value = totalHarm == 0 and totalHarm or harm
		if totalHarm == 0 then
			self.currSlidertxt.text.text = "0%"
		elseif harm < 0.001 then
			self.currSlidertxt.text.text = "0.1%"	
		elseif harm >= 1 then
			self.currSlidertxt.text.text = "100%"
		elseif harm >= 0.999 then
			self.currSlidertxt.text.text = "99.9%"
		else
			self.currSlidertxt.text.text = string.format("%.1f",harm * 100).."%"
		end
	end
	local maxIndex = #demonData.DamageReward
	self.nowBox.button.interactable = currRank > 0 and currRank <= maxIndex
	self.nextBox.button.interactable = nextRank > 0 and nextRank <= maxIndex
	local nextRewardKey = "DscRewardNext"
	if damageReward and #damageReward > 0 then
		local currIcon = ""
		if currRank == 0 then
			currIcon = "Items/item_guild_demonbox0"
		else
			local currCfg = ManagerContainer.CfgMgr:GetItemById(damageReward[currRank][1])
			if currCfg then
				currIcon = currCfg.Icon
			end
		end
		local nextIcon = ""
		if nextRank > #damageReward then
			nextIcon = "Items/item_guild_demonbox0"
			nextRewardKey = "DscMaxReward"
		else
			local nextCfg = ManagerContainer.CfgMgr:GetItemById(damageReward[nextRank][1])
			if nextCfg then
				nextIcon = nextCfg.Icon
			end
		end
		CommonUtil.LoadIcon(self, currIcon , function (sprite)
			self.nowBox.image.sprite = sprite
		end)
		CommonUtil.LoadIcon(self, nextIcon , function (sprite)
			self.nextBox.image.sprite = sprite
		end)
	end
	self.nextTxt.text.text = I18N.SetLanguageValue(nextRewardKey)
end

function UIGuildDemonView:OnClickOpenNowRewardBtn()
	local currRank = ManagerContainer.DataMgr.GuildDemonData:GetcurrRank()
	local demonId = ManagerContainer.DataMgr.GuildDemonData:GetdemonId()
	local demonData = ManagerContainer.CfgMgr:GetGuildDemonCfgCfgById(demonId)
	if demonData and demonData.DamageReward then
		local maxIndex = #demonData.DamageReward
		if currRank <= 0 or currRank > maxIndex then
			return
		end
		local data = {showId = maxIndex - currRank,BossId = demonId}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildDemonReward, data)
	end
end

function UIGuildDemonView:OnClickOpenNextRewardBtn()
	local nextRank = ManagerContainer.DataMgr.GuildDemonData:GetnextRank()
	local demonId = ManagerContainer.DataMgr.GuildDemonData:GetdemonId()
	local demonData = ManagerContainer.CfgMgr:GetGuildDemonCfgCfgById(demonId)
	if demonData and demonData.DamageReward then
		local maxIndex = #demonData.DamageReward
		if nextRank <= 0 or nextRank > maxIndex then
			return
		end
		local data = {showId = maxIndex - nextRank,BossId = demonId}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildDemonReward, data)
	end
end

function UIGuildDemonView:OnClickBackBtn()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIGuildDemonView:OnHide()

end

function UIGuildDemonView:OnClickBuyTimesBtn()
	local demonId = ManagerContainer.DataMgr.GuildDemonData:GetdemonId()
	local demonData = ManagerContainer.CfgMgr:GetGuildDemonCfgCfgById(demonId)
	if not demonData  then
		return
	end
	local cost = demonData.ChallengePrice
	local BuyTimes = ManagerContainer.DataMgr.GuildDemonData:GetbuyCount()
	local fucIsCanBuy = function(singlecost,count)	
		return self:IsCanBuyTimes(singlecost,count)
	end
	local fucBuyOk = function(count) 
		self:SureBuyTimes(count) 
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBuyTimes, {cost, BuyTimes ,fucIsCanBuy,fucBuyOk,demonData.ChallengeTimes})
end

function UIGuildDemonView:SureBuyTimes(count)
	ManagerContainer.DataMgr.GuildDemonData:SendGuildDemonBuyFighCountReq(count)
end

function UIGuildDemonView:IsCanBuyTimes(allcost)
	local AllCost = allcost
	local Goldcount = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.Diamond)
	if Goldcount >= AllCost then
		return true
	end
	return false
end

function UIGuildDemonView:RefreshModel()
	self:DisposeModel()
	local demonId = ManagerContainer.DataMgr.GuildDemonData:GetdemonId()
	local bossLv = ManagerContainer.DataMgr.GuildDemonData:GetBossLv()
	local bossCfgData = ManagerContainer.CfgMgr:GetGuildDemonCfgCfgById(demonId)
	if not bossCfgData  then
		return
	end
	local summonId = bossCfgData.SummonId or 0
	local npcCfgData = ManagerContainer.CfgMgr:GetNpcCfgById(summonId)
	if not npcCfgData then
		return
	end
	local avatarCfgData = ManagerContainer.CfgMgr:GetAvatarCfgById(npcCfgData.AvatarId)
	if not avatarCfgData then
		return
	end
	self.modelPath = avatarCfgData.AvatarPrefab
	self.modelPos = CommonUtil.TableToVector3(bossCfgData.ShowPos)
	self.modelRot = CommonUtil.TableToQuaternion(bossCfgData.ShowRot)
	self.seqId = ManagerContainer.ResMgr:LuaLoadAssets(Enum.ResourceType.GameObject, Constants.ModelPath, {self.modelPath}, self, self.ShowModel)
end

function UIGuildDemonView:ShowModel()
	self.modelGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.ModelPath, self.modelPath)
	if self.previewSystem then
		self.previewSystem:AddGo(self.modelGo)
	end
	if ManagerContainer.LuaModelMgr and ManagerContainer.LuaModelMgr.ModelRoot then
        self.modelGo.transform:SetParent(ManagerContainer.LuaModelMgr.ModelRoot.transform)
	end
	if self.modelPos then
		self.modelGo.transform.localPosition = self.modelPos
	end
	if self.modelRot then
		self.modelGo.transform.localRotation = self.modelRot
	end
end

function UIGuildDemonView:DisposeModel()
	if self.seqId then
		ManagerContainer.ResMgr:ClearUIAsyncLoadReqsBySeqId(self.seqId)
	end
	self.seqId = nil
	if self.modelGo then
		ManagerContainer.ResMgr:RecycleGO(Constants.ModelPath, self.modelPath, self.modelGo)
		if self.previewSystem then
			self.previewSystem:RemoveGo(self.modelGo)
		end
	end
	self.modelPath = nil
	self.modelGo = nil
end


function UIGuildDemonView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildDemonView:OnClose()

end

function UIGuildDemonView:OnDispose()
	self:DisposeModel()
	if self.previewSystem then
		self.previewSystem:Dispose()
		self.previewSystem = nil
	end
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	ManagerContainer.DataMgr.GuildDemonData:ClearGuildDemonViewInfos()
	self:StopRefreshTimer()
	self.controller:OnDispose()
end

return UIGuildDemonView

