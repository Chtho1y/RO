local UIItemTipsCtr = class("UIItemTipsCtr", require("UICtrBase"))

function UIItemTipsCtr:Init(view)
	self.view = view
end

function UIItemTipsCtr:SetData(data)
	self.data = data
	self.asyncIdx = 0
end

function UIItemTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIItemTipsCtr:GetData()
	return self.data
end

---@generic 从哪里进入的tips
function UIItemTipsCtr:IsOpenFuncBtn()
	return (self.data.enterType == Enum.ItemIEnterType.Bag)
end

---@generic 获得道具配置id
function UIItemTipsCtr:GetCfgId()
	return self.data.cfgId == nil and self.data.Id or self.data.cfgId
end

function UIItemTipsCtr:GetEnterType()
	return self.data.enterType
end

function UIItemTipsCtr:GetExtData()
	return self.data.extData
end

function UIItemTipsCtr:OnDispose()
	self.data = nil
	self.enterType = nil
end

function UIItemTipsCtr:SendComposeChip()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CHIP_COMPOSE_REQ, { config_id = self:GetCfgId() })
end

return UIItemTipsCtr

