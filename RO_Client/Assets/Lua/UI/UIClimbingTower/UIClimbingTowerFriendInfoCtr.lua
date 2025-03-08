local UIClimbingTowerFriendInfoCtr = class("UIClimbingTowerFriendInfoCtr", require("UICtrBase"))

local TowerDataMgr =ManagerContainer.DataMgr.TowerDataMgr


function UIClimbingTowerFriendInfoCtr:Init(view)
	self.view = view
end

function UIClimbingTowerFriendInfoCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIClimbingTowerFriendInfoCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIClimbingTowerFriendInfoCtr:GetData()
	return self.data
end

function UIClimbingTowerFriendInfoCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIClimbingTowerFriendInfoCtr:GetLevelInfo(id)
	return TowerDataMgr:FindLevelData(id)
end


return UIClimbingTowerFriendInfoCtr

