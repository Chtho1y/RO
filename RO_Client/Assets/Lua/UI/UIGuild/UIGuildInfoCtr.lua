local UIGuildInfoCtr = class("UIGuildInfoCtr", require("UICtrBase"))

function UIGuildInfoCtr:Init(view)
	self.view = view
end

function UIGuildInfoCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self.guildData = nil
end

function UIGuildInfoCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildInfoCtr:GetData()
	return self.data
end

function UIGuildInfoCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.guildData = nil
	ManagerContainer.DataMgr.GuildDataMgr:ClearCheckGuildData()
end

function UIGuildInfoCtr:IsInGuild()
	return ManagerContainer.DataMgr.GuildDataMgr:HasGuild()
end

function UIGuildInfoCtr:GetId()
	return self.data or 0
end

function UIGuildInfoCtr:RefreshGuildData()
	local guildData = ManagerContainer.DataMgr.GuildDataMgr:GetCheckGuildData()
	local brief = guildData:GetBriefData()
	if brief then
		if self:GetId() == brief.id then
			self.guildData = guildData
			return true
		end
	end
	return false
end

function UIGuildInfoCtr:GetGuildData()
	return self.guildData
end

function UIGuildInfoCtr:GetGuildBriefData()
	return self.guildData and self.guildData:GetBriefData() or nil
end

function UIGuildInfoCtr:GetGuildMoreInfoData()
	return self.guildData and self.guildData:GetBaseData() or nil
end

function UIGuildInfoCtr:GetGuildMemberNum()
	return self.guildData and self.guildData:GetGuildMemberNum() or 0
end

function UIGuildInfoCtr:GetGuildMemberLimit()
	return self.guildData and self.guildData:GetGuildMemberLimit() or 0
end

function UIGuildInfoCtr:GetNextLoadMemberUids()
	return self.guildData and self.guildData:GetNextLoadMemberUid(10) or nil
end

function UIGuildInfoCtr:GetValidMemberNum()
	return self.guildData and self.guildData:GetValidMemberNum() or 0
end

function UIGuildInfoCtr:GetMemberMoreInfoByItemidx(itemIdx)
	return self.guildData and self.guildData:GetMemberMoreInfoByidx(itemIdx + 1) or nil
end

function UIGuildInfoCtr:GetMemberMoreInfoByUid(uid)
	return self.guildData and self.guildData:GetMemberMoreInfoByUid(uid) or nil
end

function UIGuildInfoCtr:GetIsSubmitApply()
	return self.guildData and self.guildData:GetIsSubmitApply() or false
end

function UIGuildInfoCtr:GetNextCDTime()
	local guildData = ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()
	return guildData and guildData:GetNextCDTime() or nil
end


function UIGuildInfoCtr:SendGetGuildMoreInfoReq()
	if not ManagerContainer.DataMgr.GuildDataMgr:SendGetGuildMoreInfoReq(self:GetId()) then
		return 100007
	end
	return 0
end

function UIGuildInfoCtr:SendGetGuildMemberInfoReq()
	local uids = self:GetNextLoadMemberUids(10)
	if not uids or #uids == 0 then
		return 1
	end
	if not ManagerContainer.DataMgr.GuildDataMgr:SendGetGuildMemberInfoReq(self:GetId(), uids) then
		return 100007
	end
	return 0
end

function UIGuildInfoCtr:SendSubmitApplyReq()
	if not ManagerContainer.DataMgr.GuildDataMgr:SendGuildApplyReq(self:GetId(), true) then
		return 100007
	end
	return 0
end

function UIGuildInfoCtr:SendCancelApplyReq()
	if not ManagerContainer.DataMgr.GuildDataMgr:SendGuildApplyReq(self:GetId(), false) then
		return 100007
	end
	return 0
end

return UIGuildInfoCtr

