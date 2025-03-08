local UIMainView = require("UIMain/UIMainView_Generate")
local MainTopView = require("UIMain/MainTopView")
local MainBottomView = require("UIMain/MainBottomView")
-- local GotAnimCtr = require("UIPOPGot/UIPOPGotAnimsCtr")
local DOTween = DG.Tweening.DOTween
local LoopType = DG.Tweening.LoopType

local curTopResType = Enum.ItemType.Diamond
local _curMainButtonType = Enum.MainViewPageType.Adventure

local mainTopView
local mainBottomView

--- 慧勇需求 经验条，最小不能小于这个值，哪怕为真实值为0
local BarMinValue = 0.02
local AddEffectBarSpeed = 0.5

local bossBattleStatus = false
function UIMainView:OnAwake(data)
	self.controller = require("UIMain/UIMainCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)

end

function UIMainView:AddEventListener()
	-- ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_COIN_AND_DIAMOND, function()
	-- 	self:RefreshCoins()
	-- 	self:RefreshLv()
	-- end)

	-- ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_ROLE_LV, function()
	-- 	self:RefreshLv()
	-- end)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ROLE_EXP_CHANGED, self, self.ShowAddRoleExpEffect)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.JOB_EXP_CHANGED, self, self.ShowAddJobExpEffect)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.COIN_CHANGED, self, self.ShowAddCoinEffect)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.DIAMOND_CHANGED, self, self.ShowAddDiamondEffect)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ROLE_LV_CHANGED, self, self.OnRefreshRoleLv)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.JOB_LV_CHANGED, self, self.OnRefreshJobLv)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.MAIN_VIEW_SET_ATTR_BTN, self, self.CloseBtnBase)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.MAIN_VIEW_UP_SKILL_BTN, self, self.CloseBtnJob)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_HANG_TIME, self, self.RefreshRestTime)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.NICK_NAME_CREATED, self, self.RefreshUserNickName)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.USER_HEADPROTRAIT_CHANGED, self, self.RefreshHead)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.MAIN_CHANGE_BUTTONS_STATE,self,self.SetActiveButtonsState)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.MAIN_UI_ROLE_REDPOINT_NOTICE, self, self.RoleRedPointNotice)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RED_POINT_NOTICE, self, self.RoleRedPointNotice)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_FORCE_GUIDE_OVER, self, self.LoggedinForceGuideOver)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UIMAINVIEW_CHANGE_NOTICE, function(pageType, data)
		self:ChangePageMsg(pageType, data)
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.DISPLAY_MAIN_TOP, function(state, order)
		if mainTopView then
			mainTopView:Change(state, order)
		end
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.DISPLAY_MAIN_BOTTOM, function(state, order)
		if mainBottomView then
			mainBottomView:Change(state, order)
		end
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.LIMIT_RECHARGE_OPEN_NTF, function(state, order)
		if mainTopView then
			mainTopView:OpenLimitRecharge()
		end
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_COIN_AND_JOBEXP, function()
		self:RefreshDiamond()
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_CRUISE_CHANGED, function()
		if curTopResType ~= Enum.ItemType.SkillExp then return end
		self:RefreshDiamond()
	end)

	-- ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GOT_ITEM_ANIM_END_NOTIFY, function(type)
	-- 	LogError("got anim end  "..type)
	-- 	local GotAnimCtr = require("UIPOPGot/UIPOPGotAnimsCtr")
	-- 	local result = GotAnimCtr:IsInSameTypeAnim(type)
	-- 	LogError(result)
	-- end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GOT_ITEM_ANIM_END_NOTIFY, function(type, num)
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_MAIN_TOP_RES_TYPE, function(resType)
		--if Enum.TopResMap[id] == nil then
		--	id = Enum.UIPageName.UIMain
		--end
		--if id == Enum.UIPageName.UIRoleMain1 then
		--	if not param then
		--		id = Enum.UIPageName.UIRoleMain1
		--	else
		--		id = Enum.UIPageName.UIMain
		--	end
		--end

		curTopResType = resType
		self:RefreshDiamond()
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FIGHTPOWER_REFRESH, function()
		self:RefreshFightPower()
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.BTN_BASE_DISPLAY, function(result)
		if result and bossBattleStatus then return end

		self:DisplayBtnBase(result)
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.BTN_JOB_DISPLAY, function(result)
		if result and bossBattleStatus then return end

		self:DisplayBtnJob(result)
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.BOSS_BATTLE_STATUS, function(result)
		bossBattleStatus = result

		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.DISPLAY_MAIN_TOP,not result)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.STAGEGOAL_DISPLAY,not result)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BTN_BASE_DISPLAY,not result)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BTN_JOB_DISPLAY,not result)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.DISPLAY_MAIN_BOTTOM, not result)
		--if result then
		--	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.DISPLAY_MAIN_BOTTOM, result)
		--end
	end)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SEASON_OPEN_NTF, function(competitionId, _isRefresh)
		self:RefreshSeasonInfo()
		if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UISeason) and not _isRefresh then
			local curUIId = ManagerContainer.LuaUIMgr:GetCurUIId()
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISeason, competitionId, curUIId)
		end
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GM_SCROLL_NOTICE, self, self.InsertGMNotice)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ROLE_JOB_CHANGE_SUCCESS, self, self.RefreshJobIcon)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Used_New_HeadFrame, self, self.ChangeHeadFrame)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SEASON_NOTICE_CLOSE_NTF, self, self.RefreshSeasonNoticeState)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SEASON_RANK_CHANGED_NTF, self, self.OnSeasonRankChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_FirstRecharge_Change, self, self.RefreshFirstRechargeBtn)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RANK_ACTIVITY_DISPLAY_NTF, self, self.RefreshRankActivityEnter)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SEASON_MINUTE_UPDATE, self, self.RefreshSeasonInfo)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.QUESTION_REWARD_SUCCESS, self, self.RefreshQuestionRewardBtn)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.AIRSHIP_ACTIVITY_DISPLAY_NTF, self, self.RefreshAirShipActivityEnter)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_OPEN_STATE_CHANGED, self, self.RefreshGuildWarBtn)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.COMBINE_SERVER_TIME_CHANGED, self, self.OnCombineServerTimeChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.COMBINE_SERVER_CONTENT_CHANGED, self, self.OnCombineServerContentChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VIP_LV_CHANGED, self, self.OnVipLvChanged)
	
end

function UIMainView:OnStartRecordEvent(success)
	return
	
end

function UIMainView:OnRecordFinishEvent(success)
	return
end


function UIMainView:OnStartRecordClick()
	LogWarning("OnStartRecordClick ");
	-- SDKMgr.Instance:StartRecord()
end

function UIMainView:shareVideo()
	SDKMgr.Instance:Share()
end


function UIMainView:OnStopRecordClick()
	LogWarning("OnStopRecordClick ");
	-- self.isRecording = false
	-- SDKMgr.Instance:StopRecord()
end


function UIMainView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
	self:DailySignTrigger()
	self.btnGM:SetActive(false)
		
	self.startRecordBtn:SetActive(false)
	self.stoptRecordBtn:SetActive(false)
end

function UIMainView:Init()
	curTopResType = self.uiData.top_res_id
	ManagerContainer.DataMgr.TaskDataNew:SetMainButton(Enum.MainViewPageType.Adventure);

	if mainTopView == nil then
		mainTopView = MainTopView.new()
		mainTopView:Init(self.topView, self.topView.canvas, self.topView.topRoot.animator, self.uiBase.SortingOrder)
	end

	if mainBottomView == nil then
		mainBottomView = MainBottomView.new()
		mainBottomView:Init(self.bottomView, self.bottomView.canvas, self.bottomView.mainRoot.animator, self.uiBase.SortingOrder)
	end

	--ManagerContainer.ResMgr:InitCommonMats()

	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPrivateChatBtn)

	self.isRecording = false
	self.mRecordingTime = 0

	self:Refresh()

	self:RedPointRefresh()

	if mainTopView then
		mainTopView:RefreshTopBtns(true)
	end
	self:RefreshFirstRechargeBtn()
	self:RefreshGuildWarBtn()

	--统一刷新数据
	self:RefreshData()

	local datas = System.Collections.Generic.Dictionary_object_object()
	datas:Add('eventName', 'EnterGame')
	datas:Add('player', ManagerContainer.LuaGameMgr.IsNewPlayer)
	SDKMgr.Instance:ReportAction(datas)
end

function UIMainView:DailySignTrigger()
	local _canSignPlay = ManagerContainer.DataMgr.SignData:CanTodaySign()
	if _canSignPlay then

		--local isUnLock = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(55);
		--if isUnLock then
		--	ManagerContainer.LuaUIMgr:OpenInputMask(10000)
		--end

		self.canSignPlay = true
		self.delayTimer = FrameTimer.New(function()
			self.loggedinNeedForceGuide = ManagerContainer.ForceGuideMgr:LoggedinCheckForceGuide()
			if not self.loggedinNeedForceGuide and not ManagerContainer.StoryMgr:IsStorying() and not ManagerContainer.StoryMgr:HasPreStoryChapter() then
				self:LoggedinForceGuideOver()
			end

			local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(10)
			self:RefreshSeasonNoticeState(unlockState)
		end, 1)
		self.delayTimer:Start()
	else
		self.loggedinNeedForceGuide = ManagerContainer.ForceGuideMgr:LoggedinCheckForceGuide()
		if not self.loggedinNeedForceGuide and not ManagerContainer.StoryMgr:IsStorying() and not ManagerContainer.StoryMgr:HasPreStoryChapter() then
			self:LoggedinForceGuideOver()
		end
	end
end

function UIMainView:RefreshSeasonNoticeState(state)
	self.seasonNotice:SetActive(state)
end

function UIMainView:RefreshData()
	self.dataDelayTimer = FrameTimer.New(function()
		--赛季最新数据查询
		ManagerContainer.DataMgr.CompetitionData:SetRefreshSeasonState(true)
		ManagerContainer.DataMgr.CompetitionData:QueryCurCompetitionReq(true)

		ManagerContainer.DataMgr.RankActivitiesMgr:CheckRancActivityOpenTime()
		ManagerContainer.DataMgr.RuneShopDataMgr:CheckAirShipActivityOpenTime()

		--刷新契约红点
		ManagerContainer.RedPointMgr.PetRPCtr:RefreshTotalQiyueRPState()
	end, 1)
	self.dataDelayTimer:Start()
end

function UIMainView:OnSeasonRankChanged(type)
	self.seasonUp:SetActive(type == 1)
	self.seasonDown:SetActive(type == 2)
end

function UIMainView:RedPointRefresh()
	--宠物红点刷新
	ManagerContainer.DataMgr.PetDataMgr:RefreshAllPetRPState()
end

function UIMainView:Refresh()
	if ManagerContainer.FSMMgr:IsBattleState() then
		self.mainPageId = Enum.UIPageName.UIBattle
		self.mainBtn.animator:Play("AdventureActived");
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattle)
	elseif ManagerContainer.FSMMgr:IsDojoState() then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojo2D)
	end

	self.btnBase:SetActive(ManagerContainer.PlayerPrefsMgr:GetBoolean(Constant.ROLE_LV_STATUS_SAVE_KEY, false))
    self.btnJob:SetActive(ManagerContainer.PlayerPrefsMgr:GetBoolean(Constant.JOB_LV_STATUS_SAVE_KEY, false))

	self:RefreshUserNickName()
	--[[
	self:RefreshUserHeadProtrait()
	self:RefreshJobIcon()
	]]--
	self:RefreshHead();
	self:RefreshFightPower()
	self:RefreshLv()
	self:RefreshRoleExp()
	self:RefreshJobLv()
	self:RefreshJobExp()
	self:RefreshCoins()
	self:RefreshDiamond()
	self:RefreshVipView()
	self:RefreshSeasonInfo()

	self:RoleRedPointNotice()
	self:InsertGMNotice()

	self:StartLimitTimeItem()
end

function UIMainView:StartLimitTimeItem()
	ManagerContainer.DataMgr.BagData:StartLimitTimeItemDelete()
end

function UIMainView:RefreshSeasonInfo()
	local seasonData = ManagerContainer.DataMgr.CompetitionData:GetCurCompetitionData()
	if seasonData == nil then return end

	local stage,nextStageTime = ManagerContainer.DataMgr.CompetitionData:GetCurStageAndNextTime()
	local curCompetitionId = ManagerContainer.DataMgr.CompetitionData:GetCurCompetitionId()
	local competitionCfgDatas = ManagerContainer.CfgMgr:GetCompetitionDatasByType(curCompetitionId)
	if not competitionCfgDatas or #competitionCfgDatas == 0 then
		return
	end

	self.SeasonName.text.text = I18N.T(competitionCfgDatas[1].CompetitionName)

	if stage == 1 then
		self.remainDay.text.text = I18N.T("DscSeasonResult13")
		self.remainDay1.text.text = I18N.T("DscSeasonResult13")
	elseif stage == 2 then
		local endTime = nextStageTime
		if endTime == 0 then
			self.remainDay.text.text = I18N.T("DscSeasonResult6")
			self.remainDay1.text.text = I18N.T("DscSeasonResult6")
		else
			local remainS = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(endTime, false)
			if remainS > 0 then
				if remainS <= 60 then
					self.remainDay.text.text = I18N.T("LessOneMinu")
					self.remainDay1.text.text = I18N.T("LessOneMinu")
				else
					local time = DateTimeUtil.convertSeconds2TimeStr1(remainS, true, false)
					self.remainDay.text.text = time
					self.remainDay1.text.text = time
				end
			else
				self.remainDay.text.text = I18N.T("DscSeasonResult6")
				self.remainDay1.text.text = I18N.T("DscSeasonResult6")
			end
		end
	elseif stage == 3 then
		self.remainDay.text.text = I18N.T("DscSeasonResult6")
		self.remainDay1.text.text = I18N.T("DscSeasonResult6")
	end
end

function UIMainView:RefreshUserNickName()
	self.textName.text.text = ManagerContainer.DataMgr.UserData:GetUserNickname()
end

function UIMainView:InsertGMNotice()
	local notice = ManagerContainer.DataMgr.GMNoticeData:GetCurNotice()
	if mainTopView and notice then
		mainTopView:InsertGMNotice(notice)
	end
end

function UIMainView:ChangeHeadFrame(headFrameIcon)
	CommonUtil.LoadIcon(self, headFrameIcon, function (sprite)
		self.headItem.frame.image.sprite = sprite
	end)
end

function UIMainView:RefreshHead()
	local curRoleLv = ManagerContainer.DataMgr.UserData:GetRoleLv()
	local jobCfgId = ManagerContainer.DataMgr.UserData:GetJobCfgId()
	local jobCfgData = ManagerContainer.CfgMgr:GetJobDataById(jobCfgId)
	local headIcon = ManagerContainer.DataMgr.UserData:GetUserHeadIcon()
	local _fakerData = {Level = curRoleLv, ProfessionIcon = jobCfgData.JobIcon, HeadIcon = headIcon, IsHero = true};
	local _headFrameId = ManagerContainer.DataMgr.UserData:GetHeadFrameId()
	CommonUtil.SetPlayerHeadAndFrame(self, self.headItem, _fakerData,false, _headFrameId, self, self.OnClickHead);
	if not jobCfgData or jobCfgData.JobStage >= 3 then
		self.expBarJob:SetActive(false)
	else
		self.expBarJob:SetActive(true)
	end
end

function UIMainView:RefreshJobIcon()
	local jobCfgId = ManagerContainer.DataMgr.UserData:GetJobCfgId()
	local jobCfgData = ManagerContainer.CfgMgr:GetJobDataById(jobCfgId)
	CommonUtil.LoadIcon(self, jobCfgData.JobIcon, function (sprite)
        self.headItem.jobIcon.image.sprite = sprite
    end, self, 'jobIconIdx')
end

function UIMainView:RefreshFightPower()
	self.fightpower.text.text = ManagerContainer.DataMgr.UserData:GetTotalFightPower()
end

function UIMainView:RoleRedPointNotice()
	--local RPStatus = ManagerContainer.RedPointMgr.HeroRPCtr:GetUIMainRPStatus()
	--RedPointItemCtr:SetData(self, self.redPointItem, RPStatus, Enum.HeroRPSource.Main)
end

function UIMainView:RefreshLv()
	local curRoleLv = ManagerContainer.DataMgr.UserData:GetRoleLv()
	self.expBarBase.textLv.text.text = CommonUtil.StringConcat("Lv.", curRoleLv)
	self.curRoleLv = curRoleLv
	self.headItem.levelText.text.text = tostring(curRoleLv);
end

function UIMainView:RefreshRoleExp()
	local roleExp = ManagerContainer.DataMgr.UserData:GetRoleExp()
	local curBaseMaxExp = ManagerContainer.DataMgr.UserData:GetHeroCurBaseMaxExp()
	self.expBarBase.textTotal.text.text = CommonUtil.StringConcat(CommonUtil.FormatNumber(roleExp), "/", CommonUtil.FormatNumber(curBaseMaxExp))
	local barPercent = curBaseMaxExp == 0 and 0 or roleExp/curBaseMaxExp
	self.expBarBase.slider.slider.value = Mathf.Max(BarMinValue, barPercent)
	self.curRoleExp = roleExp
	self.expBarBase.slider.effect:SetActive(false)
	--self:RefreshRestTime()
end

function UIMainView:RefreshRestTime(awardTotalTime)
	self.controller:SetAwardTotalTime(awardTotalTime)
	local roleExp = ManagerContainer.DataMgr.UserData:GetRoleExp()
	local curBaseMaxExp = ManagerContainer.DataMgr.UserData:GetHeroCurBaseMaxExp()
	local lerp = curBaseMaxExp - roleExp
	if lerp > 0 then
		local curLevelExp = ManagerContainer.LuaBattleMgr:CurLevelExp() or 100
		local seconds = Mathf.Ceil(lerp * 60 / curLevelExp - self.controller:GetAwardTotalTime())
		self.restTime.text.uILocalizeScript:SetContent('RestTime')
		self.restTime.textTime.text.text = DateTimeUtil.convertSeconds2TimeStr(seconds, false)
	elseif lerp == 0 then
		self.restTime.text.uILocalizeScript:SetContent('RestTimeMax')
		self.restTime.textTime.text.text = '--'
	end
end

function UIMainView:RefreshJobLv()
	local curJobLv = ManagerContainer.DataMgr.UserData:GetJobLv()
	self.expBarJob.textLv.text.text = CommonUtil.StringConcat("Lv.", curJobLv)
	self.curJobLv = curJobLv
end

function UIMainView:RefreshJobExp()
	local curMaxJobExp = ManagerContainer.DataMgr.UserData:GetHeroCurJobMaxExp()
	local jobExp = ManagerContainer.DataMgr.UserData:GetJobExp()
	self.expBarJob.textTotal.text.text = CommonUtil.StringConcat(CommonUtil.FormatNumber(jobExp), "/", CommonUtil.FormatNumber(curMaxJobExp))
	local barPercent = curMaxJobExp == 0 and 0 or jobExp/curMaxJobExp
	self.expBarJob.slider.slider.value = Mathf.Max(BarMinValue, barPercent)
	self.curJobExp = jobExp
	self.expBarJob.slider.effect:SetActive(false)
end

function UIMainView:RefreshCoins()
	local coin = ManagerContainer.DataMgr.UserData:GetOwnCoin()
	self.coinZ.text.text.text = CommonUtil.FormatNumber(coin)
	self.curCoin = coin
end

function UIMainView:RefreshDiamond()
	local count = CommonUtil.GetOwnResCountByItemId(curTopResType) --ManagerContainer.DataMgr.UserData:GetCurrency(curTopResType)
	self.gold.text.text.text = CommonUtil.FormatNumber(count)

	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(curTopResType)

	CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function (sprite)
		self.gold.icon.image.sprite = sprite
	end)

	--只显示金币的跳转按钮
	if curTopResType == Enum.ItemType.Diamond then
		self.btnGold:SetActive(Constant.OpenPay)
	else
		self.btnGold:SetActive(false)
	end

	if curTopResType == Enum.ItemType.Diamond then
		self.curDiamond = count
	end
end

function UIMainView:RefreshVipView()
	self.vipBtn.image.sprite = nil
	self.vipBtn.image.enabled = false
	local curVipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(curVipLv)
	if not vipCfg then
		return
	end
	CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
		if sprite then
			self.vipBtn.image.sprite = sprite
			self.vipBtn.image.enabled = true
		end
	end)
end

function UIMainView:DisplayBtnBase(result)
	if result then
		if ManagerContainer.PlayerPrefsMgr:GetBoolean(Constant.ROLE_LV_STATUS_SAVE_KEY, false) ~= result then
			return
		end
	end
	self.btnBase:SetActive(result)
end

function UIMainView:DisplayBtnJob(result)
	if result then
		if ManagerContainer.PlayerPrefsMgr:GetBoolean(Constant.JOB_LV_STATUS_SAVE_KEY, false) ~= result then
			return
		end
	end
	self.btnJob:SetActive(result)
end

function UIMainView:OnRefreshRoleLv()
	-- 在属性界面打开的情况下，不再显示这个按钮
	if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIRoleNaturePoint) then
		return
	end
	ManagerContainer.PlayerPrefsMgr:SetBoolean(Constant.ROLE_LV_STATUS_SAVE_KEY, true)
	self.btnBase:SetActive(true)
end

function UIMainView:CloseBtnBase()
	self.btnBase:SetActive(false)
	ManagerContainer.PlayerPrefsMgr:SetBoolean(Constant.ROLE_LV_STATUS_SAVE_KEY, false)
end

function UIMainView:OnRefreshJobLv()
	-- 在技能树界面打开的情况下，不再显示这个按钮
	if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UISkillSettings) then
		return
	end
	ManagerContainer.PlayerPrefsMgr:SetBoolean(Constant.JOB_LV_STATUS_SAVE_KEY, true)
	self.btnJob:SetActive(true)
end

function UIMainView:OnVipLvChanged()
	self:RefreshVipView()
end

function UIMainView:CloseBtnJob()
	self.btnJob:SetActive(false)
	ManagerContainer.PlayerPrefsMgr:SetBoolean(Constant.JOB_LV_STATUS_SAVE_KEY, false)
end

function UIMainView:RemoveEventListener()
	-- LogError("remove event  "..self.uiData.name)
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIMainView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnGold.button, function()
		if self.mainPageId then
			-- ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGM)
			if curTopResType == Enum.ItemType.Diamond then
				local curUIId = ManagerContainer.LuaUIMgr:GetCurUIId()
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.Gifts, Enum.RuneShopSubType.Gold}, curUIId)
			end
		end
	end)

	self.uiBase:AddButtonEventListener(self.town.icon.button, self, self.ChangePage, Enum.MainViewPageType.Town)
	self.uiBase:AddButtonEventListener(self.adventure.icon.button, self, self.ChangePage, Enum.MainViewPageType.Adventure)
	self.uiBase:AddButtonEventListener(self.shop.icon.button, self, self.ChangePage, Enum.MainViewPageType.Battle)
	self.uiBase:AddButtonEventListener(self.role.icon.button, self, self.ChangePage, Enum.MainViewPageType.Role, 1)
	self.uiBase:AddButtonEventListener(self.bag.icon.button, self, self.ChangePage, Enum.MainViewPageType.Pub)
	self.uiBase:AddButtonEventListener(self.btnBase.button,self,self.OnClickBaseBtn)
	self.uiBase:AddButtonEventListener(self.btnJob.button,self,self.OnClickJobBtn)
	--self.uiBase:AddButtonEventListener(self.head.button,self,self.OnClickHead)

	self.uiBase:AddButtonEventListener(self.topView.topRoot.btnNotifyActivity.button,self,self.OpenNoticeAndActivity)
	self.uiBase:AddButtonEventListener(self.topView.topRoot.btnTask.button,self,self.OpenTask)

	self.uiBase:AddButtonEventListener(self.seasonInfo.button, self, self.OnSeasonClick)
	self.uiBase:AddButtonEventListener(self.coinZ.icon.button, self,self.OnClickCoinZ)
	self.uiBase:AddButtonEventListener(self.gold.icon.button, self,self.OnClickGoldIcon)
	self.uiBase:AddButtonUniqueEventListener(self.vipBtn.button, self, self.OnClickVipBtn)

	self.uiBase:AddButtonUniqueEventListener(self.topView.topRoot.btnClub.button, self, self.OnClickRuneShopBtn)
	self.uiBase:AddButtonUniqueEventListener(self.topView.topRoot.btnFirstRecharge.button, self, self.OnClickFirstRechargeBtn)
	self.uiBase:AddButtonUniqueEventListener(self.topView.topRoot.btnLimitedGift.button, self, self.OnClickLimitGiftBtn)
	self.uiBase:AddButtonUniqueEventListener(self.topView.topRoot.btnQuestionnaire.button, self, self.OnQuestionClick)
	self.uiBase:AddButtonUniqueEventListener(self.topView.topRoot.btnActivityTower.button, self, self.OnTowerClick)
	self.uiBase:AddButtonUniqueEventListener(self.topView.topRoot.btnActivityDojo.button, self, self.OnArenaClick)
	self.uiBase:AddButtonUniqueEventListener(self.topView.topRoot.btnActivityMap.button, self, self.OnMapClick)
	self.uiBase:AddButtonUniqueEventListener(self.topView.topRoot.btnActivityPet.button, self, self.OnPetClick)
	self.uiBase:AddButtonUniqueEventListener(self.topView.topRoot.btnAirshipRewards.button, self, self.OnRewardsClick)
	self.uiBase:AddButtonUniqueEventListener(self.topView.topRoot.btnActivitySkill.button, self, self.OnSkillClick)

	self.uiBase:AddButtonUniqueEventListener(self.topView.topRoot.btnGuildWar.button, self, self.OnClickGuildWarBtn)
	self.uiBase:AddButtonUniqueEventListener(self.topView.topRoot.btnCombineService.button, self, self.OnClickCombineServerBtn)
	--
	--self.chatView.uIEventTriggerListener.onClick = function()
	--	self:OnChatClick()
	--end
end



function UIMainView:OnClickCombineServerBtn()
	ManagerContainer.DataMgr.CombineServerDataMgr:SendCombineServerInfoReq()
end

function UIMainView:OnClickGuildWarBtn()
	local curUIId = ManagerContainer.LuaUIMgr:GetCurUIId()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildWarMatchMap, nil, curUIId)
end

function UIMainView:OnClickFirstRechargeBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIActivityFirstRecharge)
end

function UIMainView:OnClickLimitGiftBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIActivityLimitedGift)
end

function UIMainView:OnQuestionClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIQuestionnaire)
end

function UIMainView:OnTowerClick()
	ManagerContainer.DataMgr.RankActivitiesMgr:QueryCurRankActivityData(Enum.RankActivitiesType.ClimbingTower, true)
end

function UIMainView:OnArenaClick()
	ManagerContainer.DataMgr.RankActivitiesMgr:QueryCurRankActivityData(Enum.RankActivitiesType.Dojo, true)
end

function UIMainView:OnMapClick()
	ManagerContainer.DataMgr.RankActivitiesMgr:QueryCurRankActivityData(Enum.RankActivitiesType.MapProgress, true)
end

function UIMainView:OnPetClick()
	ManagerContainer.DataMgr.RankActivitiesMgr:QueryCurRankActivityData(Enum.RankActivitiesType.Pet, true)
end

function UIMainView:OnSkillClick()
	ManagerContainer.DataMgr.RankActivitiesMgr:QueryCurRankActivityData(Enum.RankActivitiesType.Skill, true)
end

function UIMainView:OnRewardsClick()
	if ManagerContainer.DataMgr.RuneShopDataMgr:GetAirShipIsOpen() then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.Rewards,nil,nil,true})
	else
		self:RefreshAirShipRewardsBtn(false)
	end
end

function UIMainView:OnClickRuneShopBtn()
	local curUIId = ManagerContainer.LuaUIMgr:GetCurUIId()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, nil, curUIId)
end

function UIMainView:OnClickCoinZ()
	-- ManagerContainer.LuaUIMgr:ShowMinTips("ZenyTips")
end

function UIMainView:OnClickGoldIcon()
	-- ManagerContainer.LuaUIMgr:ShowMinTips("GoldTips")
end

function UIMainView:OnClickVipBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIVip)
end

function UIMainView:OnChatClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChat, nil, self.uiData.id)
end

function UIMainView:OnSeasonClick(button, params)
	ManagerContainer.DataMgr.CompetitionData:QueryCurCompetitionReq()
end

function UIMainView:OnHide()

end

function UIMainView:OnShow()

end

function UIMainView:OnClose()
	DOTween.Kill(self.gold.transform)
end

function UIMainView:OnDispose()
	if mainTopView then
		mainTopView:Dispose()
		mainTopView = nil
	end

	if mainBottomView then
		mainBottomView:Dispose()
		mainBottomView = nil
	end

	if self.delayTimer then
		self.delayTimer:Stop()
	end
	self.delayTimer = nil

	if self.dataDelayTimer then
		self.dataDelayTimer:Stop()
	end
	self.dataDelayTimer = nil

	self.canSignPlay = false
end

function UIMainView:OnClickHead()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRoleMessage, {_targetTag = 0})	--打开头像交互界面，显示自己的信息
end

function UIMainView:OnClickBaseBtn()
	self.btnBase:SetActive(false)
	ManagerContainer.PlayerPrefsMgr:SetBoolean(Constant.ROLE_LV_STATUS_SAVE_KEY, false)
	ManagerContainer.UIJumpMgr:CreateJumpTaskById(5)
end

function UIMainView:OnClickJobBtn()
	self.btnJob:SetActive(false)
	ManagerContainer.PlayerPrefsMgr:SetBoolean(Constant.JOB_LV_STATUS_SAVE_KEY, false)
	ManagerContainer.UIJumpMgr:CreateJumpTaskById(6)
end


function UIMainView:OpenTask()
	ManagerContainer.DataMgr.TaskDataNew:OpenTaskPanel();
end

function UIMainView:OpenNoticeAndActivity()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINotifyActivityTips)
end

function UIMainView:ChangePage(button, params)
	local data = params.Length > 1 and params[1] or nil
	self:ChangePageMsg(params[0], data)
end

-- 切换主场景功能
function UIMainView:ChangePageMsg(pageType, data)
	--LogError("ChangePageMsg  ")
	LogWarning("UIMainView:ChangePageMsg ")

	if _curMainButtonType == pageType then return end

	local UIBattleCtr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIBattle)
	if UIBattleCtr then
		local newForce = UIBattleCtr:GetNewForceId()
		if newForce then
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CLOSE_NEW_FUNC_PAGE)
			return
		end
	end

	ManagerContainer.DataMgr.TaskDataNew:SetMainButton(pageType);

	if _curMainButtonType == Enum.MainViewPageType.Role or _curMainButtonType == Enum.MainViewPageType.Battle or _curMainButtonType == Enum.MainViewPageType.Town then
		ManagerContainer.LuaBattleMgr:SetTeamData(true,false)
	end
	_curMainButtonType = pageType;

	self:RefreshSeasonNoticeState(false)

	if pageType == Enum.MainViewPageType.Town then
		self.upgradeRoot:SetActive(false)

		local bta = self.town.icon.buttonTriggerAnimation
		bta.tagetAnimator:CrossFade(bta.animationName, 0.2)
		--ManagerContainer.LuaGameMgr:EnterMainCity();

		--ManagerContainer.LuaUIMgr:HideAllPagesExceptId(Enum.UIPageName.UIMainCity1)
		self.mainPageId = Enum.UIPageName.UIMainCity1
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIMainCity1)

		--打开主城需要处理额外
		ManagerContainer.RedPointMgr.PetRPCtr:RefreshRelationRPState()
	elseif pageType == Enum.MainViewPageType.Adventure then

		curTopResType = self.uiData.top_res_id
		self:RefreshDiamond()
		self.upgradeRoot:SetActive(false)

		self.mainPageId = Enum.UIPageName.UIBattle
		ManagerContainer.LuaGameMgr:EnterBattle(false);
		if ManagerContainer.FSMMgr:IsBattleState() then
			local bta = self.adventure.icon.buttonTriggerAnimation
			bta.tagetAnimator:CrossFade(bta.animationName, 0.2)
		end
	elseif pageType == Enum.MainViewPageType.Battle then
		self.mainPageId = Enum.UIPageName.UIPetRoot
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetRoot)

		local bta = self.shop.icon.buttonTriggerAnimation
		bta.tagetAnimator:CrossFade(bta.animationName, 0.2)
	elseif pageType == Enum.MainViewPageType.Role then
		self.upgradeRoot:SetActive(false)
		self.mainPageId = Enum.UIPageName.UIRoleMain1
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRoleMain1, data)

		local bta = self.role.icon.buttonTriggerAnimation
		bta.tagetAnimator:CrossFade(bta.animationName, 0.2)
	elseif pageType == Enum.MainViewPageType.Pub then
		self.upgradeRoot:SetActive(false)

		--ManagerContainer.LuaUIMgr:HideAllPagesExceptId(Enum.UIPageName.UIBag)

		self.mainPageId = Enum.UIPageName.UIBag
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBag)
		local bta = self.bag.icon.buttonTriggerAnimation
		bta.tagetAnimator:CrossFade(bta.animationName, 0.2)
	end
end

function UIMainView:GetGotAnimEndPosByType(type)
	if type == Enum.ItemType.Item
			or type == Enum.ItemType.Equip
			or type == Enum.ItemType.Card
			or type == Enum.ItemType.ParterChip
			or type == Enum.ItemType.FashionPaper
			or type == Enum.ItemType.ParterExp
			or type == Enum.ItemType.SkillBook
			or type == Enum.ItemType.Gift
			or type == Enum.ItemType.Income then
		--背包
		return self.bag.transform.position
	elseif type == Enum.ItemType.Coin then
		--银币
		return self.coinZ.icon.transform.position
	elseif type == Enum.ItemType.Diamond then
		--钻石
		return self.gold.icon.transform.position
	elseif type == Enum.ItemType.RoleBaseExp then
		--基础经验
		return self.expBarBase.slider.effect.transform.position
	elseif type == Enum.ItemType.RoleJobExp then
		--职业经验
		return self.expBarJob.slider.effect.transform.position
	end

	return Vector3.zero
end

function UIMainView:GeAnchoredPosition3DByType(type)
	local pos = self:GetGotAnimEndPosByType(type)
	return CommonUtil.ConvertUIPos2ScreenPos(pos)
end

function UIMainView:GetTaskBtnPosition()
	return self.topView.topRoot.btnTask.transform.position
end

-- function UIMainView:ShowAddEffect(type, num)
-- 	if type == Enum.ItemType.Coin then
-- 		self:ShowAddCoinEffect(num)
-- 	elseif type == Enum.ItemType.RoleBaseExp then
-- 		self:ShowAddRoleExpEffect(num)
-- 	elseif type == Enum.ItemType.RoleJobExp then
-- 		self:ShowAddJobExpEffect(num)
-- 	end
-- end

function UIMainView:ShowAddCoinEffect()
	DOTween.Kill(self.coinZ.transform)
	-- local newCoin = ManagerContainer.DataMgr.UserData:GetOwnCoin()
	self.coinZ.transform.localScale = Vector3.one
	self.coinZ.transform:DOScale(Vector3.one * 1.1, 0.2):SetLoops(2, LoopType.Yoyo):OnComplete(function()
		self:RefreshCoins()
	end)
end

function UIMainView:ShowAddDiamondEffect()
	DOTween.Kill(self.gold.transform)
	-- local newCoin = ManagerContainer.DataMgr.UserData:GetOwnCoin()
	self.gold.transform.localScale = Vector3.one
	self.gold.transform:DOScale(Vector3.one * 1.1, 0.2):SetLoops(2, LoopType.Yoyo):OnComplete(function()
		self:RefreshDiamond()
	end)
end

function UIMainView:ShowAddRoleExpEffect()
	self.expBarBase.slider.effect:SetActive(true)
	local newRoleLv = ManagerContainer.DataMgr.UserData:GetRoleLv()
	local newRoleExp = ManagerContainer.DataMgr.UserData:GetRoleExp()
	-- 计算是否升级
	local curRoleLv = self.curRoleLv
	local baseExpData = ManagerContainer.CfgMgr:GetRoleExpData(curRoleLv)
	if not baseExpData then
		self:RefreshLv()
		self:RefreshRoleExp()
		return
	end
	local curRoleExp = newRoleExp
	local curMaxExp = baseExpData.Name
	while (curRoleExp >= curMaxExp) do
		baseExpData = ManagerContainer.CfgMgr:GetRoleExpData(curRoleLv + 1)
		if not baseExpData then
			curRoleExp = curMaxExp
			break
		end
		curRoleExp = curRoleExp - curMaxExp
		curMaxExp = baseExpData.Name
		curRoleLv = curRoleLv + 1
	end
	local targetPercent = Mathf.Max(BarMinValue, curRoleExp / curMaxExp)
	local curPercent = self.expBarBase.slider.slider.value
	DOTween.Kill(self.expBarBase.slider.slider)
	if targetPercent >= curPercent and self.curRoleLv == curRoleLv and curRoleLv == newRoleLv then
		self.expBarBase.slider.slider:DOValue(targetPercent, AddEffectBarSpeed):OnComplete(function()
			self:RefreshLv()
			self:RefreshRoleExp()
		end)
	else
		local lerpPercent = 1 - curPercent
		local allPercent = (lerpPercent + targetPercent)
		local tweener1 = self.expBarBase.slider.slider:DOValue(1, lerpPercent * AddEffectBarSpeed / allPercent)
		local tweener2 = self.expBarBase.slider.slider:DOValue(targetPercent, targetPercent * AddEffectBarSpeed / allPercent)
		local seq = DOTween.Sequence()
		seq:Append(tweener1)
		seq:AppendCallback(function()
			self.expBarBase.slider.slider.value = BarMinValue
			self.expBarBase.textLv.text.text = CommonUtil.StringConcat("Lv.", curRoleLv)
		end)
		seq:Append(tweener2)
		seq:AppendCallback(function()
			self:RefreshLv()
			self:RefreshRoleExp()
		end)
	end
end

function UIMainView:ShowAddJobExpEffect()
	self.expBarJob.slider.effect:SetActive(true)
	local newJobLv = ManagerContainer.DataMgr.UserData:GetJobLv()
	local newJobExp = ManagerContainer.DataMgr.UserData:GetJobExp()
	-- 计算是否升级
	local curJobLv = self.curJobLv
	local jobStage = ManagerContainer.DataMgr.UserData:GetJobStage()
	local curMaxExp = ManagerContainer.CfgMgr:GetCurMaxJobExpByLvAndStep(curJobLv, jobStage)
	if not curMaxExp or curMaxExp == 0 then
		self:RefreshJobLv()
		self:RefreshJobExp()
		return
	end
	local curJobExp = newJobExp
	while (curJobExp >= curMaxExp) do
		local nextJobExp = ManagerContainer.CfgMgr:GetCurMaxJobExpByLvAndStep(curJobLv + 1, jobStage)
		if not nextJobExp or nextJobExp == 0 then
			curJobExp = curMaxExp
			break
		end
		curJobExp = curJobExp - curMaxExp
		curMaxExp = nextJobExp
		curJobLv = curJobLv + 1
	end
	local targetPercent = Mathf.Max(BarMinValue, curJobExp / curMaxExp)
	local curPercent = self.expBarJob.slider.slider.value
	DOTween.Kill(self.expBarJob.slider.slider)
	if targetPercent >= curPercent and self.curJobLv == curJobLv and curJobLv == newJobLv then
		self.expBarJob.slider.slider:DOValue(targetPercent, AddEffectBarSpeed):OnComplete(function()
			self:RefreshJobLv()
			self:RefreshJobExp()
		end)
	else
		local lerpPercent = 1 - curPercent
		local allPercent = (lerpPercent + targetPercent)
		local tweener1 = self.expBarJob.slider.slider:DOValue(1, lerpPercent * AddEffectBarSpeed / allPercent)
		local tweener2 = self.expBarJob.slider.slider:DOValue(targetPercent, targetPercent * AddEffectBarSpeed / allPercent)
		local seq = DOTween.Sequence()
		seq:Append(tweener1)
		seq:AppendCallback(function()
			self.expBarJob.slider.slider.value = BarMinValue
			self.expBarJob.textLv.text.text = CommonUtil.StringConcat("Lv.", curJobLv)
		end)
		seq:Append(tweener2)
		seq:AppendCallback(function()
			self:RefreshJobLv()
			self:RefreshJobExp()
		end)
	end
end

function UIMainView:LoggedinForceGuideOver(ignore)
	if ManagerContainer.StoryMgr:IsStorying() then
		return
	end
	if ManagerContainer.StoryMgr:HasPreStoryChapter() then
		return
	end

	if not ignore and self.canSignPlay then
		self.canSignPlay = false
		ManagerContainer.DataMgr.SignData:QuerySignUpInfoReq(true)
	elseif ignore then
		local _canSignPlay = ManagerContainer.DataMgr.SignData:CanTodaySign()
		--LogHRWarning("_canSignPlay   "..tostring(_canSignPlay))
		if _canSignPlay then
			self.canSignPlay = false
			ManagerContainer.DataMgr.SignData:QuerySignUpInfoReq(true)			
		end
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.LIMIT_RECHARGE_OPEN_UI_NTF)
	end
	self:OpenFirstRechargeView()
end

function UIMainView:OpenFirstRechargeView()
	local activityData = ManagerContainer.DataMgr.ActsDataMgr:GetFirstRechargeItem()
	if not activityData then
		return
	end
	if not activityData:IsNeedOpen() then
		return
	end
	self:OnClickFirstRechargeBtn()
end

--这几个按钮在主城和战斗迅游界面会打开，其他界面是要关闭的（起码目前是这样）
function UIMainView:SetActiveButtonsState(state)
	if mainTopView then
		mainTopView:RefreshTopBtns(state)
	end
	self:RefreshFirstRechargeBtn(state)
	self:RefreshGuildWarBtn(state)
end

function UIMainView:RefreshRankActivityEnter(type, state)
	if mainTopView then
		mainTopView:RefreshRankActivityEnter(type, state)
	end
end

function UIMainView:RefreshAirShipActivityEnter(state)
	if mainTopView then
		mainTopView:RefreshAirShipActivityEnter(state)
	end
end

function UIMainView:RefreshFirstRechargeBtn(state)
	if state == false then
		self.topView.topRoot.btnFirstRecharge:SetActive(false)
		return
	end
	-- 首充全部领完，则不再显示该按钮
	local activityData = ManagerContainer.DataMgr.ActsDataMgr:GetFirstRechargeItem()
	if not activityData then
		self.topView.topRoot.btnFirstRecharge:SetActive(false)
		return
	end
	if activityData:IsAllRewardGotAndHas() then
		self.topView.topRoot.btnFirstRecharge:SetActive(false)
		return
	end
	local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(57)
	if not unlockState then
		return
	end
	self.topView.topRoot.btnFirstRecharge:SetActive(true)
end

function UIMainView:RefreshQuestionRewardBtn()
	local rewardState = ManagerContainer.DataMgr.UserData:GetQuestionRewardState()
	self.topView.topRoot.btnQuestionnaire:SetActive(not rewardState)
end

function UIMainView:RefreshAirShipRewardsBtn(state)
	if not Constant.OpenPay then
		state = false
	end
	self.topView.topRoot.btnAirshipRewards:SetActive(state)
end

function UIMainView:RefreshGuildWarBtn(state)
	if state == false then
		self.topView.topRoot.btnGuildWar:SetActive(false)
		return
	end
	local _unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(66)
	if not _unlockState then
		self.topView.topRoot.btnGuildWar:SetActive(false)
		return
	end
	local isOpen = ManagerContainer.DataMgr.GuildWarDataMgr:GetOpenState()
	if isOpen then
		self.topView.topRoot.btnGuildWar:SetActive(true)
		return
	end
	self.topView.topRoot.btnGuildWar:SetActive(false)
end

function UIMainView:OnCombineServerTimeChanged()
	mainTopView:ChangeRefreshCombineServerBtn()
end

function UIMainView:OnCombineServerContentChanged(content)
	if not content or content == '' then
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINotifyTipsSimple, {'BtnCombineService', content})
end

return UIMainView

