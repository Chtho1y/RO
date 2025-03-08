local UIBattleReplayView = require("UIBattle/UIBattleReplayView_Generate")

function UIBattleReplayView:OnAwake(data)
	self.controller = require("UIBattle/UIBattleReplayCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIBattleReplayView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Fetch_BattleRecord_Success,self,self.OnFetchBattleRecordOk);
end

function UIBattleReplayView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIBattleReplayView:Init()
	self:InitPassedPlayerNode(self.LatestNode,self.controller:LatestData())
	self:InitPassedPlayerNode(self.LowestNode,self.controller:LowestData())
end

function UIBattleReplayView:InitPassedPlayerNode(node,playerData)
	if playerData == nil then
		node:SetActive(false)
		return
	end

	node.costTime.text.text = "通关用时：" .. playerData.battle_time .. "s"
	if playerData.record_time~= nil then
		node.passedDateTime.text.text = DateTimeUtil.convertTime2Str(playerData.record_time,"yyyy-MM-dd")
	else
		node.passedDateTime.text.text = ""
	end

	node.playerName.text.text = CommonUtil.GetVaildNickName(playerData.nick_name)
	node.fightPower.text.text = tostring(playerData.fight_power)
	node.headItem.levelText.text.text = tostring(playerData.level)

	node.headItem.headFrame.gameObject:SetActive(false);
	local _headFrameData = CommonUtil.GetHeadFrameDataById(playerData.head_frame_id);
	local _headFrame = GlobalConfig.Instance:GetConfigStrValue(211);
	if _headFrameData then _headFrame = _headFrameData.HeadFrameIcon; end
	CommonUtil.LoadIcon(self, _headFrame, function (sprite)
		node.headItem.frame.image.sprite = sprite
	end)

	local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(playerData.config_id)
	if jobCfg ~= nil then
		CommonUtil.LoadIcon(self, jobCfg.JobIcon, function (sprite)
			node.headItem.jobIcon.image.sprite = sprite
				end)
	end

	local head = CommonUtil.GetPlayerHeadIcon(playerData)
	if head ~= nil and head ~= "" then
		CommonUtil.LoadIcon(self, head, function (sprite)
			node.headItem.head.image.sprite = sprite
			end)
	else
		node.headItem.head.image.sprite = nil
	end


	local frameUrl = GlobalConfig.Instance:GetConfigStrValue(179)
	CommonUtil.LoadIcon(self, frameUrl, function (sprite)
		node.headItem.headFrame.image.sprite = sprite
	end)

    self.uiBase:AddButtonUniqueEventListener(node.replayBtn.button,self, self.OnClickReplay,playerData.battle_record_id,playerData.battle_time,playerData.fight_power,playerData.nick_name)
	self.uiBase:AddButtonUniqueEventListener(node.headItem.head.button,self, self.OnClickViewPlayer,playerData.uid)
	node:SetActive(true)
end

function UIBattleReplayView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIBattleReplayView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.btnClose.button,self, self.OnClickClose)
end

function UIBattleReplayView:OnHide()

end

function UIBattleReplayView:OnShow(data)
	self.controller:SetData(data)

end

function UIBattleReplayView:OnClose()
end

function UIBattleReplayView:OnDispose()
	self.controller:OnDispose()
end

function UIBattleReplayView:OnClickClose()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIBattleReplay)
end

function UIBattleReplayView:OnClickReplay(btn,params)
	local battleRecordUid = params[0]
	local battleTime = params[1]
	local fightPower = params[2]
	local nickName = params[3]
	self.curReqBattleRecordId = battleRecordUid
	self.curnickName = nickName
	ManagerContainer.LuaBattleMgr:SendBattleDetailReq(battleRecordUid,battleTime,fightPower)
end

function UIBattleReplayView:OnClickViewPlayer(btn,params)
	local uid = params[0]
	if uid ~= nil and uid  > 0 then
		ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
	end
end

function UIBattleReplayView:OnFetchBattleRecordOk(battleRecordUid,battleRecordStr)
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIBattleReplay)
	if battleRecordUid == self.curReqBattleRecordId then
		function LoadRecord()
			local strHeroName = CommonUtil.GetVaildNickName(self.curnickName)
			LuaBattleBridge.ClickReplayBattle(battleRecordStr)	
			LuaBattleBridge.SetReplayHeroActorName(strHeroName)	
		end
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UILoading,{loadingId = 3, FucOpenFinishedcb = LoadRecord })
	end
end

return UIBattleReplayView

