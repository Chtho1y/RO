local KeepSakeBookCtr = class("KeepSakeBookCtr", require("UICtrBase"))

function KeepSakeBookCtr:Init()

end

function KeepSakeBookCtr:GetData()
	return self.data
end

function KeepSakeBookCtr:GetCurCount(type)
	local count = ManagerContainer.DataMgr.KeepSakeBookData:GetKeepSakeHandBookQualityCountByType(type)
	return count
end

function KeepSakeBookCtr:GetHandBookKeepSakeCfgDatas(quality)
	local list = clone(ManagerContainer.CfgMgr:GetKeepSakeCfgDatasByLevel(quality))
	for _,v in pairs(list) do
		v.canLvUp = ManagerContainer.DataMgr.KeepSakeBookData:CanKeepSakeLvUp(v.Id)
		v.lv = ManagerContainer.DataMgr.KeepSakeBookData:GetKeepSakeBookDataById(v.Id) or 0

		v.front = v.canLvUp
		if not v.canLvUp and v.lv > 0 then
			v.front = true
		end
	end
	CommonUtil.ArraySortListSelections(list, {Enum.TableSortRule.Down, Enum.TableSortRule.Up, Enum.TableSortRule.Up}, {"front", "CollectionLevel","Id"})
	return list
end

function KeepSakeBookCtr:GetHandBookKeepSakeCfgDatasByType(type)
	if type == Enum.CollectQualityType.ALL then
		local list = {}
		for i = 2, 4 do
			local list1 = self:GetHandBookKeepSakeCfgDatas(i)
			for _,v in pairs(list1) do
				list[#list + 1] = v
			end
		end
		CommonUtil.ArraySortListSelections(list, {Enum.TableSortRule.Down, Enum.TableSortRule.Up, Enum.TableSortRule.Up}, {"front", "CollectionLevel","Id"})
		self.showData = list
	elseif type >= Enum.CollectQualityType.NORMAL or type <= Enum.CollectQualityType.MVP then
		self.showData = self:GetHandBookKeepSakeCfgDatas(type)
	end
end

function KeepSakeBookCtr:GetCurShowDatasLength()
	return self.showData and #self.showData or 0
end

function KeepSakeBookCtr:GetShowDataByIdx(idx)
	return self.showData and self.showData[idx] or nil
end

function KeepSakeBookCtr:GetKeepSakeBookOffsetCfgId(cfgId, offset)
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

function KeepSakeBookCtr:OnDispose()
	self.showData = nil
	self.data = nil
end

return KeepSakeBookCtr

