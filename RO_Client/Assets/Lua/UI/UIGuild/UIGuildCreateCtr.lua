local UIGuildCreateCtr = class("UIGuildCreateCtr", require("UICtrBase"))

function UIGuildCreateCtr:Init(view)
	self.view = view
end

function UIGuildCreateCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UIGuildCreateCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildCreateCtr:GetData()
	return self.data
end

function UIGuildCreateCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.nameMinLength = nil
	self.nameMaxLength = nil
	self.badgeId = nil
	self.guildName = nil
	self.costItemCfgId = nil
	self.costNum = nil
end

function UIGuildCreateCtr:IsInGuild()
	return false
end

function UIGuildCreateCtr:InitData()
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

	self.badgeId = GlobalConfig.Instance:GetConfigIntValue(217)
	self.costItemCfgId = 1
	self.costNum = 100
	local costStr = GlobalConfig.Instance:GetConfigStrValue(210)
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

function UIGuildCreateCtr:GetBadgeId()
	return self.badgeId
end

function UIGuildCreateCtr:SetBadgeId(badgeId)
	if self.badgeId == badgeId then
		return false
	end
	self.badgeId = badgeId
	return true
end

function UIGuildCreateCtr:GetGuildName()
	return self.guildName or ''
end

function UIGuildCreateCtr:SetGuildName(guildName)
	if self.guildName == guildName then
		return false
	end
	self.guildName = guildName
	return true
end

function UIGuildCreateCtr:GetCostInfo()
	return self.costItemCfgId, self.costNum
end

function UIGuildCreateCtr:GetNameLengthMin()
	return self.nameMinLength
end

function UIGuildCreateCtr:GetNameLengthMax()
	return self.nameMaxLength
end

function UIGuildCreateCtr:GetOwnResCountByItemId(itemCfgId)
	return CommonUtil.GetOwnResCountByItemId(itemCfgId)
end

function UIGuildCreateCtr:SendCreateGuildReq()
	if not self.guildName then
		return 523
	end
	local len = GetActualStringLength(self.guildName)
	local min = self:GetNameLengthMin()
	local max = self:GetNameLengthMax()
	if len < min or len > max then
		return 522
	end
	if not SDKMgr.Instance:CheckName(self.guildName) then
		return 'ShieldTips02'
	end
	if CommonUtil.GetOwnResCountByItemId(self.costItemCfgId) < self.costNum then
		return 514
	end
	if not ManagerContainer.DataMgr.GuildDataMgr:SendBuildGuildReq(self.guildName, self.badgeId) then
		return 100007
	end
	return 0
end

return UIGuildCreateCtr

