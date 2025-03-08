local UIBigMapCtr = class("UIBigMapCtr", require("UICtrBase"))


function UIBigMapCtr:Init(view)
	self.view = view
end

--@param data table {id = integer, enterType = Enum.BigMapEnterType}   当前地图id
function UIBigMapCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UIBigMapCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIBigMapCtr:GetData()
	return self.data
end

function UIBigMapCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.mapId = nil
	self.enterType = nil
	self.curMapId = nil
	self.curLevelId = nil
end

function UIBigMapCtr:InitData()
	self.mapId = self.data and self.data.id or ManagerContainer.LuaBattleMgr:GetCurMapId()
	self.enterType = self.data and self.data.enterType or Enum.BigMapEnterType.Default
	self:RefreshLevelData()
end

function UIBigMapCtr:RefreshLevelData()
	self.curMapId, self.curLevelId = ManagerContainer.LuaBattleMgr:GetCurMapAndLevel()
end

function UIBigMapCtr:GetCurMapId()
	return self.curMapId
end

function UIBigMapCtr:GetCurLevelId()
	return self.curLevelId
end

function UIBigMapCtr:GetMapId()
	return self.mapId
end

function UIBigMapCtr:GetEnterType()
	return self.enterType
end

function UIBigMapCtr:GetMapData()
	return ManagerContainer.CfgMgr:GetMapData(self.mapId)
end

return UIBigMapCtr

