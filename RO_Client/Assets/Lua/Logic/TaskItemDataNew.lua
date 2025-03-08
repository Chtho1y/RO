--[[
每条任务的数据类
]]--
local TaskItemDataNew = class("TaskItemDataNew", require("DataBase"))
--银币消耗（30），金币消耗（31），银币获得（39），总战力（14），使用特定道具数量（21），累积获得卡片数量（41），英灵殿胜利次数（32）
--需要转换数值显示形式的任务枚举
local _needChangeEnum = {30, 31, 39, 14, 21, 41, 32}
local _w = 10000;   --一万

function TaskItemDataNew:ctor()
    self._id = nil;
    self._taskType = nil;
    self._cfgData = nil;
    self._progress = nil;
    self._got = nil;
    self._beginTime = nil;
end

function TaskItemDataNew:Clear()
    self._id = nil;
    self._taskType = nil;
    self._cfgData = nil;
    self._progress = nil;
    self._got = nil;
    self._beginTime = nil;
end

function TaskItemDataNew:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function TaskItemDataNew:UnRegisterNetEvents()

end

function TaskItemDataNew:RefreshTaskItem(_data)
    self._id = _data.task_id;
    self._taskType = _data.task_type;
    self._state = _data.state
    self:GetCfgData(self._id, self._taskType);
    if self._cfgData then
        self._progress = {};
        local _missionCondition = self._cfgData.MissionCondition;
        for _i = 1, #_missionCondition do
            local _conditions = _missionCondition[_i];
            --完成度在表格得MissionCondition字段中的list中每一个的第一个值都是不能重复的，不允许出现：2:1;3:6;2:5这种情况，里边出现了两个2

            local _keyCon = _conditions[1];
            local _totalCon = self:JudgeTotal(_conditions[1], _conditions[#_conditions])
            local _needChangeEnum = self:IsNeedChangeEnum(_keyCon);
            local _totalConStr = tostring(_totalCon);
            if _needChangeEnum and _w <= _totalCon then
                _totalConStr = CommonUtil.GetPreciseDecimalFloor(_totalCon/10000, 1) .. "w";
            end
            local _progress = {
                _key = _keyCon,
                _total = _totalCon;    --该条件达成，需要完成多少
                _value = 0;             --完成了多少
                _state = 0;             --是否已经完成，这个完成指的是这一个条件得完成，跟整个任务得完成还不太一样，但是如果任务只有一个条件得话，那就是一样得
                _totalStr = _totalConStr;   --这个是数值格式化之后的字符串（当数值很大的时候转换成**W代表**万）
                _valueStr = ";"         --这个是完成的数值格式化之后的字符串
            };
            local _value, _state = self:GetProgressByKey(_progress._key, _data.progress);
            _progress._value = _value or 0;
            if _needChangeEnum and _w <= _progress._value then
                _progress._valueStr = CommonUtil.GetPreciseDecimalFloor(_progress._value/10000, 1) .. "w";
            else
                _progress._valueStr = tostring(_progress._value)
            end
            _progress._state = _state or 0;
            table.insert(self._progress, _progress);
        end

        self:GetProgressNumber();
        self._got = _data.state or 0;        --是否已经领取
        self._beginTime = _data.begin_time;
    end
end


--判断完成任务的需要总量
function TaskItemDataNew:JudgeTotal(_type, _total)
    if _type == Enum.TaskType.Level_Battle_Count then   --同关
        return 1;
    else
        return _total;
    end
end

--根据传进来得key查找服务器发过来得数据中对应得那个条件得进度
function TaskItemDataNew:GetProgressByKey(_key, _progress)
    for _k, _v in ipairs(_progress) do
        if _v.key == _key then
            return _v.value, _v.state;
        end
    end
end

function TaskItemDataNew:GetCfgData(_id, _type)
    if self._cfgData then return; end

    if _type == Enum.TaskTag.Daily or _type == Enum.TaskTag.Weekly then
        self._cfgData = ManagerContainer.CfgMgr:GetMissionById(_id)
    elseif _type == Enum.TaskTag.Main then
        self._cfgData = ManagerContainer.CfgMgr:GetLineMissionById(_id)
    else
        LogError("未知任务类型：" .. tostring(_type));
    end
end

--获取进度的比值,策划说的目前每个任务只有一个条件，后续如果要扩展，需要他们提供多个条件的情况下进度的比值怎么计算，然后这里需要改动
function TaskItemDataNew:GetProgressNumber()
    local _progress = self._progress[1];
    self._progressNum = _progress._value / _progress._total;
end

--获取进度信息，当前进度值，完成需要的总值
function TaskItemDataNew:GetProgressData()
    local _progress = self._progress[1];
    return _progress._valueStr, _progress._totalStr;
end

--判断是否可以领取
function TaskItemDataNew:JudgeCanGet()
    return self._got == Enum.TaskState.Got, self._got;
end

function TaskItemDataNew:IsNeedChangeEnum(_enum)
    for _i = 1, #_needChangeEnum do
        if _needChangeEnum[_i] == _enum then
            return true;
        end
    end
    return false;
end

return TaskItemDataNew