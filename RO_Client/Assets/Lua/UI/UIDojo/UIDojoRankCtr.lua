local UIDojoRankCtr = class("UIDojoRankCtr", require("UICtrBase"))

function UIDojoRankCtr:Init(view)
	self.view = view
	self._index = 1;
end

function UIDojoRankCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIDojoRankCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIDojoRankCtr:GetData()
	return self.data
end

function UIDojoRankCtr:OnDispose()
	self.data = nil
	self.view = nil
	self._index = nil
end

function UIDojoRankCtr:ResetIndex()
	self._index = 1;
end

function UIDojoRankCtr:RequireRankData(_rankType)
	self._index = self._index + 1;
	if self._index > Constant.MaxRankIndex then return; end
	ManagerContainer.DataMgr.ArenaData:SendArenaRankReq(_rankType, self._index)
end

return UIDojoRankCtr

