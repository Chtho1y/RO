local UIActivityFortnightLoginCtr = class("UIActivityFortnightLoginCtr", require("UICtrBase"))

function UIActivityFortnightLoginCtr:Init(view)
	self.view = view
end

function UIActivityFortnightLoginCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIActivityFortnightLoginCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIActivityFortnightLoginCtr:GetData()
	return self.data
end

function UIActivityFortnightLoginCtr:GetActId()
	return self.data.actId
end

function UIActivityFortnightLoginCtr:GetBg()
	return self.data.pageBg
end

function UIActivityFortnightLoginCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.activityData = nil
end

function UIActivityFortnightLoginCtr:InitActivityData(pageId)
	local actId = self:GetActId()
	self.activityData = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(actId)
end

function UIActivityFortnightLoginCtr:GetActivityData()
	return self.activityData
end

return UIActivityFortnightLoginCtr

