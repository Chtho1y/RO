local UIOptionalWishBoxCtr = class("UIOptionalWishBoxCtr", require("UICtrBase"))

function UIOptionalWishBoxCtr:Init(view)
	self.view = view
end

function UIOptionalWishBoxCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
	self.Id = data[1]
	self.cfgId = data[2]
end

function UIOptionalWishBoxCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIOptionalWishBoxCtr:GetData()
	return self.data
end

function UIOptionalWishBoxCtr:GetCfgId()
	return self.cfgId or 0
end

function UIOptionalWishBoxCtr:GetId()
	return self.Id or 0
end

function UIOptionalWishBoxCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIOptionalWishBoxCtr

