local UICreateNameCtr = class("UICreateNameCtr", require("UICtrBase"))
ProtoMsgId = require("ProtoMsgId")

function UICreateNameCtr:Init(view)
	self.view = view
end

function UICreateNameCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UICreateNameCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UICreateNameCtr:GetData()
	return self.data
end

function UICreateNameCtr:OnDispose()
	self.data = nil
	self.view = nil
end


function UICreateNameCtr:SendChangeName(newName)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_RENAME_REQ, { name = newName })
end

return UICreateNameCtr

