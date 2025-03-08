local UISeasonView = require("UISeason/UISeasonView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

local rankPercent
local CompetitionType = {
	Recruit = 1,
	Selection = 2,
	Astrolabe = 4,
	Idol	  = 5,
}

local periodIdx = 1
local TypeDesc = {
	"3","5","7"
}

local boliScaleX = {-1, 1, 1}
local boliPos = Vector3.zero
local boliScale = Vector3.one

local isEnd = false
local selectionIdx = 0
local remainTime, remainText, remainTextContent, overDsc

local curCompetitionCfgData
local competitionType
function UISeasonView:OnAwake(data)
	self.controller = require("UISeason/UISeasonCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISeasonView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SEASON_EXCHANGE_NTF_MAIN, function()
		self:Refresh(true)
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SEASON_MINUTE_UPDATE, self, self.OneSecondUpdate)
end

function UISeasonView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISeasonView:Init()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SEASON_RANK_CHANGED_NTF, 0)
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SEASON_NOTICE_CLOSE_NTF, false)

	boliPos.y = self.seasonInfo.boliBox.transform.localPosition.y

	self:InitGrid()
	local uiJumpId = ManagerContainer.DataMgr.CompetitionData:GetUIJumpId()
	local stage = self.controller:GetCurStageAndNextTime()
	if stage == 2 and uiJumpId > 0 then
		local uiJumpState = ManagerContainer.DataMgr.CompetitionData:GetUIJumpState()
		if uiJumpState > 0 then
			ManagerContainer.LuaUIMgr:Open(uiJumpId,nil,self.uiBase.MSourceUIID)
		end
	end
end

function UISeasonView:OnPageInEnd()
	self:Refresh()

	self.super.OnPageInEnd(self)
end

function UISeasonView:InitGrid()
	self.seasonPreview.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UISeasonView:Refresh(refreshReward)
	-- 推地图的进度
	local competitionId = self.controller:GetCurCompetitionId()
	rankPercent = CommonUtil.GetPreciseDecimal(ManagerContainer.DataMgr.CompetitionData:GetRankPercent(),2)

	local stage = self.controller:GetCurStageAndNextTime()
	self.seasonResult:SetActive(stage == 3)
	self.seasonInfo:SetActive(stage == 2)
	self.seasonPreview:SetActive(stage == 1)

	self:RefreshTop()
	self:RefreshBottom(refreshReward)
	--local curCompetitionData = ManagerContainer.DataMgr.CompetitionData:GetCurCompetitionData()
	--self:RefreshSeasonInfo(competitionId, curCompetitionData, refreshReward)
end

function UISeasonView:RefreshTop()
	local stage, nextTime = self.controller:GetCurStageAndNextTime()

	local curCompetitionData = ManagerContainer.DataMgr.CompetitionData:GetCurCompetitionData()
	local competitionId = self.controller:GetCurCompetitionId()
	local seasons = ManagerContainer.CfgMgr:GetCompetitionDatasByType(competitionId)
	if not next(seasons) then
		return
	end
	competitionType = seasons[1].CompetitionType
	self.btnSecond:SetActive(competitionType == 2 and stage ~= 1)
	self.btnTurnWheel:SetActive(competitionType == 3 and stage ~= 1)
	self.btnAstrolabe:SetActive(competitionType == 4 and stage ~= 1)
	self.btnGotoIdol:SetActive(competitionType == 5 and stage ~= 1)
	local cfgData = seasons[1]
	if stage == 1 then
		self.seasonPreview.titleSeason.text.text = I18N.T(cfgData.CompetitionName)
		self.seasonPreview.describe.text.text = I18N.T(cfgData.BannerDsc)

		remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(nextTime, false)
		remainText = self.seasonPreview.time.text
		if remainTime > 60 then
			local time = DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, false)
			remainText.text = time
		else
			remainText.text = I18N.T("LessOneMinu")
		end
	elseif stage == 2 then
		self.seasonInfo.titleSeason.text.text = I18N.T(cfgData.CompetitionName)
		if competitionId ~= 1 and competitionId == cfgData.CompetitionCondition[1][1] then	--偶像祭特殊显示
			local rank = ManagerContainer.DataMgr.CompetitionData:GetRank()
			if rank > 0 then
				self.seasonInfo.describe.text.text = I18N.SetLanguageValue("DscSeasonR"..cfgData.CompetitionType,"",I18N.SetLanguageValue("DscSeasonTips6",rank), "")
			else
				self.seasonInfo.describe.text.text = I18N.SetLanguageValue("DscSeasonR"..cfgData.CompetitionType,"",I18N.T("NoRank"), "")
			end
		else
			if rankPercent > 0 then
				local tips = ""--rankPercent > 60 and I18N.T("DscSeasonTips3") or I18N.T("DscSeasonTips4")
				self.seasonInfo.describe.text.text = I18N.SetLanguageValue("DscSeasonR"..competitionType, tips, rankPercent, "")
			else
				self.seasonInfo.describe.text.text = I18N.SetLanguageValue("DscSeasonR"..competitionType, I18N.T("DscSeasonTips4"), 60, "")
			end
		end

		local curTime = ManagerContainer.LuaTimerMgr:GetTimeSecond()
		local time = 8 * 3600;
		local durationTime = ManagerContainer.LuaTimerMgr:GetOneDaySeconds()*7 - time
		local startTime = curCompetitionData.curEndTime/1000 - durationTime
		local delta = curTime - startTime
		delta = type(delta) == "userdata" and #delta or delta
		local days = delta/ManagerContainer.LuaTimerMgr:GetOneDaySeconds()
		if days <= 2.67 then
			durationTime = ManagerContainer.LuaTimerMgr:GetOneDaySeconds()*9 - time
		elseif days <= 3.67 then
			durationTime = ManagerContainer.LuaTimerMgr:GetOneDaySeconds()*8 - time
		elseif days <= 4.67 then
			durationTime = ManagerContainer.LuaTimerMgr:GetOneDaySeconds()*7.5 - time
		elseif days <= 5.67 then
			durationTime = ManagerContainer.LuaTimerMgr:GetOneDaySeconds()*7.2 - time
		elseif days <= 6.67 then
			durationTime = ManagerContainer.LuaTimerMgr:GetOneDaySeconds()*7 - time
		end
		local progress = delta/durationTime
		self.daysBar.image.fillAmount = progress
	elseif stage == 3 then
		self.seasonInfo.titleSeason.text.text = I18N.T(cfgData.CompetitionName)
		if rankPercent > 0 then
			local tips = rankPercent > 60 and I18N.T("DscSeasonTips3") or I18N.T("DscSeasonTips4")
			self.seasonInfo.describe.text.text = I18N.SetLanguageValue("DscSeasonR"..competitionType, tips, rankPercent, "")
		else
			self.seasonInfo.describe.text.text = I18N.SetLanguageValue("DscSeasonR"..competitionType, I18N.T("DscSeasonTips4"), 60, "")
		end
		self.seasonInfo.describe.text.text = I18N.T("DscSeasonOver")
	end
end

function UISeasonView:RefreshBottom(refreshReward)
	local stage, nextTime = self.controller:GetCurStageAndNextTime()

	local curCompetitionData = ManagerContainer.DataMgr.CompetitionData:GetCurCompetitionData()
	local competitionId = self.controller:GetCurCompetitionId()
	local seasons = ManagerContainer.CfgMgr:GetCompetitionDatasByType(competitionId)
	if not next(seasons) then
		return
	end
	curCompetitionCfgData = seasons[1]
	if stage == 1 then
		self.seasonPreview.scrollView.loopGridView:SetListItemCount(3, true)
	elseif stage == 2 then
		periodIdx = ManagerContainer.DataMgr.CompetitionData:GetCurPeriodIdx()
		if not periodIdx then
			return
		end

		self["toggle"..periodIdx].toggle.isOn = true
		self:RefreshSeasonRewards(self["toggle"..periodIdx].toggle, periodIdx, true, refreshReward)
	elseif stage == 3 then
		self:RefreshSeasonOver()
	end
end

function UISeasonView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local reward = curCompetitionCfgData["CompetitionReward"..(itemIndex + 1)]
	local item
	if reward then
		item = gridView:NewListViewItem('UISeasonRewardItem')
		local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'UISeasonRewardItem', item.gameObject)
		CommonUtil.CloseUIClearAsyncSeqIds(itemlua)

		CommonUtil.LoadIcon(self, curCompetitionCfgData.CompetitionTitleIcon, function (sprite)
			itemlua.icon.image.sprite = sprite
		end)

		if curCompetitionCfgData.LabelIcon then
			CommonUtil.LoadIcon(self, curCompetitionCfgData.LabelIcon, function (sprite)
				itemlua.flag.image.sprite = sprite
			end)
		end
		itemlua.rewardName.text.text = I18N.SetLanguageValue("SeasonRewardTitle", (itemIndex * 2) + 3)
		local tips1 = I18N.T("DscSeasonTips5")
		local competitionId = self.controller:GetCurCompetitionId()
		if competitionId ~= 1 and competitionId == curCompetitionCfgData.CompetitionCondition[1][1] then	--偶像祭特殊显示
			itemlua.progress.text.text = I18N.SetLanguageValue("DscSeasonR"..competitionType,"", I18N.SetLanguageValue("DscSeasonTips6",curCompetitionCfgData.CompetitionCondition[1][2]), tips1)
		else
			itemlua.progress.text.text = I18N.SetLanguageValue("DscSeasonR"..competitionType, I18N.T("DscSeasonTips3"), curCompetitionCfgData.CompetitionCondition[1][2], tips1)
		end
		itemlua.cornerMark:SetActive(false)
		itemlua.rewarded:SetActive(false)

		CommonUtil.LoopGridViewEleCreateNew(self, itemlua.scrollView.loopHorizontalScrollRect, nil, reward, 0, nil, function (itemLua, idx)
			local data = {cfgId = reward[idx + 1][1], num = reward[idx + 1][2]}
			CommonUtil.UpdateItemPrefab(self, itemLua, data, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
		end)
	end
	return item
end

function UISeasonView:RefreshSeasonRewards(toggle, data, result, refreshReward)
	if not result then return end
	if not periodIdx then return end

	if not refreshReward and data == selectionIdx then return end
	selectionIdx = data

	self.seasonInfo.boliBox:SetActive(true)
	self.seasonInfo.boliBox.transform:SetParent(self["toggle"..data].on.transform)
	self.seasonInfo.boliBox.transform.localPosition = boliPos
	boliScale.x = boliScaleX[data]
	self.seasonInfo.boliBox.transform.localScale = boliScale
	self.seasonInfo.boliBox.overBox.transform.localScale = boliScale
	self.seasonInfo.boliBox.timeBox.transform.localScale = boliScale

	--self.seasonInfo.boliBox.timeBox.text.uILocalizeScript:SetContentAndValues("CompetitionTip1", {TypeDesc[data]})

	self.seasonInfo.scrollView.loopVerticalScrollRect:ClearCells()

	local competitionId = self.controller:GetCurCompetitionId()

	local periodData = ManagerContainer.DataMgr.CompetitionData:GetCurPeriodData(data)

	if periodData then
		remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(periodData.rewardEndTme, false)
	else
		remainTime = 0
	end

	self.seasonInfo.boliBox.overBox:SetActive(remainTime <= 0)
	self.seasonInfo.boliBox.timeBox:SetActive(remainTime > 0)

	if remainTime > 0 then
		overDsc = I18N.T("DscSeasonOver1")
		remainText = self.seasonInfo.boliBox.timeBox.time.text
		remainTextContent = "DscSeasonTime"
		if remainTime > 60 then
			local time = DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, false)
			self.seasonInfo.boliBox.timeBox.time.text.text = time --I18N.SetLanguageValue("DscSeasonTime", time)
		else
			self.seasonInfo.boliBox.timeBox.time.text.text = I18N.T("LessOneMinu")
		end
	else
		self.seasonInfo.boliBox.timeBox.time.text.text = I18N.T("DscSeasonOver1")
	end

	local seasons = ManagerContainer.CfgMgr:GetCompetitionDatasByType(competitionId)
	local movePos = 0
	local selfCompetitionId = seasons[1].Id
	if periodData then
		selfCompetitionId = periodData.paramList[1]
		if not selfCompetitionId then
			selfCompetitionId = seasons[#seasons].Id
		end
		if selfCompetitionId == seasons[#seasons].Id then
			movePos = 2
		end
	end
	local competitionId = self.controller:GetCurCompetitionId()
	CommonUtil.LoopGridViewEleCreateNew(self, self.seasonInfo.scrollView.loopVerticalScrollRect, nil, seasons, 0, nil, function (itemLua, idx)
		local data = {cfgData = seasons[idx + 1],competitionId = competitionId ,curId = selfCompetitionId, selectedPeriodIdx = data, curPeriodIdx = periodIdx, hasData = periodData ~= nil }
		CommonUtil.UpdateItemPrefab(self, itemLua, data)
	end, false, nil, movePos)
end

function UISeasonView:RefreshSeasonOver()
	self.btnSecond:SetActive(false)
	self.btnTurnWheel:SetActive(false)
	self.btnAstrolabe:SetActive(false)
	self.btnGotoIdol:SetActive(false)
	local curCompetitionData = ManagerContainer.DataMgr.CompetitionData:GetCurCompetitionData()
	local competitionId = self.controller:GetCurCompetitionId()

	local competitionCfgDatas = ManagerContainer.CfgMgr:GetCompetitionDatasByType(competitionId)
	if not competitionCfgDatas then
		return
	end
	self.seasonResult.titleSeason.text.text = I18N.T(competitionCfgDatas[1].CompetitionName)

	local nextTime = ManagerContainer.DataMgr.CompetitionData:GetNextSeasonStartTime(competitionId)
	remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(nextTime, false)
	local time = DateTimeUtil.TransTimeSecondIntToString(remainTime)

	remainTextContent = "DscSeasonResult3"
	if nextTime > 0 then
		self.seasonResult.time.text.text = time
	else
		self.seasonResult.time.text.text = I18N.T("CompetitionTip8")
	end
	remainText = self.seasonResult.time.text

	local rewardInfoList = curCompetitionData.rewardInfoList[#curCompetitionData.rewardInfoList]
	if not rewardInfoList then
		self.seasonResult.dsc.text.text = I18N.T("DscSeasonNoData")
		return
	end
	local seasons = ManagerContainer.CfgMgr:GetCompetitionDatasByType(competitionId)
	if not next(seasons) then
		return
	end
	local cfgData = seasons[1]
	if competitionId ~= 1 and competitionId == cfgData.CompetitionCondition[1][1] then	--偶像祭特殊显示
		local rank = ManagerContainer.DataMgr.CompetitionData:GetRank()
		if rank > 0 then
			self.seasonResult.dsc.text.text = I18N.SetLanguageValue("DscSeasonR"..cfgData.CompetitionType,"",I18N.SetLanguageValue("DscSeasonTips6",rank), "")
		else
			self.seasonResult.dsc.text.text = I18N.SetLanguageValue("DscSeasonR"..cfgData.CompetitionType,"",I18N.T("NoRank"), "")
		end
	else
		if rankPercent > 0 then
			local tips = ""--rankPercent > 60 and I18N.T("DscSeasonTips3") or I18N.T("DscSeasonTips4")
			self.seasonResult.dsc.text.text = I18N.SetLanguageValue("DscSeasonR"..competitionType, tips, rankPercent, "")
		else
			self.seasonResult.dsc.text.text = I18N.SetLanguageValue("DscSeasonR"..competitionType, I18N.T("DscSeasonTips4"), 60, "")
		end
	end
	-- if rankPercent == 0 then
	-- 	self.seasonResult.dsc.text.text = I18N.SetLanguageValue("DscSeasonR"..competitionType, I18N.T("DscSeasonTips4"), 60, "")
	-- else
	-- 	local tips = rankPercent > 60 and I18N.T("DscSeasonTips3") or I18N.T("DscSeasonTips4")
	-- 	self.seasonResult.dsc.text.text = I18N.SetLanguageValue("DscSeasonR"..competitionType, tips, rankPercent, "")
	-- end
end

function UISeasonView:OneSecondUpdate()
	if not remainText then
		return
	end

	local stage, nextTime, nextSmallStage = self.controller:GetCurStageAndNextTime()
	if nextSmallStage ~= nil then
		nextTime = nextSmallStage
	end
	if stage == 3 then
		nextTime = ManagerContainer.DataMgr.CompetitionData:GetNextSeasonStartTime()
	end
	remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(nextTime, false)
	if remainTime <= 0 then
		remainText.text = overDsc or I18N.T("DscSeasonOver")
		overDsc = nil
	else
		if isEnd then
			local time = DateTimeUtil.TransTimeSecondIntToString(remainTime)
			remainText.text = time --I18N.SetLanguageValue(remainTextContent, time)
		else
			if remainTime > 60 then
				local time = DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, false)
				remainText.text = time
			else
				remainText.text = I18N.T("LessOneMinu")
			end
		end
	end
end

function UISeasonView:ShowItemTips(button, params)
	local data = params[0]
	local data1 = clone(data)
	data1.isPreview = true
	--ManagerContainer.LuaUIMgr:OpenItemTips(data.cfgId, Enum.ItemIEnterType.Bag, data)
	ManagerContainer.LuaUIMgr:OpenTips(data1)
end

function UISeasonView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UISeasonView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnBack.button, self, self.CloseSelf)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.CloseSelf)

	self.uiBase:AddButtonEventListener(self.seasonResult.btnPlayRule.button, self, self.OnClickPlayRuleBtn)
	self.uiBase:AddButtonEventListener(self.seasonInfo.btnPlayRule.button, self, self.OnClickPlayRuleBtn)
	self.uiBase:AddButtonEventListener(self.seasonPreview.btnPlayRule.button, self, self.OnClickPlayRuleBtn)

	self.uiBase:AddToggleEventListener(self.toggle1.toggle, self, self.RefreshSeasonRewards, 1)
	self.uiBase:AddToggleEventListener(self.toggle2.toggle, self, self.RefreshSeasonRewards, 2)
	self.uiBase:AddToggleEventListener(self.toggle3.toggle, self, self.RefreshSeasonRewards, 3)

	self.uiBase:AddButtonEventListener(self.btnSecond.button, self, self.OnSecondSeasonOpen)
	self.uiBase:AddButtonEventListener(self.btnAstrolabe.button, self, self.OnStarSignOpen)
	self.uiBase:AddButtonEventListener(self.btnGotoIdol.button, self, self.OnIdolViewOpen)
	self.uiBase:AddButtonEventListener(self.btnTurnWheel.button, self, self.OnThirdSeasonOpen)
end

function UISeasonView:CloseSelf()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UISeasonView:OnClickPlayRuleBtn()
	local rule
	if competitionType == CompetitionType.Selection then
		rule = "SelectionSeasonPlayExplain"
	elseif competitionType == CompetitionType.Recruit then
		rule = "RecruitSeasonPlayExplain"
	elseif competitionType == CompetitionType.Astrolabe then
		rule = "DevineSeasonPlayExplain"
	elseif competitionType == CompetitionType.Idol then
		rule = "AidouluSeasonPlayExplain"
	else
		rule = "DojoSeasonPlayExplain"
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', rule})
end

function UISeasonView:OnSecondSeasonOpen()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIExchange, self.uiData.id)
end
function UISeasonView:OnStarSignOpen()
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if not IsOver then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIStarSignTips)
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LabelOver")
	end
end

function UISeasonView:OnIdolViewOpen()
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if not IsOver then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISeasonIdol,nil,self.uiBase.MSourceUIID)
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LabelOver")
	end
end

function UISeasonView:OnThirdSeasonOpen()
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if not IsOver then
		ManagerContainer.DataMgr.TrunWheelDataMgr:SendOpenREQ()
	else
		if not ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UIErrorTips) then
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIErrorTips, {errorId="LabelOver"}, nil, nil, nil, Enum.UISibling[Enum.UIType.Top + 1] + 11)
		else
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ERROR_DESC_DISPLAY, {errorId="LabelOver"})
		end
	end
end

function UISeasonView:OnHide()

end

function UISeasonView:OnShow(data)
	self.controller:SetData(data)
	self:Refresh(true)
end

function UISeasonView:OnClose()
	self.seasonPreview.scrollView.loopGridView:Dispose()
end

function UISeasonView:OnDispose()
	remainTime = 0
	remainText = nil

	self.seasonInfo.scrollView.loopVerticalScrollRect:ClearCells()
	self.seasonInfo.boliBox.transform:SetParent(self.toggleGroup.transform)
	self.seasonInfo.boliBox:SetActive(false)
end

return UISeasonView

