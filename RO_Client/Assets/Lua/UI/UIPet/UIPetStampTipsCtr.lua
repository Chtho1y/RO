local UIPetStampTipsCtr = class("UIPetStampTipsCtr", require("UICtrBase"))

function UIPetStampTipsCtr:Init(view)
	self.view = view
end

function UIPetStampTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPetStampTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetStampTipsCtr:GetData()
	return self.data
end

function UIPetStampTipsCtr:GetStampData()
	return self.data.stampData
end

function UIPetStampTipsCtr:GetSlotIdx()
	return self.data.slotIdx
end

function UIPetStampTipsCtr:GetPetId()
	return self.data.petId
end

function UIPetStampTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIPetStampTipsCtr

