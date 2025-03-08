local UIExpeditionWinCtr = class("UIExpeditionWinCtr", require("UICtrBase"))

function UIExpeditionWinCtr:Init(view)
	self.view = view
end

function UIExpeditionWinCtr:SetData(data)
	self.buffs = nil
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
	self.buffIds = self.data[1]
	self.inBattling = self.data[2]
	self:InitBuffData()
end

function UIExpeditionWinCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIExpeditionWinCtr:GetData()
	return self.data
end

function UIExpeditionWinCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.buffs = nil
end

function UIExpeditionWinCtr:InitBuffData()
	self.buffs = {}
	for i = 1, #self.buffIds do
		local buff = ManagerContainer.CfgMgr:GetExpeditionBuffCfgById(self.buffIds[i])
		self.buffs[#self.buffs + 1] = buff
	end
end

function UIExpeditionWinCtr:GetBuffs()
	return self.buffs
end

function UIExpeditionWinCtr:InBattling()
	return self.inBattling
end

return UIExpeditionWinCtr

