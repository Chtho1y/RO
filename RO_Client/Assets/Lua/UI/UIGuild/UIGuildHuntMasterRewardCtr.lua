local UIGuildHuntMasterRewardCtr = class("UIGuildHuntMasterRewardCtr", require("UICtrBase"))

function UIGuildHuntMasterRewardCtr:Init(view)
	self.view = view
end

function UIGuildHuntMasterRewardCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UIGuildHuntMasterRewardCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildHuntMasterRewardCtr:GetData()
	return self.data
end

function UIGuildHuntMasterRewardCtr:OnDispose()
	if self.guildData then
		self.guildData:ClearHuntBossMasterReward(self:GetBossId())
	end
	self.guildData = nil

	self.data = nil
	self.view = nil
end

function UIGuildHuntMasterRewardCtr:InitData()
	self.guildData = ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()
end

function UIGuildHuntMasterRewardCtr:GetBossId()
	return self.data
end

function UIGuildHuntMasterRewardCtr:GetAwardData()
	return self.guildData:GetHuntBossMasterReward(self:GetBossId())
end




function UIGuildHuntMasterRewardCtr:SendGuildMasterRewardReq()
	if not ManagerContainer.DataMgr.GuildDataMgr:SendGuildMasterRewardReq(self:GetBossId()) then
		return 100007
	end
	return 0
end


return UIGuildHuntMasterRewardCtr

