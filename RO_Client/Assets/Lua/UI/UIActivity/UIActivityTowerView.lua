local UIActivityTowerView = require("UIActivity/UIActivityTowerView_Generate")
local IconItemCtr = require("Common/IconItemCtr")
local IconPetItemCtr = require("Common/IconPetItemCtr")
local TaskJumpCtr = require( "Common/TaskJumpCtr")

local RankBgColorIcon = {"FrameNew/bg_label_red", "FrameNew/bg_label_yellow", "FrameNew/bg_label_purple", "FrameNew/bg_label_blue", "FrameNew/bg_label_green", "FrameNew/bg_label_green"}
local RankBGColor = {Color(1, 0.76, 0.72, 1), Color(1, 0.86, 0.57, 1), Color(0.98, 0.67, 1, 1), Color(0.65, 0.87, 1, 1), Color(0.66, 0.92, 0.71, 1), Color(0.66, 0.92, 0.71, 1)}

local pageToggleData = {}
local countlimit = 10
local reward

--是否考虑提出共同点放入配表？
local typeIdxCfgDatas
function UIActivityTowerView:OnAwake(data)
	self.controller = require("UIActivity/UIActivityTowerCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIActivityTowerView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RANK_ACTIVITY_DISPLAY_NTF, self, self.RefreshEndTime)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RANK_ACTIVITY_REWARD_SUCCESS_NTF, self, self.RefreshRankReward)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RUNE_SHOP_DATA_CHANGED, self, self.RefreshNew)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_RANK_QUERY_ACK_REFRESH, self, self.RefreshQueryPetRankDatas)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SKILL_RANK_QUERY_ACK_REFRESH, self, self.RefreshQueryPetRankDatas)
end

function UIActivityTowerView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIActivityTowerView:Init()
	self.rankIdx = 0
	self.controller:InitData()

	self:InitGrid()
	self:InitTopInfo()
end

function UIActivityTowerView:InitGrid()
	self.RankListScroll.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetRankItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self.LimitedListScroll.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetShopItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)

	 self.delayTimer = FrameTimer.New(function()
		 self.RankListScroll:SetActive(true)
		 self.LimitedListScroll:SetActive(true)
	 end, 1)
	 self.delayTimer:Start()
end

function UIActivityTowerView:InitTopInfo()
	local type, idx = self.controller:GetType(), self.controller:GetIdx()
	if not type or not idx then return end
	local cfgDatas = ManagerContainer.CfgMgr:GetRushListTargetCfgByTypeAndIdx(type,idx)
	if not cfgDatas then return end

	self.type = 1 --2toggle
	if type == Enum.RankActivitiesType.MapProgress then
		self.type = 2 --3toggle
	end

	if type <= Enum.RankActivitiesType.Dojo or type >= Enum.RankActivitiesType.Pet then
		self.rewardsToggle.text.uILocalizeScript:SetContent("RankReward")
	elseif type == Enum.RankActivitiesType.MapProgress then
		self.rewardsToggle.text.uILocalizeScript:SetContent("AdvReward")
	end
	if self.type == 1 then
		countlimit = cfgDatas[1].Rank[1][1]
		if cfgDatas[1] then
			reward = cfgDatas[1].Reward[1]
		end
	end

	if type == Enum.RankActivitiesType.ClimbingTower then
		ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.TowerRankChanged, false)
	elseif type == Enum.RankActivitiesType.Dojo then
		ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.ArenaRankChanged, false)
	elseif type == Enum.RankActivitiesType.MapProgress then
		ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.MapRankChanged, false)
	elseif type == Enum.RankActivitiesType.Pet then
		ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetRankChanged, false)
	end

	local cfgDatas = ManagerContainer.CfgMgr:GetRushListCfgByTypeAndIdx(type,idx)
	if not cfgDatas then return end
	local cfgData = cfgDatas[1]
	if not cfgData.Banner then return end

	CommonUtil.LoadIcon(self, cfgData.Banner[1], function (sprite)
		self.banner1.image.sprite = sprite
	end)
	CommonUtil.LoadIcon(self, cfgData.Banner[2], function (sprite)
		self.banner2.image.sprite = sprite
	end)
	if cfgData.Banner[3] then
		CommonUtil.LoadIcon(self, cfgData.Banner[3], function (sprite)
			self.banner3.image.sprite = sprite
		end)
	end

	local stage, endTime = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityStageEndTime(type)
	if not stage or not endTime then return end

	local remainS = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(endTime, false)

	if stage == 1 then
		if remainS <= 60 then
			self.timeTxt.text.text = I18N.SetLanguageValue("ActCloseTime", I18N.T("LessOneMinu"))
		else
			local time = DateTimeUtil.convertSeconds2TimeStr1(remainS, true, false)
			self.timeTxt.text.text = I18N.SetLanguageValue("ActCloseTime", time)
		end
	elseif stage == 2 then
		if remainS <= 0 then
			self.timeTxt.text.text = I18N.T("EndReward")
		elseif remainS <= 60 then
			self.timeTxt.text.text = I18N.SetLanguageValue("ButCloseTime", I18N.T("LessOneMinu"))
		else
			local time = DateTimeUtil.convertSeconds2TimeStr1(remainS, true, false)
			self.timeTxt.text.text = I18N.SetLanguageValue("ButCloseTime", time)
		end
	end
end

function UIActivityTowerView:RefreshEndTime(type, state)
	if type ~= self.controller:GetType() then return end

	if not state then
		self.timeTxt.text.text = I18N.T("EndReward")
		return
	end
	local stage, endTime = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityStageEndTime(self.controller:GetType())
	if not stage or not endTime then return end

	local remainS = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(endTime, false)

	if stage == 1 then
		if remainS <= 0 then
			ManagerContainer.DataMgr.RankActivitiesMgr:QueryRankActivitiesData()
		elseif remainS <= 60 then
			self.timeTxt.text.text = I18N.SetLanguageValue("ActCloseTime", I18N.T("LessOneMinu"))
		else
			local time = DateTimeUtil.convertSeconds2TimeStr1(remainS, true, false)
			self.timeTxt.text.text = I18N.SetLanguageValue("ActCloseTime", time)
		end
	elseif stage == 2 then
		self.saleToggle:SetActive(false)
		if pageToggleData.toggleDefaultIndex == 2 then
			self.rewardsToggle.toggle.isOn = true
		end
		if remainS <= 0 then
			self.timeTxt.text.text = I18N.T("EndReward")
			ManagerContainer.DataMgr.RankActivitiesMgr:QueryRankActivitiesData()
		elseif remainS <= 60 then
			self.timeTxt.text.text = I18N.SetLanguageValue("ButCloseTime", I18N.T("LessOneMinu"))
		else
			local time = DateTimeUtil.convertSeconds2TimeStr1(remainS, true, false)
			self.timeTxt.text.text = I18N.SetLanguageValue("ButCloseTime", time)
		end
	end

	self:RefreshMineInfo(self.controller:GetType())
	if pageToggleData.toggleDefaultIndex == 3 then
		if self.type == 1 then
			CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.toggleGroup, 2, self.OnValueChangedToggle, self, true)
		elseif self.type == 2 then
			CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.toggleGroup, 1, self.OnValueChangedToggle, self, true)
		end
	end
end

function UIActivityTowerView:OnValueChangedToggle(index, needRefresh)
	local type, idx = self.controller:GetType(), self.controller:GetIdx()
	if not type or not idx then return end
	local rankData = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityData(type)
	if not rankData then return end

	local rankListState = (type ~= Enum.RankActivitiesType.MapProgress and pageToggleData.toggleDefaultIndex == 2)
			or (type == Enum.RankActivitiesType.MapProgress and pageToggleData.toggleDefaultIndex <= 2)
	local limitedState = pageToggleData.toggleDefaultIndex == 3

	self.banner1:SetActive(pageToggleData.toggleDefaultIndex == 1)
	self.banner2:SetActive(pageToggleData.toggleDefaultIndex == 2)
	self.banner3:SetActive(pageToggleData.toggleDefaultIndex == 3)

	self.rankListBox:SetActive(rankListState)
	self.limitedBox:SetActive(limitedState)

	--self.btnGoto:SetActive(pageToggleData.toggleDefaultIndex == 1)
	--self.btnGetRewards:SetActive(pageToggleData.toggleDefaultIndex == 1)

	if rankListState then

		if type ~= Enum.RankActivitiesType.MapProgress or (type == Enum.RankActivitiesType.MapProgress and pageToggleData.toggleDefaultIndex == 2) then
			typeIdxCfgDatas = ManagerContainer.CfgMgr:GetRushListCfgByTypeAndIdx(type,idx)
		elseif type == Enum.RankActivitiesType.MapProgress and pageToggleData.toggleDefaultIndex == 1 then
			typeIdxCfgDatas = ManagerContainer.CfgMgr:GetRushListTargetCfgByTypeAndIdx(type,idx)
		end
		if not typeIdxCfgDatas then return end

		self:RefreshMineInfo(type)

		if not needRefresh then
			self.RankListScroll.loopGridView:RefreshListByIndex(#typeIdxCfgDatas, 0)
		else
			self.RankListScroll.loopGridView:RefreshListByIndex(#typeIdxCfgDatas)
		end

		if type == Enum.RankActivitiesType.MapProgress and pageToggleData.toggleDefaultIndex == 1 then
			local idx = self.rankIdx > 0 and self.rankIdx - 1 or 0
			self.RankListScroll.loopGridView:MovePanelToItemByIndex(idx)
		end

		--
		--CommonUtil.LoopGridViewEleCreateNew(self, self.RankListScroll.loopVerticalScrollRect, nil, cfgDatas, 0, nil, function (itemLua, idx)
		--	local data = cfgDatas[idx + 1]
		--	self:RefreshRankRewardItem(rankData, itemLua, data, idx)
		--end)
	elseif limitedState then
		local datas = self.controller:GetShowGoodsDatas()
		if not datas then return end

		if not needRefresh then
			self.LimitedListScroll.loopGridView:RefreshListByIndex(#datas, 0)
		else
			self.LimitedListScroll.loopGridView:RefreshListByIndex(#datas)
		end
		--self.LimitedListScroll.loopGridView:SetListItemCount(#datas, false)

		--CommonUtil.LoopGridViewEleCreateNew(self, self.LimitedListScroll.loopVerticalScrollRect, nil, datas, 0, nil, function (itemLua, idx)
		--	local data = datas[idx + 1]
		--	self:RefreshRankShopItem(itemLua, data, idx)
		--end)
	end
end

function UIActivityTowerView:RefreshRankReward(rewardType)
	local type = self.controller:GetType()
	if type == Enum.RankActivitiesType.MapProgress then
		ManagerContainer.DataMgr.RankActivitiesMgr:QueryCurRankActivityData(type)
	end
	self:InitTopInfo()
	self:OnValueChangedToggle(nil, true)
end

function UIActivityTowerView:RefreshNew()
	local stage, endTime = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityStageEndTime(self.controller:GetType())
	if not stage or not endTime then return end
	local datas = self.controller:GetShowGoodsDatas()
	self.saleToggle:SetActive(datas and next(datas) and stage == 1)
	if pageToggleData.toggleDefaultIndex == 3 then
		self:OnValueChangedToggle(nil, true)
	end
end

function UIActivityTowerView:RefreshMineInfo(type)
	local stage, endTime = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityStageEndTime(type)
	if not stage or not endTime then return end
	local rankData = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityData(type)
	if not rankData then return end

    self.myScore:SetActive(type ~= Enum.RankActivitiesType.MapProgress)
    self.myScoreAdv:SetActive(type == Enum.RankActivitiesType.MapProgress)

	local textScore = ""
    if type ~= Enum.RankActivitiesType.MapProgress then
        if type == Enum.RankActivitiesType.ClimbingTower then
            textScore = "DscTowerLevel"
            self.myScore.numScore.text.text = rankData.selfLevel
        elseif type == Enum.RankActivitiesType.Dojo then
            textScore = "DojoScore2"
            self.myScore.numScore.text.text = rankData.selfLevel
		elseif type == Enum.RankActivitiesType.Pet then
			textScore = "PetScoreTotal"
			self.myScore.numScore.text.text = rankData.selfScore
		elseif type == Enum.RankActivitiesType.Skill then
			textScore = "Skillrepresslv"
			self.myScore.numScore.text.text = rankData.selfLevel
        end

        self.myScore.numRank.text.text = rankData.selfRank == 0 and I18N.T("NoRank") or rankData.selfRank
        self.myScore.textScore.uILocalizeScript:SetContent(textScore)
    else
        textScore = "AllRoadScore"
        self.myScoreAdv.numScore.text.text = rankData.mapScore + rankData.bagScore
        self.myScoreAdv.numGiftScore.text.text = I18N.SetLanguageValue("IncludeGift", rankData.bagScore)

        self.myScoreAdv.numRank.text.text = rankData.selfRank == 0 and I18N.T("NoRank") or rankData.selfRank
    end

	local cfgDatas
	if type ~= Enum.RankActivitiesType.MapProgress or (type == Enum.RankActivitiesType.MapProgress and pageToggleData.toggleDefaultIndex == 2) then
		if reward then
			local data = {cfgId = tonumber(reward[1]), num = tonumber(reward[2])}
			IconItemCtr:SetData(self, self.iconSmallItem, data, Enum.ItemIEnterType.Bag, self, self.OnItemClick)
		end

		self.bottom:SetActive(true)
		self.floorsTask:SetActive(type ~= Enum.RankActivitiesType.MapProgress)
		if type ~= Enum.RankActivitiesType.MapProgress then
			local condition = rankData.fightCount
			if type == Enum.RankActivitiesType.Pet then
				condition = rankData.selfScore
				self.floorsTask.dsc.uILocalizeScript:SetContent("PetRankTarget")
			elseif type == Enum.RankActivitiesType.Skill then
				condition = rankData.selfLevel
				self.floorsTask.dsc.uILocalizeScript:SetContent("Skillrepresslv")
			else
				self.floorsTask.dsc.uILocalizeScript:SetContent("DscChallengeTime")
			end
			local count = math.min(condition, countlimit)
			self.floorsTask.times.text.text = count.."/"..countlimit

			local completed = condition >= countlimit
			self.floorsTask.textTitle:SetActive(not completed)
			self.floorsTask.btnReceive:SetActive(completed and not rankData.challengReward)
			self.floorsTask.labelReceived:SetActive(completed and rankData.challengReward)
			self.floorsTask.labelOver:SetActive(not completed and stage == 2)
		end

		cfgDatas = ManagerContainer.CfgMgr:GetRushListCfgByTypeAndIdx(type,self.controller:GetIdx())
		if not cfgDatas then return end

		self.rankIdx = 0
		if rankData.selfRank > 0 then
			for i = #cfgDatas, 1, -1 do
				local cfgData = cfgDatas[i]
				if cfgData.Rank[1][2] == 0 then
					self.rankIdx = cfgData.RankGrade
				elseif rankData.selfRank <= cfgData.Rank[1][2] then
					self.rankIdx = cfgData.RankGrade
				end
			end
		end

		self.btnGoto:SetActive(stage == 1)

		local state = pageToggleData.toggleDefaultIndex <= 2
		self.btnGetRewards:SetActive(self.rankIdx > 0 and stage == 2 and state and rankData.selfRank > 0 and not rankData.rankReward)
	elseif type == Enum.RankActivitiesType.MapProgress and pageToggleData.toggleDefaultIndex == 1 then
		self.bottom:SetActive(false)

		cfgDatas = ManagerContainer.CfgMgr:GetRushListTargetCfgByTypeAndIdx(type,self.controller:GetIdx())
		if not cfgDatas then return end

		self.rankIdx = 0
		for i = #cfgDatas, 1, -1 do
			local cfgData = cfgDatas[i]
			if rankData.rushLevel >= cfgData.Rank[1][1] then
				if cfgData.Rank[1][2] == 0 or rankData.rushLevel <= cfgData.Rank[1][2] then
					self.rankIdx = cfgData.TargetGrade
				end
			end
		end

		self.btnGoto:SetActive(stage == 1)
		self.btnGetRewards:SetActive(self.rankIdx > 0 and stage == 2 and pageToggleData.toggleDefaultIndex == 1 and not rankData.challengReward)
	end
end

function UIActivityTowerView:GetRankItemByRowColumn(gridView, itemIndex, row, column)
	local type, idx = self.controller:GetType(), self.controller:GetIdx()
	--local cfgDatas
	--if type <= Enum.RankActivitiesType.Dojo or (type == Enum.RankActivitiesType.MapProgress and pageToggleData.toggleDefaultIndex == 2) then
	--	cfgDatas = ManagerContainer.CfgMgr:GetRushListCfgByTypeAndIdx(type,idx)
	--elseif type == Enum.RankActivitiesType.MapProgress and pageToggleData.toggleDefaultIndex == 1 then
	--	cfgDatas = ManagerContainer.CfgMgr:GetRushListTargetCfgByTypeAndIdx(type,idx)
	--end
	local rankData = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityData(type)
	if not rankData then return end

	local item = gridView:NewListViewItem('RankRewardsItem')
	item.gameObject.name = itemIndex
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'RankRewardsItem', item.gameObject)
	local data = typeIdxCfgDatas[itemIndex + 1]
	if type <= Enum.RankActivitiesType.Dojo or (type == Enum.RankActivitiesType.MapProgress and pageToggleData.toggleDefaultIndex == 2)then
		self:RefreshRankRewardItem(rankData, itemlua, data, itemIndex)
	elseif type == Enum.RankActivitiesType.MapProgress and pageToggleData.toggleDefaultIndex == 1 then
		self:RefreshMapRankRewardItem(rankData, itemlua, data, itemIndex)
	elseif type == Enum.RankActivitiesType.Pet then
		self:RefreshPetRewardItem(rankData, itemlua, data, itemIndex)
	elseif type == Enum.RankActivitiesType.Skill then
		self:RefreshSkillRewardItem(rankData, itemlua, data, itemIndex)
	end

	return item
end

function UIActivityTowerView:RefreshPetRewardItem(rankData, itemLua, cfgData, idx)
	local type = self.controller:GetType()
	itemLua.textName:SetActive(true)

	local playerInfo = rankData.topData[idx + 1]

	local colorIdx = idx + 1 < #RankBGColor and idx + 1 or #RankBGColor
	itemLua.nameBG.image.color = RankBGColor[colorIdx]

	CommonUtil.LoadIcon(self, RankBgColorIcon[colorIdx], function (sprite)
		itemLua.imageLabel.image.sprite = sprite
	end, itemLua, "rankBg")

	itemLua.textDsc:SetActive(playerInfo ~= nil)
	itemLua.num:SetActive(playerInfo ~= nil)
	if playerInfo.name == "NoneRank" then
		itemLua.textName.text.text = I18N.T("NoneRank")
		itemLua.num.text.text = "-----"
	else
		if idx < 50 then
			itemLua.textName.text.text = CommonUtil.GetVaildNickName(playerInfo.name)
		else
			itemLua.textName.text.text = I18N.T("LowestPetScore")
		end
		itemLua.num.text.text = playerInfo.totalScore

		if type == Enum.RankActivitiesType.ClimbingTower then
			itemLua.textDsc.uILocalizeScript:SetContent("DscTowerLevel")
		elseif type == Enum.RankActivitiesType.Dojo then
			itemLua.textDsc.uILocalizeScript:SetContent("DojoScore2")
		elseif type == Enum.RankActivitiesType.MapProgress then
			itemLua.textDsc.uILocalizeScript:SetContent("DojoScore2")
		elseif type == Enum.RankActivitiesType.Pet then
			itemLua.textDsc.uILocalizeScript:SetContent("PetScoreTotal")
		end
	end

	if idx < 50 then
		itemLua.labelRank.text.uILocalizeScript:SetContentAndValues("ActivityPetRank", {idx + 1})
	else
		itemLua.labelRank.text.uILocalizeScript:SetContentAndValues("ActivityPetRank", {I18N.T("PetRankList")})
	end

	itemLua.RewardsNode:SetActive(false)
	itemLua.pets:SetActive(true)

	CommonUtil.LoadIcon(self, cfgData.TitleIcon, function (sprite)
		itemLua.pets.icon.image.sprite = sprite
	end, itemLua, "rewardIcon")

	for i = 1, 4 do
		local exist = playerInfo and playerInfo.info and playerInfo.info[i] ~= nil
		local pet = itemLua.pets["pet"..i]
		pet:SetActive(exist)
		if exist then
			local info = playerInfo.info[i]
			local data = {
				cfgId = info.petCfgId,
				level = info.petLevel,
			}
			IconPetItemCtr:SetData(self, pet.iconPetItem, data, nil, self, self.OnPetClick, info)
			pet.num.text.text = info.petScore
		end
	end

	self.uiBase:AddButtonUniqueEventListener(itemLua.pets.icon.button, self, self.OnShowPetRankReward, cfgData.Reward)

	self.controller:SetCurPetPage(idx)

	local rankData = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityData(type)
	if not rankData then return end
	if idx < 50 then
		itemLua.labelEstimate:SetActive(rankData.selfRank == idx + 1 and not rankData.rankReward)
		itemLua.labelReceived:SetActive(rankData.selfRank == idx + 1 and rankData.rankReward)
	else
		itemLua.labelEstimate:SetActive(rankData.selfRank > 50 and not rankData.rankReward)
		itemLua.labelReceived:SetActive(rankData.selfRank > 50 and rankData.rankReward)
	end
end

function UIActivityTowerView:RefreshSkillRewardItem(rankData, itemLua, cfgData, idx)
	local type = self.controller:GetType()
	itemLua.textName:SetActive(true)

	local playerInfo = rankData.topData[idx + 1]

	local colorIdx = idx + 1 < #RankBGColor and idx + 1 or #RankBGColor
	itemLua.nameBG.image.color = RankBGColor[colorIdx]

	CommonUtil.LoadIcon(self, RankBgColorIcon[colorIdx], function (sprite)
		itemLua.imageLabel.image.sprite = sprite
	end, itemLua, "rankBg")

	itemLua.textDsc:SetActive(playerInfo ~= nil)
	itemLua.num:SetActive(playerInfo ~= nil)
	if playerInfo.name == "NoneRank" then
		itemLua.textName.text.text = I18N.T("NoneRank")
		itemLua.textDsc.uILocalizeScript:SetContent("Skillrepresslv")
		itemLua.num.text.text = "-----"
	else
		if idx < 50 then
			itemLua.textName.text.text = CommonUtil.GetVaildNickName(playerInfo.name)
		else
			itemLua.textName.text.text = I18N.T("LowestPetScore")
		end
		itemLua.num.text.text = playerInfo.data

		if type == Enum.RankActivitiesType.ClimbingTower then
			itemLua.textDsc.uILocalizeScript:SetContent("DscTowerLevel")
		elseif type == Enum.RankActivitiesType.Dojo then
			itemLua.textDsc.uILocalizeScript:SetContent("DojoScore2")
		elseif type == Enum.RankActivitiesType.MapProgress then
			itemLua.textDsc.uILocalizeScript:SetContent("DojoScore2")
		elseif type == Enum.RankActivitiesType.Pet then
			itemLua.textDsc.uILocalizeScript:SetContent("PetScoreTotal")
		elseif type == Enum.RankActivitiesType.Skill then
			itemLua.textDsc.uILocalizeScript:SetContent("Skillrepresslv")
		end
	end

	if idx < 50 then
		itemLua.labelRank.text.uILocalizeScript:SetContentAndValues("ActivityPetRank", {idx + 1})
	else
		itemLua.labelRank.text.uILocalizeScript:SetContentAndValues("ActivityPetRank", {I18N.T("PetRankList")})
	end

	itemLua.RewardsNode:SetActive(true)
	itemLua.pets:SetActive(false)

	CommonUtil.LoadIcon(self, cfgData.TitleIcon, function (sprite)
		itemLua.pets.icon.image.sprite = sprite
	end, itemLua, "rewardIcon")

	local itemDatas = {}
	for _,v in pairs(cfgData.Reward) do
		local itemData = {cfgId = v[1], num = v[2]}
		itemDatas[#itemDatas + 1] = itemData
	end

	CommonUtil.BatchCreateItemsLoopSpawnPrefabNew1(self, itemDatas, Enum.PrefabNames.IconSmallItem, "IconItem", itemLua.RewardsNode.transform, Enum.ItemIEnterType.Bag, self, self.OnItemClick)

	self.uiBase:AddButtonUniqueEventListener(itemLua.pets.icon.button, self, self.OnShowPetRankReward, cfgData.Reward)

	self.controller:SetCurPetPage(idx)

	local rankData = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityData(type)
	if not rankData then return end
	if idx < 50 then
		itemLua.labelEstimate:SetActive(rankData.selfRank == idx + 1 and not rankData.rankReward)
		itemLua.labelReceived:SetActive(rankData.selfRank == idx + 1 and rankData.rankReward)
	else
		itemLua.labelEstimate:SetActive(rankData.selfRank > 50 and not rankData.rankReward)
		itemLua.labelReceived:SetActive(rankData.selfRank > 50 and rankData.rankReward)
	end
end

function UIActivityTowerView:OnPetClick(button, params)
	local petData = params[0]
	local petInfo = params[2]
	if not petData or not petInfo then return end

	local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
	if not petCfgData then return end

	IconPetItemCtr:SetData(self, self.petTips.iconPetItem, petData)
	self.petTips.namepet.text.text = I18N.T(petCfgData.Name)
	self.petTips.scoreTotal.text.text = petInfo.petScore

	CommonUtil.LoadIcon(self, Constant.Quality_CardType_Icons[petCfgData.Quality], function (sprite)
		self.petTips.iconlabel.image.sprite = sprite
	end, self, "petType")
	self.petTips.grade.score.text.text = petInfo.qualityScore
	self.petTips.lv.numlv.text.text = petInfo.petLevel
	self.petTips.lv.score.text.text = petInfo.levelScore
	self.petTips.skill.numskilllv.text.text = petInfo.totalSkillLevel
	self.petTips.skill.score.text.text = petInfo.skillScore

	self.petTips:SetActive(true)
	self.clickMask:SetActive(true)
end

function UIActivityTowerView:OnClickMaskClick()
	self.clickMask:SetActive(false)
	self.petTips:SetActive(false)
end

function UIActivityTowerView:RefreshQueryPetRankDatas()
	self.RankListScroll.loopGridView:RefreshAllShownItem()
end

function UIActivityTowerView:GetShopItemByRowColumn(gridView, itemIndex, row, column)
	local datas = self.controller:GetShowGoodsDatas()
	if not datas then return end

	local item = gridView:NewListViewItem('RankShopLimitedItem')
	item.gameObject.name = itemIndex
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'RankShopLimitedItem', item.gameObject)
	local data = datas[itemIndex + 1]
	self:RefreshRankShopItem(itemlua, data, itemIndex)
	return item
end

function UIActivityTowerView:RefreshMapRankRewardItem(rankData, itemLua, cfgData, idx)
	itemLua.textName:SetActive(true)
	itemLua.textDsc:SetActive(false)
	itemLua.num:SetActive(false)
	itemLua.RewardsNode:SetActive(true)

	CommonUtil.LoadIcon(self, RankBgColorIcon[idx + 1], function (sprite)
		itemLua.imageLabel.image.sprite = sprite
	end, itemLua, "rankBg")
	itemLua.nameBG.image.color = RankBGColor[idx + 1]

	itemLua.labelRank.text.uILocalizeScript:SetContent(cfgData.Label)
	itemLua.textName.text.text = I18N.T(cfgData.Des)

	local itemDatas = {}
	for _,v in pairs(cfgData.Reward) do
		local itemData = {cfgId = v[1], num = v[2]}
		itemDatas[#itemDatas + 1] = itemData
	end

	CommonUtil.BatchCreateItemsLoopSpawnPrefabNew1(self, itemDatas, Enum.PrefabNames.IconSmallItem, "IconItem", itemLua.RewardsNode.transform, Enum.ItemIEnterType.Bag, self, self.OnItemClick)

	itemLua.labelEstimate:SetActive(self.rankIdx > 0 and self.rankIdx == idx + 1 and not rankData.challengReward)
	itemLua.labelReceived:SetActive(self.rankIdx > 0 and self.rankIdx == idx + 1 and rankData.challengReward)
end

function UIActivityTowerView:RefreshRankRewardItem(rankData, itemLua, cfgData, idx)
	local type = self.controller:GetType()
	itemLua.textName:SetActive(true)
	itemLua.RewardsNode:SetActive(true)

	local playerInfo = rankData.topData[idx + 1]

	CommonUtil.LoadIcon(self, RankBgColorIcon[idx + 1], function (sprite)
		itemLua.imageLabel.image.sprite = sprite
	end, itemLua, "rankBg")
	itemLua.nameBG.image.color = RankBGColor[idx + 1]

	itemLua.textDsc:SetActive(playerInfo ~= nil)
	itemLua.num:SetActive(playerInfo ~= nil)
	if not playerInfo then
		itemLua.textName.text.text = I18N.T("NoneRank")
	else
		if idx > 2 then
			if type == Enum.RankActivitiesType.ClimbingTower then
				itemLua.textName.text.text = I18N.T("LowestFloor")
			elseif type == Enum.RankActivitiesType.Dojo or type == Enum.RankActivitiesType.MapProgress then
				itemLua.textName.text.text = I18N.T("LowestScore")
			end

			itemLua.textDsc:SetActive(false)
		else
			itemLua.textName.text.text = CommonUtil.GetVaildNickName(playerInfo.name)
		end
		itemLua.num.text.text = playerInfo.data

		if type == Enum.RankActivitiesType.ClimbingTower then
			itemLua.textDsc.uILocalizeScript:SetContent("DscTowerLevel")
		elseif type == Enum.RankActivitiesType.Dojo then
			itemLua.textDsc.uILocalizeScript:SetContent("DojoScore2")
		elseif type == Enum.RankActivitiesType.MapProgress then
			itemLua.textDsc.uILocalizeScript:SetContent("DojoScore2")
		elseif type == Enum.RankActivitiesType.Pet then
			itemLua.textDsc.uILocalizeScript:SetContent("DojoScore2")
		end
	end

	itemLua.labelRank.text.uILocalizeScript:SetContent("RushRank"..(idx + 1))

	local itemDatas = {}
	for _,v in pairs(cfgData.Reward) do
		local itemData = {cfgId = v[1], num = v[2]}
		itemDatas[#itemDatas + 1] = itemData
	end

	CommonUtil.BatchCreateItemsLoopSpawnPrefabNew1(self, itemDatas, Enum.PrefabNames.IconSmallItem, "IconItem", itemLua.RewardsNode.transform, Enum.ItemIEnterType.Bag, self, self.OnItemClick)

	itemLua.labelEstimate:SetActive(self.rankIdx > 0 and self.rankIdx == idx + 1 and not rankData.rankReward)
	itemLua.labelReceived:SetActive(self.rankIdx > 0 and self.rankIdx == idx + 1 and rankData.rankReward)
end

function UIActivityTowerView:RefreshRankShopItem(itemLua, data, idx)
	local cfgData = data.cfgData
	CommonUtil.LoadIcon(self, cfgData.Banner, function (sprite)
		itemLua.itemBg.image.sprite = sprite
	end)
	CommonUtil.LoadIcon(self, cfgData.NameImg, function (sprite)
		itemLua.itemText.image.sprite = sprite
	end)

	itemLua.saveLabel.text.text.text = cfgData.ExtraNum
	itemLua.presentPrice.number.text.text = data.price
	itemLua.labelLimited.textLimited.uILocalizeScript:SetContentAndValues("RushListLimitBuy", {data:GetRemainBuyNum()})

	itemLua.soldout:SetActive(not data:IsCanBuy())

	local itemDatas = {}
	for _,v in pairs(cfgData.Reward) do
		local itemData = {cfgId = v[1], num = v[2]}
		itemDatas[#itemDatas + 1] = itemData
	end

	CommonUtil.BatchCreateItemsLoopSpawnPrefabNew(self, itemDatas, Enum.PrefabNames.RankShopRewardIconItem, itemLua.RewardsNode.transform, Enum.ItemIEnterType.Bag, self, self.OnItemClick)

	self.uiBase:AddButtonUniqueEventListener(itemLua.presentPrice.button, self, self.OnPay, data)
end

function UIActivityTowerView:OnItemClick(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIActivityTowerView:OnPay(button, params)
	local data = params[0]
	local errorCode = ManagerContainer.PayMgr:RankActivityPay(self.controller:GetType(), data.id)
	local errorCodeKey = ManagerContainer.PayMgr:GetInitPayErrorCodeLangKey(errorCode)
	if not errorCodeKey then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCodeKey)
	end
end

function UIActivityTowerView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIActivityTowerView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.backBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnQuestion.button, self, self.OnHelperClick)
	self.uiBase:AddButtonEventListener(self.btnGoto.button, self, self.OnGotoClick)
	self.uiBase:AddButtonEventListener(self.floorsTask.btnReceive.button, self, self.OnReceiveClick)
	self.uiBase:AddButtonEventListener(self.btnGetRewards.button, self, self.OnRankRewardClick)
	self.uiBase:AddButtonEventListener(self.clickMask.button, self, self.OnClickMaskClick)

	local type = self.controller:GetType()
	local stage, endTime = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityStageEndTime(self.controller:GetType())
	if not stage or not endTime then return end
	self.mapToggle:SetActive(type == Enum.RankActivitiesType.MapProgress)
	local idx = type == Enum.RankActivitiesType.MapProgress and 1 or 2
	CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.toggleGroup, idx, self.OnValueChangedToggle, self, true)
	self.saleToggle:SetActive(false)
end

function UIActivityTowerView:OnCloseClick()
	self:UIClose()
end

function UIActivityTowerView:OnHelperClick()
	local type = self.controller:GetType()
	if not type then return end

	local rule = "RushRankRule"..type
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', rule})
end

function UIActivityTowerView:OnGotoClick()
	local type = self.controller:GetType()
	if type == Enum.RankActivitiesType.ClimbingTower then
		local unlockState, val, content = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(32)
		if not unlockState then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(content)
			return
		end
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIClimbingTower, nil, self.uiData.id)
	elseif type == Enum.RankActivitiesType.Dojo then
		local unlockState, val, content = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(8)
		if not unlockState then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(content)
			return
		end
		ManagerContainer.DataMgr.ArenaData:SendArenaDataReq(Enum.UIPageName.UIDojo2D, self.uiData.id)
		--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojo2D, nil, self.uiData.id)
	elseif type == Enum.RankActivitiesType.MapProgress then
		self:OnCloseClick()
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Adventure)
	elseif type == Enum.RankActivitiesType.Pet then
		self:OnCloseClick()
		local unlockState, val, content = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(15)
		if not unlockState then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(content)
			return
		end
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Battle)
	elseif type == Enum.RankActivitiesType.Skill then
		TaskJumpCtr:JumpBuyCfgId(38)
	end
end

function UIActivityTowerView:OnReceiveClick()
	self.controller:SendRewardReq(1)
end

function UIActivityTowerView:OnRankRewardClick()
	local type = self.controller:GetType()
	if type == Enum.RankActivitiesType.MapProgress and pageToggleData.toggleDefaultIndex == 1 then
		self.controller:SendRewardReq(1)
	else
		self.controller:SendRewardReq(2)
	end
end

function UIActivityTowerView:OnShowPetRankReward(button, params)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRewardsTips, params[0])
end

function UIActivityTowerView:OnHide()
	if self.delayTimer then
		self.delayTimer:Stop()
		self.delayTimer = nil
	end
	--
	--CommonUtil.RecycleFromBatchItemsByPrefabName(self, Enum.PrefabNames.IconSmallItem)
	--self.RankListScroll.loopGridView:Dispose()
	--
	--CommonUtil.RecycleFromBatchItemsByPrefabName(self, Enum.PrefabNames.RankShopRewardIconItem)
	--self.LimitedListScroll.loopGridView:Dispose()
end

function UIActivityTowerView:OnShow(data)
	self.controller:SetData(data)
end

function UIActivityTowerView:OnClose()

	if self.delayTimer then
		self.delayTimer:Stop()
		self.delayTimer = nil
	end

	CommonUtil.RecycleFromBatchItemsByPrefabName(self, Enum.PrefabNames.IconSmallItem)
	self.RankListScroll.loopGridView:Dispose()

	CommonUtil.RecycleFromBatchItemsByPrefabName(self, Enum.PrefabNames.RankShopRewardIconItem)
	self.LimitedListScroll.loopGridView:Dispose()
end

function UIActivityTowerView:OnDispose()
	self.controller:OnDispose()
end

return UIActivityTowerView

