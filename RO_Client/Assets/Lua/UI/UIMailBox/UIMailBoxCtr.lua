local UIMailBoxCtr = class("UIMailBoxCtr", require("UICtrBase"))

local firstOpen = true
function UIMailBoxCtr:Init(view)
	self.view = view
end

function UIMailBoxCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIMailBoxCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIMailBoxCtr:GetData()
	return self.data
end

function UIMailBoxCtr:IsFirstOpen()
	return firstOpen
end

function UIMailBoxCtr:SetFirstOpen()
	firstOpen = false
end

function UIMailBoxCtr:SendOneKeyDeleteMail()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_MAIL_DEL_READ_REQ, {})
end

function UIMailBoxCtr:SendOneKeyRewardMail()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_MAIL_REWARD_REQ, {mail_id_list = {}})
end

function UIMailBoxCtr:SendMailList()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_MAIL_LIST_REQ, {})
end

function UIMailBoxCtr:SendReadMail(id)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_MAIL_READ_REQ, {mail_id_list = {id}})
end

function UIMailBoxCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIMailBoxCtr

