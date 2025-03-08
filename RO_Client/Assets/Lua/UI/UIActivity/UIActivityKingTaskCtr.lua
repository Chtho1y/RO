local UIActivityKingTaskCtr = class("UIActivityKingTaskCtr", require("UICtrBase"))

function UIActivityKingTaskCtr:Init(view)
	self.view = view
end

function UIActivityKingTaskCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIActivityKingTaskCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIActivityKingTaskCtr:GetData()
	return self.data
end

function UIActivityKingTaskCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIActivityKingTaskCtr:InitData()
	if not self.activityData then
		self.activityData = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(self.data.actId)
	end
	self.taskList = self.activityData:GetTaskList()
	self.dayTaskList = self.activityData:GetDayTaskList()
end

function UIActivityKingTaskCtr:GetRemainTime()
	return self.activityData:LeftTime()
end

function UIActivityKingTaskCtr:GetActivityActId()
	return self.data.actId or 0
end

function UIActivityKingTaskCtr:GetDayRemainTime()
	return self.activityData:GetDayLeftTime()
end

function UIActivityKingTaskCtr:GetActivityData()
	return self.activityData
end

function UIActivityKingTaskCtr:GetTaskList()
	return self.taskList
end

function UIActivityKingTaskCtr:GetTaskListDataByIdx(idx)
	return self.taskList and self.taskList[idx] or nil
end

function UIActivityKingTaskCtr:GetDayTaskList()
	return self.dayTaskList
end

function UIActivityKingTaskCtr:GetDayTaskListDataByIdx(idx)
	return self.dayTaskList and self.dayTaskList[idx] or nil
end

function UIActivityKingTaskCtr:HasGrowTaskRP()
	return self.activityData:HasGrowTaskRP()
end

function UIActivityKingTaskCtr:HasDayTaskRP()
	return self.activityData:HasDayTaskRP()
end

return UIActivityKingTaskCtr

