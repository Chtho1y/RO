local UITaskCtr = class("UITaskCtr", require("UICtrBase"))

function UITaskCtr:Init(view)
	self.view = view
end

function UITaskCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
	self._taskType = self.data.openTaskTag
end

function UITaskCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UITaskCtr:GetData()
	return self.data
end

function UITaskCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UITaskCtr:GetCurOpenTaskType()
	return self._taskType;
end

function UITaskCtr:GetTaskData()
	return ManagerContainer.DataMgr.TaskDataNew:GetTasksDataByType(self._taskType);
end

function UITaskCtr:JudgeActTaskState(_message, _index)
	local _data = _message[_index];
	if _data._data.Active <= _message._score and not _data._state then
		return true;
	end

	return false;
end

--根据传过来的任务数据，整理成一个能够给滑动列表中的item对象进行填充的数据
function UITaskCtr:CreateLogicData(_data, _type)
	if nil == _data then return nil; end
	local _logicData = {};

	if _type ~= Enum.TaskTag.Main then
		_logicData.state = _data._got;
	end

	_logicData.itemData = _data;
	local _canGet = _data._got;
	_logicData._getState = _canGet;

	_logicData.jumpType = _logicData.itemData._cfgData.SkipInterface or 0;
	return _logicData;
end

return UITaskCtr

