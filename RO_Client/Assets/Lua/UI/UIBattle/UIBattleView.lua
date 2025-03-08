local UIBattleView = require("UIBattle/UIBattleView_Generate")
local UIChatRoot = require("UIChat/UIChatRoot")
local BattleBossBloodPart = require("UIBattle/BattleBossBloodPart")
local BattleHeadsBoxPart = require("UIBattle/BattleHeadsBoxPart")
local BattleStatisticsPart = require("UIBattle/BattleStatisticsPart")
local BattleReplayControlPart = require("UIBattle/BattleReplayControlPart")
local LoopType = DG.Tweening.LoopType
local NewBattleChatPart = require("UIBattle/NewBattleChatPart")

local UIMainCtr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIMain)

local updateHandle
local needRefreshMinimap = false
local minimapCurTime = 0
local minimapInterTime = 0.1

local curSelectedData

local stageGoalGridSpacing = {Vector2.New(0, 0), Vector2.New(-10, 0), Vector2.New(-20, 0)}
local newStageCompeleted = false
local levelIncreaseTimer
local increaseIdx

local bBossStage = false
local bBoxState = false

local bossFightCDRemainTime = 0
local curRemainSecond = 0

local bossMaskTimer


local chatDisplayDurationTime
local chatHideTimer

local windowREPos

local pageToggleData = {}
function UIBattleView:OnAwake(data)
	self.controller = require("UIBattle/UIBattleCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIBattleView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	if not updateHandle then
		updateHandle = UpdateBeat:CreateListener(self.Update, self)
	end

	UpdateBeat:AddListener(updateHandle)

	self.RewardBoxBtnPos = CommonUtil.ConvertUIPos2ScreenPos(self.RewardBoxBtn.transform.position)
	self.RewardBoxBtnPos.y =self.RewardBoxBtnPos.y;
	self:InitComs();

	self:Init()

	needRefreshMinimap = true
	self.MapRootGo:SetActive(true)

	self.startRecordBtn:SetActive(true)
	self.stoptRecordBtn:SetActive(false)
	--self.ProfitBoxGo:SetActive(true)
end

function UIBattleView:InitComs()
	-- self.levelNameGo:SetActive(false);
	self.exploringTrans:SetActive(false);
	self.rageBoxGo:SetActive(false);
	self.battleFailGo:SetActive(false);
end

function UIBattleView:Init()
	self.statTime1 = GlobalConfig.Instance:GetConfigIntValue(53) * 60000;
	self.statTime2 = GlobalConfig.Instance:GetConfigIntValue(54) * 60000;
	self.statTime3 = GlobalConfig.Instance:GetConfigIntValue(55) * 60000;
	self.statTime4 = GlobalConfig.Instance:GetConfigIntValue(56) * 60000;
	self.maxCruise = 10000;
	self.challengeAnimName = "BtnBoss1"

	self.isRecording = false
	self.mRecordingTime = 0

	self.controller:InitHeroData()
	self.recordSpeed = 1;
	self:OnRefreshEarnings();
	self:OnRefreshRewardTime();
	self:LoadMinimap()
	self:InitCruise()
	--self:RefreshChatBg()
	--self:RefreshStageGoalUI()
	--self:InitWorldChat()

	local openStatus = ManagerContainer.UIFuncUnlockMgr:GetNeedDisplayNewFuncStatus()
	if openStatus then
		self:FuncOpen1()
	else
		self.newOpen:SetActive(false)
	end

	self.btnAuto:SetActive(false)

	self:InitMinimapGoes()

	local curChatType = self.controller:GetChatChannelType()
	self.controller:SetChatChannelType(curChatType)
	--self:SetToggleGroupStatus(curChatType)
	
	if self.BossBloodPart == nil then
		self.BossBloodPart = BattleBossBloodPart:new()
	end

	if self.HeadsBoxPart == nil then
		self.HeadsBoxPart = BattleHeadsBoxPart:new()
	end

	if self.StatisticsPart == nil then
		self.StatisticsPart = BattleStatisticsPart:new()
	end

	if self.battleReplayPart == nil then
		self.battleReplayPart = BattleReplayControlPart:new()
	end

	if self.NewBattleChatPart == nil then
		self.NewBattleChatPart = NewBattleChatPart:new()
	end

	self.NewBattleChatPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/NewBattleChat"),true,self.btnChat)
	self.BossBloodPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/BattleBossBlood"))
	self.HeadsBoxPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/BattleHeadsBox"))
	self.StatisticsPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/BattleStatistics"))
	self.battleReplayPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/BattleReplayControl"))
	self.BossBloodPart:Hide()
	self.HeadsBoxPart:Hide()
	self.StatisticsPart:Hide()
	self.battleReplayPart:Hide()

	self.chatView:SetActive(true)
	self.battleLogView:SetActive(false)
	self:RestoreSpeed()

	windowREPos = self.windowEnvelope.transform.position
	self:OnRedEnvelopeRemainTimeRefresh()

	self:RefreshOnlineRecordBtn()
end


function UIBattleView:InitMinimapGoes()
	self.miniMapGoes = {}
	self.miniMapGoes[#self.miniMapGoes+1] = self.minimap.rectTransform
	for idx=1,6 do
		self.miniMapGoes[#self.miniMapGoes+1] = self["enemy"..idx].rectTransform
	end
end

------------------在线奖励
--刷新时间
function UIBattleView:RefreshOnlineTime()	
	if nil == self.OnlineRewards then
		return
	end
	--临时处理 之后改为多解锁条件
	local IsActive = self.OnlineRewards.activeInHierarchy
	local IsBossFight = ManagerContainer.LuaBattleMgr:GetBossFightState()
	if IsBossFight then
		if IsActive then
			self.OnlineRewards:SetActive(false)	
		end
	else
		local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(70)
		if unlockState and not IsActive then			
			self.OnlineRewards:SetActive(true)	
			self:RefreshOnlineRecordBtn(true)
		end
	end		
	self:RefreshOnlineAnimRecord()
	local bIsOver,strTime = ManagerContainer.LuaBattleMgr:UpdateOnlineTime()	
	if not bIsOver then
		self.btnOnlineRewards.OnlineTimeLbl.text.text = strTime
	end
end

--刷新按钮
function UIBattleView:RefreshOnlineDownBtn(state)
	self.btnOnlineRewards.times:SetActive(false)
	self.btnOnlineRewards.getRewards:SetActive(false)
	self.btnOnlineRewards.tomorrow:SetActive(false)
	if state == Enum.EnumOnineState.RunTime then
		self.btnOnlineRewards.times:SetActive(true)
	elseif state == Enum.EnumOnineState.Receive then
		self.btnOnlineRewards.getRewards:SetActive(true)
	elseif state == Enum.EnumOnineState.ToDayFinished then
		self.btnOnlineRewards.tomorrow:SetActive(true)
	end
end

--刷新领取道具
function UIBattleView:RefreshOnlineItem(state)
	local ItemId = nil
	local ItemCount = nil	
	local Time,tbRwards = ManagerContainer.LuaBattleMgr:GetNextTotalOnlineTime()
	--LogError(Inspect(tbRwards))
	if tbRwards then
		ItemId = tbRwards[1][1]
		ItemCount = tbRwards[1][2]			
	end
	if nil ~= ItemId then
		local ItemObj = self.OnlineRewards.iconSmallItem
		CommonUtil.SetRewardItemData(self,ItemId,ItemObj,ItemCount, self.OnClickItem)
	end
	self:RefreshOnlineAnimRecord()
end

--点击道具
function UIBattleView:OnClickItem(btn,params)
	local state = ManagerContainer.LuaBattleMgr:GetOnlineState()
	if state == Enum.EnumOnineState.Receive then
		self:OnClickOnlineRecord()
	else
		local logicData = params[0]
		ManagerContainer.LuaUIMgr:OpenTips(logicData)
	end
end

--刷新奖励
function UIBattleView:RefreshOnlineRecordBtn()
	local state = ManagerContainer.LuaBattleMgr:GetOnlineState()
	self:RefreshOnlineDownBtn(state)
	self:RefreshOnlineItem(state)
end

--获取在线奖励点击
function UIBattleView:OnClickOnlineRecord()
	local state = ManagerContainer.LuaBattleMgr:GetOnlineState()
	if state == Enum.EnumOnineState.Receive then
		ManagerContainer.LuaBattleMgr:SendOnlineTimeRecord()
	elseif state == Enum.EnumOnineState.RunTime then		
		--是否消耗金币 
		local NeedItem = ManagerContainer.LuaBattleMgr:GetOnlineTimeGlod()
		local data = {"OnLineUseGold", {tostring(NeedItem)}, nil, self, self.SureOpenTipsWnd}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
	elseif state == Enum.EnumOnineState.ToDayFinished then
		
	end
end

function UIBattleView:RefreshOnlineAnimRecord()
	local state = ManagerContainer.LuaBattleMgr:GetOnlineState()
	local strAnim = nil
	if state == Enum.EnumOnineState.Receive then
		strAnim = "RewardsShow"
	else
		strAnim = "RewardsKeep"
	end
	self:PlayAniRun(self.OnlineRewards.rewardsAnim.animator,strAnim)	
end

function UIBattleView:PlayAniRun(Animator,AniName)
	if Animator then
		local showStateInfo = Animator:GetCurrentAnimatorStateInfo(0)
		if showStateInfo then
			local IsPlay = showStateInfo:IsName(AniName)
			if not IsPlay then
				Animator:Play(AniName)
			end
		end		
	end
end

--提示 道具不足金币转换确定
function UIBattleView:SureOpenTipsWnd()	
	local IsCanUse = ManagerContainer.LuaBattleMgr:IsCanUseGoldOnline()
	if IsCanUse then
		ManagerContainer.LuaBattleMgr:SendOnlineTimeRecord()
	else
		self:PopErrorTips('SeasonLackGold')
	end
end

--Error弹窗
function UIBattleView:PopErrorTips(Key)
	if not ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UIErrorTips) then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIErrorTips, {errorId=Key}, nil, nil, nil, Enum.UISibling[Enum.UIType.Top + 1] + 11)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ERROR_DESC_DISPLAY, {errorId=Key})
    end
end

function UIBattleView:OnRefreshOnlineState()
	self:RefreshOnlineRecordBtn()
end

----------------------------

function UIBattleView:Update()
	self:RefreshOnlineTime()
	if bossFightCDRemainTime > 0 then
		bossFightCDRemainTime = bossFightCDRemainTime - Time.unscaledDeltaTime
		if bossFightCDRemainTime <= 0 then
			bossFightCDRemainTime = 0
			self.challengeAnimName = bBossStage and "BtnBoss3" or "BtnBoss1"
		else
			local remain = math.ceil(bossFightCDRemainTime)
			--if remain ~= curRemainSecond then
				curRemainSecond = remain
				if self.btnChallenge then
					self.btnChallenge.remainCDTime.text.text = I18N.SetLanguageValue("FightCD", curRemainSecond)
				end
			--end
			self.challengeAnimName = bBossStage and "BtnBoss3" or "BtnBoss4"
		end
		if self.btnBossAnimator then
			self.btnBossAnimator.animator:Play(self.challengeAnimName) 
		end
	end

	if not needRefreshMinimap then
		return
	end

	minimapCurTime = minimapCurTime + Time.unscaledDeltaTime
	if minimapCurTime >= minimapInterTime then
		minimapCurTime = 0
		self:RefreshMinimapInfo()
	end
end

function UIBattleView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_BOSS_SPAWNED,self,self.OnBossSpawned);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Boss_Dead,self,self.OnBossDead);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_BATTLE_WIN,self,self.OnBattleWin);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_BATTLE_FAILED,self,self.OnBattleFailed);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_FORCEBATTLE_FAILED,self,self.OnForceBattleFailed);	
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_BATTLE_ERROR,self,self.OnBattleFailed);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_NEXT_BATTLE, self,self.OnBattleNewWave);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_CONTINUE_BATTLE, self,self.OnContinueBattle);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_SHOW_BOSS_RAGE,self, self.OnShowBossRage)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_SHOW_BOSS_RAGE_LEFTTIME, self,self.OnShowBossRageLeftTime);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_REFRESH_RAGE_LEFTTIME, self,self.RefreshRageTime);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_BOSS_IN_RAGE, self,self.OnBossInRage);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_HIDE_LEVEL_NAME, self,self.OnHideLevelName);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_SHOW_BOSS_WARNING,self,self.OnShowBossWarning);	
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_REFRESH_REWARD_TIME,self,self.OnRefreshRewardTime);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_BATTLE_INCOME_ACK,self,self.OnBattleIncomeAck);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_CRUISE_CHANGED,self,self.RefreshCruise);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_BOSS_Battle_End,self,self.BossBattleEnd);
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_BATTLE_FUNC_OPEN_NTF, self, self.FuncOpen)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_BATTLE_NORMAL_NTF, self, self.ShowBattleNormalUI)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GOT_ANIM_TYPE_END_NOTIFY, self, self.PopGotAnimEnd)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.NEW_LEVEL_INCREASE_NTF, self, self.NewLevelIncrease)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.BATTLE_WIN_CLOSE, self, self.RewardBoxRefresh)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.BATTLE_LOADING_COMPELETED, self, self.BattleLoadingCompeleted)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Challenge_Boss_Fight_ACK, self, self.OnChallengeBossAck)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CLOSE_NEW_FUNC_PAGE, self, self.OnCloseNewOpen)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.BATTLE_CHALLENGE_TIME_REFRESH, self, self.OnRefreshBossChallengeTime)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_CHALLENGE_AUTO, self, self.OnStartAutoChallenge)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RED_ENVELOPE_REMAIN_TIME_REFRESH, self, self.OnRedEnvelopeRemainTimeRefresh)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_REFRESH_ONLINETIME_CHANGESTATE, self, self.OnRefreshOnlineState)	
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.TT_RECORD_START, self, self.OnStartRecordEvent)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.TT_RECORD_FINISH, self, self.OnRecordFinishEvent)

	
	self.uiBase:AddUIEventHandlerClickListener(self.uIEventHandler, function (go)
		self:OnAutoChallengeClickEvent()
	end)
end

function UIBattleView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIBattleView:OnStartRecordEvent(success)
	self.startRecording = true
	if success ~= true then
		return
	end	
	LogWarning("SDK调用开始录屏完成 "..tostring(success))
	
	self.startRecordBtn:SetActive(false)
	self.stoptRecordBtn:SetActive(true)

	if self.waitTimer then
		LogWarning(" 定时器不为空删除定时器 ")

		self.waitTimer:Stop()
		self.waitTimer = nil
	end
	self.TimeText.text.text = "00:00";

	self.isRecording = true
	self.mRecordingTime = 0
	self.waitTimer = Timer.New(slot(self.delayTimeFunc, self), 1, 300)
	self.waitTimer:Start()
end

function UIBattleView:OnRecordFinishEvent(success)
	LogWarning("SDK调用结束录屏完成 "..tostring(success))
	self.startRecording = false

	self.startRecordBtn:SetActive(true)
	self.stoptRecordBtn:SetActive(false)
	self.TimeText.text.text = "00:00";
	self.isRecording = false

	if self.waitTimer then
		LogWarning("录屏完成删除 定时器 ")
		self.waitTimer:Stop()
		self.waitTimer = nil
	end

	if self.mRecordingTime < 3 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("录屏过短 无法分享")
		return
	end

	if success == true then
		local data = {"ShareVideoTips", nil, nil, self, self.shareVideo, nil}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISystemNoticeTips, data, nil, nil, nil, Enum.UISibling[Enum.UIType.Top + 1] + 10)
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("录屏失败 请重试")
	end	

end

---@param num number
function UIBattleView:ConverTimeStr(num)
	local second_value = math.floor(num / 60);
	if second_value < 1 then
		return "00:"..num;
	elseif second_value < 10 then 
		return "0"..second_value..":"..num;
	else
		return second_value..":"..num;

	end
end


function UIBattleView:delayTimeFunc()
	if self.isRecording == false  then
		if self.waitTimer and self.waitTimer.running then
			self.waitTimer:Stop()
		end
	end

	if self.mRecordingTime >= 300 then
		LogWarning("waitTimer over ")
		self.isRecording = false
		
		if self.waitTimer  then
			self.waitTimer:Stop()
		end
		return
	end
		
	self.mRecordingTime = self.mRecordingTime + 1
	local second_value = math.floor(self.mRecordingTime %60)
	local min_value = math.floor(self.mRecordingTime / 60)
	local second_str = ""
	local min_str = ""

	self.TimeText:SetActive(true)
	if second_value < 10 then
		second_str =  "0"..second_value;
	else
		second_str = ""..second_value
	end

	if min_value < 10 then
		min_str =  "0"..min_value
	else
		min_str =  ""..min_value
	end

	self.TimeText.text.text = min_str..":"..second_str
end


function UIBattleView:OnStartRecordClick()
	LogWarning("OnStartRecordClick ");
	SDKMgr.Instance:StartRecord()
end

function UIBattleView:shareVideo()
	SDKMgr.Instance:Share()
end

function UIBattleView:onGameServiceClick()
	SDKMgr.Instance:ShowGameService()
end

function UIBattleView:OnStopRecordClick()
	LogWarning("OnStopRecordClick ");
	self.isRecording = false
	SDKMgr.Instance:StopRecord()
end

function UIBattleView:OnPlayerQuery()
	self.controller:SendPlayerQuery(curSelectedData.uid)
	self.funcbg:SetActive(false)
end

function UIBattleView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnChallenge.button,self, self.OnClickChallengeBtn)
	self.uiBase:AddButtonEventListener(self.ReceiveGo.button,self,self.OnClickRewardBtn)
	self.uiBase:AddButtonEventListener(self.quickBattleBtn.button,self,self.OnClickQuickBtn)
	self.uiBase:AddButtonEventListener(self.miniMapBg.button,self,self.OnClickMiniMap)
	self.uiBase:AddButtonEventListener(self.btnOnlineRewards.button,self,self.OnClickOnlineRecord)
	-- self.uiBase:AddButtonEventListener(self.btnCruise.button,self,self.OnClickCruiseBtn)
	--self.uiBase:AddButtonEventListener(self.btnStageGoal.button, self, self.AwardOrJumpStageGoal)


	self.uiBase:AddButtonEventListener(self.newOpen.alpha.button, self, self.OnCloseNewOpen)
	self.uiBase:AddButtonEventListener(self.btnwarlog.button, self, self.OnClickBattleRecordBtn)
	self.uiBase:AddButtonEventListener(self.btnStatistics.button, self, self.OnClickBattleStatisticsBtn)

	self.uiBase:AddButtonEventListener(self.btnAuto.button, self, self.OnClickAutoChallenge)

	--self.uiBase:AddToggleEventListener(self.togworld.toggle, self, self.OnValueChangedToggle, 1)
	--self.uiBase:AddToggleEventListener(self.togguild.toggle, self, self.OnValueChangedToggle, 2)
	--self.uiBase:AddToggleEventListener(self.togsystem.toggle, self, self.OnValueChangedToggle, 3)
	--self.uiBase:AddToggleEventListener(self.togwarlog.toggle, self, self.OnValueChangedToggle, 4)

	self.BossBloodPart:AddUIEventListener()
	self.HeadsBoxPart:AddUIEventListener()
	self.StatisticsPart:AddUIEventListener()
	self.battleReplayPart:AddUIEventListener()
	self.NewBattleChatPart:AddUIEventListener()

	self.uiBase:AddButtonUniqueEventListener(self.btnRedEnvelope.button, self, self.OnNormalREClick)
	self.uiBase:AddButtonUniqueEventListener(self.windowEnvelope.button, self, self.OnHideWindowsEnvelope)

	self.uiBase:AddButtonUniqueEventListener(self.startRecordBtn.button, self, self.OnStartRecordClick)
	self.uiBase:AddButtonUniqueEventListener(self.stoptRecordBtn.button, self, self.OnStopRecordClick)
	self.uiBase:AddButtonUniqueEventListener(self.gameServiceBtn.button, self, self.onGameServiceClick)

end

function UIBattleView:OnHide()
	self.newFunc = nil
	self:DisposeNewLevelIncrease()

	self.recordSpeed = ManagerContainer.LuaGameMgr:GetGameSpeed();
	ManagerContainer.LuaGameMgr:SetGameSpeed(1)
	needRefreshMinimap = false

	if self.inited then
		self.chatView:SetActive(false)
	end

	if chatHideTimer then
		ManagerContainer.LuaTimerMgr:RemoveTimer(chatHideTimer)
		chatHideTimer = nil
	end
	ManagerContainer.LuaBattleMgr:StopAutoChallenge(true)
end

function UIBattleView:OnShow()

	ManagerContainer.LuaGameMgr:SetGameSpeed(self.recordSpeed)
	self:InitComs();
	self:OnRefreshEarnings();
	self:LoadMinimap()
	self:InitCruise()
	--self:RefreshChatBg()

	if self.btnBossAnimator.activeInHierarchy then
		self.btnBossAnimator.animator:Play(self.challengeAnimName);
	end
	self:OnRefreshRewardTime();

	--self:RefreshStageGoalUI()

	local result = ManagerContainer.UIFuncUnlockMgr:GetNeedDisplayNewFuncStatus()
	if result then
		self:FuncOpen1()
	else
		self.newOpen:SetActive(false)
	end

	self.btnAuto:SetActive(false)
	
	needRefreshMinimap = true

	--self.chatView:SetActive(true)

	--self.battleLogView:SetActive(false)
	self.battleRootNew:SetActive(true)
	--self:HandleChatToggleBtns(1)
	if not ManagerContainer.LuaBattleMgr:GetBossFightState() then
		self.MapRootGo:SetActive(true)
	end
	self:RefreshOnlineRecordBtn()
end

function UIBattleView:OnClose()
	DG.Tweening.DOTween.Kill(self.windowEnvelope.transform)

	if updateHandle ~= nil then
		UpdateBeat:RemoveListener(updateHandle)
		updateHandle = nil
	end

	self.logList = nil
	if chatHideTimer then
		ManagerContainer.LuaTimerMgr:RemoveTimer(chatHideTimer)
		chatHideTimer = nil
	end

	if self.inited then
		self.battleLogView.loopVerticalScrollRect:SetUpdateCellCallback(nil,nil)
		-- self:ClearBattleSkillTimer()

		if self.openRewardTimer ~= nil then
			ManagerContainer.LuaTimerMgr:RemoveTimer(self.openRewardTimer);
			self.openRewardTimer = nil
		end
		ManagerContainer.LuaGameMgr:SetGameSpeed(1)
		self.controller:SetChatChannelType(nil)
	end

	if self.BossBloodPart ~= nil then
		self.BossBloodPart:Dispose()
		self.BossBloodPart = nil
	end

	if self.HeadsBoxPart ~= nil then
		self.HeadsBoxPart:Dispose()
		self.HeadsBoxPart = nil
	end

	if self.StatisticsPart ~= nil then
		self.StatisticsPart:Dispose()
		self.StatisticsPart = nil
	end

	if self.battleReplayPart ~= nil then
		self.battleReplayPart:Dispose()
		self.battleReplayPart = nil
	end
	if self.NewBattleChatPart ~= nil then
		self.NewBattleChatPart:Dispose()
		self.NewBattleChatPart = nil
	end

	pageToggleData = nil
	ManagerContainer.LuaBattleMgr:StopAutoChallenge(true)
	self.uIEventHandler:RemoveListener()
end

function UIBattleView:RefreshStageGoalUI(newProgress)
	local curGoal = ManagerContainer.DataMgr.StageGoalData:GetCurGoalData()
	self.btnStageGoal:SetActive(curGoal ~= nil and curGoal.taskId <= ManagerContainer.CfgMgr:LastTargetTaskId() and curGoal.state <= 1)
	if curGoal ~= nil then
		local goalCfgData = ManagerContainer.CfgMgr:GetTargetTaskDataById(curGoal.taskId)
        if goalCfgData == nil then
            return
        end
		local max = 0
		for _,v in pairs(CommonUtil.DeserializeCfgItemList(goalCfgData.TargetTaskCondition)) do
			max = max + v[#v]
		end

		local progress = ManagerContainer.DataMgr.StageGoalData:GetCurGoalDataProgress()
		local isCompleted = progress == max
		local func
		if not isCompleted then
			self.btnStageGoal.state:SetActive(false)
			func = self.ShowItemTips
		else
			if not newProgress then
				self.btnStageGoal.state:SetActive(true)
				func = self.AwardGoal
			else
				self.btnStageGoal.state:SetActive(false)
				func = self.ShowItemTips
			end
		end

		local data = {cfgId = goalCfgData.TargetReward[1][1], num = goalCfgData.TargetReward[1][2]}
		CommonUtil.UpdateItemPrefab(self, self.btnStageGoal.iconItem, data, Enum.ItemIEnterType.Bag, self, func)

		if max < 4 then
			self.btnStageGoal.points.gridLayoutGroup.spacing = stageGoalGridSpacing[1]
		elseif max == 4 then
			self.btnStageGoal.points.gridLayoutGroup.spacing = stageGoalGridSpacing[2]
		elseif max == 5 then
			self.btnStageGoal.points.gridLayoutGroup.spacing = stageGoalGridSpacing[3]
		end


		for i = 1, Constant.StageGoalMaxPoints do
			self["point"..i]:SetActive(i <= max)
			if i <= max then
				self["point"..i].light.animator:Play(i < progress and "CupKeep" or "CupEmpty")
				if newProgress then
					newStageCompeleted = newProgress
				else
					if i == progress then
						self["point"..i].light.animator:Play("CupKeep")
					end
				end
			end
		end
	end
end

function UIBattleView:NewStageCompletedNtf()
	if newStageCompeleted then
		newStageCompeleted = false
		local curGoal = ManagerContainer.DataMgr.StageGoalData:GetCurGoalData()
		if curGoal ~= nil then
			local goalCfgData = ManagerContainer.CfgMgr:GetTargetTaskDataById(curGoal.taskId)
			if goalCfgData == nil then
				return
			end
			local max = 0
			for _,v in pairs(CommonUtil.DeserializeCfgItemList(goalCfgData.TargetTaskCondition)) do
				max = max + v[#v]
			end

			if curGoal.state == Enum.TaskStateType.CompletedAndNoReceive then
				self.btnStageGoal.state:SetActive(true)
				local func = self.AwardGoal

				local data = {cfgId = goalCfgData.TargetReward[1][1], num = goalCfgData.TargetReward[1][2]}
				CommonUtil.UpdateItemPrefab(self, self.btnStageGoal.iconItem, data, Enum.ItemIEnterType.Bag, self, func)
			end

			local progress = ManagerContainer.DataMgr.StageGoalData:GetCurGoalDataProgress()
			for i = 1, Constant.StageGoalMaxPoints do
				if i == progress then
					self["point"..i].light.animator:Play("CupShow")
				end
			end
		end
	end
end

function UIBattleView:StageGoalAwarded(list)
	if #list == 0 then
		-- LogError("no item")
		return
	end

	local data = {cfgId = list[1].key, num = list[1].value}
	local data1 = {list = {data}, startPoses = {self.btnStageGoal.iconItem.transform.position}, enterType = Enum.ItemIEnterType.StageGoal}
	ManagerContainer.LuaUIMgr:POPGotAnimNotice(data1)
	self:RefreshStageGoalUI()
end

function UIBattleView:AwardOrJumpStageGoal(button, params)
	local curGoal = ManagerContainer.DataMgr.StageGoalData:GetCurGoalData()
	if curGoal ~= nil then
		if curGoal.state ~= 1 then
			local goalCfgData = ManagerContainer.CfgMgr:GetTargetTaskDataById(curGoal.taskId)
			local data = ManagerContainer.CfgMgr:GetUIJumpData(goalCfgData.SkipInterface)
			if data == nil then return end

			ManagerContainer.UIJumpMgr:CreateJumpTask(data)
		else
			self:AwardGoal()
		end
	end
end

function UIBattleView:AwardGoal()
	local curGoal = ManagerContainer.DataMgr.StageGoalData:GetCurGoalData()
	if curGoal ~= nil then
		if curGoal.state ~= 1 then
			local goalCfgData = ManagerContainer.CfgMgr:GetTargetTaskDataById(curGoal.taskId)
			local data = {cfgId = goalCfgData.TargetReward[1][1], num = goalCfgData.TargetReward[1][2]}
			--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIItemTips, data)
			ManagerContainer.LuaUIMgr:OpenTips(data)
		else
			self.stageGoalNtf:SetActive(false)
			self.controller:SendGetMainTaskRewardReq()
		end
	end
end

function UIBattleView:ShowItemTips(button, params)
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIItemTips, params[0])
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIBattleView:OnDispose()
	self.battleLoadingState = nil
	self.chatView.loopListView:Dispose()

	self:DisposeNewLevelIncrease()
	if bossMaskTimer ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(bossMaskTimer)
		bossMaskTimer = nil
	end

	needRefreshMinimap = false
	self.miniMapGoes = nil
	if updateHandle ~= nil then
		UpdateBeat:RemoveListener(updateHandle)
		updateHandle = nil
	end

	DG.Tweening.DOTween.Kill(self.transform)
	self.battleLogView.uIEventTriggerListener.onPointerUp = nil
	self.battleLogView.uIEventTriggerListener.onClick = nil
	UIMainCtr = nil
end

function UIBattleView:OnClickQuickBtn()
	if self.controller:IsUnlockQuickBattle() then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIQuickBattle)
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(self.controller:UnlockQuickBattleCondition())
	end
end

function UIBattleView:OnClickRewardBtn()
	if bBossStage then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Fighting2")
		return
	else
		ManagerContainer.LuaBattleMgr:SendBattleIncomeReq()
	end

	self.RewardBoxBtn.animator:Play("ChestPressedNew");
end

function UIBattleView:OnAutoChallengeClickEvent()
	if ManagerContainer.LuaBattleMgr:GetAutoChallengeState() and not bBossStage then
		ManagerContainer.LuaBattleMgr:StopAutoChallenge(true)
	end
end

function UIBattleView:OnStartAutoChallenge()
	if not ManagerContainer.LuaBattleMgr:GetAutoChallengeState() then
		return
	end
	self:DisposeNewLevelIncrease()

	if bBossStage then
		return;
	end

	if bossFightCDRemainTime > 0 then
		ManagerContainer.LuaBattleMgr:StopAutoChallenge(true)
		return;
	end

	local roleLv = ManagerContainer.DataMgr.UserData:GetRoleLv()
	local challengeLv = LuaBattleBridge.GetCurLevelChallengeLv()
	if roleLv < challengeLv then
		ManagerContainer.LuaBattleMgr:StopAutoChallenge(true)
		return
	end

	local jobLv = ManagerContainer.DataMgr.UserData:GetJobLv()
	local maxJobLv = ManagerContainer.DataMgr.UserData:GetJobMaxLevel()
	local jobStage = ManagerContainer.DataMgr.UserData:GetJobStage()
	if jobStage<3 and jobLv>= maxJobLv then
		ManagerContainer.LuaBattleMgr:StopAutoChallenge(true)
		return
	end

	--self.challengeAnimName = "BtnBoss2"
	--
	--if self.btnBossAnimator.activeInHierarchy then
	--	self.btnBossAnimator.animator:Play(self.challengeAnimName);
	--end

	local battleLoadingState,text = ManagerContainer.LuaBattleMgr:GetBattleLoadingState()
	if battleLoadingState then
		ManagerContainer.LuaBattleMgr:StopAutoChallenge(true)
		return
	end
	self:StartBattleBoss()
end

function UIBattleView:OnClickChallengeBtn(btn)
	self:DisposeNewLevelIncrease()

	if bBossStage then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Fighting1")
		return;
	end

	if bossFightCDRemainTime > 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam("FightCD", math.ceil(bossFightCDRemainTime))
		return;
	end

	local roleLv = ManagerContainer.DataMgr.UserData:GetRoleLv()
	local challengeLv = LuaBattleBridge.GetCurLevelChallengeLv()
	if roleLv < challengeLv then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.SetLanguageValue("LevelLimit", challengeLv))
		return
	end

	local jobLv = ManagerContainer.DataMgr.UserData:GetJobLv()
	local maxJobLv = ManagerContainer.DataMgr.UserData:GetJobMaxLevel()
	local jobStage = ManagerContainer.DataMgr.UserData:GetJobStage()
	if jobStage<3 and jobLv>= maxJobLv then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("JobLimit"))
		return
	end

	--self.challengeAnimName = "BtnBoss2"
	--
	--if self.btnBossAnimator.activeInHierarchy then
	--	self.btnBossAnimator.animator:Play(self.challengeAnimName);
	--end

	local battleLoadingState,text = ManagerContainer.LuaBattleMgr:GetBattleLoadingState()
	if battleLoadingState then
		self.battleLoadingState = battleLoadingState
		self.btnChallenge.battleState.text.text = I18N.T(text)
		return
	end
	self:StartBattleBoss()

end

function UIBattleView:StartBattleBoss()
	local levelCfgId = ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId()

	local levelCfgData = ManagerContainer.CfgMgr:GetLevelDataById(levelCfgId)
	LogWarning("levelCfg " .. Inspect(levelCfgData))
	LogWarning("levelCfgData BossKey " .. levelCfgData.BossId)

	if levelCfgData and levelCfgData.BossKey ~= "" then
		ManagerContainer.DataMgr.ChatData:AddLocalNewSystemData(levelCfgData.BossKey)
		LogWarning("levelCfgData BossKey " .. levelCfgData.BossKey)
	end

	local datas = System.Collections.Generic.Dictionary_object_object()
	datas:Add('eventName', 'KillBoss')
	datas:Add('player', ManagerContainer.LuaGameMgr.IsNewPlayer)
	datas:Add('levelCfgId', levelCfgId)
	datas:Add('BossId', levelCfgData.BossId)
	SDKMgr.Instance:ReportAction(datas)
	ManagerContainer.LuaBattleMgr:SendChallengeBossReq()
end

function UIBattleView:OnChallengeBossAck(factorList)
	local curLevelId = ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId()
	local levelCfgData = ManagerContainer.CfgMgr:GetLevelDataById(curLevelId)
	bossFightCDRemainTime = levelCfgData.FightCD

	ManagerContainer.LuaUIMgr:OpenInputMask(9500)

	bBossStage = true
	bBoxState = true

	local battleFactors = System.Array.CreateInstance(Enum.TypeInfo.ValType, #factorList)
	for i = 1, #factorList do
		local factor = ValType.New(factorList[i].key,factorList[i].value)
		battleFactors[i-1] = factor
	end

	local teams = ManagerContainer.DataMgr.UserData:GetTeamData(true)
	for i = 1 , #teams do
		local actor = ManagerContainer.LuaActorDataMgr:GetActorsById(teams[i].uid,teams[i].id)
		--增加对应压制mark
		ManagerContainer.DataMgr.UserData:SetActorPveMark(teams[i].uid,actor)
	end

	LuaBattleBridge.ClickChallegeBoss(battleFactors);
	self.btnAuto:SetActive(Constant.OpenPay or false)
	local autoCState = ManagerContainer.LuaBattleMgr:GetAutoChallengeState()
	if autoCState then
		self.autoAnim.animator:Play("AutoIn")
	else
		self.autoAnim.animator:Play("AutoKeep")
	end
end

function UIBattleView:OnRefreshBossChallengeTime(time)
	bossFightCDRemainTime = time
end

function UIBattleView:BattleLoadingCompeleted()
	self.btnChallenge.battleState.text.text = I18N.T("BtnChallengeBOSS")
	if self.battleLoadingState then
		self.battleLoadingState = nil
		--self:StartBattleBoss()
	end
end

function UIBattleView:OnClickMiniMap()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBigMap, {id = ManagerContainer.LuaBattleMgr:GetCurMapId()})
end

function UIBattleView:OnBossDead()
	self.rageBoxGo:SetActive(false)
end

function UIBattleView:OnBossSpawned(bossActor,bossName,life,maxLife,skillParam,isPlayRecord)
	if bossMaskTimer ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(bossMaskTimer)
		bossMaskTimer = nil
	end
	bossMaskTimer = ManagerContainer.LuaTimerMgr:AddTimer(1500, 1, self, self.CloseInputMask, nil)

	self.exploringTrans:SetActive(false);
	if self.btnBossAnimator ~= nil then
		self.challengeAnimName = "BtnBoss3"
		self.btnBossAnimator.animator:Play(self.challengeAnimName);
	end

	self.quickBattleBtn.button.interactable = false
	if self.openRewardTimer~=nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self.openRewardTimer)
		self.openRewardTimer = nil;
	end
	self:OnHideLevelName()
	self:SetBossBattleInfo()

	self.StatisticsPart:SetCanvasOrder(self.uiBase.SortingOrder-1)
	self.BossBloodPart:Show(bossActor,bossName,life,maxLife,skillParam)
	self.HeadsBoxPart:Show()
	self.StatisticsPart:Show(BattleMode.Normal,BattleSubMode.None)
	if isPlayRecord then
		self.battleReplayPart:SetCanvasOrder(self.uiBase.SortingOrder-1)
		self.battleReplayPart:Show(ManagerContainer.LuaBattleMgr:GetCurrentLevelData().Name)
		self.battleRootNew:SetActive(false)
	end
	self.dragBg:SetActive(false)

	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIBattleReward)
	self:DisposeNewLevelIncrease()
	ManagerContainer.LuaGameMgr:SetGameSpeed(ManagerContainer.LuaGameMgr.GameSpeed)
end

function UIBattleView:CloseInputMask()
	ManagerContainer.LuaUIMgr:CloseInputMask()
end

function UIBattleView:BossBattleEnd(isPlayRecord)
	self.dragBg:SetActive(true)
	bBossStage = false
	bBoxState = false
	self:RefreshRedEnvelope()
	self:PlayChallengeBtnNormalAnim()
	if isPlayRecord then
		self.battleReplayPart:Hide()
		self.battleRootNew:SetActive(true)
	end
	self.btnAuto:SetActive(false)
end

function UIBattleView:SetBossBattleInfo()
	self.centerNode:SetActive(false)
	self.MapRootGo:SetActive(false)
	self.btnwarlog:SetActive(false)
	self.btnStatistics:SetActive(false)
	self:RefreshRedEnvelope()

	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BOSS_BATTLE_STATUS,true)
end

local remainTime = 5
function UIBattleView:RefreshRedEnvelope()
	if not Constant.OpenPay then
		self.btnRedEnvelope:SetActive(false)
		self.windowEnvelope:SetActive(false)
		return
	end
	local curLevelId = ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId()
	local levelCfgData = ManagerContainer.CfgMgr:GetLevelDataById(curLevelId)

	local reActItem = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(Enum.ActivityType.ACTIVITY_TYPE_CASH_SHOP)
	local state = reActItem and reActItem:IsUnlocked() and reActItem:IsOpened() and not reActItem:IsOutofDate()
	self.btnRedEnvelope:SetActive(state)
	self.windowEnvelope:SetActive(false)
	if state then
		if bBossStage then
			self:OnShowWindowsEnvelope()
			self.uiBase:AddButtonUniqueEventListener(self.btnRedEnvelope.button, self, self.OnBattleREClick)
		else
			self:OnHideWindowsEnvelope()
			self:OnRedEnvelopeRemainTimeRefresh()
			self.uiBase:AddButtonUniqueEventListener(self.btnRedEnvelope.button, self, self.OnNormalREClick)
		end
	else
		if self.btnRedEnvelope.activeSelf then
			self.btnRedEnvelope:SetActive(false)
		end
		if self.windowEnvelope.activeSelf then
			self.windowEnvelope:SetActive(false)
		end
	end
end

function UIBattleView:OnHideWindowsEnvelope()
	self.windowEnvelope.transform:DOMove(self.btnRedEnvelope.transform.position, 0.3):SetEase(DG.Tweening.Ease.InQuint)
	self.windowEnvelope.transform:DOScale(0, 0.3):SetEase(DG.Tweening.Ease.InQuint):OnComplete(function()
		self.windowEnvelope:SetActive(false)
		DG.Tweening.DOTween.Kill(self.windowEnvelope.transform)

		self.btnRedEnvelope:SetActive(true)
	end)
end

function UIBattleView:OnShowWindowsEnvelope()
	DG.Tweening.DOTween.Kill(self.windowEnvelope.transform)
	local curLevelId = ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId()
	local levelCfgData = ManagerContainer.CfgMgr:GetLevelDataById(curLevelId)
	if levelCfgData.Cash == 0 then
		self.btnRedEnvelope:SetActive(false)
		self.windowEnvelope:SetActive(false)
		return
	end

	self.windowEnvelope.transform.localScale = Vector3.zero
	self.windowEnvelope.cashNumber.text.text = levelCfgData.Cash
	self.windowEnvelope.textRank.uILocalizeScript:SetContentAndValues("CashReward01", {levelCfgData.PassNum})
	self.btnRedEnvelope:SetActive(false)
	self.windowEnvelope:SetActive(true)
	self.windowEnvelope.transform.position = self.btnRedEnvelope.transform.position
	self.windowEnvelope.transform:DOMove(windowREPos, 0.3):SetEase(DG.Tweening.Ease.OutQuint)
	self.windowEnvelope.transform:DOScale(1, 0.3):SetEase(DG.Tweening.Ease.OutBounce):OnComplete(function()
		remainTime = 5
		self.windowEnvelope.text.text.text = string.formatbykey("CashReward03", remainTime)
		self.windowEnvelope.transform:DOScale(1, 1):SetLoops(5):OnStepComplete(function ()
			remainTime = remainTime - 1
			self.windowEnvelope.text.text.text = string.formatbykey("CashReward03", remainTime)
			if remainTime == 0 then
				self.windowEnvelope.transform:DOMove(self.btnRedEnvelope.transform.position, 0.3):SetEase(DG.Tweening.Ease.InQuint)
				self.windowEnvelope.transform:DOScale(0, 0.3):SetEase(DG.Tweening.Ease.InQuint):OnComplete(function()
					self.windowEnvelope:SetActive(false)
					DG.Tweening.DOTween.Kill(self.windowEnvelope.transform)

					self.btnRedEnvelope:SetActive(true)
				end)
			end
		end)
	end)
end

function UIBattleView:OnRedEnvelopeRemainTimeRefresh()
	if not Constant.OpenPay then
		self.btnRedEnvelope:SetActive(false)
		self.windowEnvelope:SetActive(false)
		return
	end
	local reActItem = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(Enum.ActivityType.ACTIVITY_TYPE_CASH_SHOP)
	local state = reActItem and reActItem:IsUnlocked() and reActItem:IsOpened() and not reActItem:IsOutofDate()
	self.btnRedEnvelope:SetActive(state)
	if not state then
		self.windowEnvelope:SetActive(false)
		return
	end

	local curLevelId = ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId()
	local levelCfgData = ManagerContainer.CfgMgr:GetLevelDataById(curLevelId)
	if levelCfgData.Cash == 0 and bBossStage then
		if self.btnRedEnvelope.activeSelf then
			self.btnRedEnvelope:SetActive(false)
		end
		if self.windowEnvelope.activeSelf then
			self.windowEnvelope:SetActive(false)
		end
		return
	end

	local leftSeconds = reActItem:LeftTime()
	if leftSeconds > 0 then
		if leftSeconds <= 60 then
			self.btnRedEnvelope.text.text.text = I18N.T("LessOneMinu")
		else
			local time = DateTimeUtil.convertSeconds2TimeStr1(leftSeconds, true, false)
			self.btnRedEnvelope.text.text.text = time
		end
	else
		if self.btnRedEnvelope.activeSelf then
			self.btnRedEnvelope:SetActive(false)
		end
		if self.windowEnvelope.activeSelf then
			self.windowEnvelope:SetActive(false)
		end
	end
end

function UIBattleView:OnBattleREClick()
	self:OnShowWindowsEnvelope()
end

function UIBattleView:OnNormalREClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIREShop, nil, self.uiData.id)
end

function UIBattleView:ShowBattleNormalUI()
	if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIBattle) then
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BOSS_BATTLE_STATUS,false)
	end
	self.transform:DOScale(1, 0.8):OnComplete(function ()
		self:ShowBattleNormalUI1()
	end)
end

function UIBattleView:ShowBattleNormalUI1()
	--self.bottomNode:SetActive(true)
	self.centerNode:SetActive(true)
	--self.ProfitBoxGo:SetActive(true)
	if not ManagerContainer.LuaBattleMgr:GetBossFightState() then
        self.MapRootGo:SetActive(true)        
    end    
	self.btnwarlog:SetActive(true)
	self.btnStatistics:SetActive(true)

	-- self:OnValueChangedToggle(nil,1, true)
end

function UIBattleView:OnContinueBattle()
	bBoxState = false
	self.battleFailGo:SetActive(false);
	self:PlayRewardNormalAnim();
end

function UIBattleView:OnBattleWin()
	self:RestoreSpeed()
	self.BossBloodPart:Hide()
	self.HeadsBoxPart:Hide()
	self.StatisticsPart:Hide()
	self.rageBoxGo:SetActive(false)
end

function UIBattleView:OnBattleFailed(killboss,isPlayRecord)
	self:RestoreSpeed()
	-- self.battleFailGo:SetActive(true);
	self.BossBloodPart:Hide()
	self.HeadsBoxPart:Hide()
	self.StatisticsPart:Hide()
	self.rageBoxGo:SetActive(false)

	self:PlayChallengeBtnNormalAnim()
	self:PlayRewardNormalAnim()	
	if killboss and (not isPlayRecord) then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIClimbingTowerBattleFailed,Enum.UIPageName.UIBattle)
	else
		self.battleFailGo:SetActive(true)
	end
	--self:ShowBattleNormalUI()
end


function UIBattleView:OnForceBattleFailed(killboss,isPlayRecord)
	self:RestoreSpeed()
	-- self.battleFailGo:SetActive(true);
	self.BossBloodPart:Hide()
	self.HeadsBoxPart:Hide()
	self.StatisticsPart:Hide()
	self.rageBoxGo:SetActive(false)

	self:PlayChallengeBtnNormalAnim()
	self:PlayRewardNormalAnim()	
	if killboss and (not isPlayRecord) then
		--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIClimbingTowerBattleFailed,Enum.UIPageName.UIBattle)
	end	
	self.battleFailGo:SetActive(false)
end

function UIBattleView:RestoreSpeed()
	ManagerContainer.LuaGameMgr:SetGameSpeed(1)
end

function UIBattleView:FuncOpen()
	self:PlayChallengeBtnNormalAnim()
	self:PlayRewardNormalAnim();
	self:OnRefreshEarnings();
	--if ManagerContainer.LuaUIMgr.CurrentPage.PageId == self.uiData.id then
		self:FuncOpen1()
	--end
end

function UIBattleView:FuncOpen1()
	local levelId = ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId()
	local newFuncs, nearFuncs, forceGuideList = ManagerContainer.UIFuncUnlockMgr:GetNewFuncAndNearFuncByLevelId(levelId)
	if newFuncs[1] == nil then
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_OVER, true)
		return
	end

	local newFunc = newFuncs[1]
	self.newFuncs = newFuncs
	if #forceGuideList > 0 then
		self.controller:SetNewForceId(forceGuideList[1])
	end
	local newFuncData = ManagerContainer.CfgMgr:GetUIFuncUnLockCfgDataById(newFunc)
	CommonUtil.LoadIcon(self, newFuncData.FunIcon, function (sprite)
		self.newOpen.image.image.sprite = sprite
		self.newOpen.imageLt.image.sprite = sprite
	end)

	self.newOpen.nameTxt.text.text = I18N.T(newFuncData.FunName)
	self.newOpen.dscTxt.text.text = I18N.T(newFuncData.FunDsc)

	local item = self.newOpen.item
	item:SetActive(nearFuncs[1] ~= nil)
	if nearFuncs[1] ~= nil then
		local nearData = ManagerContainer.CfgMgr:GetUIFuncUnLockCfgDataById(nearFuncs[1])
		CommonUtil.LoadIcon(self, nearData.FunIcon, function (sprite)
			item.image.image.sprite = sprite
		end)

		local result,val,content = ManagerContainer.UIFuncUnlockMgr:CheckConditionPassResult(nearData)
		item.itemTxt.text.text = I18N.T(nearData.FunName).."("..content..")"
	end

	self.newOpen:SetActive(true)
end

function UIBattleView:OnTaskClick()
	ManagerContainer.DataMgr.TaskDataNew:OpenTaskPanel();
end

function UIBattleView:OnCloseNewOpen()
	self.newOpen:SetActive(false)
	if self.newFuncs then
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_UNLOCK_NTF, self.newFuncs)
		self.newFuncs = nil
	end

	local newForceId = self.controller:GetNewForceId()
	if newForceId then
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_TRIGGER, Enum.ForceGuideTriggerEnum.FuncOpen, newForceId)
		self.controller:SetNewForceId()
	else
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_OVER, true)
	end
end

function UIBattleView:OnBattleNewWave(levelName)
	self.battleFailGo:SetActive(false);
	self:OnRefreshEarnings();
end

function UIBattleView:OnHideLevelName()
end

function UIBattleView:OnShowBossRage()
	self.rageBoxGo:SetActive(true)
end

function UIBattleView:OnShowBossRageLeftTime(leftTime)
	self:RefreshRageTime(leftTime)
end

function UIBattleView:OnBossInRage()
	self.rageBoxGo:SetActive(false)
end

function UIBattleView:PlayChallengeBtnNormalAnim()
	if self.btnBossAnimator~= nil then
		self.challengeAnimName = bossFightCDRemainTime <= 0 and "BtnBoss1" or "BtnBoss4"
		if self.btnBossAnimator.activeInHierarchy then
			self.btnBossAnimator.animator:Play(self.challengeAnimName);
		end

		if bossFightCDRemainTime > 0 then
			self.btnChallenge.remainCDTime.text.text = I18N.SetLanguageValue("FightCD", math.ceil(bossFightCDRemainTime))
		end
	end
	--self.ReceiveGo:SetActive(true);
	self.quickBattleBtn.button.interactable = true
end

function UIBattleView:PlayRewardNormalAnim()
	self:OnRefreshRewardTime();
end

function UIBattleView:RefreshRageTime(leftTime)
	if leftTime ~= nil then
		local spriteName = nil
		if leftTime == 10 then
			spriteName = "Alert_number_0"
		else
			spriteName = "Alert_number_"..leftTime
		end

		self.rageNum1.image.sprite  = self.rageNum1.switchSprite:GetSprite(spriteName)
		self.rageNum2.image.sprite  = self.rageNum2.switchSprite:GetSprite(spriteName)
		if leftTime == 1 then
			self.rageBoxGo.bg.animator:Play("BafengteAlertEnd")
		end
	end
end

function UIBattleView:OnShowBossWarning(vis)
	self.bossWarning.animator.gameObject:SetActive(vis)
end

function UIBattleView:OnRefreshEarnings()
	self.ExpLbl.text.text = ManagerContainer.LuaBattleMgr:CurLevelExp() .. "/" .. I18N.T("m") ;
	self.ZenyLbl.text.text = ManagerContainer.LuaBattleMgr:CurLevelZeny() .. "/" ..  I18N.T("m");
	self.ParnterExpLbl.text.text = ManagerContainer.LuaBattleMgr:CurLevelParnterExp() .. "/" ..  I18N.T("m");
	self.CruiseLbl.text.text = ManagerContainer.LuaBattleMgr:CurLevelCruise() .. "/" ..  I18N.T("m");
	self.CurLevelName.text.text = ManagerContainer.LuaBattleMgr:CurLevelName();

	ManagerContainer.LuaBattleMgr:SetRewardDropPos(self.RewardBoxBtnPos);

	local lockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(35)
	ManagerContainer.LuaUIMgr:SetBattleDropRootVisible(lockState)
end

function UIBattleView:OnRefreshRewardTime()

	local passedTime = ManagerContainer.LuaBattleMgr:AccumIncomeTime();
	local maxTime = ManagerContainer.LuaBattleMgr:MaxInComeTime() * 1000
	if passedTime >=  maxTime then
		passedTime = maxTime
	end

	local leftTime,num = ManagerContainer.LuaBattleMgr:GetIncomeInfo()
	if num == nil then
		num = 0
	end

	self.rewardPoint:SetActive(num >= 1)
	if num > 999 then
		self.rewardPoint.num.text.text = "999+"
	else
		self.rewardPoint.num.text.text = tostring(num)
	end

	if passedTime >= maxTime then
		self.RewardTimeLbl.text.text = "Max";
	else
		self.RewardTimeLbl.text.text = DateTimeUtil.convertSeconds2TimeStr(leftTime,true);
	end
	self:CheckRewardBoxStatus(passedTime)
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_HANG_TIME,passedTime);
end

function UIBattleView:CheckRewardBoxStatus(passedTime)
	local animName = "Chest01New"
	if bBoxState then
		animName = "ChestClose"
	else
		if passedTime <= self.statTime1 then
			animName = "Chest01New"
		elseif passedTime <= self.statTime2 then
			animName = "Chest02New"
		elseif passedTime <= self.statTime3 then
			animName = "Chest03New"
		else
			animName = "Chest04New"
		end
	end

	if self.RewardBoxBtn.activeInHierarchy then
		self.RewardBoxBtn.animator:Play(animName);
	end
end

function UIBattleView:OnBattleIncomeAck(dropLoc)
	local zeny = ManagerContainer.LuaBattleMgr:GetRewardCnt(Enum.ItemType.Coin)
	local partnerExp = ManagerContainer.LuaBattleMgr:GetRewardCnt(Enum.ItemType.ParterExp)
	local exp = ManagerContainer.LuaBattleMgr:GetRewardCnt(Enum.ItemType.RoleBaseExp)
	local createZeny = false;
	local createExp=false;
	local createPartnerExp = false;

	if UIMainCtr == nil then
		UIMainCtr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIMain)
	end

	local zenyPos = UIMainCtr:GeAnchoredPosition3DByType(Enum.ItemType.Coin)
	local expPos = UIMainCtr:GeAnchoredPosition3DByType(Enum.ItemType.RoleBaseExp)
	local bagPos = UIMainCtr:GeAnchoredPosition3DByType(Enum.ItemType.ParterExp)

	if zeny ~= nil and zeny > 0 then
		createZeny = true
	end

	if partnerExp~= nil and partnerExp > 0 then
		createPartnerExp = true
	end

	if exp ~= nil and exp > 0 then
		createExp = true
	end

	local itemIcons = {};
	for i =1, #ManagerContainer.LuaBattleMgr.rewardItemList do
		local item = ManagerContainer.LuaBattleMgr.rewardItemList[i];
		if item.key >= 100 then
			local itemCfg = ManagerContainer.CfgMgr:GetItemById(item.key)
			if itemCfg~= nil then
				itemIcons[#itemIcons+1] = itemCfg.Icon
			end
		end
	end
	self.dropType = dropLoc;

	if dropLoc == 0 then
		LuaBattleBridge.GenerateDropItems(self.RewardBoxBtnPos,createZeny,zenyPos,createExp,expPos,createPartnerExp,bagPos,false,Vector3.zero,0.15,0.25,unpack(itemIcons));
	else
		LuaBattleBridge.GenerateDropItems(Vector3.New(0, 0, 0),createZeny,zenyPos,createExp,expPos,createPartnerExp,bagPos,false,Vector3.zero,0.30,0.25,unpack(itemIcons));
	end

	if self.openRewardTimer ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self.openRewardTimer)
		self.openRewardTimer = nil
	end
	self.openRewardTimer = ManagerContainer.LuaTimerMgr:AddTimer(GlobalConfig.Instance:GetConfigFloatValue(78)*1000, 1, self, self.OnOpenRewardPage, nil)
end

function UIBattleView:OnOpenRewardPage()
	self.openRewardTimer = nil
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleReward,self.dropType)
end

function UIBattleView:LoadMinimap()
	local mapId = ManagerContainer.LuaBattleMgr:GetCurMapId()
	local mapCfgData = ManagerContainer.CfgMgr:GetMapData(mapId)

	local center = mapCfgData.Center
	self.mapCenter = Vector3.New(center[1], center[2], center[3])
	self.mapSizeX = mapCfgData.RealSizeX
	self.mapSizeZ = mapCfgData.RealSizeZ

	local scale = mapCfgData.MinimapScale *0.01
	self.minimap.transform.localScale = Vector3.New(scale, scale, scale)
	self.minimapSizeX = mapCfgData.MinimapSizeX * scale
	self.minimapSizeZ = mapCfgData.MinimapSizeZ * scale

	CommonUtil.LoadTexture(self, mapCfgData.MinimapIcon, function (texture)
		self.minimap.rawImage.texture = texture

		self:RefreshMinimapInfo()
	end)
end

function UIBattleView:WorldPos2MinimapPos(pos)
	local xRate = pos.x / self.mapSizeX
	local zRate = pos.z / self.mapSizeZ
	local x = self.minimapSizeX * xRate
	local z = self.minimapSizeZ * zRate
	return x,z
end

function UIBattleView:OnRefreshMinimap()
	self:RefreshMinimapInfo()
end

function UIBattleView:RefreshMinimapInfo()
	if self.miniMapGoes == nil then
		return
	end

	if ManagerContainer.LuaBattleMgr.isBattleing then
		return
	end
	LuaBattleBridge.RefreshMinimap(self.mapCenter, self.mapSizeX,self.mapSizeZ,self.minimapSizeX,self.minimapSizeZ, self.hero,unpack(self.miniMapGoes))
end

function UIBattleView:InitCruise()
end

function UIBattleView:RefreshCruise()
end

function UIBattleView:OnClickCruiseBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UITreasures)
end

function UIBattleView:OnClickMailBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIMailBox)
end

function UIBattleView:GeAnchoredPosition3DByType(type)
	if type ~= Enum.ItemType.RoleJobExp and type ~= Enum.ItemType.RoleBaseExp then
		return self.ReceiveGo.transform.position
	end

	return Vector3.zero
end

function UIBattleView:GetMiniMapPosition()
	return self.minimap.transform.parent.position
end

function UIBattleView:RewardBoxRefresh()
	bBoxState = false
	self:PlayRewardNormalAnim();
end

function UIBattleView:GetBattleState()
	return bBossStage
end

function UIBattleView:PopGotAnimEnd(type)
	if type == Enum.ItemIEnterType.BattleWin then
		self:PlayChallengeBtnNormalAnim()
	end
end

function UIBattleView:NewLevelIncrease()
	if levelIncreaseTimer ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(levelIncreaseTimer)
		levelIncreaseTimer = nil
	end
	if bBossStage then return end

	local count = 0
	local list = {}

	local lastLevelZeny = ManagerContainer.LuaBattleMgr.lastLevelZeny
	local curLevelZeny = ManagerContainer.LuaBattleMgr:CurLevelZeny()
	if lastLevelZeny < curLevelZeny then
		count = count + 1

		local data = {iconPath = Enum.LevelIncreaseType.Zeny, lastNum = lastLevelZeny, newNum = curLevelZeny}
		list[#list + 1] = data
	end

	local lastLevelExp = ManagerContainer.LuaBattleMgr.lastLevelExp
	local curLevelExp = ManagerContainer.LuaBattleMgr:CurLevelExp()
	if lastLevelExp < curLevelExp then
		count = count + 1

		local data = {iconPath = Enum.LevelIncreaseType.BaseExp, lastNum = lastLevelExp, newNum = curLevelExp}
		list[#list + 1] = data
	end

	local lastLevelPartnerExp = ManagerContainer.LuaBattleMgr.lastLevelPartnerExp
	local curLevelPartnerExp = ManagerContainer.LuaBattleMgr:CurLevelParnterExp()
	if lastLevelPartnerExp < curLevelPartnerExp then
		count = count + 1

		local data = {iconPath = Enum.LevelIncreaseType.Zeny, lastNum = lastLevelPartnerExp, newNum = curLevelPartnerExp}
		list[#list + 1] = data
	end

	local lastLevelCruise = ManagerContainer.LuaBattleMgr.lastLevelCruise
	local curLevelCruise = ManagerContainer.LuaBattleMgr:CurLevelCruise()
	if lastLevelCruise < curLevelCruise then
		count = count + 1

		local data = {iconPath = Enum.LevelIncreaseType.Zeny, lastNum = lastLevelCruise, newNum = curLevelCruise}
		list[#list + 1] = data
	end

	if #list > 0 then
		increaseIdx = 0
		self:ShowLevelIncrease(0, list)
		if #list > 1 then
			levelIncreaseTimer = ManagerContainer.LuaTimerMgr:AddTimer(500, #list - 1, self, self.ShowLevelIncrease, list)
		end
	end
end

function UIBattleView:ShowLevelIncrease(idx, list)
	increaseIdx = increaseIdx + 1
	local data = list[increaseIdx]
	ManagerContainer.GoPoolMgr:SpawnGo(Enum.PrefabNames.LevelIncreaseItem, function(itemlua)
		CommonUtil.BatchCreateItems(self, itemlua, self.centerNode.transform, data)
	end)
end

function UIBattleView:DisposeNewLevelIncrease()
	if levelIncreaseTimer ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(levelIncreaseTimer)
		levelIncreaseTimer = nil
	end
	CommonUtil.RecycleFromBatchItemsByPrefabName(self, Enum.PrefabNames.LevelIncreaseItem)
end

function UIBattleView:IsSomeFrameCount(keyName)
	local value = self[keyName]
	if value and value >= Time.frameCount then
		return true
	end
	self[keyName] = Time.frameCount
	return false
end


 function UIBattleView:OnClickBattleRecordBtn()
	ManagerContainer.LuaBattleMgr:SendBattleRecordReq()
 end

 function UIBattleView:OnClickBattleStatisticsBtn()
	if LuaBattleBridge.HasStatistics(BattleMode.Normal,BattleSubMode.None)  then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleStatistics,{BattleMode.Normal,BattleSubMode.None})
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NullBattleInformation1")
	end
 end

function UIBattleView:OnClickAutoChallenge()
	if not ManagerContainer.DataMgr.RuneShopDataMgr:CheckSuperMonth() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("nomonthcard")
		ManagerContainer.LuaBattleMgr:StopAutoChallenge()
		return
	end
	if ManagerContainer.LuaBattleMgr:GetAutoChallengeState() then
		self.autoAnim.animator:Play("AutoKeep")
		ManagerContainer.LuaBattleMgr:StopAutoChallenge()
	else
		self.autoAnim.animator:Play("AutoIn")
		ManagerContainer.LuaBattleMgr:SetAutoChallengeState(true)
	end
	
end



function UIBattleView:FindTaskCompeleted1(id, owner, ownerCB)
	local page = ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UIPOPGot)
	if page then
		local pop = page.MLuaTable
		pop:UIClose()
	end

	local target = self.btnChallenge
	if target == nil then
		if owner and ownerCB then
			ownerCB(owner)
		end
		return
	end

	if owner and ownerCB then
		ownerCB(owner, target)
	end
end

return UIBattleView

