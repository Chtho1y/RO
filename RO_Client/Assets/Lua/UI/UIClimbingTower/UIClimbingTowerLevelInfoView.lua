local UIClimbingTowerLevelInfoView = require("UIClimbingTower/UIClimbingTowerLevelInfoView_Generate")

function UIClimbingTowerLevelInfoView:OnAwake(data)
	self.controller = require("UIClimbingTower/UIClimbingTowerLevelInfoCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIClimbingTowerLevelInfoView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Fetch_BattleRecord_Success,self,self.OnFetchBattleRecordOk);
end

function UIClimbingTowerLevelInfoView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIClimbingTowerLevelInfoView:Init()
	self.battleRecordUid = nil
	local levelInfo = self.controller:GetLevelInfo(self.controller:GetData())
	if levelInfo ~= nil then
		self:SetPlayerInfo(levelInfo:GetLowestPlayer())
		self:SetRewardInfo(levelInfo:GetRewards())
	end

	self.replayBtn:SetActive(self.battleRecordUid  ~= nil)
	self.infoNode:SetActive(self.battleRecordUid ~= nil)
end

function UIClimbingTowerLevelInfoView:SetPlayerInfo(playerData)
	if playerData == nil then
		self.playerNode:SetActive(false)
		self.nothingNode:SetActive(true)
	else
		self.battleRecordUid = playerData.battle_record_uid
		self.battleTime = playerData.battle_time
		self.fightPower = playerData.fightPower

		self.playerNode:SetActive(true)
		self.nothingNode:SetActive(false)

		local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(playerData.job)
		local _jobICon = nil;
		if jobCfg ~= nil then
			_jobICon = jobCfg.JobIcon;
		end
		local _headIcon = nil;
		if playerData.head ~= nil then
			_headIcon = playerData.head
		end

		local _fakerData = {Level = playerData.level, ProfessionIcon = _jobICon, HeadIcon = _headIcon, IsHero = true};
		CommonUtil.SetPlayerHeadAndFrame(self, self.playerNode.headItem, _fakerData,false, playerData.head_frame, self, self.OnClickPlayerHead,playerData.uid);

		self.playerNode.playerName.text.text = playerData.name
		self.PlayerName = playerData.name
		self.playerNode.fightPower.text.text = tostring(playerData.fightPower)

		if playerData.battle_time~= nil then
			self.costTime.text.text = playerData.battle_time .. "s"
		else
			self.costTime.text.text = ""
		end

		if playerData.record_time~= nil then
			self.passedDateTime.text.text = DateTimeUtil.convertTime2Str(playerData.record_time,"yyyy-MM-dd")
		else
			self.passedDateTime.text.text = ""
		end
		
		--self.uiBase:AddButtonUniqueEventListener(self.playerNode.headItem.head.button,self,self.OnClickPlayerHead,playerData.uid)
	end
end

function UIClimbingTowerLevelInfoView:SetRewardInfo(rewardData)
	if rewardData~= nil then
		CommonUtil.LoopGridViewEleCreateNew(self,
									self.ItemScrollView.loopVerticalScrollRect,
									self.ItemContent.gridLayoutGroup,rewardData,0,self,self.OnUpdateItemData)
	end
end

function UIClimbingTowerLevelInfoView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIClimbingTowerLevelInfoView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.CloseBtn.button,self,self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self,self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.replayBtn.button,self,self.OnClickReplayBtn)
end

function UIClimbingTowerLevelInfoView:OnHide()

end

function UIClimbingTowerLevelInfoView:OnShow(data)
	self.controller:SetData(data)

end

function UIClimbingTowerLevelInfoView:OnClose()
end

function UIClimbingTowerLevelInfoView:OnDispose()
	self.controller:OnDispose()
end

function UIClimbingTowerLevelInfoView:OnUpdateItemData(itemLua,idx,itemData)
	CommonUtil.SetRewardItemData(self,itemData[1],itemLua,itemData[2], self.OnClickItem)
end

function UIClimbingTowerLevelInfoView:OnClickClose()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIClimbingTowerLevelInfo)
end

function UIClimbingTowerLevelInfoView:OnClickPlayerHead(btn,param)
	local uid = param[0]
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

function UIClimbingTowerLevelInfoView:OnClickItem(btn,params)
	local logicData = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(logicData)
end


function UIClimbingTowerLevelInfoView:OnClickReplayBtn()
	if self.battleRecordUid == nil then
		return
	end
	
	ManagerContainer.LuaBattleMgr:SendBattleDetailReq(self.battleRecordUid,self.battleTime,self.fightPower)
end

function UIClimbingTowerLevelInfoView:OnFetchBattleRecordOk(battleRecordUid,battleRecordStr)
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIClimbingTowerLevelInfo)
	if battleRecordUid == self.battleRecordUid then	
		ManagerContainer.DataMgr.TowerDataMgr:ReplayBattle(self.controller:GetData(),battleRecordStr,self.PlayerName)
	end
end

return UIClimbingTowerLevelInfoView

