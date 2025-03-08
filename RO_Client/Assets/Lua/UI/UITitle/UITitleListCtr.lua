local UITitleListCtr = class("UITitleListCtr", require("UICtrBase"))

function UITitleListCtr:Init(view)
	self.view = view
end

function UITitleListCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UITitleListCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UITitleListCtr:SendTitleOperateReq(state,id)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HEAD_OPERATE_REQ,{operateType = state,headId = id})
end

function UITitleListCtr:GetData()
	return self.data
end

function UITitleListCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UITitleListCtr

