local UIPetAdvenceCtr = class("UIPetAdvenceCtr", require("UICtrBase"))

local advenceLvStage
function UIPetAdvenceCtr:Init(view)
	self.view = view

	local val = GlobalConfig.Instance:GetConfigStrValue(208)
	if val ~= "" and val ~= nil then
		advenceLvStage = CommonUtil.DeserializeGlobalStrToTable(val)
	end
end

function UIPetAdvenceCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data

	self.selectionedList = {self.data}
end

function UIPetAdvenceCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetAdvenceCtr:GetData()
	return self.data
end

function UIPetAdvenceCtr:GetCurAdvenceMaxLv()
	if next(advenceLvStage) == nil then
		return 0
	end
	if not self.curPetData then
		self.curPetData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(self.data)
	end
	return tonumber(advenceLvStage[self.curPetData.advanceLevel + 1] or 0), tonumber(advenceLvStage[self.curPetData.advanceLevel + 2] or 0)
end

function UIPetAdvenceCtr:GetCurPetAttr(key)
	local actorData = ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(self.data)
	return actorData:GetFinalAttr(key)
end

function UIPetAdvenceCtr:AddSelection(id)
	if not id then return end

	local targetPetData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(id)
	local curPetCfgData = ManagerContainer.CfgMgr:GetPetProgressCfgDataById(self.curPetData.cfgId)

	local nextAdvenceLv = self.curPetData.advanceLevel + 1

	local idxList = {}
	for i = 1, 2 do
		local inCondition = true
		local condition = curPetCfgData["Condition"..nextAdvenceLv..i]
		if condition then
			for k,v in pairs(condition) do
				local type = v[1]
				local num = v[2]
				if type == Enum.PetRelationConditionType.Type then
					if targetPetData.quality ~= num then
						inCondition = false
						break
					end
				elseif type == Enum.PetRelationConditionType.Advence then
					if targetPetData.advanceLevel ~= num then
						inCondition = false
						break
					end
				elseif type == Enum.PetRelationConditionType.Nature then
					if targetPetData.natureType ~= num then
						inCondition = false
						break
					end
				end
			end
		end
		if inCondition then
			idxList[#idxList + 1] = i + 1
		end
	end

	local emptyIdx = 0
	for i = 1, #idxList do
		local idx = idxList[i]
		if self.selectionedList[idx] == nil then
			emptyIdx = idx
			break
		end
	end
	local lastSelectedId
	if emptyIdx > 0 then
		lastSelectedId = nil
	else
		emptyIdx = idxList[1]
		lastSelectedId = self.selectionedList[emptyIdx]
	end

	self:RemoveSelection(emptyIdx)
	self.selectionedList[emptyIdx] = id
	if self.showDatas then
		for j = 1, #self.showDatas do
			if self.showDatas[j].id == id then
				self.showDatas[j].selected = emptyIdx
			end
		end
	end
	return lastSelectedId
end

function UIPetAdvenceCtr:SetChildController(ctr)
	self.childCtr = ctr
end

function UIPetAdvenceCtr:RemoveSelection(idx)
	if idx == 1 then return end
	if self.selectionedList[idx] == nil then return end

	local id = self.selectionedList[idx]
	if self.showDatas then
		for j = 1, #self.showDatas do
			if self.showDatas[j].id == id then
				self.showDatas[j].selected = nil
			end
		end
	end

	self.selectionedList[idx] = nil
end

function UIPetAdvenceCtr:GetSelections()
	return self.selectionedList
end

function UIPetAdvenceCtr:GetSelectionsLegnth()
	return #self.selectionedList
end

function UIPetAdvenceCtr:IsInSelections(id)
	return CommonUtil.EleInTable(id, self.selectionedList)
end

function UIPetAdvenceCtr:SetShowDatas(datas)
	self.showDatas = datas
end

function UIPetAdvenceCtr:GetSelectionPetData(id)
	for _, v in pairs(self.showDatas) do
		if v.id == id then
			return v
		end
	end
	return
end

function UIPetAdvenceCtr:RefreshPetDatas()
	if not self.petAdvenceLimit then
		local val = GlobalConfig.Instance:GetConfigStrValue(346)
		if val ~= "" and val ~= nil then
			self.petAdvenceLimit = CommonUtil.DeserializeGlobalStrToTable(val)
		end
	end

	local petDatasSource = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
	local petDatas = petDatasSource
	local curPetData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(self.data)
	local curPetCfgData = ManagerContainer.CfgMgr:GetPetProgressCfgDataById(curPetData.cfgId)

	local limitIdx = 0
	if self.petAdvenceLimit then
		for i = #self.petAdvenceLimit, 1, -1 do
			local adv = tonumber(self.petAdvenceLimit[i][1])
			if curPetData.advanceLevel >= adv then
				limitIdx = i
				break
			end
		end
	end
	
	local function IsAdvenceMatLimit(matCfgId)
		if not self.petAdvenceLimit then return false end
		local needDel = false
		for i = #self.petAdvenceLimit, 1, -1 do
			local adv = tonumber(self.petAdvenceLimit[i][1])
			local cfgId = tonumber(self.petAdvenceLimit[i][2])
			if i == limitIdx and matCfgId == cfgId then
				return false
			end
			if i ~= limitIdx and matCfgId == cfgId then
				needDel = true
			end
		end
		return needDel
	end

	local nextAdvenceLv = curPetData.advanceLevel + 1

	local typeNum, advenceNum, natureNum = {},{},{}
	for i = 1, 2 do
		local condition = curPetCfgData["Condition"..nextAdvenceLv..i]
		if condition then
			for k,v in pairs(condition) do
				local type = v[1]
				local num = v[2]
				if type == Enum.PetRelationConditionType.Type then
					typeNum[#typeNum + 1] = num
				elseif type == Enum.PetRelationConditionType.Advence then
					advenceNum[#advenceNum + 1] = num
				elseif type == Enum.PetRelationConditionType.Nature then
					natureNum[#natureNum + 1] = num
				end
			end
		end
	end

	local list = CommonUtil.ArrayFilterSelections(petDatas, Enum.FilterType.AND, {"quality", "advanceLevel", "natureType", "qiyueHeroId"}, {typeNum, advenceNum, natureNum, 0})

	if list ~= nil then
		for i = #list, 1, -1 do
			local needDel = IsAdvenceMatLimit(list[i].cfgId)
			if needDel then
				table.remove(list, i)
			end
		end

		CommonUtil.ArraySortSelections(list, Enum.TableSortRule.Up, "isBattle", "isSupport", "isRelevant", "cfgId")

		for k,v in pairs(self.selectionedList) do
			local data
			for j = 1, #list do
				if list[j].id == v then
					if k == 1 then
						data = table.remove(list, j)
					else
						list[j].selected = k
					end
					break
				end
			end
			if k == 1 then
				if data then
					data.selected = 1
					data.isBattle = false
					table.insert(list, 1, data)
				else
					if not self.curPetData then
						self.curPetData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(v)
					end
					data = clone(self.curPetData)
					data.selected = 1
					data.isBattle = false
					table.insert(list, 1, data)
				end
			end
		end

		for k,v in pairs(list) do
			v.idx = k
		end
	end

	if list == nil then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NoCardTips3")
	end

	-- LogHRWarning(Inspect(list))
	return list
end

function UIPetAdvenceCtr:SendPetAdvence()
	local list = {}
	for k,v in pairs(self.selectionedList) do
		if k > 1 then
			list[#list + 1] = v
		end
	end
	ManagerContainer.DataMgr.PetDataMgr:SendPetAdvence(self.data, list)
end

function UIPetAdvenceCtr:GetPetDataById(id)
	if self.childCtr and self.childCtr.GetPetDataById then
		return self.childCtr:GetPetDataById(id)
	end
	return nil
end

function UIPetAdvenceCtr:WasSkillUp(petData)
	for _,v in pairs(petData.skillList) do
		if v.level > 1 then
			return true
		end
	end
	return false
end

function UIPetAdvenceCtr:IsAdvenceFree()
	local vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
	return vipCfg and vipCfg.PetAdvance >= 1
end

function UIPetAdvenceCtr:OnDispose()
	self.showDatas = nil
	self.selectionedList = nil
	self.childCtr = nil

	self.data = nil
	self.view = nil
end

return UIPetAdvenceCtr

