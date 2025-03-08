local UIForgePopCtr = class("UIForgePopCtr", require("UICtrBase"))

function UIForgePopCtr:Init(view)
	self.view = view
end

function UIForgePopCtr:SetData(data)
	self.data = data
	self.asyncIdx = 0
end

function UIForgePopCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIForgePopCtr:GetData()
	return self.data
end

function UIForgePopCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIForgePopCtr:SendEquipOneKeyForge(type, jobType)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EQUIP_FORGE_REQ, {config_id = 0, equip_type = type, sub_equip_type = jobType})
end

return UIForgePopCtr

