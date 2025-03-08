local UIGuildLobbyCtr = class("UIGuildLobbyCtr", require("UICtrBase"))

function UIGuildLobbyCtr:Init(view)
	self.view = view
end

function UIGuildLobbyCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIGuildLobbyCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildLobbyCtr:GetData()
	return self.data
end

function UIGuildLobbyCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIGuildLobbyCtr

