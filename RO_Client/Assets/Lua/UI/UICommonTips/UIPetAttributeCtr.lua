local UIPetAttributeCtr = class("UIPetAttributeCtr", require("UICtrBase"))

function UIPetAttributeCtr:Init(view)
	self.view = view
end

function UIPetAttributeCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPetAttributeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetAttributeCtr:GetData()
	return self.data
end

function UIPetAttributeCtr:GetId()
	return self.data.id
end

function UIPetAttributeCtr:GetType()
	return self.data.type
end

function UIPetAttributeCtr:GetCfgId()
	return self.data.cfgId
end

function UIPetAttributeCtr:GetBaseAttrList()
	return self.data.baseList
end

function UIPetAttributeCtr:GetAddAttrList()
	return self.data.addList
end

function UIPetAttributeCtr:GetPetActorData()
	local id = self.data.id
	local actorData = ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(id)
	if not actorData then
		return
	end

	return actorData
end

function UIPetAttributeCtr:GetRelationAddAttrs()
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

	local list = {}
	local relationDatas = ManagerContainer.DataMgr.PetDataMgr:GetAllPetRelationDatas()
	for _,v in pairs(relationDatas) do
		local cfgData = ManagerContainer.CfgMgr:GetPetPartnerDataById(v.cfgId)
		local maxIdx = GetMaxActiveRelationIdx(v.relationPets, cfgData)
		if maxIdx > 0 then
			for i = maxIdx, 1, -1 do
				for k, v1 in pairs(cfgData["attribute"..i]) do
					if not list[v1[1]] then
						list[v1[1]] = 0
					end
					list[v1[1]] = list[v1[1]] + v1[2]
				end
			end
		end
	end
	return list
end

function UIPetAttributeCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIPetAttributeCtr

