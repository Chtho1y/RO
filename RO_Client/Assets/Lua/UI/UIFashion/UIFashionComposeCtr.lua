local UIFashionComposeCtr = class("UIFashionComposeCtr", require("UICtrBase"))

function UIFashionComposeCtr:Init(view)
	self.view = view
end

function UIFashionComposeCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data

	-- 初始化数据

end

function UIFashionComposeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIFashionComposeCtr:GetData()
	return self.data
end

function UIFashionComposeCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIFashionComposeCtr:GetCfgId()
	return self.data.cfgId
end

--- 是否能制作时装的错误判断
---@return integer 0：可以制作；1：金币不足；2：钻石不足；3：道具不足;4：已拥有
function UIFashionComposeCtr:GetErrorCode()
	local fashionPaperCfgData = ManagerContainer.CfgMgr:GetFashionPaperById(self:GetCfgId())
	local owned = ManagerContainer.DataMgr.FashionData:Contains(fashionPaperCfgData.FashionId)
	if owned then
		return 4
	end
	local makeMaterial = fashionPaperCfgData.MakeMaterial
	if type(makeMaterial[1]) == 'number' then
		makeMaterial = {makeMaterial}
	end
	local materialCfgId = nil
	local materialNum = nil
	for i = 1, #makeMaterial do
		materialCfgId = makeMaterial[i][1]
		materialNum = makeMaterial[i][2]
		local materialItemCfgData = ManagerContainer.CfgMgr:GetItemById(materialCfgId)
		if materialItemCfgData.ResType == Enum.ItemType.Coin then
			if ManagerContainer.DataMgr.UserData:GetOwnCoin() < materialNum then
				return 1
			end
		elseif materialItemCfgData.ResType == Enum.ItemType.Diamond then
			if ManagerContainer.DataMgr.UserData:GetOwnDiamond() < materialNum then
				return 2
			end
		else
			if ManagerContainer.DataMgr.BagData:GetItemCountByCfgId(materialCfgId) < materialNum then
				return 3
			end
		end
	end
	return 0
end

function UIFashionComposeCtr:SendCompose()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FASHION_COMPOSE_REQ, {paper_cfg_id = self:GetCfgId()})
end

return UIFashionComposeCtr

