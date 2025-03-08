local UIActivityFortnightTaskView = require("UIActivity/UIActivityFortnightTaskView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

function UIActivityFortnightTaskView:OnAwake(data)
	self.controller = require("UIActivity/UIActivityFortnightTaskCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIActivityFortnightTaskView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_Data_Change,self,self.OnRefreshActivity);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_Day_Change,self,self.OnNewDayRefresh);
end

function UIActivityFortnightTaskView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIActivityFortnightTaskView:Init()
	self.controller:InitActivityData(self.uiData.id)
	self.boxRewardLuaList = {}
	self.boxRewardGoList = {}

	self.startBoxPosX = self.templateBox.rectTransform.anchoredPosition3D.x
	self.boxPosY = self.templateBox.rectTransform.anchoredPosition3D.y
	self.boxTotalWidth = self.totalScore.progressNode.rectTransform.sizeDelta.x
	self.srvDay = 0
	self.curShowDay = 0
	self.curShowSubType = 0

	self.templateBox:SetActive(false)
	self:InitUIComs()
	--self:RefreshToggleData()
	--self:RefreshRedPoint()

	local activityItem = self.controller:GetActivityData()
	if activityItem  == nil then
		return
	end

	self.srvDay = activityItem.curDay
	local initPageId = self.srvDay <= 7 and 1 or 2
	self:RefreshInfos(initPageId)
end

function UIActivityFortnightTaskView:RefreshInfos(pageId)
	local activityItem = self.controller:GetActivityData()
	if activityItem  == nil then
		return
	end

	self.srvDay = activityItem.curDay
	self.pageId = pageId
	if pageId == 1 then
		self.curShowDay = self.srvDay <= 7 and self.srvDay or 1
	elseif pageId == 2 then
		self.curShowDay = self.srvDay <= 7 and 8 or self.srvDay
	end

	self:RefreshToggleData()
	self:RefreshRedPoint()
	self:RefreshOtherPageRedPoint()

	self.left:SetActive(pageId == 2 and self.srvDay > 7)
	self.right:SetActive(pageId == 1 and self.srvDay > 7)
end

function UIActivityFortnightTaskView:OnRefreshActivity(activityId)
	local actItem = self.controller:GetActivityData()
	if actItem == nil or actItem.actId ~= activityId then
		return
	end

	self:RefreshActData(self.curShowDay,self.curShowSubType)
	self:RefreshBoxRewardData(actItem:GetBoxRewards(self.pageId))
	self:RefreshScore(actItem.taskScore,actItem.totalTaskScore)
	self:RefreshRedPoint()
end

function UIActivityFortnightTaskView:OnNewDayRefresh(activityId)
	local actItem = self.controller:GetActivityData()
	if actItem == nil or actItem.actId ~= activityId then
		return
	end

	self.srvDay = actItem.curDay
	self.pageId = self.srvDay <= 7 and 1 or 2
	if self.pageId == 1 then
		self.curShowDay = self.srvDay <= 7 and self.srvDay or 1
	elseif self.pageId == 2 then
		self.curShowDay = self.srvDay <= 7 and 8 or self.srvDay
	end
	self:RefreshToggleData()

	self.left:SetActive(self.pageId == 2 and self.srvDay > 7)
	self.right:SetActive(self.pageId == 1 and self.srvDay > 7)
end

function UIActivityFortnightTaskView:InitUIComs()
	self.toggles = {}
	self.toggles[#self.toggles+1] = self.toggle1
	self.toggles[#self.toggles+1] = self.toggle2
	self.toggles[#self.toggles+1] = self.toggle3
	self.toggles[#self.toggles+1] = self.toggle4
	self.toggles[#self.toggles+1] = self.toggle5
	self.toggles[#self.toggles+1] = self.toggle6
	self.toggles[#self.toggles+1] = self.toggle7
	for i = 1, #self.toggles do
		self.toggles[i].toggle.isOn = false
	end
end

function UIActivityFortnightTaskView:RefreshToggleData()
	local activityItem = self.controller:GetActivityData()
	if activityItem  == nil then
		return
	end
	--
	--self.srvDay = activityItem.curDay
	--self.curShowDay  = self.srvDay
	self.curShowSubType = 1
	local startDay = 0 
	if self.pageId == 2 then
		startDay = 7
	end
	self.title.text.text = string.formatbykey("FortnightTaskTitle", (startDay+7))
	local bg = self.controller:GetBg()
	if bg ~= nil then
		local pageBg = bg .. "_" .. (startDay+7)
		CommonUtil.LoadIcon(self, pageBg, function (sprite)
			self.bg.image.sprite = sprite
		end,self, 'FortnightTaskBGIdx')
	end	

	for i = 1, 7 do
		local tog = self.toggles[i]
		local day = startDay + i
		tog.dayTxt.text.text = tostring(day)
		tog.lock:SetActive(day > self.srvDay)
		if day <= self.srvDay then
			tog.toggle.interactable = true
			tog.lock.lockBtn.button.interactable = false
			self.uiBase:AddToggleUniqueEventListener(tog.toggle,self, self.OnDayToggleClick,day)
		else
			tog.toggle.interactable = false
			tog.lock.lockBtn.button.interactable = true
			self.uiBase:AddButtonUniqueEventListener(tog.lock.lockBtn.button,self, self.OnClickLockDay,day)
		end

		if day == self.curShowDay then
			tog.toggle.isOn = true
			self.growthTaskToggle.toggle.isOn = true
			self:RefreshActData(self.curShowDay,self.curShowSubType)
		end
	end

	self:RefreshBoxRewardData(activityItem:GetBoxRewards(self.pageId))
	self:RefreshScore(activityItem.taskScore,activityItem.totalTaskScore)

	self:ClearLeftTimeTimer()
	self.updateLeftTimeTimer = ManagerContainer.LuaTimerMgr:AddTimer(60000, -1,self,self.UpdateLeftTime,nil);
end

function UIActivityFortnightTaskView:RefreshRedPoint()
	local activityItem = self.controller:GetActivityData()
	local startDay = 0 
	if self.pageId == 2 then
		startDay = 7
	end

	for i = 1, #self.toggles do
		self.toggles[i].redpoint:SetActive(false)
	end

	for i = 1, 7 do
		local tog = self.toggles[i]
		local day = startDay + i
		if day <= self.srvDay then
			local gRedPoint,dRedPoint = activityItem:HasDayRedPoint(day)
			tog.redpoint:SetActive(gRedPoint or dRedPoint)
			if self.curShowDay == day then
				self.growthTaskToggle.redpoint:SetActive(gRedPoint)
				self.dailyTaskToggle.redpoint:SetActive(dRedPoint)
			end
		end
	end
end

function UIActivityFortnightTaskView:RefreshOtherPageRedPoint()
	local activityItem = self.controller:GetActivityData()

	local startDay = 0
	if self.pageId == 1 then
		startDay = 7
	end

	local state = false
	for i = 1, 7 do
		local day = startDay + i
		if day <= self.srvDay then
			local gRedPoint,dRedPoint = activityItem:HasDayRedPoint(day)
			if gRedPoint or dRedPoint then
				state = true
				break
			end
		end
	end

	if self.pageId == 1 then
		self.right.uIRedPointRP:SetActive(state)
	else
		self.left.uIRedPointRP:SetActive(state)
	end
end

function UIActivityFortnightTaskView:RefreshScore(score,totalScore)
	self.totalScore.item.num.text.text = tostring(score)
	if totalScore > 0 then
		self.totalScore.progressNode.scrollbar.size = score/totalScore
	else
		self.totalScore.progressNode.scrollbar.size = 0
	end
end

function UIActivityFortnightTaskView:RefreshBoxRewardData(boxRewards)
	if boxRewards == nil or #boxRewards == 0 then
		self.totalScore.progressNode.scrollbar.size = 0
		return
	end

	local boxCnt = #boxRewards
	local deltaX = self.boxTotalWidth / boxCnt
	for i = 1,boxCnt do
		local posX = self.startBoxPosX + i * deltaX 
		local boxLua = self:GetBoxRewardLua(i,posX)
		self:SetBoxReward(boxLua,boxRewards[i])
	end
end

function UIActivityFortnightTaskView:SetBoxReward(boxLua,boxData)
	boxLua.num.text.text = tostring(boxData.score)
	if boxData:IsGotReward() then
		boxLua.box.animator:Play("BoxOpened")
		self.uiBase:AddButtonUniqueEventListener(boxLua.box.button,self, self.OnClickShowRewardBoxTips, boxData)
	elseif boxData:IsCanGet() then
		boxLua.box.animator:Play("BoxGlow")
		self.uiBase:AddButtonUniqueEventListener(boxLua.box.button,self, self.OnClickRewardBox, boxData)
	else
		boxLua.box.animator:Play("BoxClose")
		self.uiBase:AddButtonUniqueEventListener(boxLua.box.button,self, self.OnClickShowRewardBoxTips, boxData)
	end
end

function UIActivityFortnightTaskView:OnClickRewardBox(btn,param)
	local boxData = param[0]
	ManagerContainer.DataMgr.ActsDataMgr:SendGetBoxRewardReq(self.controller:GetActivityData().actId,boxData.boxId)
end

function UIActivityFortnightTaskView:OnClickShowRewardBoxTips(btn,param)
	local boxData = param[0]
	ManagerContainer.LuaUIMgr:ShowMinRewardTips(boxData:ShowRewards())
end

function UIActivityFortnightTaskView:GetBoxRewardLua(idx,posX)
	if idx <= #self.boxRewardLuaList then
		return self.boxRewardLuaList[idx]
	end

	
	local boxGo = UnityEngine.GameObject.Instantiate(self.templateBox.gameObject)
	self.boxRewardGoList[#self.boxRewardGoList+1] = boxGo
	local boxRewardLua = CommonUtil.BindGridViewItem2Lua(self, "RewardBox", boxGo)
	boxRewardLua.prefabName = "RewardBox"
	
	boxGo.name = "RewardBoxItem"
	boxRewardLua.transform:SetParent(self.totalScore.transform)
	boxRewardLua.transform.localScale = Vector3(1,1,1)
	boxRewardLua.rectTransform.anchoredPosition3D = Vector3(posX,self.boxPosY,0)
	boxRewardLua:SetActive(true)
	self.boxRewardLuaList[#self.boxRewardLuaList+1] = boxRewardLua
	return boxRewardLua
end

function UIActivityFortnightTaskView:OnClickLockDay(btn,param)
	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("DailyTaskCannotBeViewed")
end

function UIActivityFortnightTaskView:OnDayToggleClick(toggle, param)
	if toggle.isOn then
		self.curShowDay = param[0]
		self.curShowSubType = 1
		self.growthTaskToggle.toggle.isOn = true
		self:RefreshActData(self.curShowDay,self.curShowSubType)
	end
end

--subType:1表示成长任务， 2表示今日任务
function UIActivityFortnightTaskView:OnClickToggle(toggle,subType)
	if toggle.isOn then
		if self.curShowSubType ~= subType then
			if subType == 2 then
				local activityItem = self.controller:GetActivityData()
				local gRedPoint,dRedPoint = activityItem:HasDayRedPoint(self.curShowDay)
				local lockState = not dRedPoint and self.curShowDay < self.srvDay
				if lockState then
					self.growthTaskToggle.toggle.isOn = true
					ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ActivitiesTaskFinish")
					return
				end
			end

			self.curShowSubType = subType
			self:RefreshActData(self.curShowDay,self.curShowSubType)
		end
	end
end

--flag:1 表示成长任务，2：表示今日任务
function UIActivityFortnightTaskView:RefreshActData(day,flag)
	local activityItem = self.controller:GetActivityData()
	local taskInfo = activityItem:GetTaskListByDay(day)
	if taskInfo == nil then
		return
	end

	local gRedPoint,dRedPoint = activityItem:HasDayRedPoint(day)
	self.growthTaskToggle.redpoint:SetActive(gRedPoint)
	self.dailyTaskToggle.redpoint:SetActive(dRedPoint)

	local lockState = not dRedPoint and day < self.srvDay
	CommonUtil.SetTotalChildrenGray(self.dailyTaskToggle, lockState)
	if lockState and flag == 2 then
		self.growthTaskToggle.toggle.isOn = true
		return
	end

	local taskList = nil
	if flag == 1 then
		taskList = taskInfo.gTasks
	elseif flag == 2 then 
		taskList = taskInfo.dTasks
		self:RefreshLeftTime(activityItem:GetLeftTime())
	end

	self.leftTimeNode:SetActive(flag == 2 and day == self.srvDay)
	self.taskListScroll.loopVerticalScrollRect:ClearCells()
	if taskList ~= nil and #taskList > 0 then
		CommonUtil.LoopGridViewEleCreateNew(self,
			self.taskListScroll.loopVerticalScrollRect,
			self.taskListScroll.content.verticalLayoutGroup,
			taskList,
			0,
			self, self.SetTaskItem);
			self.taskListScroll.loopVerticalScrollRect:MoveTo(0)
	else
		self.taskListScroll.loopVerticalScrollRect:ClearCells()
	end
end

function UIActivityFortnightTaskView:RefreshLeftTime(leftTime)
	local day,hour,minute,second = ConvertTimeForm(leftTime)
	local timeStr = ""
	if hour > 0 then
		timeStr = hour .. "时" .. minute .. "分"
	else
		if minute == 0 then
			minute = 1
		end
		timeStr = minute .. "分"
	end

	self.leftTimeNode.leftTimeTxt.text.text = string.formatbykey("DailyTaskLeftTime",timeStr)
end

function UIActivityFortnightTaskView:SetTaskItem(taskLua,idx,taskData)
	taskLua.taskName.text.text = taskData.name
	taskLua.progress.scrollbar.size = taskData.doNum / taskData.finishedNum
	taskLua.doNumTxt.text.text = taskData.doNum  .. "/" .. taskData.finishedNum
	self:ShowTaskReward(taskLua,taskData:ShowRewards())
	self.uiBase:AddButtonUniqueEventListener(taskLua.gotoBtn.button,self, self.OnClickTaskGoto, taskData)
	self.uiBase:AddButtonUniqueEventListener(taskLua.getBtn.button,self, self.OnClickTaskGet, taskData.taskId)

	if taskData:IsOutofDate() then
		if not taskData:IsFinished() then
			taskLua.gotoBtn:SetActive(false)
			taskLua.getBtn:SetActive(false)
			taskLua.sealBtn:SetActive(false)
			taskLua.endBtn:SetActive(true)
		elseif not taskData:IsGotReward() then 
			taskLua.gotoBtn:SetActive(false)
			taskLua.getBtn:SetActive(true)
			taskLua.sealBtn:SetActive(false)
			taskLua.endBtn:SetActive(false)
		else
			taskLua.gotoBtn:SetActive(false)
			taskLua.getBtn:SetActive(false)
			taskLua.sealBtn:SetActive(true)
			taskLua.endBtn:SetActive(false)
		end
	else
		if not taskData:IsFinished() then
			taskLua.gotoBtn:SetActive(true)
			taskLua.getBtn:SetActive(false)
			taskLua.sealBtn:SetActive(false)
			taskLua.endBtn:SetActive(false)
		elseif not taskData:IsGotReward() then 
			taskLua.gotoBtn:SetActive(false)
			taskLua.getBtn:SetActive(true)
			taskLua.sealBtn:SetActive(false)
			taskLua.endBtn:SetActive(false)
		else
			taskLua.gotoBtn:SetActive(false)
			taskLua.getBtn:SetActive(false)
			taskLua.sealBtn:SetActive(true)
			taskLua.endBtn:SetActive(false)
		end
	end
end

function UIActivityFortnightTaskView:ShowTaskReward(taskLua,rewards)
	if taskLua.itemList == nil then
		taskLua.itemList = {}
		taskLua.itemList[#taskLua.itemList+1] = taskLua.iconItem
	end

	for i = 1, #taskLua.itemList do
		taskLua.itemList[i]:SetActive(false)
	end

	if rewards == nil then
		return
	end

	for i = 1, #rewards do
		local itemLua = taskLua.itemList[i]
		if itemLua == nil then
			local itemGo = UnityEngine.GameObject.Instantiate(taskLua.iconItem.gameObject)
			itemLua = CommonUtil.BindGridViewItem2Lua(self, "IconItem", itemGo)
			itemLua.prefabName = "IconItem"
			
			itemGo.name = "IconItem"
			itemLua.transform:SetParent(taskLua.rewardsNode.transform)
			itemLua.transform.localScale = Vector3(1,1,1)
			itemLua.rectTransform.anchoredPosition3D = Vector3(0,0,0)
			taskLua.itemList[#taskLua.itemList+1] = itemLua
		end

		local rewardData = {cfgId = rewards[i][1], num = rewards[i][2] }
		IconItemCtr:SetData(self, itemLua, rewardData, nil, self, self.OnClickItem)
		itemLua:SetActive(true)
	end
end

function UIActivityFortnightTaskView:OnClickItem(btn,params)
	local logicData = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(logicData)
end

function UIActivityFortnightTaskView:OnClickTaskGoto(btn,param)
	local taskData = param[0]
	local parentPageId = 0
	if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIMainCity1) then
		parentPageId = Enum.UIPageName.UIMainCity1
	elseif ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIBattle) then
		parentPageId = Enum.UIPageName.UIBattle
	end

	if taskData:CanJump() then
		if taskData.gotoPageId > 0 then
			if taskData.gotoPageId == Enum.UIPageName.UIDojo2D then
				ManagerContainer.DataMgr.ArenaData:SendArenaDataReq(Enum.UIPageName.UIDojo2D, parentPageId)
			else
				ManagerContainer.LuaUIMgr:Open(taskData.gotoPageId,nil,parentPageId)
			end

			local uiData = ManagerContainer.CfgMgr:GetUIData(taskData.gotoPageId)
			if uiData.type == 0 then
				ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, uiData.mainViewType)
			end
			self:UIClose()
		end
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("DailyTaskText")
	end
end

function UIActivityFortnightTaskView:OnClickTaskGet(btn,param)
	local taskId = param[0]
	ManagerContainer.DataMgr.ActsDataMgr:SendGetActivityRewardReq(self.controller:GetActivityData().actId,taskId)
end

function UIActivityFortnightTaskView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIActivityFortnightTaskView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.backBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddToggleEventListener(self.growthTaskToggle.toggle,self, self.OnClickToggle, 1)
	self.uiBase:AddToggleEventListener(self.dailyTaskToggle.toggle,self, self.OnClickToggle, 2)
	self.uiBase:AddButtonEventListener(self.left.button,self, self.OnLeftClick)
	self.uiBase:AddButtonEventListener(self.right.button,self, self.OnRightClick)
end

function UIActivityFortnightTaskView:OnHide()

end

function UIActivityFortnightTaskView:OnShow(data)
	self.controller:SetData(data)

end

function UIActivityFortnightTaskView:OnClose()
	self:ClearLeftTimeTimer()
	self:DestroyGoes()
	CommonUtil.ClearGridViewItem(self, "RewardBox")
	self.boxRewardLuaList = nil
	self.taskListScroll.loopVerticalScrollRect:DestroyCells()
end

function UIActivityFortnightTaskView:OnDispose()
	self.controller:OnDispose()
end

function UIActivityFortnightTaskView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
	if self.uiBase.MSourceUIID > 0 then
        ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID)
    end
end

function UIActivityFortnightTaskView:OnLeftClick()
	self:RefreshInfos(1)
end

function UIActivityFortnightTaskView:OnRightClick()
	self:RefreshInfos(2)
end

function UIActivityFortnightTaskView:DestroyGoes()
	if self.boxRewardGoList ~= nil then
		for i = 1, #self.boxRewardGoList do
			CommonUtil.DestroyGO(self.boxRewardGoList[i])
		end
	end

	self.boxRewardGoList = nil
end

function UIActivityFortnightTaskView:ClearLeftTimeTimer()
	if self.updateLeftTimeTimer~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.updateLeftTimeTimer)
        self.updateLeftTimeTimer = nil
    end
end

function UIActivityFortnightTaskView:UpdateLeftTime()
	local activityItem = self.controller:GetActivityData()
	self:RefreshLeftTime(activityItem:GetLeftTime())
	if activityItem:GetLeftTime() == 0 then
		self:ClearLeftTimeTimer()
	end
end

return UIActivityFortnightTaskView

