local UIDojoRankView = require("UIDojo/UIDojoRankView_Generate")

function UIDojoRankView:OnAwake(data)
	self.controller = require("UIDojo/UIDojoRankCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIDojoRankView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Arena_Season_Rank_List,self,self.OnRefreshRankData);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Arena_Season_End,self,self.OnSeasonOver);
end

function UIDojoRankView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
	self:SetToggleBtnStatus()
end

function UIDojoRankView:Init()
	self.frameUrl = GlobalConfig.Instance:GetConfigStrValue(179)

	self.curSeasonToggle.toggle.interactable = true
	self.lastSeasonToggle.toggle.interactable = true

	self.rankScroll.loopVerticalScrollRect:SetDragLuaCallback(self.OnDragScrollView)
end

function UIDojoRankView:OnDragScrollView()
	local curTime = Time.realtimeSinceStartup
	if (curTime - self.lastReqTime) >= 0.1 then
		self.controller:RequireRankData(self.curRankType)
		self.lastReqTime = curTime
	end
end

function UIDojoRankView:SetToggleBtnStatus()
	self.toggles = {}
	self.toggles[1] = self.curSeasonToggle;
	self.toggles[2] = self.lastSeasonToggle;
	self.curToggleIdx = 1
	self.toggles[self.curToggleIdx].toggle.isOn = true
	--self.toggles[self.curToggleIdx].toggle.interactable = false

	self:ShowRankList(0)
end

function UIDojoRankView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIDojoRankView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddToggleEventListener(self.curSeasonToggle.toggle,self,self.OnClickTab,1)
	self.uiBase:AddToggleEventListener(self.lastSeasonToggle.toggle,self,self.OnClickTab,2)
end

function UIDojoRankView:OnHide()

end

function UIDojoRankView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIDojoRankView:OnClose()

end

function UIDojoRankView:OnDispose()


	self.rankScroll.loopVerticalScrollRect:ClearCells()
end

function UIDojoRankView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
end

function UIDojoRankView:OnClickTab(selectedTog,toggleIdx, result)
	if self.curToggleIdx == toggleIdx then
		return
	 end

	 self.curToggleIdx = toggleIdx

	 for i =1, #self.toggles do
		if i ~= (toggleIdx) then
			self.toggles[i].toggle.isOn = false
			self.toggles[i].toggle.interactable = true
		end
	end

	 selectedTog.interactable = false
	 
	 if self.curToggleIdx == 2 then
		-- self:ShowRankList(1)
		ManagerContainer.DataMgr.ArenaData:SendArenaRankReq(1,1)
	 elseif self.curToggleIdx == 1 then
		-- self:ShowRankList(0)
		ManagerContainer.DataMgr.ArenaData:SendArenaRankReq(0,1)
	 end
end

function UIDojoRankView:OnSeasonOver()
	if self.curToggleIdx == 2 then
		-- self:ShowRankList(1)
		ManagerContainer.DataMgr.ArenaData:SendArenaRankReq(1,1)
	 elseif self.curToggleIdx == 1 then
		-- self:ShowRankList(0)
		ManagerContainer.DataMgr.ArenaData:SendArenaRankReq(0,1)
	 end
end

function UIDojoRankView:OnRefreshRankData(rankType)
	--[[
	if self.curRankType == rankType then
		return
	end]]--
	self:ShowRankList(rankType)
end

-- ranktype = 1, 上赛季， ranktype = 0 ,本赛季
function UIDojoRankView:ShowRankList(rankType)
	if self.curRankType ~= rankType then
		self.lastReqTime = 0;
		self.rankScroll.loopVerticalScrollRect:ClearCells();
		self.controller:ResetIndex();
	end
	--LogError("ShowRankList")
	self.curRankType = rankType
	self.rankList = ManagerContainer.DataMgr.ArenaData:GetSeasonRanList(self.curRankType)
	if self.rankList~= nil and #self.rankList >= 1 then
		self.rankContent:SetActive(true)
		self.emptyNode:SetActive(false)
		CommonUtil.LoopGridViewEleCreateNew(self,
				self.rankScroll.loopVerticalScrollRect,
				nil,
				self.rankList,
				0,
				self,
				self.OnUpdateRankData)
	else
		self.rankContent:SetActive(false)
		self.emptyNode:SetActive(true)
	end

	self:UpdateSelfRankData(rankType)
end

function UIDojoRankView:RefreshRankIcon(RandItem,Rank)
	RandItem.rank:SetActive(false)
	RandItem.madel01:SetActive(false)
	RandItem.madel02:SetActive(false)
	RandItem.madel03:SetActive(false)
	if Rank == 1 then
		RandItem.madel01:SetActive(true)
		RandItem.madel01.image:SetNativeSize()
	elseif Rank == 2 then
		RandItem.madel02:SetActive(true)
		RandItem.madel02.image:SetNativeSize()
	elseif Rank == 3 then
		RandItem.madel03:SetActive(true)
		RandItem.madel03.image:SetNativeSize()
	else
		RandItem.rank:SetActive(true)
		RandItem.rank.text.text = tostring(Rank)
	end
end

function UIDojoRankView:OnUpdateRankData(rankItemLua,idx,rankData)
	rankData = ManagerContainer.DataMgr.ArenaData:GetSeasonRanList(self.curRankType)[idx + 1]
	if rankItemLua == nil  or rankData == nil then
		return
	end
	--rankItemLua.rank.text.text = tostring(rankData.rank)
	self:RefreshRankIcon(rankItemLua,rankData.rank)

	rankItemLua.playerName.text.text = CommonUtil.GetVaildNickName(rankData.playerName)
	rankItemLua.fighterPower.text.text = rankData.score--rankData.playerFighterPower 修改为积分

	local _jobIcon = nil;
	local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(rankData.playerJobId)
	if jobCfg ~= nil then
		_jobIcon = jobCfg.JobIcon;
	end
--[[
	if rankData.playerHead ~= nil then
		CommonUtil.LoadIcon(self, rankData.playerHead, function (sprite)
				rankItemLua.headItem.head.image.sprite = sprite
				end)
	end

	CommonUtil.LoadIcon(self, self.frameUrl, function (sprite)
		rankItemLua.headItem.headFrame.image.sprite = sprite
	end)

	rankItemLua.headItem.levelText.text.text = tostring(rankData.playerLevel)
]]--
	rankItemLua.danName.text.text = rankData.danName

	if rankData.danIcon ~= nil and rankData.danIcon ~= "" then
		CommonUtil.LoadIcon(self, rankData.danIcon, function (sprite)
				rankItemLua.danIcon.image.sprite = sprite
			end)
	end

	local _fakerData = {Level = rankData.playerLevel, ProfessionIcon = _jobIcon, HeadIcon = rankData.playerHead, IsHero = true};
	CommonUtil.SetPlayerHeadAndFrame(self, rankItemLua.headItem, _fakerData,false, rankData.headFrameId, self, self.OnClickPlayerHead, rankData.playerId);

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
	self.uiBase:AddButtonUniqueEventListener(rankItemLua.viewBtn.button,self,self.OnClickPlayerHead,rankData.playerId)
end

function UIDojoRankView:UpdateSelfRankData(rankType)
	local arenaData = ManagerContainer.DataMgr.ArenaData
	local userData = ManagerContainer.DataMgr.UserData

	local rank = arenaData:GetRank(rankType)
	
	if rank == 0 then
		self.rank.text.text =  I18N.T("NoRank")
	else		
		self.rank.text.text = tostring(rank)		
	end
	self.playerName.text.text = userData:GetUserNickname()
	self.fighterPower.text.text =  arenaData:GetSelfSeasonScore(rankType)--userData:GetTotalFightPower() 修改为积分

	local _headIcon = ManagerContainer.DataMgr.UserData:GetUserHeadIcon()
	if self.frameUrl ~= nil then
		CommonUtil.LoadIcon(self, self.frameUrl, function (sprite)
			self.headItem.headFrame.image.sprite = sprite
		end)
	end
	--LogError("------UpdateSelfRankData--" )
	local danIcon,danName = arenaData:GetCurDanInfoByRank(rankType)
	self.danName.text.text = danName

	
	if danIcon ~= nil and danIcon ~= "" then
		CommonUtil.LoadIcon(self, danIcon, function (sprite,loadseqId,assetPath,assetName)
				local danIcon,danName = arenaData:GetCurDanInfoByRank(rankType)				
				if danIcon == assetName[1] then
					self.danIcon.image.sprite = sprite
				end
			end)
	end

	local _headFrameId = ManagerContainer.DataMgr.UserData:GetHeadFrameId();

	local _fakerData = {Level = userData:GetRoleLv(), ProfessionIcon = userData:GetJobIcon(), HeadIcon = _headIcon, IsHero = true};
	CommonUtil.SetPlayerHeadAndFrame(self, self.headItem, _fakerData,false, _headFrameId, self, self.OnClickSelfHead);

	self.vipIcon.image.enabled = false
	self.vipIcon.image.sprite = nil
	local vipLv = userData:GetVipLv()
	if vipLv and vipLv >= 0 then
		local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
		if vipCfg then
			CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
				if sprite then
					self.vipIcon.image.sprite = sprite
					self.vipIcon.image.enabled = true
				end
			end)
		end
	end

	--self.uiBase:AddButtonUniqueEventListener(self.headItem.head.button,self,self.OnClickSelfHead)
end

function UIDojoRankView:OnClickSelfHead()
	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("ChatError1"))
end

function UIDojoRankView:OnClickPlayerHead(btn,param)
	local uid = param[0]
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

return UIDojoRankView

