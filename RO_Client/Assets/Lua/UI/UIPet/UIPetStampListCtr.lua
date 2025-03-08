local UIPetStampListCtr = class("UIPetStampListCtr", require("UICtrBase"))

function UIPetStampListCtr:Init(view)
	self.view = view
end

function UIPetStampListCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPetStampListCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetStampListCtr:GetData()
	return self.data
end

function UIPetStampListCtr:NilStampData()
	self.data.curStamp = nil
end

function UIPetStampListCtr:GetStampData()
	return self.data.curStamp
end

function UIPetStampListCtr:GetAllTypeStampDatas()
	local id = self.data.curStamp and self.data.curStamp.id or nil
	self.typeStampDatas = ManagerContainer.DataMgr.PetDataMgr.petStampData:GetAllPetStampDatasByTypeExcludeId(self.data.slotIdx, id)
	if self.typeStampDatas then
		CommonUtil.ArraySortSelections(self.typeStampDatas, Enum.TableSortRule.Down, "quality", "lv", "cfgId")
	end
	return self.typeStampDatas
end

function UIPetStampListCtr:GetShowDataByIdx(idx)
	return self.typeStampDatas and self.typeStampDatas[idx + 1] or nil
end

function UIPetStampListCtr:SendDownStamp()
	local slotIdx = self.data.slotIdx
	local petId = self.data.petId
	ManagerContainer.DataMgr.PetDataMgr:SendStampDownReq(petId, slotIdx)
end

function UIPetStampListCtr:SendChangeStamp(id)
	local slotIdx = self.data.slotIdx
	local petId = self.data.petId
	local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(petId)
	if not petData then
		return
	end
	local slots = petData.slots
	local list = {}
	list[#list + 1] = {key = slotIdx, value = id}
	for _,v in pairs(slots) do
		if v.idx ~= slotIdx then
			list[#list + 1] = {key = v.idx, value = v.stampId}
		end
	end
	ManagerContainer.DataMgr.PetDataMgr:SendStampUpReq(petId, list)
end

function UIPetStampListCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIPetStampListCtr

