local UIFruitUseCtr = class("UIFruitUseCtr", require("UICtrBase"))

local sortedPartnerDatas 

function UIFruitUseCtr:Init(view)
	self.view = view
end

function UIFruitUseCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIFruitUseCtr:GetSlotSortPartnerDatas()
	local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
	sortedPartnerDatas = {}
	for _,v in pairs(partnerDatas) do
		sortedPartnerDatas[#sortedPartnerDatas + 1] = v
	end
	table.sort(sortedPartnerDatas, function (a, b)
		if a.owned and b.owned then
			return a.post < b.post
		else
			if a.owned and not b.owned then
				return true
			elseif not a.owned and b.owned then
				return false
			else
				return a.post < b.post
			end
		end
	end)
	return sortedPartnerDatas
end

function UIFruitUseCtr:GetHeroDataIndex(heroid)
	for k, v in pairs(sortedPartnerDatas) do
		if v.id == heroid then
			return k
		end
	end
	return 0
end

function UIFruitUseCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIFruitUseCtr:GetData()
	return self.data
end

function UIFruitUseCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIFruitUseCtr

