local UIGuildMainCtr = class("UIGuildMainCtr", require("UICtrBase"))

function UIGuildMainCtr:Init(view)
	self.view = view
end

function UIGuildMainCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UIGuildMainCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildMainCtr:GetData()
	return self.data
end

function UIGuildMainCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.enterGuildCD = nil
	self.noticeMaxLength = nil
	self.activeDayLimit = nil
	self.guildData = nil
	self.changedNotice = nil
end

function UIGuildMainCtr:InitData()
	local cdMap = {}
	local cdInfoStr = GlobalConfig.Instance:GetConfigStrValue(201)
	if cdInfoStr then
		local cdInfoArr = string.split(cdInfoStr, ';')
		for _, cdInfo in pairs(cdInfoArr) do
			local cdArr = string.split(cdInfo, ':')
			if cdArr and #cdArr >= 2 then
				local num = tonumber(cdArr[1])
				local hour = tonumber(cdArr[2])
				cdMap[num] = hour
			end
		end
	end
	self.enterGuildCD = cdMap

	self.noticeMaxLength = GlobalConfig.Instance:GetConfigIntValue(215)
	self.activeDayLimit = GlobalConfig.Instance:GetConfigIntValue(197)
	self.guildData = ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()

	self.changedNotice = self:GetCurNotice()
end

function UIGuildMainCtr:GetEnterGuildCD()
	local roleData = self:GetRoleData()
	local quitNum = roleData and roleData.quitNum or 1
	quitNum = quitNum + 1
	local cdtime = nil
	while not cdtime and quitNum > 0 do
		cdtime = self.enterGuildCD[quitNum]
		quitNum = quitNum - 1
	end
	return cdtime
end

function UIGuildMainCtr:GetNoticeLengthMax()
	return self.noticeMaxLength
end

function UIGuildMainCtr:GetActiveDayLimit()
	return self.activeDayLimit
end

function UIGuildMainCtr:GetGuildData()
	return self.guildData
end

function UIGuildMainCtr:GetGuildBriefData()
	return self.guildData:GetBriefData()
end

function UIGuildMainCtr:GetGuildMoreInfoData()
	return self.guildData:GetBaseData()
end

function UIGuildMainCtr:GetRoleData()
	return self.guildData:GetRoleData()
end

function UIGuildMainCtr:GetGuildMemberNum()
	return self.guildData:GetGuildMemberNum()
end

function UIGuildMainCtr:GetGuildMemberLimit()
	return self.guildData:GetGuildMemberLimit()
end

function UIGuildMainCtr:GetValidMemberNum()
	return self.guildData:GetValidMemberNum()
end

function UIGuildMainCtr:GetNeedLoadMemberMoreInfo(startIdx, endIdx)
	return self.guildData:GetNeedLoadMemberMoreInfo(startIdx + 1, endIdx + 1)
end

function UIGuildMainCtr:GetNextLoadMemberUids()
	return self.guildData:GetNextLoadMemberUid(10)
end

function UIGuildMainCtr:GetMemberMoreInfoByItemidx(itemIdx)
	return self.guildData:GetMemberMoreInfoByidx(itemIdx + 1)
end

function UIGuildMainCtr:GetMemberMoreInfoByUid(uid)
	return self.guildData:GetMemberMoreInfoByUid(uid)
end

function UIGuildMainCtr:GetGuildMemberPost(uid)
	return self.guildData:GetGuildMemberPost(uid)
end

function UIGuildMainCtr:GetIsHasApply()
	return self.guildData:GetIsHasApply()
end

function UIGuildMainCtr:GetId()
	local brief = self.guildData:GetBriefData()
	return brief and brief.id or 0
end

function UIGuildMainCtr:GetGuildPostType()
	return self:GetGuildMemberPost(ManagerContainer.DataMgr.UserData:GetUserId())
end

function UIGuildMainCtr:GetCurNotice()
	local moreInfo = self:GetGuildMoreInfoData()
	if not moreInfo then return '' end
	return tostring(moreInfo.notice)
end

function UIGuildMainCtr:SetChangeNotice(newNotice)
	self.changedNotice = newNotice
end

function UIGuildMainCtr:GetGuildWarInfo()
	return self.guildData:GetGuildWarInfo()
end











function UIGuildMainCtr:SendGetGuildMemberInfoReq(uids)
	if not uids or #uids == 0 then
		return 0
	end
	if not ManagerContainer.DataMgr.GuildDataMgr:SendGetGuildMemberInfoReq(self:GetId(), uids) then
		return 100007
	end
	return 0
end

function UIGuildMainCtr:SendGetGuildInfoReq()
	if not ManagerContainer.DataMgr.GuildDataMgr:SendGetGuildSelfInfoReq(self:GetId()) then
		return 100007
	end
	return 0
end

function UIGuildMainCtr:SendChangeNoticeReq()
	if self.changedNotice == self:GetCurNotice() then
		return 0
	end
	local level = ManagerContainer.DataMgr.UserData:GetRoleLv()
	if not SDKMgr.Instance:CheckSpeech(level, ChannelType.GUILD_NOTICE, self.changedNotice) then
		return 'ShieldTips01'
	end
	if not ManagerContainer.DataMgr.GuildDataMgr:SendChangeNoticeReq(self.changedNotice) then
		return 100007
	end
	return 0
end


function UIGuildMainCtr:SendApplyInfoHandleReq()
	if not ManagerContainer.DataMgr.GuildDataMgr:SendApplyInfoHandleReq(self:GetId()) then
		return 100007
	end
	return 0
end

function UIGuildMainCtr:SendSetGuildInfoReq()
	if not ManagerContainer.DataMgr.GuildDataMgr:SendSetGuildInfoReq(self:GetId()) then
		return 100007
	end
	return 0
end

function UIGuildMainCtr:SendDisbandGuildReq()
	if not ManagerContainer.DataMgr.GuildDataMgr:SendDisbandGuildReq() then
		return 100007
	end
	return 0
end

function UIGuildMainCtr:SendQuitGuildReq()
	if not ManagerContainer.DataMgr.GuildDataMgr:SendQuitGuildReq() then
		return 100007
	end
	return 0
end




function UIGuildMainCtr:SendChangeMemberTitleReq(uid, post)
	if not ManagerContainer.DataMgr.GuildDataMgr:SendChangeMemberTitleReq(uid, post) then
		return 100007
	end
	return 0
end

function UIGuildMainCtr:SendKickGuildMemeberReq(uid)
	if not ManagerContainer.DataMgr.GuildDataMgr:SendKickGuildMemeberReq(uid) then
		return 100007
	end
	return 0
end

function UIGuildMainCtr:SendGetGuildWarMatchMapReq()
	ManagerContainer.DataMgr.GuildWarDataMgr:SendGetGuildWarMatchMapReq()
end


return UIGuildMainCtr

