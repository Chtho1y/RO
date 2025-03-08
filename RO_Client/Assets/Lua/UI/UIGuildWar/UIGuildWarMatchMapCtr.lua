local UIGuildWarMatchMapCtr = class("UIGuildWarMatchMapCtr", require("UICtrBase"))

function UIGuildWarMatchMapCtr:Init(view)
	self.view = view
end

function UIGuildWarMatchMapCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIGuildWarMatchMapCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildWarMatchMapCtr:GetData()
	return self.data
end

function UIGuildWarMatchMapCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIGuildWarMatchMapCtr:GetMatchMapData()
	return ManagerContainer.DataMgr.GuildWarDataMgr:GetMatchMapData()
end

function UIGuildWarMatchMapCtr:IsSameGuild(guildId)
	local guildData = ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()
	if guildData then
		return guildData:IsSameGuild(guildId)
	end
	return false
end




function UIGuildWarMatchMapCtr:SendGetGuildWarMatchMapReq()
	if ManagerContainer.DataMgr.GuildWarDataMgr:SendGetGuildWarMatchMapReq() then
		return 100007
	end
	return 0
end


return UIGuildWarMatchMapCtr

