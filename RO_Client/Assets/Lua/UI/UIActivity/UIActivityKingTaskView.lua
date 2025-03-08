local UIActivityKingTaskView = require("UIActivity/UIActivityKingTaskView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

function UIActivityKingTaskView:OnAwake(data)
	self.controller = require("UIActivity/UIActivityKingTaskCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIActivityKingTaskView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_Data_Change,self,self.ActivityRefresh);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_Day_Change,self,self.RefreshShow)
end

function UIActivityKingTaskView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIActivityKingTaskView:Init()
	local data = self.controller:GetData()
	CommonUtil.LoadIcon(self, data.pageBg, function (sprite)
		self.bg.image.sprite = sprite
	end)
	self.pageToggleData = {}
	self.controller:InitData()
	self:InitGrid()
end

function UIActivityKingTaskView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.isActiveToggle1 = self:GetIsActiveToggle1()
	self.isActiveToggle2 = self:GetIsActiveToggle2()
	self.growthTaskToggle:SetActive(not self.isActiveToggle1)
	self.dailyTaskToggle.label.text.text = self.isActiveToggle1 and I18N.SetLanguageValue("BtnPaymentToday") or I18N.SetLanguageValue("BtnActivityToday")
	self.dailyTaskToggle:SetActive(not self.isActiveToggle2)
	self.leftTimeNode.icon:SetActive(not self.isActiveToggle1)
	local index = self.isActiveToggle1 and 2 or 1  
	CommonUtil.CreateToggleMouduleOnlyBtns(self, self.pageToggleData, self.toggleGroup, index, self.OnValueChangedToggle, self, true)
	self:InitUpdate()
	self:RefreshRemainTime()
	self:RefreshToggleRP()
end

function UIActivityKingTaskView:RefreshToggleRP()
	self.growthTaskToggle.redpoint:SetActive(self.controller:HasGrowTaskRP())
	self.dailyTaskToggle.redpoint:SetActive(self.controller:HasDayTaskRP())
end

function UIActivityKingTaskView:GetIsActiveToggle1()
	local actId = self.controller:GetActivityActId()
	local cfgdata = GlobalConfig.Instance:GetConfigStrValue(330)
	local actIdList  =  CommonUtil.DeserializeGlobalStrToNumberTable(cfgdata)
	for i = 1, #actIdList do
		if actId == actIdList[i] then
			return true
		end
	end
	return false
end

function UIActivityKingTaskView:GetIsActiveToggle2()
	local actId = self.controller:GetActivityActId()
	local cfgdata = GlobalConfig.Instance:GetConfigStrValue(341)
	local actIdList  =  CommonUtil.DeserializeGlobalStrToNumberTable(cfgdata)
	for i = 1, #actIdList do
		if actId == actIdList[i] then
			return true
		end
	end
	return false
end


function UIActivityKingTaskView:InitUpdate()
	if not self.updateTimer then
		self.updateTimer = Timer.New(slot(self.RefreshRemainTime, self), 60, -1)
		if not self.updateTimer.running then
			self.updateTimer:Start()
		end
	end
end

function UIActivityKingTaskView:ConvertTime(time)
	local day,hour,minute,second = ConvertTimeForm(time)
	local timeStr = ""
	if day > 0 then
		timeStr = day .. "天"..hour .. "时" .. minute .. "分"
	else
		if hour > 0 then
			timeStr = hour .. "时" .. minute .. "分"
		else
			if minute == 0 then
				minute = 1
			end
			timeStr = minute .. "分"
		end
	end
	return timeStr
end

function UIActivityKingTaskView:RefreshRemainTime()
	if not self.controller then
		return false
	end
	local leftTime = self.controller:GetRemainTime()
	if leftTime <= 0 then
		self.TimeTxt.text.text = "0"
		self:OnClickCloseBtn()
		return false
	end

	self.TimeTxt.text.text = self:ConvertTime(leftTime)
	self.leftTimeNode.leftTimeTxt.text.text = self.isActiveToggle1 and I18N.SetLanguageValue("BtnPaymentToday1") or self:ConvertTime(self.controller:GetDayRemainTime())

	return true
end

function UIActivityKingTaskView:InitGrid()
	self.taskListScroll.loopListView:InitListView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end
function UIActivityKingTaskView:ActivityRefresh(actid)
	if self.controller:GetActivityActId() == actid then
		self:RefreshShow()
	end
end

function UIActivityKingTaskView:RefreshShow()
	self:OnValueChangedToggle()
	self:RefreshToggleRP()
	self:RefreshRemainTime()
end

function UIActivityKingTaskView:OnValueChangedToggle()
	self.leftTimeNode:SetActive(self.pageToggleData.toggleDefaultIndex == 2)
	if self.pageToggleData.toggleDefaultIndex == 1 then
		local taskList = self.controller:GetTaskList()
		local length = taskList ~= nil and #taskList or 0

		self.taskListScroll.loopListView:SetListItemCount(length, true)
	elseif self.pageToggleData.toggleDefaultIndex == 2 then
		local dayTaskList = self.controller:GetDayTaskList()
		local length = dayTaskList ~= nil and #dayTaskList or 0
		self.taskListScroll.loopListView:SetListItemCount(length, true)

		self.leftTimeNode.leftTimeTxt.text.text = self.isActiveToggle1 and I18N.SetLanguageValue("BtnPaymentToday") or self:ConvertTime(self.controller:GetDayRemainTime())
	end

	self.taskListScroll.loopListView:RefreshAllShownItem()
end

function UIActivityKingTaskView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local taskData = self.pageToggleData.toggleDefaultIndex == 1
			and self.controller:GetTaskListDataByIdx(itemIndex + 1)
			or self.controller:GetDayTaskListDataByIdx(itemIndex + 1)
	if not taskData then
		return nil
	end
	local item = gridView:NewListViewItem('TaskItemActivity')
	local taskLua = CommonUtil.BindGridViewItem2Lua(self, 'TaskItemActivity', item.gameObject)
	--taskLua.num.text.text = itemIndex + 1

	taskLua.taskName.text.text = taskData.name
	taskLua.progress.scrollbar.size = taskData.progress and taskData.progress or (taskData.doNum / taskData.finishedNum)
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
	return item
end

function UIActivityKingTaskView:ShowTaskReward(taskLua,rewards)
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

function UIActivityKingTaskView:OnClickItem(btn,params)
	local logicData = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(logicData)
end

function UIActivityKingTaskView:OnClickTaskGoto(btn,param)
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

function UIActivityKingTaskView:OnClickTaskGet(btn,param)
	local taskId = param[0]
	ManagerContainer.DataMgr.ActsDataMgr:SendGetActivityRewardReq(self.controller:GetActivityData().actId,taskId)
end

function UIActivityKingTaskView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIActivityKingTaskView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.backBtn.button,self, self.OnClickCloseBtn)
end

function UIActivityKingTaskView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
	if self.uiBase.MSourceUIID > 0 then
		ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID)
	end
end

function UIActivityKingTaskView:OnHide()

end

function UIActivityKingTaskView:OnShow(data)
	self.controller:SetData(data)

end

function UIActivityKingTaskView:OnClose()
	self.taskListScroll.loopListView:Dispose()
	if self.updateTimer then
		self.updateTimer:Stop();
		self.updateTimer = nil
	end
end

function UIActivityKingTaskView:OnDispose()
	self.controller:OnDispose()
end

return UIActivityKingTaskView

