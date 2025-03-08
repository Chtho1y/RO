local UIBattleSimpleResultCtr = class("UIBattleSimpleResultCtr", require("UICtrBase"))

function UIBattleSimpleResultCtr:Init(view)
	self.view = view
end

function UIBattleSimpleResultCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIBattleSimpleResultCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIBattleSimpleResultCtr:GetData()
	return self.data
end

function UIBattleSimpleResultCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIBattleSimpleResultCtr:GetBattleResult()
	if self.data then
		return self.data[1] or 0
	end
	return 0
end

function UIBattleSimpleResultCtr:HandleCallback()
	if self.data then
		local cb = self.data[2]
		local ownerCb = self.data[3]
		if cb then
			if ownerCb then
				cb(ownerCb, self:GetBattleResult())
			else
				cb(self:GetBattleResult())
			end
		end
	end
end

return UIBattleSimpleResultCtr

