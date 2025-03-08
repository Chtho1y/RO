local UIDojoRewardCtr = class("UIDojoRewardCtr", require("UICtrBase"))

function UIDojoRewardCtr:Init(view)
	self.view = view
end

function UIDojoRewardCtr:SetData(data)
	self.asyncIdx = 0
	self:InitRankRewardData()
	if data == nil then return end
	self.data = data
end

function UIDojoRewardCtr:InitDanRewardData()
	if self.data ~= nil then

	end
end

function UIDojoRewardCtr:InitRankRewardData()
	self.rankRewardList = ManagerContainer.DataMgr.ArenaData:GetDanRankReward()
end

function UIDojoRewardCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIDojoRewardCtr:GetData()
	return self.data
end

function UIDojoRewardCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIDojoRewardCtr

