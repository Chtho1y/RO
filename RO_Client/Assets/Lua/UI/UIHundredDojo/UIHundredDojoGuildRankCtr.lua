local UIHundredDojoGuildRankCtr = class("UIHundredDojoGuildRankCtr", require("UICtrBase"))

function UIHundredDojoGuildRankCtr:Init(view)
	self.view = view
end

function UIHundredDojoGuildRankCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIHundredDojoGuildRankCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIHundredDojoGuildRankCtr:GetData()
	return self.data
end

function UIHundredDojoGuildRankCtr:OnDispose()
	self.rankDatas = nil

	self.data = nil
	self.view = nil
end

function UIHundredDojoGuildRankCtr:OnDispose()
end

function UIHundredDojoGuildRankCtr:HasGuild()
	return ManagerContainer.DataMgr.GuildDataMgr:HasGuild()
end

function UIHundredDojoGuildRankCtr:GetCurGuildData()
	return ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()
end

function UIHundredDojoGuildRankCtr:SetRankDatas(rankDatas)
	self.rankDatas = rankDatas
end

function UIHundredDojoGuildRankCtr:GetRankDatas()
	return self.rankDatas
end

function UIHundredDojoGuildRankCtr:GetRankListLength()
	if self.rankDatas then
		if self.rankDatas.cp_list then
			return #self.rankDatas.cp_list
		end
	end
	return 0
end

function UIHundredDojoGuildRankCtr:GetRankDataByItemIdx(itemIdx)
	if self.rankDatas then
		if self.rankDatas.cp_list then
			return self.rankDatas.cp_list[itemIdx + 1]
		end
	end
	return nil
end

function UIHundredDojoGuildRankCtr:GetSelfGuildCPAndRank()
	if self.rankDatas then
		if self.rankDatas then
			return self.rankDatas.self_guild_cp or 0, self.rankDatas.self_guild_rank or 0
		end
	end
	return 0, 0
end


function UIHundredDojoGuildRankCtr:SendGuildWarCPRankReq()
	if not ManagerContainer.DataMgr.GuildWarDataMgr:SendGuildWarCPRankReq() then
		return 100007
	end
	return 0
end

return UIHundredDojoGuildRankCtr

