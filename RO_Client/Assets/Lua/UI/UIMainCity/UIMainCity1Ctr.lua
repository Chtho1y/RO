local UIMainCity1Ctr = class("UIMainCity1Ctr", require("UICtrBase"))

function UIMainCity1Ctr:Init(view)
	self.view = view
end

function UIMainCity1Ctr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIMainCity1Ctr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIMainCity1Ctr:GetData()
	return self.data
end

function UIMainCity1Ctr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIMainCity1Ctr:HasWorldBossList()
	return ManagerContainer.DataMgr.WorldBossData:HasWorldBossList()
end

function UIMainCity1Ctr:SendWorldBossListReq()
	ManagerContainer.DataMgr.WorldBossData:SendWorldBossListRequest()
end

return UIMainCity1Ctr

