local UIActivityTurntableCtr = class("UIActivityTurntableCtr", require("UICtrBase"))

function UIActivityTurntableCtr:Init(view)
	self.view = view
end

function UIActivityTurntableCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data	
end

function UIActivityTurntableCtr:GetActivityItem()
	local ActId = self.data.actId	
	local actItem = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(ActId)
	return actItem
end

function UIActivityTurntableCtr:GetActivityData()
	local Act = self:GetActivityItem()
	if Act then		
		--LogError("GetActivityData"..Inspect(Act:GetActivityData().itemlist))
		return Act:GetActivityData()		
	end
end

function UIActivityTurntableCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIActivityTurntableCtr:GetData()
	return self.data
end

function UIActivityTurntableCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIActivityTurntableCtr

