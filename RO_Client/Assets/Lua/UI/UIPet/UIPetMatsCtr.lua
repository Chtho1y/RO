local UIPetMatsCtr = class("UIPetMatsCtr", require("UICtrBase"))

local commonSkillMatId = 819
function UIPetMatsCtr:Init(view)
	self.view = view
end

function UIPetMatsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data

	commonSkillMatId = GlobalConfig.Instance:GetConfigIntValue(313)
end

function UIPetMatsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetMatsCtr:GetData()
	return self.data
end

function UIPetMatsCtr:SetChildController(ctr)
	self.childCtr = ctr
end

function UIPetMatsCtr:GetFromUIId()
	return self.data.fromUIId
end

function UIPetMatsCtr:GetRelationCfgId()
	return self.data.relationCfgId
end

function UIPetMatsCtr:GetSupportIdx()
	return self.data.supportIdx
end

function UIPetMatsCtr:GetEnterType()
	return self.data.enterType or Enum.ItemIEnterType.PetMats
end

function UIPetMatsCtr:SetSelectedData(idx)
	if self.data.selectedIdx == idx then
		self.data.selectedIdx = nil
	else
		self.data.selectedIdx = idx
	end
end

function UIPetMatsCtr:RefreshPetDatas()
	local fromUIId = self:GetFromUIId()
	if fromUIId == Enum.UIPageName.UIPetLvUp then
		return self:RefreshSkillMatsData()
	elseif fromUIId == Enum.UIPageName.UIPetRelations then
		return self:RefreshRelationsData()
	elseif fromUIId == Enum.UIPageName.UIPetMySupport then
		return self:RefreshSupportData()
	end
end

function UIPetMatsCtr:RefreshSkillMatsData()
	local selfId = self.data.selfId
	local selectedId = self.data.selectedId
	local petDatasSource = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
	local petDatas = petDatasSource
	local selfDatas
	if selfId then
		local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(selfId)
		selfDatas = CommonUtil.ArrayFilterSelections(petDatas, Enum.FilterType.AND, {"cfgId", "qiyueHeroId"}, {petData.cfgId, 0})
		local commonDatas = CommonUtil.ArrayFilterSelections(petDatas, Enum.FilterType.AND, {"cfgId", "qiyueHeroId"}, {commonSkillMatId, 0})

		for j = #selfDatas, 1, -1 do
			if selfDatas[j].id == selfId then
				table.remove(selfDatas, j)
				break
			end
		end

		if selfDatas ~= nil or commonDatas ~= nil then
			CommonUtil.ArraySortSelections(selfDatas, Enum.TableSortRule.Up, "isBattle", "quality", "isSupport", "isRelevant", "advanceLevel", "level", "cfgId")
			CommonUtil.ArraySortSelections(commonDatas, Enum.TableSortRule.Up, "isBattle", "quality", "isSupport", "isRelevant", "advanceLevel", "level", "cfgId")

			if petData.cfgId ~= commonSkillMatId then
				for i = 1, #commonDatas do
					selfDatas[#selfDatas + 1] = commonDatas[i]
				end
			end

			for k,v in pairs(selfDatas) do
				v.idx = k
			end
			if selectedId then
				for j = #selfDatas, 1, -1 do
					if selfDatas[j].id == selectedId then
						selfDatas[j].selected = 1
						self.data.curSelectedData = selfDatas[j]
						self.data.selectedIdx = selfDatas[j].idx
						break
					end
				end
			end
		end

		if selfDatas == nil then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NoCardTips3")
		end
		-- LogHRWarning(Inspect(selfDatas))
	end
	return selfDatas
end

function UIPetMatsCtr:RefreshRelationsData()
	local relationCfgId = self.data.relationCfgId
	local relationIdx = self.data.curRelationIdx
	local relationCfgData = ManagerContainer.CfgMgr:GetPetPartnerDataById(relationCfgId)
	local petDatas

	if not relationCfgData then
		return petDatas
	end

	local function ParseToPetData(uid, nickname, petData)
		local data = {}
		data.uid = uid
		data.nickname = nickname
		data.id = petData.id
		data.cfgId = petData.cfgId
		data.quality = petData.quality
		data.level = petData.level
		data.advanceLevel = petData.advanceLevel
		data.natureType = petData.natureType
		data.isBattle = petData.isBattle
		data.isSupport = petData.isSupport
		data.isRelevant = petData.isRelevant
		return data
	end

	local selectedPetId, selectedUid
	local relationData = ManagerContainer.DataMgr.PetDataMgr:GetPetRelationDataByCfgId(relationCfgId)
	if relationData and relationData.relationPets then
		for k,v in pairs(relationData.relationPets) do
			if k == relationIdx then
				selectedPetId, selectedUid = v.petId, v.uid
				break
			end
		end
	end

	local function IsUsed(uid, id)
		if relationData and relationData.relationPets then
			for k,v in pairs(relationData.relationPets) do
				if v.uid == uid and v.petId == id then
					return true
				end
			end
		end
		return false
	end

	local cfgIds, advenceNum = {},{}
	local condition = relationCfgData['Condition1']
	if condition and condition[relationIdx] then
		local cfgId = condition[relationIdx][1]
		local num = condition[relationIdx][2]
		cfgIds[#cfgIds + 1] = cfgId
		advenceNum[#advenceNum + 1] = num
	end

	local val = GlobalConfig.Instance:GetConfigStrValue(208)
	local advanceLimit = 5
	if val ~= "" and val ~= nil then
		local advenceLvStage = CommonUtil.DeserializeGlobalStrToTable(val)
		advanceLimit = #advenceLvStage
	end

	if #advenceNum > 0 then
		for i = 1, advanceLimit do
			if i > advenceNum[1] and not CommonUtil.EleInTable(i, advenceNum) then
				advenceNum[#advenceNum + 1] = i
			end
		end
	end

	local petDatasSource = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
	petDatas = petDatasSource
	local friendDatas = ManagerContainer.DataMgr.PetDataMgr:GetCurFriendSupportDatas()

	local list = {}
	local uid = 0
	local nickname = ManagerContainer.DataMgr.UserData:GetUserNickname()
	for _,v in pairs(petDatas) do
		if selectedUid ~= uid or v.id ~= selectedPetId then
			local data = ParseToPetData(uid, nickname, v)
			data.canUse = not IsUsed(uid, v.id)
			list[#list + 1] = data
		end
	end
	for _,v in pairs(friendDatas) do
		local uid = v.uid
		local nickname = v.nickname
		for _,v1 in pairs(v.supportPets) do
			if selectedUid ~= uid or selectedPetId ~= v1.id then
				local data = ParseToPetData(uid, nickname, v1)
				data.canUse = not IsUsed(uid, v1.id)
				list[#list + 1] = data
			end
		end
	end
	if list ~= nil then
		list = CommonUtil.ArrayFilterSelections(list, Enum.FilterType.AND, {"cfgId", "advanceLevel"}, {cfgIds, advenceNum})
		CommonUtil.ArraySortListSelections(list, {Enum.TableSortRule.Down,Enum.TableSortRule.Up,Enum.TableSortRule.Up, Enum.TableSortRule.Up, Enum.TableSortRule.Down},
				{"canUse", "isBattle", "isRelevant", "isSupport", "advanceLevel"})

		for k,v in pairs(list) do
			v.idx = k
		end
	end

	if list == nil then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NoCardTips3")
	end
	return list
end

function UIPetMatsCtr:RefreshSupportData()
	local mySupportPets = ManagerContainer.DataMgr.PetDataMgr:GetMySupportPets()
	local function IsUsed(id)
		if mySupportPets then
			for _,v in pairs(mySupportPets) do
				if v.id == id then
					return true
				end
			end
		end
		return false
	end

	local petDatasSource = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
	local petDatas = petDatasSource
	if petDatas == nil then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NoCardTips3")
	end
	if petDatas then
		for k,v in pairs(petDatas) do
			v.isUsed = IsUsed(v.id)
		end

		CommonUtil.ArraySortSelections(petDatas, Enum.TableSortRule.Down, "isUsed", "quality", "advanceLevel", "level", "cfgId")

		for k,v in pairs(petDatas) do
			v.idx = k
		end

		-- LogHRWarning(Inspect(petDatas))
	end
	return petDatas
end

function UIPetMatsCtr:GetCurSelectedIdx()
	return self.data.curSelectedData, self.data.selectedIdx
end

function UIPetMatsCtr:GetCurSelectedIdByIdx()
	if self.childCtr and self.data.selectedIdx then
		local data = self.childCtr:GetShowData(self.data.selectedIdx - 1)
		return data.id
	end
	return nil
end

function UIPetMatsCtr:GetCurSelectedDataByIdx()
	if self.childCtr and self.data.selectedIdx then
		local data = self.childCtr:GetShowData(self.data.selectedIdx - 1)
		return data
	end
	return nil
end

function UIPetMatsCtr:WasSkillUp(petData)
	if not petData.skillList then return false end

	for _,v in pairs(petData.skillList) do
		if v.level > 1 then
			return true
		end
	end
	return false
end

function UIPetMatsCtr:OnDispose()
	self.childCtr = nil

	self.data = nil
	self.view = nil
end

return UIPetMatsCtr

