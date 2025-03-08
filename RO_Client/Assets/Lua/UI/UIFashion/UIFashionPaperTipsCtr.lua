local UIFashionPaperTipsCtr = class("UIFashionPaperTipsCtr", require("UICtrBase"))

function UIFashionPaperTipsCtr:Init(view)
	self.view = view
end

function UIFashionPaperTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIFashionPaperTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIFashionPaperTipsCtr:GetData()
	return self.data
end

function UIFashionPaperTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIFashionPaperTipsCtr:GetCfgId()
	return self.data.cfgId
end

function UIFashionPaperTipsCtr:GetEnterType()
	return self.data.enterType
end

function UIFashionPaperTipsCtr:GetExtData()
	return self.data.extData
end

function UIFashionPaperTipsCtr:GetIsOwned()
	local fashionPaperCfgData = ManagerContainer.CfgMgr:GetFashionPaperById(self:GetCfgId())
	local owned = ManagerContainer.DataMgr.FashionData:Contains(fashionPaperCfgData.FashionId)
	return owned
end

function UIFashionPaperTipsCtr:GetOwnedItemNum(itemCfgId)
	return CommonUtil.GetOwnResCountByItemId(itemCfgId)
end

function UIFashionPaperTipsCtr:SendDecomposeMsg()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FASHION_PAPER_DECOMPOSE_REQ, {paper_cfg_id = self:GetCfgId()})
end

return UIFashionPaperTipsCtr

