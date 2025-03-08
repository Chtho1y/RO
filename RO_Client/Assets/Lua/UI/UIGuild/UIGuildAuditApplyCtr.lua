local UIGuildAuditApplyCtr = class("UIGuildAuditApplyCtr", require("UICtrBase"))

function UIGuildAuditApplyCtr:Init(view)
	self.view = view
end

function UIGuildAuditApplyCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self.guildData = ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()
end

function UIGuildAuditApplyCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildAuditApplyCtr:GetData()
	return self.data
end

function UIGuildAuditApplyCtr:OnDispose()
	self.data = nil
	self.view = nil
	if self.guildData then
		self.guildData:ClearAuditApplyData()
	end
	self.guildData = nil
end

function UIGuildAuditApplyCtr:GetAuditApplys()
	return self.guildData:GetAuditApplys()
end

function UIGuildAuditApplyCtr:GetIsHasApply()
	return self.guildData:GetIsHasApply()
end

function UIGuildAuditApplyCtr:GetGuildMemberNum()
	return self.guildData:GetGuildMemberNum()
end

function UIGuildAuditApplyCtr:GetGuildMemberLimit()
	return self.guildData:GetGuildMemberLimit()
end

function UIGuildAuditApplyCtr:GetNextLoadAuditApplyUids()
	return self.guildData:GetNextLoadAuditApplyUids(10)
end

function UIGuildAuditApplyCtr:GetNextAuditApplyById(idx)
	return self.guildData:GetNextAuditApplyById(idx + 1)
end

function UIGuildAuditApplyCtr:GetAuditApplyNum()
	return self.guildData:GetAuditApplyNum()
end

function UIGuildAuditApplyCtr:SetAuditApplyPlayBrief(playerBriefs)
	self.guildData:SetAuditApplyPlayBrief(playerBriefs)
end

function UIGuildAuditApplyCtr:SendGetAuditApplyListReq()
	if not ManagerContainer.DataMgr.GuildDataMgr:SendGetAuditApplyListReq() then
		return 100007
	end
	return 0
end

function UIGuildAuditApplyCtr:SendGetAuditApplyInfoListReq()
	local uids = self:GetNextLoadAuditApplyUids()
	if not uids or #uids <= 0 then return false end
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_OTHER_PLAYER_BRIEF_INFO_REQ, {type=Enum.FriendTogglePageType.GuildPlayerBriefQuery, player_list=uids})
	return true
end

function UIGuildAuditApplyCtr:SendAllRefuseReq()
	local num = self:GetAuditApplyNum()
	if not num or num <= 0 then
		return 0
	end
	if self:GetGuildMemberNum() >= self:GetGuildMemberLimit() then
		return 'GuildTips_027'
	end
	if not ManagerContainer.DataMgr.GuildDataMgr:SendApplyInfoHandleReq(nil, Enum.GuildAduitApplyHandleType.AllRefuse) then
		return 100007
	end
	return 0
end

function UIGuildAuditApplyCtr:SendAllAllowReq()
	local num = self:GetAuditApplyNum()
	if not num or num <= 0 then
		return 0
	end
	if self:GetGuildMemberNum() >= self:GetGuildMemberLimit() then
		return 'GuildTips_027'
	end
	if not ManagerContainer.DataMgr.GuildDataMgr:SendApplyInfoHandleReq(nil, Enum.GuildAduitApplyHandleType.AllAllow) then
		return 100007
	end
	return 0
end

function UIGuildAuditApplyCtr:SendRefuseReq(uid)
	local apply = {key = uid, value = Enum.GuildAduitApplyType.Refuse}
	if not ManagerContainer.DataMgr.GuildDataMgr:SendApplyInfoHandleReq(apply, Enum.GuildAduitApplyHandleType.One) then
		return 100007
	end
	return 0
end

function UIGuildAuditApplyCtr:SendAllowReq(uid)
	local apply = {key = uid, value = Enum.GuildAduitApplyType.Allow}
	if not ManagerContainer.DataMgr.GuildDataMgr:SendApplyInfoHandleReq(apply, Enum.GuildAduitApplyHandleType.One) then
		return 100007
	end
	return 0
end


return UIGuildAuditApplyCtr

