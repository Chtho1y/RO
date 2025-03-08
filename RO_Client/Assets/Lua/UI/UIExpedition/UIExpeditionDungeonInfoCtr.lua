local UIExpeditionDungeonInfoCtr = class("UIExpeditionDungeonInfoCtr", require("UICtrBase"))

function UIExpeditionDungeonInfoCtr:Init(view)
	self.view = view
end

function UIExpeditionDungeonInfoCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
	self:RefreshMapData()
end

function UIExpeditionDungeonInfoCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIExpeditionDungeonInfoCtr:GetData()
	return self.data
end

function UIExpeditionDungeonInfoCtr:RefreshMapData()
	self.mapData = ManagerContainer.DataMgr.ExpeditionDataMgr:FindMapByTypeId(self.data)
end

function UIExpeditionDungeonInfoCtr:GetMapData()
	return self.mapData
end

function UIExpeditionDungeonInfoCtr:GetCurLevelId()
	local curLevelId = ManagerContainer.DataMgr.ExpeditionDataMgr:GetCurLevelId()
	local mapData = self:GetMapData()
	if mapData.isPassed then
		curLevelId = mapData.maxLevelNum
	end
	return curLevelId
end

function UIExpeditionDungeonInfoCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.mapData = nil
end

return UIExpeditionDungeonInfoCtr

