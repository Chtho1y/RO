local UIAntiCheatMsgWndCtr = class("UIAntiCheatMsgWndCtr", require("UICtrBase"))

function UIAntiCheatMsgWndCtr:Init(view)
	self.view = view
end

function UIAntiCheatMsgWndCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIAntiCheatMsgWndCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIAntiCheatMsgWndCtr:GetData()
	return self.data
end

function UIAntiCheatMsgWndCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIAntiCheatMsgWndCtr

