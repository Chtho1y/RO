local UIChangeHeadCtr = class("UIChangeHeadCtr", require("UICtrBase"))

local GetSex = function(key)
	local sex = key
	while sex >= 10 do
		sex = sex * 0.1
	end
	return math.floor(sex)
end

function UIChangeHeadCtr:Init(view)
	self.view = view
end

function UIChangeHeadCtr:SetData(data)
	self.asyncIdx = 0
	self:RefreshHeadPortraitsSort()
	if data == nil then return end
	self.data = data
end

function UIChangeHeadCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIChangeHeadCtr:GetData()
	return self.data
end

function UIChangeHeadCtr:OnDispose()
	self.data = nil
	self.view = nil
end

----Custom start----

function UIChangeHeadCtr:RefreshHeadPortraits()
	local headPortraits = {}
	local datas = ManagerContainer.CfgMgr:GetHeadPortraitDatas()
	local sex = ManagerContainer.DataMgr.UserData:GetSex()
	for key, value in pairs(datas) do
		if Constant.OpenPay  or not value.NoPay then
			if GetSex(key) == sex then
				table.insert(headPortraits, {cfgId = key})
			end
		end
	end
	self.headPortraits = headPortraits
	self:RefreshHeadPortraitsSort()
end

function UIChangeHeadCtr:GetActiveHeadProtraitError(cfgId)
	local state = ManagerContainer.DataMgr.HeadProtraitData:GetState(cfgId)
	if state == Enum.TaskStateType.NoCompeleted then
		return 1
	elseif state == Enum.TaskStateType.Received then
		return 2
	end
	return 0
end


function UIChangeHeadCtr:GetSetHeadProtraitError(cfgId)
	if cfgId == ManagerContainer.DataMgr.UserData:GetUserHeadPortraitId() then
		return 1
	end
	local state = ManagerContainer.DataMgr.HeadProtraitData:GetState(cfgId)
	if state == Enum.TaskStateType.NoCompeleted then
		return 2
	elseif state == Enum.TaskStateType.CompletedAndNoReceive then
		return 3
	end
	return 0
end

function UIChangeHeadCtr:RefreshHeadPortraitsSort()
	if not self.headPortraits then return end
	table.sort(self.headPortraits, function(a, b)
		local stateA = ManagerContainer.DataMgr.HeadProtraitData:GetState(a.cfgId)
		local stateB = ManagerContainer.DataMgr.HeadProtraitData:GetState(b.cfgId)
		if stateA == stateB then
			return b.cfgId > a.cfgId
		else
			return stateA > stateB
		end
	end)
end

function UIChangeHeadCtr:GetHeadPortraits()
	if not self.headPortraits then
		self:RefreshHeadPortraits()
	end
	return self.headPortraits
end
----Custom end ----

return UIChangeHeadCtr

