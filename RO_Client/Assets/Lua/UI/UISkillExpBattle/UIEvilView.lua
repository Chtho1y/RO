local UIEvilView = require("UISkillExpBattle/UIEvilView_Generate")
local IconItemCtr = require("Common/IconItemCtr")
local SLOT_INTERVAL_TIME = 0.1
local SLOT_CLOSE_TIME = 0.2
local SLOT_OPEN_TIME = 0.5

function UIEvilView:OnAwake(data)
	self.controller = require("UISkillExpBattle/UIEvilCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIEvilView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_SkillExpBattle_SlotData,self,self.RefreshSlotsData)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Evil_Refresh_SlotCDTime,self,self.RefreshSlotCDTime)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Evil_Confirm_Challenge,self,self.OnConfirmChanllenge)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Challenge_Evil_Ok,self,self.OnChallengeEvilOk)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_ROLE_EVIL_EXP_CHANGED,self,self.RefreshEvilExp)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_ROLE_EVIL_Level_CHANGED,self,self.RefreshEvilLevelUp)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_CLOSE_POPGOT_PAGE,self,self.OnClosePopGotPage)
end

function UIEvilView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
	self.successNode:SetActive(false)
end

function UIEvilView:Init()
	self.skillState = false
	self:RefreshData()
end

function UIEvilView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIEvilView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.refreshBtn.button,self, self.OnClickRefresh)
	self.uiBase:AddButtonEventListener(self.playRuleBtn.button, self, self.OnClickPlayRuleBtn)
	self.uiBase:AddButtonEventListener(self.coinIcon.button, self, self.OnClickViewCoinIcon)

	self.uiBase:AddButtonEventListener(self.btnInOut.button, self, self.RefreshSkillNoticeState)
	self.uiBase:AddButtonEventListener(self.btnGoto.button, self, self.OnGotoSkillSetting)
end

function UIEvilView:OnHide()

end

function UIEvilView:OnShow(data)
	self.controller:SetData(data)
	self:RefreshSkillGoTo()
end

function UIEvilView:OnClose()
	self.rewards = nil
	self.levelUpRewards = nil
	self:ClearTimer()
	self:DisposeBossInfoTimers()
end

function UIEvilView:OnDispose()
	self.controller:OnDispose()
end

function UIEvilView:OnChallengeEvilOk(rewards)
	self.rewards = rewards
	self.successNode:SetActive(true)
	local skeleton = self.battleShow.skeletonGraphic
	skeleton.Skeleton:SetToSetupPose();
	skeleton.AnimationState:ClearTracks();
	skeleton.AnimationState:SetAnimation(0, self.battleShow.skeletonGraphic.startingAnimation, false);
	self:ClearTimer()
	self.hideNodeTimer = ManagerContainer.LuaTimerMgr:AddTimer(3000, 1, self, self.HideSuccessNode, nil)
end

function UIEvilView:HideSuccessNode()
	self.successNode:SetActive(false)
	self:ClearTimer()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot, {rewards = self.rewards})
end

function UIEvilView:RefreshEvilLevelUp(rewards)
	self.levelUpRewards = rewards
end

function UIEvilView:OnClosePopGotPage()
	if self.levelUpRewards ~= nil then
		local cb = function()
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot,{rewards = self.levelUpRewards,title="EvilLevelUpBouns"})
			self.levelUpRewards = nil
        end
        RegisterDelayStep(cb)
	end
	self:RefreshSkillGoTo()
end

function UIEvilView:OnClickViewCoinIcon()
	ManagerContainer.LuaUIMgr:ShowMinTips("UISkillExpBattleInfo_1")
end

function UIEvilView:ClearTimer()
	if self.hideNodeTimer ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self.hideNodeTimer)
		self.hideNodeTimer = nil
	end
end

function UIEvilView:RefreshData()
	self:RefreshSlotsData()
	self:RefreshEvilExp()
	self:RefreshSkillGoTo()
end

function UIEvilView:RefreshSlotsData()
	local slotsData = self.controller:GetSlotData()
	local delayTime = 0
	for i=1, #slotsData do
		if self:SetBossInfo(i,self:GetBossGo(i),slotsData[i], delayTime) then
			delayTime = delayTime + SLOT_INTERVAL_TIME
		end
	end

	if self.controller:IsFreeForever() then
		self.usedRefreshCntTxt.text.text = "刷新次数永久免费"
		self.costTxt.text.text = string.formatbykey('Free')
		self.costTxt.text.color = Color.white
		self.costIcon:SetActive(false)
	else
		local leftFreeCnt = self.controller:LeftFreeCnt()
		self.usedRefreshCntTxt.text.text = "今日可免费刷新" .. self.controller:LeftFreeCnt() .. "次"
		if leftFreeCnt > 0 then
			self.costTxt.text.text = string.formatbykey('Free')
			self.costTxt.text.color = Color.white
		else
			self.costTxt.text.text = tostring(self.controller:RefreshCost())
			if ManagerContainer.DataMgr.UserData:GetCurrency(Enum.ItemType.Diamond) >= self.controller:RefreshCost() then
				self.costTxt.text.color = Color.white
			else
				self.costTxt.text.color = Color.pink
			end
		end
		self.costIcon:SetActive(leftFreeCnt == 0)
	end

	if self.controller:GetEvilLevel() == self.controller:GetMaxLevel() then
		self.tipsNode.tipsTxt.text.text = string.formatbykey("EvilLevelMax",self.controller:GetMaxLevel())
	else
		self.tipsNode.tipsTxt.text.text = string.formatbykey("EvilLevelUp",self.controller:NextLevelChallengedCount(),self.controller:GetEvilLevel()+1)
	end
end

function UIEvilView:SetBossInfo(idx, node, bossData, delayTime)
	if not node then
		return false
	end
	if not bossData then
		node:SetActive(false)
		return false
	end
	node:SetActive(true)
	if not bossData:GetChangeState() then
		if not self:IsBossInfoTimeringByIdx(idx) then
			self:StopBossInfoTimer(idx)
			self:RefreshBossInfo(idx)
			return false
		end
	end
	bossData:SetChangeState(false)
	self:StopBossInfoTimer(idx)
	local delayTimer = nil
	if self.delayCloseTimers then
		delayTimer = self.delayCloseTimers[idx]
	else
		self.delayCloseTimers = {}
	end
	if not delayTimer then
		delayTimer = Timer.New(function ()
			self:PlayBossInfoCloseAnim(idx)
		end, delayTime, 1)
		self.delayCloseTimers[idx] = delayTimer
	else
		delayTimer.loop = 1
		delayTimer.time = delayTime
		delayTimer.duration = delayTime
	end
	if not delayTimer.running then
		delayTimer:Start()
	end
	return true
end


function UIEvilView:PlayBossInfoCloseAnim(idx)
	local node = self:GetBossGo(idx)
	if not node then return end
	node.animator:Play("UIEvilRefresh", -1)
	node.animator:Update(0)
	local delayTimer = nil
	if self.delayOpenTimers then
		delayTimer = self.delayOpenTimers[idx]
	else
		self.delayOpenTimers = {}
	end
	if not delayTimer then
		delayTimer = Timer.New(function ()
			self:RefreshBossInfo(idx)
			self:PlayBossInfoOpenAnim(idx)
		end, SLOT_CLOSE_TIME, 1)
		self.delayOpenTimers[idx] = delayTimer
	else
		delayTimer.loop = 1
		delayTimer.time = SLOT_CLOSE_TIME
		delayTimer.duration = SLOT_CLOSE_TIME
	end
	if not delayTimer.running then
		delayTimer:Start()
	end
end

function UIEvilView:PlayBossInfoOpenAnim(idx)
	local delayTimer = nil
	if self.delayStopTimers then
		delayTimer = self.delayStopTimers[idx]
	else
		self.delayStopTimers = {}
	end
	if not delayTimer then
		delayTimer = Timer.New(function ()
			self:StopBossInfoTimer(idx)
		end, SLOT_OPEN_TIME, 1)
		self.delayStopTimers[idx] = delayTimer
	else
		delayTimer.loop = 1
		delayTimer.time = SLOT_OPEN_TIME
		delayTimer.duration = SLOT_OPEN_TIME
	end
	if not delayTimer.running then
		delayTimer:Start()
	end
end

function UIEvilView:IsBossInfoTimering()
	if self.delayCloseTimers then
		for _, delayTimer in pairs(self.delayCloseTimers) do
			if delayTimer and delayTimer.running then
				return true
			end
		end
	end
	if self.delayOpenTimers then
		for _, delayTimer in pairs(self.delayOpenTimers) do
			if delayTimer and delayTimer.running then
				return true
			end
		end
	end
	if self.delayStopTimers then
		for _, delayTimer in pairs(self.delayStopTimers) do
			if delayTimer and delayTimer.running then
				return true
			end
		end
	end
	return false
end

function UIEvilView:DisposeBossInfoTimers()
	if self.delayCloseTimers then
		for _, delayTimer in pairs(self.delayCloseTimers) do
			if delayTimer and delayTimer.running then
				delayTimer:Stop()
			end
		end
		self.delayCloseTimers = nil
	end
	if self.delayOpenTimers then
		for _, delayTimer in pairs(self.delayOpenTimers) do
			if delayTimer and delayTimer.running then
				delayTimer:Stop()
			end
		end
		self.delayOpenTimers = nil
	end
	if self.delayStopTimers then
		for _, delayTimer in pairs(self.delayStopTimers) do
			if delayTimer and delayTimer.running then
				delayTimer:Stop()
			end
		end
		self.delayStopTimers = nil
	end
end

function UIEvilView:IsBossInfoTimeringByIdx(idx)
	local delayTimer = nil
	if self.delayTimers then
		delayTimer = self.delayTimers[idx]
		if delayTimer and delayTimer.running then
			return true
		end
	end
	if self.delayOpenTimers then
		delayTimer = self.delayOpenTimers[idx]
		if delayTimer and delayTimer.running then
			return true
		end
	end
	if self.delayStopTimers then
		delayTimer = self.delayStopTimers[idx]
		if delayTimer and delayTimer.running then
			return true
		end
	end
	return false
end

function UIEvilView:StopBossInfoTimer(idx)
	local node = self:GetBossGo(idx)
	if node then
		node.animator:Play("UIEvilKeep", -1)
		node.animator:Update(0)
	end
	local delayTimer = nil
	if self.delayTimers then
		delayTimer = self.delayTimers[idx]
		if delayTimer and delayTimer.running then
			delayTimer:Stop()
		end
	end
	if self.delayOpenTimers then
		delayTimer = self.delayOpenTimers[idx]
		if delayTimer and delayTimer.running then
			delayTimer:Stop()
		end
	end
	if self.delayStopTimers then
		delayTimer = self.delayStopTimers[idx]
		if delayTimer and delayTimer.running then
			delayTimer:Stop()
		end
	end
end

function UIEvilView:RefreshBossInfo(idx)
	local node = self:GetBossGo(idx)
	if not node then return end
	local bossData = self.controller:GetSlotDataByIdx(idx)
	if not bossData then
		node:SetActive(false)
		return
	end
	node:SetActive(true)
	local qualityBg = self.controller:GetQuialityBg(bossData.bossQuality)
	if qualityBg ~= nil and qualityBg ~= "" then
		CommonUtil.LoadIcon(self, qualityBg, function (sprite)
			node.shadow.image.sprite = sprite
		end)
	else
		node.shadow.image.sprite = nil
	end

	node.titleImg.image.sprite = node.titleImg.switchSprite.sprites[bossData.bossQuality-1]
	node.bossName.text.text = bossData.bossName
	CommonUtil.LoadIcon(self, bossData.bossIcon, function (sprite)
		node.bossNode.bossImg.image.sprite = sprite
	end)
	if bossData:IsBossDead() then
		node.passedNode:SetActive(true)
		node.challengeBtn:SetActive(false)
	else
		node.passedNode:SetActive(false)
		node.challengeBtn:SetActive(true)
	end
	self:RefreshSlotCDTime(idx,bossData:GetLeftCDTime())
	node.costVal.text.text = tostring(self.controller:GetCost())
	if self.controller:GetCost() <= self.controller:GetCurrentEvilExp() then
		node.costVal.text.color = Color.white
	else
		node.costVal.text.color = Color.pink
	end

	self.uiBase:AddButtonUniqueEventListener(node.challengeBtn.button, self, self.OnClickChallengeBoss, idx)
	IconItemCtr:SetData(self,node.rewardItem,{cfgId = Enum.ItemType.SkillExp, num = bossData.rewardEvilExp},Enum.ItemIEnterType.Bag,self,self.OnClickReward)
end


function UIEvilView:OnClickReward(btn,params)
	local itemData = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(itemData)
end

function UIEvilView:RefreshSlotCDTime(slotId,cdTime)
	local slotGo = self:GetBossGo(slotId)
	if slotGo == nil then
		return
	end

	slotGo.cdNode.cdTxt.text.text = FormatTime2(cdTime)
	slotGo.cdNode:SetActive(cdTime > 0)	
end

function UIEvilView:RefreshEvilExp()
	self.evilValTxt.text.text = self.controller:GetCurrentEvilExp() .. "/" .. self.controller:GetMaxEvilExp()
	if self.controller:GetCurrentEvilExp() >= self.controller:GetCost() then
		self.evilValTxt.text.color = Color.white
	else
		self.evilValTxt.text.color = Color.pink
	end
end

function UIEvilView:OnClickChallengeBoss(btn,params)
	if self:IsBossInfoTimering() then
		return
	end
	local slotIdx = params[0]
	local slotData = self.controller:GetSlotDataByIdx(slotIdx)
	if slotData ~= nil then
		self.controller:SendChallengeBoss(slotIdx,slotData.bossId)
	end
end

function UIEvilView:OnClickRefresh()
	if self:IsBossInfoTimering() then
		return
	end
	if self.controller:IsFreeForever() or self.controller:LeftFreeCnt() > 0  then
		self.controller:RefreshReq()
	else
		if ManagerContainer.DataMgr.UserData:GetCurrency(Enum.ItemType.Diamond) < self.controller:RefreshCost() then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(282)
		else
			ManagerContainer.LuaUIMgr:ShowMessageBox("EvilRefreshRefreshCD",{self.controller:RefreshCost()},nil, self, self.OnConfirmRefreshRefresh)
		end
	end
end

function UIEvilView:OnConfirmRefreshRefresh()
	self.controller:RefreshReq()
end

function UIEvilView:OnClickClose()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIEvilView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'EvilGuildPlayExplain'})
end

function UIEvilView:GetBossGo(idx)
	if idx == 1 then
		return self.bossNode1
	elseif idx == 2 then
		return self.bossNode2
	elseif idx == 3 then
		return self.bossNode3
	elseif idx == 4 then
		return self.bossNode4
	end
	return nil
end

function UIEvilView:RefreshSkillGoTo()
	local lvCnt = CommonUtil.GetAllSlotSkillCanUpNum(true)
	if not self.lastCnt then
		self.lastCnt = 0
	end
	self.light:SetActive(lvCnt > 0)
	--self.btnGoto.button.enabled = lvCnt > 0
	self.text1.uILocalizeScript:SetContentAndValues("SkillUpCount", {lvCnt})

	if lvCnt > self.lastCnt then
		self.lastCnt = lvCnt
		self:RefreshSkillNoticeState(nil, nil, true)
	end
end

function UIEvilView:RefreshSkillNoticeState(button, params, out)
	if not out then
		self.skillState = not self.skillState
	else
		self.skillState = true
	end
	self.bgGoto.animator:Play(self.skillState and "UIGotoIn" or "UIGotoOut")
end

function UIEvilView:OnGotoSkillSetting()
	local id = CommonUtil.GetHeroIdBySlotSkillLowerLv(true)
	if id == 0 then
		id = 1
	end

	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISkillSettings, {id})
end

return UIEvilView

