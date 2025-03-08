local UIMailCtr = class("UIMailCtr", require("UICtrBase"))

function UIMailCtr:Init(view)
	self.view = view
end

function UIMailCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIMailCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIMailCtr:GetData()
	return self.data
end

function UIMailCtr:SendRewardMail(id)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_MAIL_REWARD_REQ, {mail_id_list = {id}})
end

function UIMailCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIMailCtr

