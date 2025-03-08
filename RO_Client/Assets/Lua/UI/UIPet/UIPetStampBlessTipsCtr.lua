local UIPetStampBlessTipsCtr = class("UIPetStampBlessTipsCtr", require("UICtrBase"))

function UIPetStampBlessTipsCtr:Init(view)
	self.view = view
end

function UIPetStampBlessTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPetStampBlessTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetStampBlessTipsCtr:GetData()
	return self.data
end

function UIPetStampBlessTipsCtr:GetCurPetData()
	local id = self.data
	self.curPetData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(id)
	return self.curPetData
end

function UIPetStampBlessTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIPetStampBlessTipsCtr

