local UIGuildSettingsCtr = class("UIGuildSettingsCtr", require("UICtrBase"))

function UIGuildSettingsCtr:Init(view)
	self.view = view
end

function UIGuildSettingsCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UIGuildSettingsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildSettingsCtr:GetData()
	return self.data
end

function UIGuildSettingsCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.guildData = nil
	self.changeBadge = nil
	self.minRecuritLevel = nil
	self.maxRecuritLevel = nil
	self.changeRecuritLevel = nil
	self.changeRecuritNotice = nil
	self.recuritNoticeMaxLength = nil
	self.costItemCfgId = nil
	self.costNum = nil
end

function UIGuildSettingsCtr:InitData()
	self.guildData = ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()
	self.changeBadge = nil
	self.changeRecuritType = nil
	self.changeRecuritLevel = nil
	self.changeRecuritNotice = nil
	if self.guildData then
		local briefData = self.guildData:GetBriefData()
		if briefData then
			self.changeBadge = briefData.badge
		end
		local baseData = self.guildData:GetBaseData()
		if baseData then
			self.changeRecuritType = baseData.recuritType
			self.changeRecuritLevel = baseData.recuritLevel
			self.changeRecuritNotice = baseData.recruitNotice
		end
	end

	self.minRecuritLevel = 0
	self.maxRecuritLevel = 0
	local cfgStr = GlobalConfig.Instance:GetConfigStrValue(195)
	if cfgStr then
		local arr = string.split(cfgStr, ':')
		if arr then
			self.minRecuritLevel = (arr[1] and tonumber(arr[1]) or 0)
			self.maxRecuritLevel = (arr[2] and tonumber(arr[2]) or 0)
		end
	end

	if not self.changeBadge then
		self.changeBadge = GlobalConfig.Instance:GetConfigIntValue(217)
	end
	if not self.changeRecuritType then
		self.changeRecuritType = Enum.GuildEnterVerifyType.NeedVerify
	end
	if not self.changeRecuritLevel then
		self.changeRecuritLevel = self.minRecuritLevel
	end
	if not self.changeRecuritNotice then
		self.changeRecuritNotice = ''
	end
	self.recuritNoticeMaxLength = GlobalConfig.Instance:GetConfigIntValue(216)

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

function UIGuildSettingsCtr:GetRecuritNoticeMaxLength()
	return self.recuritNoticeMaxLength
end

function UIGuildSettingsCtr:GetRecuritNotice()
	return self.changeRecuritNotice
end

function UIGuildSettingsCtr:SetRecuritNotice(newNotice)
	self.changeRecuritNotice = newNotice
end

function UIGuildSettingsCtr:GetCurName()
	if self.guildData then
		local briefData = self.guildData:GetBriefData()
		return briefData and briefData.name or ''
	end
	return ''
end

function UIGuildSettingsCtr:GetCurBadgeResPath()
	if self.changeBadge then
		local badgeCfgData = ManagerContainer.CfgMgr:GetGuildBadgeCfgById(self.changeBadge)
        if badgeCfgData then
            return badgeCfgData.Pic
        end
	end
	return ''
end

function UIGuildSettingsCtr:GetBadge()
	return self.changeBadge
end

function UIGuildSettingsCtr:SetBadge(badge)
	if self.changeBadge == badge then
		return false
	end
	self.changeBadge = badge
	return true
end

function UIGuildSettingsCtr:GetRecuritType()
	return self.changeRecuritType
end

function UIGuildSettingsCtr:SetRecuritType(recuritType)
	if self.changeRecuritType == recuritType then
		return false
	end
	self.changeRecuritType = recuritType
	return true
end

function UIGuildSettingsCtr:GetRecuritLevel()
	return self.changeRecuritLevel
end

function UIGuildSettingsCtr:SetRecuritLevel(recuritLevel)
	self.changeRecuritLevel = recuritLevel
end

function UIGuildSettingsCtr:GetRecuritLevelLimit()
	return self.minRecuritLevel, self.maxRecuritLevel
end

function UIGuildSettingsCtr:GetCostInfo()
	return self.costItemCfgId, self.costNum
end

function UIGuildSettingsCtr:HasChanged()
	local isChanged = false
	if self.guildData then
		local briefData = self.guildData:GetBriefData()
		if briefData then
			if self.changeBadge ~= briefData.badge then
				isChanged = true
			end
		end
		local baseData = self.guildData:GetBaseData()
		if baseData then
			if self.changeRecuritType ~= baseData.recuritType then
				isChanged = true
			end
			if self.changeRecuritLevel ~= baseData.recuritLevel then
				isChanged = true
			end
			if self.changeRecuritNotice ~= baseData.recruitNotice then
				isChanged = true
			end
		end
	end
	return isChanged
end

function UIGuildSettingsCtr:SendGuildSettingsReq()
	if not self:HasChanged() then
		return 0
	end
	local level = ManagerContainer.DataMgr.UserData:GetRoleLv()
	if not SDKMgr.Instance:CheckSpeech(level, ChannelType.GUILD_RECRUIT, self.changeRecuritNotice) then
		return 'ShieldTips01'
	end
	if not ManagerContainer.DataMgr.GuildDataMgr:SendSetGuildInfoReq(self.changeBadge, self.changeRecuritType, self.changeRecuritLevel, self.changeRecuritNotice) then
		return 100007
	end
	return 0
end


return UIGuildSettingsCtr

