local UIGuildWarView = require("UIGuildWar/UIGuildWarView_Generate")
local ColorExtension = require('ColorExtension')

local THRONE_PATHS = {
	[1] = {'GuildWarPlace/GuildWar_SpotA1', 'GuildWarPlace/GuildWar_SpotA2', 'GuildWarPlace/GuildWar_SpotA3'},
	[2] = {'GuildWarPlace/GuildWar_SpotB1', 'GuildWarPlace/GuildWar_SpotB2', 'GuildWarPlace/GuildWar_SpotB3'},
	[3] = {'GuildWarPlace/GuildWar_SpotC1', 'GuildWarPlace/GuildWar_SpotC2', 'GuildWarPlace/GuildWar_SpotC3'}
}

local GUILD_COLOR_ID1 = ColorExtension.HexStringToColor(string.formatbykey('ColorID3'))
local GUILD_COLOR_ID2 = ColorExtension.HexStringToColor(string.formatbykey('ColorID6'))
local GUILD_COLOR_DEFAULT = ColorExtension.HexStringToColor(string.formatbykey('ColorID1'))

local SCROE_INTERVAL = 2
local AREA_INTERVAL = 5

function UIGuildWarView:OnAwake(data)
	self.controller = require("UIGuildWar/UIGuildWarCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildWarView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_BATTLE_FIELD_INFO_CHANGED, self, self.OnBattleInfoChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_BATTLE_SCORE_DATA_CHANGED, self, self.OnScoreDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_BATTLE_AREA_DATA_CHANGED, self, self.OnAreaDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_BATTLE_SELF_DATA_CHANGED, self, self.OnSelfDataChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_OPEN_STATE_CHANGED, self, self.OnOpenStateChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_BATTLE_FIELD_ENDED, self, self.OnBattleFieldEnded)
end

function UIGuildWarView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildWarView:Init()
	self.controller:InitData()
	local initParam = SuperScrollView.LoopGridViewInitParam()
	initParam.mSmoothDumpRate = 0.05
	self.scrollView.loopGridView.ItemSnapEnable = false
	self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, function(gridView, itemIndex, row, column, loopGridViewItem)
		self:RecycleItem(gridView, itemIndex, row, column, loopGridViewItem)
	end, nil, initParam)

	self.isInitGrid = nil
	self.alignAreaId = nil
	self.isInitScore = nil

	self:RefreshPanel()
	self:CloseMenu()
	local errorCode = self.controller:SendGuildWarInfoReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildWarView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	self.scrollView.loopGridView.mOnBeginDragAction = nil
	self.scrollView.loopGridView.mOnEndDragAction = nil
	self.scrollView.loopGridView.mOnSnapItemFinished = nil
end

function UIGuildWarView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnBack.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnHelp.button, self, self.OnClickHelpBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnLog.button, self, self.OnClickLogBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnRank.button, self, self.OnClickRankBtn)
	self.uiBase:AddButtonUniqueEventListener(self.infoPanel.button, self, self.OnClickRankBtn)

	self.uiBase:AddToggleUniqueEventListener(self.challenge.toggle.toggle, self, self.OnClickChallengeToggle)
	self.uiBase:AddButtonUniqueEventListener(self.challenge.btnAdd.button, self, self.OnClickChallengeAddBtn)
	self.uiBase:AddToggleUniqueEventListener(self.reborn.toggle.toggle, self, self.OnClickRebornToggle)
	self.uiBase:AddButtonUniqueEventListener(self.reborn.btnAdd.button, self, self.OnClickRebornAddBtn)
	self.uiBase:AddButtonUniqueEventListener(self.buffUpBtn.button, self, self.OnClickBuffUpBtn)

	self.uiBase:AddButtonUniqueEventListener(self.menu.AnyBtn.button, self, self.OnClickMenuCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.menu.btnClg.button, self, self.OnClickMenuChallengeBtn)
	self.uiBase:AddButtonUniqueEventListener(self.menu.btnInfo.button, self, self.OnClickMenuInfoBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnChat.button, self, self.OpenWorldChat)

	self.scrollView.loopGridView.mOnBeginDragAction = function(gridView)
		self:OnBeginDragAction(gridView)
	end
	self.scrollView.loopGridView.mOnEndDragAction = function(gridView)
		self:OnEndDragAction(gridView)
	end
	self.scrollView.loopGridView.mOnSnapItemFinished = function(gridView, gridViewItem)
		self:OnSnapItemFinished(gridView, gridViewItem)
	end
end

function UIGuildWarView:OpenWorldChat()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChat)
end

function UIGuildWarView:OnHide()
	if self.scoreTimer then
		self.scoreTimer:Stop()
	end
	if self.areaTimer then
		self.areaTimer:Stop()
	end
	if self.battleTimer then
		self.battleTimer:Stop()
	end
	if self.rebornTimer then
		self.rebornTimer:Stop()
	end
end

function UIGuildWarView:OnShow(data)
	self.controller:SetData(data)
	if self.scoreTimer then
		self.scoreTimer.func()
	end
	if self.areaTimer then
		self.areaTimer.func()
	end
	if self.battleTimer then
		self.battleTimer.func()
	end
	if self.rebornTimer then
		self.rebornTimer.func()
	end
end

function UIGuildWarView:OnClose()
end

function UIGuildWarView:OnDispose()
	if self.scoreTimer then
		self.scoreTimer:Stop()
		self.scoreTimer = nil
	end
	if self.areaTimer then
		self.areaTimer:Stop()
		self.areaTimer = nil
	end
	if self.battleTimer then
		self.battleTimer:Stop()
		self.battleTimer = nil
	end
	if self.rebornTimer then
		self.rebornTimer:Stop()
		self.rebornTimer = nil
	end
	self.isInitGrid = nil
	self.alignAreaId = nil
	self.isInitScore = nil
	self.scrollView.loopGridView:Dispose()
	self:CloseMenu()
	self:DisposeRawItemLua()
	self:DisposeAreaItemLua()
	self.controller:OnDispose()
end

function UIGuildWarView:OnBattleInfoChanged(battleIdxChanged)
	if battleIdxChanged then
		self.controller:ResetBattleIdx()
		self:CloseMenu()
		self.isInitScore = nil
	end
	self:RefreshPanel()
end

function UIGuildWarView:OnScoreDataChanged()
	self:RefreshScore()
end

function UIGuildWarView:OnAreaDataChanged(areaChangeIds)
	if not self.isInitGrid then
		self:RefreshArea()
		return
	end
	if not areaChangeIds then
		return
	end
	for _, id in pairs(areaChangeIds) do
		self:RefreshItemLua(id)
		if self.curSelectAreaId == id then
			self:OpenMenu(self.curSelectAreaId)
		end
	end
end

function UIGuildWarView:OnSelfDataChanged()
	self:RefreshFunPanel()
end

function UIGuildWarView:OnOpenStateChanged(isOpen)
	if isOpen then return end
	if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIChat) then
		ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIChat)
	end
	self:UIClose()
end

function UIGuildWarView:OnBattleFieldEnded(battleIdx)
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData then
		return
	end
	if battleFieldData.id ~= battleIdx then
		return
	end
	if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIChat) then
		ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIChat, true)
	end
	if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIGuildWarRank) then
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildWarRank, battleIdx)
	if battleFieldData.isFinish then
		if self.battleTimer then
			if self.battleTimer.running then
				self.battleTimer:Stop()
			end
		end
		self.endTimerTxt.text.text = string.formatbykey('GuildWarBattle20')
	end
end

function UIGuildWarView:OnClickCloseBtn()
	self:UIClose()
	if self.uiBase.MSourceUIID > 0 then
		ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID, nil, nil, false)
	end
end

function UIGuildWarView:OnClickHelpBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'GuildWarBattleText'})
end

function UIGuildWarView:OnClickLogBtn()
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle10')
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildWarLog, battleFieldData.id)
end

function UIGuildWarView:OnClickRankBtn()
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle10')
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildWarRank, battleFieldData.id)
end


function UIGuildWarView:SureAutoBuyChallengeNum(isOn)
	if not self:IsBattleMy() then
		return
	end
	local errorCode, costCfgId = self.controller:SendGuildWarSettingReq(isOn)
	if errorCode ~= 0 then
		if errorCode == 1 then
			CommonUtil.ItemNotEnoughHandle(costCfgId, Enum.UIPageName.UIGuildWar)
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end

function UIGuildWarView:OnClickChallengeToggle(toggle, _, isOn)
	local battleFieldData = self.controller:GetBattleFieldData()
	if not self:IsBattleMy() then
		toggle.isOn = battleFieldData.autoChallenge
		return
	end
	if battleFieldData.autoChallenge == isOn then
		return
	end
	toggle.isOn = battleFieldData.autoChallenge
	if not isOn then
		self:SureAutoBuyChallengeNum(false)
		return
	end

	local costCfgId, costNum = self.controller:GetBuyChallengeCountCost()
	local ownNum = self.controller:GetOwnResCountByItemId(costCfgId)
	if ownNum < costNum then
		CommonUtil.ItemNotEnoughHandle(costCfgId, Enum.UIPageName.UIGuildWar)
		return
	end
	local itemName = tostring(costNum)
	local cfgData = ManagerContainer.CfgMgr:GetItemById(costCfgId)
	if cfgData then
		itemName = itemName .. string.formatbykey(cfgData.Name)
	end
	local data = {"GuildWarAutoChangllengeTip", {itemName}, isOn, self, self.SureAutoBuyChallengeNum}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
end

function UIGuildWarView:SureBuyChallengeNum()
	if not self:IsBattleMy() then
		return
	end
	local errorCode, costCfgId = self.controller:SendGuildWarBuyChallengeNumReq()
	if errorCode ~= 0 then
		if errorCode == 1 then
			CommonUtil.ItemNotEnoughHandle(costCfgId, Enum.UIPageName.UIGuildWar)
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end

function UIGuildWarView:OnClickChallengeAddBtn()
	if not self:IsBattleMy() then
		return
	end
	local costCfgId, costNum = self.controller:GetBuyChallengeCountCost()
	local ownNum = self.controller:GetOwnResCountByItemId(costCfgId)
	if ownNum < costNum then
		CommonUtil.ItemNotEnoughHandle(costCfgId, Enum.UIPageName.UIGuildWar)
		return
	end
	local itemName = tostring(costNum)
	local cfgData = ManagerContainer.CfgMgr:GetItemById(costCfgId)
	if cfgData then
		itemName = itemName .. string.formatbykey(cfgData.Name)
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoBuyTimes, {costNum, nil, self.SureBuyChallengeNum, self})
end

function UIGuildWarView:SureAutoBuyReborn(isOn)
	if not self:IsBattleMy() then
		return
	end
	local errorCode, costCfgId = self.controller:SendGuildWarSettingReq(nil, isOn)
	if errorCode ~= 0 then
		if errorCode == 1 then
			CommonUtil.ItemNotEnoughHandle(costCfgId, Enum.UIPageName.UIGuildWar)
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end

function UIGuildWarView:OnClickRebornToggle(toggle, _, isOn)
	local battleFieldData = self.controller:GetBattleFieldData()
	if not self:IsBattleMy() then
		toggle.isOn = battleFieldData.autoReborn
		return
	end
	if battleFieldData.autoReborn == isOn then
		return
	end
	toggle.isOn = battleFieldData.autoReborn
	if not isOn then
		self:SureAutoBuyReborn(false)
		return
	end
	local costCfgId, costNum = self.controller:GetBuyRebornCost()
	local ownNum = self.controller:GetOwnResCountByItemId(costCfgId)
	if ownNum < costNum then
		CommonUtil.ItemNotEnoughHandle(costCfgId, Enum.UIPageName.UIGuildWar)
		return
	end
	local itemName = tostring(costNum)
	local cfgData = ManagerContainer.CfgMgr:GetItemById(costCfgId)
	if cfgData then
		itemName = itemName .. string.formatbykey(cfgData.Name)
	end
	local data = {"GuildWarAutoRebornTip", {itemName}, isOn, self, self.SureAutoBuyReborn}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
end

function UIGuildWarView:SureBuyReborn()
	if not self:IsBattlingMy() then
		return
	end
	local errorCode, costCfgId = self.controller:SendGuildWarBuyRebornReq()
	if errorCode ~= 0 then
		if errorCode == 1 then
			CommonUtil.ItemNotEnoughHandle(costCfgId, Enum.UIPageName.UIGuildWar)
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end

function UIGuildWarView:OnClickRebornAddBtn()
	if not self:IsBattlingMy() then
		return
	end
	local costCfgId, costNum = self.controller:GetBuyRebornCost()
	local ownNum = self.controller:GetOwnResCountByItemId(costCfgId)
	if ownNum < costNum then
		CommonUtil.ItemNotEnoughHandle(costCfgId, Enum.UIPageName.UIGuildWar)
		return
	end
	local itemName = tostring(costNum)
	local cfgData = ManagerContainer.CfgMgr:GetItemById(costCfgId)
	if cfgData then
		itemName = itemName .. string.formatbykey(cfgData.Name)
	end
	local data = {"GuildWarBuyRebornTip", {itemName}, nil, self, self.SureBuyReborn}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
end

function UIGuildWarView:OnClickBuffUpBtn()
	if not self:IsBattleMy() then
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildWarBuff)
end


function UIGuildWarView:OnClickAreaSlotItem(btn, params)
	if not self:IsBattlingMy() then
		return
	end
	local itemLua = params[0]
	if not itemLua then return end
	if self.curSelectAreaItemLua == itemLua then return end
	local areaId = itemLua.areaId
	local areaData = self.controller:GetAreaDataById(areaId)
	if not areaData or not areaData:IsValidData() then
		-- ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle10')
		return
	end
	if not areaData:IsPeopleOccupy() then
		self:CloseMenu()
		if not self:IsBattlingMy() then
			return
		end
		local errorCode = self.controller:SendGuildWarChallengeReq(areaId)
		if errorCode ~= 0 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
		return
	end
	if self.controller:IsSelfArea(areaId) then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle8')
		return
	end
	if self.controller:IsSameGuildArea(areaId) then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle9')
		return
	end
	self:LocationAndOpenMenu(areaId)
end

function UIGuildWarView:OnBeginDragAction(gridView)
	gridView.ItemSnapEnable = false
	self.alignAreaId = nil
	self:StopRefreshArea()
	-- self:CloseSlogan()
end

function UIGuildWarView:OnEndDragAction(gridView)
	gridView.ItemSnapEnable = false
	self.alignAreaId = nil
	self:StartRefreshArea(true)
	-- self:OpenSlogan()
end

function UIGuildWarView:OnSnapItemFinished(gridView, gridViewItem)
	gridView.ItemSnapEnable = false
	self:StartRefreshArea(true)
	if not self.alignAreaId then return end
	local itemIdx, idx = self.controller:GetRawIdxByAreaId(self.alignAreaId)
	if itemIdx == 0
		or itemIdx == gridViewItem.ItemIndex
		or (itemIdx + 1) == self.controller:GetRawCount()  then
		self:OpenMenu(self.alignAreaId)
	end
	self.alignAreaId = nil
	-- self:OpenSlogan()
end


function UIGuildWarView:RefreshPanel()
	self:RefreshInfoPanel()
	self:RefreshFunPanel()
end

function UIGuildWarView:RefreshInfoPanel()
	if self.battleTimer and self.battleTimer.running then
		self.battleTimer:Stop()
	end
	self:RefreshScore()
	self:RefreshArea()
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData then
		self.btnLog:SetActive(false)
		self.btnRank:SetActive(false)
		self.guildInfo:SetActive(false)
		self.beforeBattle:SetActive(false)
		self.battle:SetActive(false)
		self.infoPanel:SetActive(false)
		self:StopRefreshScore()
		self:StopRefreshArea()
		return
	end
	self.infoPanel:SetActive(true)
	self.guildInfo:SetActive(true)
	self.guildNameTxt1.text.text = string.formatbykey('GuildWarBattle5', battleFieldData.guildName1)
	self.guildNameTxt2.text.text = string.formatbykey('GuildWarBattle7', battleFieldData.guildName2)
	self:RefreshBadgeImg(self.guildBadgeImg1.image, battleFieldData.guildBadge1)
	self:RefreshBadgeImg(self.guildBadgeImg2.image, battleFieldData.guildBadge2)

	self.btnLog:SetActive(true)
	self.btnRank:SetActive(true)
	local serverTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	local remainTime = 0
	if battleFieldData.startTime then
		remainTime = battleFieldData.startTime - serverTime
	end
	if remainTime > 0 then
		self.beforeBattle:SetActive(true)
		local langKey = nil
		if battleFieldData.id >= 4 then
			langKey = 'GuildWarBattle1'
		elseif battleFieldData.id >= 2 then
			langKey = 'GuildWarBattle2'
		elseif battleFieldData.id >= 1 then
			langKey = 'GuildWarBattle3'
		end
		self.battleTxt.text.text = langKey and string.formatbykey(langKey) or ''
		self.battle:SetActive(false)
		self:StopRefreshScore()
		self:StopRefreshArea()
	else
		if battleFieldData.endTime then
			remainTime = battleFieldData.endTime - serverTime
		end
		self.beforeBattle:SetActive(false)
		self.battle:SetActive(true)
		if remainTime > 0 then
			self:StartRefreshScore()
			self:StartRefreshArea()
		else
			self:StopRefreshScore()
			self:StopRefreshArea()
		end
	end
	self:RefreshBattleTimer(true)
end

function UIGuildWarView:RefreshBattleTimer(reset)
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData or battleFieldData.isFinish then
		if self.battleTimer and self.battleTimer.running then
			self.battleTimer:Stop()
		end
		return
	end
	local serverTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	local remainTime = nil
	local isStart = nil
	if reset or not self.battleTimer then
		isStart = true
		if battleFieldData.startTime then
			remainTime = battleFieldData.startTime - serverTime
		end
		if not remainTime or remainTime <= 0 then
			isStart = false
			if battleFieldData.endTime then
				remainTime = battleFieldData.endTime - serverTime
			end
		end
	else
		isStart = self.battleTimer.isStart
		if isStart then
			if battleFieldData.startTime then
				remainTime = battleFieldData.startTime - serverTime
			end
		else
			if battleFieldData.endTime then
				remainTime = battleFieldData.endTime - serverTime
			end
		end
	end
	if remainTime and remainTime > 0 then
		remainTime = remainTime / 1000
		if type(remainTime) == 'userdata' then
			remainTime = #remainTime
		end
		if remainTime <= 0 then
			remainTime = 1
		end
	else
		remainTime = 0
	end
	if isStart then
		self.beginTimerTxt.text.text = string.formatbykey('GuildWarBattle4', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, true))
	else
		self.endTimerTxt.text.text = string.formatbykey('GuildWarBattle15', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, true))
	end
	if not remainTime or remainTime <= 0 then
		if self.battleTimer then
			if self.battleTimer.running then
				self.battleTimer:Stop()
			end
			if isStart then
				self:RefreshInfoPanel()
			else
				self:OnBattleFieldEnded(battleFieldData.id)
			end
		end
	else
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
			if not self.battleTimer then
				self.battleTimer = Timer.New(slot(self.RefreshBattleTimer, self), validTime, -1)
			else
				self.battleTimer.duration = validTime
			end
			self.battleTimer.isStart = isStart
			if not self.battleTimer.running then
				self.battleTimer:Start()
			end
		else
			if self.battleTimer then
				if self.battleTimer.running then
					self.battleTimer:Stop()
				end
				if isStart then
					self:RefreshInfoPanel()
				else
					self:OnBattleFieldEnded(battleFieldData.id)
				end
			end
		end
	end
end

function UIGuildWarView:RefreshBadgeImg(image, badge)
	if not image or not badge then return end
	local badgeCfgData = ManagerContainer.CfgMgr:GetGuildBadgeCfgById(badge)
    if not badgeCfgData then return end
	image.enabled = false
	image.sprite = nil
	CommonUtil.LoadIcon(self, badgeCfgData.Pic, function (sprite)
		if sprite then
			image.sprite = sprite
			image.enabled = true
		end
	end)
end

function UIGuildWarView:RefreshFunPanel()
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData or not battleFieldData:IsBattlingMy() then
		self.funPanel:SetActive(false)
		if self.rebornTimer and self.rebornTimer.running then
			self.rebornTimer:Stop()
		end
	else
		self.funPanel:SetActive(true)
		self.challenge.toggle.toggle.isOn = battleFieldData.autoChallenge
		self.challenge.text.text.text = string.formatbykey('ChallengeTimes', battleFieldData.challengeNum and tostring(battleFieldData.challengeNum) or '0')
		self.reborn.toggle.toggle.isOn = battleFieldData.autoReborn
		self:RefreshRebornTimer()
		local buffDic = battleFieldData.buffDic
		if buffDic then
			self:RefreshBuffItem(self.buff1, 1, buffDic[1])
			self:RefreshBuffItem(self.buff2, 2, buffDic[2])
		else
			self:RefreshBuffItem(self.buff1, 1)
			self:RefreshBuffItem(self.buff2, 2)
		end
	end
end

function UIGuildWarView:RefreshRebornTimer()
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData or not battleFieldData:IsBattlingMy() then
		if self.rebornTimer and self.rebornTimer.running then
			self.rebornTimer:Stop()
		end
		self.reborn.times:SetActive(false)
		self:RefreshFunPanel()
		return
	end
	if battleFieldData.rebornTime and battleFieldData.rebornTime >= 0 then
		local remainTime = battleFieldData.rebornTime - ManagerContainer.LuaTimerMgr:CurLuaServerTime()
		if remainTime > 0 then
			if type(remainTime) == 'userdata' then
				remainTime = #remainTime
			end
			remainTime = remainTime / 1000
			local rebornMaxTime = self.controller:GetRebornMaxTime()
			self.reborn.times:SetActive(true)
			if remainTime >= 3.5 then
				self.reborn.times.canvasGroup.alpha = 1
			elseif remainTime >= 3 then
				self.reborn.times.canvasGroup.alpha = (remainTime - 3) * 2
			elseif remainTime >= 2.5 then
				self.reborn.times.canvasGroup.alpha = (3 - remainTime) * 2
			elseif remainTime >= 2 then
				self.reborn.times.canvasGroup.alpha = (remainTime - 2) * 2
			elseif remainTime >= 1.5 then
				self.reborn.times.canvasGroup.alpha = (2 - remainTime) * 2
			elseif remainTime >= 1 then
				self.reborn.times.canvasGroup.alpha = (remainTime - 1) * 2
			elseif remainTime >= 0.5 then
				self.reborn.times.canvasGroup.alpha = (1 - remainTime) * 2
			else
				self.reborn.times.canvasGroup.alpha = remainTime * 2
			end
			self.reborn.text.text.text = string.formatbykey('ReviveCountDown', DateTimeUtil.convertSeconds2TimeStr1(remainTime, false, true, false))
			self.reborn.slider.value = Mathf.Clamp01(remainTime / rebornMaxTime)

			if not self.rebornTimer then
				self.rebornTimer = FrameTimer.New(slot(self.RefreshRebornTimer, self), 1, -1)
			end
			if not self.rebornTimer.running then
				self.rebornTimer:Start()
			end
			return
		end
	end
	if self.rebornTimer and self.rebornTimer.running then
		self.rebornTimer:Stop()
	end
	self.reborn.times:SetActive(false)
end

function UIGuildWarView:RefreshBuffItem(buffLua, cfgId, lv)
	if not buffLua then return end
	buffLua.icon.image.enabled = false
	buffLua.icon.image.sprite = nil
	if cfgId then
		local cfgData = ManagerContainer.CfgMgr:GetGuildWarBuffCfgById(cfgId)
		if cfgData then
			CommonUtil.LoadIcon(self, cfgData.Icon, function (sprite)
				if sprite then
					buffLua.icon.image.sprite = sprite
					buffLua.icon.image.enabled = true
				end
			end)
		end
	end
	buffLua.level.text.text = lv and tostring(lv) or '0'
end

function UIGuildWarView:StartRefreshScore()
	if not self.scoreTimer then
		self.scoreTimer = Timer.New(slot(self.RefreshScoreTimer, self), SCROE_INTERVAL, -1)
	end
	if not self.scoreTimer.running then
		self.scoreTimer:Start()
	end
	if not self.scoreTimer.lastUpdateTime  then
		self:RefreshScoreTimer()
	else
		local remainTime = (ManagerContainer.LuaTimerMgr:CurLuaServerTime() - self.scoreTimer.lastUpdateTime)
		if remainTime > 0 then
			remainTime = remainTime / 1000
			if type(remainTime) == 'userdata' then
				remainTime = #remainTime
			end
			self.scoreTimer.time = remainTime
		else
			self:RefreshScoreTimer()
		end
	end
end

function UIGuildWarView:StopRefreshScore()
	if self.scoreTimer and self.scoreTimer.running then
		self.scoreTimer:Stop()
	end
end

function UIGuildWarView:RefreshScoreTimer()
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData then
		self:StopRefreshScore()
		return
	end
	if battleFieldData.isFinish then
		self:StopRefreshScore()
		return
	end
	local serverTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	if not battleFieldData.startTime or battleFieldData.startTime > serverTime then
		self:StopRefreshScore()
		return
	end
	if not battleFieldData.endTime or battleFieldData.endTime < serverTime then
		self:StopRefreshScore()
		return
	end
	self.scoreTimer.lastUpdateTime = serverTime
	self.controller:SendGuildWarScoreDataReq()
end

function UIGuildWarView:RefreshScore()
	local dojoName = string.formatbykey('GuildWarBattle14')
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData then
		self.scoreSlider.slider:DOValue(0.5, 0)
		self.scoreTxt1.text.text = '0'
		self.scoreTxt2.text.text = '0'
		self.dojoNumTxt1.text.text = '0' .. tostring(dojoName)
		self.dojoNumTxt2.text.text = '0' .. tostring(dojoName)
		return
	end
	local time = SCROE_INTERVAL
	if not self.isInitScore then
		time = 0
		self.isInitScore = true
	end
	local score1 = battleFieldData.guildScore1
	if not score1 or score1 <= 0 then score1 = 0 end
	local score2 = battleFieldData.guildScore2
	if not score2 or score2 <= 0 then score2 = 0 end
	local score = score1 + score2
	if score <= 0 then
		self.scoreSlider.slider:DOValue(0.5, time)
	else
		self.scoreSlider.slider:DOValue(score2 / score, time)
	end
	self.scoreTxt1.text.text = tostring(score1)
	self.scoreTxt2.text.text = tostring(score2)

	local occupy1 = battleFieldData.guildOccupy1
	if not occupy1 or occupy1 <= 0 then occupy1 = 0 end
	local occupy2 = battleFieldData.guildOccupy2
	if not occupy2 or occupy2 <= 0 then occupy2 = 0 end
	self.dojoNumTxt1.text.text = tostring(occupy1) .. tostring(dojoName)
	self.dojoNumTxt2.text.text = tostring(occupy2) .. tostring(dojoName)
end


function UIGuildWarView:StartRefreshArea(forceUpdate)
	if not self.areaTimer then
		self.areaTimer = Timer.New(slot(self.RefreshAreaTimer, self), AREA_INTERVAL, -1)
	end
	if forceUpdate then
		local battleFieldData = self.controller:GetBattleFieldData()
		if not battleFieldData then
			return
		end
		if battleFieldData.isFinish then
			return
		end
		local serverTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
		if not battleFieldData.startTime or battleFieldData.startTime > serverTime then
			return
		end
		if not battleFieldData.endTime or battleFieldData.endTime < serverTime then
			return
		end
		self.areaTimer.lastUpdateTime = serverTime - 1000
	end
	if not self.areaTimer.running then
		self.areaTimer:Start()
	end
	if not self.areaTimer.lastUpdateTime  then
		self:RefreshAreaTimer()
	else
		local remainTime = (ManagerContainer.LuaTimerMgr:CurLuaServerTime() - self.areaTimer.lastUpdateTime)
		if remainTime > 0 then
			remainTime = remainTime / 1000
			if type(remainTime) == 'userdata' then
				remainTime = #remainTime
			end
			self.areaTimer.time = remainTime
		else
			self:RefreshAreaTimer()
		end
	end
end

function UIGuildWarView:StopRefreshArea()
	if self.areaTimer and self.areaTimer.running then
		self.areaTimer:Stop()
	end
end

function UIGuildWarView:RefreshAreaTimer()
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData then
		self:StopRefreshArea()
		return
	end
	if battleFieldData.isFinish then
		self:StopRefreshArea()
		return
	end
	local serverTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	if not battleFieldData.startTime or battleFieldData.startTime > serverTime then
		self:StopRefreshArea()
		return
	end
	if not battleFieldData.endTime or battleFieldData.endTime < serverTime then
		self:StopRefreshArea()
		return
	end
	self.areaTimer.lastUpdateTime = serverTime
	local showRawIdxs = self.controller:GetShowRawIdxs()
	local startId, endId
	for i = 1, #showRawIdxs do
		local startId1, endId1 = self.controller:GetRawAreaStartAndEnd(showRawIdxs[i])
		if not startId or not endId then
			startId = startId1
			endId = endId1
		else
			if startId > startId1 then
				startId = startId1
			end
			if endId < endId1 then
				endId = endId1
			end
		end
	end
	if not startId or not endId then
		LogError('[wboy] not find need get data')
		return
	end
	if endId < startId then
		LogError('[wboy] not find need get valid data')
		return
	end
	local areaIds = {}
	if (endId - startId) > 30 then
		LogWarning('[Wboy] Need Get Data is Num' .. tostring((endId - startId)))
	end
	for i = startId, endId do
		local areaCfgData = ManagerContainer.CfgMgr:GetGuildWarDojoCfgById(i)
		if areaCfgData then
			areaIds[#areaIds+1] = i
		end
	end
	self.controller:SendGuildWarAreaDatasReq(areaIds)
end

function UIGuildWarView:RefreshArea()
	local loopGridView = self.scrollView.loopGridView
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData then
		loopGridView:RefreshListByIndex(0, 0)
		self.isInitGrid = nil
		return
	end
	local itemCount = loopGridView.ItemTotalCount
	local count  = self.controller:GetRawCount()
	if itemCount ~= count then
		local areaId = self.controller:GetLastAttackAreaId()
		if areaId and areaId > 0 then
			local padding = loopGridView.Padding
			local height = (loopGridView.ViewPortHeight - loopGridView.ItemSizeWithPadding.y) * 0.5 - padding.top
			local itemIdx = self.controller:GetRawIdxByAreaId(areaId)
			loopGridView:RefreshListByIndex(count, itemIdx, 0, -height)
		else
			loopGridView:RefreshListByIndex(count, 0)
		end
		self.isInitGrid = true
	end
end

function UIGuildWarView:GetItemByRowColumn(gridView, itemIndex, row, column)
	self.controller:AddShowRawIdx(itemIndex)
	local startId, endId = self.controller:GetRawAreaStartAndEnd(itemIndex)
	local item = gridView:NewListViewItem('GuildWarRawItem')
	local itemLua = self:GetRawItemLua(item.gameObject)
	if itemLua then
		for i = startId, endId do
			self:RefreshAreaItemLuaByAreaId(itemLua, i)
		end
	end
	ManagerContainer.LuaUIMgr:ForceRebuildLayoutImmediate(item.CachedRectTransform)
	return item
end

function UIGuildWarView:RecycleItem(gridView, itemIndex, row, column, loopGridViewItem)
	self.controller:RemoveShowRawIdx(itemIndex)
	local itemLua = self:GetRawItemLua(loopGridViewItem.gameObject)
	if not itemLua then return end
	local childrenLua = itemLua.childrenLua
	if childrenLua then
		for _, areaItemLua in pairs(childrenLua) do
			self:ReleaseAreaItemLua(areaItemLua)
		end
	end
	itemLua.childrenLua = nil
end

function UIGuildWarView:GetRawItemLua(go)
	local itemLua = nil
	if self.rawItemDic  then
		itemLua = self.rawItemDic[go]
	else
		self.rawItemDic = {}
	end
	if not itemLua then
		itemLua = 
		{
			gameObject = go,
			transform = go.transform,
		}
		self.rawItemDic[go] = itemLua
	end
	return itemLua
end

function UIGuildWarView:DisposeRawItemLua()
	self.rawItemDic = nil
end

function UIGuildWarView:FindAreaItemLuaByAreaId(areaId)
	local itemIdx, idx = self.controller:GetRawIdxByAreaId(areaId)
	local item = self.scrollView.loopGridView:GetShownItemByItemIndex(itemIdx)
	if item then
		local itemLua = self:GetRawItemLua(item.gameObject)
		if itemLua then
			if itemLua.childrenLua then
				return itemLua.childrenLua[idx]
			end
		end
	end
	return nil
end


function UIGuildWarView:RefreshItemLua(areaId)
	if not areaId then return end
	local itemIdx, idx = self.controller:GetRawIdxByAreaId(areaId)
	local item = self.scrollView.loopGridView:GetShownItemByItemIndex(itemIdx)
	if item then
		local itemLua = self:GetRawItemLua(item.gameObject)
		if itemLua then
			self:RefreshAreaItemLuaByAreaId(itemLua, areaId)
		end
	end
end

function UIGuildWarView:RefreshAreaItemLuaByAreaId(itemLua, areaId)
	local childrenLua = itemLua.childrenLua
	if not childrenLua then
		childrenLua = {}
		itemLua.childrenLua = childrenLua
	end
	local areaCfgData = ManagerContainer.CfgMgr:GetGuildWarDojoCfgById(areaId)
	if areaCfgData then
		local itemIdx, idx = self.controller:GetRawIdxByAreaId(areaId)
		local areaItemLua = childrenLua[idx]
		if not areaItemLua then
			self:ReleaseAreaItemLua(areaItemLua)
			areaItemLua = self:GetAreaItemLua(itemLua.transform)
			childrenLua[idx] = areaItemLua
		end
		self:RefreshAreaItemLua(areaItemLua, areaId)
	end
end

function UIGuildWarView:RefreshAreaItemLua(areaItemLua, areaId, hideName)
	if not areaItemLua then return end
	areaItemLua.areaId = areaId
	local areaCfgData = ManagerContainer.CfgMgr:GetGuildWarDojoCfgById(areaId)
	if areaCfgData then
		areaItemLua:SetActive(true)
		local heroCutePath = nil
		local areaData = self.controller:GetAreaDataById(areaId)
		local picIdx = 1
		if areaData and areaData:IsOccupy() then
			local color = nil
			local battleFieldData = self.controller:GetBattleFieldData()
			if battleFieldData then
				if battleFieldData.guildId1 == areaData.guildId then
					picIdx = 2
					color = GUILD_COLOR_ID1
				elseif battleFieldData.guildId2 == areaData.guildId then
					picIdx = 3
					color = GUILD_COLOR_ID2
				end
			end
			if not color then
				color = GUILD_COLOR_DEFAULT
			end
			local playBrief = areaData:GetPlayBrief()
			if playBrief and playBrief.uid and playBrief.uid > 0 then
				local playName = nil
				local atkPower = playBrief.fightPower
				if self.controller:IsSelfArea(areaId) then
					playName = self.controller:GetUserNickname()
					local roleId = self.controller:GetUserRoleId()
					local roleCfgData = ManagerContainer.CfgMgr:GetRoleDataById(roleId)
					if roleCfgData then
						heroCutePath = roleCfgData.HeroCute
					end
				else
					playName = playBrief.nickName
					local roleId = CommonUtil.JobIdToRoleId(playBrief.configId, playBrief.gender)
					local roleCfgData = ManagerContainer.CfgMgr:GetRoleDataById(roleId)
					if roleCfgData then
						heroCutePath = roleCfgData.HeroCute
					end
				end
				areaItemLua.nameBoard.bG.image.color = color
				areaItemLua.nameBoard.nameTxt.text.text = (playName and tostring(playName) or '')
				areaItemLua.nameBoard.power.text.text = tostring(atkPower)
				if hideName then
					areaItemLua.nameBoard:SetActive(false)
				else
					areaItemLua.nameBoard:SetActive(true)
				end
				if not heroCutePath or heroCutePath == '' then
					heroCutePath = self.controller:GetDefaultHeroCute()
				end
			else
				areaItemLua.nameBoard:SetActive(false)
			end
			if areaData:IsFighting() then
				areaItemLua.animator:Play('BattleKeep')
			else
				areaItemLua.animator:Play('NormalKeep')
			end
		elseif not areaData or not areaData:IsValidData() then
			-- if not heroCutePath or heroCutePath == '' then
			-- 	heroCutePath = self.controller:GetDefaultHeroCute()
			-- end
			areaItemLua.animator:Play('NormalKeep')
			areaItemLua.nameBoard:SetActive(false)
		else
			if areaData:IsFighting() then
				areaItemLua.animator:Play('BattleKeep')
			else
				areaItemLua.animator:Play('EmptyKeep')
			end
			areaItemLua.nameBoard:SetActive(false)
		end
		areaItemLua.player.image.enabled = false
		areaItemLua.player.image.sprite = nil
		areaItemLua.shadow:SetActive(false)
		CommonUtil.LoadIcon(self, heroCutePath, function(sprite)
			areaItemLua.player.image.sprite = sprite
			areaItemLua.player.image.enabled = true
			areaItemLua.shadow:SetActive(true)
		end, areaItemLua, 'AreaItemHeroCuteAsyncIdx')
		local thronePaths = THRONE_PATHS[areaCfgData.AreaType]
		local thronePath = thronePaths and thronePaths[picIdx] or nil
		areaItemLua.imgThrone.image.enabled = false
		areaItemLua.imgThrone.image.sprite = nil
		CommonUtil.LoadIcon(self, thronePath, function(sprite)
			if sprite then
				areaItemLua.imgThrone.image.sprite = sprite
				areaItemLua.imgThrone.image.enabled = true
			end
		end, areaItemLua, 'ImgThroneAsyncIdx')
	else
		areaItemLua:SetActive(false)
	end
end






function UIGuildWarView:GetAreaItemLua(parent)
	if self.areaPool then
		if self.areaPool then
			local item = self.areaPool[#self.areaPool]
			if item then
				self.areaPool[#self.areaPool] = nil
				item.transform:SetParent(parent)
				item.transform.localPosition = Vector3.zero
				item.transform.localScale = Vector3.one
				item.transform.localRotation = Quaternion.identity
				item:SetActive(true)
				return item
			end
		end
	end
	local source = self.guildWarSlotItem
	if not source then return nil end
	local newGo = UnityEngine.GameObject.Instantiate(source.gameObject)
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, source.prefabName, newGo)
	itemLua.transform:SetParent(parent)
	itemLua.transform.localPosition = Vector3.zero
	itemLua.transform.localScale = Vector3.one
	itemLua.transform.localRotation = Quaternion.identity
	itemLua:SetActive(true)
	self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickAreaSlotItem, itemLua)
	return itemLua
end

function UIGuildWarView:ReleaseAreaItemLua(itemLua)
	if not itemLua then return end
	if not self.areaPool then
		self.areaPool = {}
	end
	itemLua.transform:SetParent(self.scrollView.transform)
	itemLua:SetActive(false)
	self.areaPool[#self.areaPool + 1] = itemLua
end

function UIGuildWarView:DisposeAreaItemLua()
	if not self.areaPool then
		return
	end
	for _, itemLua in pairs(self.areaPool) do
		if itemLua.gameObject then
			CommonUtil.DestroyGO(itemLua.gameObject)
		end
	end
	self.areaPool = nil
end





function UIGuildWarView:LocationAndOpenMenu(areaId)
	local itemIdx = self.controller:GetRawIdxByAreaId(areaId)
	local loopGridView = self.scrollView.loopGridView
	local pair1 = loopGridView:GetRowColumnByItemIndex(itemIdx)
	local pair2 = loopGridView:GetRowColumnByItemIndex(itemIdx + 1)
	local offset = loopGridView.ContainerTrans.anchoredPosition
	local itemPosStart = loopGridView:GetItemPos(pair1.mRow, pair1.mColumn) + offset
	local itemPosEnd = loopGridView:GetItemPos(pair2.mRow, pair2.mColumn) + offset
	local rect = self.viewRect.rectTransform.rect
	local min = self.viewRect.rectTransform:TransformPoint(rect.min)
	local max = self.viewRect.rectTransform:TransformPoint(rect.max)
	local scrollRect = loopGridView.ScrollRect
	local viewport = scrollRect.viewport
	min = viewport:InverseTransformPoint(min)
	max = viewport:InverseTransformPoint(max)

	local isStart1 = ((itemPosStart.y - min.y) >= 0.001)
	local isStart2 = ((itemPosStart.y - max.y) <= 0.001)
	local isEnd1 = ((itemPosEnd.y - min.y) >= 0.001)
	local isEnd2 = ((itemPosEnd.y - max.y) <= 0.001 )

	if isStart1 and isStart2 and isEnd1 and isEnd2 then
		self:OpenMenu(areaId)
		return
	end
	local val = scrollRect.verticalNormalizedPosition
	if val <= 0 or val >= 1 then
		self:OpenMenu(areaId)
		return
	end
	-- self:CloseSlogan()
	self.alignAreaId = areaId
	if self.areaTimer then
		self.areaTimer:Stop()
	end
	loopGridView.ItemSnapEnable = true
	loopGridView:SetSnapTargetItemRowColumn(pair1.mRow, pair1.mColumn)
	local rect1 = viewport.rect
	if isEnd1 then
		loopGridView.ItemSnapPivot = Vector2.one
		local pivotOffset = (rect1.yMax - max.y)
		if pivotOffset <= 0 then
			pivotOffset = 1
		else
			pivotOffset = 1 - pivotOffset / rect1.height
		end
		loopGridView.ViewPortSnapPivot = Vector2(0, pivotOffset)
		return
	end
	loopGridView.ItemSnapPivot = Vector2.zero
	local pivotOffset = (min.y - rect1.yMin)
	if pivotOffset <= 0 then
		pivotOffset = 0
	else
		pivotOffset = pivotOffset / rect1.height
	end
	loopGridView.ViewPortSnapPivot = Vector2(0, pivotOffset)
end


function UIGuildWarView:OpenMenu(areaId)
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData then
		self:CloseMenu()
		return
	end
	local isBattlingMy = battleFieldData:IsBattlingMy()
	if not areaId then
		self:CloseMenu()
		return
	end
	self.curSelectAreaId = areaId
	if self.controller:IsSelfArea(areaId) then
		self:CloseMenu()
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle8')
		return
	end
	local areaData = battleFieldData:GetAreaDataById(areaId)
	if not areaData or not areaData:IsValidData() then
		self:CloseMenu()
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle10')
		return
	else
		if not areaData:IsPeopleOccupy() then
			self:CloseMenu()
			if isBattlingMy then
				local errorCode = self.controller:SendGuildWarChallengeReq(areaId)
				if errorCode ~= 0 then
					ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
				end
			end
			return
		end
	end
	local itemIdx, idx = self.controller:GetRawIdxByAreaId(areaId)
	local item = self.scrollView.loopGridView:GetShownItemByItemIndex(itemIdx)
	if not item then
		self:CloseMenu()
		return
	end
	local itemLua = self:GetRawItemLua(item.gameObject)
	if not itemLua then
		self:CloseMenu()
		return
	end
	local childrenLua = itemLua.childrenLua
	if not childrenLua then
		self:CloseMenu()
		return
	end
	local areaItemLua = childrenLua[idx]
	if not areaItemLua then
		self:CloseMenu()
		return
	end
	local areaCfgData = ManagerContainer.CfgMgr:GetGuildWarDojoCfgById(areaId)
	if not areaCfgData then
		self:CloseMenu()
		return
	end
	local playName = nil
	local atkPower = 0
	local color = nil
	local playBrief = areaData:GetPlayBrief()
	if playBrief then
		playName = playBrief.nickName
		atkPower = playBrief.fightPower
	end
	if battleFieldData then
		if battleFieldData.guildId1 == areaData.guildId then
			color = GUILD_COLOR_ID1
		elseif battleFieldData.guildId2 == areaData.guildId then
			color = GUILD_COLOR_ID2
		end
	end
	if not color then
		color = GUILD_COLOR_DEFAULT
	end
	self.menu:SetActive(true)
	if not self.curSelectAreaItemLua then
		self.curSelectAreaItemLua = self:GetAreaItemLua(self.menu.transform)
	end
	if self.curSelectAreaItemLua then
		self.curSelectAreaItemLua.transform.position = areaItemLua.transform.position
		self:RefreshAreaItemLua(self.curSelectAreaItemLua, areaId, true)
	end
	self.menu.panel.transform.position = areaItemLua.transform.position
	self.menu.panel.transform:SetAsLastSibling()
	self.menu.nameBoard.bG.image.color = color
	self.menu.nameBoard.nameTxt.text.text = (playName and tostring(playName) or '')
	self.menu.nameBoard.power.text.text = tostring(atkPower)
	self.menu.nameBoard:SetActive(true)
	self.menu.btnInfo:SetActive(true)
	self.menu.btnClg:SetActive(isBattlingMy and areaData:GetGuildId() ~= battleFieldData.guildId)
	-- self:ReleaseOtherSloganByAreaId(areaId)
end

function UIGuildWarView:CloseMenu()
	self.curSelectAreaId = nil
	if self.curSelectAreaItemLua then
		self:ReleaseAreaItemLua(self.curSelectAreaItemLua)
		self.curSelectAreaItemLua = nil
	end
	self.menu:SetActive(false)
end

function UIGuildWarView:OnClickMenuCloseBtn()
	self:CloseMenu()
end

function UIGuildWarView:OnClickMenuChallengeBtn()
	local areaId = self.curSelectAreaId
	if not areaId then return end
	if not self:IsBattlingMy() then
		return
	end
	local areaData = self.controller:GetAreaDataById(areaId)
	if not areaData or not areaData:IsValidData() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle10')
		return
	end
	if areaData:IsPeopleOccupy() then
		if self.controller:IsSelfArea(areaId) then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle8')
			return
		end
		if self.controller:IsSameGuildArea(areaId) then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle9')
			return
		end
	end
	self:CloseMenu()
	local errorCode = self.controller:SendGuildWarChallengeReq(areaId)
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildWarView:OnClickMenuInfoBtn()
	local areaId = self.curSelectAreaId
	if not areaId then return end
	local areaData = self.controller:GetAreaDataById(areaId)
	if not areaData or not areaData:IsValidData() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle10')
		return
	end
	if not areaData:IsPeopleOccupy() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle10')
		return
	end
	if self.controller:IsSelfArea(areaId) then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle8')
		return
	end
	self:CloseMenu()
	local playBrief = areaData:GetPlayBrief()
	if playBrief then
		ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(playBrief.uid)
	end
end


function UIGuildWarView:IsBattleMy()
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle10')
		return false
	end
	if battleFieldData.isFinish then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle20')
		return false
	end
	if not battleFieldData:IsBattlingMy() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle11')
		return false
	end
	local serverTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	if not battleFieldData.endTime or battleFieldData.endTime < serverTime then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle20')
		return false
	end
	return true
end

function UIGuildWarView:IsBattlingMy()
	local battleFieldData = self.controller:GetBattleFieldData()
	if not battleFieldData then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle10')
		return false
	end
	if battleFieldData.isFinish then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle20')
		return false
	end
	if not battleFieldData:IsBattlingMy() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle11')
		return false
	end
	local serverTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	if not battleFieldData.startTime or battleFieldData.startTime > serverTime then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle19')
		return false
	end
	if not battleFieldData.endTime or battleFieldData.endTime < serverTime then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle20')
		return false
	end
	return true
end


return UIGuildWarView

