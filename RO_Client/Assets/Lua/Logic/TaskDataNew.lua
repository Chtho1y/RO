local TaskDataNew = class("TaskDataNew", require("DataBase"))
local TaskItemDataNew = require("TaskItemDataNew")
local ProtocalDataNormal = require("ProtocalDataNormal")

function TaskDataNew:ctor()
    self._data = nil
    self._dayTaskMessage = {};
    self._weekTaskMessage = {};
    self._mainButton = nil;
    self._refreshImmediately = true;
    self.dailyTaskEndTime = 0
    self.weeklyTaskEndTime = 0
end

function TaskDataNew:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GET_TASK_REWARD_ACK, self.SCGetTaskRewardAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GET_TASK_SCORE_REWARD_ACK, self.CSGetTaskScoreRewardAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_TASK_CHANGE_NTF,self.SCTaskChangeNtf,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_HERO_CONDITIN_DATA_NTF, function(data)
        self:RefreshChangeJobTaskData(data)
    end)
end

function TaskDataNew:Clear()
    self._data = nil
    self._dayTaskMessage = {}
    self._weekTaskMessage = {}
    self._mainButton = nil
    self._refreshImmediately = true
    self.dailyTaskEndTime = 0
    self.weeklyTaskEndTime = 0
end

function TaskDataNew:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function TaskDataNew:UnRegisterNetEvents()

end

--设置当前处在那个主按钮
function TaskDataNew:SetMainButton(_buttonType)
    self._mainButton = _buttonType;
end

function TaskDataNew:GetMainButton()
    return self._mainButton;
end

--[[
self._data = {
                [Enum.TaskTag.Daily] = {TaskItemDataNew}
                [Enum.TaskTag.Weekly] = {TaskItemDataNew}
                [Enum.TaskTag.Main] = {TaskItemDataNew}
              }

self._dayTaskMessage = {
                          _beginTime = **
                          _score = ***
                          _rewardList = {}
                        }

]]--
--add是不是增量增加
function TaskDataNew:CreateTaskByTable(_table, _add)
    if not _add or nil == self._data then
        self._data = {
            [Enum.TaskTag.Daily] = {},
            [Enum.TaskTag.Weekly] = {},
            [Enum.TaskTag.Main] = {},
            _changeJobTaskData = nil,
            _headCond = {},
            _heroCond = {},
        };
    end
    for _k, _v in ipairs(_table) do
        local _taskItemData = TaskItemDataNew:new();
        _taskItemData:RefreshTaskItem(_v);
        if _taskItemData._cfgData then
            local _taskType = _taskItemData._taskType
            local ls = self._data[_taskType]
            if ls then
                table.insert(ls, _taskItemData)
            else
                LogError('task is error ' .. tostring(_taskType) .. '   ' .. tostring(_taskItemData._id))
            end
        end
    end

    self:GetActRewardInCfg();
end

--登录之初整理一下玩家的所有当前任务的信息
function TaskDataNew:InitRoleTask(_data)
    self.dailyTaskEndTime = tonumber(tostring(_data.latest5_hour_time/1000))
    self.weeklyTaskEndTime = tonumber(tostring(_data.latest_week5_hour_time/1000))

    local _taskList = _data.task_list;
    self._data = {};

    self:CreateTaskByTable(_taskList);

    self:SortTask(Enum.TaskTag.Daily);
    self:SortTask(Enum.TaskTag.Weekly);
    self:SortTask(Enum.TaskTag.Main);

    self:RecordScoreMessage(self._dayTaskMessage, _data.daily_task_score, Enum.TaskTag.Daily);
    self:RecordScoreMessage(self._weekTaskMessage, _data.week_task_score, Enum.TaskTag.Weekly);

    local _dayBeginTime, _weekBeginTime = 0, 0;
    local _dayTasks, _weekTasks = self._data[Enum.TaskTag.Daily], self._data[Enum.TaskTag.Weekly];
    if _dayTasks and _dayTasks[1] then
        _dayBeginTime = _dayTasks[1]._beginTime
    else
        LogError("Task Error :No day task!" .. Inspect(_data))
    end
    if _weekTasks and _weekTasks[1] then
        _weekBeginTime = _weekTasks[1]._beginTime
    else
        LogError("Task Error :No week task!" .. Inspect(_data))
    end

    self._dayTaskMessage._beginTime = _dayBeginTime;
    self._weekTaskMessage._beginTime = _weekBeginTime;

    self:RefreshChangeJobTaskData(_data);

    self:RefreshRedPoint();
end

--对任务信息进行排序
function TaskDataNew:SortTask(_taskType)
    if not self._data[_taskType] then return; end
    table.sort(self._data[_taskType], function (a, b)
        local _sortGotA = math.fmod((a._got + 1), 3);
        local _sortGotB = math.fmod((b._got + 1), 3);
        if _sortGotA > _sortGotB then
            return true;
        elseif _sortGotA < _sortGotB then
            return false;
        else
            if a._progressNum > b._progressNum then
                return true;
            elseif a._progressNum < b._progressNum then
                return false
            else
                return a._id < b._id;
            end
        end
    end);

    if _taskType == Enum.TaskTag.Main then
        self:RemoveGotMainTask();
    end
end

--移除已经领取的主线任务
function TaskDataNew:RemoveGotMainTask()
    local _mainTaskList = self._data[Enum.TaskTag.Main];
    for _i = #_mainTaskList, 1, -1 do
        if _mainTaskList[_i]._state == Enum.TaskState.GotAndHas then    --已经领取过了
            table.remove(_mainTaskList, _i);
        end
    end
end

--获取活跃度奖励得表格数据，注意：主线任务是没有活跃度这个概念得
function TaskDataNew:GetActRewardInCfg()
    if not self._dayTaskMessage._rewardList and not self._weekTaskMessage._rewardList then
        self._dayTaskMessage._rewardList = {}
        self._weekTaskMessage._rewardList = {}
        local _actRewardCfg = ManagerContainer.CfgMgr:GetActRewardCfg();
        for _k, _v in pairs(_actRewardCfg) do
            if _v.ActiveType == Enum.TaskTag.Daily then
                table.insert(self._dayTaskMessage._rewardList, {
                    _data = _v,     --表格中的信息
                    _state = false, --领取状态,true--已领取；false--未领取
                });
            elseif _v.ActiveType == Enum.TaskTag.Weekly then
                table.insert(self._weekTaskMessage._rewardList,  {
                    _data = _v,     --表格中的信息
                    _state = false, --领取状态
                });
            end
        end

        self:SortRewardList(self._dayTaskMessage._rewardList);
        self:SortRewardList(self._weekTaskMessage._rewardList);
    end
end

--对表格中的奖励信息进行排序
function TaskDataNew:SortRewardList(_rewardList)
    table.sort(_rewardList, function(a, b)
        return a._data.Active < b._data.Active;
    end)
end

--记录服务器给过来的任务的活跃度信息
function TaskDataNew:RecordScoreMessage(_targetMessage ,_scoreMessage, _type)
    if _scoreMessage == nil then
        _targetMessage._score = 0;
        return
    end

    _targetMessage._score = _scoreMessage.value or 0;
    for _i = 1, #_targetMessage._rewardList do
        local _move = (_type - 1) * 5 + _i; --这个是任务奖励表格中的id的操作
        local _judgeNum = Bit.lshift(1, _move);
        local _stateNum = CommonUtil.And(_judgeNum, _scoreMessage.key);
        _targetMessage._rewardList[_i]._state = _stateNum > 0;
    end
end

--找到队对应的任务对象
function TaskDataNew:GetTaskItemData(_id, _taskType)
    if nil == self._data or nil == self._data[_taskType] then
        return nil;
    end
    for _k, _v in ipairs(self._data[_taskType]) do
        if _v._id == _id then
            return _v;
        end
    end
    return nil
end

--获取不同类型的任务
function TaskDataNew:GetTasksDataByType(_type)
    return self._data[_type];
end

--获取任务的活跃度信息
function TaskDataNew:GetTaskMessage(_type)
    if _type == Enum.TaskTag.Daily then
        return self._dayTaskMessage;
    elseif _type == Enum.TaskTag.Weekly then
        return self._weekTaskMessage;
    else
        LogError("这种类型暂时没有活跃度信息：" .. tostring(_type));
    end
end

--开启任务面板
function TaskDataNew:OpenTaskPanel()
    local _openTaskTag = self:RefreshRedPoint();
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UITaskNew, {
        openTaskTag = _openTaskTag,
    })
end

--刷新红点
function TaskDataNew:RefreshRedPoint()
    local _dailyCanGet, _weeklyCanGet, _mainLinCanGet;
    _dailyCanGet = self:JudgeCanGetByType(Enum.TaskTag.Daily);
    _weeklyCanGet = self:JudgeCanGetByType(Enum.TaskTag.Weekly);
    _mainLinCanGet = self:JudgeCanGetByType(Enum.TaskTag.Main);

    local _openTaskTag = Enum.TaskTag.Daily;
    if _dailyCanGet then
    elseif _weeklyCanGet then
        _openTaskTag = Enum.TaskTag.Weekly;
    elseif _mainLinCanGet then
        _openTaskTag = Enum.TaskTag.Main;
    end

    local _canGetTask = _dailyCanGet or _weeklyCanGet or _mainLinCanGet
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.Task, _canGetTask);

    return _openTaskTag;
end

--判断是否有可领取的任务
function TaskDataNew:JudgeCanGetByType(_type)
    local _allData = self._data[_type];
    for _i = 1, #_allData do
        if _allData[_i]:JudgeCanGet() then
            return true;
        end
    end
    if _type == Enum.TaskTag.Daily then
        local _canGet = self:JudgeRewardList(self._dayTaskMessage);
        if _canGet then return true; end
    elseif _type == Enum.TaskTag.Weekly then
        local _canGet = self:JudgeRewardList(self._weekTaskMessage);
        if _canGet then return true; end
    end

    return false;
end

--判断活跃度奖励
function TaskDataNew:JudgeRewardList(_message)
    for _i = 1, #_message._rewardList do
        local _data = _message._rewardList[_i];
        if _data._data.Active <= _message._score and not _data._state then
            return true;
        end
    end
    return false;
end

--判断某一级别的活跃度是否可领取
function TaskDataNew:JudgeRewardByIndex(_type, _index)
    local _message = nil;
    if _type == Enum.TaskTag.Daily then
        _message = self._dayTaskMessage;
    elseif _type == Enum.TaskTag.Weekly then
        _message = self._weekTaskMessage;
    else
        return false
    end
    if _index <= #_message._rewardList then
        local _data = _message._rewardList[_index];
        if _data._data.Active <= _message._score and not _data._state then
            return true;
        end
    else
        LogError("index超出边界：" .. tostring(_index));
        LogError(Inspect(_message));
    end

    return false;
end

--刷新可转职业条件
function TaskDataNew:RefreshChangeJobTaskData(_data)
    if not self._data then return end
    if not self._data._changeJobTaskData then
        self._data._changeJobTaskData = ProtocalDataNormal.ParseRoleTaskData(_data);
    else
        if _data.condition then
            for _, v in pairs(_data.condition) do
                self._data._changeJobTaskData.condition[v.hero_id] = ProtocalDataNormal.ParseTaskDataList(v.task_list)
            end
        end
    end

    ManagerContainer.RedPointMgr.HeroRPCtr:RoleTransferRedPointNotify()
end

--获取专职的任务数据
function TaskDataNew:GetChangeJobTaskData(_heroId, _conId)
    if self._data == nil then return end
    if self._data._changeJobTaskData == nil then return end
    if self._data._changeJobTaskData.condition == nil then return end
    if self._data._changeJobTaskData.condition[_heroId] == nil then return end

    local _data = self._data._changeJobTaskData.condition[_heroId][_conId];
    return _data;
end

--请求服务器发放任务奖励
function TaskDataNew:CSGetTaskRewardReq(_id)
    local _req = {
        task_id = _id;
    };
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_TASK_REWARD_REQ, _req);
    self:ReportTask(_id, true)
end

function TaskDataNew:ReportTask(_id, success)
    if not SDKMgr.Instance:IsReportAction() then
        return
    end
    if _id == 800001 then
        local datas = System.Collections.Generic.Dictionary_object_object()
        datas:Add('event', 'mj_maintask_clothing')
        datas:Add('is_achieve', (success and 1 or 0))
        SDKMgr.Instance:ReportAction(datas)
    else
        local _taskItemData = self:GetTaskItemData(_id, Enum.TaskTag.Main)
        if _taskItemData then
            local datas = System.Collections.Generic.Dictionary_object_object()
            datas:Add('event', 'mj_maintask')
            datas:Add('is_achieve', (success and 1 or 0))
            SDKMgr.Instance:ReportAction(datas)
            return
        end
        _taskItemData = self:GetTaskItemData(_id, Enum.TaskTag.Daily)
        if _taskItemData then
            local datas = System.Collections.Generic.Dictionary_object_object()
            datas:Add('event', 'mj_daily_rewards')
            datas:Add('is_achieve', (success and 1 or 0))
            SDKMgr.Instance:ReportAction(datas)
        end
    end
end


--领取任务奖励之后的返回
function TaskDataNew:SCGetTaskRewardAck(_data)
    self:JudgeAck(_data);
end

--请求服务器下发活跃度的奖励
function TaskDataNew:CSGetTaskScoreRewardReq(_type, _index)
    local _req = {
        reward_type = _type,
        reward_idx = _index,
    };
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_TASK_SCORE_REWARD_REQ, _req);
end

function TaskDataNew:CSGetTaskScoreRewardAck(_data)
    self:JudgeAck(_data);
end

--任务奖励和活跃度奖励的ack内容是一样的，都调用这里吧
function TaskDataNew:JudgeAck(_data)
    if _data.error ~= Enum.NetErrorCode.ERROR_OK then
        -- LogError("领取任务奖励失败，错误码：" .. tostring(_data.error));
        return
    end

    if _data.item_list and #_data.item_list > 0 then
        local _rewards = {};
        for _i = 1, #_data.item_list do
            local _itemData = _data.item_list[_i];
            table.insert(_rewards, {
                cfgId = _itemData.key;
                num = _itemData.value;
            })
        end
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot,{rewards = _rewards})
    end
end

--服务器主动推送的任务状态改变之后的信息
function TaskDataNew:SCTaskChangeNtf(_data)
    if self._data == nil then       --如果服务器在登录得到所有的任务之前发了这条推送的话，不用记录这个消息,因为后续还会发送一个总的消息
        return;
    end
    
    if _data.latest5_hour_time ~= nil and _data.latest5_hour_time > 0 then
        self.dailyTaskEndTime = tonumber(tostring(_data.latest5_hour_time/1000))
    end

    if _data.latest_week5_hour_time ~= nil and _data.latest_week5_hour_time > 0 then
        self.weeklyTaskEndTime = tonumber(tostring(_data.latest_week5_hour_time/1000))
    end

    local _newTaskList = {};
    for _k, _v in pairs(_data.task_change_list) do
        local _taskItemData = self:GetTaskItemData(_v.task_id, _v.task_type);
        if _taskItemData then
            _taskItemData:RefreshTaskItem(_v);
        else
            table.insert(_newTaskList, _v);
        end
    end

    if #_newTaskList > 0 then
        self:CreateTaskByTable(_newTaskList, true);
    end

    self:SortTask(Enum.TaskTag.Daily);
    self:SortTask(Enum.TaskTag.Weekly);
    self:SortTask(Enum.TaskTag.Main);

    self:RecordScoreMessage(self._dayTaskMessage, _data.daily_task_score, Enum.TaskTag.Daily);
    self:RecordScoreMessage(self._weekTaskMessage, _data.week_task_score, Enum.TaskTag.Weekly);

    if self._refreshImmediately then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_TASK_CHANGE);
    else
        self._refreshImmediately = true;
    end
    self:RefreshRedPoint();
end

return TaskDataNew