local UIGuildRecommendCtr = class("UIGuildRecommendCtr", require("UICtrBase"))

function UIGuildRecommendCtr:Init(view)
	self.view = view
end

function UIGuildRecommendCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UIGuildRecommendCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildRecommendCtr:GetData()
	return self.data
end

function UIGuildRecommendCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.nameMinLength = nil
	self.nameMaxLength = nil
	self.showDatas = nil
	if ManagerContainer.DataMgr.GuildDataMgr then
		ManagerContainer.DataMgr.GuildDataMgr:ClearSearchGuildDatas()
		ManagerContainer.DataMgr.GuildDataMgr:ClearRecommendGuildDatas()
	end
end

function UIGuildRecommendCtr:InitData()
	self.nameMinLength = 1
	self.nameMaxLength = 8
	local nameLimitStr = GlobalConfig.Instance:GetConfigStrValue(212)
	if nameLimitStr then
		local nameLimitArr = string.split(nameLimitStr, ':')
		if nameLimitArr and #nameLimitArr >= 2 then
			self.nameMinLength = tonumber(nameLimitArr[1])
			self.nameMaxLength = tonumber(nameLimitArr[2])
		end
	end
end

function UIGuildRecommendCtr:GetNameLengthMin()
	return self.nameMinLength
end

function UIGuildRecommendCtr:GetNameLengthMax()
	return self.nameMaxLength
end

function UIGuildRecommendCtr:IsInGuild()
	return ManagerContainer.DataMgr.GuildDataMgr:HasGuild()
end

function UIGuildRecommendCtr:ClearSearchList(searchString)
	ManagerContainer.DataMgr.GuildDataMgr:ResetSearchGuildDatas(searchString)
end

function UIGuildRecommendCtr:GetSearchList()
	return ManagerContainer.DataMgr.GuildDataMgr:GetSearchGuildDatas()
end

function UIGuildRecommendCtr:RefreshShowDatas(dataType)
	if dataType == 1 then
		self.showDatas = ManagerContainer.DataMgr.GuildDataMgr:GetRecommendGuildDatas()
	elseif dataType == 2 then
		self.showDatas = ManagerContainer.DataMgr.GuildDataMgr:GetSearchGuildDatas()
	else
		self.showDatas = nil
	end
end

function UIGuildRecommendCtr:GetShowDatas()
	return self.showDatas
end

function UIGuildRecommendCtr:GetShowDataByItemIndex(itemIndex)
	return self.showDatas and self.showDatas[itemIndex + 1] or nil
end











function UIGuildRecommendCtr:SendGetRecommendListReq()
	if not ManagerContainer.DataMgr.GuildDataMgr:SendGetRecommendListReq() then
		return 100007
	end
	return 0
end

function UIGuildRecommendCtr:SendSearchGuildReq(text)
	if not ManagerContainer.DataMgr.GuildDataMgr:SendSearchGuildReq(text) then
		return 100007
	end
	return 0
end


return UIGuildRecommendCtr

