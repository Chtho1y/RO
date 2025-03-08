local UIVipCtr = class("UIVipCtr", require("UICtrBase"))

function UIVipCtr:Init(view)
	self.view = view
end

function UIVipCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UIVipCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIVipCtr:GetData()
	return self.data
end

function UIVipCtr:OnDispose()
	self.data = nil
	self.view = nil

	self.curShowVipLv = nil
	self.showCustomerVipLv = nil
	self.lockedVipLv = nil
end

function UIVipCtr:InitData()
	local curVipLv = self:GetCurVipLv()
	if self.data then
		self.curShowVipLv = self.data
	else
		if curVipLv <= 0 then
			self.curShowVipLv = 1
		else
			self.curShowVipLv = curVipLv
		end
	end
	self.showCustomerVipLv = GlobalConfig.Instance:GetConfigIntValue(319)
end

function UIVipCtr:GetCurVipLv()
	return ManagerContainer.DataMgr.UserData:GetVipLv()
end

function UIVipCtr:GetCurVipExp()
	return ManagerContainer.DataMgr.UserData:GetVipExp()
end

function UIVipCtr:GetCurShowVipLv()
	return self.curShowVipLv
end

function UIVipCtr:ChangeCurShowVipLv(next)
	if next then
		if self:HasNext() then
			self.curShowVipLv = self.curShowVipLv + 1
			return true
		end
	else
		if self:HasPrev() then
			self.curShowVipLv = self.curShowVipLv - 1
			return true
		end
	end
	return false
end

function UIVipCtr:HasPrev()
	local prevLv = self.curShowVipLv - 1
	if prevLv <= 0 then return false end
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(prevLv)
	if vipCfg then
		return true
	end
	return false
end

function UIVipCtr:HasNext()
	local nextLv = self.curShowVipLv + 1
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(nextLv)
	if not vipCfg then
		return false
	end
	if self:GetCurVipLv() < self.curShowVipLv then
		local curVipCfg = ManagerContainer.CfgMgr:GetVipCfgById(self.curShowVipLv)
		if curVipCfg and curVipCfg.PreviewLock and curVipCfg.PreviewLock > 0 then
			return false
		end
	end
	return true
end

function UIVipCtr:IsReachLv()
	return self.curShowVipLv <= self:GetCurVipLv()
end

function UIVipCtr:IsShowCustomerVipLv()
	if not self.showCustomerVipLv or self.showCustomerVipLv <= 0 then
		return false
	end
	return self.showCustomerVipLv <= self:GetCurVipLv()
end

return UIVipCtr

