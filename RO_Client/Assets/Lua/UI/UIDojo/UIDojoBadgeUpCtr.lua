local UIDojoBadgeUpCtr = class("UIDojoBadgeUpCtr", require("UICtrBase"))

function UIDojoBadgeUpCtr:Init(view)
	self.view = view
end

function UIDojoBadgeUpCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIDojoBadgeUpCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIDojoBadgeUpCtr:GetData()
	return self.data
end

function UIDojoBadgeUpCtr:OnDispose()
	self.data = nil
	self.view = nil
end

--获取当前等级的数据
function UIDojoBadgeUpCtr:GetCurArenaLevelData()
	local _curDanScore = ManagerContainer.DataMgr.ArenaData.danScore;
	local _data = self:GetArenaLevelData(_curDanScore);
	return _data
end

--获取上一个等级的数据
function UIDojoBadgeUpCtr:GetLastArenaLevelData()
	local _lastDanScore = ManagerContainer.DataMgr.ArenaData.lastDanScore;
	local _data = self:GetArenaLevelData(_lastDanScore);
	return _data;
end

--根据积分获取英灵殿等级的表格信息
function UIDojoBadgeUpCtr:GetArenaLevelData(_danScore)
	if _danScore > 0 then
		local _levelCfg, _ = CommonUtil.GetCurDunData(_danScore);
		return _levelCfg;
	end
	return nil;
end

return UIDojoBadgeUpCtr

