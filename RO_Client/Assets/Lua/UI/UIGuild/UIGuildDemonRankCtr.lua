local UIGuildDemonRankCtr = class("UIGuildDemonRankCtr", require("UICtrBase"))

function UIGuildDemonRankCtr:Init(view)
	self.view = view
end

function UIGuildDemonRankCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
	self.selectPageType = 1
end

function UIGuildDemonRankCtr:GetPageType()
	return self.selectPageType
end


function UIGuildDemonRankCtr:SetPageType(PageType)
	if self.selectPageType == PageType then
		return false
	end
	self.selectPageType = PageType
	return true
end

function UIGuildDemonRankCtr:GetShowData()
	local showData = {}
	if self.selectPageType == 1 then
		showData = ManagerContainer.DataMgr.GuildDemonData:GetGuildInfos()
	elseif self.selectPageType == 2 then
		showData = ManagerContainer.DataMgr.GuildDemonData:GetGuildMvpInfos()
	end
	return showData
end

function UIGuildDemonRankCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildDemonRankCtr:GetData()
	return self.data
end

function UIGuildDemonRankCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIGuildDemonRankCtr

