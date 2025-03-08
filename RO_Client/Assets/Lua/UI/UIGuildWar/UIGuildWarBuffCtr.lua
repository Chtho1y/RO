local UIGuildWarBuffCtr = class("UIGuildWarBuffCtr", require("UICtrBase"))

function UIGuildWarBuffCtr:Init(view)
	self.view = view
end

function UIGuildWarBuffCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIGuildWarBuffCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildWarBuffCtr:GetData()
	return self.data
end

function UIGuildWarBuffCtr:OnDispose()
	self.buffCfgs = nil

	self.data = nil
	self.view = nil
end

function UIGuildWarBuffCtr:GetOwnResCountByItemId(itemCfgId)
	return CommonUtil.GetOwnResCountByItemId(itemCfgId)
end

function UIGuildWarBuffCtr:GetBuffCfgs()
	if not self.buffCfgs then
		local buffCfgs = ManagerContainer.CfgMgr:GetGuildWarBuffCfg()
		table.sort(buffCfgs, function(a, b)
			return a.SortId < b.SortId
		end)
		self.buffCfgs = buffCfgs
	end
	return self.buffCfgs
end

function UIGuildWarBuffCtr:GetBattleFieldData()
	return ManagerContainer.DataMgr.GuildWarDataMgr:GetBattleFieldData()
end

function UIGuildWarBuffCtr:SendGuildWarBuyBuffReq(buffId)
	local battleFieldData = self:GetBattleFieldData()
	if not ManagerContainer.DataMgr.GuildWarDataMgr:SendGuildWarBuyBuffReq(battleFieldData and battleFieldData.id or nil, buffId) then
		return 100007
	end
	return 0
end



return UIGuildWarBuffCtr

