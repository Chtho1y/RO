local UINewStoryCtr = class("UINewStoryCtr", require("UICtrBase"))

function UINewStoryCtr:Init(view)
	self.view = view
end

function UINewStoryCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UINewStoryCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UINewStoryCtr:GetData()
	return self.data
end

function UINewStoryCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UINewStoryCtr

