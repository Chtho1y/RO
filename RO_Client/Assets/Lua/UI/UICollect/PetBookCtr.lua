local PetBookCtr = class("PetBookCtr", require("UICtrBase"))

function PetBookCtr:Init()

end

function PetBookCtr:GetData()
	return self.data
end

function PetBookCtr:GetCurCount(type)
	local count = ManagerContainer.DataMgr.PetDataMgr:GetActivedPetCount(type)
	return count
end

function PetBookCtr:GetHandBookPetCfgDatas(quality)
	local list = {}
	local datas = clone(ManagerContainer.CfgMgr:GetPetDatasByQuality(quality))
	if datas then
		for _,v in pairs(datas) do
			local data = ManagerContainer.DataMgr.PetDataMgr:GetPetCollectBoolState(v.Id)
			v.canActive = not data
			list[#list + 1] = v
		end
		CommonUtil.ArraySortSelections(list, Enum.TableSortRule.Up, "canActive", "Quality", "Id")
	end
	return list
end

function PetBookCtr:GetHandBookPetCfgDatasByType(type)
	if type == Enum.CollectQualityType.ALL then
		local list = {}
		local datas = clone(ManagerContainer.CfgMgr:GetAllPetDatas())
		if datas then
			for _,v in pairs(datas) do
				local data = ManagerContainer.DataMgr.PetDataMgr:GetPetCollectBoolState(v.Id)
				v.canActive = not data
				list[#list + 1] = v
			end
			CommonUtil.ArraySortSelections(list, Enum.TableSortRule.Up, "canActive", "Quality", "Id")
		end
		self.showData = list
	elseif type >= Enum.CollectQualityType.NORMAL or type <= Enum.CollectQualityType.MVP then
		self.showData = self:GetHandBookPetCfgDatas(type - 1)
	end
end

function PetBookCtr:GetCurShowDatasLength()
	return self.showData and #self.showData or 0
end

function PetBookCtr:GetShowDataByIdx(idx)
	return self.showData and self.showData[idx] or nil
end

function PetBookCtr:GetPetBookOffsetCfgId(cfgId, offset)
	if not self.showData then return cfgId end

	for i = 1,#self.showData do
		if self.showData[i].Id == cfgId then
			if i + offset < 1 then
				return self.showData[#self.showData].Id
			elseif i + offset > #self.showData then
				return self.showData[1].Id
			else
				return self.showData[i + offset].Id
			end
		end
	end
	return cfgId
end

function PetBookCtr:OnDispose()
	self.showData = nil
	self.data = nil
end

return PetBookCtr

