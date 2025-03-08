local UIGuildWarRankView = require("UIGuildWar/UIGuildWarRankView_Generate")
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')

local RankPageType = {
	Score = 1,
	Kill = 2,
}

local SCROE_INTERVAL = 2

function UIGuildWarRankView:OnAwake(data)
	self.controller = require("UIGuildWar/UIGuildWarRankCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildWarRankView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_BATTLE_RANK_DATA_CHANGED, self, self.OnRankDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_BATTLE_SCORE_DATA_CHANGED, self, self.OnScoreDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_OPEN_STATE_CHANGED, self, self.OnOpenStateChanged)
end

function UIGuildWarRankView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildWarRankView:Init()
	self.controller:InitData()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	self.loadStatusLoopListCtr = LoadStatusLoopListCtr:new(self, self.scrollView.loopListView, 0, 1,
															false, 'LoadingItem', Enum.ListLoadingStatus.None,
															true, 'LoadingItem', Enum.ListLoadingStatus.WaitLoad,
															self.GetItemByIndex,nil, self.OnBeginLoad)

	self.scrollView.loopListView.ScrollRect.enabled = false
	local battleRankData = self.controller:GetBattleRankData()
	self:RefreshBaseView(battleRankData)
	if battleRankData then
		self:RefreshScoreView(battleRankData.guildOccupy1, battleRankData.guildOccupy2, battleRankData.guildScore1, battleRankData.guildScore2)
	else
		self:RefreshScoreView(0, 0, 0, 0)
		self.isInitScore = nil
	end
	self:OnBeginLoad(true)
end

function UIGuildWarRankView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuildWarRankView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)

	self.uiBase:AddToggleUniqueEventListener(self.rankScore.toggle, self, self.OnClickRankToggle, RankPageType.Score)
	self.uiBase:AddToggleUniqueEventListener(self.rankKill.toggle, self, self.OnClickRankToggle, RankPageType.Kill)
end

function UIGuildWarRankView:OnHide()

end

function UIGuildWarRankView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildWarRankView:OnClose()
end

function UIGuildWarRankView:OnDispose()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	self.isInitScore = nil
	self.controller:OnDispose()
end

function UIGuildWarRankView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.scrollView.loopListView.ScrollRect.enabled = true
end

function UIGuildWarRankView:OnClickCloseBtn()
	self:UIClose()
end

function UIGuildWarRankView:OnClickRankToggle(toggle, params, isOn)
	local battleRankPageType = params[0]
	if isOn then
		if self.controller:SetBattleRankPageType(battleRankPageType) then
			self:RefreshListView()
			self:OnBeginLoad(true)
		end
	else
		if battleRankPageType == self.controller:GetBattleRankPageType() then
			toggle.isOn = true
		end
	end
end

function UIGuildWarRankView:OnClickRankItem(btn, params)
	local uid = params[0]
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

function UIGuildWarRankView:OnRankDataChanged()
	self.controller:RefreshBattleRankData()
	local battleRankData = self.controller:GetBattleRankData()
	self:RefreshBaseView(battleRankData)
	if battleRankData then
		self:RefreshScoreView(battleRankData.guildOccupy1, battleRankData.guildOccupy2, battleRankData.guildScore1, battleRankData.guildScore2)
	else
		self:RefreshScoreView(0, 0, 0, 0)
		self.isInitScore = nil
	end
	self:RefreshListView()
end

function UIGuildWarRankView:OnScoreDataChanged()
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData then return end
	if battleFieldData.id ~= self.controller:GetBattleIdx() then return end
	self:RefreshScoreView(battleFieldData.guildOccupy1, battleFieldData.guildOccupy2, battleFieldData.guildScore1, battleFieldData.guildScore2)
end

function UIGuildWarRankView:OnOpenStateChanged(isOpen)
	if isOpen then return end
	self:UIClose()
end

function UIGuildWarRankView:RefreshBaseView(battleRankData)
	if not battleRankData then
		self.guildNameTxt1.text.text = ''
		self.guildNameTxt2.text.text = ''
		self:RefreshBadgeImg(self.flag1.badge.image, nil)
		self:RefreshBadgeImg(self.flag2.badge.image, nil)
		self.flag1.result:SetActive(false)
		self.flag2.result:SetActive(false)
		return
	end
	self.guildNameTxt1.text.text = string.formatbykey('GuildWarBattle21', battleRankData.guildName1)
	self.guildNameTxt2.text.text = string.formatbykey('GuildWarBattle21', battleRankData.guildName2)
	self:RefreshBadgeImg(self.flag1.badge.image, battleRankData.guildBadge1)
	self:RefreshBadgeImg(self.flag2.badge.image, battleRankData.guildBadge2)
	if battleRankData.isFinish then
		self.flag1.result:SetActive(true)
		self.flag2.result:SetActive(true)
		if battleRankData.isWin then
			self.flag1.result.uIImageSwitchSprite:ChangeSprite(1)
			self.flag2.result.uIImageSwitchSprite:ChangeSprite(0)
		else
			self.flag1.result.uIImageSwitchSprite:ChangeSprite(0)
			self.flag2.result.uIImageSwitchSprite:ChangeSprite(1)
		end
	else
		self.flag1.result:SetActive(false)
		self.flag2.result:SetActive(false)
	end
end

function UIGuildWarRankView:RefreshBadgeImg(image, badge)
	if not image then return end
	image.enabled = false
	image.sprite = nil
	if badge then
		local badgeCfgData = ManagerContainer.CfgMgr:GetGuildBadgeCfgById(badge)
		if not badgeCfgData then return end
		CommonUtil.LoadIcon(self, badgeCfgData.Pic, function (sprite)
			if sprite then
				image.sprite = sprite
				image.enabled = true
			end
		end)
	end
end

function UIGuildWarRankView:RefreshScoreView(areaNum1, areaNum2, score1, score2)
	local dojoName = string.formatbykey('GuildWarBattle14')
	self.areaNumTxt1.text.text = (areaNum1 and tostring(areaNum1) or '0') .. tostring(dojoName)
	self.areaNumTxt2.text.text = (areaNum2 and tostring(areaNum2) or '0') .. tostring(dojoName)
	if not score1 or score1 <= 0 then score1 = 0 end
	if not score2 or score2 <= 0 then score2 = 0 end
	local score = score1 + score2
	local time = SCROE_INTERVAL
	if not self.isInitScore then
		time = 0
		self.isInitScore = true
	end
	if score <= 0 then
		self.scoreSlider.slider:DOValue(0.5, time)
	else
		self.scoreSlider.slider:DOValue(score2 / score, time)
	end
	self.scoreTxt1.text.text = tostring(score1)
	self.scoreTxt2.text.text = tostring(score2)
end

function UIGuildWarRankView:RefreshListView()
	local battleRankPageType = self.controller:GetBattleRankPageType()
	self.rankScore.toggle.isOn = battleRankPageType == RankPageType.Score
	self.rankKill.toggle.isOn = battleRankPageType == RankPageType.Kill
	local battleRankPageData = self.controller:GetBattleRankPageData()
	if not battleRankPageData then
		self.loadStatusLoopListCtr:SetHasBegin(true)
		self.loadStatusLoopListCtr:OnAllLoaded()
		self.loadStatusLoopListCtr:RefreshMaxDataLength(2)
		self.loadStatusLoopListCtr:RefreshDataLength(1)
		return
	end
	local dataNum = battleRankPageData:GetDataNum()
	local isEnd = battleRankPageData.isEnd
	self.loadStatusLoopListCtr:SetHasBegin(not isEnd)
	self.loadStatusLoopListCtr:OnAllLoaded()
	if not dataNum or dataNum <= 0 then
		self.loadStatusLoopListCtr:RefreshMaxDataLength(isEnd and 1 or 2)
		self.loadStatusLoopListCtr:RefreshDataLength(1)
		return
	end
	self.loadStatusLoopListCtr:RefreshMaxDataLength(isEnd and dataNum or (dataNum + 1))
	self.loadStatusLoopListCtr:RefreshDataLength(dataNum)
end

function UIGuildWarRankView:OnBeginLoad(isBegin)
	local errorCode = self.controller:SendGuildWarRankReq(isBegin)
	if errorCode ~= 0 then
		self:RefreshListView()
		if errorCode ~= 1 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end

function UIGuildWarRankView:GetItemByIndex(loopListView, idx, dataIdx)
	local battleRankPageData = self.controller:GetBattleRankPageData()
	if not battleRankPageData then
		return loopListView:NewListViewItem('NoGuildItem')
	end
	local dataNum = battleRankPageData:GetDataNum()
	if not dataNum or dataNum <= 0 then
		return loopListView:NewListViewItem('NoGuildItem')
	end
	local itemData = battleRankPageData:GetDataByIdx(dataIdx + 1)
	if not itemData then
		return nil
	end
	local item = loopListView:NewListViewItem('GuildWarRankItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'GuildWarRankItem', item.gameObject)
	if itemLua then
		itemLua.nameTxt.text.text = tostring(self.controller:GetGuildName(itemData.guildId))
		local playerBrief = itemData.playerBrief
		local uid
		local data = nil
		local headFrameId = nil
		-- local vipLv = nil
		if playerBrief then
			uid = playerBrief.uid
			-- vipLv = playerBrief.vipLv
			headFrameId = playerBrief.headFrame
			if int64.equals(uid, ManagerContainer.DataMgr.UserData:GetUserId()) then
				headFrameId = ManagerContainer.DataMgr.UserData:GetHeadFrameId()
				-- vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
			end
			local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(playerBrief.configId)
			local jobIcon = ''
			if jobCfg then
				jobIcon = jobCfg.JobIcon
			end
			data = {Level = playerBrief.level, ProfessionIcon = jobIcon, HeadIcon = playerBrief.headPortraitName, IsHero = true}
			itemLua.playerName.text.text = tostring(playerBrief.nickName)
		else
			data = {}
			itemLua.playerName.text.text = ''
		end
		itemLua.headItem.head.button.enabled = false
		CommonUtil.SetPlayerHeadAndFrame(self, itemLua.headItem, data, false, headFrameId)
		local rank = itemData.id
		itemLua.rankTxt.text.text = tostring(rank)
		local battleRankPageType = self.controller:GetBattleRankPageType()
		if battleRankPageType == RankPageType.Score then
			itemLua.tagMvp:SetActive(rank == 1)
			self:RefreshCurrencyItem(itemLua.currency, 'Common/ic_res_gulid_capturepoint', itemData.value)
		elseif battleRankPageType == RankPageType.Kill then
			itemLua.tagMvp:SetActive(rank == 1)
			self:RefreshCurrencyItem(itemLua.currency, 'Common/ic_res_gulid_killerpoint', itemData.value)
		else
			itemLua.tagMvp:SetActive(false)
			self:RefreshCurrencyItem(itemLua.currency)
		end
		self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickRankItem, uid)
	end
	return item
end

function UIGuildWarRankView:RefreshCurrencyItem(currency, resPath, num)
	if not currency then return end
	currency.icon.image.enabled = false
	currency.icon.image.sprite = nil
	CommonUtil.LoadIcon(self, resPath, function (sprite)
		if sprite then
			currency.icon.image.sprite = sprite
			currency.icon.image.enabled = true
		end
	end)
	currency.numTxt.text.text = tostring(num)
end


return UIGuildWarRankView

