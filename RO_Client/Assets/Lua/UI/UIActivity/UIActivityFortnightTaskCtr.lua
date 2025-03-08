local UIActivityFortnightTaskCtr = class("UIActivityFortnightTaskCtr", require("UICtrBase"))

function UIActivityFortnightTaskCtr:Init(view)
	self.view = view
end

function UIActivityFortnightTaskCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIActivityFortnightTaskCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIActivityFortnightTaskCtr:GetActId()
	return self.data.actId
end

function UIActivityFortnightTaskCtr:GetBg()
	return self.data.pageBg
end

function UIActivityFortnightTaskCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.activityData = nil
end

function UIActivityFortnightTaskCtr:InitActivityData(pageId)
	local actId = self:GetActId()
	self.activityData = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(actId)
end

function UIActivityFortnightTaskCtr:GetActivityData()
	return self.activityData
end

function UIActivityFortnightTaskCtr:GetHeroIdx(uid)
    if self.teamMembers == nil  then
		return -1
	end

	for i=1, #self.teamMembers do
		if self.teamMembers[i].uid == uid then
			return i
		end
	end
	return -1
end

return UIActivityFortnightTaskCtr

