local UIGuildHuntView = require("UIGuild/UIGuildHuntView_Generate")

local PreviewSystem = require("PreviewSystem")

function UIGuildHuntView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildHuntCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildHuntView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_DISBAND_SUCCESS, self, self.OnGuildDisBandSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_QUIT_SUCCESS, self, self.OnGuildQuitSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_KICKOUT_SUCCESS, self, self.OnGuildKickoutSuccess)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_HUNT_BOSS_LIST_CHANGED, self, self.OnGuildHuntBossListChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_HUNT_BOSS_SUMMON_CHANGED, self, self.OnGuildHuntBossSummonChanged)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VIP_LV_CHANGED, self, self.OnVipLvChanged)
end

function UIGuildHuntView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildHuntView:Init()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.GuildHuntBoss, false)
	if not self.previewSystem then
		self.previewSystem = PreviewSystem:new('GuildHuntPreview')
		self.previewSystem:SetView(Vector3(0, 1.93, 4.75), Quaternion.Euler(0, 180, 0))
	else
		self.previewSystem:RemoveAllGo()
	end
	self.bossImg.rawImage.texture = self.previewSystem:GetRenderTexture()
	self:RefreshModel()
	self:RefreshView()

	self.controller:SendGuildHuntBossListInfoReq()
end

function UIGuildHuntView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuildHuntView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnPlayRule.button, self, self.OnClickPlayRuleBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnAward.button, self, self.OnClickAwardBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnLeft.button, self, self.OnClickLeftBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnRight.button, self, self.OnClickRightBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnBack.button, self, self.OnClickBackBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnLog.button, self, self.OnClickLogBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnChallenge.button, self, self.OnClickChallengeBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnSummon.button, self, self.OnClickSummonBtn)
end

function UIGuildHuntView:OnHide()

end

function UIGuildHuntView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildHuntView:OnClose()
end

function UIGuildHuntView:OnDispose()
	self:DisposeModel()
	if self.previewSystem then
		self.previewSystem:Dispose()
		self.previewSystem = nil
	end
	self:DisposeRefreshTimer()
	self:DisposeRefreshInfoTimer()
	self.controller:OnDispose()
end

function UIGuildHuntView:OnGuildDisBandSuccess()
	self.uiBase.MSourceUIID = 0
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIGuildHuntView:OnGuildQuitSuccess()
	self.uiBase.MSourceUIID = 0
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIGuildHuntView:OnGuildKickoutSuccess()
	self.uiBase.MSourceUIID = 0
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIGuildHuntView:OnGuildHuntBossListChanged()
	self.controller:RefreshBossList()
	self:RefreshModel()
	self:RefreshView()
	self:StartRefreshInfoTimer()
end

function UIGuildHuntView:OnGuildHuntBossSummonChanged(bossId)
	if not self.controller:ContainBoss(bossId) then
		self.controller:RefreshBossList()
		self:RefreshModel()
	end
	self:RefreshView()
end

function UIGuildHuntView:OnVipLvChanged()
	self:RefreshView()
end

function UIGuildHuntView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'GuildBossPlayExplain'})
end

function UIGuildHuntView:OnClickAwardBtn()
	local bossId = self.controller:GetCurBossId()
	if not bossId then
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildHuntMasterReward, bossId)
end

function UIGuildHuntView:OnClickLeftBtn()
	if not self.controller:ChangeBoss(false) then
		return
	end
	self:RefreshModel()
	self:RefreshView()
end

function UIGuildHuntView:OnClickRightBtn()
	if not self.controller:ChangeBoss(true) then
		return
	end
	self:RefreshModel()
	self:RefreshView()
end

function UIGuildHuntView:OnClickBackBtn()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIGuildHuntView:OnClickChallengeBtn()
	local data = self.controller:GetBossInfoList()
	if not data then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(587)
		return
	end
	local bossCfgData, bossData = self.controller:GetCurBossInfo()
	if not bossCfgData or not bossData then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(587)
		return
	end
	local maxNum = bossCfgData.Challenge or 0
	if bossCfgData.BossType == Enum.GuildHuntBossType.Normal then
		maxNum = maxNum + self.controller:ExtraChallengeNum()
	end
	local remainNum = bossData.remainNum or 0
	if remainNum >= maxNum then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(587)
		return
	end
	if bossCfgData.BossType ~= Enum.GuildHuntBossType.Normal then
		local cd = self.controller:GetHuntBossCd()
		if cd then
			local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(cd)
			if remainTime > 0 then
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam('GuildTips_045', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, true))
				return
			end
		end
	end
	self.controller:ChallengeBoss()
end

function UIGuildHuntView:OnClickSummonBtn()
	local errorCode = self.controller:SendGuildHuntBossSummonReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildHuntView:OnClickLogBtn()
	local bossId = self.controller:GetCurBossId()
	if not bossId then
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildHuntLog, bossId)
end

function UIGuildHuntView:OnClickSkillItem(_, params)
	local skillId = params[0]
	local skillLv = params[1]
	ManagerContainer.LuaUIMgr:OpenTips({tipsType = Enum.UITipsType.Skill, cfgId = skillId, num = skillLv})
end

function UIGuildHuntView:OnClickIconItem(_, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIGuildHuntView:RefreshView()
	local data = self.controller:GetBossInfoList()
	if not data then
		self.bossName:SetActive(false)
		self.timer:SetActive(false)
		self.btnAward:SetActive(false)
		self.btnLeft:SetActive(false)
		self.btnRight:SetActive(false)
		self.skillList:SetActive(false)
		self.awardScrollView:SetActive(false)
		self.btnChallenge:SetActive(false)
		self.btnSummon:SetActive(false)
		self.costBox:SetActive(false)
		self.condBox:SetActive(false)
		self.btnLog:SetActive(false)
		return
	end
	local canLeft, canRight = self.controller:CanMove()
	self.btnLeft:SetActive(canLeft)
	self.btnRight:SetActive(canRight)

	local bossCfgData, bossData = self.controller:GetCurBossInfo()
	if not bossCfgData or not bossData then
		self.bossName:SetActive(false)
		self.timer:SetActive(false)
		self.btnAward:SetActive(false)
		self.skillList:SetActive(false)
		self.awardScrollView:SetActive(false)
		self.btnChallenge:SetActive(false)
		self.btnSummon:SetActive(false)
		self.costBox:SetActive(false)
		self.condBox:SetActive(false)
		self.btnLog:SetActive(false)
		self:StopRefreshTimer()
		return
	end
	self.bossName:SetActive(true)
	self.btnAward:SetActive((bossCfgData.BossType == Enum.GuildHuntBossType.Normal and bossCfgData.MasterReward and #bossCfgData.MasterReward > 0))
	self.skillList:SetActive(true)
	self.btnLog:SetActive(true)

	local post = self.controller:GetGuildMinePost()
	local summonAuth = IsTableHasValue(bossCfgData.SummonLimit, post)

	if bossCfgData.UnlockCond > self.controller:GetGuildLv() then
		self.timer:SetActive(false)
		self:StopRefreshTimer()
		self.costBox:SetActive(false)
		self.condBox:SetActive(true)
		self.condBox.condTxt.text.text = string.formatbykey('GuildInfo_035', tostring(bossCfgData.UnlockCond))
		if summonAuth then
			self.btnChallenge:SetActive(false)
			self.btnSummon:SetActive(true)
			self.btnSummon.button.interactable = false
		else
			self.btnChallenge:SetActive(true)
			self.btnChallenge.button.interactable = false
			self.btnSummon:SetActive(false)
		end
	elseif bossData.fightTime and bossData.fightTime > 0 then
		self.timer:SetActive(true)
		local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(bossData.fightTime)
		self.timeTxt.text.text = string.formatbykey('OutTime1', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false))
		self:StartRefreshTimer()
		local maxNum = bossCfgData.Challenge or 0
		if bossCfgData.BossType == Enum.GuildHuntBossType.Normal then
			maxNum = maxNum + self.controller:ExtraChallengeNum()
		end
		local remainNum = bossData.remainNum or 0
		self.costBox:SetActive(false)
		self.condBox:SetActive(true)
		self.condBox.condTxt.text.text = string.formatbykey('GuildInfo_034', tostring(maxNum - remainNum))
		self.btnChallenge:SetActive(true)
		self.btnChallenge.button.interactable = true
		self.btnSummon:SetActive(false)
	-- elseif bossData.fightCdTime and bossData.fightCdTime > 0 then
	-- 	local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(bossData.fightCdTime)
	-- 	-- self.timeTxt.text.text = string.formatbykey('InTime1', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false))
	-- 	-- self:StartRefreshTimer()
	-- 	-- self.btnChallenge:SetActive(false)
	-- 	-- self.btnSummon:SetActive(false)
	-- 	self.timer:SetActive(false)
	-- 	self:StopRefreshTimer()
	-- 	if bossCfgData.BossType == Enum.GuildHuntBossType.Normal or not summonAuth then
	-- 		self.btnChallenge:SetActive(true)
	-- 		self.btnChallenge.button.interactable = true
	-- 		self.btnSummon:SetActive(false)
	-- 		self.costBox:SetActive(true)
	-- 		local maxNum = bossCfgData.Challenge or 0
	-- 		local remainNum = bossData.remainNum or 0
	-- 		self.costBox.number.text.text = string.formatbykey('GuildInfo_034', tostring(maxNum - remainNum))
	-- 		self.condBox:SetActive(false)
	-- 	else
	-- 		self.btnChallenge:SetActive(false)
	-- 		self.btnSummon:SetActive(true)
	-- 		self.btnSummon.button.interactable = false

	-- 	end
	else
		if bossData.fightCdTime and bossData.fightCdTime > 0 then
			local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(bossData.fightCdTime)
			self.timeTxt.text.text = string.formatbykey('GuildInfo_039', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false))
			self.timer:SetActive(true)
			self:StartRefreshTimer()
		else
			self.timer:SetActive(false)
			self:StopRefreshTimer()
		end
		if bossCfgData.BossType == Enum.GuildHuntBossType.Normal or not summonAuth then
			self.btnChallenge:SetActive(true)
			self.btnChallenge.button.interactable = false
			self.btnSummon:SetActive(false)
			self.costBox:SetActive(false)
			self.condBox:SetActive(true)
			self.condBox.condTxt.text.text = string.formatbykey('GuildInfo_036')
		else
			self.btnChallenge:SetActive(false)
			self.btnSummon:SetActive(true)
			self.costBox:SetActive(true)
			local active = self.controller:GetCurGuildActive()
			if (bossCfgData.Consume > active) then
				self.btnSummon.button.interactable = false
				self.costBox.number.text.text = string.format(Constant.RedColorText, (tostring(active) .. '/' .. tostring(bossCfgData.Consume)))
			else
				self.btnSummon.button.interactable = true
				self.costBox.number.text.text = string.format(Constant.GreenColorText, (tostring(active) .. '/' .. tostring(bossCfgData.Consume)))
			end
			self.condBox:SetActive(false)
		end
	end

	local npcId = bossCfgData.SummonId
	local npcCfgData = ManagerContainer.CfgMgr:GetNpcCfgById(npcId)
	local skillInfos = nil
	if npcCfgData then
		skillInfos = npcCfgData.SkillIds
		self.bossName.text.text = string.formatbykey(npcCfgData.Name)
	else
		self.bossName.text.text = ''
	end

	for i = 1, 4 do
		local skillItem = self['skillItem' .. i]
		if skillItem then
			local skillInfo = skillInfos and skillInfos[i] or nil
			if not skillInfo then
				skillItem:SetActive(false)
			else
				skillItem:SetActive(true)
				local skillId = skillInfo[1]
				local skillLv = skillInfo[2]
				local skillCfgData = ManagerContainer.CfgMgr:GetSkillCfgByType(Enum.SkillType.Active, skillId, skillLv)
				if skillCfgData then
					skillItem.icon.image.enabled = false
					skillItem.icon.image.sprite = nil
					CommonUtil.LoadIcon(self, skillCfgData.Icon, function (sprite)
						skillItem.icon.image.enabled = true
						skillItem.icon.image.sprite = sprite
					end, skillItem, "SkillIconAsyncIdx")
					self.uiBase:AddButtonUniqueEventListener(skillItem.icon.button, self, self.OnClickSkillItem, skillId, skillLv)
				else
					skillItem.icon.image.enabled = false
					skillItem.icon.image.sprite = nil
					skillItem.icon.button:RemoveAllListeners()
				end
				skillItem.num.text.text = (I18N.SetLanguageValue('Lv') .. tostring(skillLv)) or ''
			end
		end
	end

	local awards = bossCfgData.ReviewAwards
	if not awards then
		self.awardScrollView:SetActive(false)
		return
	end
	self.awardScrollView:SetActive(true)
	CommonUtil.LoopGridViewEleCreateNew(self, self.awardScrollView.loopHorizontalScrollRect, nil, awards, 0, self, self.UpdateAwardItem)
end

function UIGuildHuntView:UpdateAwardItem(itemLua, idx, itemData)
	if not itemLua or not itemData then return end
	CommonUtil.UpdateItemPrefab(self, itemLua, {cfgId = itemData, num = 0}, Enum.ItemIEnterType.Bag, self, self.OnClickIconItem)
end

function UIGuildHuntView:RefreshModel()
	self:DisposeModel()
	local data = self.controller:GetBossInfoList()
	if not data then
		return
	end
	local bossCfgData, bossData = self.controller:GetCurBossInfo()
	if not bossCfgData or not bossData then
		return
	end
	local npcCfgData = ManagerContainer.CfgMgr:GetNpcCfgById(bossCfgData.SummonId)
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

function UIGuildHuntView:ShowModel()
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

function UIGuildHuntView:DisposeModel()
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


function UIGuildHuntView:StartRefreshTimer()
	local timer = self.refreshTimer
	if not timer then
		timer = Timer.New(function()
			self:RefreshTimer()
		end, 1, -1)
		self.refreshTimer = timer
	end
	if not timer.running then
		timer:Start()
	end
end

function UIGuildHuntView:StopRefreshTimer()
	if self.refreshTimer then
		self.refreshTimer:Stop()
	end
end

function UIGuildHuntView:DisposeRefreshTimer()
	self:StopRefreshTimer()
	self.refreshTimer = nil
end

function UIGuildHuntView:RefreshTimer()
	local bossCfgData, bossData = self.controller:GetCurBossInfo()
	if not bossCfgData or not bossData then
		self:StopRefreshTimer()
		return
	end
	local remainTime  = nil
	if bossData.fightTime and bossData.fightTime > 0 then
		remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(bossData.fightTime)
		self.timeTxt.text.text = I18N.SetLanguageValue('OutTime1', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false))
	elseif bossData.fightCdTime and bossData.fightCdTime > 0 then
		remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(bossData.fightCdTime)
		self.timeTxt.text.text = I18N.SetLanguageValue('GuildInfo_039', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false))
	else
		self.timeTxt.text.text = ''
	end
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

function UIGuildHuntView:StartRefreshInfoTimer()
	-- 获得最近倒计时要结束的时间
	local remainTime = self.controller:GetNearNeedUpdateRemainTime()
	if not remainTime or remainTime <= 0 then
		self:StopRefreshInfoTimer()
		return
	end
	local timer = self.refreshInfoTimer
	if not timer then
		timer = Timer.New(function()
			self:RefreshInfoTimer()
		end, remainTime)
		self.refreshInfoTimer = timer
	else
		timer.duration = remainTime
		timer.time = remainTime
	end
	if not timer.running then
		timer:Start()
	end
end

function UIGuildHuntView:StopRefreshInfoTimer()
	if self.refreshInfoTimer then
		self.refreshInfoTimer:Stop()
	end
end

function UIGuildHuntView:RefreshInfoTimer()
	self.controller:SendGuildHuntBossListInfoReq()
end

function UIGuildHuntView:DisposeRefreshInfoTimer()
	self:StopRefreshInfoTimer()
	self.refreshInfoTimer = nil
end

return UIGuildHuntView

