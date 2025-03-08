local UIStampLvUpCtr = class("UIStampLvUpCtr", require("UICtrBase"))

function UIStampLvUpCtr:Init(view)
	self.view = view
end

function UIStampLvUpCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIStampLvUpCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIStampLvUpCtr:GetData()
	return self.data
end

function UIStampLvUpCtr:GetStampData()
	return self.data.stampData
end

function UIStampLvUpCtr:SendLvUp()
	self.state = 1
	local id = self.data.stampData and self.data.stampData.id or nil
	ManagerContainer.DataMgr.PetDataMgr:SendStampLvUpReq(id)
end

function UIStampLvUpCtr:SendAdvance()
	self.state = 2
	local id = self.data.stampData and self.data.stampData.id or nil
	ManagerContainer.DataMgr.PetDataMgr:SendStampLvUpReq(id)
end

function UIStampLvUpCtr:GetState()
	return self.state
end

function UIStampLvUpCtr:ClearState()
	self.state = nil
end

function UIStampLvUpCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIStampLvUpCtr

