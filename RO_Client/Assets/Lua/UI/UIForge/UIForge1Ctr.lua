local UIForge1Ctr = class("UIForge1Ctr", require("UICtrBase"))

function UIForge1Ctr:Init(view)
	self.view = view
end

function UIForge1Ctr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIForge1Ctr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIForge1Ctr:GetData()
	return self.data
end

function UIForge1Ctr:SendEquipForge(cfgId, count)
	local oldData = ManagerContainer.CfgMgr:GetEquipById(cfgId)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_EQUIP_FORGE_REQ, {config_id = cfgId, once = count, equip_type = oldData.Type})
end

function UIForge1Ctr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIForge1Ctr

