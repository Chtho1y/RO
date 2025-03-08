local UICollectCtr = class("UICollectCtr", require("UICtrBase"))

function UICollectCtr:Init(view)
	self.view = view
end

function UICollectCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UICollectCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UICollectCtr:GetData()
	return self.data
end

function UICollectCtr:SetCardBookCtr(ctr)
	self.cardBookCtr = ctr
end

function UICollectCtr:GetCardBookOffsetCfgId(curCfgId, offset)
	if self.cardBookCtr and self.cardBookCtr.GetCardBookOffsetCfgId then
		return self.cardBookCtr:GetCardBookOffsetCfgId(curCfgId, offset)
	end
	return curCfgId
end

function UICollectCtr:GetPetBookOffsetCfgId(curCfgId, offset)
	if self.petBookCtr and self.petBookCtr.GetPetBookOffsetCfgId then
		return self.petBookCtr:GetPetBookOffsetCfgId(curCfgId, offset)
	end
	return curCfgId
end

function UICollectCtr:SetPetBookCtr(ctr)
	self.petBookCtr = ctr
end

function UICollectCtr:SetKeepSakeBookCtr(ctr)
	self.keepSakeBookCtr = ctr
end

function UICollectCtr:GetKeepSakeBookOffsetCfgId(curCfgId, offset)
	if self.keepSakeBookCtr and self.keepSakeBookCtr.GetKeepSakeBookOffsetCfgId then
		return self.keepSakeBookCtr:GetKeepSakeBookOffsetCfgId(curCfgId, offset)
	end
	return curCfgId
end

function UICollectCtr:OnDispose()
	self.cardBookCtr = nil
	self.petBookCtr = nil
	self.keepSakeBookCtr = nil

	self.data = nil
	self.view = nil
end

return UICollectCtr

