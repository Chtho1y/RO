local UIClimbingTowerLevelInfoCtr = class("UIClimbingTowerLevelInfoCtr", require("UICtrBase"))

local TowerDataMgr =ManagerContainer.DataMgr.TowerDataMgr


function UIClimbingTowerLevelInfoCtr:Init(view)
	self.view = view
end

function UIClimbingTowerLevelInfoCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIClimbingTowerLevelInfoCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIClimbingTowerLevelInfoCtr:GetData()
	return self.data
end

function UIClimbingTowerLevelInfoCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIClimbingTowerLevelInfoCtr:GetLevelInfo(id)
	return TowerDataMgr:FindLevelData(id)
end

return UIClimbingTowerLevelInfoCtr

