local CardBookCtr = class("CardBookCtr", require("UICtrBase"))

function CardBookCtr:Init()

end

function CardBookCtr:GetData()
	return self.data
end

function CardBookCtr:GetHandBookQualityCountByQuality(quality)
	return ManagerContainer.DataMgr.CollectionBookData:GetCardHandBookQualityCountById(quality)
end

function CardBookCtr:GetCurCount(type)
	local count = 0
	if type == Enum.CollectQualityType.ALL then
		for i = 1, 3 do
			local count1 = self:GetHandBookQualityCountByQuality(i)
			count = count + count1
		end
	elseif type >= Enum.CollectQualityType.NORMAL or type <= Enum.CollectQualityType.MVP then
		count = self:GetHandBookQualityCountByQuality(type - 1)
	end
	return count
end

function CardBookCtr:GetHandBookCardCfgDatas(quality)
	local list = clone(ManagerContainer.CfgMgr:GetCardIdentificationDatasByQuality(quality))
	for _,v in pairs(list) do
		local data = ManagerContainer.DataMgr.CollectionBookData:GetCollectionBookDataById(v.Cardid)
		v.canActive = (data and {data.cardLevel == 0} or {true})[1]
	end
	CommonUtil.ArraySortSelections(list, Enum.TableSortRule.Up, "canActive", "CardQuality", "Cardid")
	return list
end

function CardBookCtr:GetHandBookCardCfgDatasByType(type)
	if type == Enum.CollectQualityType.ALL then
		local list = {}
		for i = 1, 3 do
			local list1 = self:GetHandBookCardCfgDatas(i)
			for _,v in pairs(list1) do
				list[#list + 1] = v
			end
		end
		CommonUtil.ArraySortSelections(list, Enum.TableSortRule.Up, "canActive", "CardQuality", "Cardid")
		self.showData = list
	elseif type >= Enum.CollectQualityType.NORMAL or type <= Enum.CollectQualityType.MVP then
		self.showData = self:GetHandBookCardCfgDatas(type - 1)
	end
end

function CardBookCtr:GetCurShowDatasLength()
	return self.showData and #self.showData or 0
end

function CardBookCtr:GetShowDataByIdx(idx)
	return self.showData and self.showData[idx] or nil
end

function CardBookCtr:GetCardBookOffsetCfgId(cfgId, offset)
	if not self.showData then return cfgId end

	for i = 1,#self.showData do
		if self.showData[i].Cardid == cfgId then
			if i + offset < 1 then
				return self.showData[#self.showData].Cardid
			elseif i + offset > #self.showData then
				return self.showData[1].Cardid
			else
				return self.showData[i + offset].Cardid
			end
		end
	end
	return cfgId
end

function CardBookCtr:OnDispose()
	self.showData = nil
	self.data = nil
end

return CardBookCtr

