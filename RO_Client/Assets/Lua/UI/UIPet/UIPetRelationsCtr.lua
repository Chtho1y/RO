local UIPetRelationsCtr = class("UIPetRelationsCtr", require("UICtrBase"))

function UIPetRelationsCtr:Init(view)
	self.view = view
end

function UIPetRelationsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPetRelationsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetRelationsCtr:GetData()
	return self.data
end

function UIPetRelationsCtr:RefreshRelationDatas()
	if not self.relationDatas then
		self.relationDatas = ManagerContainer.CfgMgr:GetAllPetPartnerDatas()
	end
	
	return self.relationDatas
end

function UIPetRelationsCtr:GetRelationDataLength()
	return #self.relationDatas
end

function UIPetRelationsCtr:GetRelationShowDataByIdx(idx)
	return self.relationDatas[idx + 1]
end

function UIPetRelationsCtr:SetRelationDataByRelationIdAndSlotIdx(cfgId, idx, petData)
	local datas = {}

	local replaceUid, replaceCfgId, replacePetId, replaceAdvanceLevel
	local relationData = ManagerContainer.DataMgr.PetDataMgr:GetPetRelationDataByCfgId(cfgId)
	local cloneData = clone(relationData)
	if not cloneData then
		cloneData = {}
		cloneData.cfgId = cfgId
		cloneData.relationPets = {}
	end

	if cloneData.relationPets then
		local data = cloneData.relationPets[idx]
		if data == nil then
			data = {}
		end
		replaceUid, replaceCfgId, replacePetId, replaceAdvanceLevel = data.uid, data.cfgId, data.id or data.petId, data.advanceLevel
		data.uid = petData.uid;
		data.petId = petData.id;
		data.cfgId = petData.cfgId;
		data.advanceLevel = petData.advanceLevel

		cloneData.relationPets[idx] = data
	end
	datas[#datas + 1] = cloneData

	local replaceRelationData = ManagerContainer.DataMgr.PetDataMgr:GetReplacePetRelationDataByUidAndPetId(petData.uid, petData.id)
	if replaceRelationData then
		local cloneData = clone(replaceRelationData)
		if cloneData.relationPets then
			for _,v in pairs(cloneData.relationPets) do
				if v.uid == petData.uid and v.petId == petData.id then
					v.uid = replaceUid or 0
					v.cfgId = replaceCfgId or 0
					v.petId = replacePetId or 0
					v.advanceLevel = replaceAdvanceLevel or 0
				end
			end
		end
		datas[#datas + 1] = cloneData
	end
	ManagerContainer.DataMgr.PetDataMgr:SendPetRelationActive(datas)
end

local function GetMaxActiveRelationIdx(relationPets, cfgData)
	local count = 3
	local maxIdx = 0
	for j = 3, 1, -1 do
		local condition = cfgData['Condition'..j]
		local state
		if condition then
			local curCount = 0
			if relationPets then
				for k,v1 in pairs(relationPets) do
					local cfgId = condition[k][1]
					local num = condition[k][2]
					if v1.cfgId == cfgId and v1.advanceLevel >= num and v1.petId > 0 then
						curCount = curCount + 1
					end
				end
			end

			state = curCount >= count
			if state then
				if maxIdx == 0 then
					maxIdx = j
				end
			end
		end
	end
	return maxIdx
end

function UIPetRelationsCtr:RefreshAllAttrs()
	self.allAttrs = {}
	local list = {7,8,9,10,11,12,13,14,15,16,91,92,93,94,95,96,97}
	for i = 1, #list do
		table.insert(self.allAttrs, {list[i], 0})
	end

	local function AddAttr(attrId, val)
		for _,v in pairs(self.allAttrs) do
			if attrId == v[1] then
				v[2] = v[2] + val
			end
		end
	end

	local relationDatas = ManagerContainer.DataMgr.PetDataMgr:GetAllPetRelationDatas()
	for k,v in pairs(relationDatas) do
		local cfgData = ManagerContainer.CfgMgr:GetPetPartnerDataById(v.cfgId)

		local maxIdx = GetMaxActiveRelationIdx(v.relationPets, cfgData)
		if maxIdx > 0 and v.relationPets then
			for j = maxIdx,1,-1 do
				local attribute = cfgData['attribute'..j]
				if attribute then
					for i = 1,#attribute do
						local attrId = attribute[i][1]
						local value = attribute[i][2]
						AddAttr(attrId, value)
					end
				end
			end
		end
	end
end

function UIPetRelationsCtr:GetAllAttrs()
	return self.allAttrs
end

function UIPetRelationsCtr:GetRelationRPStates()
	if not self.relationRPStates then
		self.relationRPStates = ManagerContainer.DataMgr.PetDataMgr:GetRelationRPStates()
		if not self.relationRPStates then
			ManagerContainer.DataMgr.PetDataMgr:RefreshRelationRPStates()
		end
	end
	return self.relationRPStates
end

function UIPetRelationsCtr:OnDispose()
	self.relationDatas = nil
	self.allAttrs = nil
	self.relationRPStates = nil

	self.data = nil
	self.view = nil
end

return UIPetRelationsCtr

