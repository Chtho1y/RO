local UIWorldMapCtr = class("UIWorldMapCtr", require("UICtrBase"))

function UIWorldMapCtr:Init(view)
	self.view = view
end

---@param data nil|boolean 是否播放进入下一个区域的动画
function UIWorldMapCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
	ManagerContainer.DataMgr.BigMapData:SendGetData()
end

function UIWorldMapCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIWorldMapCtr:GetData()
	return self.data
end

function UIWorldMapCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.curMapId = nil
	self.curLevelId = nil
	self.lastMapId = nil
	self.lastLevelId = nil
end

function UIWorldMapCtr:InitData()
	self.curMapId, self.curLevelId = ManagerContainer.LuaBattleMgr:GetCurMapAndLevel()
	if self:IsChangeMap() then
		-- 找到上一个区域的最后一个关卡点
		local lastMapId = self.curMapId - 1
		local lastLevelId = 0
		local levelData = ManagerContainer.CfgMgr:GetLevelDataByMapAndLevel(lastMapId, 1)
		while levelData ~= nil do
			lastLevelId = lastLevelId + 1
			levelData = ManagerContainer.CfgMgr:GetLevelDataByMapAndLevel(lastMapId, lastLevelId + 1)
		end
		if lastLevelId > 0 then
			self.lastMapId = lastMapId
			self.lastLevelId = lastLevelId
			return
		end
		LogError("Not Find lastMapId and lastLevelId. curMapId : " .. tostring(self.curMapId) .. " curLevelId : " .. tostring(self.curLevelId))
	end
	self.data = nil
	self.lastMapId = nil
	self.lastLevelId = nil
end

function UIWorldMapCtr:IsChangeMap()
	return self.data or false
end

function UIWorldMapCtr:GetCurMapId()
	return self.curMapId
end

function UIWorldMapCtr:GetLastMapId()
	return self.lastMapId
end

function UIWorldMapCtr:GetShowMapId()
	if self:IsChangeMap() then
		return self.lastMapId
	else
		return self.curMapId
	end
end

function UIWorldMapCtr:GetShowMapName()
	if self:IsChangeMap() then
		return self:GetMapName(self.lastMapId, self.lastLevelId)
	else
		return self:GetMapName(self.curMapId, self.curLevelId)
	end
end

function UIWorldMapCtr:ClearChangeMap()
	self.data = nil
end

function UIWorldMapCtr:GetMapName(mapId, levelId)
	local levelData = ManagerContainer.CfgMgr:GetLevelDataByMapAndLevel(mapId, levelId)
	return levelData and I18N.SetLanguageValue(levelData.Name) or ''
end

function UIWorldMapCtr:GetTopRankPlayerList()
	return ManagerContainer.DataMgr.BigMapData:GetTopRankPlayerList()
end

return UIWorldMapCtr

