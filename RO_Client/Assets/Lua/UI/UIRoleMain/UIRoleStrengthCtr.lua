local UIRoleStrengthCtr = class("UIRoleStrengthCtr", require("UICtrBase"))

function UIRoleStrengthCtr:Init(view)
	self.view = view
end

function UIRoleStrengthCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIRoleStrengthCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIRoleStrengthCtr:GetData()
	return self.data
end

function UIRoleStrengthCtr:SendStrengthReq(id)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HERO_STRENGTH_REQ, {hero_id = id})
end

function UIRoleStrengthCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIRoleStrengthCtr

