local UIMaterialsTipsCtr = class("UIMaterialsTipsCtr", require("UICtrBase"))

function UIMaterialsTipsCtr:Init(view)
	self.view = view
end

function UIMaterialsTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIMaterialsTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIMaterialsTipsCtr:GetData()
	return self.data
end

function UIMaterialsTipsCtr:GetAllMaterialDatas()
	local map = ManagerContainer.DataMgr.KeepSakeBookData:GetMaterialDatas()
	self.showData = {}
	for k,v in pairs(map) do
		if v > 0 then
			self.showData[#self.showData + 1] = {cfgId = k, num = v}
		end
	end
	CommonUtil.ArraySortSelections(self.showData, Enum.TableSortRule.Up, "cfgId")
	return self.showData
end

function UIMaterialsTipsCtr:GetShowDataLength()
	return self.showData and #self.showData or 0
end

function UIMaterialsTipsCtr:GetShowDataItem(index)
	return self.showData[index + 1]
end

function UIMaterialsTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIMaterialsTipsCtr

