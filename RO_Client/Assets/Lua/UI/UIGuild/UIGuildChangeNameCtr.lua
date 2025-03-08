local UIGuildChangeNameCtr = class("UIGuildChangeNameCtr", require("UICtrBase"))

function UIGuildChangeNameCtr:Init(view)
	self.view = view
end

function UIGuildChangeNameCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UIGuildChangeNameCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildChangeNameCtr:GetData()
	return self.data
end

function UIGuildChangeNameCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.nameMinLength = nil
	self.nameMaxLength = nil
	self.guildData = nil
	self.changedName = nil
	self.costItemCfgId = nil
	self.costNum = nil
end

function UIGuildChangeNameCtr:InitData()
	self.nameMinLength = 1
	self.nameMaxLength = 8
	local nameLimitStr = GlobalConfig.Instance:GetConfigStrValue(213)
	if nameLimitStr then
		local nameLimitArr = string.split(nameLimitStr, ':')
		if nameLimitArr and #nameLimitArr >= 2 then
			self.nameMinLength = tonumber(nameLimitArr[1])
			self.nameMaxLength = tonumber(nameLimitArr[2])
		end
	end
	self.guildData = ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()
	self.changedName = self:GetCurName()

	self.costItemCfgId = 2
	self.costNum = 100
	local costStr = GlobalConfig.Instance:GetConfigStrValue(220)
	if costStr then
		local costStrArr = string.split(costStr, ':')
		if costStrArr then
			if costStrArr[1] then
				self.costItemCfgId = tonumber(costStrArr[1])
			end
			if costStrArr[2] then
				self.costNum = tonumber(costStrArr[2])
			end
		end
	end
end

function UIGuildChangeNameCtr:GetNameLengthMin()
	return self.nameMinLength
end

function UIGuildChangeNameCtr:GetNameLengthMax()
	return self.nameMaxLength
end

function UIGuildChangeNameCtr:GetCurName()
	if self.guildData then
		local briefData = self.guildData:GetBriefData()
		return briefData and briefData.name or ''
	end
	return ''
end

function UIGuildChangeNameCtr:SetChangedName(newName)
	self.changedName = newName
end

function UIGuildChangeNameCtr:GetCostInfo()
	return self.costItemCfgId, self.costNum
end




function UIGuildChangeNameCtr:SendGuildChangeNameReq()
	if self:GetCurName() == self.changedName then
		return 588
	end
	if not self.changedName then
		return 523
	end
	local len = GetActualStringLength(self.changedName)
	local min = self:GetNameLengthMin()
	local max = self:GetNameLengthMax()
	if len < min or len > max then
		return 522
	end
	if not SDKMgr.Instance:CheckName(self.changedName) then
		return 'ShieldTips02'
	end
	if CommonUtil.GetOwnResCountByItemId(self.costItemCfgId) < self.costNum then
		return 514
	end
	if not ManagerContainer.DataMgr.GuildDataMgr:SendGuildChangeNameReq(self.changedName) then
		return 100007
	end
	return 0
end

return UIGuildChangeNameCtr

