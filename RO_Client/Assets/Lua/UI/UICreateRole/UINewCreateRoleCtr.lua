local UINewCreateRoleCtr = class("UINewCreateRoleCtr", require("UICtrBase"))

function UINewCreateRoleCtr:Init(view)
	self.view = view
	self.sexType = nil
	self.maleAnimator = nil
	self.femaleAnimator  = nil
end

function UINewCreateRoleCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UINewCreateRoleCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UINewCreateRoleCtr:GetData()
	return self.data
end

function UINewCreateRoleCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.maleAnimator = nil
	self.femaleAnimator  = nil
end

function UINewCreateRoleCtr:GetSexType()
	return self.sexType
end

function UINewCreateRoleCtr:SetSexType(newSexType)
	self.sexType = newSexType
end

function UINewCreateRoleCtr:GetMaleCfgId()
	return CommonUtil.JobIdToRoleId(GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_default_profession), Enum.SexType.Man)
end

function UINewCreateRoleCtr:GetFemaleCfgId()
	return CommonUtil.JobIdToRoleId(GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_default_profession), Enum.SexType.Woman)
end

function UINewCreateRoleCtr:SetActorAnim(maleAnim,femaleAnim)
	self.maleAnimator = maleAnim
	self.femaleAnimator = femaleAnim
end

function UINewCreateRoleCtr:OnSelectRole(isMale,go)
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SELECT_ROLE,isMale,go)
	if self.view ~= nil then
		return self.view:OnSelectRole(isMale,go)
	end
	return false
end

function UINewCreateRoleCtr:CancelSelected()
	if self.view ~= nil then
		self.view:CancelSelected()
	end
end

function UINewCreateRoleCtr:OnCreateClick(activationCode)
	local country 			= GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_default_country)
	local openId = ManagerContainer.LuaGameMgr.openId
	local jobId = GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_default_profession)
	LogWarning("userName = " .. tostring(openId) .. " job_id = " .. tostring(jobId) .. " sex = " .. self.sexType .. "activationCode = " .. tostring(activationCode))

	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CREATE_ROLE_REQ, {open_id = openId, job_id = jobId, sex = self.sexType, country = country , active_code = activationCode})
end

return UINewCreateRoleCtr

