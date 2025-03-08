local UIExpiditionHelpLogView = require("UIExpedition/UIExpiditionHelpLogView_Generate")

function UIExpiditionHelpLogView:OnAwake(data)
	self.controller = require("UIExpedition/UIExpiditionHelpLogCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIExpiditionHelpLogView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Expedition_REFRESH_HELP_LOG,self,self.ShowLogList)
end

function UIExpiditionHelpLogView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIExpiditionHelpLogView:Init()
	self.lastReqTime = 0
	self.logScrollList.loopVerticalScrollRect:SetDragLuaCallback(self.OnDragScrollView)
	self:ShowLogList()
	self:OnDragScrollView()
end

function UIExpiditionHelpLogView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIExpiditionHelpLogView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self, self.OnClickClose)
end

function UIExpiditionHelpLogView:OnHide()

end

function UIExpiditionHelpLogView:OnShow(data)
	self.controller:SetData(data)

end

function UIExpiditionHelpLogView:OnClose()
	self.logScrollList.loopVerticalScrollRect:ClearCells()
end

function UIExpiditionHelpLogView:OnDispose()
	self.controller:OnDispose()
end

function UIExpiditionHelpLogView:OnClickClose()
	self:UIClose()
end

function UIExpiditionHelpLogView:ShowLogList()
	local leftRescuedNum = ManagerContainer.DataMgr.ExpeditionDataMgr.maxRescuedNum - ManagerContainer.DataMgr.ExpeditionDataMgr.usedRescuedNum
	local leftAssistNum = ManagerContainer.DataMgr.ExpeditionDataMgr.maxAssistNum - ManagerContainer.DataMgr.ExpeditionDataMgr.usedAssistNum
	self.leftRescuedNumTxt.text.text = tostring(leftRescuedNum)
	self.leftAssistNumTxt.text.text = tostring(leftAssistNum)

	local logList = ManagerContainer.DataMgr.ExpeditionDataMgr:GetRescuers()
	if logList ~= nil and #logList > 0 then
		self.emptyNode:SetActive(false)
		CommonUtil.LoopGridViewEleCreateNew(self,
			self.logScrollList.loopVerticalScrollRect,
			self.logScrollList.content.verticalLayoutGroup,
			logList,
			0,
			self, self.SetLogData);
	else
		self.emptyNode:SetActive(true)
		self.logScrollList.loopVerticalScrollRect:ClearCells()
	end
end

function UIExpiditionHelpLogView:SetLogData(node,idx,friendData)
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
	node.timeTxt.text.text = DateTimeUtil.convertTime2Str(friendData.param,"yyyy-MM-dd")
end

function UIExpiditionHelpLogView:OnClickPlayerHead(btn,params)
	local uid = params[0]
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

function UIExpiditionHelpLogView:OnDragScrollView()
	local leftCnt = ManagerContainer.DataMgr.ExpeditionDataMgr:GetRescuerCnt()
	if leftCnt > 0 then
		local curTime = Time.realtimeSinceStartup
		if (curTime - self.lastReqTime) >= 0.1 then
			ManagerContainer.DataMgr.ExpeditionDataMgr:ReqestRescuerBriefData()
			self.lastReqTime = curTime
		end
	end
end

return UIExpiditionHelpLogView

