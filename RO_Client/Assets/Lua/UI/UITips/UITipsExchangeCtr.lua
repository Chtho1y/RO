local UITipsExchangeCtr = class("UITipsExchangeCtr", require("UICtrBase"))

function UITipsExchangeCtr:Init(view)
	self.view = view
end

function UITipsExchangeCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data

	self.selectedCount = 1
end

function UITipsExchangeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UITipsExchangeCtr:GetData()
	return self.data
end

function UITipsExchangeCtr:GetCfgId()
	return self.data.cfgId
end

function UITipsExchangeCtr:GetCfgCount()
	return self.data.count or 0
end

function UITipsExchangeCtr:GetisExchangeRadioDesc()
	return self.data.desc or ""
end
function UITipsExchangeCtr:GetisExchangeDesc()
	return self.data.desc
end

function UITipsExchangeCtr:GetisExchangeItem()
	return self.data.isExchangeItem or false
end

function UITipsExchangeCtr:GetRadio()
	return self.data.radio or 1
end

function UITipsExchangeCtr:GetTargetCfgId()
	return self.data.targetCfgId or 0
end

function UITipsExchangeCtr:GetisSetColor()
	return self.data.isSetColor or false
end

function UITipsExchangeCtr:GetEnterType()
	return self.data.EnterType or 0
end

function UITipsExchangeCtr:GetMaxExchangeCount()
	return self.data.maxExchangeCount
end

function UITipsExchangeCtr:RefreshSelectedCount(offset)
	self.selectedCount = self.selectedCount + offset
	self.selectedCount = Mathf.Clamp(self.selectedCount, 1, self.data.maxExchangeCount)
end

function UITipsExchangeCtr:SetSelectedCount(count)
	self.selectedCount = count
	self.selectedCount = Mathf.Clamp(self.selectedCount, 1, self.data.maxExchangeCount)
end

function UITipsExchangeCtr:GetSelectedCount()
	return self.selectedCount
end

function UITipsExchangeCtr:OnExchangeClick()
	if self.data.owner and self.data.ownerCB then
		self.data.ownerCB(self.data.owner, self.data.idx, self.selectedCount)
	end
end

function UITipsExchangeCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UITipsExchangeCtr

