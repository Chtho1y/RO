local UIGuildChangeBadgeCtr = class("UIGuildChangeBadgeCtr", require("UICtrBase"))

function UIGuildChangeBadgeCtr:Init(view)
	self.view = view
end

---@param data table 数据结构为｛badgeId, owner, ownerCB｝
function UIGuildChangeBadgeCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UIGuildChangeBadgeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildChangeBadgeCtr:GetData()
	return self.data
end

function UIGuildChangeBadgeCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.defaultBadgeId = nil
	self.curBadgeId = nil
	self.badgeCfgs = nil
end

function UIGuildChangeBadgeCtr:InitData()
	local curBadgeId = nil
	local badgeId = nil
	if self.data then
		badgeId = self.data[1]
	end
	local badgeCfgs = ManagerContainer.CfgMgr:GetGuildBadgeCfg()
	local ls = {}
	for id, cfg in pairs(badgeCfgs) do
		ls[#ls + 1] = cfg
		if badgeId == id then
			curBadgeId = badgeId
		end
	end

	table.sort(ls, function(a, b)
		return a.Id < b.Id
	end)
	self.badgeCfgs = ls
	if not curBadgeId then
		curBadgeId = ls[1].Id
	end
	self.defaultBadgeId = badgeId
	self.curBadgeId = curBadgeId
end

function UIGuildChangeBadgeCtr:GetDefaultBadgeId()
	return self.defaultBadgeId
end

function UIGuildChangeBadgeCtr:GetCurBadgeId()
	return self.curBadgeId
end

function UIGuildChangeBadgeCtr:SetCurBadgeId(badgeId)
	if self.curBadgeId == badgeId then
		return false
	end
	self.curBadgeId = badgeId
	return true
end

function UIGuildChangeBadgeCtr:GetBadgeCfgs()
	return self.badgeCfgs
end

function UIGuildChangeBadgeCtr:OnExitGuildBadge(save)
	if save then
		local isChanged = (self.defaultBadgeId ~= self.curBadgeId)
		self:TriggerCallback(self.curBadgeId, isChanged)
	else
		self:TriggerCallback(self.defaultBadgeId, false)
	end
end

function UIGuildChangeBadgeCtr:TriggerCallback(badgeId, isChanged)
	local owner = nil
	local ownerCB = nil
	if self.data then
		owner = self.data[2]
		ownerCB = self.data[3]
	end
	if ownerCB then
		if owner then
			ownerCB(owner, badgeId, isChanged)
		else
			ownerCB(badgeId, isChanged)
		end
	end
end

return UIGuildChangeBadgeCtr

