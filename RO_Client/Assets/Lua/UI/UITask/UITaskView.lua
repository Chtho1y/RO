local UITaskView = require("UITask/UITaskView_Generate")
local IconItemCtr = require("Common/IconItemCtr")
local TaskJumpCtr = require("Common/TaskJumpCtr")
local TaskItemMainCtr = require("Common/TaskItemMainCtr")
local TaskItemRefreshCtr = require("Common/TaskItemRefreshCtr")

function UITaskView:OnAwake(data)
	self.controller = require("UITask/UITaskCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UITaskView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_TASK_CHANGE, self, self.RefreshTask)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_CLOSE_TASK_PAGE, self, self.OnCloseClick)
end

function UITaskView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UITaskView:Init()
	self._timer = nil;
	self._actLevelMax = 5;	--活跃度的最高等级
	self.curOpenType = 0

	self._boxCount = 5;		--周常和日常任务的可领取的宝箱的个数

	if not self._box then
		self._box = {};
		local _boxOriginal = self.refreshTaskParent.totalScore.box1;
		_boxOriginal.gameObject:SetActive(false);
		local _boxOriginalPos = _boxOriginal.transform.localPosition;

		for _i = 1, self._boxCount do
			local _go = CommonUtil.Instantiate(_boxOriginal, self.refreshTaskParent.totalScore.transform);
			local _move = Vector3.New(_boxOriginalPos.x + 148 * _i, _boxOriginalPos.y, _boxOriginalPos.z);
			_go.transform.localPosition = _go.transform.localPosition + _move;

			local _numText = _go.transform:Find("Num").gameObject:GetComponent(Enum.TypeInfo.TextMeshProUGUI);
			_numText.text = tostring(_i * 20);
			table.insert(self._box, _go);
		end
	end

	local _curOpenType = self.controller:GetCurOpenTaskType();
	if Constant.OpenPay then
		self.toggle1:SetActive(true)
		self.toggle2:SetActive(true)
		self.toggle3:SetActive(true)
	else
		self.toggle1:SetActive(false)
		self.toggle2:SetActive(false)
		self.toggle3:SetActive(true)
		_curOpenType = Enum.TaskTag.Main
	end

	for _i = 1, Enum.TaskTag.Main do
		local _show = _curOpenType == _i;
		self["toggle" .. tostring(_i)].toggle.isOn = _show;
	end
	--self:SetTaskDataByType(_curOpenType);
	self.refreshTaskParent.gameObject:SetActive(false);
	self.mainTaskParent.gameObject:SetActive(false);

	self:RefreshRedPoint(Enum.TaskTag.Daily);
	self:RefreshRedPoint(Enum.TaskTag.Weekly);
	self:RefreshRedPoint(Enum.TaskTag.Main);
end

function UITaskView:OnPageInEnd()
	local _curOpenType = self.controller:GetCurOpenTaskType();
	if not Constant.OpenPay then
		_curOpenType = Enum.TaskTag.Main
	end
	self:SetTaskDataByType(_curOpenType);
	self.super.OnPageInEnd(self)
end

function UITaskView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UITaskView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.BtnClose.button, self, self.OnCloseClick);
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick);

	self.uiBase:AddButtonUniqueEventListener(self.refreshTaskParent.totalScore.item.button, self, self.OnClickTotalScoreItem)

	self.uiBase:AddToggleEventListener(self.toggle1.toggle, self, self.OnPageToggleClick, Enum.TaskTag.Daily);
	self.uiBase:AddToggleEventListener(self.toggle2.toggle, self, self.OnPageToggleClick, Enum.TaskTag.Weekly);
	self.uiBase:AddToggleEventListener(self.toggle3.toggle, self, self.OnPageToggleClick, Enum.TaskTag.Main);
end

function UITaskView:OnHide()
end

function UITaskView:OnShow(data)
	self.controller:SetData(data)
end

function UITaskView:OnClose()
	self.mainTaskParent.scrollViewMain.loopVerticalScrollRect:ClearCells()
	self.refreshTaskParent.scrollViewRefresh.loopVerticalScrollRect:ClearCells()
	self:RemoveTimer();
	self._actLevelMax = nil;
	--清除所有的item对象
	for i = #self._box, 0, -1 do
		CommonUtil.DestroyGO(self._box[i]);
	end
	self._box = nil;
end

function UITaskView:OnDispose()
	self.controller:OnDispose()
end

function UITaskView:OnCloseClick()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_CLOSEED_TASK_PAGE)
	self:UIClose()
end

function UITaskView:OnClickTotalScoreItem()
	if self.curOpenType == Enum.TaskTag.Daily then 
		ManagerContainer.LuaUIMgr:ShowMinTips('DayTaskTips2')
	elseif self.curOpenType == Enum.TaskTag.Weekly then
		ManagerContainer.LuaUIMgr:ShowMinTips('WeekTaskTips2')
	end
end

function UITaskView:RefreshRedPoint(_type)
	local _canGet = ManagerContainer.DataMgr.TaskDataNew:JudgeCanGetByType(_type);

	local _taskEnum;
	if _type == Enum.TaskTag.Daily then
		_taskEnum = Enum.RPNotifyType.TaskDaily;
	elseif _type == Enum.TaskTag.Weekly then
		_taskEnum = Enum.RPNotifyType.TaskWeekly;
	else
		_taskEnum = Enum.RPNotifyType.TaskMain;
	end

	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, _taskEnum, _canGet);
end

function UITaskView:OnPageToggleClick(_toggle, _params)
	if _toggle.isOn then
		if self.curOpenType ~= _params then
			self.mainTaskParent.scrollViewMain.loopVerticalScrollRect:ClearCells()
			self.refreshTaskParent.scrollViewRefresh.loopVerticalScrollRect:ClearCells()
			self:SetTaskDataByType(_params);
		end
	end
end

function UITaskView:RefreshTask()
	self:SetTaskDataByType(self.curOpenType)
    self:RefreshRedPoint(self.curOpenType);
end

function UITaskView:SetTaskDataByType(_type)
	self.curOpenType = _type
	local _isMain = (self.curOpenType == Enum.TaskTag.Main);

	self:SetScrollLoop();
	self.refreshTaskParent.gameObject:SetActive(not _isMain);
	self.mainTaskParent.gameObject:SetActive(_isMain);
	self.refreshTaskParent.dailyShow.gameObject:SetActive(self.curOpenType == Enum.TaskTag.Daily)
	self.refreshTaskParent.weeklyShow.gameObject:SetActive(self.curOpenType == Enum.TaskTag.Weekly)
	self.refreshTaskParent.tipsTxt.gameObject:SetActive(true);
	if self.curOpenType == Enum.TaskTag.Daily then
		self.refreshTaskParent.tipsTxt.RefreshTips.text.text = I18N.T("DayTaskTips")
	elseif self.curOpenType == Enum.TaskTag.Weekly then
		self.refreshTaskParent.tipsTxt.RefreshTips.text.text = I18N.T("WeekTaskTips")
	end
	if not _isMain then
		self:SetTime();
		self:SetActReward();
	end
end

--清除时间
function UITaskView:RemoveTimer()
	if self._timer then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self._timer);
		self._timer = nil;
	end
end

--设置时间
function UITaskView:SetTime()
	if self.curOpenType == Enum.TaskTag.Daily then
		self:RemoveTimer();
		if ManagerContainer.DataMgr.TaskDataNew.dailyTaskEndTime > ManagerContainer.LuaTimerMgr:GetTimeSecond() then
			self:RefreshLeftTime()
			self._timer = ManagerContainer.LuaTimerMgr:AddTimer(1000, -1, self, self.RefreshLeftTime, nil);
		else
			self.time.text.text = ""
		end
	elseif self.curOpenType == Enum.TaskTag.Weekly then
		self:RemoveTimer();
		if ManagerContainer.DataMgr.TaskDataNew.weeklyTaskEndTime > ManagerContainer.LuaTimerMgr:GetTimeSecond() then
			self:RefreshLeftTime()
			self._timer = ManagerContainer.LuaTimerMgr:AddTimer(1000, -1, self, self.RefreshLeftTime, nil);
		else
			self.time.text.text = ""
		end
	end
end

function UITaskView:RefreshLeftTime()
	local endTime = 0
	if self.curOpenType == Enum.TaskTag.Daily then
		endTime = ManagerContainer.DataMgr.TaskDataNew.dailyTaskEndTime
	elseif self.curOpenType == Enum.TaskTag.Weekly then
		endTime = ManagerContainer.DataMgr.TaskDataNew.weeklyTaskEndTime
	end

	if endTime <= ManagerContainer.LuaTimerMgr:GetTimeSecond() then
		self:RemoveTimer()
		self.time.text.text = ""
	else
		local leftTime = endTime - ManagerContainer.LuaTimerMgr:GetTimeSecond()
		if leftTime < 1 then
			self:RemoveTimer()
			self.time.text.text = ""
		else
			local day,hour,minute,second = ConvertTimeForm(leftTime)
			local timeStr = ""
			if day > 0 then
				timeStr = string.format("%02d天%02d时", day, hour)
			else
				if hour > 0 then
					timeStr = string.format("%02d时%02d分", hour, minute)
				else
					timeStr = string.format("%02d分%02d秒", minute, second)
				end
			end	
			self.time.text.text = string.formatbykey("RefreshTime",timeStr)
		end
	end
end

--设置活跃度奖励的显示
function UITaskView:SetActReward()
	local _taskMessage = ManagerContainer.DataMgr.TaskDataNew:GetTaskMessage(self.curOpenType);

	self.refreshTaskParent.totalScore.item.num.text.text = tostring(_taskMessage._score);

	local _max = _taskMessage._rewardList[self._actLevelMax]._data.Active;
	local _progress = _taskMessage._score / _max;
	self.refreshTaskParent.totalScore.scrollbar.scrollbar.size = _progress;

	for _i = 1, self._actLevelMax do
		local _data = _taskMessage._rewardList[_i];

		local _box = self._box[_i];
		_box.gameObject:SetActive(true);
		local _boxTra = _box.transform:Find("Box")
		local _animator = _boxTra.gameObject:GetComponent(Enum.TypeInfo.Animator);
		if not _data._state then	--未领取
			local _canGet = ManagerContainer.DataMgr.TaskDataNew:JudgeRewardByIndex(self.curOpenType, _i);
			if _canGet then
				_animator:Play("BoxGlow");
			else
				_animator:Play("BoxClose");
			end
		else	--已经领取
			_animator:Play("BoxOpened");
		end

		local _boxButton = _boxTra.gameObject:GetComponent(Enum.TypeInfo.Button);
		self.uiBase:AddButtonUniqueEventListener(_boxButton, self, function (buttton, params)
			local _canGet = ManagerContainer.DataMgr.TaskDataNew:JudgeRewardByIndex(self.curOpenType, _i);
			if _canGet then
				ManagerContainer.DataMgr.TaskDataNew:CSGetTaskScoreRewardReq(self.curOpenType, _data._data.ID);
			else
				for i = 1, #_data._data.Reward do
					_data._data.Reward[i][3] = _data._state
				end
				ManagerContainer.LuaUIMgr:ShowMinRewardTips(_data._data.Reward)
			end
		end)
	end
end

--点击tips上的iconitem之后弹出对应的item的tip
function UITaskView:ShowItemTips(button, params)
	ManagerContainer.LuaUIMgr:OpenTips(params[0]);
end

--设置滚动列表
function UITaskView:SetScrollLoop()
	if self.curOpenType == Enum.TaskTag.Main then
		local taskList = ManagerContainer.DataMgr.TaskDataNew:GetTasksDataByType(self.curOpenType)
		if taskList ~= nil and #taskList > 0 then
			CommonUtil.LoopGridViewEleCreateNew(self,
					self.mainTaskParent.scrollViewMain.loopVerticalScrollRect,
					self.mainTaskParent.scrollViewMain.content.verticalLayoutGroup,
					taskList,
					0,
					self,
					self.UpdateTaskItem);
		else
			self.mainTaskParent.scrollViewMain.loopVerticalScrollRect:ClearCells()
		end
	else
		local taskList = ManagerContainer.DataMgr.TaskDataNew:GetTasksDataByType(self.curOpenType)
		if taskList ~= nil and #taskList > 0 then
			CommonUtil.LoopGridViewEleCreateNew(self,
					self.refreshTaskParent.scrollViewRefresh.loopVerticalScrollRect,
					self.refreshTaskParent.scrollViewRefresh.content.verticalLayoutGroup,
					taskList,
					0,
					self,
					self.UpdateTaskItem);
		else
			self.refreshTaskParent.scrollViewRefresh.loopVerticalScrollRect:ClearCells()
		end
	end
end

--设置单个对象
function UITaskView:UpdateTaskItem(_itemLua, _idx,_data)
	if _data then
		local _logicData = self.controller:CreateLogicData(_data, self.curOpenType);
		if self.curOpenType == Enum.TaskTag.Main then
			TaskItemMainCtr:SetData(self, _itemLua, _logicData, self, self.OnMainTaskItemClick);
		else
			_logicData.fakeIcon = self.refreshTaskParent.fakeIcon;
			TaskItemRefreshCtr:SetData(self, _itemLua, _logicData, self, self.OnRefreshItemClick);
		end
	else
		LogError(Inspect(self.controller:GetTaskData()));
	end
end

function UITaskView:OnMainTaskItemClick(button, params)
	button.interactable = false;
	local _itemData = params[0].itemData;
	if _itemData:JudgeCanGet() then
		ManagerContainer.DataMgr.TaskDataNew:CSGetTaskRewardReq(_itemData._id);
	else
		local _jumpType = _itemData._cfgData.SkipInterface or 0;
		if _jumpType > 0 then
			TaskJumpCtr:JumpBuyCfgId(_itemData._cfgData.SkipInterface)
		end
	end
end

function UITaskView:OnRefreshItemClick(button, params)
	local _fun = params[1];
	if type(_fun) == "function" then
		_fun();
	end

	local _itemData = params[0].itemData;
	if _itemData:JudgeCanGet() then
		button.interactable = false;
		ManagerContainer.DataMgr.TaskDataNew:CSGetTaskRewardReq(_itemData._id);
	else
		local _jumpType = _itemData._cfgData.SkipInterface or 0;
		if _jumpType > 0 then
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_TASK_JUMP)
			TaskJumpCtr:JumpBuyCfgId(_itemData._cfgData.SkipInterface);
		end
	end
end

function UITaskView:FindTaskCompeleted(id, owner, ownerCB)
	local content = self.refreshTaskParent.scrollViewRefresh.content.transform
	if content.childCount == 0 then
		if owner and ownerCB then
			ownerCB(owner)
		end
		return
	end

	local itemGo = content:GetChild(0).gameObject
	local itemlua = CommonUtil.GetBindGridViewItem2Lua(self, "TaskItemRefresh", itemGo)
	if not itemlua then
		if owner and ownerCB then
			ownerCB(owner)
		end
		return
	end

	local target = itemlua.btnGet
	if target == nil then
		if owner and ownerCB then
			ownerCB(owner)
		end
		return
	end

	if owner and ownerCB then
		ownerCB(owner, target)
	end
end

return UITaskView

