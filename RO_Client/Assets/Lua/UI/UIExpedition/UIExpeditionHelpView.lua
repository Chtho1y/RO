local UIExpeditionHelpView = require("UIExpedition/UIExpeditionHelpView_Generate")

function UIExpeditionHelpView:OnAwake(data)
	self.controller = require("UIExpedition/UIExpeditionHelpCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIExpeditionHelpView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.EID_Refresh_FriendData,self,self.OnRefreshData)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.EID_Expedition_RefreshData,self,self.RefreshLeftTimes)
end

function UIExpeditionHelpView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIExpeditionHelpView:Init()
	ManagerContainer.DataMgr.FriendDataMgr:SetExpedotopmHelpList(true)
	self.controller:InitFriendData()
	self.lastReqTime = 0
	self.friendScrollList.loopVerticalScrollRect:SetDragLuaCallback(self.OnDragScrollView)
	self:ShowFriendsData()
	if not self.controller:IsReqFinished()  then
		self:OnDragScrollView()
	end
	self:RefreshLeftTimes()
end

function UIExpeditionHelpView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIExpeditionHelpView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.guildHelpBtn.button, self, self.OnClickGuildHelp)
end

function UIExpeditionHelpView:OnHide()

end

function UIExpeditionHelpView:OnShow(data)
	self.controller:SetData(data)

end

function UIExpeditionHelpView:OnClose()
	self:ClearLeftTimeTimer()
	ManagerContainer.DataMgr.FriendDataMgr:SetExpedotopmHelpList(false)
	self.friendScrollList.loopVerticalScrollRect:SetDragLuaCallback(nil)
	self.friendScrollList.loopVerticalScrollRect:ClearCells()
end

function UIExpeditionHelpView:OnDispose()
	self.controller:OnDispose()
end

function UIExpeditionHelpView:OnClickClose()
	self:UIClose()
end

function UIExpeditionHelpView:OnRefreshData()
	--self.controller:RefreshFriendList()
	self:ShowFriendsData()
end

function UIExpeditionHelpView:OnDragScrollView()
	if not self.controller:IsReqFinished() then
		local curTime = Time.realtimeSinceStartup
		if (curTime - self.lastReqTime) >= 0.1 then
			self.controller:ReqestFriendBriefData()
			self.lastReqTime = curTime
		end
	end
end

function UIExpeditionHelpView:RefreshLeftTimes()
	local leftRescuedNum = ManagerContainer.DataMgr.ExpeditionDataMgr.maxRescuedNum - ManagerContainer.DataMgr.ExpeditionDataMgr.usedRescuedNum
	self.leftRescuedNumTxt.text.text = tostring(leftRescuedNum)

	local inGuild = ManagerContainer.DataMgr.GuildDataMgr:HasGuild()
	CommonUtil.NeedUIGray(self.guildImg.image,not inGuild)
	if inGuild then
		local leftTime = ManagerContainer.DataMgr.ExpeditionDataMgr.guildAssistingEndTime - ManagerContainer.LuaTimerMgr:GetTimeSecond()
		if leftTime > 0 then
			self.guildHelpBtn:SetActive(false)
			self.guildCDTxt:SetActive(true)
			self:ClearLeftTimeTimer()
			self.updateLeftTimeTimer = ManagerContainer.LuaTimerMgr:AddTimer(1000, leftTime,self,self.UpdateLeftTime,nil)
			self:UpdateLeftTime()
		else
			self.guildHelpBtn:SetActive(true)
			self.guildCDTxt:SetActive(false)
		end
	else
		self.guildHelpBtn:SetActive(false)
		self.guildCDTxt:SetActive(false)
	end
end

function UIExpeditionHelpView:ClearLeftTimeTimer()
	if self.updateLeftTimeTimer~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.updateLeftTimeTimer)
        self.updateLeftTimeTimer = nil
    end
end

function UIExpeditionHelpView:UpdateLeftTime()
	local leftTime = ManagerContainer.DataMgr.ExpeditionDataMgr.guildAssistingEndTime - ManagerContainer.LuaTimerMgr:GetTimeSecond()
	if leftTime < 1 then
		self:ClearLeftTimeTimer()
		self.guildHelpBtn:SetActive(true)
		self.guildCDTxt:SetActive(false)
	else
		local day,hour,minute,second = ConvertTimeForm(leftTime)
		local timeStr = ""
		if hour > 0 then
			timeStr = string.format("%02d时%02d分%02d秒", hour,minute, second)
		else
			if minute > 0 then
				timeStr = string.format("%02d分%02d秒", minute, second)
			else
				timeStr = string.format("%02d秒", second)
			end
		end	
		self.leftTime.text.text = timeStr
	end
end

function UIExpeditionHelpView:ShowFriendsData()
	if #self.controller:FriendList() > 0 then
		self.emptyNode:SetActive(false)
		local friendList = self.controller:FriendList()
		CommonUtil.LoopGridViewEleCreateNew(self,
			self.friendScrollList.loopVerticalScrollRect,
			self.friendScrollList.content.verticalLayoutGroup,
			friendList,
			0,
			self, self.SetFriendData);
	else
		self.friendScrollList.loopVerticalScrollRect:ClearCells()
		self.emptyNode:SetActive(true)
	end
end

function UIExpeditionHelpView:SetFriendData(node,idx,friendData)
	if node == nil or friendData == nil then
		return
	end

	local _jbIcon = nil;
	local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(friendData.job)
	if jobCfg ~= nil then
		_jbIcon = jobCfg.JobIcon;
	end

	local _headIcon = nil;
	if friendData.head ~= nil then
		_headIcon = friendData.head;
	end

	local _fakerData = {Level = friendData.level, ProfessionIcon = _jbIcon, HeadIcon = _headIcon, IsHero = true};
	CommonUtil.SetPlayerHeadAndFrame(self, node.headItem, _fakerData,false, friendData.headFrameId, self, self.OnClickPlayerHead, friendData.uid);

	node.playerName.text.text = friendData.name
	node.fightPower.text.text = tostring(friendData.fightPower)
	node.statusLbl.text.text = friendData:GetOnlineStatus()

	self.uiBase:AddButtonUniqueEventListener(node.helpBtn.button, self, self.OnClickPlayerHelp, friendData.uid)
end

function UIExpeditionHelpView:OnClickPlayerHelp(btn,params)
	local leftNum =  ManagerContainer.DataMgr.ExpeditionDataMgr.maxRescuedNum - ManagerContainer.DataMgr.ExpeditionDataMgr.usedRescuedNum
	if leftNum <= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ExpeditionSalvation")
		return
	end

	local uid = params[0]
	ManagerContainer.LuaUIMgr:ShowMessageBox("ExpeditionCallHelp",nil,uid,self,self.OnConfirmSendAssistReq,nil)
end

function UIExpeditionHelpView:OnClickPlayerHead(btn,params)
	local uid = params[0]
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

function UIExpeditionHelpView:OnClickGuildHelp()
	local leftNum =  ManagerContainer.DataMgr.ExpeditionDataMgr.maxRescuedNum - ManagerContainer.DataMgr.ExpeditionDataMgr.usedRescuedNum
	if leftNum <= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ExpeditionSalvation")
		return
	end

	ManagerContainer.LuaUIMgr:ShowMessageBox("ExpeditionCallHelp",nil,0,self,self.OnConfirmSendAssistReq,nil)
end

function UIExpeditionHelpView:OnConfirmSendAssistReq(reqId)
	ManagerContainer.DataMgr.ExpeditionDataMgr:SendAssistReq(reqId)
end

return UIExpeditionHelpView

