local UIPetStampCtr = class("UIPetStampCtr", require("UICtrBase"))

function UIPetStampCtr:Init(view)
	self.view = view
end

function UIPetStampCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPetStampCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetStampCtr:GetData()
	return self.data
end

function UIPetStampCtr:RefreshShowDataType()
	self.showDatas = self:RefreshStampDatas()

	local showDataLength = 0
	if self.showDatas then
		showDataLength = #self.showDatas
		if self.row and self.minColumn then
			local curColumn = Mathf.Ceil(showDataLength / self.row) + 2
			if curColumn < self.minColumn then
				curColumn = self.minColumn
			end
			showDataLength = curColumn * self.row
		end
	end
	self.showDataLength = showDataLength
end

function UIPetStampCtr:SetGridRowColumn(row, minColumn)
	self.row = row
	self.minColumn = minColumn
end

function UIPetStampCtr:GetShowDataLength()
	return self.showDataLength or 0
end

function UIPetStampCtr:GetShowDataRealLength()
	return self.showDatas and #self.showDatas or 0
end

function UIPetStampCtr:GetShowData(itemIndex)
	return self.showDatas and self.showDatas[itemIndex + 1] or nil
end

function UIPetStampCtr:RefreshStampDatas()
	local maps = ManagerContainer.DataMgr.PetDataMgr.petStampData:GetAllPetStampDataMap()
	local runeDatas = {}
	for _,v in pairs(maps) do
		if v.petId == 0 then
			runeDatas[#runeDatas + 1] = v
		end
	end
	CommonUtil.ArraySortSelections(runeDatas, Enum.TableSortRule.Down, "quality", "lv", "cfgId")
	return runeDatas
end

function UIPetStampCtr:OnDispose()
	self.showDatas = nil

	self.data = nil
	self.view = nil
end

return UIPetStampCtr

