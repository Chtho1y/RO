local UIClimbingTowerRankView = require("UIClimbingTower/UIClimbingTowerRankView_Generate")

function UIClimbingTowerRankView:OnAwake(data)
	self.controller = require("UIClimbingTower/UIClimbingTowerRankCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIClimbingTowerRankView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_ClimbingTower_RankData,self,self.OnRefreshRankList);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_ClimbingTower_RankDetailData,self,self.OnRankDataCB);
end

function UIClimbingTowerRankView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIClimbingTowerRankView:Init()
	self.frameUrl = GlobalConfig.Instance:GetConfigStrValue(179)
	self.lastReqTime = 0
	self.rankScroll.loopVerticalScrollRect:SetDragLuaCallback(self.OnDragScrollView)
	self.selfRank:SetActive(false)
	-- self:RefreshSelfRank()
	self:OnRefreshRankData()
end

function UIClimbingTowerRankView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIClimbingTowerRankView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self, self.OnClickCloseBtn)

end

function UIClimbingTowerRankView:OnHide()

end

function UIClimbingTowerRankView:OnShow(data)
	self.controller:SetData(data)

end

function UIClimbingTowerRankView:OnClose()
	self.rankScroll.loopVerticalScrollRect:ClearCells()
end

function UIClimbingTowerRankView:OnDispose()
	self.controller:OnDispose()
end

function UIClimbingTowerRankView:RefreshSelfRank()
	local type = self.controller:GetCurTowerType()

	self.selfRank.levelNumTips:SetActive(type == Enum.UnlimitTowerType.ClimbingTower)
	self.selfRank.levelNum:SetActive(type == Enum.UnlimitTowerType.ClimbingTower)
	self.selfRank.passedTimeTips:SetActive(type == Enum.UnlimitTowerType.ClimbingTower)
	self.selfRank.passedTime:SetActive(type == Enum.UnlimitTowerType.ClimbingTower)

	self.selfRank.blockNumTitle:SetActive(type == Enum.UnlimitTowerType.PeakTower)
	self.selfRank.blockNum:SetActive(type == Enum.UnlimitTowerType.PeakTower)
	self.selfRank.serverName:SetActive(type == Enum.UnlimitTowerType.PeakTower)

	if type == Enum.UnlimitTowerType.ClimbingTower then
		self:RefreshClimbingTowerSelfRank()
	elseif type == Enum.UnlimitTowerType.PeakTower then
		self:RefreshPeakTowerSelfRank()
	end

	self.selfRank:SetActive(true)
end

function UIClimbingTowerRankView:RefreshClimbingTowerSelfRank()
	local userData = ManagerContainer.DataMgr.UserData
	local rank = self.controller:GetSelfRank()
	if rank > 1000  or  rank == 0 then
		self.selfRank.rank.text.text =  I18N.T("NoRank")
	else
		self.selfRank.rank.text.text = tostring(rank)
	end

	self.selfRank.playerNode.playerName.text.text = userData:GetUserNickname()
	self.selfRank.playerNode.fighterPower.text.text = userData:GetTotalFightPower()
	--self.selfRank.playerNode.playerLevel.text.text = tostring(userData:GetRoleLv())
	self.selfRank.levelNum.text.text = tostring(self.controller:GetCurLevelNum() - 1)
	if self.controller:GetSelfPassedTime() > 0 then
		self.selfRank.passedTime.text.text = DateTimeUtil.convertTime2Str(self.controller:GetSelfPassedTime(),"yyyy/MM/dd")
	else
		self.selfRank.passedTime.text.text = DateTimeUtil.convertTime2Str(self.controller:GetSelfPassedTime(),"--/--/--")
	end

	local _playerHead = userData:GetUserHeadIcon()
	local _headFrameId = ManagerContainer.DataMgr.UserData:GetHeadFrameId();
	local _fakerData = {Level = userData:GetRoleLv(), ProfessionIcon = userData:GetJobIcon(), HeadIcon = _playerHead, IsHero = true};
	CommonUtil.SetPlayerHeadAndFrame(self, self.selfRank.playerNode.headItem, _fakerData,false, _headFrameId, self, self.OnClickSelfHead);

	self.selfRank.vipIcon.image.enabled = false
	self.selfRank.vipIcon.image.sprite = nil
	local vipLv = userData:GetVipLv()
	if vipLv and vipLv >= 0 then
		local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
		if vipCfg then
			CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
				if sprite then
					self.selfRank.vipIcon.image.sprite = sprite
					self.selfRank.vipIcon.image.enabled = true
				end
			end)
		end
	end

	--self.uiBase:AddButtonUniqueEventListener(self.selfRank.playerNode.playerHead.button,self,self.OnClickSelfHead)
end

function UIClimbingTowerRankView:RefreshPeakTowerSelfRank()
	local userData = ManagerContainer.DataMgr.UserData
	local rank = self.controller:GetPeakTowerSelfRankIdx()
	if rank > 1000  or  rank == 0 then
		self.selfRank.rank.text.text = I18N.T("NoRank")
	else
		self.selfRank.rank.text.text = tostring(rank)
	end

	self.selfRank.playerNode.playerName.text.text = userData:GetUserNickname()
	self.selfRank.playerNode.fighterPower.text.text = userData:GetTotalFightPower()
	
	self.selfRank.blockNum.text.text = self.controller:GetPeakTowerSelfRankScore()

	local serverData = ManagerContainer.LuaGameMgr.serverData
	self.selfRank.serverName.text.text =  I18N.SetLanguageValue("TopTowerServer", serverData and serverData.id or 0) 

	local _playerHead = userData:GetUserHeadIcon()
	local _headFrameId = ManagerContainer.DataMgr.UserData:GetHeadFrameId();
	local _fakerData = {Level = userData:GetRoleLv(), ProfessionIcon = userData:GetJobIcon(), HeadIcon = _playerHead, IsHero = true};
	CommonUtil.SetPlayerHeadAndFrame(self, self.selfRank.playerNode.headItem, _fakerData,false, _headFrameId, self, self.OnClickSelfHead);

	self.selfRank.vipIcon.image.enabled = false
	self.selfRank.vipIcon.image.sprite = nil
	local vipLv = userData:GetVipLv()
	if vipLv and vipLv >= 0 then
		local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
		if vipCfg then
			CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
				if sprite then
					self.selfRank.vipIcon.image.sprite = sprite
					self.selfRank.vipIcon.image.enabled = true
				end
			end)
		end
	end
end

function UIClimbingTowerRankView:OnRefreshRankList()
	self:RefreshSelfRank()
	self.controller:ReqestRankBriefData()
end

function UIClimbingTowerRankView:OnDragScrollView()
	local curTime = Time.realtimeSinceStartup
	if (curTime - self.lastReqTime) >= 0.1 then
		self.controller:ReqestRankBriefData()
		self.lastReqTime = curTime
	end
end

function UIClimbingTowerRankView:OnRankDataCB()
	self:RefreshSelfRank()
	self:OnRefreshRankData()
end

function UIClimbingTowerRankView:OnRefreshRankData()
	local rankList = self.controller:GetRankData()
	if rankList ~= nil and next(rankList) ~= nil then
		self.rankScroll:SetActive(true)
		CommonUtil.LoopGridViewEleCreateNew(self,
								self.rankScroll.loopVerticalScrollRect,
								self.rankContent.gridLayoutGroup,rankList,0,self,self.OnUpdateRankData)

		local type = self.controller:GetCurTowerType()
		if type == Enum.UnlimitTowerType.ClimbingTower then
			self.rankScroll.loopVerticalScrollRect.totalCount = math.min(#rankList, 50)
		elseif type == Enum.UnlimitTowerType.PeakTower then
			self.rankScroll.loopVerticalScrollRect.totalCount =  math.min(#rankList, 20)
		end
	else
		self.rankScroll:SetActive(false)
	end

	self.emptyNode:SetActive(rankList == nil or #rankList == 0)
end

function UIClimbingTowerRankView:OnUpdateRankData(rankItemLua,idx,rankData)
	local type = self.controller:GetCurTowerType()

	rankItemLua.levelNumTips:SetActive(type == Enum.UnlimitTowerType.ClimbingTower)
	rankItemLua.levelNum:SetActive(type == Enum.UnlimitTowerType.ClimbingTower)
	rankItemLua.passedTimeTips:SetActive(type == Enum.UnlimitTowerType.ClimbingTower)
	rankItemLua.passedTime:SetActive(type == Enum.UnlimitTowerType.ClimbingTower)

	rankItemLua.blockNumTitle:SetActive(type == Enum.UnlimitTowerType.PeakTower)
	rankItemLua.blockNum:SetActive(type == Enum.UnlimitTowerType.PeakTower)
	rankItemLua.serverName:SetActive(type == Enum.UnlimitTowerType.PeakTower)

	if type == Enum.UnlimitTowerType.ClimbingTower then
		self:RefreshClimibingTowerRankItem(rankItemLua,idx,rankData)
	elseif type == Enum.UnlimitTowerType.PeakTower then
		self:RefreshPeakTowerRankItem(rankItemLua,idx,rankData)
	end
end

function UIClimbingTowerRankView:RefreshClimibingTowerRankItem(rankItemLua,idx,rankData)
	if rankItemLua == nil  or rankData == nil then
		return
	end
	
	if rankData.rank > 3 then
		rankItemLua.rank.text.text = tostring(rankData.rank)
		rankItemLua.rank:SetActive(true)
		rankItemLua.rankImg:SetActive(false)
	else
		rankItemLua.rankImg.image.sprite = rankItemLua.rankImg.switchSprite:GetSprite("icon_medal_"..rankData.rank)
		rankItemLua.rank:SetActive(false)
		rankItemLua.rankImg:SetActive(true)
		rankItemLua.rankImg.image:SetNativeSize()
	end
	
	rankItemLua.playerName.text.text = rankData.playerName
	rankItemLua.headItem.levelText.text.text = tostring(rankData.playerLevel)

	local _jobIcon = nil;
	local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(rankData.playerJobId)
	if jobCfg ~= nil then
		_jobIcon = jobCfg.JobIcon;
	end

	local _fakerData = {Level = rankData.playerLevel, ProfessionIcon = _jobIcon, HeadIcon = rankData.playerHead, IsHero = true};
	CommonUtil.SetPlayerHeadAndFrame(self, rankItemLua.headItem, _fakerData,false, rankData.headFrameId , self, self.OnClickPlayerHead,rankData.playerId);
--[[
	if self.frameUrl ~= nil then
		CommonUtil.LoadIcon(self, self.frameUrl, function (sprite)
			rankItemLua.headItem.headFrame.image.sprite = sprite
		end)
	end
]]--
	rankItemLua.levelNum.text.text = tostring(rankData.leveLNum)
	rankItemLua.passedTime.text.text = rankData.passedTimeStr

	rankItemLua.vipIcon.image.enabled = false
	rankItemLua.vipIcon.image.sprite = nil
	local vipLv = rankData.vipLv
	if vipLv and vipLv >= 0 then
		local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
		if vipCfg then
			CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
				if sprite then
					rankItemLua.vipIcon.image.sprite = sprite
					rankItemLua.vipIcon.image.enabled = true
				end
			end, rankItemLua, 'VipIcon')
		end
	end

	--self.uiBase:AddButtonUniqueEventListener(rankItemLua.headItem.head.button,self,self.OnClickPlayerHead,rankData.playerId)
end

function UIClimbingTowerRankView:RefreshPeakTowerRankItem(rankItemLua,idx,rankData)
	if rankItemLua == nil  or rankData == nil then
		return
	end
	
	if rankData.rank > 3 then
		rankItemLua.rank.text.text = tostring(rankData.rank)
		rankItemLua.rank:SetActive(true)
		rankItemLua.rankImg:SetActive(false)
	else
		rankItemLua.rankImg.image.sprite = rankItemLua.rankImg.switchSprite:GetSprite("icon_medal_"..rankData.rank)
		rankItemLua.rank:SetActive(false)
		rankItemLua.rankImg:SetActive(true)
		rankItemLua.rankImg.image:SetNativeSize()
	end
	
	local briefInfo = rankData.briefInfo

	rankItemLua.playerName:SetActive(briefInfo ~= nil)
	rankItemLua.headItem:SetActive(briefInfo ~= nil)
	rankItemLua.blockNum:SetActive(briefInfo ~= nil)
	rankItemLua.serverName:SetActive(briefInfo ~= nil)
	rankItemLua.vipIcon:SetActive(briefInfo ~= nil)
	if briefInfo then
		rankItemLua.playerName.text.text = briefInfo.nickName
		rankItemLua.headItem.levelText.text.text = tostring(briefInfo.level)

		local _jobIcon = nil;
		local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(briefInfo.configId)
		if jobCfg ~= nil then
			_jobIcon = jobCfg.JobIcon;
		end

		local _fakerData = {Level = briefInfo.level, ProfessionIcon = _jobIcon, HeadIcon = briefInfo.playerHead, IsHero = true};
		CommonUtil.SetPlayerHeadAndFrame(self, rankItemLua.headItem, _fakerData,false, briefInfo.headFrame , self, self.OnClickPlayerHead,briefInfo.uid);

		rankItemLua.blockNum.text.text = rankData.score
		rankItemLua.serverName.text.text = I18N.SetLanguageValue("TopTowerServer", briefInfo.selectZone)

		rankItemLua.vipIcon.image.enabled = false
		rankItemLua.vipIcon.image.sprite = nil
		local vipLv = rankData.vipLv
		if vipLv and vipLv >= 0 then
			local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
			if vipCfg then
				CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
					if sprite then
						rankItemLua.vipIcon.image.sprite = sprite
						rankItemLua.vipIcon.image.enabled = true
					end
				end, rankItemLua, 'VipIcon')
			end
		end
	end
end

function UIClimbingTowerRankView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
end

function UIClimbingTowerRankView:OnClickSelfHead()
	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("ChatError1"))
end

function UIClimbingTowerRankView:OnClickPlayerHead(btn,param)
	local type = self.controller:GetCurTowerType()
	local uid = param[0]
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid, type == Enum.UnlimitTowerType.PeakTower)
end


return UIClimbingTowerRankView

