local UILanuchCtr = class("UILanuchCtr", require("UICtrBase"))

function UILanuchCtr:Init(view)
	self.view = view
end

function UILanuchCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UILanuchCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UILanuchCtr:GetData()
	return self.data
end

function UILanuchCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UILanuchCtr

