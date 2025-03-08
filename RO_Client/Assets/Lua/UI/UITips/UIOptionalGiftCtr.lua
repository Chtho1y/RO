local UIOptionalGiftCtr = class("UIOptionalGiftCtr", require("UICtrBase"))

function UIOptionalGiftCtr:Init(view)
	self.view = view
end

function UIOptionalGiftCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIOptionalGiftCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIOptionalGiftCtr:GetData()
	return self.data
end

function UIOptionalGiftCtr:OnDispose()
	self.itemId = nil
	self.cfgId = nil
	self.num = nil
	self.cfgData = nil
	self.selectIdx = nil
	self.selectCfgIds = nil
	self.selectCfgIdNum = nil

	self.data = nil
	self.view = nil
end

function UIOptionalGiftCtr:RefreshData()
	if self.data then
		self.itemId = self.data[1]
		self.cfgId = self.data[2]
		self.num = self.data[3]
	else
		self.itemId = nil
		self.cfgId = nil
		self.num = nil
	end
	self.cfgData = nil
	self.selectIdx = nil
	self.selectCfgIds = nil
	self.selectCfgIdNum = 0
	if self.cfgId then
		self.cfgData = ManagerContainer.CfgMgr:GetItemById(self.cfgId)
		if self.cfgData then
			local composeItems = self.cfgData.ComposeItem
			if composeItems then
				self.selectCfgIdNum = #composeItems
				self.selectCfgIds = {}
				for i = 1, self.selectCfgIdNum do
					local composeItem = composeItems[i]
					self.selectCfgIds[i] = {cfgId = composeItem[1], num = composeItem[2]}
				end
			end
		end
	end
end

function UIOptionalGiftCtr:GetCfgData()
	return self.cfgData
end

function UIOptionalGiftCtr:GetSelectCfgIdNum()
	return self.selectCfgIdNum
end

function UIOptionalGiftCtr:GetSelectItemData(idx)
	if self.selectCfgIds then
		return self.selectCfgIds[idx]
	end
	return nil
end

function UIOptionalGiftCtr:GetSelectIdx()
	return self.selectIdx
end

function UIOptionalGiftCtr:SetSelectIdx(idx)
	if self.selectIdx == idx then
		return false
	end
	self.selectIdx = idx
	return true
end

function UIOptionalGiftCtr:CanCost()
	if self.num then
		if self:GetOwnResCountByItemId() >= self.num then
			return true
		end
	end
	return false
end

function UIOptionalGiftCtr:GetOwnResCountByItemId()
	if self.itemId then
		local item = ManagerContainer.DataMgr.BagData:GetItemById(self.itemId)
		if item then
			return item.num
		end
	end
	return 0
end





function UIOptionalGiftCtr:SendOpenGiftReq()
	if not self.selectIdx then
		return 'ZixuanBag2'
	end
	if not self.selectCfgIds then
		return 'ZixuanBag1'
	end
	local itemData = self.selectCfgIds[self.selectIdx]
	if not itemData and not itemData.cfgId then
		return 'ZixuanBag1'
	end
	if not self.itemId then
		return 'ZixuanBag1'
	end
	if not self.cfgId or not self.num or self.num <= 0 then
		return 'ZixuanBag1'
	end
	if CommonUtil.GetOwnResCountByItemId(self.cfgId) < self.num then
		return 'ZixuanBag3'
	end
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_USE_ITEM_REQ, {
		item_id = self.itemId,
		item_num = self.num,
		item_idx_list = {self.selectIdx - 1},
		force_item_id = true,
	})
	self.selectIdx = nil
	return 0
end

return UIOptionalGiftCtr

