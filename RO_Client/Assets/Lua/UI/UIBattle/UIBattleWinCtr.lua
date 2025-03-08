local UIBattleWinCtr = class("UIBattleWinCtr", require("UICtrBase"))

function UIBattleWinCtr:Init(view)
	self.view = view
end

function UIBattleWinCtr:SetData(data)
	self.asyncIdx = 0
	self:InitData()
	if data == nil then return end
	self.data = data
end

function UIBattleWinCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIBattleWinCtr:GetData()
	return self.data
end

function UIBattleWinCtr:OnDispose()
	self.data = nil
	self.view = nil

	self.curMapId = nil
	self.curLevelId = nil
	self.lastLevelUniqueId = nil
	self.levelCfgData = nil
end

function UIBattleWinCtr:InitData()
	self.curMapId, self.curLevelId = ManagerContainer.LuaBattleMgr:GetCurMapAndLevel()
	self.curLevelId = self.curLevelId - 1
	self.lastLevelUniqueId = ManagerContainer.LuaBattleMgr:GetLastLevelUniqueId()
	self.levelCfgData = ManagerContainer.CfgMgr:GetLevelDataById(self.lastLevelUniqueId)
end

function UIBattleWinCtr:GetCurMapAndLevel()
	return self.curMapId, self.curLevelId
end

function UIBattleWinCtr:GetCurLevelUniqueId()
	return self.lastLevelUniqueId
end

function UIBattleWinCtr:GetLevelCfgData()
	return self.levelCfgData
end

return UIBattleWinCtr

